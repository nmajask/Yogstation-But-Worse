// This is literally the worst possible cheap tablet
/obj/item/modular_computer/tablet/pda/preset/basic
	desc = "A standard issue PDA often given to station personnel."
	starting_components = list( /obj/item/computer_hardware/processor_unit/pda,
								/obj/item/stock_parts/cell/computer/micro,
								/obj/item/computer_hardware/hard_drive/small,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)
	
	starting_files = list(/datum/computer_file/program/chatclient)

// Honk
/obj/item/modular_computer/tablet/pda/preset/basic/clown
	desc = "A hilarious PDA often given to station pranksters."
	finish_color = "pink"

/obj/item/modular_computer/tablet/pda/preset/basic/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/slippery, 120, NO_SLIP_WHEN_WALKING)
