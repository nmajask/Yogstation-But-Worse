//normal computer version is located in code\modules\power\monitor.dm, /obj/machinery/computer/monitor

/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitor"
	category = PROGRAM_CATEGORY_ENGI
	program_icon_state = "power_monitor"
	extended_desc = "This program connects to sensors around the station to provide information about electrical systems"
	ui_header = "power_norm.gif"
	transfer_access = ACCESS_ENGINE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN
	requires_ntnet = 0
	network_destination = "power monitoring system"
	size = 9
	tgui_id = "NtosPowerMonitor"
	file_icon = "plug"

	var/has_alert = 0
	var/datum/powernet/powernet
	var/list/history = list()
	var/record_size = 60
	var/record_interval = 50
	var/next_record = 0


/datum/computer_file/program/power_monitor/run_program(mob/living/user)
	. = ..(user)
	history["supply"] = list()
	history["demand"] = list()


/datum/computer_file/program/power_monitor/process_tick()
	if(get_powernet())
		record()

/datum/computer_file/program/power_monitor/proc/get_powernet() //keep in sync with /obj/machinery/computer/monitor's version
	var/obj/item/computer_hardware/recharger/recharger = computer.all_components[MC_CHARGE]
	return recharger.get_powernet()

/datum/computer_file/program/power_monitor/proc/record() //keep in sync with /obj/machinery/computer/monitor's version
	if(world.time >= next_record)
		next_record = world.time + record_interval

		if(history.len < 1)
			history["supply"] = list()
			history["demand"] = list()

		var/datum/powernet/connected_powernet = get_powernet()

		var/list/supply = history["supply"]
		if(connected_powernet)
			supply += connected_powernet.viewavail
		if(supply.len > record_size)
			supply.Cut(1, 2)

		var/list/demand = history["demand"]
		if(connected_powernet)
			demand += connected_powernet.viewload
		if(demand.len > record_size)
			demand.Cut(1, 2)

/datum/computer_file/program/power_monitor/ui_data()
	var/datum/powernet/connected_powernet = get_powernet()
	var/list/data = get_header_data()
	data["stored"] = record_size
	data["interval"] = record_interval / 10
	data["attached"] = connected_powernet ? TRUE : FALSE
	if(connected_powernet)
		data["supply"] = DisplayPower(connected_powernet.viewavail)
		data["demand"] = DisplayPower(connected_powernet.viewload)
	data["history"] = history

	data["areas"] = list()
	if(connected_powernet)
		for(var/obj/machinery/power/terminal/term in connected_powernet.nodes)
			var/obj/machinery/power/apc/A = term.master
			if(istype(A))
				data["areas"] += list(list(
					"name" = A.area.name,
					"charge" = A.cell ? A.cell.percent() : 0,
					"load" = DisplayPower(A.lastused_total),
					"charging" = A.charging,
					"eqp" = A.equipment,
					"lgt" = A.lighting,
					"env" = A.environ
				))

	return data

