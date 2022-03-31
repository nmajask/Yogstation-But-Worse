/*
/	Tablets are middl-of-the-line computers that are more versitile than PDAs, but are not as portable
/
/	Available to: High Ranking Station Jobs (Captain, Head of Personel, Head of Security, Chief Medical Officer, Research Director, Chief Engineer)
*/

// This is literally the worst possible cheap phone
/obj/item/modular_computer/phone/preset/cheap
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer/micro,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card)

// Alternative version, an average one, for higher ranked positions mostly
/obj/item/modular_computer/phone/preset/advanced
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)

/obj/item/modular_computer/phone/preset/cargo
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/printer/mini)
	starting_files = list(	new /datum/computer_file/program/budgetorders,
							new /datum/computer_file/program/cargo_bounties,
							new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/phone/preset/advanced/atmos
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/phone/preset/advanced/command
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary)
	starting_files = list(	new /datum/computer_file/program/budgetorders,
							new /datum/computer_file/program/cargo_bounties,
							new /datum/computer_file/program/card_mod,
							new /datum/computer_file/program/crew_manifest,
							new /datum/computer_file/program/job_management,
							new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/phone/preset/advanced/command/captain
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/phone/preset/advanced/command/personel
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/phone/preset/advanced/command/security
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/phone/preset/advanced/command/medical
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/phone/preset/advanced/command/science
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/phone/preset/advanced/command/engineering
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/card_slot/secondary,
								/obj/item/computer_hardware/sensorpackage)
