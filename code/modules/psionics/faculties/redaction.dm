/datum/psionic_faculty/redaction
	id = PSI_REDACTION
	name = "Redaction"
	associated_intent = INTENT_HELP
	armour_types = list(BIO, RAD)

/datum/psionic_power/redaction
	faculty = PSI_REDACTION
	admin_log = FALSE

/datum/psionic_power/redaction/proc/check_dead(var/mob/living/target)
	if(!istype(target))
		return FALSE
	if(target.stat == DEAD || HAS_TRAIT(target, TRAIT_FAKEDEATH))
		return TRUE
	return FALSE

/datum/psionic_power/redaction/invoke(var/mob/living/user, var/mob/living/target)
	if(check_dead(target))
		return FALSE
	. = ..()

/datum/psionic_power/redaction/skinsight
	name =            "Skinsight"
	cost =            3
	heat =            1
	cooldown =        3 SECONDS
	use_melee =      TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Grab a patient, target the chest, then switch to help intent and use the grab on them to perform a health scan."

/datum/psionic_power/redaction/skinsight/invoke(var/mob/living/user, var/mob/living/target)
	if(!istype(target) || user.zone_selected != BODY_ZONE_CHEST || target.pulledby == user)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(span_notice("\The [user] rests a hand on \the [target]."))
		healthscan(user, target, user.psi.get_rank(PSI_REDACTION) >= PSI_RANK_GRANDMASTER)
		return TRUE

/datum/psionic_power/redaction/mend
	name =            "Mend"
	cost =            7
	heat =            10
	cooldown =        5 SECONDS
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Target a patient while on help intent at melee range to mend a variety of maladies, such as bleeding or broken bones. Higher ranks in this faculty allow you to mend a wider range of problems."

/datum/psionic_power/redaction/mend/invoke(var/mob/living/user, var/mob/living/carbon/human/target)
	if(!istype(user) || !istype(target) || target.pulledby != user || user.grab_state >= GRAB_AGGRESSIVE)
		return FALSE
	. = ..()
	if(.)
		var/obj/item/bodypart/E = target.get_bodypart(user.zone_selected)

		if(!E)
			to_chat(user, span_warning("They are missing that limb."))
			return TRUE

		if(E.status == BODYPART_ROBOTIC)
			to_chat(user, span_warning("That limb is prosthetic."))
			return TRUE

		user.visible_message(span_notice("<i>\The [user] rests a hand on \the [target]'s [E.name]...</i>"))
		to_chat(target, span_notice("A healing warmth suffuses you."))

		var/redaction_rank = user.psi.get_rank(PSI_REDACTION)
		var/pk_rank = user.psi.get_rank(PSI_PSYCHOKINESIS)

		if(pk_rank >= PSI_RANK_LATENT && redaction_rank >= PSI_RANK_MASTER)
			var/removal_size = clamp(5-pk_rank, 0, 5)
			var/valid_objects = list()
			for(var/obj/item/thing in E.embedded_objects)
				if(thing.w_class >= removal_size)
					valid_objects += thing
			if(LAZYLEN(valid_objects))
				var/removing = pick(valid_objects)
				target.remove_embedded_object(removing)
				to_chat(user, span_notice("You extend a tendril of psychokinetic-redactive power and carefully tease \the [removing] free of \the [E]."))
				return TRUE

		if(redaction_rank >= PSI_RANK_GRANDMASTER)
			for(var/obj/item/organ/O in target.internal_organs)
				if(O.damage > 0)
					to_chat(user, span_notice("You encourage the damaged tissue of \the [O] to repair itself."))
					O.applyOrganDamage(-rand(redaction_rank, redaction_rank * 2))
					return TRUE
		if(E.get_damage(TRUE))
			E.heal_damage((redaction_rank * 10), (redaction_rank * 10))
			to_chat(user, span_notice("You patch up some of the damage to [target]'s [E]."))
			new /obj/effect/temp_visual/heal(get_turf(target), "#33cc33")
			return TRUE

		to_chat(user, span_notice("You can find nothing within \the [target]'s [E.name] to mend."))
		return FALSE

/datum/psionic_power/redaction/cleanse
	name =            "Cleanse"
	cost =            9
	heat =            15
	cooldown =        6 SECONDS
	use_melee =       TRUE
	min_rank =        PSI_RANK_GRANDMASTER
	use_description = "Target a patient while on help intent at melee range to cleanse radiation and genetic damage from a patient."

/datum/psionic_power/redaction/cleanse/invoke(var/mob/living/user, var/mob/living/carbon/human/target)
	if(!istype(user) || !istype(target) || target.pulledby != user || user.zone_selected != BODY_ZONE_PRECISE_MOUTH)
		return FALSE
	. = ..()
	if(.)
		// No messages, as Mend procs them even if it fails to heal anything, and Cleanse is always checked after Mend.
		var/removing = rand(20,25)
		if(target.radiation)
			to_chat(user, span_notice("You repair some of the radiation-damaged tissue within \the [target]..."))
			if(target.radiation > removing)
				target.radiation -= removing
			else
				target.radiation = 0
			return TRUE
		if(target.getCloneLoss())
			to_chat(user, span_notice("You stitch together some of the mangled DNA within \the [target]..."))
			if(target.getCloneLoss() >= removing)
				target.adjustCloneLoss(-removing)
			else
				target.adjustCloneLoss(-(target.getCloneLoss()))
			return TRUE
		to_chat(user, span_notice("You can find no genetic damage or radiation to heal within \the [target]."))
		return TRUE

/datum/psionic_power/revive
	name =            "Revive"
	cost =            25
	heat =            100
	cooldown =        8 SECONDS
	use_melee =      TRUE
	min_rank =        PSI_RANK_PARAMOUNT
	faculty =         PSI_REDACTION
	use_description = "Obtain a grab on a dead target, target the head, then select help intent and use the grab against them to attempt to bring them back to life. The process is lengthy and failure is punished harshly."
	admin_log = FALSE

/datum/psionic_power/revive/invoke(var/mob/living/user, var/mob/living/target)
	if(!isliving(target) || !istype(target) || user.zone_selected != BODY_ZONE_PRECISE_EYES || target.pulledby != user || user.grab_state < GRAB_AGGRESSIVE)
		return FALSE
	. = ..()
	if(.)
		if(target.stat != DEAD && !HAS_TRAIT(target, TRAIT_FAKEDEATH))
			to_chat(user, span_warning("This person is already alive!"))
			return TRUE

		if(((world.time - target.timeofdeath) > DEFIB_TIME_LIMIT))
			to_chat(user, span_warning("\The [target] has been dead for too long to revive."))
			return TRUE

		user.visible_message(span_notice("<i>\The [user] splays out their hands over \the [target]'s body...</i>"))
		target.notify_ghost_cloning("Your heart is being revived!")
		target.grab_ghost()
		if(!do_after(user, 10 SECONDS, target, FALSE))
			user.psi.backblast(rand(10,25))
			return TRUE
			
		to_chat(target, span_notice("Life floods back into your body!"))
		target.visible_message(span_notice("\The [target] shudders violently!"))
		target.adjustOxyLoss(-rand(15,20))
		target.revive()
		return TRUE
