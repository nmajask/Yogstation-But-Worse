/datum/surgery/lipoplasty
	name = "Lipoplasty"
	desc = "Removes excess fat from the patient."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "meat"
	steps = list(/datum/surgery_step/incise, 
				/datum/surgery_step/clamp_bleeders, 
				/datum/surgery_step/cut_fat, 
				/datum/surgery_step/remove_fat, 
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/lipoplasty/can_start(mob/user, mob/living/carbon/target)
	if(HAS_TRAIT(target, TRAIT_FAT))
		return TRUE
	return FALSE

/datum/surgery/lipoplasty/mechanic
	steps = list(/datum/surgery_step/mechanic_open,
				/datum/surgery_step/open_hatch, 
				/datum/surgery_step/cut_fat, 
				/datum/surgery_step/remove_fat, 
				/datum/surgery_step/mechanic_close)
	requires_bodypart_type = BODYPART_ROBOTIC
	lying_required = FALSE
	self_operable = TRUE

//cut fat
/datum/surgery_step/cut_fat
	name = "cut excess fat"
	implements = list(TOOL_SAW = 100, /obj/item/hatchet = 35, /obj/item/kitchen/knife/butcher = 25)
	time = 6.4 SECONDS

/datum/surgery_step/cut_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to cut away [target]'s excess fat.", span_notice("You begin to cut away [target]'s excess fat..."))
	display_results(user, target, span_notice("You begin to cut away [target]'s excess fat..."),
			"[user] begins to cut away [target]'s excess fat.",
			"[user] begins to cut [target]'s [target_zone] with [tool].")

/datum/surgery_step/cut_fat/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You cut [target]'s excess fat loose."),
			"[user] cuts [target]'s excess fat loose!",
			"[user] finishes the cut on [target]'s [target_zone].")
	return TRUE

//remove fat
/datum/surgery_step/remove_fat
	name = "remove loose fat"
	implements = list(/obj/item/retractor = 100, TOOL_SCREWDRIVER = 45, TOOL_WIRECUTTER = 35)
	time = 3.2 SECONDS

/datum/surgery_step/remove_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to extract [target]'s loose fat..."),
			"[user] begins to extract [target]'s loose fat!",
			"[user] begins to extract something from [target]'s [target_zone].")

/datum/surgery_step/remove_fat/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You extract [target]'s fat."),
			"[user] extracts [target]'s fat!",
			"[user] extracts [target]'s fat!")
	target.overeatduration = 0 //patient is unfatted
	var/removednutriment = target.nutrition
	target.set_nutrition(NUTRITION_LEVEL_WELL_FED)
	removednutriment -= 450 //whatever was removed goes into the meat
	var/mob/living/carbon/human/H = target
	var/typeofmeat = /obj/item/reagent_containers/food/snacks/meat/slab/human

	if(H.dna && H.dna.species)
		typeofmeat = H.dna.species.meat

	var/obj/item/reagent_containers/food/snacks/meat/slab/human/newmeat = new typeofmeat
	newmeat.name = "fatty meat"
	newmeat.desc = "Extremely fatty tissue taken from a patient."
	newmeat.subjectname = H.real_name
	newmeat.subjectjob = H.job
	newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, (removednutriment / 15)) //To balance with nutriment_factor of nutriment
	newmeat.forceMove(target.loc)
	return TRUE
