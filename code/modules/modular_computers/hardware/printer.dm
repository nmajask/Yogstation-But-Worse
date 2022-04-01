/obj/item/computer_hardware/printer
	name = "printer"
	desc = "Computer-integrated printer with paper recycling module."
	power_usage = 100
	icon_state = "printer"
	w_class = WEIGHT_CLASS_BULKY
	device_type = MC_PRINT
	expansion_hw = TRUE


/obj/item/computer_hardware/printer/proc/print_text(var/text_to_print, var/paper_title = "", var/do_encode = TRUE)
	if(!check_functionality())
		return FALSE
	
	if(do_encode)
		text_to_print = html_encode(text_to_print)
		paper_title = html_encode(paper_title)

	var/obj/item/paper/P = new/obj/item/paper(holder.drop_location())

	// Damaged printer causes the resulting paper to be somewhat harder to read.
	if(damage > damage_malfunction)
		P.info = stars(text_to_print, 100-malfunction_probability)
	else
		P.info = text_to_print
	if(paper_title)
		P.name = paper_title
	P.update_icon()
	P.reload_fields()
	P = null
	return TRUE

/obj/item/computer_hardware/printer/proc/print_file(var/datum/computer_file/file)
	if(!check_functionality() || !file.can_print)
		return FALSE
	var/new_item = file.print(TRUE)
	if(new_item)
		return TRUE
	return FALSE

/obj/item/computer_hardware/printer/try_insert(obj/item/I, mob/living/user = null)
	var/obj/item/computer_hardware/hard_drive/hard_drive = holder.all_components[MC_HDD]
	if(istype(I, /obj/item/paper))
		var/datum/computer_file/text/new_text = new(I)
		if(!holder || !hard_drive || !hard_drive.can_store_file(new_text))
			to_chat(user, span_notice("ERROR: Not enough space on harddrive"))
			return FALSE
		hard_drive.store_file(new_text)
		to_chat(user, span_notice("You scan \the [I] with the [src]"))
		return TRUE
	else if(istype(I, /obj/item/photo))
		var/datum/computer_file/picture/new_picture = new(I)
		if(!holder || !hard_drive || !hard_drive.can_store_file(new_picture))
			to_chat(user, span_notice("ERROR: Not enough space on harddrive"))
			return FALSE
		hard_drive.store_file(new_picture)
		to_chat(user, span_notice("You scan \the [I] with the [src]"))
		return TRUE
	return FALSE

/obj/item/computer_hardware/printer/mini
	name = "miniprinter"
	desc = "A small printer with paper recycling module."
	power_usage = 50
	icon_state = "printer_mini"
	w_class = WEIGHT_CLASS_TINY
