/datum/job/psych
	title = "Psychiatrist"
	flag = PSYCH
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	selection_color = "#d4ebf2"
	alt_titles = list("Counsellor", "Therapist", "Mentalist")

	outfit = /datum/outfit/job/psych

	added_access = list()
	base_access = list(ACCESS_MEDICAL)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_PSYCHIATRIST
	minimal_character_age = 24 //Psychology, therapy, and the like; all branches that would probably need to be certified as properly educated

	changed_maps = list("OmegaStation","GaxStation")

/datum/job/psych/proc/OmegaStationChanges()
	return TRUE

/datum/job/psych/proc/GaxStationChanges() // I'M SORRY
	return TRUE

/datum/job/psych/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	H.set_psi_rank(PSI_COERCION, PSI_RANK_OPERANT)
	if(H.psi)
		to_chat(H, "You are psionically awakened, part of a tiny minority, and you are the first and only exposure most of the crew will have to the mentally gifted.")

/datum/outfit/job/psych
	name = "Psych"
	jobtype = /datum/job/psych

	shoes = /obj/item/clothing/shoes/sneakers/brown
	uniform = /obj/item/clothing/under/suit_jacket/burgundy
	l_hand = /obj/item/storage/briefcase
	glasses = /obj/item/clothing/glasses/regular
	ears = /obj/item/radio/headset/headset_med

	implants = list(/obj/item/implant/psi_control)
