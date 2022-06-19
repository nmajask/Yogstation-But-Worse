//Programs that heal the host in some way.

/datum/nanite_program/regenerative
	name = "Accelerated Regeneration"
	desc = "The nanites boost the host's natural regeneration, increasing their healing speed. Does not consume nanites if the host is unharmed."
	use_rate = 2.5
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/regenerative/check_conditions()
	if(!host_mob.getBruteLoss() && !host_mob.getFireLoss())
		return FALSE
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE,TRUE, status = BODYPART_ORGANIC)
		if(!parts.len)
			return FALSE
	return ..()

/datum/nanite_program/regenerative/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE,TRUE, status = BODYPART_ORGANIC)
		if(!parts.len)
			return
		for(var/obj/item/bodypart/L in parts)
			if(L.heal_damage(1/parts.len, 1/parts.len, null, BODYPART_ORGANIC))
				host_mob.update_damage_overlays()
		if(C.getStaminaLoss() < 41) //Should just push you into the first slowdown stage before resetting after 10 seconds
			C.adjustStaminaLoss(1) //Annoying but not lethal, and won't stop stamina regen if you're over the limit
			if(prob(5))
				to_chat(C, "<span class='warning'>Your injuries itch and burn as they heal.")
	else
		host_mob.adjustBruteLoss(-1, TRUE)
		host_mob.adjustFireLoss(-1, TRUE)

/datum/nanite_program/temperature
	name = "Temperature Adjustment"
	desc = "The nanites adjust the host's internal temperature to an ideal level."
	use_rate = 3.5
	rogue_types = list(/datum/nanite_program/skin_decay)

/datum/nanite_program/temperature/check_conditions()
	if(host_mob.bodytemperature > (BODYTEMP_NORMAL - 30) && host_mob.bodytemperature < (BODYTEMP_NORMAL + 30))
		return FALSE
	return ..()

/datum/nanite_program/temperature/active_effect()
	if(host_mob.bodytemperature > BODYTEMP_NORMAL)
		host_mob.adjust_bodytemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	else if(host_mob.bodytemperature < (BODYTEMP_NORMAL + 1))
		host_mob.adjust_bodytemperature(40 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)

/datum/nanite_program/purging
	name = "Blood Purification"
	desc = "The nanites purge toxins and chemicals from the host's bloodstream."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/suffocating, /datum/nanite_program/necrotic)

/datum/nanite_program/purging/check_conditions()
	var/foreign_reagent = LAZYLEN(host_mob.reagents?.reagent_list)
	if(!host_mob.getToxLoss() && !foreign_reagent)
		return FALSE
	return ..()

/datum/nanite_program/purging/active_effect()
	host_mob.adjustToxLoss(-1)
	for(var/datum/reagent/R in host_mob.reagents?.reagent_list)
		host_mob.reagents.remove_reagent(R.type,1)

/datum/nanite_program/brain_heal
	name = "Neural Regeneration"
	desc = "The nanites fix neural connections in the host's brain, reversing brain damage and minor traumas."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/brain_decay)

/datum/nanite_program/brain_heal/check_conditions()
	if(!host_mob.getOrganLoss(ORGAN_SLOT_BRAIN) > 0)
		return FALSE
	return ..()

/datum/nanite_program/brain_heal/active_effect()
	host_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1)
	if(iscarbon(host_mob) && prob(10))
		var/mob/living/carbon/C = host_mob
		C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)

/datum/nanite_program/blood_restoring
	name = "Blood Regeneration"
	desc = "The nanites stimulate and boost blood cell production in the host."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/suffocating)

/datum/nanite_program/blood_restoring/check_conditions()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		if(C.blood_volume >= BLOOD_VOLUME_SAFE(C))
			return FALSE
	else
		return FALSE
	return ..()

/datum/nanite_program/blood_restoring/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		C.blood_volume += 2

/datum/nanite_program/repairing
	name = "Mechanical Repair"
	desc = "The nanites fix damage in the host's mechanical limbs."
	use_rate = 0.5 //much more efficient than organic healing
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/repairing/check_conditions()
	if(!host_mob.getBruteLoss() && !host_mob.getFireLoss())
		return FALSE

	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE, TRUE, status = BODYPART_ROBOTIC)
		if(!parts.len)
			return FALSE
	else
		if(!(MOB_ROBOTIC in host_mob.mob_biotypes))
			return FALSE
	return ..()

/datum/nanite_program/repairing/active_effect(mob/living/M)
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE, TRUE, status = BODYPART_ROBOTIC)
		if(!parts.len)
			return
		var/update = FALSE
		for(var/obj/item/bodypart/L in parts)
			if(L.heal_damage(1/parts.len, 1/parts.len, null, BODYPART_ROBOTIC))
				update = TRUE
		if(update)
			host_mob.update_damage_overlays()
	else
		host_mob.adjustBruteLoss(-1, TRUE)
		host_mob.adjustFireLoss(-1, TRUE)

/datum/nanite_program/purging_advanced
	name = "Selective Blood Purification"
	desc = "The nanites purge toxins and dangerous chemicals from the host's bloodstream, while ignoring beneficial chemicals. \
			The added processing power required to analyze the chemicals severely increases the nanite consumption rate."
	use_rate = 2
	rogue_types = list(/datum/nanite_program/suffocating, /datum/nanite_program/necrotic)

/datum/nanite_program/purging_advanced/check_conditions()
	var/foreign_reagent = FALSE
	for(var/datum/reagent/toxin/R in host_mob.reagents.reagent_list)
		foreign_reagent = TRUE
		break
	if(!host_mob.getToxLoss() && !foreign_reagent)
		return FALSE
	return ..()

/datum/nanite_program/purging_advanced/active_effect()
	host_mob.adjustToxLoss(-1)
	for(var/datum/reagent/toxin/R in host_mob.reagents.reagent_list)
		host_mob.reagents.remove_reagent(R.type,1)

/datum/nanite_program/regenerative_advanced
	name = "Bio-Reconstruction"
	desc = "The nanites manually repair and replace organic cells, acting much faster than normal regeneration. \
			However, this program cannot detect the difference between harmed and unharmed, causing it to consume nanites even if it has no effect."
	use_rate = 5.5
	rogue_types = list(/datum/nanite_program/suffocating, /datum/nanite_program/necrotic)

/datum/nanite_program/regenerative_advanced/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/list/parts = C.get_damaged_bodyparts(TRUE,TRUE, status = BODYPART_ORGANIC)
		if(!parts.len)
			return
		var/update = FALSE
		for(var/obj/item/bodypart/L in parts)
			if(L.heal_damage(3/parts.len, 3/parts.len, null, BODYPART_ORGANIC))
				update = TRUE
		if(update)
			host_mob.update_damage_overlays()
		if(C.getStaminaLoss() < 80) //Stops after hitting the second slowdown level.
			C.adjustStaminaLoss(5) //Hurts a lot more
		else if(C.getBruteLoss() || C.getFireLoss()) //Prevents stamina regen if it's actively healing and you're over the limit.
			C.adjustStaminaLoss(0.1) 
		if(prob(5))
			if(!C.getBruteLoss() && !C.getFireLoss())	
				to_chat(C, "<span class='warning'>You feel a searing pain across your body!")//Not actively healing, so nanites will start randomly replacing healthy tissue. Ouch!
			else
				to_chat(C, "<span class='warning'>Your wounds burn horribly as they heal!")
	else
		host_mob.adjustBruteLoss(-3, TRUE)
		host_mob.adjustFireLoss(-3, TRUE)

/datum/nanite_program/brain_heal_advanced
	name = "Neural Reimaging"
	desc = "The nanites are able to backup and restore the host's neural connections, potentially replacing entire chunks of missing or damaged brain matter."
	use_rate = 3
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)

/datum/nanite_program/brain_heal_advanced/check_conditions()
	if(!host_mob.getOrganLoss(ORGAN_SLOT_BRAIN) > 0)
		return FALSE
	return ..()

/datum/nanite_program/brain_heal_advanced/active_effect()
	host_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2)
	if(iscarbon(host_mob) && prob(10))
		var/mob/living/carbon/C = host_mob
		C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_LOBOTOMY)

/datum/nanite_program/triggered/defib
	name = "Defibrillation"
	desc = "The nanites shock the host's heart when triggered, bringing them back to life if the body can sustain it."
	trigger_cost = 25
	trigger_cooldown = 120
	rogue_types = list(/datum/nanite_program/triggered/shocking)

/datum/nanite_program/triggered/defib/trigger()
	if(!..())
		return

	host_mob.notify_ghost_cloning("Your heart is being defibrillated by nanites. Re-enter your corpse if you want to be revived!")
	addtimer(CALLBACK(src, .proc/zap), 50)

/datum/nanite_program/triggered/defib/proc/zap()
	var/mob/living/carbon/C = host_mob
	playsound(C, 'sound/machines/defib_charge.ogg', 50, 0)
	sleep(3 SECONDS)
	playsound(C, 'sound/machines/defib_zap.ogg', 50, 0)
	if(C.can_defib())
		playsound(C, 'sound/machines/defib_success.ogg', 50, 0)
		C.set_heartattack(FALSE)
		C.revive()
		C.emote("gasp")
		C.Jitter(10 SECONDS)
		SEND_SIGNAL(C, COMSIG_LIVING_MINOR_SHOCK)
	else
		playsound(C, 'sound/machines/defib_failed.ogg', 50, 0)

