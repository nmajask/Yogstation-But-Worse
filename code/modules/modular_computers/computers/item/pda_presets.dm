/*
/	PDAs are the most basic modular device that you can have, with many limitations on what parts and programs can be used with it
/
/	Available to: All Station Jobs
*/

// This is literally the worst possible cheap PDA
/obj/item/modular_computer/pda/preset/basic
	desc = "A standard issue PDA often given to civilian station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell/computer/nano,
								/obj/item/computer_hardware/hard_drive/micro,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)
	
	starting_files = list(/datum/computer_file/program/chatclient)

/obj/item/modular_computer/pda/preset/advanced
	desc = "A standard issue PDA often given to station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell/computer/micro,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)
	
	starting_files = list(/datum/computer_file/program/chatclient)

/obj/item/modular_computer/pda/preset/advanced/atmos
	desc = "A standard issue PDA often given to station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell/computer/micro,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/pda/preset/advanced/command
	desc = "A high-end PDA often seen among command staff."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell/computer/micro,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/sensorpackage)

/obj/item/modular_computer/pda/preset/advanced/command/captain
	desc = "A high-end PDA often seen among command staff. This one seems to be outfitted for the captain."

/obj/item/modular_computer/pda/preset/advanced/command/hop
	desc = "A high-end PDA often seen among command staff. This one seems to be outfitted for the head of personel."
	
/obj/item/modular_computer/pda/preset/advanced/command/hos
	desc = "A high-end PDA often seen among command staff. This one seems to be outfitted for the head of security."
	
/obj/item/modular_computer/pda/preset/advanced/command/ce
	desc = "A high-end PDA often seen among command staff. This one seems to be outfitted for the chief engineer."
	
/obj/item/modular_computer/pda/preset/advanced/command/cmo
	desc = "A high-end PDA often seen among command staff. This one seems to be outfitted for the chief medical officer."
	
/obj/item/modular_computer/pda/preset/advanced/command/rd
	desc = "A high-end PDA often seen among command staff. This one seems to be outfitted for the research director."

/obj/item/modular_computer/pda/preset/advanced/syndicate
	desc = "A syndicate PDA often given to syndicate personel."

// Honk
/obj/item/modular_computer/pda/preset/basic/clown
	desc = "A hilarious PDA often given to station pranksters."
	finish_color = "pink"
	interact_sounds = list('sound/machines/computers/pda_click.ogg', 'sound/machines/computers/pda_click.ogg')

/obj/item/modular_computer/pda/preset/basic/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/slippery, 120, NO_SLIP_WHEN_WALKING)
