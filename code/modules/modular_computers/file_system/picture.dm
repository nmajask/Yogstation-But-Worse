#define PICTUREFILE_GQ_PER_PIXEL 0.0005

/datum/computer_file/picture
	filetype = "PIC"
	file_icon = "file-image"
	can_print = TRUE

	var/datum/picture/stored_picture
	var/name
	var/description

/datum/computer_file/picture/New(var/based_item)
	..()
	if(istype(based_item, /obj/item/photo))
		store_photo(based_item)
	if(istype(based_item, /datum/picture))
		var/datum/picture/P = based_item
		stored_picture = P.Copy()
		calculate_size()

/datum/computer_file/picture/clone()
	var/datum/computer_file/picture/temp = ..()
	temp.stored_picture = stored_picture.Copy()
	return temp

// Calculates file size from amount of characters in saved string
/datum/computer_file/picture/calculate_size()
	if(stored_picture)
		var/pixels = stored_picture.psize_x * stored_picture.psize_x
		size = max(round(pixels * PICTUREFILE_GQ_PER_PIXEL), 1)

/datum/computer_file/picture/proc/store_photo(var/obj/item/photo/photo)
	if(photo.picture)
		stored_picture = photo.picture.Copy()
	name = photo.name
	description = photo.desc
	calculate_size()

/datum/computer_file/picture/print(var/drop = FALSE)
	var/obj/item/photo/new_photo
	if(drop)
		new_photo = new(holder.drop_location(), stored_picture, name, description, TRUE)
	else
		new_photo = new(null, stored_picture, name, description, TRUE)
	return new_photo

#undef PICTUREFILE_GQ_PER_PIXEL
