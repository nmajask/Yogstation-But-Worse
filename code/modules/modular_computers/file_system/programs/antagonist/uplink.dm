/datum/computer_file/program/uplink
	filename = "synbn"
	filedesc = "Syndix Blackmarket Network"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "hostile"
	extended_desc = "A heavily secure trading network that trades illegal items using telecrystals to avoid taxes. Commonly used by Syndicate agents to purchace useful gear to help in their missons."
	size = 20
	available_on_ntnet = FALSE
	tgui_id = "NtosUplink"
	program_icon = "gem"
	var/datum/component/uplink/uplink

/datum/computer_file/program/uplink/clone()
	var/datum/computer_file/program/uplink/temp = ..()
	temp.uplink = uplink
	return temp

/datum/computer_file/program/uplink/can_run(mob/user, loud = FALSE, access_to_check, transfer = FALSE, var/list/access)
	if(..() && check_uplink())
		return TRUE
	return FALSE

/datum/computer_file/program/uplink/proc/check_uplink()
	if(!computer || !uplink)
		return FALSE
	var/obj/item/computer_hardware/hard_drive/HDD = computer.all_components[MC_HDD]
	var/obj/item/computer_hardware/hard_drive/RHDD = computer.all_components[MC_SDD]
	if(HDD.GetExactComponent(/datum/component/uplink) == uplink || RHDD.GetExactComponent(/datum/component/uplink) == uplink)
		return TRUE

/*
/datum/computer_file/program/uplink/kill_program(forced = FALSE)
	if(target)
		target.dos_sources.Remove(src)
	target = null
	executed = FALSE

	..()
*/

/datum/computer_file/program/uplink/ui_act(action, params)
	if(..())
		return
	if(!check_uplink())
		return
	computer.play_interact_sound()
	return uplink.ui_act(action, params)

/datum/computer_file/program/uplink/ui_data(mob/user)
	var/list/data = get_header_data()

	data |= uplink.ui_data(user)

	return data

/datum/computer_file/program/uplink/ui_static_data(mob/user)
	return uplink.ui_static_data(user)

	