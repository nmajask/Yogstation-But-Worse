/datum/reagent/crystal
	name = "crystallizing agent"
	taste_description = "sharpness"
	reagent_state = LIQUID
	color = "#13bc5e"
/*
/datum/reagent/crystal/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/result_mat = (M.psi || (M.mind && GLOB.wizards.is_antagonist(M.mind))) ? MATERIAL_NULLGLASS : MATERIAL_CRYSTAL
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(5))
			var/obj/item/organ/external/E = pick(H.organs)
			if(!E || E.is_stump() || BP_IS_ROBOTIC(E))
				return
			if(BP_IS_CRYSTAL(E))
				E.heal_damage(rand(3,5), rand(3,5))
				if(BP_IS_BRITTLE(E) && prob(5))
					E.status &= ~ORGAN_BRITTLE
			else if(E.organ_tag != BP_CHEST && E.organ_tag != BP_GROIN)
				to_chat(H, SPAN_DANGER("Your [E.name] is being lacerated from within!"))
				if(H.can_feel_pain())
					H.emote("scream")
				if(prob(25))
					for(var/i = 1 to rand(3,5))
						new /obj/item/weapon/material/shard(get_turf(E), result_mat)
					E.droplimb(0, DROPLIMB_BLUNT)
				else
					E.take_external_damage(rand(20,30), 0)
					E.status |= ORGAN_CRYSTAL
					E.status |= ORGAN_BRITTLE
			return

	to_chat(M, SPAN_DANGER("Your flesh is being lacerated from within!"))
	M.adjustBruteLoss(rand(3,6))
	if(prob(10))
		new /obj/item/weapon/material/shard(get_turf(M), result_mat)
*/
