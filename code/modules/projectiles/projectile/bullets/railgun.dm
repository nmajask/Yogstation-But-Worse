/obj/item/projectile/bullet/railgun
	name = "railgun slug"
	icon_state = "gauss"
	speed = 0.1
	damage = 20
	armour_penetration = 40
	dismemberment = 20
	penetrating = TRUE
	penetration_type = 2
	var/velocity = 0
	var/minimum_velocity = 0
	var/velocityloss_mob = 10
	var/velocityloss_obj = 5
	var/velocityloss_turf = 5
	var/velocityloss_air_resistance = 0.01
	var/hit_mech_pilots = TRUE
	var/max_extra_damage = 50
	var/max_extra_ap = 40
	var/max_extra_dismemberment = 40
	var/max_extra_stamina = 0

/obj/item/projectile/bullet/railgun/on_hit(atom/target, blocked = 0)
	. = ..()
	if(!.)
		return
	if(ismob(target))
		set_velocity(velocity - velocityloss_mob)
	else if(isobj(target))
		set_velocity(velocity - velocityloss_obj)
	else if(isturf(target))
		set_velocity(velocity - velocityloss_turf)

/obj/item/projectile/bullet/railgun/Move()
	. = ..()
	var/turf/location = get_turf(src)
	if(!location)
		return
	var/datum/gas_mixture/gasses = location.return_air()
	if(!gasses)
		return
	var/presure = gasses.return_pressure()
	if(!presure)
		return
	set_velocity(velocity - (velocityloss_air_resistance * presure))
	
/*
/obj/item/projectile/bullet/railgun/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE)
	. = ..()
	if(!hit_mech_pilots || !istype(target, /obj/mecha))
		return 
	var/obj/mecha/mech = target
	var/mob/living/carbon/occupant = mech.occupant
	if(!istype(occupant))
*/

/obj/item/projectile/bullet/railgun/proc/set_velocity(new_veleocity)
	if(minimum_velocity >= new_veleocity)
		qdel(src)
		return
	velocity = new_veleocity
	var/velocity_mod = velocity * 0.01
	damage = CEILING(initial(damage) + (max_extra_damage * velocity_mod), 0.1)
	armour_penetration = CEILING(initial(armour_penetration) + (max_extra_ap * velocity_mod), 0.1)
	dismemberment = CEILING(initial(dismemberment) + (max_extra_dismemberment * velocity_mod), 0.1)
	stamina = CEILING(initial(stamina) + (max_extra_stamina * velocity_mod), 0.1)

/obj/item/projectile/bullet/railgun/du
	name = "railgun depleated uranium slug"
	damage = 15
	armour_penetration = 50
	dismemberment = 30
	velocityloss_mob = 5
	velocityloss_obj = 3
	velocityloss_turf = 3
	max_extra_damage = 35
	max_extra_ap = 50
	max_extra_dismemberment = 50

/obj/item/projectile/bullet/railgun/he
	name = "railgun high explosive slug"
	damage = 30
	armour_penetration = 20
	dismemberment = 0
	penetrating = FALSE
	velocityloss_mob = 0
	velocityloss_obj = 0
	velocityloss_turf = 0
	max_extra_damage = 10
	max_extra_ap = 10
	max_extra_dismemberment = 0

/obj/item/projectile/bullet/railgun/he/on_hit(atom/target, blocked = FALSE)
	..()
	if(!isliving(target)) //if the target isn't alive, so is a wall or something
		explosion(target, 0, 1, 2, 4)
	else
		explosion(target, 0, 0, 2, 4)
	return BULLET_ACT_HIT

/obj/item/projectile/bullet/railgun/pyro
	name = "railgun pyrotechnic slug"
	damage = 15
	armour_penetration = 35
	dismemberment = 0
	velocityloss_mob = 15
	velocityloss_obj = 7
	velocityloss_turf = 7
	max_extra_damage = 35
	max_extra_ap = 35
	max_extra_dismemberment = 0
	var/fire_stacks = 1
	var/hotspot_temp = 200
	var/max_extra_fire_stacks = 4
	var/max_extra_temp = 600

/obj/item/projectile/bullet/railgun/pyro/set_velocity(new_veleocity)
	..()
	var/velocity_mod = velocity * 0.01
	fire_stacks = CEILING(initial(fire_stacks) + (max_extra_fire_stacks * velocity_mod), 0.1)
	fire_stacks = CEILING(initial(hotspot_temp) + (max_extra_temp * velocity_mod), 0.1)

/obj/item/projectile/bullet/railgun/pyro/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()

/obj/item/projectile/bullet/railgun/pyro/Move()
	. = ..()
	var/turf/location = get_turf(src)
	if(location)
		new /obj/effect/hotspot(location)
		location.hotspot_expose(hotspot_temp, 50, 1)

/obj/item/projectile/bullet/railgun/emp
	name = "railgun emp slug"
	damage = 15
	armour_penetration = 35
	dismemberment = 0
	velocityloss_mob = 15
	velocityloss_obj = 7
	velocityloss_turf = 7
	max_extra_damage = 35
	max_extra_ap = 35
	max_extra_dismemberment = 0

/obj/item/projectile/bullet/railgun/emp/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!isturf(target))
		empulse(target, 0.5, 1)

/obj/item/projectile/bullet/railgun/emp/Move()
	. = ..()
	var/turf/location = get_turf(src)
	if(location)
		empulse(location, 0, 1)

/obj/item/projectile/bullet/railgun/heartpiercer
	name = "railgun heart piercer slug"
	icon_state = "gauss"
	armour_penetration = 20
	velocityloss_mob = 5
	velocityloss_obj = 10
	velocityloss_turf = 10
	hit_mech_pilots = FALSE
	max_extra_ap = 20
	var/organ_damage = 10
	var/max_extra_organ_damage = 90

/obj/item/projectile/bullet/railgun/heartpiercer/set_velocity(new_veleocity)
	..()
	organ_damage = CEILING(initial(organ_damage) + (max_extra_organ_damage * velocity * 0.01), 0.1)

/obj/item/projectile/bullet/railgun/heartpiercer/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/pierced = target
		var/list/organs = pierced.getorganszone(def_zone, TRUE)
		var/obj/item/organ/organ = pick(organs)
		organ.applyOrganDamage(organ_damage)

/obj/item/projectile/bullet/railgun/hardlight
	name = "railgun hardlight slug"
	damage = 0
	stamina = 40
	armour_penetration = 0 // Doesn't matter in this case
	dismemberment = 0
	hit_mech_pilots = TRUE
	max_extra_damage = 0
	max_extra_ap = 0
	max_extra_dismemberment = 0
	max_extra_stamina = 60

/obj/item/projectile/bullet/railgun/makeshift
	name = "makeshift railgun slug"
	damage = 0
	armour_penetration = -20
	dismemberment = 0
	hit_mech_pilots = FALSE
	max_extra_damage = 40
	max_extra_ap = 60
	max_extra_dismemberment = 0


// Micro Slugs

/obj/item/projectile/bullet/railgun/micro
	name = "micro railgun slug"
	icon_state = "gaussweak"
	damage = 10
	armour_penetration = 20
	dismemberment = 0
	penetrating = TRUE
	velocityloss_mob = 100
	velocityloss_obj = 20
	velocityloss_turf = 20
	velocityloss_air_resistance = 0.04
	hit_mech_pilots = FALSE
	max_extra_damage = 10
	max_extra_ap = 20
	max_extra_dismemberment = 5

/obj/item/projectile/bullet/railgun/micro/hardlight
	name = "micro railgun hardlight slug"
	damage = 0
	stamina = 20
	armour_penetration = 0 // Doesn't matter in this case
	dismemberment = 0
	max_extra_damage = 0
	max_extra_ap = 0
	max_extra_dismemberment = 0
	max_extra_stamina = 20

/obj/item/projectile/bullet/railgun/micro/makeshift
	name = "makeshift micro railgun slug"
	damage = 0
	armour_penetration = -40
	max_extra_damage = 15
	max_extra_ap = 30
	max_extra_dismemberment = 0
