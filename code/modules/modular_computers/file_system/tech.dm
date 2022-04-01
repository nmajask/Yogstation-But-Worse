// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/node
	filetype = "NRN"	// Nanotrasen Research Technology Node Format
	var/datum/techweb_node/stored_node

/datum/computer_file/node/New(var/datum/techweb_node/new_node)
	..()
	stored_node = new_node

/datum/computer_file/node/clone()
	var/datum/computer_file/node/temp = ..()
	temp.stored_node = stored_node
	return temp



/datum/computer_file/design
	filetype = "NRD"	// Nanotrasen Research Design Format, also funny nerd file
	var/datum/design/stored_design

/datum/computer_file/design/New(var/datum/design/new_design)
	..()
	stored_design = new_design

/datum/computer_file/design/clone()
	var/datum/computer_file/design/temp = ..()
	temp.stored_design = stored_design
	return temp

	

/datum/computer_file/mutation
	filetype = "CHM"	// Chimeric DNA Technologies Mutation Format
	var/datum/mutation/human/stored_mutation

/datum/computer_file/mutation/New(var/datum/techweb_node/new_mutation)
	..()
	stored_mutation = new_mutation

/datum/computer_file/mutation/clone()
	var/datum/computer_file/mutation/temp = ..()
	temp.stored_mutation = stored_mutation
	return temp

	

/datum/computer_file/surgery
	filetype = "BCS"	// Blue Cross Medical Surgical Data Format
	var/datum/surgery/stored_surgery

/datum/computer_file/surgery/New(var/datum/techweb_node/new_surgery)
	..()
	stored_surgery = new_surgery

/datum/computer_file/surgery/clone()
	var/datum/computer_file/surgery/temp = ..()
	temp.stored_surgery = stored_surgery
	return temp
