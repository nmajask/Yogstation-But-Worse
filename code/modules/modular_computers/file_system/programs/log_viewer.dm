/datum/computer_file/program/file_editor
	filename = "fileeditor"
	filedesc = "Thinktronic File Editor"
	file_icon = "folder-open"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "comm_monitor"
	extended_desc = "This program allows for viewing, editing, and saving standard file formats"
	size = 5
	available_on_ntnet = TRUE
	tgui_id = "NtosFileEditor"

	var/datum/computer_file/activefile

/datum/computer_file/program/file_editor/ui_act(action, params)
	if(..())
		return

	var/obj/item/computer_hardware/hard_drive/HDD = computer.all_components[MC_HDD]
	var/obj/item/computer_hardware/printer/printer = computer.all_components[MC_PRINT]
	switch(action)
		if("PRG_Print")
			if(!HDD)
				return
			if(!printer)
				return
			var/datum/computer_file/F = HDD.find_file_by_name(params["name"])
			if(!F || !istype(F))
				return
			if(printer.print_file(F) && computer)
				computer.play_ping()
		if("PRG_Open")
			if(!HDD)
				return
			var/datum/computer_file/F = HDD.find_file_by_name(params["name"])
			if(!F || !istype(F))
				return
			if(!istype(F, /datum/computer_file))
				return
			activefile = F
			return TRUE

/datum/computer_file/program/file_editor/ui_data(mob/user)
	if(!SSnetworks.station_network)
		return
	var/list/data = get_header_data()

	var/obj/item/computer_hardware/hard_drive/HDD = computer.all_components[MC_HDD]
	var/list/files = list()
	for(var/datum/computer_file/F in HDD.stored_files)
		var/viewable = FALSE
		var/datum/computer_file/log/logfile = F
		if(istype(logfile))
			viewable = TRUE
		files += list(list(
			"name" = F.filename,
			"type" = F.filetype,
			"size" = F.size,
			"printable" = F.can_print,
			"openable" = viewable,
		))
		data["files"] = files
	if(istype(activefile, /datum/computer_file/log))
		var/datum/computer_file/log/log = activefile
		data["fileData"] = log.formatfile(FALSE)
		data["fileType"] = "Log"
	return data
