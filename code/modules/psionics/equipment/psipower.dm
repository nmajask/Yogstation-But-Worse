/obj/item/psychic_power
	name = "psychic power"
	icon = 'icons/obj/psychic_powers.dmi'
	anchored = TRUE
	var/maintain_cost = 3
	var/mob/living/owner

/obj/item/psychic_power/New(var/mob/living/_owner)
	owner = _owner
	if(!istype(owner))
		qdel(src)
		return
	START_PROCESSING(SSprocessing, src)
	..()

/obj/item/psychic_power/Destroy()
	if(istype(owner) && owner.psi)
		LAZYREMOVE(owner.psi.manifested_items, src)
		UNSETEMPTY(owner.psi.manifested_items)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/psychic_power/attack_self(var/mob/user)
	user.playsound_local(soundin = 'sound/effects/psi/power_fail.ogg')
	user.dropItemToGround(src)

/obj/item/psychic_power/dropped()
	..()
	qdel(src)

/obj/item/psychic_power/process()
	if(istype(owner))
		owner.psi.spend_power(maintain_cost)
	if(!owner || loc != owner || !(src in owner.held_items))
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			host.remove_embedded_object(src)
			host.dropItemToGround(src)
		else
			qdel(src)
