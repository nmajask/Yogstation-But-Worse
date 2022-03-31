// Radio Card //
/obj/item/computer_hardware/radio_card
	name = "integrated radio card"
	desc = "An integrated signaling assembly for computers to send an outgoing frequency signal. Required by certain programs."
	icon_state = "signal_card"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_SIGNALER
	expansion_hw = TRUE
	power_usage = 10

// GPS Card //
/obj/item/computer_hardware/gps_card
	name = "integrated radio card"
	desc = "An integrated signaling assembly for computers to send an outgoing frequency signal. Required by certain programs."
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
	name = "global positioning system ([gpstag])"
	if(tracking) //Some roundstart GPS are off.
		add_overlay("working")

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
