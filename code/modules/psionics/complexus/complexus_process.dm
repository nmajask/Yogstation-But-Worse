/datum/psi_complexus/proc/update(force)

	set waitfor = FALSE

	var/last_rating = rating
	var/highest_faculty
	var/highest_rank = 0
	var/combined_rank = 0
	for(var/faculty in ranks)
		var/check_rank = get_rank(faculty)
		if(check_rank == 1)
			LAZYADD(latencies, faculty)
		else
			if(check_rank <= 0)
				ranks -= faculty
			LAZYREMOVE(latencies, faculty)
		combined_rank += check_rank
		if(!highest_faculty || highest_rank < check_rank)
			highest_faculty = faculty
			highest_rank = check_rank

	UNSETEMPTY(latencies)
	var/rank_count = max(1, LAZYLEN(ranks))
	if(force || last_rating != CEILING(combined_rank/rank_count, 1))
		if(highest_rank <= 1)
			if(highest_rank == 0)
				qdel(src)
			return
		rebuild_power_cache = TRUE
		SEND_SOUND(owner, 'sound/effects/psi/power_unlock.ogg')
		rating = CEILING(combined_rank/rank_count, 1)
		cost_modifier = 1
		if(rating > 1)
			cost_modifier -= min(1, max(0.1, (rating-1) / 10))
		if(!ui)
			ui = new(owner)
		if(owner.client)
			owner.client.screen += ui.components
			owner.client.screen += ui
		if(!suppressed && owner.client)
			for(var/image/I in SSpsi.all_aura_images)
				owner.client.images |= I
		var/image/aura_image = get_aura_image()
		/*
		if(rating >= PSI_RANK_PARAMOUNT) // spooky boosters
			aura_color = "#aaffaa"
			aura_image.blend_mode = BLEND_SUBTRACT
		else
		*/
		aura_image.blend_mode = BLEND_ADD
		switch(highest_faculty)
			if(PSI_COERCION)
				aura_color = "#cc3333"
			if(PSI_PSYCHOKINESIS)
				aura_color = "#3333cc"
			if(PSI_REDACTION)
				aura_color = "#33cc33"
			if(PSI_ENERGISTICS)
				aura_color = "#cccc33"

	if(!announced && owner?.client && !QDELETED(src))
		announced = TRUE
		to_chat(owner, "<hr>")
		to_chat(owner, span_notice("<font size = 3>You are <b>psionic</b>, touched by powers beyond understanding.</font>"))
		to_chat(owner, span_notice("<b>Shift-left-click your Psi icon</b> on the bottom right to <b>view a summary of how to use them</b>, or <b>left click</b> it to <b>suppress or unsuppress</b> your psionics. Beware: overusing your gifts can have <b>deadly consequences</b>."))
		to_chat(owner, "<hr>")

/datum/psi_complexus/process()

	var/update_hud
	if(stun)
		stun--
		if(stun)
			suppressed = TRUE
		else
			to_chat(owner, span_notice("You have recovered your mental composure."))
		update_hud = TRUE
		return

	if(stamina < max_stamina)
		adjust_stamina((owner.stat == CONSCIOUS ? rand(1,3) : rand(3,5)) * stamina_recharge_mult)

	if(heat)
		adjust_heat(((owner.stat == CONSCIOUS ? -1 : -3)) * heat_decay_mult)

	if(owner.stat == CONSCIOUS && stamina && use_autoredaction && !suppressed && get_rank(PSI_REDACTION) >= PSI_RANK_OPERANT)
		attempt_regeneration()

	var/next_aura_size = max(0.1,((stamina/max_stamina)*min(3,rating))/5)
	var/next_aura_alpha = round(((suppressed ? max(0,rating - 2) : rating)/5)*255)

	if(next_aura_alpha != last_aura_alpha || next_aura_size != last_aura_size || aura_color != last_aura_color)
		last_aura_size =  next_aura_size
		last_aura_alpha = next_aura_alpha
		last_aura_color = aura_color
		var/matrix/M = matrix()
		if(next_aura_size != 1)
			M.Scale(next_aura_size)
		animate(get_aura_image(), alpha = next_aura_alpha, transform = M, color = aura_color, time = 3)

	if(update_hud)
		ui.update_icon()

/datum/psi_complexus/proc/attempt_regeneration()

	var/heal_general =  FALSE
	var/heal_poison =   FALSE
	var/heal_internal = FALSE
//	var/heal_bleeding = FALSE
	var/heal_rate =     0
	var/mend_prob =     0

	switch(get_rank(PSI_REDACTION))
		if(PSI_RANK_PARAMOUNT)
			heal_general = TRUE
			heal_poison = TRUE
			heal_internal = TRUE
	//		heal_bleeding = TRUE
			mend_prob = 50
			heal_rate = 7
		if(PSI_RANK_GRANDMASTER)
			heal_poison = TRUE
			heal_internal = TRUE
	//		heal_bleeding = TRUE
			mend_prob = 20
			heal_rate = 5
		if(PSI_RANK_MASTER)
			heal_internal = TRUE
	//		heal_bleeding = TRUE
			mend_prob = 10
			heal_rate = 3
		if(PSI_RANK_OPERANT)
	//		heal_bleeding = TRUE
			mend_prob = 5
			heal_rate = 1
		else
			return

	if(!heal_rate || stamina < heal_rate)
		return // Don't backblast from trying to heal ourselves thanks.

	if(ishuman(owner))

		var/mob/living/carbon/human/H = owner

		// Mend internal damage.
		if(prob(mend_prob))
/*
			// Fix our heart if we're paramount.
			if(heal_general && H.is_asystole() && spend_power(heal_rate))
				H.resuscitate()
*/
			// Heal organ damage.
			if(heal_internal)
				for(var/obj/item/organ/I in H.internal_organs)

					if(I.organ_flags & ORGAN_SYNTHETIC)
						continue

					if(I.damage > 0 && spend_power(heal_rate))
						I.applyOrganDamage(-heal_rate)
						if(prob(25))
							to_chat(H, span_notice("Your innards itch as your autoredactive faculty mends your [I.name]."))
						return
			/* To fix
			// Heal broken bones.
			if(H.bad_external_organs.len)
				for(var/obj/item/organ/external/E in H.bad_external_organs)

					if(BP_IS_ROBOTIC(E))
						continue

					if(heal_internal && (E.status & ORGAN_BROKEN) && E.damage < (E.min_broken_damage * config.organ_health_multiplier)) // So we don't mend and autobreak.
						if(spend_power(heal_rate))
							if(E.mend_fracture())
								to_chat(H, span_notice("Your autoredactive faculty coaxes together the shattered bones in your [E.name]."))
								return

					if(heal_bleeding)

						if((E.status & ORGAN_ARTERY_CUT) && spend_power(heal_rate))
							to_chat(H, span_notice("Your autoredactive faculty mends the torn artery in your [E.name], stemming the worst of the bleeding."))
							E.status &= ~ORGAN_ARTERY_CUT
							return

						if(E.status & ORGAN_TENDON_CUT)
							to_chat(H, span_notice("Your autoredactive faculty repairs the severed tendon in your [E.name]."))
							E.status &= ~ORGAN_TENDON_CUT
							return TRUE

						for(var/datum/wound/W in E.wounds)

							if(W.bleeding() && spend_power(heal_rate))
								to_chat(H, span_notice("Your autoredactive faculty knits together severed veins, stemming the bleeding from \a [W.desc] on your [E.name]."))
								W.bleed_timer = 0
								W.clamped = TRUE
								E.status &= ~ORGAN_BLEEDING
								return
			*/


	// Heal radiation, cloneloss and poisoning.
	if(heal_poison)

		if(owner.radiation && spend_power(heal_rate))
			if(prob(25))
				to_chat(owner, span_notice("Your autoredactive faculty repairs some of the radiation damage to your body."))
			owner.radiation = max(0, owner.radiation - (heal_rate * 5))
			return

		if(owner.getCloneLoss() && spend_power(heal_rate))
			if(prob(25))
				to_chat(owner, span_notice("Your autoredactive faculty stitches together some of your mangled DNA."))
			owner.adjustCloneLoss(-heal_rate)
			return

	// Heal everything left.
	if(heal_general && prob(mend_prob) && (owner.getBruteLoss() || owner.getFireLoss() || owner.getOxyLoss()) && spend_power(heal_rate))
		owner.adjustBruteLoss(-(heal_rate))
		owner.adjustFireLoss(-(heal_rate))
		owner.adjustOxyLoss(-(heal_rate))
		new /obj/effect/temp_visual/heal(get_turf(owner), "#33cc33")
		if(prob(25))
			to_chat(owner, span_notice("Your skin crawls as your autoredactive faculty heals your body."))
