/datum/computer_file/text
	filetype = "TEX"
	file_icon = "file-alt"
	can_print = TRUE

	var/name = "New File"
	var/info = "" // What's prewritten on the paper. Appears first and is a special snowflake callback to how paper used to work.
	var/coloroverride // A hexadecimal as a string that, if set, overrides the font color of the whole document. Used by photocopiers
	var/datum/language/infolang // The language info is written in. If left NULL, info will default to being omnilingual and readable by all.
	var/list/written //What's written on the paper by people. Stores /datum/langtext values, plus plaintext values that mark where fields are.
	var/stamps		//The (text for the) stamps on the paper.
	var/fields = 0	//Amount of user created fields
	var/list/stamped

/datum/computer_file/text/New(var/based_item)
	..()
	if(istype(based_item, /obj/item/paper))
		store_paper(based_item)

/datum/computer_file/text/clone()
	var/datum/computer_file/text/temp = ..()
	temp.name = name
	temp.infolang = infolang
	temp.info += info + "</font>"
	temp.fields = fields
	temp.stamps = stamps
	if(stamped)
		temp.stamped = stamped.Copy()
	temp.info = written.Copy()
	return temp

/datum/computer_file/text/calculate_size()
	if(written)
		size = max(written.len, 1)

/datum/computer_file/text/proc/store_paper(var/obj/item/paper/paper)
	name = paper.name
	infolang = paper.infolang
	info += paper.info + "</font>"
	fields = paper.fields
	stamps = paper.stamps
	if(paper.stamped)
		stamped = paper.stamped.Copy()
	info = paper.written.Copy()
	calculate_size()

/datum/computer_file/text/print(var/drop = FALSE)
	var/obj/item/paper/new_paper
	if(drop)
		new_paper = new(holder.drop_location())
	else
		new_paper = new()

	new_paper.name = name
	new_paper.infolang = infolang
	new_paper.info += info + "</font>"
	new_paper.fields = fields
	new_paper.stamps = stamps
	new_paper.update_icon()
	new_paper.reload_fields()
	return new_paper
