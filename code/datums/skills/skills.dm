GLOBAL_LIST_INIT(all_skill_paths, list(
	/datum/skill/strength,
	/datum/skill/dexterity,
	/datum/skill/endurance,
	/datum/skill/botany,
	/datum/skill/cooking,
	/datum/skill/creativity,
	/datum/skill/survival,
	/datum/skill/piloting,
	/datum/skill/leadership,
	/datum/skill/forensics,
	/datum/skill/hand_to_hand,
	/datum/skill/melee,
	/datum/skill/ranged,
	/datum/skill/medicine,
	/datum/skill/anatomy,
	/datum/skill/chemistry,
	/datum/skill/psychology,
	/datum/skill/design,
	/datum/skill/robotics,
	/datum/skill/biology,
	/datum/skill/mechanics,
	/datum/skill/it,
	/datum/skill/atmospherics))

GLOBAL_LIST_INIT(all_skill_ids, list(
	SKILL_STRENGHT,
	SKILL_DEXTERITY,
	SKILL_ENDURANCE,
	SKILL_BOTANY,
	SKILL_COOKING,
	SKILL_CREATIVITY,
	SKILL_SURVIVAL,
	SKILL_PILOTING,
	SKILL_LEADERSHIP,
	SKILL_FORENSICS,
	SKILL_HAND_TO_HAND,
	SKILL_MELEE_WEAPONS,
	SKILL_RANGED_WEAPONS,
	SKILL_MEDICINE,
	SKILL_ANATOMY,
	SKILL_CHEMISTRY,
	SKILL_PHSYCHOLOGY,
	SKILL_DESIGN,
	SKILL_ROBOTICS,
	SKILL_BIOLOGY,
	SKILL_MECHANICS,
	SKILL_IT,
	SKILL_ATMOSPHERICS))

GLOBAL_LIST_INIT(all_skill_levels, list(
	SKILLLEVEL_UNSKILLED,
	SKILLLEVEL_BASIC,
	SKILLLEVEL_TRAINED,
	SKILLLEVEL_EXPERIENCED,
	SKILLLEVEL_MASTER))

/datum/skill
	var/id
	var/name
	var/catagory
	var/icon = "question"
	var/desc
	var/current_level = SKILLLEVEL_UNSKILLED
	var/datum/skillset/parent
	var/list/level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")
	var/experience = 0
	var/difficulty = 1
	var/max_starting
	var/list/proficient_jobs

/datum/skill/New(var/datum/skillset/new_parent)
	..()
	parent = new_parent

//Skill Adjustment Procs
/datum/skill/proc/level_change(new_level, var/silent = FALSE)
	if(new_level > current_level && !silent)
		skill_increase()
	if(new_level < current_level && !silent)
		skill_decrease()

/datum/skill/proc/set_level(new_level, var/silent = FALSE)
	level_change(new_level, silent)
	current_level = new_level
	return current_level

/datum/skill/proc/adjust_level(change, var/silent = FALSE)
	var/new_level = current_level + change
	if(new_level > SKILLLEVEL_MASTER || new_level < SKILLLEVEL_UNSKILLED)
		return FALSE
	level_change(new_level, silent)
	current_level = new_level
	return TRUE

/datum/skill/proc/update_experience_level()
	switch(experience)
		if(8 * difficulty * 100 to INFINITY)
			current_level = SKILLLEVEL_MASTER
		if(4 * difficulty * 100 to 8 * difficulty * 100 )
			current_level = SKILLLEVEL_EXPERIENCED
		if(2 * difficulty * 100 to 4 * difficulty * 100)
			current_level = SKILLLEVEL_TRAINED
		if(difficulty * 100 to 2 * difficulty * 100)
			current_level = SKILLLEVEL_BASIC
		else
			current_level = SKILLLEVEL_UNSKILLED

//Caulculation Procs
/datum/skill/proc/find_active_difficulty(var/job = null)
	var/J = job
	var/active_difficulty = difficulty
	if(isnull(J) && !isnull(parent))
		var/datum/mind/owner = parent.owner
		J = owner.assigned_role
	for(var/current_job in proficient_jobs)
		if(!isnull(J) && J == job && active_difficulty > 1)
			active_difficulty -= 1
	
	return active_difficulty

/datum/skill/proc/get_cost(level, var/job = null)
	var/active_difficulty = find_active_difficulty(job)
	switch(level)
		if(SKILLLEVEL_UNSKILLED)
			return 0
		if(SKILLLEVEL_BASIC)
			return active_difficulty
		if(SKILLLEVEL_TRAINED, SKILLLEVEL_EXPERIENCED)
			return 2 * active_difficulty
		if(SKILLLEVEL_MASTER)
			return 3 * active_difficulty
		else
			return 0

//Text Procs
/datum/skill/proc/skill_increase()
	to_chat(parent.owner,"<span class='notice'> You fell more capable than before.")

/datum/skill/proc/skill_decrease()
	to_chat(parent.owner,"<span class='notice'> You fell less capable than before.")

/datum/skill/strength
	id = SKILL_STRENGHT
	name = "Strength"
	catagory = ""
	icon = "box"
	desc = "How good you are at lifting, pushing, or carrying heavy objects."
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "You have done few physical tasks in your life, with underdeveloped arm muscles as a result.",
							SKILLLEVEL_BASIC		= "You can and have performed simple tasks, able to do any basic action using your unimpressive arms.",
							SKILLLEVEL_TRAINED		= "Your body, through continuous work, is able to handle heavier loads better than the average person.",
							SKILLLEVEL_EXPERIENCED	= "Exercise finds its way into your schedule with ease; you are an intimidating figure with immense muscles that forcefully manipulate objects with ease.",
							SKILLLEVEL_MASTER		= "Your body has reached its limits— veins and sheer prowess bulging from your figure with every motion. Woe to whatever finds itself at the mercy of your legendary power.")

/datum/skill/dexterity
	id = SKILL_DEXTERITY
	name = "Dexterity"
	catagory = ""
	icon = "running"
	desc = "How good you are at quickly and accurately moving yourself and your limbs."
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/endurance
	id = SKILL_ENDURANCE
	name = "Endurance"
	catagory = ""
	icon = "heart"
	desc = "How good you are at tanking through hits and resisting chemicals and alcohol."
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/botany
	id = SKILL_BOTANY
	name = "Botany"
	catagory = ""
	icon = "seedling"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/cooking
	id = SKILL_COOKING
	name = "Cooking"
	catagory = ""
	icon = "apple-alt"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/creativity
	id = SKILL_CREATIVITY
	name = "Creativity"
	catagory = ""
	icon = "lightbulb"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/survival
	id = SKILL_SURVIVAL
	name = "Survival"
	catagory = ""
	difficulty = 2
	icon = "campground"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/piloting
	id = SKILL_PILOTING
	name = "Piloting"
	catagory = ""
	difficulty = 2
	icon = "rocket"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/leadership
	id = SKILL_LEADERSHIP
	name = "Leadership"
	catagory = ""
	difficulty = 3
	icon = "bullhorn"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/forensics
	id = SKILL_FORENSICS	
	name = "Forensics"
	catagory = ""
	difficulty = 3
	icon = "search"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/hand_to_hand
	id = SKILL_HAND_TO_HAND
	name = "Hand-to-Hand"
	catagory = ""
	difficulty = 2
	icon = "fist-raised"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/melee
	id = SKILL_MELEE_WEAPONS	
	name = "Melee Weapons"
	catagory = ""
	difficulty = 2
	icon = "toolbox"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/ranged
	id = SKILL_RANGED_WEAPONS
	name = "Ranged Weapons"
	catagory = ""
	difficulty = 2
	icon = "crosshairs"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/medicine
	id = SKILL_MEDICINE
	name = "Medicine"
	catagory = ""
	difficulty = 2
	icon = "first-aid"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/anatomy
	id = SKILL_ANATOMY
	name = "Anatomy"
	catagory = ""
	difficulty = 3
	icon = "x-ray"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/chemistry
	id = SKILL_CHEMISTRY
	name = "Chemistry"
	catagory = ""
	difficulty = 3
	icon = "flask"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/psychology
	id = SKILL_PHSYCHOLOGY
	name = "Psychology"
	catagory = ""
	difficulty = 2
	icon = "brain"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/design
	id = SKILL_DESIGN
	name = "Design"
	catagory = ""
	difficulty = 3
	icon = "pencil-ruler"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/robotics
	id = SKILL_ROBOTICS
	name = "Robotics"
	catagory = ""
	icon = "robot"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/biology
	id = SKILL_BIOLOGY
	name = "Biology"
	catagory = ""
	icon = "dna"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/mechanics
	id = SKILL_MECHANICS
	name = "Mechanics"
	catagory = ""
	icon = "tools"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/it
	id = SKILL_IT
	name = "Information Technology"
	catagory = ""
	icon = "microchip"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/atmospherics
	id = SKILL_ATMOSPHERICS
	name = "Atmospherics"
	icon = "cloud"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")
