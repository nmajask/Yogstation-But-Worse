/**
  * A datum containing the information about a specific skills
  */
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
	var/list/level_base_cost = list(
							SKILLLEVEL_UNSKILLED	= 0,
							SKILLLEVEL_BASIC		= 1,
							SKILLLEVEL_TRAINED		= 2,
							SKILLLEVEL_EXPERIENCED	= 2,
							SKILLLEVEL_MASTER		= 3)
	var/difficulty = 1
	var/max_starting
	var/list/proficient_jobs

/datum/skill/New(var/datum/skillset/new_parent)
	..()
	parent = new_parent

/**
  * Copies the skill data to a current/new skill
  */
/datum/skill/proc/Copy(var/datum/skill/new_skill, var/datum/skillset/new_parent)
	if(isnull(new_skill))
		new_skill = new()
	if(!isnull(new_skill))
		new_skill.parent = new_parent
	new_skill.set_level(current_level, TRUE)
	return new_skill

//Skill Adjustment Procs
/datum/skill/proc/level_change(new_level)
	if(new_level > current_level)
		skill_increase()
	if(new_level < current_level)
		skill_decrease()

/datum/skill/proc/set_level(new_level, var/silent = FALSE)
	if(!silent)
		level_change(new_level)
	current_level = new_level
	return current_level

/datum/skill/proc/adjust_level(change, var/silent = FALSE)
	var/new_level = current_level + change
	if(new_level > SKILLLEVEL_MASTER || new_level < SKILLLEVEL_UNSKILLED)
		return
	return set_level(new_level, silent)

//Caulculation Procs
/datum/skill/proc/find_active_difficulty(job)
	var/J = job
	var/active_difficulty = difficulty
	if(isnull(J) && !isnull(parent))
		var/datum/mind/owner = parent.owner
		J = owner.assigned_role
	if(J in proficient_jobs && active_difficulty > 1)
		active_difficulty -= 1
	
	return active_difficulty

/datum/skill/proc/get_cost(level, job)
	var/active_difficulty = find_active_difficulty(job)
	if(!level)
		level = current_level
	return level_base_cost[level] * active_difficulty

/datum/skill/proc/get_full_cost(var/level, var/job = null)
	var/total = 0
	if(isnull(level))
		level = current_level
	for(var/skilllevel in GLOB.all_skill_levels)
		if(skilllevel <= level)
			total += get_cost(skilllevel, job)
	return total

//Text Procs
/datum/skill/proc/skill_increase()
	if(parent)
		to_chat(parent.owner, span_notice("You feel more capable at [name] than before."))

/datum/skill/proc/skill_decrease()
	if(parent)
		to_chat(parent.owner, span_warning("You feel less capable at [name] than before."))

/datum/skill/proc/incapable_text()
	if(parent)
		to_chat(parent.owner, span_warning("You dont know how to do this as you lack the knowledge in [name]."))

/datum/skill/proc/proficient_text()
	if(parent)
		to_chat(parent.owner, span_notice("You quickly preform the task due to your knowledge in [name]."))

/datum/skill/proc/struggle_text()
	if(parent)
		to_chat(parent.owner, span_warning("You struggle as you lack the knowledge in [name]."))

/datum/skill/strength
	id = SKILL_STRENGTH
	name = "Strength"
	catagory = SKILLCAT_PHYSICAL
	icon = "box"
	desc = "How good you are at lifting, pushing, or carrying heavy objects."
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "You have done few physical tasks in your life, with underdeveloped arm muscles as a result.",
							SKILLLEVEL_BASIC		= "You can and have performed simple tasks, able to do any basic action using your unimpressive arms.",
							SKILLLEVEL_TRAINED		= "Your body, through continuous work, is able to handle heavier loads better than the average person.",
							SKILLLEVEL_EXPERIENCED	= "Exercise finds its way into your schedule with ease; you are an intimidating figure with immense muscles that forcefully manipulate objects with ease.",
							SKILLLEVEL_MASTER		= "Your body has reached its limits— veins and sheer prowess bulging from your figure with every motion. Woe to whatever finds itself at the mercy of your legendary power.")

/datum/skill/strength/incapable_text()
	if(parent)
		to_chat(parent.owner, span_warning("You dont know how to do this as you lack the knowledge in [name]."))

/datum/skill/strength/proficient_text()
	if(parent)
		to_chat(parent.owner, span_notice("You quickly preform the task due to your knowledge in [name]."))

/datum/skill/strength/struggle_text()
	if(parent)
		to_chat(parent.owner, span_warning("You struggle as you are not strong enough."))

/datum/skill/dexterity
	id = SKILL_DEXTERITY
	name = "Dexterity"
	catagory = SKILLCAT_PHYSICAL
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
	catagory = SKILLCAT_PHYSICAL
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
	catagory = SKILLCAT_GENERAL
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
	catagory = SKILLCAT_GENERAL
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
	catagory = SKILLCAT_GENERAL
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
	catagory = SKILLCAT_GENERAL
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
	catagory = SKILLCAT_GENERAL
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
	catagory = SKILLCAT_GENERAL
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
	catagory = SKILLCAT_COMBAT
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
	catagory = SKILLCAT_COMBAT
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
	catagory = SKILLCAT_COMBAT
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
	catagory = SKILLCAT_COMBAT
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
	catagory = SKILLCAT_MEDICAL
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
	catagory = SKILLCAT_MEDICAL
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
	catagory = SKILLCAT_MEDICAL
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
	catagory = SKILLCAT_MEDICAL
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
	catagory = SKILLCAT_SCIENCE
	difficulty = 3
	icon = "pencil-ruler"
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
	catagory = SKILLCAT_SCIENCE
	icon = "microchip"
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
	catagory = SKILLCAT_SCIENCE
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
	catagory = SKILLCAT_ENGINEERING
	icon = "tools"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")

/datum/skill/electronics
	id = SKILL_ELECTRONICS
	name = "Electronics"
	catagory = SKILLCAT_ENGINEERING
	icon = "bolt"
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
	catagory = SKILLCAT_ENGINEERING
	icon = "cloud"
	desc = "TODO"
	level_descriptions = list(
							SKILLLEVEL_UNSKILLED	= "Unskilled Description",
							SKILLLEVEL_BASIC		= "Basic Description",
							SKILLLEVEL_TRAINED		= "Trained Description",
							SKILLLEVEL_EXPERIENCED	= "Experienced Description",
							SKILLLEVEL_MASTER		= "Master Description")
