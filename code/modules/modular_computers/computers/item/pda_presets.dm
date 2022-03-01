// This is literally the worst possible cheap PDA
/obj/item/modular_computer/pda/preset/basic
	desc = "A standard issue PDA often given to civilian station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell/crap,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)

/obj/item/modular_computer/pda/preset/basic
	desc = "A standard issue PDA often given to station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell/computer/micro,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)
	
	starting_files = list(/datum/computer_file/program/chatclient)

/obj/item/modular_computer/pda/preset/basic/atmos
	desc = "A standard issue PDA often given to station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot,
								/obj/item/computer_hardware/sensorpackage)
	
	starting_files = list(/datum/computer_file/program/chatclient)

// Honk
/obj/item/modular_computer/pda/preset/basic/clown
	desc = "A hilarious PDA often given to station pranksters."
	finish_color = "pink"
	interact_sounds = list('sound/machines/computers/pda_click.ogg', 'sound/machines/computers/pda_click.ogg')

/obj/item/modular_computer/pda/preset/basic/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/slippery, 120, NO_SLIP_WHEN_WALKING)
