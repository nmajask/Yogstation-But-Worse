// Essentialy a laptop thats bolted down to a table
/obj/machinery/modular_computer/personal_computer
	name = "personal computer"
	desc = "A bulky computer designed for personal use."

	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop-closed"
	icon_state_powered = "laptop"
	icon_state_unpowered = "laptop-off"
	icon_state_menu = "menu"

	hardware_flag = PROGRAM_LAPTOP
	max_hardware_size = WEIGHT_CLASS_NORMAL
	max_bays = 4
