proc
	Save_Faction()
		var/savefile/S = new("World.sav")
		S["Konoha_Leader"]<<leaf_faction.leader
		S["Kiri_Leader"]<<mist_faction.leader
		S["Sand_Leader"]<<sand_faction.leader
		S["Rain_Leader"]<<amegakure_faction.leader
		S["Sound_Leader"]<<otogakure_faction.leader
		S["Akatsuki_Leader"]<<akatsuki_faction.leader

		S["ANBU_Leader"]<<anbu_faction.leader
		S["Konoha_Medic_Leader"]<<konoha_medic_faction.leader
		S["MGU_Leader"]<<milt_guard_unit_faction.leader
		S["Police_Force_Leader"]<<police_force_faction.leader

		S["Hunter_Nin_Leader"]<<hunter_nin_faction.leader
		S["Kiri_Medic_Leader"]<<kiri_medic_faction.leader
		S["Intel_Leader"]<<intel_faction.leader
		S["7SM_Leader"]<<swordsmen_faction.leader

		S["Assassin_Leader"]<<assassination_unit_faction.leader
		S["Suna_Medic_Leader"]<<suna_medic_faction.leader
		S["Bomb_Leader"]<<bomb_faction.leader

		S["Dark_Leagence_Leader"]<<dark_leagence_faction.leader
		S["Samegakure_Leader"]<<samegakure_faction.leader
		S["Vincentgakure_Leader"]<<vincentgakure_faction.leader
	Load_Faction()
		if(fexists("World.sav"))
			var/savefile/S = new("World.sav")
			S["Konoha_Leader"]>>leaf_faction.leader
			S["Kiri_Leader"]>>mist_faction.leader
			S["Sand_Leader"]>>sand_faction.leader
			S["Rain_Leader"]>>amegakure_faction.leader
			S["Sound_Leader"]>>otogakure_faction.leader
			S["Akatsuki_Leader"]>>akatsuki_faction.leader

			S["ANBU_Leader"]>>anbu_faction.leader
			S["Konoha_Medic_Leader"]>>konoha_medic_faction.leader
			S["MGU_Leader"]>>milt_guard_unit_faction.leader
			S["Police_Force_Leader"]>>police_force_faction.leader

			S["Hunter_Nin_Leader"]>>hunter_nin_faction.leader
			S["Kiri_Medic_Leader"]>>kiri_medic_faction.leader
			S["Intel_Leader"]>>intel_faction.leader
			S["7SM_Leader"]>>swordsmen_faction.leader

			S["Assassin_Leader"]>>assassination_unit_faction.leader
			S["Suna_Medic_Leader"]>>suna_medic_faction.leader
			S["Bomb_Leader"]>>bomb_faction.leader

			S["Dark_Leagence_Leader"]>>dark_leagence_faction.leader
			S["Samegakure_Leader"]>>samegakure_faction.leader
			S["Vincentgakure_Leader"]>>vincentgakure_faction.leader

var
	list
		faction_mouse = list(
			"Konoha" = 'icons/mouse_icons/konohamouse.dmi',
			"Kiri" = 'icons/mouse_icons/mistmouse.dmi',
			"Suna" = 'icons/mouse_icons/sunamouse.dmi',
			"Ourico-Ame" = 'faction_icons/ourico-ame-mouse.dmi',
			"Manage-Sound" = 'faction_icons/mange-sound-mouse.png',
			"Akatsuki" = 'faction_icons/akatsuki-mouse.dmi',
			"Dark" = 'faction_icons/espada-mouse.dmi',
			"Same" = 'faction_icons/frontier-hunters-mouse.dmi',
			"Vincent" = 'faction_icons/blood-mouse.dmi',
		)
		faction_chat = list(
			"Konoha" = 'pngs/Leaf.png',
			"Kiri" = 'pngs/Mist.png',
			"Suna" = 'pngs/Sand.png',
			"Missing" = 'pngs/Missing.png',
			"Ourico-Ame" = 'faction_icons/ourico-ame-chat.png',
			"Mange-Sound" = 'faction_icons/mange-sound-chat.png',
			"Akatsuki" = 'faction_icons/akatsuki-chat.dmi',
			"Dark" = 'faction_icons/espada-chat.dmi',
			"Same" = 'faction_icons/frontier-hunters-chat.dmi',
			"Vincent" = 'faction_icons/blood-chat.dmi',
		)
#define DEBUG
faction
	var
		leader
		village
		name
		mouse_icon
		chat_icon
		chuunin_item
		member_limit
		tmp
			mob/human/player/online_members[0]

	New(faction_name, faction_village, mob/human/player/leader_mob, faction_mouse_icon, faction_chat_icon, faction_chuunin_item=0, member_limit=0, topic_call=0)
		. = ..()
		name = faction_name
		tag = "faction__[faction_name]"
		village = faction_village
		var/leader_string
		if(ismob(leader_mob))
			online_members += leader_mob
			leader_string = leader_mob.name
		else
		 leader_string = leader_mob
		leader = leader_string
		mouse_icon = faction_mouse_icon
		chat_icon = faction_chat_icon
		if(faction_chuunin_item && !isnum(faction_chuunin_item))
			faction_chuunin_item = text2num("[faction_chuunin_item]")
		chuunin_item = faction_chuunin_item
		if(topic_call)
			SendInterserverMessage("new_faction", list("name" = faction_name, "leader" = leader_string, "village" = faction_village, "mouse_icon" = mouse_icon, "chat_icon" = chat_icon, "chuunin_item" = chuunin_item, "member_limit" = member_limit))
	proc
		AddMember(mob/M)
			online_members += M
			M.faction = src
			if(mouse_icon) M.mouse_over_pointer = faction_mouse[mouse_icon]
			M.Refresh_Faction_Verbs()
		RemoveMember(mob/M)
			online_members -= M
			M.mouse_over_pointer = null

var
	faction
		leaf_faction
		mist_faction
		sand_faction
		missing_faction
		akatsuki_faction
		amegakure_faction
		otogakure_faction
		samegakure_faction
		vincentgakure_faction
		dark_leagence_faction

		//Leaf
		anbu_faction
		konoha_medic_faction
		milt_guard_unit_faction
		police_force_faction
		//Kiri
		hunter_nin_faction
		kiri_medic_faction
		intel_faction
		swordsmen_faction
		//Suna
		assassination_unit_faction
		suna_medic_faction
		bomb_faction

proc
	initialize_basic_factions()
		//"Faction Name", "Village", "The Leader", "The Mouse Icon", "The Chat Icon", "Chuunin Item", "Member Limit", 0)
		leaf_faction = new /faction("Konohagakure", "Konoha", null, "Konoha", "Konoha", "224", 10000000000, 0)

		//Leaf Factions
		anbu_faction = new /faction("Anbu Black Ops", "Konoha", null, "Konoha", "Konoha", "224", 10, 0)
		konoha_medic_faction = new /faction("Konoha Medical Unit", "Konoha", null, "Konoha", "Konoha", "224", 25, 0)
		milt_guard_unit_faction = new /faction("Milt.Guard Unit", "Konoha", null, "Konoha", "Konoha", "224", 25, 0)
		police_force_faction = new /faction("Police Force", "Konoha", null, "Konoha", "Konoha", "224", 25, 0)

		mist_faction = new /faction("Kirigakure", "Kiri", null, "Kiri", "Kiri", "226", 10000000000, 0)

		//Kiri Factions
		hunter_nin_faction = new /faction("Hunter-Nin", "Kiri", null, "Kiri", "Kiri", "226", 10, 0)
		kiri_medic_faction = new /faction("Kiri Medical Unit", "Kiri", null, "Kiri", "Kiri", "226", 25, 0)
		intel_faction = new /faction("Intel Unit", "Kiri", null, "Kiri", "Kiri", "226", 25, 0)
		swordsmen_faction = new /faction("Seven Swordsmen Of The Hidden Mist", "Kiri", null, "Kiri", "Kiri", "226", 7, 0)

		sand_faction = new /faction("Sunagakure", "Suna", null, "Suna", "Suna", "225", 10000000000, 0)

		//Suna Factions
		assassination_unit_faction = new /faction("Assassination Unit", "Suna", null, "Suna", "Suna", "225", 10, 0)
		suna_medic_faction = new /faction("Suna Medical Unit", "Suna", null, "Suna", "Suna", "225", 25, 0)
		bomb_faction = new /faction("Milt.Bomb Unit", "Suna", null, "Suna", "Suna", "225", 25, 0)

		missing_faction = new /faction("Missing", "Missing", null, null, "Missing", null, 10000000000, 0)
		amegakure_faction = new /faction("Amegakure", "Ame", null, "Ourico-Ame", "Ourico-Ame", "10000", 15, 0)
		otogakure_faction = new /faction("Otogakure", "Oto", null,"Manage-Sound", "Mange-Sound", "10001", 25, 0)
		akatsuki_faction = new /faction("Akatsuki", "Akatsuki", null,"Akatsuki", "Akatsuki", "10003", 9, 0)
		dark_leagence_faction = new /faction("Dark Leagence", "Dark Leagence", null, "Dark", "Dark", "60000", 6, 0)
		samegakure_faction = new /faction("Samegakure", "Same", null,"Same", "Same", "65000", 15, 0)
		vincentgakure_faction = new /faction("Vincentgakure", "Vincent", null,"Vincent", "Vincent", "70000", 15, 0)

		leaf_faction.tag = "faction__[leaf_faction.name]"

		//Leaf Factions
		anbu_faction.tag = "faction__[anbu_faction.name]"
		konoha_medic_faction.tag = "faction__[konoha_medic_faction.name]"
		milt_guard_unit_faction.tag = "faction__[milt_guard_unit_faction.name]"
		police_force_faction.tag = "faction__[police_force_faction.name]"

		mist_faction.tag = "faction__[mist_faction.name]"

		//Kiri Factions
		hunter_nin_faction.tag = "faction__[hunter_nin_faction.name]"
		kiri_medic_faction.tag = "faction__[kiri_medic_faction.name]"
		intel_faction.tag = "faction__[intel_faction.name]"
		swordsmen_faction.tag = "faction__[swordsmen_faction.name]"

		sand_faction.tag = "faction__[sand_faction.name]"

		//Suna Factions
		assassination_unit_faction.tag = "faction__[assassination_unit_faction.name]"
		suna_medic_faction.tag = "faction__[suna_medic_faction.name]"
		bomb_faction.tag = "faction__[bomb_faction.name]"

		missing_faction.tag = "faction__[missing_faction.name]"
		amegakure_faction.tag = "faction__[amegakure_faction.name]"
		otogakure_faction.tag = "faction__[otogakure_faction.name]"
		akatsuki_faction.tag = "faction__[akatsuki_faction.name]"
		dark_leagence_faction.tag = "faction__[dark_leagence_faction.name]"
		samegakure_faction.tag = "faction__[samegakure_faction.name]"
		vincentgakure_faction.tag = "faction__[vincentgakure_faction.tag]"
		world.log << "Basic factions loaded"

	load_faction(faction_name)
		var/faction/faction
		switch(faction_name)
			if("Konohagakure")
				faction = leaf_faction
			//Leaf Factions
			if("Anbu Black Ops")
				faction = anbu_faction
			if("Konoha Medical Unit")
				faction = konoha_medic_faction
			if("Police Force")
				faction = police_force_faction
			if("Milt.Guard Unit")
				faction = milt_guard_unit_faction

			if("Kirigakure")
				faction = mist_faction
			//Kir Factions
			if("Hunter-Nin")
				faction = hunter_nin_faction
			if("Kiri Medical Unit")
				faction = kiri_medic_faction
			if("Intel Unit")
				faction = intel_faction
			if("Seven Swordsmen Of The Hidden Mist")
				faction = swordsmen_faction

			if("Sunagakure")
				faction = sand_faction
			//Suna Factions
			if("Assassination Unit")
				faction = assassination_unit_faction
			if("Suna Medical Unit")
				faction = suna_medic_faction
			if("Milt.Bomb Unit")
				faction = bomb_faction

			if("Missing")
				faction = missing_faction
			if("Amegakure")
				faction = amegakure_faction
			if("Otogakure")
				faction = otogakure_faction
			if("Akatsuki")
				faction = akatsuki_faction
			if("Dark Leagence")
				faction = dark_leagence_faction
			if("Samegakure")
				faction = samegakure_faction
			if("Vincentgakure")
				faction = vincentgakure_faction
			else
				faction = locate("faction__[faction_name]")
		if(!faction)
			var/list/faction_info = params2list(SendInterserverMessage("faction_info", list("faction" = faction_name)))
			faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["member_limit"], 0)
			faction.tag = "faction__[faction.name]"
		return faction

mob
	var
		tmp/faction/faction
	proc
		Refresh_Faction_Verbs()
			var/client/C = client
			if(!C && usr && usr.client)
				C = usr.client
			if(faction)
				if(C) winset(usr, "faction_menu", "parent=menu;name=\"&Faction\"")
				if(faction.leader == realname)
					if(C) winset(C, "faction_leader_menu", "parent=faction_menu;name=\"&Leader\"")
				if(faction.village != "Missing")
					verbs += typesof(/mob/faction_verbs/non_missing/verb)
					if(C)
						winset(C, "vsay_button", "is-visible=true")
						winset(C, "faction_verb_vsay", "parent=faction_menu;name=\"&Village Say\";command=Village-Say")
						winset(C, "faction_verb_vleave", "parent=faction_menu;name=\"L&eave Village\";command=Leave-Village")
				if(!(faction in list(leaf_faction, mist_faction, sand_faction, missing_faction, anbu_faction,konoha_medic_faction,milt_guard_unit_faction,police_force_faction,hunter_nin_faction,kiri_medic_faction,intel_faction,swordsmen_faction,assassination_unit_faction,suna_medic_faction,bomb_faction,akatsuki_faction, otogakure_faction, amegakure_faction)))
					verbs += typesof(/mob/faction_verbs/non_default/verb)
					if(C)
						winset(C, "fsay_button", "is-visible=true")
						winset(C, "faction_verb_fsay", "parent=faction_menu;name=\"&Faction Say\";command=Faction-Say")
						winset(C, "faction_verb_fleave", "parent=faction_menu;name=\"L&eave Faction\";command=Leave-Faction")

				if(faction in list(leaf_faction, mist_faction, sand_faction))
					if(faction.leader == realname)
						verbs += typesof(/mob/faction_verbs/leader/default_non_missing/verb)
						if(C)
							winset(C, "subfaction_menu", "parent=faction_leader_menu;name=\"&Village Factions\"")
							winset(C, "subfaction_verb_create", "parent= subfaction_menu; name=\"&Pick A Faction Leader\";command=Pick-Faction-Leader")
							winset(C, "faction_verb_chuunin", "parent=faction_leader_menu;name=\"Host &Chuunin Exam\";command=Host-Chuunin-Exam")
							winset(C, "faction_verb_infocard", "parent=faction_leader_menu;name=\"Change I&nfo Card Comment\";command=Set-Info-Card-Comment")
							winset(C, "faction_verb_addhelper", "parent=faction_leader_menu;name=\"A&dd Helper\";command=Add-Helper")
							winset(C, "faction_verb_removehelper", "parent=faction_leader_menu;name=\"&Remove Helper\";command=Remove-Helper")
							winset(C, "faction_verb_mute", "parent=faction_leader_menu;name=\"&Mute\";command=Mute-KAGE")
							winset(C, "faction_verb_unmute", "parent=faction_leader_menu;name=\"&Unmute\";command=Unmute-KAGE")
							winset(C, "faction_verb_unmuteall", "parent=faction_leader_menu;name=\"Unmute &Everyone\";command=Unmute-All-KAGE")
							winset(C, "faction_verb_vinvite", "parent=faction_leader_menu;name=\"&Invite\";command=Invite-to-Village")
							winset(C, "faction_verb_war", "parent=faction_leader_menu;name=\"&Start a war\";command=Start-A-War")
							winset(C, "faction_verb_vkick", "parent=faction_leader_menu;name=\"&Kick\";command=Kick-from-Village")
							winset(C, "faction_verb_rank", "parent=faction_leader_menu;name=\"&Promote Villager\";command=Change-Rank")
							winset(C, "faction_verb_raid", "parent=faction_leader_menu;name=\"Order a Raid\";command=Raid")
							winset(C, "arena_host_menu", "parent=faction_leader_menu;name=\"&Arena\"")
							winset(C, "arena_host_verb_start", "parent=arena_host_menu;name=\"&Start Tournament\";command=Start-Tourney")
							winset(C, "arena_host_verb_end", "parent=arena_host_menu;name=\"&End Tournament\";command=End-Tourney")
							winset(C, "arena_host_verb_send", "parent=arena_host_menu;name=\"&Send Player to Arena\";command=Send-to-Arena")
							winset(C, "arena_host_verb_fight", "parent=arena_host_menu;name=\"Start &Fight\";command=Start-Fight")
							winset(C, "arena_host_verb_winner", "parent=arena_host_menu;name=\"Declare &Winner\";command=Declare-Winner")
				if(faction in list(akatsuki_faction, otogakure_faction, amegakure_faction, dark_leagence_faction, samegakure_faction, vincentgakure_faction))
					if(faction.leader == realname)
						verbs += typesof(/mob/faction_verbs/leader/default_non_missing/verb)
						if(C)
							winset(C, "faction_verb_mute", "parent=faction_leader_menu;name=\"&Mute\";command=Mute-KAGE")
							winset(C, "faction_verb_unmute", "parent=faction_leader_menu;name=\"&Unmute\";command=Unmute-KAGE")
							winset(C, "faction_verb_unmuteall", "parent=faction_leader_menu;name=\"Unmute &Everyone\";command=Unmute-All-KAGE")
							winset(C, "faction_verb_vinvite", "parent=faction_leader_menu;name=\"&Invite\";command=Invite-to-Village")
							winset(C, "faction_verb_war", "parent=faction_leader_menu;name=\"&Start a war\";command=Start-A-War")
							winset(C, "faction_verb_vkick", "parent=faction_leader_menu;name=\"&Kick\";command=Kick-from-Village")
							winset(C, "faction_verb_rank", "parent=faction_leader_menu;name=\"&Promote Villager\";command=Change-Rank")
							winset(C, "faction_verb_raid", "parent=faction_leader_menu;name=\"Order a Raid\";command=Raid")
							winset(C, "arena_host_menu", "parent=faction_leader_menu;name=\"&Arena\"")
							winset(C, "arena_host_verb_start", "parent=arena_host_menu;name=\"&Start Tournament\";command=Start-Tourney")
							winset(C, "arena_host_verb_end", "parent=arena_host_menu;name=\"&End Tournament\";command=End-Tourney")
							winset(C, "arena_host_verb_send", "parent=arena_host_menu;name=\"&Send Player to Arena\";command=Send-to-Arena")
							winset(C, "arena_host_verb_fight", "parent=arena_host_menu;name=\"Start &Fight\";command=Start-Fight")
							winset(C, "arena_host_verb_winner", "parent=arena_host_menu;name=\"Declare &Winner\";command=Declare-Winner")
				if(faction in list(anbu_faction, konoha_medic_faction, milt_guard_unit_faction, police_force_faction, hunter_nin_faction, kiri_medic_faction, intel_faction, swordsmen_faction, assassination_unit_faction, suna_medic_faction, bomb_faction))
					if(faction.leader == realname)
						if(faction in list(akatsuki_faction, otogakure_faction, amegakure_faction,leaf_faction, mist_faction, sand_faction, dark_leagence_faction, samegakure_faction, vincentgakure_faction))
							if(faction.leader == realname)
								if(C)
									winset(C, "vsay_button", "is-visible=false")
									winset(C, "fsay_button", "is-visible=false")
									winset(C, "faction_menu", "parent=")
									winset(C, "faction_leader_menu", "parent=")
								verbs -= typesof(/mob/faction_verbs/leader/default_non_missing/verb)
						spawn(5)
							verbs += typesof(/mob/faction_verbs/leader/default_non_missing/verb)
							if(C)
								winset(C, "subfaction_menu", "parent=faction_leader_menu;name=\"&Village Factions\"")
								winset(C, "faction_verb_vinvite", "parent=faction_leader_menu;name=\"&Invite\";command=Invite-to-Village")
								winset(C, "faction_verb_vkick", "parent=faction_leader_menu;name=\"&Kick\";command=Kick-from-Village")
								winset(C, "arena_host_menu", "parent=faction_leader_menu;name=\"&Arena\"")
								winset(C, "arena_host_verb_start", "parent=arena_host_menu;name=\"&Start Tournament\";command=Start-Tourney")
								winset(C, "arena_host_verb_end", "parent=arena_host_menu;name=\"&End Tournament\";command=End-Tourney")
								winset(C, "arena_host_verb_send", "parent=arena_host_menu;name=\"&Send Player to Arena\";command=Send-to-Arena")
								winset(C, "arena_host_verb_fight", "parent=arena_host_menu;name=\"Start &Fight\";command=Start-Fight")
								winset(C, "arena_host_verb_winner", "parent=arena_host_menu;name=\"Declare &Winner\";command=Declare-Winner")
			else
				if(C)
					winset(C, "vsay_button", "is-visible=false")
					winset(C, "fsay_button", "is-visible=false")
					winset(C, "faction_menu", "parent=")
					winset(C, "faction_leader_menu", "parent=")
				verbs -= typesof(/mob/faction_verbs/non_missing)
				verbs -= typesof(/mob/faction_verbs/non_default/verb)
				verbs -= typesof(/mob/faction_verbs/leader/non_default/verb)

mob/Admin/verb
	Create_Faction(faction_name as text, village as text, leader_name as text|mob in world, mouse_icon as null|anything in faction_mouse, chat_icon as anything in faction_chat, chuunin_item as null|num, member_limit as num)
		set desc = "(faction, village, leader name, mouse icon, chat icon) Create a new faction"
		var/list/faction_info = params2list(SendInterserverMessage("faction_info", list("faction" = faction_name)))
		if(!faction_info["name"])
			var/faction/faction = new /faction(faction_name, village, leader_name, mouse_icon, chat_icon, chuunin_item, member_limit, 1)
			faction.tag = "faction__[faction.name]"
			if(ismob(leader_name))
				faction.AddMember(leader_name)
				leader_name:Refresh_Faction_Verbs()
		else
			usr << "There is already a faction using that name!"
	Change_Faction_Leader(faction_name as text, leader_name as text|mob in All_Clients())
		set desc = "(faction, leader name) Change the leader of a faction."
		var/faction/faction = load_faction(faction_name)
		if(!faction)
			src << "That faction (\"[faction_name]\") does not exist."
		else
			faction.leader = "[leader_name]"
			if(ismob(leader_name))
				faction.AddMember(leader_name)
				leader_name:Refresh_Faction_Verbs()
			SendInterserverMessage("faction_leader_change", list("faction" = faction_name, "new_leader" = faction.leader))

mob/faction_verbs
	non_missing
		verb
			Village_Say(var/t as text)
				set category="Faction"
				winset(usr, "map", "focus=true")
				if(mute||tempmute)
					src<<"You're Muted"
				else
					if(name!="")
						talkcool=20
						talktimes+=1
						if(talktimes>=2 && rank=="Academy Student")
							src<<"Sorry new players cannot talk that fast, take a breather before each message."
							return
						if(FilterText(t,chat_filter))
							usr<<"<font color=green><b>Please do not try to advertise on this game</b></font color>"
							world<<"<font color=green></font color>[usr] has been auto-muted for trying to advertise"
							usr.mute=2
							sleep(1200)
							usr.mute=0
						if(talktimes>=8)
							src<<"You have been temporarily muted for talking too quickly."
							tempmute=1
							sleep(100)
							src<<"temp mute lifted"
							tempmute=0
							talktimes=0
						if(talkcooling==0)
							spawn()talkcool()
						if(length(t) <= 500&&say==1)
							say=0
							var/rrank=rank
							if((faction in list(leaf_faction,mist_faction,sand_faction,samegakure_faction,vincentgakure_faction)) && realname == faction.leader)
								rrank="Kage"
							if((faction in list(akatsuki_faction,otogakure_faction,amegakure_faction)) && realname == faction.leader)
								rrank="Leader"
							if((faction in list(dark_leagence_faction)) && realname == faction.leader)
								rrank="God Of Darkness"
							for(var/mob/human/player/P in world)
								if(P.client && P.faction && (P.faction.village==faction.village || (P in online_admins)))
									if(P.ckey in online_admins)
										P<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rrank]</span>) <a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[realname]</span></a>: <span class='message'>[html_encode(t)]</span></span></span>"
									else
										P<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rrank]</span>) <span class='name'>[realname]</span>: <span class='message'>[html_encode(t)]</span></span></span>"
							ChatLog("village") << "[time2text(world.timeofday, "hh:mm:ss")]\t[faction.village]\t[realname]\t[html_encode(t)]"
							spawn() SendInterserverMessage("chat_mirror", list("mode" = "village", "ref" = "\ref[src]", "name" = realname, "rank" = rrank, "faction" = "[faction]", "msg" = html_encode(t)))
							sleep(2)
							say=1
						else
							world<<"[html_encode(realname)]/[key] is temporarily muted for spamming"
							tempmute=1
							sleep(200)
							tempmute=0
			Leave_Village()
				set category="Faction"
				if(usr.blevel<15)
					usr<<"You can't leave your village until you're at least level 15"
					return
				if(alert(usr,"Leaving a village is very serious, it's very difficult to get invited back into a village.  Don't do this if your new or dont fully understand the consequences.",,"No","Yes")=="Yes")
					if(alert(usr,"LEAVE YOUR VILLAGE?!",,"No","Yes")=="Yes")
						world<<"[usr] has abandoned [usr.faction.village] and become a missing nin."
						faction.RemoveMember(src)
						missing_faction.AddMember(src)
						if(rank != "Genin" && rank != "Academy Student")
							rank = "Chuunin"
	non_default
		verb
			Faction_Say(msg as text)
				set category="Faction"
				if(mute||tempmute)
					src<<"You're Muted"
				else if(name!="")
					talkcool=20
					talktimes+=1
					if(talktimes>=2 && rank=="Academy Student")
						src<<"Sorry new players cannot talk that fast, take a breather before each message."
						return
					if(talktimes>=8)
						src<<"You have been temporarily muted for talking too quickly."
						tempmute=1
						sleep(100)
						src<<"temp mute lifted"
						tempmute=0
						talktimes=0
					if(FilterText(msg,chat_filter))
						usr<<"<font color=green><b>Please do not try to advertise on this game</b></font color>"
						world<<"<font color=green></font color>[usr] has been auto-muted for trying to advertise"
						usr.mute=2
						sleep(1200)
						usr.mute=0
					if(talkcooling==0)
						spawn()talkcool()
					if(length(msg) <= 500&&say==1)
						var/rrank=rank
						say=0
						if((faction in list(amegakure_faction,otogakure_faction,akatsuki_faction)) && realname == faction.leader)
							rrank="Leader"
						for(var/mob/M in (faction.online_members + online_admins))
							if(M.ckey in online_admins)
								M<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rrank]</span>) <a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[realname]</span></a>: <span class='message'>[html_encode(msg)]</span></span></span>"
							else
								M<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rrank]</span>) <span class='name'>[realname]</span>: <span class='message'>[html_encode(msg)]</span></span></span>"

						ChatLog("faction") << "[time2text(world.timeofday, "hh:mm:ss")]\t[faction]\t[realname]\t[html_encode(msg)]"
						spawn() SendInterserverMessage("chat_mirror", list("mode" = "faction", "ref" = "\ref[src]", "name" = realname, "rank" = rank, "faction" = "[faction]", "msg" = html_encode(msg)))
						sleep(2)
						say=1
					else
						world<<"[html_encode(realname)]/[key] is temporarily muted for spamming"
						tempmute=1
						sleep(200)
						tempmute=0

			Leave_Faction()
				set category="Faction"
				if(faction && input2(src,"Are you sure you want to leave your faction?","Leave faction",list("Yes","No")) == "Yes")
					var/faction_village = faction.village
					switch(faction_village)
						if("Konoha")
							leaf_faction.AddMember(src)
						if("Kiri")
							mist_faction.AddMember(src)
						if("Suna")
							sand_faction.AddMember(src)
						else
							missing_faction.AddMember(src)
					Refresh_Faction_Verbs()
					src << "You have left your faction."
	leader
		default_non_missing
			verb
				Create_Faction_KAGE(faction_name as text, mob/leader as mob in world, member_limit as num)
					set desc = "(faction, leader, limit) Create a new faction"
					if(!leader.faction || leader.faction.village != faction.village)
						src << "The leader must be in your village."
					var/list/faction_info = params2list(SendInterserverMessage("faction_info", list("faction" = faction_name)))
					if(!faction_info["name"])
						var/faction/new_faction = new /faction(faction_name, faction.village, leader, faction.mouse_icon, faction.chat_icon, faction.chuunin_item, member_limit, 1)
						new_faction.tag = "faction__[new_faction.name]"
						new_faction.AddMember(leader)
						leader:Refresh_Faction_Verbs()
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tcreate_faction\t[src]\t[faction]\t[faction_name]\t[leader]\t[member_limit]"
					else
						usr << "There is already a faction using that name!"

				Pick_Faction_Leader(mob/leader as mob in All_Clients())
					if(leader.faction.village != faction.village || !leader.faction)
						src << "Please pick someone in your village."
						return
			/*		if(leader == src)
						return*/
					if(src.faction.village == "Konoha")
						switch(input(usr, "Please pick a faction")in list("Anbu Black Ops","Medical Unit","Military Guard Unit","Police Force"))
							if("Anbu Black Ops")
								var/faction/faction = load_faction("Anbu Black Ops")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#04B404 size=+1>[leader] is now Anbu Black Ops Leader</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Medical Unit")
								var/faction/faction = load_faction("Konoha Medical Unit")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#04B404 size=+1>[leader] is now Medical Unit Leader for konoha</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Military Guard Unit")
								var/faction/faction = load_faction("Milt.Guard Unit")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#04B404 size=+1>[leader] is now Military Guard Unit Leader</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Police Force")
								var/faction/faction = load_faction("Police Force")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#04B404 size=+1>[leader] is now Police Force Leader</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
					if(src.faction.village == "Kiri")
						switch(input(usr, "Please pick a faction")in list("Hunter-Nin","Medical Unit","Intel Unit","Seven Swordsmen Of The Hidden Mist"))
							if("Hunter-Nin")
								var/faction/faction = load_faction("Hunter-Nin")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#084B8A size=+1>[leader] is now Hunter-Nin Leader</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Medical Unit")
								var/faction/faction = load_faction("Kiri Medical Unit")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#084B8A size=+1>[leader] is now Medical Unit Leader for kiri</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Intel Unit")
								var/faction/faction = load_faction("Intel Unit")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#084B8A size=+1>[leader] is now Intel Squad Leader</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Seven Swordsmen Of The Hidden Mist")
								var/faction/faction = load_faction("Seven Swordsmen Of The Hidden Mist")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#084B8A size=+1>[leader] is now Seven Swordsmen Of The Hidden Mist Leader</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
					if(src.faction.village == "Suna")
						switch(input(usr, "Please pick a faction")in list("Assassination Unit","Medical Unit","Milt.Bomb Unit"))
							if("Assassination Unit")
								var/faction/faction = load_faction("Assassination Unit")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#DBA901 size=+1>[leader] is now Assassination Unit Leader</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Medical Unit")
								var/faction/faction = load_faction("Suna Medical Unit")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#DBA901 size=+1>[leader] is now Medical Unit Leader for suna</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))
							if("Milt.Bomb Unit")
								var/faction/faction = load_faction("Milt.Bomb Unit")
								faction.leader = "[leader]"
								faction.AddMember(leader)
								world << "<b><font color=#DBA901 size=+1>[leader] is now Military Bombing Unit Leader for suna</b>"
								leader.Refresh_Faction_Verbs()
								SendInterserverMessage("faction_leader_change", list("faction" = faction, "new_leader" = faction.leader))

				Change_Faction_Leader_KAGE(faction_name as text, mob/leader as mob in world)
					set desc = "(faction, leader name) Change the leader of a faction."
					if(!leader.faction || leader.faction.village != faction.village)
						src << "The leader must be in your village."
					var/faction/change_faction = load_faction(faction_name)
					if(!change_faction)
						src << "That faction (\"[faction_name]\") does not exist."
					else
						if(change_faction.village != faction.village)
							src << "You can only change factions in your own village!"
							return
						if(change_faction == faction)
							src << "You cannot change the leader of your own faction!"
							return
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tchange_faction_leader\t[src]\t[faction]\t[faction_name]\t[change_faction.leader]\t[leader]"
						change_faction.leader = "[leader]"
						change_faction.AddMember(leader)
						leader:Refresh_Faction_Verbs()
						SendInterserverMessage("faction_leader_change", list("faction" = change_faction.name, "new_leader" = change_faction.leader))

				Set_Info_Card_Comment(mob/M in world)
					var/comment = input("Edit Comment:", "Info Card [M]", GetComment(M, lowertext(faction.village))) as null|message
					if(comment)
						var/success = params2list(SendInterserverMessage("char_info_set_comment", list("char" = "[M]", "village" = lowertext(faction.village), "comment" = comment)))
						if(success)
							src << "[faction.village] info comment for [M] changed."
							file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tchange_info_card_comment\t[src]\t[faction]\t[faction.village]\t[M]\t[comment]"
						else src << "[faction.village] info comment for [M] could not be changed."

				Raid()
					set category = "Faction Leader"
					if(WAR || cexam) return
					for(var/mob/human/player/x in world)
						if(x.client && x.faction && x.faction.village==src.faction.village)
							x << "<font color = pink><font size=+1> [src.name] your leader has ordered a raid. Meet At the village enterance immediately."

				Start_Tourney()
					set category="Faction Leader"
					tourney=1
					world<<"<font color=Blue size= +1>[usr] has started a Tourney, you can watch by clicking on Watch_Fight in your commands tab!</font>"
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tstart_tournament\t[src]\t[faction]"
				End_Tourney()
					set category="Faction Leader"
					tourney=0
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tend_tournament\t[src]\t[faction]"
				Send_to_Arena()
					set category="Faction Leader"
					var/list/X = new
					for(var/mob/human/player/O in world)
						if(O.client && O.faction && O.faction.village==src.faction.village && O.RankGrade()>=1)
							X+=O
					var/mob/human/player/x=input(usr,"Put who in the arena?","Arena") as null|anything in X
					if(x && x.client)
						if(x.shopping)
							x.shopping=0
							x.canmove=1
							x.see_invisible=0
						x.oldx=x.x
						x.oldy=x.y
						x.oldz=x.z
						x.pk=0
						x.dojo=1
						x.inarena=1
						x.stunned=30
						x<<"Wait for 1,2,3 Go."
						world<<"<font color=Blue size= +1>[x] Has entered the Arena!</font>"
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tsend_to_arena\t[src]\t[faction]\t[x]"
						x.loc=locate(69,72,3)
				Start_Fight()
					set category="Faction Leader"
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tstart_fight\t[src]\t[faction]"
					world<<"On Go"
					sleep(10)
					world<<"3"
					sleep(10)
					world<<"2"
					sleep(10)
					world<<"1"
					sleep(10)
					world<<"0, GO!"
					for(var/mob/human/player/x in world)
						if(x.inarena==1 && !x.cexam ||x.inarena==2 && !x.cexam)
							x.pk=1
							x.dojo=0
							x.stunned=0
							x.curwound=0

				Declare_Winner()
					set category="Faction Leader"
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tend_fight\t[src]\t[faction]"
					for(var/mob/human/player/x in world)
						if(x.inarena==1 && x.z==3)
							world<<"<font color=Blue size= +1>[x] Has won!</font>"
							x.inarena=0
							x.curwound=0
							x.curstamina=x.stamina
							x.curchakra=x.chakra

							if(x.oldx &&x.oldy && x.oldz)
								x.loc=locate(x.oldx,x.oldy,x.oldz)
								x.oldx=0
								x.oldy=0 //
								x.oldz=0
				Change_Rank()
					set category="Faction Leader"
					var/list/X = new
					for(var/mob/human/player/O in world)
						if(O.client && O.faction && O.faction.village==src.faction.village && O.RankGrade()>=2)
							X+=O
					var/mob/human/player/P=input(usr,"Change Whos rank? (max of 3 Elite Jounin, These are people powerful enough and mature enough to be potential future kage candidates.)","Rank") as null|anything in X
					if(P)
						var/rank = input(usr,"Which Rank?")in list("Chuunin","Special Jounin","Jounin","Elite Jounin")
						if(P)
							P.rank=rank
							world<<"{[usr.faction.village]} [P]'s rank is now [P.rank]"
							file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tchange_rank\t[src]\t[faction]\t[P]\t[P.rank]"
				Host_Chuunin_Exam()
					set category = "Faction Leader"
					if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)  <0)
						usr.Last_Hosted=0
					if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted) >48)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\thost_chuunin\t[src]\t[faction]"
						world<<"<span class='chuunin_exam'>[usr.realname] has decided to host a chuunin exam.</span>"
						MultiAnnounce("<span class='chuunin_exam'>[usr.realname] has decided to host a chuunin exam. (<a href='[world.url]'>Join server</a>)</span>", 0)
						sleep(130)
						if(chuuninactive) return
						usr.Last_Hosted=time2text(world.realtime,"DD:hh")
						world.Auto_Chuunin()
					else
						usr<<"You last hosted a chuunin on [usr.Last_Hosted] (Day:Hour), thats [In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)] /48 Hours ago."

				Start_A_War()
					set category="Faction Leader"
					if(chuuninactive||WAR) return
					if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)  <0)
						usr.Last_Hosted=0
					if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted) > 1)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tdeclared a war\t[src]\t[faction]"
						world<<"<font size=+1><span class='war'>[name] has declared War!</span>"
						usr.Last_Hosted=time2text(world.realtime,"DD:hh")
						Start_War()
					else
						usr<<"You last declared a war on [usr.Last_Hosted] (Day:Hour), thats [In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)] /15 Hours ago."

				Invite_to_Village()
					set category="Faction Leader"
					if(WAR) return
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village=="Missing") li+=X
//					for(var/mob/human/X in li)
//						if(X.faction.village!="Missing") li-=X

					if(length(li)<1)
						usr<<"No candidates! Player must be Missing and not be in a Clan"
						return

					var/mob/human/M=input(usr,"Who do you wish to Invite","Invite") as null|anything in li
					if(M)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tvillage_invite\t[src]\t[faction]\t[M]"
						var/cert=alert(M,"Are you sure?!","Invite", "Yes", "No")
						if(cert=="No")return

						var/accept=input(M,"You have been invited to join [usr.faction.village]<br>This will remove you from any factions you are currently a member of.","Accept?", "Yes", "No")
						if(accept=="Yes")
							world<<"[M] has joined [faction.village]"
							M.faction.RemoveMember(M)
							faction.AddMember(M)
				Kick_from_Village()
					set category="Faction Leader"
					if(WAR) return
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && X!=src) li+=X
					var/mob/human/M=input(usr,"Who do you wish to kick from the village","Kick") as null|anything in li
					if(!M)
						return
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tvillage_kick\t[src]\t[faction]\t[M]"
					world<<"[M] has been exiled from [M.faction.village]!"
					M.faction.RemoveMember(M)
					missing_faction.AddMember(M)
				Add_Helper()
					set category = "Faction Leader"
					if(length(helpers[usr.faction.name]) >= 10)
						alert(usr, "Your village has reached its helper cap")
						return
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village) li+=X
					var/mob/human/M=input(usr,"Who do you wish to make a helper?","Add Helper") as null|anything in li
					if(M)
						if(length(helpers[usr.faction.name]) >= 10)
							alert(usr, "Your village has reached its helper cap")
							return
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tadd_helper\t[src]\t[faction]\t[M]"
						SendInterserverMessage("add_helper", list("name" = M.name, "village" = usr.faction.name))
				Remove_Helper()
					set category = "Faction Leader"
					var/name=input(usr,"Who do you wish to remove helper status from?","Remove Helper") as null|anything in helpers[usr.faction.name]
					if(name)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tremove_helper\t[src]\t[faction]\t[name]"
						SendInterserverMessage("remove_helper", list("name" = name, "village" = usr.faction.name))
				Mute_KAGE()
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && !X.mute) li+=X
					var/mob/human/M=input(usr,"Who do you wish to mute?","Mute") as null|anything in li
					if(M)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tmute\t[src]\t[faction]\t[M]"
						M.mute=1
						world<<"[M] is muted"
						var/c_id = M.client.computer_id
						mutelist+=c_id
						src = null
						spawn(18000)
							mutelist-=c_id
							if(M && M.mute)
								M.mute=0
								world<<"[M.realname] is unmuted"
				Unmute_KAGE()
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && X.mute==1) li+=X
					var/mob/human/M=input(usr,"Who do you wish to unmute?","Unmute") as null|anything in li
					if(M)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tunmute\t[src]\t[faction]\t[M]"
						M.mute=0
						mutelist-=M.client.computer_id
						world<<"[M] is unmuted"
				Unmute_All_KAGE()
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tunmute_all\t[src]\t[faction]"
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && X.mute==1)
							X.mute=0
							mutelist-=X.client.computer_id
							world<<"[X] is unmuted"
		non_default
			verb
				Invite_to_Faction(mob/M in oview())
					set category="Faction Leader"
					if(faction && (!M.faction || M.faction.village == faction.village))
						if(faction.member_limit)
							var/faction_members = SendInterserverMessage("faction_member_count", list("faction" = faction.name))
							if(faction_members < faction.member_limit)
								usr << "Your faction is full!"
								return

						file("logs/faction_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tfaction_invite\t[src]\t[faction]\t[M]"
						if(input2(M,"Would you like to join [src]'s faction \"[faction]\"?","Faction Invite",list("Yes","No")) == "Yes")
							if(faction.member_limit)
								var/faction_members = SendInterserverMessage("faction_member_count", list("faction" = faction.name))
								if(faction_members < faction.member_limit)
									usr << "Your faction is full!"
									return
							M.faction.RemoveMember(M)
							faction.AddMember(M)

				Kick_from_Faction(mob/M in (faction.online_members-src))
					set category="Faction Leader"
					if(input2(src,"Are you sure you would like to kick [M] from your faction?","Faction Kick",list("Yes","No")) == "Yes")
						file("logs/faction_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tfaction_kick\t[src]\t[faction]\t[M]"
						faction.RemoveMember(M)
						switch(faction.village)
							if("Konoha")
								M.faction = leaf_faction
							if("Kiri")
								M.faction = mist_faction
							if("Suna")
								M.faction = sand_faction
							else
								M.faction = missing_faction
						M.faction.AddMember(M)