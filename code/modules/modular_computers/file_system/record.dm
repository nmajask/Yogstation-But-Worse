/datum/computer_file/record
	filetype = "REC"

	var/datum/data/record/stored_record

/datum/computer_file/record/calculate_size()
	if(stored_record)
		size = max(stored_record.fields.len, 1)
