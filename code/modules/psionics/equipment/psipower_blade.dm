/obj/item/psychic_power/psiblade
	name = "psychokinetic slash"
	force = 10
	sharpness = SHARP_EDGED
	maintain_cost = 1
	icon_state = "psiblade_short"
	hitsound = 'sound/weapons/psisword.ogg'

/obj/item/psychic_power/psiblade/dropped(var/mob/living/user)
	playsound(loc, 'sound/effects/psi/power_fail.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/psychic_power/psiblade/master
	force = 20
	maintain_cost = 2

/obj/item/psychic_power/psiblade/master/grand
	force = 30
	maintain_cost = 3
	icon_state = "psiblade_long"

/obj/item/psychic_power/psiblade/master/grand/paramount // Silly typechecks because rewriting old interaction code is outside of scope.
	force = 50
	maintain_cost = 4
	icon_state = "psiblade_long"
