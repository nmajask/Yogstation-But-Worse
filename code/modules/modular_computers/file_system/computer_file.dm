/datum/computer_file
	// Placeholder. No spacebars
	var/filename = "NewFile"
	// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/filetype = "XXX"
	/// User-friendly name of this file.
	var/filedesc = "Unknown File"
	/// Short description of this file's function.
	var/extended_desc = "N/A"
	// File size in GQ. Integers only!
	var/size = 1											
	// Holder that contains this file.
	var/obj/item/computer_hardware/hard_drive/holder
	// Whether the file may be sent to someone via NTNet transfer or other means.
	var/unsendable = FALSE
	// Whether the file may be deleted. Setting to TRUE prevents deletion/renaming/etc.
	var/undeletable = FALSE
	// UID of this file
	var/uid
	var/static/file_uid = 0

	// File Downloading
	/// List of required accesses to *open* this program.
	var/required_access = null
	/// List of required access to download or file host the program
	var/transfer_access = null
	/// Category in the NTDownloader.
	var/category = PROGRAM_CATEGORY_MISC
	/// Whether the file can be downloaded from NTNet. Set to FALSE to disable.
	var/available_on_ntnet = FALSE
	/// Whether the file can be downloaded from SyndiNet (accessible via emagging the computer). Set to TRUE to enable.
	var/available_on_syndinet = FALSE

/datum/computer_file/New()
	..()
	uid = file_uid++

/datum/computer_file/Destroy()
	if(!holder)
		return ..()

	holder.remove_file(src)
	// holder.holder is the computer that has drive installed. If we are Destroy()ing program that's currently running kill it.
	if(holder.holder && holder.holder.active_program == src)
		holder.holder.kill_program(forced = TRUE)
	holder = null
	return ..()

// Returns independent copy of this file.
/datum/computer_file/proc/clone(rename = FALSE)
	var/datum/computer_file/temp = new type
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.size = size
	if(rename)
		temp.filename = filename + "(Copy)"
	else
		temp.filename = filename
	temp.filetype = filetype
	return temp
