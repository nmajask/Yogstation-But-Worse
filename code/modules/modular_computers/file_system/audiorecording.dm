/*
/datum/computer_file/audiorecord
	filetype = "AUD"
	file_icon = "file-video"
	var/datum/holorecord/recording

/datum/computer_file/holorecord/New(based_item)
	..()
	if(istype(based_item, /datum/holorecord))
		var/datum/holorecord/R = based_item
		recording = R.Copy()
		calculate_size()

/datum/computer_file/holorecord/clone()
	var/datum/computer_file/holorecord/temp = ..()
	temp.recording = recording.Copy()
	return temp

// Calculates file size from amount of characters in saved string
/datum/computer_file/holorecord/calculate_size()
	if(stored_picture)
		var/pixels = stored_picture.psize_x * stored_picture.psize_x
		size = max(round(pixels * PICTUREFILE_GQ_PER_PIXEL), 1)

/datum/computer_file/text/print(var/drop = FALSE)
	var/obj/item/paper/new_paper
	if(drop)
		new_paper = new(holder.drop_location())
	else
		new_paper = new()

	new_paper.name = "paper- 'Transcript'"
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i = 1, mytape.storedinfo.len >= i, i++)
		t1 += "[mytape.storedinfo[i]]<BR>"
	new_paper.info = t1
	new_paper.update_icon()
	return new_paper
*/
