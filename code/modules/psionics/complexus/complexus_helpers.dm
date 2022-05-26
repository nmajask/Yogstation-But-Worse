/datum/psi_complexus/proc/cancel()
	SEND_SOUND(owner, sound('sound/effects/psi/power_fail.ogg'))
	if(LAZYLEN(manifested_items))
		for(var/thing in manifested_items)
			owner.drop_from_inventory(thing)
			qdel(thing)
		manifested_items = null

/datum/psi_complexus/proc/stunned(var/amount)
	var/old_stun = stun
	stun = max(stun, amount)
	if(amount && !old_stun)
		to_chat(owner, "<span class='danger'>Your concentration has been shattered! You cannot focus your psi power!</span>")
		ui.update_icon()
	cancel()

/datum/psi_complexus/proc/get_armour(var/armourtype)
	if(can_use_passive())
		last_armor_check = world.time
		return round(clamp(clamp(4 * rating, 0, 20) * get_rank(SSpsi.armour_faculty_by_type[armourtype]), 0, 100) * (stamina/max_stamina))
	else
		last_armor_check = 0
		return 0

/datum/psi_complexus/proc/get_rank(var/faculty)
	return LAZYACCESS(ranks, faculty)

/datum/psi_complexus/proc/set_rank(var/faculty, var/rank, var/defer_update, var/temporary)
	if(get_rank(faculty) != rank)
		LAZYSET(ranks, faculty, rank)
		if(!temporary)
			LAZYSET(base_ranks, faculty, rank)
		if(!defer_update)
			update()

/datum/psi_complexus/proc/set_cooldown(var/value)
	next_power_use = world.time + value
	ui.update_icon()

/datum/psi_complexus/proc/can_use_passive()
	return (owner.stat == CONSCIOUS && !suppressed && !stun)

/datum/psi_complexus/proc/can_use(var/incapacitation_flags)
	return (owner.stat == CONSCIOUS &&  !suppressed && !stun && world.time >= next_power_use)

/datum/psi_complexus/proc/spend_power(var/value = 0, var/check_incapacitated)
	. = FALSE
	if(can_use())
		value = max(1, CEILING(value * cost_modifier, 1))
		if(value <= stamina)
			stamina -= value
			ui.update_icon()
			. = TRUE
		else
			backblast(abs(stamina - value))
			stamina = 0
			. = FALSE
		ui.update_icon()

/datum/psi_complexus/proc/hide_auras()
	if(owner.client)
		for(var/thing in SSpsi.all_aura_images)
			owner.client.images -= thing

/datum/psi_complexus/proc/show_auras()
	if(owner.client)
		for(var/image/I in SSpsi.all_aura_images)
			owner.client.images |= I

/datum/psi_complexus/proc/backblast(var/value)

	// Can't backblast if you're controlling your power.
	if(!owner || suppressed)
		return FALSE

	SEND_SOUND(owner, sound('sound/effects/psi/power_feedback.ogg'))
	to_chat(owner, "<span class='danger'><font size=3>Wild energistic feedback blasts across your psyche!</font></span>")
	stunned(value * 2)
	set_cooldown(value * 100)

	if(prob(value*10)) owner.emote("scream")

	// Your head asplode.
	owner.adjustBrainLoss(value)
	owner.adjustHalLoss(value * 25) //Ouch.
	if(ishuman(owner))
		var/mob/living/carbon/human/pop = owner
		var/obj/item/organ/internal/brain/sponge = pop.internal_organs_by_name[ORGAN_SLOT_BRAIN]
		if(sponge && sponge.damage >= sponge.max_damage)
			pop.ghostize()
			sponge.Remove(sponge)
			qdel(sponge)

			/* Need to fix this later
			var/obj/item/organ/external/affecting = pop.get_organ(sponge.parent_organ)
			if(affecting && !affecting.is_stump())
				affecting.droplimb(0, DROPLIMB_BLUNT)
				if(sponge) qdel(sponge)
			*/

/datum/psi_complexus/proc/reset()
	aura_color = initial(aura_color)
	ranks = base_ranks ? base_ranks.Copy() : null
	max_stamina = initial(max_stamina)
	stamina = min(stamina, max_stamina)
	cancel()
	update()
