/datum/job/rd
	title = "Research Director"
	flag = RD_JF
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Captain")
	department_flag = MEDSCI
	head_announce = list("Science")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_type_department = EXP_TYPE_SCIENCE
	exp_requirements = 720
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SCIENCE
	alt_titles = list("Chief Science Officer", "Head of Research")

	outfit = /datum/outfit/job/rd

	added_access = list(ACCESS_CAPTAIN)
	base_access = list(ACCESS_RD, ACCESS_HEADS, ACCESS_TOX, ACCESS_GENETICS, ACCESS_MORGUE,
			            ACCESS_TOX_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS, ACCESS_MECH_SCIENCE,
			            ACCESS_RESEARCH, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD,
			            ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM,
			            ACCESS_TECH_STORAGE, ACCESS_MINISAT, ACCESS_MAINT_TUNNELS, ACCESS_NETWORK)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR
	minimal_character_age = 26 // "A PhD takes twice as long as a bachelor's degree to complete. The average student takes 8.2 years to slog through a PhD program and is 33 years old before earning that top diploma."

	changed_maps = list("OmegaStation")

/datum/job/rd/proc/OmegaStationChanges()
	return TRUE

/datum/outfit/job/rd
	name = "Research Director"
	jobtype = /datum/job/rd

	id_type = /obj/item/card/id/silver

	ears = /obj/item/radio/headset/heads/rd
	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	uniform = /obj/item/clothing/under/rank/research_director
	uniform_skirt = /obj/item/clothing/under/rank/research_director/skirt
	shoes = /obj/item/clothing/shoes/sneakers/brown
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/command
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/clipboard
	l_pocket = /obj/item/laser_pointer
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1) //yogs - removes sci budget

	device_types = list(DEVICE_NONE = /obj/item/storage/wallet/random,
						DEVICE_PDA = /obj/item/modular_computer/pda/preset/advanced/command/rd,
						DEVICE_LAPTOP = /obj/item/modular_computer/laptop/preset/advanced/command/rd,
						DEVICE_TABLET = /obj/item/modular_computer/tablet/preset/advanced/command/rd,
						DEVICE_PHONE = /obj/item/modular_computer/phone/preset/advanced/command/rd)

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

	chameleon_extras = /obj/item/stamp/rd

/datum/outfit/job/rd/rig
	name = "Research Director (Hardsuit)"

	l_hand = null
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/rd
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = SLOT_S_STORE
