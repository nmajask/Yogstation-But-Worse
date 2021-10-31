/obj/item/computer_hardware/microphone/radio
	name = "integrated radio"
	desc = "A module containing an integrated station bounced radio for comunications when other means arent available. An encryption key can be inserted to offer a wider range of channels."
	power_usage = 50 //W
	icon_state = "card_mini"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_MIC
	expansion_hw = TRUE

	var/obj/item/radio/internal_radio = null

/obj/item/computer_hardware/microphone/radio/Initialize()
	..()
	internal_radio = new(src)
	internal_radio.subspace_switchable = TRUE

/obj/item/computer_hardware/microphone/radio/handle_atom_del(atom/A)
	qdel(internal_radio)
	. = ..()

/obj/item/computer_hardware/microphone/radio/security
	name = "integrated security intercomm"
	internal_radio = /obj/item/radio/security
