var
	PASS=""
	SkipCount = 10
	Lcount = 0
	voteclear = 10
	list
		DeathList = new/list
		tolog = new()
mob/var/logger=0

world
	mob=/mob/charactermenu
	view=8
	turf=/turf/denseempty
	name = "Naruto Goa Chronicles"
	status = "Naruto Goa Chronicles"
	hub = "Ninitoniazo.NarutoGoaChronicles"
	hub_password= "narutoregeneration123456"
	tick_lag = 1
	loop_checks = 0

#if DM_VERSION >= 455
	map_format = TILED_ICON_MAP
	icon_size = 32
#endif

var
	list
		Names=list()
		Handles=list()


world
	proc
		WorldSave()
			set background = 1
			var/list/O = new
			for(var/mob/human/player/X in world)
				if(X.client)
					O+=X
			for(var/mob/M in O)
				if(M.client)
					M.client.SaveMob()
					sleep(100)
					sleep(-1)
			sleep(100)
			spawn()WorldSave()

		WSave()
			for(var/mob/human/player/O in world)
				if(O.client && O.initialized)
					spawn()O.client.SaveMob()

		WorldLoop_Status()
			set background = 1
			spawn() bingosort()
			sleep(3000)
			var/c = 0
			for(var/mob/human/player/X in world)
				if(X.client)
					c++
				if(X.ckey in admins)
					X << "World status changed"
			world.status = "{[sname]}([c]/[maxplayers])"

			wcount=c
			sleep(500)
			spawn()WorldLoop_Status()

		Worldloop_VoteClear()
			set background = 1 //infinite loops do well to be set as not high priority
			spawn()
				if(voteclear)
					voteclear--
					if(voteclear <= 0)
						Mute_Elects = new/list()
						voteclear = 10

				sleep(600)
				spawn() Worldloop_VoteClear()


		NameCheck(xname)
			return SendInterserverMessage("check_name", list("name" = xname))

	New()
		..()
		spawn(20)
			for(var/mob/human/player/npc/X in world)
				if(X.questable && !X.onquest&&X.difficulty!="A")
					switch(X.locationdisc)
						if("Kawa no Kuni")
							Town_Kawa+=X
						if("Cha no Kuni")
							Town_Cha+=X
						if("Ishi no Kuni")
							Town_Ishi+=X
						if("Konoha")
							Town_Konoha+=X
						if("Suna")
							Town_Suna+=X
						if("Kiri")
							Town_Mist+=X

		spawn() WorldLoop_Status()

		spawn() Worldloop_VoteClear()

mob
	Admin/verb
		World_Save()
			world << "<b><font color=#fff67f><center>[usr] is saving all files"
			sleep(5)
			for(var/mob/M in world) if(M.client)
				M.client.SaveMob()
				M << "\red You have been saved."
			sleep(3)
			world << "<b><font color=#fff67f><center>[usr] has saved all files"

		Ban(mob/M in All_Clients())
			set category = "Bans"
			if(M.client)
				SendInterserverMessage("add_ban", list("key" = M.ckey, "computer_id" = M.client.computer_id))
				src << "Banned [M] ([M.key], [M.client.computer_id])"
				del(M.client)

		Unban_Key(key as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("key" = ckey(key)))
			src << "Unbanned [key]"

		Unban_Computer(computer_id as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("computer_id" = computer_id))
			src << "Unbanned [computer_id]"

		Unban(key as text, computer_id as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("key" = ckey(key), "computer_id" = computer_id))
			src << "Unbanned [key], [computer_id]"

		Ban_Key(key as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("key" = ckey(key)))
			src << "Banned [key]"

		Ban_Computer(computer_id as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("computer_id" = computer_id))
			src << "Banned [computer_id]"

		Ban_Manual(key as text, computer_id as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("key" = ckey(key), "computer_id" = computer_id))
			src << "Banned [key], [computer_id]"

		Give_Money(mob/M in All_Clients(), x as num)
			M.money+=x

		Set_Tick_Lag(x as num)
			if(x<1)
				x=1
			if(x>3)
				x=3
			world.tick_lag=x
			usr<<"world tick_lag=[world.tick_lag]"

		LOCATE(ex as num, ey as num, ez as num)
			usr.loc=locate(ex,ey,ez)

mob
	Developer
		verb
			Give_Attribute(mob/human/player/M in All_Clients(), levelpoints as num)
				M.levelpoints += levelpoints

			Edit(var/O as obj|mob|turf in view(src))
				set name = ".edit"
				var/variable = input("Which var?","Var") in O:vars + list("Cancel")
				if(variable == "Cancel")
					return
				var/default
				var/typeof = O:vars[variable]
				if(isnull(typeof))
					default = "Text"
				else if(isnum(typeof))
					default = "Num"
					dir = 1
				else if(istext(typeof))
					default = "Text"
				else if(isloc(typeof))
					default = "Reference"
				else if(isicon(typeof))
					typeof = "\icon[typeof]"
					default = "Icon"
				else if(istype(typeof,/atom) || istype(typeof,/datum))
					default = "Type"
				else if(istype(typeof,/list))
					default = "List"
				else if(istype(typeof,/client))
					default = "Cancel"
				else
					default = "File"
				var/class = input("What kind of variable?","Variable Type",default) in list("Text","Num","Type","Reference","Icon","File","Restore to default","List","Null","Cancel")
				switch(class)
					if("Cancel")
						return
					if("Restore to default")
						O:vars[variable] = initial(O:vars[variable])
						text2file("[time2text(world.realtime)]: [O] was restored to default by [usr]<BR>","GMlog.html")
					if("Text")
						O:vars[variable] = input("Enter new text:","Text",O:vars[variable]) as text
						text2file("[time2text(world.realtime)]: [O] had one of his [variable] edited with text by [usr]<BR>","GMlog.html")
					if("Num")
						O:vars[variable] = input("Enter new number:","Num",O:vars[variable]) as num
						text2file("[time2text(world.realtime)]: [O] had one of his [variable] edited with numbers by [usr]<BR>","GMlog.html")
					if("Type")
						O:vars[variable] = input("Enter type:","Type",O:vars[variable]) in typesof(/obj,/mob,/area,/turf)
					if("Reference")
						O:vars[variable] = input("Select reference:","Reference",O:vars[variable]) as mob|obj|turf|area in world
					if("File")
						O:vars[variable] = input("Pick file:","File",O:vars[variable]) as file
					if("Icon")
						O:vars[variable] = input("Pick icon:","Icon",O:vars[variable]) as icon
					if("List")
						input("This is what's in [variable]") in O:vars[variable] + list("Close")
					if("Null")
						if(alert("Are you sure you want to clear this variable?","Null","Yes","No") == "Yes")
							O:vars[variable] = null

mob
	var
		tooc = 0
	verb
		toggle_ooc()
			set category = "Other"

			if(usr && usr.tooc == 0)
				usr.tooc = 1
				usr << "OOC's has been turned off."
			else
				usr.tooc = 0
				usr << "OOC's has now been turned on."