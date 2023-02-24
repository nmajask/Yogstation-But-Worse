/obj/item/gun/ballistic/railgun
	name = "railgun"
	desc = "A MARS hybrid energy-ballistic gun made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_carbine"
	item_state = "railgun_carbine"
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/railgun
	bolt_wording = "bolt"
	cartridge_wording = "slug"
	bolt_type = BOLT_TYPE_NO_BOLT
	weapon_weight = WEAPON_MEDIUM
	special_mags = TRUE
	semi_auto = FALSE
	actions_types = list(/datum/action/item_action/toggle_charging)
	internal_magazine = TRUE
	load_sound = "sound/weapons/shotguninsert.ogg"
	rack_sound = "sound/weapons/sniper_rack.ogg"
	fire_sound = "sound/weapons/sniper_shot.ogg"
	knife_x_offset = 21
	knife_y_offset = 11
	empty_indicator = TRUE
	
	// Magnetic Charge Vars //
	/// Last recorded magnetic charge. Don't use this var, use get_magnetic_charge() instead as this isnt updated when charging.
	var/charge = 0
	/// If we wan't to try to charge the rails
	var/charging = TRUE
	/// When the current rail charging started, used to calculate charge and is reset when get_magnetic_charge() is called.
	var/charge_started
	/// How long it takes for the max magnetic charge to be reached.
	var/max_charge_time = 5 SECONDS
	/// Max magnetic charge that can be reached when not in hand, when unequipped the current charge is reduced to this if above.
	var/unequiped_max_charge = 0
	/// Speed that is given to a slug at max magnetic charge. Velocity given to the projectile is calculated with max_velocity * charge.
	var/max_velocity = 80
	/// Max magnetic charge that can be used per shot, useful for burst railguns so the first shot doesn't hog all the charge
	var/max_charge_per_shot = INFINITY
	/// Minimum magnetic charge that can be used per shot, so you don't shoot a slug with next to no velocity
	var/minimum_charge_shot = 20
	/// Timer for when the railgun is fully charged so it makes the noise
	var/fully_charged_timer_id

	// Battery Vars - AKA I love single inheritance //
	/// Cell for the charge
	var/obj/item/stock_parts/cell/cell = /obj/item/stock_parts/cell/upgraded/plus
	/// Energy required for a max charge shot
	var/energy_per_shot = 250 // Gives you 20 max charge shots with an upgraded+ cell

	// Overlay Vars //
	var/obj/effect/overlay/vis/magnetic_charge_overlay
	var/obj/effect/overlay/vis/magnetic_charge_emissive_overlay
	var/obj/effect/overlay/vis/full_magnetic_charge_overlay
	var/obj/effect/overlay/vis/full_magnetic_charge_emissive_overlay
	var/mutable_appearance/cell_charge_overlay

	// Sound Vars //
	var/full_charge_sound = 'sound/weapons/kenetic_reload.ogg'

/obj/item/gun/ballistic/railgun/Initialize()
	if(ispath(cell))
		cell = new cell(src)
	charge_started = world.time
	. = ..()

/obj/item/gun/ballistic/railgun/Destroy()
	if(cell)
		QDEL_NULL(cell)
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	if(cell_charge_overlay)
		QDEL_NULL(cell_charge_overlay)
	if(fully_charged_timer_id)
		deltimer(fully_charged_timer_id)
		fully_charged_timer_id = null
	return ..()

/obj/item/gun/ballistic/railgun/update_icon()
	. = ..()
	if(istype(cell))
		var/cell_overlay_state
		var/min_charge_for_shot = energy_per_shot * minimum_charge_shot * 0.01
		if(cell.charge < min_charge_for_shot)
			cell_overlay_state = "empty"
		else
			switch(round(cell.percent(), 0.1))
				if(75 to INFINITY)
					cell_overlay_state = "100"
				if(50 to 74.9)
					cell_overlay_state = "75"
				if(25 to 49.9)
					cell_overlay_state = "50"
				if(-INFINITY to 24.9)
					cell_overlay_state = "25"

		add_overlay("[overlay_icon_state ? overlay_icon_state : icon_state]_cellcharge_[cell_overlay_state]")
	
	get_magnetic_charge() // Handles creating the overlay and animating it

/obj/item/gun/ballistic/railgun/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/toggle_charging))
		get_magnetic_charge() // Need to update the carge first or the carge gained since we last updated will be lost
		set_charging()
	else
		..()

/obj/item/gun/ballistic/railgun/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))
		chambered = null //we empty the chamber
		if(severity == EMP_HEAVY)
			set_magnetic_charge(0)
			set_charging(FALSE)
		else
			set_magnetic_charge(get_magnetic_charge() * 0.5)
		update_icon()

/obj/item/gun/ballistic/railgun/get_cell()
	return cell

/// This handles calculating what charge we actualy have and setting up the next timer
/obj/item/gun/ballistic/railgun/proc/get_magnetic_charge()
	message_admins("GMC - WT: [world.time] - CS: [charge_started]") // DELME
	// We get the charge based on the change in time and dividing it by the time to max charge
	return adjust_magnetic_charge(((world.time - charge_started) / max_charge_time) * 100, update_charge = FALSE)

/// This handles setting the charge and manageing all that entails
/obj/item/gun/ballistic/railgun/proc/set_magnetic_charge(amt, force = FALSE)
	var/max_charge = get_max_magnetic_charge()
	charge = round(force ? amt : clamp(amt, 0, max_charge), 0.1)
	if(fully_charged_timer_id)
		deltimer(fully_charged_timer_id)
		fully_charged_timer_id = null
	setup_magnetic_charging()
	message_admins("A - [charge]") // DELME
	return charge

/// Calls set_magnetic_charge, but with the amt given added to the current charge
/obj/item/gun/ballistic/railgun/proc/adjust_magnetic_charge(amt, force = FALSE, update_charge = TRUE)
	return set_magnetic_charge((update_charge ? get_max_magnetic_charge() : charge) + amt, force)

/// Returns what the charge is currently capped at
/obj/item/gun/ballistic/railgun/proc/get_max_magnetic_charge()
	. = 100
	if(!istype(cell) || QDELETED(cell))
		return 0
	if(energy_per_shot && cell.charge < energy_per_shot)
		. = min(., (cell.charge / energy_per_shot) * 100)
	var/mob/holder = loc
	if(!istype(holder) || !holder.is_holding(src))
		. = min(., unequiped_max_charge)
		
/// This handles animating the overlay and setting up the timer
/obj/item/gun/ballistic/railgun/proc/setup_magnetic_charging()
	SSvis_overlays.remove_vis_overlay(src, list(magnetic_charge_overlay, magnetic_charge_emissive_overlay, full_magnetic_charge_overlay, full_magnetic_charge_emissive_overlay))
	if(!charging)
		return
	if(charge >= 100)
		full_magnetic_charge_overlay = SSvis_overlays.add_vis_overlay(src, icon, "[overlay_icon_state ? overlay_icon_state : icon_state]_charge_full", layer, plane, dir, unique = TRUE)
		full_magnetic_charge_emissive_overlay = SSvis_overlays.add_vis_overlay(src, icon, "[overlay_icon_state ? overlay_icon_state : icon_state]_charge_full", layer, EMISSIVE_PLANE, dir, unique = TRUE)
		return
	var/charge_percent = charge * 0.01
	var/max_charge_percent = get_max_magnetic_charge() * 0.01
	var/remaining_time = max_charge_time * (max_charge_percent - charge_percent)
	message_admins("Churg - CP: [charge_percent] - RT: [remaining_time]")
	magnetic_charge_overlay = SSvis_overlays.add_vis_overlay(src, icon, "[overlay_icon_state ? overlay_icon_state : icon_state]_charge", layer, plane, dir, round(255 * charge_percent), unique = TRUE)
	magnetic_charge_emissive_overlay = SSvis_overlays.add_vis_overlay(src, icon, "[overlay_icon_state ? overlay_icon_state : icon_state]_charge", layer, EMISSIVE_PLANE, dir, round(255 * charge_percent), unique = TRUE)
	animate(magnetic_charge_overlay, time = remaining_time, alpha = 255)
	animate(magnetic_charge_emissive_overlay, time = remaining_time, alpha = 255)
	if(charge_percent >= max_charge_percent)
		return
	charge_started = world.time
	fully_charged_timer_id = addtimer(CALLBACK(src, PROC_REF(on_full_charge)), remaining_time, TIMER_STOPPABLE | TIMER_DELETE_ME | TIMER_UNIQUE)
	
/// Called when the railgun should be fully charged
/obj/item/gun/ballistic/railgun/proc/on_full_charge()
	message_admins("Full") // DELME
	if(get_magnetic_charge() >= 100)
		message_admins("Check") // DELME
		playsound(src, full_charge_sound, 60, 1)

/// This handles changing the charging mode, replacing it with the new value or switching the current value if null
/obj/item/gun/ballistic/railgun/proc/set_charging(new_value)
	get_magnetic_charge() // Need to update the carge first or the carge gained since we last updated will be lost
	charging = new_value ? new_value : !charging
	
/obj/item/gun/ballistic/railgun/can_shoot()
	if(!..())
		return FALSE
		
	var/charge_to_use = min(get_magnetic_charge(), max_charge_per_shot)
	if(charge_to_use < minimum_charge_shot)
		return FALSE

	return  TRUE

/obj/item/gun/ballistic/railgun/before_firing(atom/target, mob/user)
	if(!istype(chambered) || !istype(chambered.BB, /obj/item/projectile/bullet/railgun))
		return
	
	var/obj/item/projectile/bullet/railgun/slug = chambered.BB
	if(!istype(slug))
		return
	
	var/magnetic_charge = get_magnetic_charge()
	var/charge_to_use = min(magnetic_charge, max_charge_per_shot)
	if(charge_to_use < minimum_charge_shot)
		return

	var/used_charge = magnetic_charge - adjust_magnetic_charge(-charge_to_use)
	message_admins("Used - used_charge: [used_charge] - charge_to_use: [charge_to_use]") // DELME
	cell.use(energy_per_shot * used_charge * 0.01)
	slug.set_velocity(max_velocity * used_charge * 0.01)

/obj/item/gun/ballistic/railgun/CtrlClick()
	if(loc == usr && usr.CanReach(src) && usr.canUseTopic(src))
		set_charging()
	else
		..()

/obj/item/gun/ballistic/railgun/equipped()
	. = ..()
	update_icon()

/obj/item/gun/ballistic/railgun/dropped()
	. = ..()
	update_icon()

/obj/item/gun/ballistic/railgun/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("charge")
			message_admins("VV: [set_magnetic_charge(var_value)]")
			return TRUE 
	. = ..()


// Subtypes

/obj/item/gun/ballistic/railgun/revolver // Long recharge time but can charge when unequipped, making it a good sidearm to swap into every once in a while.
	name = "\improper Lancer rail-revolver"
	desc = "A MARS hybrid energy-ballistic revolver made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots even when not held."
	icon_state = "railgun_revolver"
	item_state = "railgun_revolver"
	eject_sound = 'sound/weapons/revolverempty.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/railgun
	semi_auto = TRUE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	max_charge_time = 15 SECONDS
	unequiped_max_charge = 80
	max_velocity = 60
	knife_x_offset = 17
	knife_y_offset = 11
	var/spin_delay = 1 SECONDS

/obj/item/gun/ballistic/railgun/revolver/chamber_round(spin_cylinder = TRUE)
	if(spin_cylinder)
		chambered = magazine.get_round(TRUE)
		flick("[icon_state]_cycle", src)
	else
		chambered = magazine.stored_ammo[1]

/obj/item/gun/ballistic/railgun/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round(TRUE)

/obj/item/gun/ballistic/railgun/revolver/AltClick(mob/user)
	..()
	spin()

/obj/item/gun/ballistic/railgun/revolver/verb/spin()
	set name = "Spin Chamber"
	set category = "Object"
	set desc = "Click to spin your revolver's chamber."

	var/mob/M = usr

	if(M.stat || !in_range(M,src))
		return

	if(TIMER_COOLDOWN_CHECK(src, "spin_cooldown"))
		return
	TIMER_COOLDOWN_START(src, "spin_cooldown", spin_delay)

	if(do_spin())
		playsound(usr, "revolver_spin", 30, FALSE)
		usr.visible_message("[usr] spins [src]'s chamber.", span_notice("You spin [src]'s chamber."))
	else
		verbs -= /obj/item/gun/ballistic/revolver/verb/spin

/obj/item/gun/ballistic/railgun/revolver/proc/do_spin()
	var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
	. = istype(C)
	if(.)
		C.spin()
		chamber_round(FALSE)
		flick("[icon_state]_spin", src)

/obj/item/gun/ballistic/railgun/revolver/examine(mob/user)
	. = ..()
	. += "It can be spun with <b>alt+click</b>"

/obj/item/gun/ballistic/railgun/revolver/syndicate
	name = "syndicate rail-revolver"
	desc = "A crimson MARS hybrid energy-ballistic revolver made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held. This one has a self recharing cell inside."
	icon_state = "railgun_revolver_syndicate"
	overlay_icon_state = "railgun_revolver"
	item_state = "railgun_revolver_syndicate"
	cell = /obj/item/stock_parts/cell/syndicate

/obj/item/gun/ballistic/railgun/revolver/ert
	desc = "A blue MARS hybrid energy-ballistic revolver made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_revolver_ert"
	overlay_icon_state = "railgun_revolver"

/obj/item/gun/ballistic/railgun/revolver/micro
	name = "\improper Spear micro rail-revolver"
	desc = "A MARS hybrid energy-ballistic micro revolver made of two magnetically charged rails that propell a small rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots even when not held. This one has smaller, less effective components to reduice size."
	icon_state = "railgun_revolver_micro"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/railgun/micro
	w_class = WEIGHT_CLASS_SMALL
	max_charge_time = 5 SECONDS
	unequiped_max_charge = 100
	max_velocity = 80
	energy_per_shot = 500

/obj/item/gun/ballistic/railgun/revolver/micro/empty
	pin = null
	starting_mag_type = /obj/item/ammo_box/magazine/internal/cylinder/railgun/micro/empty

/obj/item/gun/ballistic/railgun/revolver/micro/prototype // For det?
	name = "prototype micro rail-revolver"
	max_velocity = 90

/obj/item/gun/ballistic/railgun/revolver/micro/prototype/empty
	pin = null
	starting_mag_type = /obj/item/ammo_box/magazine/internal/cylinder/railgun/micro/empty

/obj/item/gun/ballistic/railgun/revolver/micro/syndicate // Tator tot one
	name = "\improper syndicate micro rail-revolver"
	desc = "A MARS hybrid energy-ballistic micro revolver made of two magnetically charged rails that propell a small rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots even when not held. This one has smaller, less effective components to reduice size. This one has a self recharing cell inside."
	icon_state = "railgun_revolver_micro_syndicate"
	overlay_icon_state = "railgun_revolver_micro"
	item_state = "railgun_revolver_syndicate"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	max_velocity = 100
	cell = /obj/item/stock_parts/cell/syndicate

/obj/item/gun/ballistic/railgun/carbine // Can switch between single or three round burst, former offering better single shot accuracy and velocity while the latter allows for more volume. Good primary for mid-range with cover and backed up with close range sidearm. 
	name = "\improper Glave rail-carbine"
	desc = "A MARS hybrid energy-ballistic carbine made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	load_sound = "sound/weapons/sniper_mag_insert.ogg"
	bolt_type = BOLT_TYPE_STANDARD
	internal_magazine = FALSE
	semi_auto = TRUE
	mag_type = /obj/item/ammo_box/magazine/railgun
	actions_types = list(/datum/action/item_action/toggle_charging, /datum/action/item_action/toggle_firemode)
	burst_size = 3
	empty_alarm = TRUE
	mag_display_ammo = TRUE
	fire_delay = 0.25 SECONDS
	max_charge_per_shot = 30
	var/burst_on = TRUE

/obj/item/gun/ballistic/railgun/carbine/update_icon()
	..()
	if(burst_on)
		add_overlay("[overlay_icon_state ? overlay_icon_state : icon_state]_burst")
	else
		add_overlay("[overlay_icon_state ? overlay_icon_state : icon_state]_semi")

/obj/item/gun/ballistic/railgun/carbine/ui_action_click(mob/user, actiontype) // Fix this up, maybe make revolver spin cylinder an action
	if(istype(actiontype, /datum/action/item_action/toggle_firemode))
		burst_toggle()
	else
		..()

/obj/item/gun/ballistic/railgun/carbine/proc/burst_toggle()
	burst_on = !burst_on
	if(burst_on)
		burst_size = initial(burst_size)
		fire_delay = initial(fire_delay)
		max_charge_per_shot = initial(max_charge_per_shot)
		to_chat(usr, span_notice("You switch to [burst_size]-rnd burst."))
	else
		burst_size = 1
		fire_delay = 0
		max_charge_per_shot = INFINITY
		to_chat(usr, span_notice("You switch to semi-automatic."))
	update_icon()

/obj/item/gun/ballistic/railgun/carbine/syndicate
	name = "syndicate rail-carbine"
	desc = "A crimson MARS hybrid energy-ballistic carbine made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held. This one has a self recharing cell inside."
	icon_state = "railgun_carbine_syndicate"
	overlay_icon_state = "railgun_carbine"
	cell = /obj/item/stock_parts/cell/syndicate

/obj/item/gun/ballistic/railgun/carbine/ert
	desc = "A blue MARS hybrid energy-ballistic carbine made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_carbine_ert"
	overlay_icon_state = "railgun_carbine"

/obj/item/gun/ballistic/railgun/sniper // Offers the best single shot accuracy and speed, but the fire rite is awful. Best when combined with backup and a way to see people through walls for sniping.
	name = "\improper Pikeman sniper rail-lance"
	desc = "A massive MARS hybrid energy-ballistic lance made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_sniper"
	item_state = "railgun_sniper"
	load_sound = "sound/weapons/sniper_mag_insert.ogg"
	weapon_weight = WEAPON_HEAVY
	bolt_type = BOLT_TYPE_STANDARD
	internal_magazine = FALSE
	empty_alarm = TRUE
	mag_display_ammo = TRUE
	mag_type = /obj/item/ammo_box/magazine/railgun
	max_velocity = 100
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 5

/obj/item/gun/ballistic/railgun/sniper/syndicate
	name = "syndicate sniper rail-lance"
	desc = "A massive, crimson MARS hybrid energy-ballistic lance made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held. This one has a self recharing cell inside."
	icon_state = "railgun_sniper_syndicate"
	overlay_icon_state = "railgun_sniper"
	cell = /obj/item/stock_parts/cell/syndicate

/obj/item/gun/ballistic/railgun/sniper/ert
	desc = "A massive, crimson MARS hybrid energy-ballistic lance made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held. This one has a self recharing cell inside."
	icon_state = "railgun_sniper_syndicate"
	overlay_icon_state = "railgun_sniper"

/obj/item/gun/ballistic/railgun/lance // A weaker version of the standard revolver and sniper, this one aims to combine the weaknesses of both to make a weapon that isnt too powerful for crew to have. Functions like a heavy anti-armor gun that excells at fighting mech, though it is less effective against fast and unarmored targets due to the slow cooldown and lack of crowd control.
	name = "\improper Halberd rail-lance"
	desc = "A massive MARS hybrid energy-ballistic lance made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_lance"
	item_state = "railgun_lance"
	overlay_icon_state = "railgun_sniper"
	weapon_weight = WEAPON_HEAVY
	max_charge_time = 15 SECONDS
	max_velocity = 60

/obj/item/gun/ballistic/railgun/lance/empty // For crew to print out
	pin = null
	starting_mag_type = /obj/item/ammo_box/magazine/internal/railgun/empty

/obj/item/gun/ballistic/railgun/makeshift
	name = "makeshift railgun"
	desc = "A shoddy railgun made with scraps lying arround. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_makeshift"
	item_state = "railgun_makeshift"
	max_velocity = 40
	knife_x_offset = 17
	knife_y_offset = 10
	cell = null

/obj/item/gun/ballistic/railgun/makeshift/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stock_parts/cell))
		if(cell)
			to_chat(user, span_warning("There is already a cell in [src]!"))
			return ..()

		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("You cant stick \the [I] into [src]!"))
			return ..()
		
		to_chat(user, span_notice("You insert \the [cell] into [src]."))
		cell = I
		update_icon()
	else
		return ..()

/obj/item/gun/ballistic/railgun/revolver/AltClick(mob/user)
	if(cell)
		to_chat(user, span_notice("You remove \the [cell] from [src]."))
		cell.forceMove(drop_location())
		cell = null
		update_icon()
	return ..()

/obj/item/gun/ballistic/railgun/makeshift/CheckParts(list/parts_list)
	var/obj/item/stock_parts/cell/new_cell = locate() in parts_list
	if(new_cell)
		if(cell) // Already have a cell, lets put the new one on the ground
			new_cell.forceMove(drop_location())
		else
			new_cell.forceMove(drop_location())
	. = ..()

/obj/item/gun/ballistic/railgun/sword
	name = "railgun sword"
	desc = "A sword made of two blades that hold magnetic charge and shoot metal slugs. Has science gone too far?"
	icon_state = "railgun_sword"
	item_state = "railgun_sword"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	mag_type = /obj/item/ammo_box/magazine/internal/railgun/sword
	bolt_type = BOLT_TYPE_STANDARD
	force = 30
	throwforce = 7
	w_class = WEIGHT_CLASS_HUGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	armour_penetration = 75
	block_chance = 50
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/gun/ballistic/railgun/sword/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 15, 125, 0, hitsound)

/obj/item/gun/ballistic/railgun/sword/syndicate
	name = "syndicate railgun sword"
	desc = "A crimson sword made of two blades that hold magnetic charge and shoot metal slugs. Has science gone too far?"
	icon_state = "railgun_sword_syndicate"
	overlay_icon_state = "railgun_sword"
	cell = /obj/item/stock_parts/cell/syndicate
