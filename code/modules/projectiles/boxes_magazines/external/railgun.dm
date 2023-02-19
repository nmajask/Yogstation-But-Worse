/obj/item/ammo_box/magazine/railgun
	name = "railgun magazine (Slug)"
	desc = "A masive magazine for loading slugs into semi-automatic railguns."
	icon_state = "railgunmag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_NORMAL // Beg box
	ammo_type = /obj/item/ammo_casing/caseless/railgun
	caliber = "railgun"
	max_ammo = 12

/obj/item/ammo_box/magazine/railgun/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/railgun/du
	name = "railgun magazine (Depleated Uranium)"
	desc = "A masive magazine for loading slugs into semi-automatic railguns."
	icon_state = "railgunmag_du"
	ammo_type = /obj/item/ammo_casing/caseless/railgun/du

/obj/item/ammo_box/magazine/railgun/he
	name = "railgun magazine (High Explosive)"
	desc = "A masive magazine for loading slugs into semi-automatic railguns."
	icon_state = "railgunmag_he"
	ammo_type = /obj/item/ammo_casing/caseless/railgun/he

/obj/item/ammo_box/magazine/railgun/pyro
	name = "railgun magazine (Pyrotechnic)"
	desc = "A masive magazine for loading slugs into semi-automatic railguns."
	icon_state = "railgunmag_pyro"
	ammo_type = /obj/item/ammo_casing/caseless/railgun/pyro

/obj/item/ammo_box/magazine/railgun/emp
	name = "railgun magazine (EMP)"
	desc = "A masive magazine for loading slugs into semi-automatic railguns."
	icon_state = "railgunmag_emp"
	ammo_type = /obj/item/ammo_casing/caseless/railgun/emp

/obj/item/ammo_box/magazine/railgun/heartpiercer
	name = "railgun magazine (Heart Piercer)"
	desc = "A masive magazine for loading slugs into semi-automatic railguns."
	icon_state = "railgunmag_heartpiercer"
	ammo_type = /obj/item/ammo_casing/caseless/railgun/heartpiercer

// Quickloaders

/obj/item/ammo_box/railgun/revolver
	name = "railgun speed loader (Slug)"
	desc = "A four-shot speed loader designed for railgun revolvers."
	icon_state = "railgun_quickloader_slug"
	max_ammo = 4
	multiple_sprites = AMMO_BOX_PER_BULLET
	materials = list(/datum/material/iron = 20000)

/obj/item/ammo_box/railgun/revolver/empty
	start_empty = TRUE

/obj/item/ammo_box/railgun/revolver/du
	name = "railgun speed loader (Depleated Uranium)"
	desc = "A four-shot speed loader designed for railgun revolvers."
	icon_state = "railgun_quickloader_du"

/obj/item/ammo_box/railgun/revolver/he
	name = "railgun speed loader (High Explosive)"
	desc = "A four-shot speed loader designed for railgun revolvers."
	icon_state = "railgun_quickloader_he"

/obj/item/ammo_box/railgun/revolver/pyro
	name = "railgun speed loader (Pyrotechnic)"
	desc = "A four-shot speed loader designed for railgun revolvers."
	icon_state = "railgun_quickloader_pyro"

/obj/item/ammo_box/railgun/revolver/emp
	name = "railgun speed loader (EMP)"
	desc = "A four-shot speed loader designed for railgun revolvers."
	icon_state = "railgun_quickloader_emp"

/obj/item/ammo_box/railgun/revolver/heartpiercer
	name = "railgun speed loader (Heart Piercer)"
	desc = "A four-shot speed loader designed for railgun revolvers."
	icon_state = "railgun_quickloader_heartpiercer"
