/datum/species/skrell
	name = "Skrell"
	id = "skrell"
	damage_overlay_type = "skrell"
	default_color = "#4B4B4B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAS_FLESH,HAS_BONE,NO_SLIP_WHEN_WALKING)
	default_features = list("skrell_hair" = "Short")
	mutant_bodyparts = list("skrell_hair")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	say_mod = "warbles"
	brutemod = 1.7
	burnmod = 0.6
	species_language_holder = /datum/language_holder/skrell
	exotic_bloodtype = "C" // Copper blood
	payday_modifier = 0.8

	latency_chance = 99.9
	starting_psi_level = PSI_RANK_OPERANT

	toxic_food = FRIED | PINEAPPLE
	disliked_food = MEAT | GRAIN
	liked_food = FRUIT

	mutantlungs = /obj/item/organ/lungs/skrell
	mutant_brain = /obj/item/organ/brain/skrell
	mutant_heart = /obj/item/organ/heart/skrell
	mutanteyes = /obj/item/organ/eyes/skrell
	mutantappendix = /obj/item/organ/stomach/skrell/second
	mutantliver = /obj/item/organ/liver/skrell
	mutantstomach = /obj/item/organ/stomach/skrell

	face_icon = 'icons/mob/species/skrell/face.dmi'
