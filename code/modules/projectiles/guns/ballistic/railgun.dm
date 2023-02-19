/obj/item/gun/ballistic/railgun
	name = "railgun"
	desc = "A MARS hybrid energy-ballistic gun made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_carbine"
	item_state = "railgun_carbine"
	mag_type = /obj/item/ammo_box/magazine/internal/railgun
	bolt_wording = "bolt"
	bolt_type = BOLT_TYPE_NO_BOLT
	semi_auto = FALSE
	internal_magazine = TRUE
	load_sound = "sound/weapons/shotguninsert.ogg"
	rack_sound = "sound/weapons/sniper_rack.ogg"
	knife_x_offset = 21
	knife_y_offset = 11
	empty_indicator = TRUE
	
	// Magnetic Charge Vars //
	/// Last recorded magnetic charge. Don't use this var, use get_magnetic_charge() instead as this isnt updated when charging.
	var/charge
	/// If we wan't to try to charge the rails
	var/charging
	/// When the current rail charging started, used to calculate charge and is reset when get_magnetic_charge() is called.
	var/charge_started
	/// How long it takes for the max magnetic charge to be reached.
	var/max_charge_time = 5 SECONDS
	/// Max magnetic charge that can be reached when not in hand, when unequipped the current charge is reduced to this if above.
	var/unequiped_max_charge = 0
	/// Speed that is given to a slug at max magnetic charge. Velocity given to the projectile is calculated with max_velocity * charge.
	var/max_velocity = 80
	/// Max magnetic charge that can be used per shot, useful for burst railguns so the first shot doesn't hog all the charge
	var/max_carge_per_shot = INFINITY
	/// Minimum magnetic charge that can be used per shot, useful for burst railguns so the first shot doesn't hog all the charge
	var/minimum_charge_shot = 5
	/// Timer for when the railgun is fully charged so it makes the noise
	var/fully_charged_timer

	// Battery Vars - AKA I love single inheritance //
	/// Cell for the charge
	var/obj/item/stock_parts/cell/cell = /obj/item/stock_parts/cell/upgraded/plus
	/// Energy required for a max charge shot
	var/energy_per_shot = 250 // Gives you 20 max charge shots with an upgraded+ cell

	// Overlay Vars //
	var/mutable_appearance/magnetic_charge_overlay
	var/mutable_appearance/cell_charge_overlay

/obj/item/gun/ballistic/railgun/Initialize()
	if(ispath(cell))
		cell = new cell(src)
	. = ..()

/obj/item/gun/ballistic/railgun/Destroy()
	if (cell)
		QDEL_NULL(cell)
	return ..()

/obj/item/gun/ballistic/railgun/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))
		chambered = null //we empty the chamber
		recharge_newshot() //and try to charge a new shot
		update_icon()

/obj/item/gun/ballistic/railgun/get_cell()
	return cell

/// This handles calculating what charge we actualy have and setting up the next timer
/obj/item/gun/ballistic/railgun/proc/get_magnetic_charge()
	// If we aren't charging, then there is no need to proccess all of this
	if(!charging)
		return charge

	var/max_charge = get_max_magnetic_charge()

	// If we are already at or bellow the cap, min it and return early
	if(max_charge <= charge)
		charge = min(charge, max_charge)
		return charge

	// If there is no charge time, then just set the carge to the max it can be to save time
	if(!max_charge_time)
		charge = max_charge
		return charge

	// We get the charge based on the change in time and dividing it by the time to max charge
	var/charge_increase = min(max_charge_time ? (world.time - charge_started) / max_charge_time : 100, 100)
	message_admins("A - [charge_increase]") // DELME
	charge = round(clamp(charge_increase, 0, max_charge), 0.1)
	if(charge < max_charge)
		setup_magnetic_charging()
	return charge

/// Returns what the charge is currently capped at
/obj/item/gun/ballistic/railgun/proc/get_max_magnetic_charge()
	. = 100
	if(!istype(cell) || QDELETED(cell))
		return 0
	if(energy_per_shot && cell.charge < energy_per_shot)
		. = min(., energy_per_shot / energy_per_shot)
	var/mob/holder = loc
	if(!holder?.is_holding(src))
		. = min(., unequiped_max_charge)
		

/// This handles animating the overlay and setting up the timer
/obj/item/gun/ballistic/railgun/proc/setup_magnetic_charging()
	if(!magnetic_charge_overlay)
		magnetic_charge_overlay = new mutable_appearance(icon, "[icon_state]_charge")
	magnetic_charge_overlay.alpha =  255 * charge
	animate(magnetic_charge_overlay, alpha)
	
/obj/item/gun/ballistic/railgun/can_shoot()
	return ..() && get_magnetic_charge() >= minimum_charge_shot


// Subtypes

/obj/item/gun/ballistic/railgun/revolver // Long recharge time but can charge when unequipped, making it a good sidearm to swap into every once in a while.
	name = "\improper Lancer rail-revolver"
	desc = "A MARS hybrid energy-ballistic revolver made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots even when not held."
	icon_state = "railgun_revolver"
	item_state = "railgun_revolver"
	max_charge_time = 15 SECONDS
	unequiped_max_charge = 80
	max_velocity = 60
	knife_x_offset = 17
	knife_y_offset = 11

/obj/item/gun/ballistic/railgun/carbine // Can switch between single or three round burst, former offering better single shot accuracy and speed while the latter allows for more volume. Good primary for mid-range with cover and backed up with close range sidearm. 
	name = "\improper Glave rail-carbine"
	desc = "A MARS hybrid energy-ballistic carbine made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	load_sound = "sound/weapons/sniper_mag_insert.ogg"
	bolt_type = BOLT_TYPE_STANDARD

/obj/item/gun/ballistic/railgun/sniper // Offers the best single shot accuracy and speed, but the fire rite is awful. Best when combined with backup and a way to see people through walls for sniping.
	name = "\improper Pikeman sniper rail-lance"
	desc = "A massive MARS hybrid energy-ballistic lance made of two magnetically charged rails that propell a rod to extreme speeds. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_sniper"
	item_state = "railgun_sniper"
	load_sound = "sound/weapons/sniper_mag_insert.ogg"
	bolt_type = BOLT_TYPE_STANDARD
	max_velocity = 100
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 5

/obj/item/gun/ballistic/railgun/makeshift
	name = "makeshift railgun"
	desc = "A shoddy railgun made with scraps lying arround. Projectile speed is dependent on the magnetic charge, which passively goes up between shots when held."
	icon_state = "railgun_makeshift"
	item_state = "railgun_makeshift"
	max_velocity = 60
	knife_x_offset = 17
	knife_y_offset = 10
