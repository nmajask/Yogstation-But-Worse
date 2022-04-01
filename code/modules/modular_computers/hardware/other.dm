// Signaler Card //
/obj/item/computer_hardware/signaler_card
	name = "integrated signaler card"
	desc = "An integrated signaling assembly for computers to send an outgoing frequency signal. Required by certain programs."
	icon_state = "signal_card"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_SIGNALER
	expansion_hw = TRUE
	power_usage = 10

// GPS Card //
/obj/item/computer_hardware/gps_card
	name = "integrated gps transmitter"
	desc = "An integrated GPS for viewing and emmiting a GPS signal. Required by certain programs."
	icon_state = "cart_connector"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_GPS
	expansion_hw = TRUE
	power_usage = 10
	var/gpstag = "MPC0"
	var/tracking = TRUE
	var/updating = TRUE //Automatic updating of GPS list. Can be set to manual by user.
	var/global_mode = TRUE //If disabled, only GPS signals of the same Z level are shown

/obj/item/computer_hardware/gps_card/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click to switch it [tracking ? "off":"on"].")

/obj/item/computer_hardware/gps_card/Initialize()
	. = ..()
	GLOB.GPS_list += src

/obj/item/computer_hardware/gps_card/Destroy()
	GLOB.GPS_list -= src
	return ..()

/obj/item/computer_hardware/gps_card/attackby(obj/item/I, mob/living/user)
	if(..())
		return
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(enabled)
			tracking = !tracking
		to_chat(user, "<span class='notice'>You press down on small pinhole under the \"TRACKING ENABLED\" light with \the [I], and it is now a [enabled ? (tracking ? "solid green" : "blinking red") : "disabled"] light.</span>")

/obj/item/computer_hardware/gps_card/examine(mob/user)
	. = ..()
	. += "There is a [enabled ? (tracking ? "solid green" : "blinking red") : "disabled"] \"TRACKING ENABLED\" light, and a small pinhole under it that can be pressed with a screwdriver."

// Integrated Radio //
/obj/item/computer_hardware/microphone/radio
	name = "integrated radio"
	desc = "A module containing an integrated station bounced radio for comunications when other means arent available."
	power_usage = 50 //W
	icon_state = "signal_card"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_MIC
	expansion_hw = TRUE

	var/obj/item/radio/internal_radio = null

/obj/item/computer_hardware/microphone/radio/Initialize()
	..()
	internal_radio = new(src)

/obj/item/computer_hardware/microphone/radio/Destroy()
	qdel(internal_radio)
	return ..()

/obj/item/computer_hardware/microphone/radio/security
	name = "integrated security intercomm"
	internal_radio = /obj/item/radio/security

/obj/item/computer_hardware/microphone/radio/syndicate
	name = "integrated syndicate radio"

/obj/item/computer_hardware/microphone/radio/syndicate/Initialize()
	..()
	internal_radio.make_syndie()
