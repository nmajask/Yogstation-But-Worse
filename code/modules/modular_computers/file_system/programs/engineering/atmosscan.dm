/datum/computer_file/program/atmosscan
	filename = "atmosscan"
	filedesc = "Atmospheric Scanner"
	category = PROGRAM_CATEGORY_ENGI
	program_icon_state = "air"
	extended_desc = "A small built-in sensor reads out the atmospheric conditions around the device."
	network_destination = "atmos scan"
	size = 4
	tgui_id = "NtosAtmos"
	file_icon = "thermometer-half"

/datum/computer_file/program/atmosscan/run_program(mob/living/user)
	. = ..()
	if (!.)
		return
	if(!computer?.get_modular_computer_part(MC_SENSORS)) //Giving a clue to users why the program is spitting out zeros.
		to_chat(user, "<span class='warning'>\The [computer] flashes an error: \"hardware\\sensorpackage\\startup.bin -- file not found\".</span>")


/datum/computer_file/program/atmosscan/ui_data(mob/user)
	var/list/data = get_header_data()
	var/list/airlist = list()
	var/turf/T = get_turf(ui_host())
	var/obj/item/computer_hardware/sensorpackage/sensors = computer?.get_modular_computer_part(MC_SENSORS)
	if(T && sensors?.check_functionality())
		var/datum/gas_mixture/environment = T.return_air()
		var/list/env_gases = environment.get_gases()
		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles()
		data["AirPressure"] = round(pressure,0.1)
		data["AirTemp"] = round(environment.return_temperature() - T0C)
		if (total_moles)
			for(var/id in env_gases)
				var/moles = environment.get_moles(id)
				var/gas_level = moles/total_moles
				if(gas_level > 0)
					airlist += list(list("name" = "[GLOB.meta_gas_info[id][META_GAS_NAME]]", "percentage" = round(gas_level*100, 0.01)))
		data["AirData"] = airlist
	else
		data["AirPressure"] = 0
		data["AirTemp"] = 0
		data["AirData"] = list(list())
	return data

/datum/computer_file/program/atmosscan/ui_act(action, list/params)
	if(..())
		return TRUE
