/*
/	Laptops are bulky computers that can use many complex programs and parts, but are not very good for those who need to use those tools on the move
/
/	Available to: All Station Jobs
*/

/obj/item/modular_computer/laptop/preset
	start_open = FALSE
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive,
								/obj/item/computer_hardware/network_card)

/obj/item/modular_computer/laptop/preset/civillian
	desc = "A low-end laptop often used for personal recreation."
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer,
								/obj/item/computer_hardware/hard_drive,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)
	starting_files = list(new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/laptop/preset/basic
	desc = "A decent laptop often given to mid-ranking staff for personal use and recreation."
	starting_components = list( /obj/item/computer_hardware/processor_unit/small,
								/obj/item/stock_parts/cell/computer/advanced,
								/obj/item/computer_hardware/hard_drive/advanced,
								/obj/item/computer_hardware/network_card,
								/obj/item/computer_hardware/card_slot)
	starting_files = list(new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/laptop/preset/advanced
	desc = "A high-end laptop often given to high-ranking staff for personal use and recreation."
	starting_components = list( /obj/item/computer_hardware/processor_unit,
								/obj/item/stock_parts/cell/computer/super,
								/obj/item/computer_hardware/hard_drive/super,
								/obj/item/computer_hardware/network_card/advanced,
								/obj/item/computer_hardware/card_slot)
	starting_files = list(new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/laptop/preset/advanced/command
	desc = "A high-end laptop often given to high-ranking staff for personal use and recreation."
	starting_components = list( /obj/item/computer_hardware/processor_unit,
								/obj/item/stock_parts/cell/computer/super,
								/obj/item/computer_hardware/hard_drive/super,
								/obj/item/computer_hardware/network_card/advanced,
								/obj/item/computer_hardware/card_slot)
	starting_files = list(new /datum/computer_file/program/chatclient)

/obj/item/modular_computer/laptop/preset/advanced/command/captain
	desc = "A high-end laptop often seen among command staff. This one seems to be outfitted for the captain."

/obj/item/modular_computer/laptop/preset/advanced/command/hop
	desc = "A high-end laptop often seen among command staff. This one seems to be outfitted for the head of personel."
	
/obj/item/modular_computer/laptop/preset/advanced/command/hos
	desc = "A high-end laptop often seen among command staff. This one seems to be outfitted for the head of security."
	
/obj/item/modular_computer/laptop/preset/advanced/command/ce
	desc = "A high-end laptop often seen among command staff. This one seems to be outfitted for the chief engineer."
	
/obj/item/modular_computer/laptop/preset/advanced/command/cmo
	desc = "A high-end laptop often seen among command staff. This one seems to be outfitted for the chief medical officer."
	
/obj/item/modular_computer/laptop/preset/advanced/command/rd
	desc = "A high-end laptop often seen among command staff. This one seems to be outfitted for the research director."
