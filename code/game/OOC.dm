var/list/newbies = list()
var/list/helpers = list()
mob/var
	admin_chat=""
	admin_chat_2=""
	admin_chat_3=""
	admin_chat_4=""

mob/human/Topic(href,href_list[])
	switch(href_list["action"])
		if("mute")
			mute=2
			world<<"[realname] is muted"
			var/c_id = client.computer_id
			mutelist+=c_id
			var/mob/M = src
			src = null
			spawn(18000)
				mutelist-=c_id
				if(M && M.mute)
					M.mute=0
					world<<"[M.realname] is unmuted"
		else
			. = ..()

var/O_Mute = 0

mob/Community_Guide/verb
	OOC_Mute()
		set name = ".ooc"
		if(O_Mute == 1)
			O_Mute = 0
			world << "OOC has been <b>enabled</b>."
			return
		O_Mute = 1
		world << "OOC has been <b>disabled</b>."

mob/human/player
	newbie
		verb
			NOOC(var/t as text)
				if(O_Mute)
					if(usr.key=="Ninitoniazo"||src in GM||src in CG||src in DEV||src in ADM)
						usr<<"<font size=1>You may continue"
					else
						alert("OOC's muted at the moment.")
						return
				winset(usr, "map", "focus=true")

				if(usr.mute||usr.tempmute)
					usr<<"You're muted"
				else
					if(usr.name!="" && usr.name!="player" && usr.initialized)
						usr.talkcool=20
						usr.talktimes+=1
						if(FilterText(t,chat_filter))
							usr<<"<font color=green><b>Please do not try to advertise on this game</b></font color>"
							world<<"<font color=green>[usr] has been auto-muted for trying to advertise in OOC</b><font color>"
							usr.mute=2
							sleep(6000)
							usr.mute=0
						if(usr.talktimes>=8)
							usr<<"You have been temporarily muted for talking too quickly."
							usr.tempmute=1
							sleep(100)
							usr<<"temp mute lifted"
							usr.tempmute=0
							usr.talktimes=0
						if(usr.talkcooling==0)
							spawn()usr.talkcool()
						if(length(t) <= 500&&usr.say==1)
							usr.say=0
							var/rrank=usr.rank
							if((faction in list(leaf_faction,mist_faction,sand_faction,samegakure_faction,vincentgakure_faction)) && realname == faction.leader)
								rrank="Kage"
							if((faction in list(amegakure_faction,otogakure_faction,akatsuki_faction)) && realname == faction.leader)
								rrank="Leader"
							if((faction in list(dark_leagence_faction)) && realname == faction.leader)
								rrank="God Of Darkness"
							for(var/mob/M in newbies)
								if(M.tooc == 0)
									if(M.ckey in admins)
										M<<"<span class='help'><span class='villageicon'>\icon[faction_chat[usr.faction.chat_icon]]</span><b>{<span class='handle'>[usr.handle]</span>}</b><span class='adminchat4'>[usr.admin_chat_4]</span><span class='adminchat2'>[usr.admin_chat_2]</span><span class='adminchat'>[usr.admin_chat]</span><span class='adminchat3'>[usr.admin_chat_3]</span>(<a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[usr.realname]</span></a>){<span class='rank'>[rrank]</span>} <span class='message'>[html_encode(t)]</span></span>"
									else
										M<<"<span class='help'><span class='villageicon'>\icon[faction_chat[usr.faction.chat_icon]]</span><b>{<span class='handle'>[usr.handle]</span>}</b><span class='adminchat4'>[usr.admin_chat_4]</span><span class='adminchat2'>[usr.admin_chat_2]</span><span class='adminchat'>[usr.admin_chat]</span><span class='adminchat3'>[usr.admin_chat_3]</span>(<span class='name'>[usr.realname]</span>){<span class='rank'>[rrank]</span>} <span class='message'>[html_encode(t)]</span></span>"
								else
									M<<"OOC is muted at the moment."
							ChatLog("newbie") << "[time2text(world.timeofday, "hh:mm:ss")]\t[usr.realname]\t[html_encode(t)]"
							sleep(2)
							usr.say=1
						else
							world<<"[html_encode(usr.realname)]/[usr.key] is temporarily muted for spamming"
							usr.tempmute=1
							sleep(200)
							usr.tempmute=0


mob
	var
		handle = ""

mob/verb
	Change_Handle(var/T as text)
		set desc = "This is your OOC title that other players will see next to your name."
		var/old=usr.handle
		T = Replace_All(T, chat_filter)
		if(findtext(T,"<h2>")||findtext(T,"<size>")||findtext(T, "<")||findtext(T, ">"))
			usr << "Noob trying to get a gay ass handle!"
			return
		if(!findtext(T, "<font>") && length(T) <= 20)
			handles_save:Remove(old)
			usr.handle = T
			handles_save:Add(usr.handle)
			//usr << "Handle changed."
		else
			usr << "You can't have that handle."
mob/Admin/verb
	Clear_Handles()
		for(var/mob/O in world)
			if(O.handle)
				O.handle = ""
	Edit_Handle(var/mob/O in All_Clients())
		set name = ".handle"
		var/New = input(usr, "What is their new handle?") as text
		if(O)
			O.handle = New

world
	New()
		..()
		HandleLoad()
	Del()
		..()
		HandleSave()

mob/human/player/New()
	..()
	var/G = src.handle
	if(handles_save.Find(G))
		src.handle=G

proc
	HandleSave()
		if(length(handles_save))
			var/savefile/F = new("Handles.sav")
			F["handles_save"] << handles_save
	HandleLoad()
		if(fexists("Handles.sav"))
			var/savefile/F = new("Handles.sav")
			F["handles_save"] >> handles_save

var/list/handles_save=list()