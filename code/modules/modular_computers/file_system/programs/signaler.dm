/datum/computer_file/program/signaler
	filename = "signaler"
	filedesc = "SignalCommander"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "signaler"
	extended_desc = "A small built-in frequency app that sends out signaller signals with the appropriate hardware."
	size = 2
	tgui_id = "NtosSignaler"
	file_icon = "satellite-dish"
	///What is the saved signal frequency?
	var/signal_frequency = FREQ_SIGNALER
	/// What is the saved signal code?
	var/signal_code = DEFAULT_SIGNALER_CODE
	/// Radio connection datum used by signalers.
	var/datum/radio_frequency/radio_connection
	/// List of possable colors for the program.
	var/static/list/label_colors = list("green", "blue", "red", "cyan", "yellow")
	/// Current selected color.
	var/label_color = "green"

/datum/computer_file/program/signaler/run_program(mob/living/user)
	. = ..()
	if (!.)
		return
	if(!computer?.get_modular_computer_part(MC_SIGNALER)) //Giving a clue to users why the program is spitting out zeros.
		to_chat(user, "<span class='warning'>\The [computer] flashes an error: \"hardware\\signal_hardware\\startup.bin -- file not found\".</span>")


/datum/computer_file/program/signaler/ui_data(mob/user)
	var/list/data = get_header_data()
	var/obj/item/computer_hardware/signaler_card/sensor = computer?.get_modular_computer_part(MC_SIGNALER)
	if(!sensor?.check_functionality())
		data["Prg_Error"] = TRUE
		data["Prg_ErrorName"] = "MISSING FILE ERROR" 
		data["Prg_ErrorDesc"] = "File \"hardware\\signal_hardware\\startup.bin\" not found, please make sure the device is firmly secured and try again. If problem persists contact your system administrator."
	data["frequency"] = signal_frequency
	data["code"] = signal_code
	data["minFrequency"] = MIN_FREE_FREQ
	data["maxFrequency"] = MAX_FREE_FREQ
	data["color"] = label_color
	return data

/datum/computer_file/program/signaler/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/obj/item/computer_hardware/signaler_card/sensor = computer?.get_modular_computer_part(MC_SIGNALER)
	if(!(sensor?.check_functionality()))
		playsound(src, 'sound/machines/scanbuzz.ogg', 100, FALSE)
		return
	switch(action)
		if("signal")
			INVOKE_ASYNC(src, .proc/signal)
			. = TRUE
		if("freq")
			signal_frequency = unformat_frequency(params["freq"])
			signal_frequency = sanitize_frequency(signal_frequency, TRUE)
			set_frequency(signal_frequency)
			. = TRUE
		if("code")
			signal_code = text2num(params["code"])
			signal_code = round(signal_code)
			. = TRUE
		if("reset")
			if(params["reset"] == "freq")
				signal_frequency = initial(signal_frequency)
			else
				signal_code = initial(signal_code)
			. = TRUE
		if("color")
			var/idx = label_colors.Find(label_color)
			if(idx == label_colors.len || idx == 0)
				idx = 1
			else
				idx++
			label_color = label_colors[idx]
			program_icon_state = "[initial(program_icon_state)]_[label_color]"
			computer?.update_icon()

/datum/computer_file/program/signaler/proc/signal()
	if(!radio_connection)
		return
	var/datum/signal/signal = new(list("code" = signal_code))
	radio_connection.post_signal(src, signal)

/datum/computer_file/program/signaler/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, signal_frequency)
	signal_frequency = new_frequency
	radio_connection = SSradio.add_object(src, signal_frequency, RADIO_SIGNALER)
	return
