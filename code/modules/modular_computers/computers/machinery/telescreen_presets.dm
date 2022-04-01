/obj/machinery/modular_computer/telescreen/preset
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/crap,
								/obj/item/computer_hardware/recharger/APC,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card)

/obj/machinery/modular_computer/telescreen/preset/Initialize()
	..()
	cpu.enabled = TRUE

// ===== ENGINEERING TELESCREEN =====
/obj/machinery/modular_computer/telescreen/preset/engineering
	finish_color = "black"
	department_stripe = "department-engi"

	starting_files = list(	new /datum/computer_file/program/alarm_monitor,
							new /datum/computer_file/program/supermatter_monitor)
	initial_program = /datum/computer_file/program/alarm_monitor

// ===== MEDICAL TELESCREEN =====
/obj/machinery/modular_computer/telescreen/preset/medical
	finish_color = "white"
	department_stripe = "department-med"

	starting_files = list(	new /datum/computer_file/program/crew_monitor)
	initial_program = /datum/computer_file/program/crew_monitor

// ===== SUPPLY TELESCREEN =====
/obj/machinery/modular_computer/telescreen/preset/supply
	finish_color = "black"
	department_stripe = "department-supply"

	starting_files = list(	new /datum/computer_file/program/bounty_board,
							new /datum/computer_file/program/cargo_bounties,
							new /datum/computer_file/program/budgetorders)
	initial_program = /datum/computer_file/program/budgetorders

// ===== CIVILIAN TELESCREEN =====
/obj/machinery/modular_computer/telescreen/preset/civilian
	finish_color = "black"
	department_stripe = "department-civilian"

	starting_files = list(	new /datum/computer_file/program/portrait_printer)
	initial_program = /datum/computer_file/program/portrait_printer

////////////////
// Wallframes //
////////////////

/obj/item/wallframe/telescreen/preset
	result_path = /obj/machinery/modular_computer/telescreen/preset
