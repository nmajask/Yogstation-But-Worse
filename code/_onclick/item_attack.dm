
/obj/item/proc/melee_attack_chain(mob/user, atom/target, params)
	if(!tool_attack_chain(user, target) && pre_attack(target, user, params))
		// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
		var/resolved = target.attackby(src, user, params)
		if(!resolved && target && !QDELETED(src))
			afterattack(target, user, 1, params) // 1: clicking something Adjacent
	SSdemo.mark_dirty(src)
	if(isturf(target))
		SSdemo.mark_turf(target)
	else
		SSdemo.mark_dirty(target)

//Checks if the item can work as a tool, calling the appropriate tool behavior on the target
/obj/item/proc/tool_attack_chain(mob/user, atom/target)
	if(!tool_behaviour)
		return FALSE

	return target.tool_act(user, src, tool_behaviour)


// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	if(HAS_TRAIT(user, TRAIT_NOINTERACT)) //sorry no using grenades
		to_chat(user, span_notice("You can't use things!"))
		return
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_NO_INTERACT)
		return
	interact(user)
	SSdemo.mark_dirty(src)

/obj/item/proc/pre_attack(atom/A, mob/living/user, params) //do stuff before attackby!
	if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, params) & COMPONENT_NO_ATTACK)
		return FALSE
	return TRUE //return FALSE to avoid calling attackby after this proc does stuff

// No comment
/atom/proc/attackby(obj/item/W, mob/user, params)
	if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, W, user, params) & COMPONENT_NO_AFTERATTACK)
		return TRUE
	return FALSE

/obj/attackby(obj/item/I, mob/living/user, params)
	return ..() || ((obj_flags & CAN_BE_HIT) && I.attack_obj(src, user))

/mob/living/attackby(obj/item/I, mob/living/user, params)
	for(var/datum/surgery/S in surgeries)
		if(!(mobility_flags & MOBILITY_STAND) || !S.lying_required)
			if((S.self_operable || user != src) && (user.a_intent == INTENT_HELP || user.a_intent == INTENT_DISARM))
				if(S.next_step(user,user.a_intent))
					return TRUE
	var/dist = get_dist(src,user)
	if(..())
		return TRUE
	user.changeNext_move(CLICK_CD_MELEE * I.weapon_stats[SWING_SPEED] * (I.range_cooldown_mod ? (dist > 0 ? min(dist, I.weapon_stats[REACH]) * I.range_cooldown_mod : I.range_cooldown_mod) : 1)) //range increases attack cooldown by swing speed
	user.weapon_slow(I)
	if(user.a_intent == INTENT_HARM && stat == DEAD && (butcher_results || guaranteed_butcher_results)) //can we butcher it?
		var/datum/component/butchering/butchering = I.GetComponent(/datum/component/butchering)
		if(butchering && butchering.butchering_enabled)
			to_chat(user, span_notice("You begin to butcher [src]..."))
			playsound(loc, butchering.butcher_sound, 50, TRUE, -1)
			if(do_mob(user, src, butchering.speed) && Adjacent(I))
				butchering.Butcher(user, src)
			return 1
		else if(I.is_sharp() && !butchering) //give sharp objects butchering functionality, for consistency
			I.AddComponent(/datum/component/butchering, 80 * I.toolspeed)
			attackby(I, user, params) //call the attackby again to refresh and do the butchering check again
			return
	return I.attack(src, user)


/obj/item/proc/attack(mob/living/M, mob/living/user)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user)
	if(item_flags & NOBLUDGEON)
		return

	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to harm other living beings!"))
		return TRUE

	if((item_flags & SURGICAL_TOOL) && (user.a_intent != INTENT_HARM)) // checks for if harm intent with surgery tool
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			for(var/i in C.all_wounds)
				var/datum/wound/W = i
				if(W.try_treating(src, user))
					return TRUE
		to_chat(user, span_warning("You aren't doing surgery!")) //yells at you
		return TRUE

	if(!force)
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), 1, -1)
	else if(hitsound)
		playsound(loc, hitsound, get_clamped_volume(), 1, -1)

	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey

	if(force)
		M.last_damage = name

	user.do_attack_animation(M)
	M.attacked_by(src, user)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	add_fingerprint(user)

	take_damage(rand(weapon_stats[DAMAGE_LOW], weapon_stats[DAMAGE_HIGH]), sound_effect = FALSE)

//the equivalent of the standard version of attack() but for object targets.
/obj/item/proc/attack_obj(obj/O, mob/living/user)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_OBJ, O, user) & COMPONENT_NO_ATTACK_OBJ)
		return
	if(item_flags & NOBLUDGEON)
		return
	var/dist = get_dist(O,user)
	user.changeNext_move(CLICK_CD_MELEE * weapon_stats[SWING_SPEED] * (range_cooldown_mod ? (dist > 0 ? min(dist, weapon_stats[REACH]) * range_cooldown_mod : range_cooldown_mod) : 1)) //range increases attack cooldown by swing speed
	user.do_attack_animation(O)
	O.attacked_by(src, user)
	user.weapon_slow(src)
	take_damage(rand(weapon_stats[DAMAGE_LOW], weapon_stats[DAMAGE_HIGH]), sound_effect = FALSE)

/atom/movable/proc/attacked_by()
	return

/obj/attacked_by(obj/item/I, mob/living/user)
	if(I.force)
		visible_message(span_danger("[user] has hit [src] with [I]!"), null, null, COMBAT_MESSAGE_RANGE)
		//only witnesses close by and the victim see a hit message.
		log_combat(user, src, "attacked", I)
	take_damage(I.force, I.damtype, MELEE, 1)

/mob/living/attacked_by(obj/item/I, mob/living/user)
	send_item_attack_message(I, user)
	if(I.force)
		apply_damage(I.force, I.damtype)
		if(I.damtype == BRUTE)
			if(prob(33))
				I.add_mob_blood(src)
				var/turf/location = get_turf(src)
				add_splatter_floor(location)
				if(get_dist(user, src) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(src)
		return TRUE //successful attack

/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user)
	if(I.force < force_threshold || I.damtype == STAMINA)
		playsound(loc, 'sound/weapons/tap.ogg', I.get_clamped_volume(), 1, -1)
	else
		return ..()

/mob/living/proc/weapon_slow(obj/item/I)
	add_movespeed_modifier(I.name, priority = 101, multiplicative_slowdown = I.weapon_stats[ENCUMBRANCE])
	addtimer(CALLBACK(src, .proc/remove_movespeed_modifier, I.name), I.weapon_stats[ENCUMBRANCE_TIME], TIMER_UNIQUE|TIMER_OVERRIDE)

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)


/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return clamp((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return clamp(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/mob/living/proc/send_item_attack_message(obj/item/I, mob/living/user, hit_area, obj/item/bodypart/hit_bodypart)
	var/message_verb = "attacked"
	if(length(I.attack_verb))
		message_verb = "[pick(I.attack_verb)]"
	else if(!I.force)
		return
	var/message_hit_area = ""
	if(hit_area)
		message_hit_area = " in the [hit_area]"
	var/attack_message = "[src] has been [message_verb][message_hit_area] with [I]."
	if(user in viewers(src, null))
		attack_message = "[user] has [message_verb] [src][message_hit_area] with [I]!"
	visible_message(span_danger("[attack_message]"),\
		span_userdanger("[attack_message]"), null, COMBAT_MESSAGE_RANGE)
	return 1
