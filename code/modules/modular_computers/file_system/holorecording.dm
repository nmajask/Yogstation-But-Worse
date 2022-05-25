/datum/computer_file/holorecord
	filetype = "REC"
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
/*
// Calculates file size from amount of characters in saved string
/datum/computer_file/holorecord/calculate_size()
	if(stored_picture)
		var/pixels = stored_picture.psize_x * stored_picture.psize_x
		size = max(round(pixels * PICTUREFILE_GQ_PER_PIXEL), 1)

/datum/computer_file/holorecord/proc/store_photo(var/obj/item/photo/photo)
	if(photo.picture)
		stored_picture = photo.picture.Copy()
	name = photo.name
	description = photo.desc
	calculate_size()
*/
