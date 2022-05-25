/*
/	Tablets are middle-of-the-line computers that are more versitile than PDAs, but are not as portable
/
/	Available to: Specialized Station Jobs (Quartermaster, Doctors, Engineers, Scientists, Security Officers)
*/

// This is literally the worst possible cheap tablet
/obj/item/modular_computer/tablet/preset/cheap
	desc = "A low-end tablet often seen among low ranked station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer/micro,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)

// Alternative version, an average one, for higher ranked positions mostly
/obj/item/modular_computer/tablet/preset/advanced
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/printer/mini)

/obj/item/modular_computer/tablet/preset/cargo
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/printer/mini)
	starting_files = list(	new /datum/computer_file/program/budgetorders,
							new /datum/computer_file/program/cargo_bounties,
							new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/tablet/preset/advanced/atmos //This will be defunct and will be replaced when NtOS PDAs are fully implemented
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/printer/mini,
								/obj/item/computer_hardware/sensorpackage)

// Head Tablets
/obj/item/modular_computer/tablet/preset/advanced/command
	desc = "A high-end tablet often seen among command staff."
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/printer/mini,
								/obj/item/computer_hardware/card_slot/secondary)
	starting_files = list(	new /datum/computer_file/program/budgetorders,
							new /datum/computer_file/program/cargo_bounties,
							new /datum/computer_file/program/card_mod,
							new /datum/computer_file/program/crew_manifest,
							new /datum/computer_file/program/job_management,
							new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/tablet/preset/advanced/command/captain
	desc = "A high-end tablet often seen among command staff. This one seems to be outfitted for the captain."

/obj/item/modular_computer/tablet/preset/advanced/command/hop
	desc = "A high-end tablet often seen among command staff. This one seems to be outfitted for the head of personel."
	
/obj/item/modular_computer/tablet/preset/advanced/command/hos
	desc = "A high-end tablet often seen among command staff. This one seems to be outfitted for the head of security."
	
/obj/item/modular_computer/tablet/preset/advanced/command/ce
	desc = "A high-end tablet often seen among command staff. This one seems to be outfitted for the chief engineer."
	
/obj/item/modular_computer/tablet/preset/advanced/command/cmo
	desc = "A high-end tablet often seen among command staff. This one seems to be outfitted for the chief medical officer."
	
/obj/item/modular_computer/tablet/preset/advanced/command/rd
	desc = "A high-end tablet often seen among command staff. This one seems to be outfitted for the research director."
	

/// A simple syndicate tablet, used for comms agents
/obj/item/modular_computer/tablet/preset/syndicate
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small/syndicate,
								/obj/item/computer_hardware/network_card/advanced,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/printer/mini)
	finish_color = "red"

/// Given by the syndicate as part of the contract uplink bundle - loads in the Contractor Uplink.
/obj/item/modular_computer/tablet/syndicate_contract_uplink/preset/uplink
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small/syndicate,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/printer/mini)

	starting_files = list(new /datum/computer_file/program/contract_uplink)
	initial_program = /datum/computer_file/program/contract_uplink

/// Given to Nuke Ops members.
/obj/item/modular_computer/tablet/nukeops
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small/nukeops,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,)

	starting_files = list(new /datum/computer_file/program/radar/fission360)
	initial_program = /datum/computer_file/program/radar/fission360

/// Debug Tablet
/obj/item/modular_computer/tablet/admin
	device_theme = MPCTHEME_ABDUCTORWARE
	w_class = WEIGHT_CLASS_SMALL
	hardware_flag = PROGRAM_ALL
	max_hardware_size = WEIGHT_CLASS_GIGANTIC
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	max_bays = INFINITY

/obj/item/modular_computer/tablet/admin
	starting_components = list( /obj/item/computer_hardware/processor_unit/admin,
								/obj/item/computer_hardware/hard_drive/admin,
								/obj/item/computer_hardware/hard_drive/portable/admin,
								/obj/item/stock_parts/cell/computer/super,
								/obj/item/computer_hardware/network_card/advanced,
								/obj/item/computer_hardware/recharger/lambda,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary,
								/obj/item/computer_hardware/sensorpackage,
								/obj/item/computer_hardware/ai_slot,
								/obj/item/computer_hardware/printer,
								/obj/item/computer_hardware/signaler_card,
								/obj/item/computer_hardware/gps_card,
								/obj/item/computer_hardware/microphone/radio)
