/mob/proc/get_say()
	create_typing_indicator()
	var/msg = input(src, null, "say \"text\"") as text|null
	remove_typing_indicator()
	say_verb(msg)
