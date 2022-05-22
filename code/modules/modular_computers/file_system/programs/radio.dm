/datum/computer_file/program/radio
	filename = "radiointerface"
	filedesc = "Radio Interface"
	program_icon_state = "bounty"
	extended_desc = "Program for configuring an integrated radio"
	requires_ntnet = FALSE
	size = 1
	tgui_id = "NtosRadio"
	file_icon = "microphone"

/datum/computer_file/program/radio/ui_data(mob/user)
	var/list/data = get_header_data()

	var/obj/item/computer_hardware/microphone/radio/radio = computer.all_components[MC_MIC]
	var/obj/item/radio/internal_radio = radio?.internal_radio
	if(!internal_radio)
		data["Prg_Error"] = TRUE
		data["Prg_ErrorName"] = "MISSING FILE ERROR" 
		data["Prg_ErrorDesc"] = "File \"hardware\\radio\\startup.bin\" not found, please make sure the device is firmly secured and try again. If problem persists contact your system administrator."
		return data
	data |= internal_radio.ui_data(user)

	return data

/datum/computer_file/program/radio/ui_act(action, params, datum/tgui/ui)
	if(..())
		return

	var/obj/item/computer_hardware/microphone/radio/radio = computer.all_components[MC_MIC]
	var/obj/item/radio/internal_radio = radio?.internal_radio
	if(!internal_radio)
		return

	return internal_radio.ui_act(action, params, ui)
