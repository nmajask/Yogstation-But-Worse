/datum/computer_file/program/mecha_monitor
	filename = "exosuitmonitor"
	filedesc = "Exosuit Remote Monitoring"
	category = PROGRAM_CATEGORY_SCI
	ui_header = "borg_mon.gif"
	program_icon_state = "generic"
	extended_desc = "This program allows for remote monitoring or locking down exosuits."
	requires_ntnet = TRUE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_TELESCREEN
	transfer_access = ACCESS_ROBOTICS
	network_destination = "cyborg remote monitoring"
	size = 10
	tgui_id = "NtosCyborgRemoteMonitor"
	file_icon = "project-diagram"
	var/list/located = list()

/datum/computer_file/program/mecha_monitor/ui_data(mob/user)
	var/list/data = get_header_data()

	var/list/trackerlist = list()
	for(var/obj/mecha/MC in GLOB.mechas_list)
		trackerlist += MC.trackers

	data["mechs"] = list()
	for(var/obj/item/mecha_parts/mecha_tracking/MT in trackerlist)
		if(!MT.chassis)
			continue
		var/obj/mecha/M = MT.chassis
		var/list/mech_data = list(
			name = M.name,
			integrity = round((M.obj_integrity / M.max_integrity) * 100),
			charge = M.cell ? round(M.cell.percent()) : null,
			airtank = M.internal_tank ? M.return_pressure() : null,
			pilot = M.occupant,
			location = get_area_name(M, TRUE),
			active_equipment = M.selected,
			emp_recharging = MT.recharging,
			tracker_ref = REF(MT)
		)
		if(istype(M, /obj/mecha/working/ripley))
			var/obj/mecha/working/ripley/RM = M
			mech_data += list(
				cargo_space = round((RM.cargo.len / RM.cargo_capacity) * 100)
		)

		data["mechs"] += list(mech_data)

	return data

/datum/computer_file/program/mecha_monitor/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("send_message")
			var/obj/item/mecha_parts/mecha_tracking/MT = locate(params["tracker_ref"])
			if(!istype(MT))
				return
			var/message = stripped_input(usr, "Input message", "Transmit message")
			var/obj/mecha/M = MT.chassis
			if(trim(message) && M)
			
				M.occupant_message(message)
				to_chat(usr, span_notice("Message sent."))
				. = TRUE
		if("shock")
			var/obj/item/mecha_parts/mecha_tracking/MT = locate(params["tracker_ref"])
			if(!istype(MT))
				return
			var/obj/mecha/M = MT.chassis
			if(M)
				MT.shock()
				log_game("[key_name(usr)] has activated remote EMP on exosuit [M], located at [loc_name(M)], which is currently [M.occupant? "being piloted by [key_name(M.occupant)]." : "without a pilot."] ")
				message_admins("[key_name_admin(usr)][ADMIN_FLW(usr)] has activated remote EMP on exosuit [M][ADMIN_JMP(M)], which is currently [M.occupant ? "being piloted by [key_name_admin(M.occupant)][ADMIN_FLW(M.occupant)]." : "without a pilot."] ")
				. = TRUE
