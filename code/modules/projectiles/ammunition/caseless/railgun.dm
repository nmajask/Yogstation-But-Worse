/obj/item/ammo_casing/caseless/railgun // Baseline, high armor penitration and good damage. Deals damage to mech pilots and punches through walls though it, though doing so decreases the speed
	name = "railgun slug"
	desc = "More akin to a metal rod than a traditional slug, they are usually launched out of a railgun at high speeds."
	caliber = "railgun"
	icon_state = "railgun_slug"
	materials = list(/datum/material/iron=2000)
	projectile_type = /obj/item/projectile/bullet/railgun

/obj/item/ammo_casing/caseless/railgun/du // Better anti-armor but less straight up damage, looses less velocity punching through stuff
	name = "railgun depleated uranium slug"
	desc = "A slug made of extremely dense depleated uranium, making it much more effective at punching through armor and stuctures alike."
	icon_state = "railgun_du"
	projectile_type = /obj/item/projectile/bullet/railgun/du

/obj/item/ammo_casing/caseless/railgun/he // Trades penitrating objects for an explosive first impact
	name = "railgun high explosive slug"
	desc = "A slug tipped with explosives that detonates on impact."
	icon_state = "railgun_he"
	projectile_type = /obj/item/projectile/bullet/railgun/he

/obj/item/ammo_casing/caseless/railgun/pyro // Worse anti-armor and damage, but leaves a trail of fire as it moves
	name = "railgun pyrotechnic slug"
	desc = "A slug made of plasma that ignites anything in its path."
	icon_state = "railgun_pyro"
	projectile_type = /obj/item/projectile/bullet/railgun/pyro

/obj/item/ammo_casing/caseless/railgun/emp // Worse anti-armor and damage, but leaves a trail of emp as it moves
	name = "railgun emp slug"
	desc = "A slug that pulses whatever it hits with a electro magnetic effect, disruping or outright breaking some electronics."
	icon_state = "railgun_emp"
	projectile_type = /obj/item/projectile/bullet/railgun/emp

/obj/item/ammo_casing/caseless/railgun/heartpiercer // Deals more damage, deals slashing wounds, and damages organs of mobs it passes through, but has worse armor penitration
	name = "railgun heart piercer slug"
	desc = "An inisdious slug with razor sharp edges designed to cause havoc on the insides of a living being, though the blades decrease the peircing potenetial."
	icon_state = "railgun_heartpiercer"
	projectile_type = /obj/item/projectile/bullet/railgun/heartpiercer

/obj/item/ammo_casing/caseless/railgun/hardlight // Non-lethal alternative that functions like an percing disabler
	name = "railgun hardlight slug"
	desc = "A \"rod\" made of pure light somehow suspended as a solid, who knows. However it's done, this can easily disable people when hit at high speeds."
	icon_state = "railgun_hardlight"
	materials = list(/datum/material/glass=200, /datum/material/uranium=200)
	projectile_type = /obj/item/projectile/bullet/railgun/hardlight

/obj/item/ammo_casing/caseless/railgun/makeshift // Worse version of regular slugs that can be crafted by hand with rods
	name = "makeshift railgun slug"
	desc = "This kinda resembles a railgun slug, so lets shove one in and find out if it works!"
	icon_state = "railgun_makeshift"
	projectile_type = /obj/item/projectile/bullet/railgun/makeshift
	variance = 5

/obj/item/ammo_casing/caseless/railgun/micro // Weaker version
	name = "micro railgun slug"
	desc = "A smaller metal slug that those used in standard MARS railguns, these trade efficency for a lower ammount of force required to propel it allowing for more compact weapons."
	caliber = "railgun_micro"
	icon_state = "railgun_micro"
	materials = list(/datum/material/iron=1000)
	projectile_type = /obj/item/projectile/bullet/railgun/micro

/obj/item/ammo_casing/caseless/railgun/micro/hardlight // Non-lethal alternative for micro slugs
	name = "micro railgun hardlight slug"
	desc = "A smaller \"rod\" made of pure light somehow suspended as a solid, who knows. However it's done, this can easily disable people when hit at high speeds."
	icon_state = "railgun_micro_hardlight"
	materials = list(/datum/material/glass=100, /datum/material/uranium=100)
	projectile_type = /obj/item/projectile/bullet/railgun/micro/hardlight

/obj/item/ammo_casing/caseless/railgun/micro/makeshift // Worse version of micro slugs that can be crafted by cutting regular makeshift slugs
	name = "makeshift railgun slug"
	desc = "This kinda resembles a micro railgun slug, so lets shove one in and find out if it works!"
	icon_state = "railgun_micro_makeshift"
	projectile_type = /obj/item/projectile/bullet/railgun/micro/makeshift
	variance = 5
