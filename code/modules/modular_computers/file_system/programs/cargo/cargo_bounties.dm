/datum/computer_file/program/cargo_bounties
	filename = "ntbounty"
	filedesc = "Nanotrasen bounty browser"
	category = PROGRAM_CATEGORY_SUPL
	program_icon_state = "bounty"
	extended_desc = "Program for viewing and printing the current Nanotrasen bounties"
	transfer_access = ACCESS_CARGO
	requires_ntnet = TRUE
	size = 3
	tgui_id = "NtosCargoBounties"
	program_icon = "file-invoice-dollar"
	var/static/datum/bank_account/cargocash

/datum/computer_file/program/cargo_bounties/New()
	. = ..()
	if(!cargocash)
		cargocash = SSeconomy.get_dep_account(ACCOUNT_CAR)

/datum/computer_file/program/cargo_bounties/ui_data(mob/user)
	var/list/data = get_header_data()
	var/list/bountyinfo = list()
	for(var/datum/bounty/B in GLOB.bounties_list)
		bountyinfo += list(list("name" = B.name, "description" = B.description, "reward_string" = B.reward_string(), "completion_string" = B.completion_string() , "claimed" = B.claimed, "can_claim" = B.can_claim(), "priority" = B.high_priority, "bounty_ref" = REF(B)))
	data["stored_cash"] = cargocash.account_balance
	data["bountydata"] = bountyinfo
	return data

/datum/computer_file/program/cargo_bounties/ui_act(action, params, datum/tgui/ui)
	if(..())
		return

	var/obj/item/computer_hardware/printer/printer
	if(computer)
		printer = computer.all_components[MC_PRINT]

	switch(action)
		if("ClaimBounty")
			var/datum/bounty/cashmoney = locate(params["bounty"]) in GLOB.bounties_list
			if(cashmoney)
				cashmoney.claim()
			return TRUE
		if("Print")
			if(computer && printer) //This option should never be called if there is no printer
				var/contents = "<h2>Nanotrasen Cargo Bounties</h2></br>"
				
				for(var/datum/bounty/B in GLOB.bounties_list)
					if(B.claimed)
						continue
					contents += {"<h3>[B.name]</h3>
					<ul><li>Reward: [B.reward_string()]</li>
					<li>Completed: [B.completion_string()]</li></ul>"}

				computer.play_interact_sound()

				if(!printer.print_text(contents,text("cargo bounties ([])", station_time_timestamp()),FALSE))
					to_chat(usr, span_notice("Hardware error: Printer was unable to print the file. It may be out of paper."))
					return
				else
					computer.visible_message(span_notice("\The [computer] prints out a paper."))
