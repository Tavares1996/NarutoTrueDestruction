squad
	var
		leader
		name
		tmp
			mob/human/player/online_members[0]
			pending_invites = 0

	New(squad_name, mob/human/player/leader_mob, topic_call=0)
		. = ..()
		name = squad_name
		tag = "squad__[squad_name]"
		var/leader_string
		if(ismob(leader_mob))
			online_members += leader_mob
			leader_string = leader_mob.name
			Refresh_Display()
		else
		 leader_string = leader_mob
		leader = leader_string
		if(topic_call && squad_name)
			SendInterserverMessage("new_squad", list("name" = squad_name, "leader" = leader_string))

	proc
		Refresh_Display()
			var/grid_item = 0
			online_members << output(name, "squad_list_grid:[++grid_item]")
			for(var/M in online_members)
				if(!M)
					online_members -= M
					continue
				online_members << output(M, "squad_list_grid:[++grid_item]")
			for(var/mob/M in online_members)
				if(M.client)
					winset(M, "squad_list_grid", "cells=[grid_item]")


proc
	load_squad(squad_name)
		if(!squad_name) return null
		var/squad/squad = locate("squad__[squad_name]")
		if(!squad)
			var/list/squad_info= params2list(SendInterserverMessage("squad_info", list("squad" = squad_name)))
			squad = new /squad(squad_info["name"], squad_info["leader"], 0)
			squad.tag = "squad__[squad.name]"
		return squad

mob
	var
		tmp/squad/squad
	proc
		Refresh_Squad_Verbs()
			var/client/C = client
			if(!C && usr && usr.client)
				C = usr.client
			if(squad)
				if(C)
					winset(C, "squad_menu", "parent=menu;name=\"&Squad\"")
					if(squad.leader == name)
						winset(C, "squad_leader_menu", "parent=squad_menu;name=\"&Leader\"")
					winset(C, "squad_verb_leave", "parent=squad_menu;name=\"&Leave Squad\";command=Leave-Squad")
					winset(C, "squad_verb_create", "parent=")
					winset(C, "squad_members_menu_item", "is-disabled=false")
				verbs -= /mob/human/verb/Create_Squad
				verbs += typesof(/mob/squad_verbs/verb)
				if(squad.leader == name)
					if(C)
						winset(C, "squad_verb_invite", "parent=squad_leader_menu;name=\"&Invite\";command=Invite-to-Squad")
						winset(C, "squad_verb_kick", "parent=squad_leader_menu;name=\"&Kick\";command=Kick-from-Squad")
						winset(C, "squad_verb_startsquadwar", "parent=squad_leader_menu;name=\"&Start A Squad War\";command=Challenge-Squad-To-War")
					verbs += typesof(/mob/squad_verbs/leader/verb)
			else
				if(C)
					winset(C, "squad_menu", "parent=menu;name=\"&Squad\"")
					winset(C, "squad_verb_create", "parent=squad_menu;name=\"&Create Squad\";command=Create-Squad")
					winset(C, "squad_leader_menu", "parent=")
					winset(C, "squad_members_menu_item", "is-disabled=true")
				verbs += /mob/human/verb/Create_Squad
				verbs -= typesof(/mob/squad_verbs/verb)
				verbs -= typesof(/mob/squad_verbs/leader/verb)

mob/human
	verb
		Create_Squad(squad_name as text)
			set desc = "(squad name) Create a new squad."
			squad_name = html_encode(squad_name)
			if(!squad_name || length(squad_name) <= 1)
				usr << "That name is too short."
				return
			if(length(squad_name) >= 50)
				usr << "That name is too long."
				return
			if(!squad)
				var/list/squad_info = params2list(SendInterserverMessage("squad_info", list("squad" = squad_name)))
				if(!squad_info["name"])
					squad = new(squad_name, src, 1)
					squad.tag = "squad__[squad.name]"
					Refresh_Squad_Verbs()
				else
					usr << "There is already a squad using that name!"
			else
				usr << "You already have a squad!"

mob/squad_verbs
	verb
		Leave_Squad()
			if(squad && input2(src,"Are you sure you want to leave your squad?","Leave Squad",list("Yes","No")) == "Yes" && squad)
				squad.online_members -= src
				if(squad.leader == name)
					spawn()
					del squad
				if(squad)
					squad.Refresh_Display()
				squad = null
				Refresh_Squad_Verbs()
				winset(src, "right_top_child", "left=combat_output_pane")
	leader
		verb
			Invite_to_Squad(mob/M in oview(10,src))
				if(M.faction && faction && M.faction.village == faction.village && squad && !M.squad)
					var/max_squad = 2 + RankGrade()
					if(max_squad == 7) ++max_squad
					if((faction in list(leaf_faction,mist_faction,sand_faction,akatsuki_faction,amegakure_faction,otogakure_faction)) && name == faction.leader)
						max_squad = 10

					var/accepted = input2(M,"Would you like to join [src]'s squad \"[squad]\"?","Squad Invite",list("Yes","No"))
					if(accepted == "Yes" && squad)
						squad.online_members += M
						M.squad = squad
						M.Refresh_Squad_Verbs()
						M.client.SaveMob()
						squad.Refresh_Display()
					if(squad) --squad.pending_invites

			Kick_from_Squad(mob/M in (squad.online_members-src))
				if(input2(src,"Are you sure you would like to kick [M] from your squad?","Squad Kick",list("Yes","No")) == "Yes" && squad)
					squad.online_members -= M
					M.squad = null
					M.Refresh_Squad_Verbs()
					squad.Refresh_Display()
