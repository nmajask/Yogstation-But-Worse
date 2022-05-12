/obj/item/gun/ballistic/bow
	name = "wooden bow"
	desc = "some sort of primitive projectile weapon. used to fire arrows."
	icon_state = "bow"
	item_state = "bow"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY //need both hands to fire
	force = 5
	mag_type = /obj/item/ammo_box/magazine/internal/bow
	fire_sound = 'sound/weapons/sound_weapons_bowfire.ogg'
	slot_flags = ITEM_SLOT_BACK
	item_flags = NEEDS_PERMIT
	casing_ejector = FALSE
	internal_magazine = TRUE
	pin = null
	no_pin_required = TRUE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL //so ashwalkers can use it

	var/draw_time = 1 SECONDS
	var/draw_slowdown = 1 SECONDS
	var/mutable_appearance/arrow_overlay

/obj/item/gun/ballistic/bow/shoot_with_empty_chamber()
	return

/obj/item/gun/ballistic/bow/chamber_round()
	chambered = magazine.get_round(1)
	update_icon()

/obj/item/gun/ballistic/bow/process_chamber()
	chambered = null
	magazine.get_round(0)
	update_slowdown()
	update_icon()

/obj/item/gun/ballistic/bow/attack_self(mob/living/user)
	if(chambered)
		var/obj/item/ammo_casing/AC = magazine.get_round(0)
		user.put_in_hands(AC)
		chambered = null
		to_chat(user, span_notice("You gently release the bowstring, removing the arrow."))
	else if(get_ammo())
		var/obj/item/I = user.get_active_held_item()
		if (do_mob(user, I, draw_time))
			to_chat(user, span_notice("You draw back the bowstring."))
			playsound(src, 'sound/weapons/sound_weapons_bowdraw.ogg', 75, 0) //gets way too high pitched if the freq varies
			chamber_round()
	update_slowdown()
	update_icon()

/obj/item/gun/ballistic/bow/attackby(obj/item/I, mob/user, params)
	if (magazine.attackby(I, user, params, 1))
		to_chat(user, span_notice("You notch the arrow."))
	update_slowdown()
	update_icon()

/obj/item/gun/ballistic/bow/update_icon()
	cut_overlay(arrow_overlay, TRUE)
	icon_state = "[initial(icon_state)][chambered ? "_firing" : ""]"
	if(get_ammo())
		var/obj/item/ammo_casing/caseless/arrow/energy/E = magazine.get_round(TRUE)
		arrow_overlay = mutable_appearance(icon, "[initial(E.icon_state)][chambered ? "_firing" : ""]")
		add_overlay(arrow_overlay, TRUE)

/obj/item/gun/ballistic/bow/proc/update_slowdown()
	if(chambered)
		slowdown = draw_slowdown
	else
		slowdown = initial(slowdown)

/obj/item/gun/ballistic/bow/can_shoot()
	return chambered

/obj/item/gun/ballistic/bow/ashen
	name = "Bone Bow"
	desc = "Some sort of primitive projectile weapon made of bone and wrapped sinew."
	icon_state = "ashenbow"
	item_state = "ashenbow"
	force = 8

/obj/item/gun/ballistic/bow/pipe
	name = "Pipe Bow"
	desc = "A crude projectile weapon made from silk string, pipe and lots of bending."
	icon_state = "pipebow"
	item_state = "pipebow"
	force = 7

/obj/item/gun/ballistic/bow/energy
	name = "Hardlight Bow"
	desc = "A modern bow that can fabricate hardlight arrows using internal energy."
	icon_state = "bow_hardlight"
	mag_type = /obj/item/ammo_box/magazine/internal/bow/energy
	var/recharge_time = 1.5 SECONDS

/obj/item/gun/ballistic/bow/energy/update_icon()
	cut_overlay(arrow_overlay, TRUE)
	if(get_ammo())
		var/obj/item/ammo_casing/caseless/arrow/energy/E = magazine.get_round(TRUE)
		arrow_overlay = mutable_appearance(icon, "[initial(E.icon_state)][chambered ? "_firing" : ""]")
		add_overlay(arrow_overlay, TRUE)

/obj/item/gun/ballistic/bow/energy/shoot_live_shot(mob/living/user, pointblank, atom/pbtarget, message)
	. = ..()
	if(recharge_time)
		TIMER_COOLDOWN_START(src, "arrow_recharge", recharge_time)

/obj/item/gun/ballistic/bow/energy/proc/end_cooldown(source, index)
	playsound(src, 'sound/effects/sparks4.ogg', 25, 0)

/obj/item/gun/ballistic/bow/energy/attack_self(mob/living/user)
	to_chat(user, magazine.get_round(TRUE))
	if(chambered)
		chambered = null
		to_chat(user, span_notice("You disperse the arrow."))
	else if(magazine.get_round(TRUE))
		var/obj/item/I = user.get_active_held_item()
		if (do_mob(user, I, draw_time))
			to_chat(user, span_notice("You draw back the bowstring."))
			playsound(src, 'sound/weapons/sound_weapons_bowdraw.ogg', 75, 0) //gets way too high pitched if the freq varies
			chamber_round()
	else if(!recharge_time || !TIMER_COOLDOWN_CHECK(src, "arrow_recharge"))
		to_chat(user, span_notice("You fabricate an arrow."))
		recharge_bolt()
	else
		to_chat(user, span_warning("\the [src] is still recharing!"))
	update_icon()

/obj/item/gun/ballistic/bow/energy/proc/recharge_bolt()
	if(magazine.get_round(TRUE))
		return
	var/ammo_type = magazine.ammo_type
	magazine.give_round(new ammo_type())

	update_icon()

/obj/item/gun/ballistic/bow/energy/attackby(obj/item/I, mob/user, params)
	return

/obj/item/gun/ballistic/bow/energy/AltClick(mob/living/user)
	select_projectile(user)
	var/current_round = magazine.get_round(TRUE)
	if(current_round)
		QDEL_NULL(current_round)
	if(!TIMER_COOLDOWN_CHECK(src, "arrow_recharge"))
		recharge_bolt()
	update_icon()

/obj/item/gun/ballistic/bow/energy/proc/select_projectile(mob/living/user)
	var/obj/item/ammo_box/magazine/internal/bow/energy/M = magazine
	if(!istype(M) || !M.selectable_types)
		return
	var/list/selectable_types = M.selectable_types

	if(selectable_types.len == 1)
		M.ammo_type = selectable_types[1]
		to_chat(user, span_notice("\The [src] doesn't have any other firing modes."))
		update_icon()
		return

	if(selectable_types.len == 2)
		selectable_types = selectable_types - M.ammo_type
		M.ammo_type = selectable_types[1]
		to_chat(user, span_notice("You switch \the [src]'s firing mode."))
		update_icon()
		return

	var/list/choice_list = list()
	for(var/arrow_type in M.selectable_types)
		var/obj/item/ammo_casing/caseless/arrow/energy/arrow = new arrow_type()
		choice_list[arrow] = image(arrow)
	var/obj/item/ammo_casing/caseless/arrow/energy/choice = show_radial_menu(user, user, choice_list, tooltips = TRUE)
	if(!choice || (choice.type in M.selectable_types))
		return
	M.ammo_type = choice.type
	to_chat(user, span_notice("You switch \the [src]'s firing mode to \"[choice]\"."))
	for(var/arrow in choice_list)
		QDEL_NULL(choice_list[arrow])
		QDEL_NULL(arrow)
	QDEL_NULL(choice_list)
	update_icon()

/obj/item/gun/ballistic/bow/energy/advanced
	name = "Advanced Hardlight Bow"
	mag_type = /obj/item/ammo_box/magazine/internal/bow/energy/advanced
	recharge_time = 0

/obj/item/gun/ballistic/bow/energy/syndicate
	name = "Syndicate Hardlight Bow"
	desc = "A modern bow that can fabricate hardlight arrows using internal energy. This one is designed by the Syndicate for silent takedowns."
	icon_state = "bow_syndicate"
	mag_type = /obj/item/ammo_box/magazine/internal/bow/energy/syndicate
	recharge_time = 2 SECONDS
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 5

/obj/item/gun/ballistic/bow/energy/clockwork
	name = "Brass Bow"
	desc = "A bow made from brass and other components that you can't quite understand. It glows with a deep energy and frabricates arrows by itself."
	icon_state = "bow_clockwork"
	mag_type = /obj/item/ammo_box/magazine/internal/bow/energy/clockcult
