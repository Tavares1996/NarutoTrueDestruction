//#define GOA_TESTSERVER


mob/proc/combat(msg)
	src<< output("[msg]", "combat_output")

mob/var/Last_Hosted=0
proc
	In_Hours(X)
		var/separator_pos = findtext(X,":")
		var/Days = text2num(copytext(X, 1, separator_pos))
		var/Hours = text2num(copytext(X, separator_pos + 1))

		return Days * 24 + Hours

	Remove_Clans(vil,list/l2)
		var/list/L=new
		for(var/mob/human/X in l2)
			if(X.skills)
				if(vil!="Konoha" && (X.clan in list("Uchiha", "Hyuuga", "Nara", "Akimichi")))
					continue
				if(vil!="Kiri" && (X.clan in list("Kaguya", "Jashin", "Haku")))
					continue
				if(vil!="Suna" && (X.clan in list("Deidara", "Sand Control", "Puppeteer")))
					continue
				L += X

		return L

	All_Clients()
		var/list/L=new
		for(var/mob/human/player/Lp in world)
			if(Lp.client)L+=Lp
		return L

mob/Community_Guide/verb
	Teleport(mob/M in All_Clients())
		usr.loc=M.loc
	Summon(mob/M in All_Clients())
		M.loc=usr.loc
mob/Developer/verb
	View_CHG(var/m as num)
		usr.client.view=m
	Save_Listen()
		if(SaveListen.Find(usr.client))
			SaveListen-=src.client
			usr<<"You are no longer watching saves."
		else
			SaveListen+=usr.client
			usr<<"You are now watching saves."


client/Topic(href,href_list[],hsrc)
	switch(href_list["action"])
		if("inter_mute")
			return
			src << "<span class='mute_notify'><span class='interserver'>[href_list["name"]] is muted!</span></span>"
			spawn() SendInterserverMessage("mute", href_list)
		else
			. = ..()

proc
	StyleClassFilter(text)
		return Replace(text, " ", "_")

	MultiAnnounce(message, show_self=1)
		if(show_self)
			world << message

		return SendInterserverMessage("announce", list("msg" = message))

	SendInterserverMessage(action, params)
		if(!address_of_other_server) return
		params["action"] = action
		params["Password"] = PASS
		return world.Export("[address_of_other_server]?[list2params(params)]")
var
	address_of_other_server
	maxplayers = 100
	block_alts = 0

world/proc/Shutdown_In(H)
	var/timeleft = H*60*60 // 1 hour = 60 minutes = 60*60 seconds

	while(timeleft > 0 || chuuninactive)
		sleep(10)
		timeleft--

	WSave()

	for(var/mob/human/X in world)
		if(X.client) X << "The World is rebooting, click <a href=byond://[internet_address]:[port]>byond://[internet_address]:[port]</a>"

	sleep(30)

	shutdown()

var
	sname="Public Server"
	save_path
	RB_Time=0
	sql_host
	sql_database
	sql_user
	sql_password

world/New()
	..()

	if(!lp_mult)
		lp_mult=100

	if(!save_path)
		save_path = "Players"

	if(RB_Time)
		spawn() Shutdown_In(RB_Time)

	if(savelead<2)
		savelead=2

	if(port)
		SendInterserverMessage("newserver", list())

	if(RP)
		spawn()RPMode()

	initialize_basic_factions()
	sleep(10)
	Load_Faction()

world/Del()
	Save_Faction()
	if(port)
		SendInterserverMessage("removeserver", list())
	..()

mob/Admin/verb
	Export_Icon()
		var/mob/x=usr
		var/icon/IP = new('icons/underpreview.dmi')
		if(x.icon)
			IP.Blend(icon(x.icon,"",SOUTH,1),ICON_OVERLAY)
		for(var/X in x.overlays)
			if(X && X:icon)
				IP.Blend(icon(X:icon,"",SOUTH,1),ICON_OVERLAY)

		usr << ftp(IP,"[x.name].dmi")

	Change_Sight()
		usr.invisibility=0
		usr.see_invisible=0
		usr.sight=(BLIND|SEE_MOBS|SEE_OBJS)

		sleep(100)
		usr.sight=0

		usr.invisibility=0
		usr.see_invisible=0

mob
	var
		checkservs = 0
		checking = 0

	proc/CheckServers()
		checkservs = 1

		if(sname=="Public Server"||!leaf_faction || !missing_faction || !mist_faction || !sand_faction)
			src<<"Wait for the server to finish loading."
			return 0

		var/client/C = src.client

		if(C && (C.ckey in admins))
			return 1

		if(C && !checking)
			checking = 1
			var/r = SendInterserverMessage("is-logged-in", list("key" = ckey, "computer-id" = C.computer_id))

			if(r)
				src << "You are already logged in on a different server!"
				del(src)
				return 0

			checking = 0
			return 1

var/list/SaveListen=new/list()

//reciever
proc
	Delete_Save(K,C)
		SendInterserverMessage("delete_save", list("key" = K, "char" = C))

	Rename_Save(key, name_old, name_new)
		SendInterserverMessage("rename_save", list("key" = key, "name_old" = name_old, "name_new" = name_new))

world/proc
	Update_Save(k,list/S)
		var/list/strg = S[3]
		for(var/i = 1, i <= strg.len, ++i)
			strg[i] = Escape_String(strg[i])

		var/i = SendInterserverMessage("update_save", list("inv" = S[1],"bar" = S[2],"strg" = S[3],"nums" = S[4],"lst" = S[5], "key" = k))
		sleep(100)
		var/e = 0
		while(!i && e < 5)
			e++
			i = SendInterserverMessage("update_save", list("inv" = S[1],"bar" = S[2],"strg" = S[3],"nums" = S[4],"lst" = S[5], "key" = k))
			sleep(100)
		if(!i)
			world.log << "Update_Save([k]) failed."

proc
	Replace(text,word,replace)
		var/pos = findtext(text,word)
		while(pos)
			text = copytext(text,1,pos) + replace + copytext(text,pos+length(word))
			pos = findtext(text,word)
		return text

/*
	Replace All proc
	replace_list: list in the format word = replace
	replaces each word with it's replace entry
*/
	Replace_All(text,replace_list)
		for(var/word in replace_list)
			var/pos = findtext(text,word)
			while(pos)
				text = copytext(text,1,pos) + replace_list[word] + copytext(text,pos+length(word))
				pos = findtext(text,word)
		return text

	Escape_String(str)
		return Replace_All(str, list(";" = " ", "$" = " ", "&" = " "))

	//////////////////////////////////////////////////////////////////////////////
	// limit(minimun, value, maximum)
	//   Limits val between min and max (so that min <= returned <= max)
	//////////////////////////////////////////////////////////////////////////////
	limit(min, val, max)
		return min(max, max(min, val))
