/datum/computer_file/log
	filetype = "LOG"
	can_print = TRUE

	var/list/entries = list()
	var/max_entries = 999

/datum/computer_file/log/clone()
	var/datum/computer_file/log/temp = ..()
	temp.entries = entries.Copy()
	temp.max_entries = max_entries
	return temp

/datum/computer_file/log/calculate_size()
	size = entries.len * 0.1 + 0.5

/datum/computer_file/log/proc/addentry(var/string = "", var/time_override = null, var/overwrite = FALSE)
	if(!string)
		return
	if(!entries)
		entries = list()
		return
	if(entries.len >= max_entries)
		if(!overwrite)
			return
		entries.Cut(1,2)
	var/time = station_time_timestamp()
	if(time_override)
		time = time_override
	var/index = entries.len + 1
	entries += list(list("time" = time, "content" = string, "index" = index))
	calculate_size()

/datum/computer_file/log/proc/clear(var/log = TRUE)
	entries = list()
	if(log)
		addentry("Log cleared successfuly")
	calculate_size()

/datum/computer_file/log/proc/findbytime(var/time, var/return_all = FALSE)
	var/list/matches = list()
	for(var/list/entry in entries)
		if(entry["time"] == time)
			if(return_all)
				matches.Add(entry)
			else
				return entry
	return matches

/datum/computer_file/log/proc/formatentry(var/index)
	if(!index)
		return
	var/list/entry = entries[index]
	return "[entry["time"]] - [entry["content"]]"

/datum/computer_file/log/proc/formatfile(var/return_string = TRUE)
	var/data
	if(return_string)
		data = list()
	else
		data = ""
	for(var/list/entry in entries)
		if(return_string)
			data += "[entry["time"]] - [entry["content"]]<br>"
		else
			data += "[entry["time"]] - [entry["content"]]"
	return data

/datum/computer_file/log/print(var/drop = FALSE)
	var/obj/item/paper/new_paper
	if(drop)
		new_paper = new(holder.drop_location())
	else
		new_paper = new()

	new_paper.name = filename
	new_paper.info = formatfile()
	return new_paper
