/datum/outfit/infiltrator
	name = "Syndicate Infiltrator"

	uniform = /obj/item/clothing/under/chameleon/syndicate
	shoes = /obj/item/clothing/shoes/chameleon/noslip/syndicate
	gloves = /obj/item/clothing/gloves/chameleon/syndicate
	back = /obj/item/storage/backpack/chameleon/syndicate
	ears = /obj/item/radio/headset/chameleon/syndicate
	id = /obj/item/card/id/syndicate
	mask = /obj/item/clothing/mask/chameleon/syndicate
	backpack_contents = list(/obj/item/storage/box/engineer=1,\
		/obj/item/kitchen/knife/combat/survival=1,\
		/obj/item/gun/ballistic/automatic/pistol=1)

/datum/outfit/infiltrator/post_equip(mob/living/carbon/human/H)
	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(H)
	W.implant(H)
	var/obj/item/implant/dusting/E = new/obj/item/implant/dusting(H)
	E.implant(H)
	var/datum/team/infiltrator/team
	for (var/T in GLOB.antagonist_teams)
		if (istype(T, /datum/team/infiltrator))
			var/datum/team/infiltrator/infil_team = T
			if (H.mind in infil_team.members)
				team = infil_team
				break
	var/obj/item/implant/infiltrator/U = new/obj/item/implant/infiltrator(H, H.key, team)
	U.implant(H)
	var/obj/item/implant/radio/syndicate/S = new/obj/item/implant/radio/syndicate(H)
	S.implant(H)
	H.faction |= ROLE_SYNDICATE
	H.update_icons()

	var/obj/item/card/id/card = H.wear_id
	if(istype(card))
		card.registered_name = H.real_name
		card.assignment = "Assistant"
		card.access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE)
		card.update_label()

	var/list/device_types = list(DEVICE_NONE = /obj/item/storage/wallet/random,
								 DEVICE_PDA = /obj/item/modular_computer/pda/preset/basic,
								 DEVICE_LAPTOP = /obj/item/modular_computer/laptop/preset/civillian,
								 DEVICE_TABLET = /obj/item/modular_computer/tablet/preset/cheap,
								 DEVICE_PHONE = /obj/item/modular_computer/tablet/preset/cheap)
	var/device_path = device_types[H.device]
	var/obj/item/device = new device_path()

	if(!(H.equip_to_slot_if_possible(device, ITEM_SLOT_BELT, FALSE, TRUE) || \
		H.equip_to_slot_if_possible(device, SLOT_L_STORE, FALSE, TRUE) || \
		H.equip_to_slot_if_possible(device, SLOT_R_STORE, FALSE, TRUE) || \
		H.equip_to_slot_if_possible(device, SLOT_S_STORE, FALSE, TRUE) || \
		H.equip_to_slot_if_possible(device, SLOT_IN_BACKPACK, FALSE, TRUE) || \
		H.equip_to_slot_if_possible(device, SLOT_HANDS, FALSE, TRUE)))
		CRASH("Failed to equip [device] to [H]")
	/*
	if(device && device.is_modular_computer())
		var/obj/item/modular_computer/modular_device = device
		modular_device.finish_color = ((!H.device_color == "random" || (H.device_color in modular_device.variants) || (H.device_color in modular_device.donor_variants)) ? "department-civilian" : null)
		modular_device.overlay_skin = ((!H.device_color == "Default" || (H.device_interface in modular_device.available_overlay_skins)) ? H.device_interface : null)
		modular_device.department_stripe = ((H.device_stripe && modular_device.has_department_stripes && !isnull(department_stripe)) ? department_stripe : null)
		modular_device.update_icon()
		*/
