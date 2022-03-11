//Skill Level Defines
#define SKILLLEVEL_UNSKILLED	1
#define SKILLLEVEL_BASIC		2
#define SKILLLEVEL_TRAINED		3
#define SKILLLEVEL_EXPERIENCED	4
#define SKILLLEVEL_MASTER		5

//Skill Difficulty Defines
#define SKILLDIF_EASY			1
#define SKILLDIF_MEDIUM			2
#define SKILLDIF_HARD			3

//Physical Skills
#define SKILL_STRENGTH			"Strength"
#define SKILL_DEXTERITY			"Dexterity"
#define SKILL_ENDURANCE			"Endurance"

//General Skills
#define SKILL_BOTANY			"Botany"
#define SKILL_COOKING			"Cooking"
#define SKILL_CREATIVITY		"Creativity"
#define SKILL_SURVIVAL			"Survival"
#define SKILL_PILOTING			"Piloting"
#define SKILL_LEADERSHIP		"Leadership"

//Security/Combat Skills
#define SKILL_FORENSICS			"Forensics"
#define SKILL_HAND_TO_HAND		"Hand-to-Hand"
#define SKILL_MELEE_WEAPONS		"Melee Weapons"
#define SKILL_RANGED_WEAPONS	"Ranged Weapons"

//Medical Skills
#define SKILL_MEDICINE			"Medicine"
#define SKILL_ANATOMY			"Anatomy"
#define SKILL_CHEMISTRY			"Chemistry"
#define SKILL_PHSYCHOLOGY		"Psychology"

//Science Skills
#define SKILL_DESIGN			"Design"
#define SKILL_IT				"Information Technology"
#define SKILL_BIOLOGY			"Biology"

//Engineer Skills
#define SKILL_MECHANICS			"Mechanics"
#define SKILL_ELECTRONICS		"Electronics"
#define SKILL_ATMOSPHERICS		"Atmospherics"

//Skills Catagory
#define SKILLCAT_PHYSICAL			"Physical"
#define SKILLCAT_GENERAL			"General"
#define SKILLCAT_COMBAT				"Combat"
#define SKILLCAT_MEDICAL			"Medical"
#define SKILLCAT_SCIENCE			"Science"
#define SKILLCAT_ENGINEERING		"Engineering"

GLOBAL_LIST_INIT(all_skill_ids, list(
	SKILL_STRENGTH,
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
	SKILL_IT,
	SKILL_BIOLOGY,
	SKILL_MECHANICS,
	SKILL_ELECTRONICS,
	SKILL_ATMOSPHERICS))

GLOBAL_LIST_INIT(all_skill_levels, list(
	SKILLLEVEL_UNSKILLED,
	SKILLLEVEL_BASIC,
	SKILLLEVEL_TRAINED,
	SKILLLEVEL_EXPERIENCED,
	SKILLLEVEL_MASTER))

GLOBAL_LIST_INIT(difficulty_to_text, list(
	SKILLDIF_EASY = "Easy",
	SKILLDIF_MEDIUM = "Medium",
	SKILLDIF_HARD = "Hard"))

GLOBAL_LIST_INIT(difficulty_to_color, list(
	SKILLDIF_EASY = "Good",
	SKILLDIF_MEDIUM = "Medium",
	SKILLDIF_HARD = "Bad"))

GLOBAL_LIST_INIT(skill_level_to_text, list(
	SKILLLEVEL_UNSKILLED = "Unskilled",
	SKILLLEVEL_BASIC = "Basic",
	SKILLLEVEL_TRAINED = "Trained",
	SKILLLEVEL_EXPERIENCED = "Experienced",
	SKILLLEVEL_MASTER = "Master"))

GLOBAL_LIST_INIT(skill_level_to_color, list(
	SKILLLEVEL_UNSKILLED = "red",
	SKILLLEVEL_BASIC = "orange",
	SKILLLEVEL_TRAINED = "yellow",
	SKILLLEVEL_EXPERIENCED = "green",
	SKILLLEVEL_MASTER = "slateblue"))

//Skill Procs, kinda self explainitory

/**
  * Finds the skillset datum of the target mind/mob/skill
  */
/proc/find_skillset(target)
	//If its a client, our actual target is the mob
	if(istype(target, /client))
		var/client/C = target
		target = C

	//Get the skillset from the mind
	if(istype(target, /datum/mind))
		var/datum/mind/M = target
		return M.get_skillset()

	//Alive mob, get it from the mind if possible
	if(isliving(target))
		var/mob/living/L = target
		return L.mind?.get_skillset()

	//If its a skill, get its parent
	if(istype(target, /datum/skill))
		var/datum/skill/S = target
		return S.parent

	//Maybe you just want to confirm its a skillset?
	if(istype(target, /datum/skillset))
		return target

	//No match
	return null

/**
  * Finds the skill datum of the given skill ID from the target mind/mob/skill
  */
/proc/find_skill(target, skill)
	var/results = find_skillset(target)
	if(istype(results, /datum/skillset))
		var/datum/skillset/target_skillset = results
		return target_skillset.get_skill(skill)
	return null

/**
  * Finds the skill level of the given skill ID from the target mind/mob/skill
  */
/proc/find_skill_level(target, skill)
	var/datum/skillset/target_skillset = find_skillset(target)
	if(target_skillset)
		return target_skillset.get_skill_level(skill)
	return null

/**
  * Checks if the target mind/mob/skill uses skills
  */
/proc/usesSkills(target)
	var/datum/skillset/target_skillset = find_skillset(target)
	return (target_skillset && target_skillset.use_skills == TRUE)

/**
  * Checks if the skill level of the given the target mind/mob/skill/skillset is greater than or equal to the required skill level
  * Also checks if the target uses skills, and returns the oposite of requires_skills if they dont
  */
/proc/skill_check(target, skill, required, requires_skills = FALSE)
	if(usesSkills(target))
		return find_skill_level(target, skill) >= required
	else
		return !requires_skills

#define GET_SKILLS(target) (find_skill(target))
#define SKILL_CHECK(target, skill, required) (find_skill_level(target, skill) >= required)
#define SKILL_INDEX(target, skill, list) (list?[find_skill_level(target, skill)])

