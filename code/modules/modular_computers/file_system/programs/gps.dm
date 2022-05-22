/datum/computer_file/program/gps
	filename = "gpsinterface"
	filedesc = "GPS Interface"
	program_icon_state = "bounty"
	extended_desc = "Program for configuring and viewing signals dected by an integrated GPS"
	requires_ntnet = FALSE
	size = 3
	tgui_id = "NtosGps"
	file_icon = "globe"

/datum/computer_file/program/gps/run_program(mob/living/user)
	. = ..()
	if (!.)
		return

/datum/computer_file/program/gps/ui_data(mob/user)
	var/list/data = get_header_data()
	var/obj/item/computer_hardware/gps_card/gps = computer?.get_modular_computer_part(MC_GPS)
	if(!istype(gps, /obj/item/computer_hardware/gps_card))
		data["Prg_Error"] = TRUE
		data["Prg_ErrorName"] = "MISSING FILE ERROR" 
		data["Prg_ErrorDesc"] = "File \"hardware\\gps\\startup.bin\" not found, please make sure the device is firmly secured and try again. If problem persists contact your system administrator."
		return data

	data["power"] = gps.tracking
	data["tag"] = gps.gpstag
	data["updating"] = gps.updating
	data["globalmode"] = gps.global_mode
	if(!(gps.tracking && gps.enabled)) //Do not bother scanning if the GPS is off
		return data

	var/turf/curr = get_turf_global(gps) // yogs - get_turf_global instead of get_turf
	data["currentArea"] = "[get_area_name(curr, TRUE)]"
	data["currentCoords"] = "[curr.x], [curr.y], [curr.z]"

	var/list/signals = list()
	data["signals"] = list()

	for(var/other_gps in GLOB.GPS_list)
		var/obj/item/gps/G = other_gps
		if(G == gps || !G.tracking || G?.emped)
			continue
		var/turf/pos = get_turf_global(G) // yogs - get_turf_global instead of get_turf
		if(!pos)
			continue
		if(!gps.global_mode && pos.z != curr.z)
			continue
		var/list/signal = list()
		signal["entrytag"] = G.gpstag //Name or 'tag' of the GPS
		signal["coords"] = "[pos.x], [pos.y], [pos.z]"
		if(pos.z == curr.z) //Distance/Direction calculations for same z-level only
			signal["dist"] = max(get_dist(curr, pos), 0) //Distance between the src and remote GPS turfs
			signal["degrees"] = round(Get_Angle(curr, pos)) //0-360 degree directional bearing, for more precision.

		signals += list(signal) //Add this signal to the list of signals
	data["signals"] = signals
	return data

/datum/computer_file/program/gps/ui_act(action, params, datum/tgui/ui)
	if(..())
		return

	var/obj/item/computer_hardware/gps_card/gps = computer?.get_modular_computer_part(MC_GPS)
	if(!istype(gps, /obj/item/computer_hardware/gps_card))
		return

	switch(action)
		if("rename")
			var/a = stripped_input(usr, "Please enter desired tag.", filedesc, gps.gpstag, 20)
			if(isnotpretty(a))
				to_chat(usr, span_notice("Your fingers slip. <a href='https://forums.yogstation.net/help/rules/#rule-0_1'>See rule 0.1</a>."))
				var/log_message = "[key_name(usr)] just tripped a pretty filter: '[a]'."
				message_admins(log_message)
				log_say(log_message)
				return
			gps.gpstag = a
			return
		if("power")
			gps.tracking = !gps.tracking
			return
		if("updating")
			gps.updating = !gps.updating
			return
		if("globalmode")
			gps.global_mode = !gps.global_mode
			return
