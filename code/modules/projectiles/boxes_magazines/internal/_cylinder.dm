/obj/item/ammo_box/magazine/internal/cylinder
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 7

/obj/item/ammo_box/magazine/internal/cylinder/Initialize()
	. = ..()
	if(start_empty) // Can't load ammo with a null stored_ammo, so here is a shit solution because I am tired of looking at gun code
		for(var/i = 1, i <= max_ammo, i++)
			LAZYADD(stored_ammo, null)

/obj/item/ammo_box/magazine/internal/cylinder/get_round(keep = 0)
	rotate()

	var/b = stored_ammo[1]
	if(!keep)
		stored_ammo[1] = null

	return b

/obj/item/ammo_box/magazine/internal/cylinder/proc/rotate()
	var/atom/b = stored_ammo[1]
	if(QDELETED(b))
		b = null // Don't want to have the cylinder full of qdeleted refs as it causes issues, mainly for caseless rounds
	stored_ammo.Cut(1,2)
	stored_ammo.Insert(0, b)

/obj/item/ammo_box/magazine/internal/cylinder/proc/spin()
	for(var/i in 1 to rand(0, max_ammo*2))
		rotate()

/obj/item/ammo_box/magazine/internal/cylinder/ammo_list(drop_list = FALSE)
	var/list/L = list()
	for(var/i=1 to stored_ammo.len)
		var/obj/item/ammo_casing/bullet = stored_ammo[i]
		if(bullet)
			L.Add(bullet)
			if(drop_list)//We have to maintain the list size, to emulate a cylinder
				stored_ammo[i] = null
	return L

/obj/item/ammo_box/magazine/internal/cylinder/give_round(obj/item/ammo_casing/R, replace_spent = 0)
	if(!R || (caliber && R.caliber != caliber) || (!caliber && R.type != ammo_type))
		return FALSE

	for(var/i in 1 to stored_ammo.len)
		var/obj/item/ammo_casing/bullet = stored_ammo[i]
		if(!bullet || !bullet.BB) // found a spent ammo
			stored_ammo[i] = R
			R.forceMove(src)

			if(bullet)
				bullet.forceMove(drop_location())
			return TRUE

	return FALSE

/obj/item/ammo_box/magazine/internal/cylinder/top_off(load_type, starting=FALSE)
	if(starting) // nulls don't exist when we're starting off
		return ..()

	if(!load_type)
		load_type = ammo_type

	for(var/i = 1, i <= max_ammo, i++)
		if(!give_round(new load_type(src)))
			break
	update_icon()
