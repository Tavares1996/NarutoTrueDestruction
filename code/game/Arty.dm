/*var/seal_time_for_steam
proc/steam(mob/human/user)
	if(usr.dragon_steam_active)
		var/time = seal_time_for_steam
		if(user.move_stun) time = time*2+5
		var/obj/Water/X
		if(X in oview(src, 10))
			var/obj/Steam/x=new/obj/Steam(locate(X.x,X.y,X.z))
			for(, time > 0, --time)
				sleep(1)
				if(time <= 0)
					del(x)
				if(!user || !user.CanUseSkills())
					break
	else return
*/
mob
	var
		block_arena = 0
		block_whispers = 0

var/list/arena_condition=list()

var/list/Bans=new/list

proc/Save_an()
	var/savefile/S=new("Ban Save")
	S["Bans"]<<Bans
proc/Load_Ban()
	if(fexists("Ban Save"))
		var/savefile/S=new("Ban Save")
		S["Bans"]>>Bans



proc //the Proc!
	ServerSave()// Proc name so we can call it to save the reports
		if(length(Reports))//If there are any reports in the list
			var/savefile/F = new("Server Saves/Reports.sav")// Makes a save file for them to go to
			F["Reports"] << Reports//Writes the reports so they can be loaded later
	ServerLoad()// Proc name so we can call it to load the reports
		if(fexists("Server Saves/Reports.sav"))// if there is a file that has reports
			var/savefile/F = new("Server Saves/Reports.sav")// load all the reports so you can view them
			F["Reports"] >> Reports//just gives the reports back into the list

world
	New()
		ServerLoad()//Load the reports if there are any!
		..()
	Del()
		ServerSave()//Save them so we can load them later or even view them later
		..()
var
	list
		Reports = list()// The list we use to put all the reports in!

mob/var/claimed=0
mob/human/player/verb
	Claim_Points()
		if(src.killed_player>0&&!src.claimed)
			spawn()
				src.claimed=1
				src<<"Please don't log out or relog for your points to add"
				sleep(10*60*5)
				src.player_total+=src.killed_player
				src.killed_player=0
				src<<"You now have [src.player_total] points to spend on ranks or skill points"
				src.claimed=0
		else src<<"You have already claimed the points, please wait for a few minutes for the points to get added to your account"
	Spend_Points()
		var/list = input(src,"You have [src.player_total] Tokens to spend")\
		in list("Rank: Special Jounin | Cost: 60","Rank: Jounin | Cost: 90","Levelpoints Points+3 | Cost: 200","Skill Points+50 | Cost: 1","Cancel")
		if(list=="Rank: Special Jounin | Cost: 60"&&src.player_total>=60)
			src.player_total-=60
			src.rank="Special Jounin"
			world << "[src] has is now a [src.rank]"
			src << "Please bare in mind if the kage chooses to demote you, please respect his/her decision"
		if(list=="Rank: Jounin | Cost: 90"&&src.player_total>=90)
			src.player_total-=90
			src.rank="Jounin"
			world << "[src] has is now a [src.rank]"
			src << "Please bare in mind if the kage chooses to demote you, please respect his/her decision"
		if(list=="Levelpoints Points+3 | Cost: 200"&&src.player_total>=200)
			src.player_total-=110
			src.levelpoints+=3
			world << "[src] has is now a [src.rank]"
		if(list=="Skill Points+50 | Cost: 1"&&src.player_total>=1)
			src.player_total-=1
			src.skillpoints+=50
			src<<"You have added 50 skill points to spend on any skill in the skill tree"
		if(list=="Cancel")
			return
	Forum()
		src << link("http://w11.zetaboards.com/NLLProductions/index/")
	Hub()
		src << link("http://www.byond.com/games/Sasuk8/Naruto")

mob
	proc
		Reflex_Roll(mob/attacker,mob/nub)
			var/Roll=(attacker.rfx+attacker.rfxbuff-attacker.rfxneg)-(nub.rfx+nub.rfxbuff-nub.rfxneg)
			if(Roll<50)
				return 100
			if(Roll<101)
				return 90
			if(Roll<151)
				return 80
			if(Roll<201)
				return 70
			if(Roll<251)
				return 60
			if(Roll<301)
				return 50
			if(Roll<349)
				return 40
			if(Roll<399)
				return 30
			if(Roll<449)
				return 20
			if(Roll<499)
				return rand(10,20)
			if(Roll>499)
				return rand(10,20)

var
	Using_Arena = 0
/*
proc/Timer_10_Minutes()
	var/time=1200
	while(time > 0)
		time--
		sleep(10)
		if(usr.block_arena==1 && time <= 0)
			usr << "You arena has been unblocked now"
			usr.block_arena=0
		return
*/
mob/var/arena=0
mob
	var
		Arena_Battle = 0



mob/human/player
	verb
		Suggestion()//The verb!
			set category = "Character"
			//All this is basic stuff, inputs, and checks to make sure no one abuses this to the max and just spams it
			var/reportcategory = input("Making a suggestion, go with whatever category your suggestionn is supposed to be in.","File Report")\
			in list("Bug / Glitch","Map / Villages","Nerfs / Buffs","New Jutsus","Other","Donations","Cancel")
			var/reportname = input("Please name your Suggestion.","Suggestion Name") as text | null
			set category = "Other"
			if(!reportname)
				usr<<"<small><b><font color=red>Your report failed to send, beause it has no name</font color></b></small>"
				return
			if(length(reportname) > 50)
				usr<<"<small><b><font color=red>Your report failed to send, because it was longer than 50 characters</font color></b></small>"
				return
			var/reportdesc = input("Now please describe your Suggestion\n- Your IP, Key, and Name are being logged","Explanation") as text | null
			if(!reportdesc)
				usr<<"<small><b><font color=red>Your report failed to send, because it had no explanation</font color></b></small>"
				return
			//Log the report in the list so it can be later viewed!
			Reports+="[time2text(world.realtime)] - <b>[reportcategory]</b> [usr.client.address] - [usr] ([usr.key])<br><b><u>[html_encode(reportname)]</u></b><br>[html_encode(reportdesc)]<br>---"
			usr<<"<small><b>Your suggestion has been sent and will be read.</b></small>"//Tell them that their report was successfully sent

		Check_Registered_Fighters_Player()
			for(var/mob/x in fighter_reg)
				usr<<"<b><font color=red>[x.realname]</b></font>"

		Watch_Fight_Player()
			var/list/li=new
			for(var/mob/human/player/x in world)
				if(x.inarena)
					li+=x
			if(li && li.len)
				var/mob/spec=input3(usr,"Who do you wish to spectate","Spectate", li)
				if(spec)
					if(spec.inarena)
						usr.spectate=1
						usr.client.eye=spec
						usr<<"<font size=+1>Spectating, Hit the Interact Button or Space to return. (Only your vision has changed, your character is still in the same spot.)</font>"

		Save()
			usr << "<font color=#fff67f> Saving....."
			sleep(10)
			client.SaveMob()
			usr << "<font color=#fff67f> Saved!"

		Toggle_Combat()
			if(toggle_combat==1)
				toggle_combat=0
				usr<<"<font color=red>You have toggled your combat output off"
			else
				toggle_combat=1
				usr<<"<font color=red>You have toggled your combat output on"

		Update()
			var/window = {"
<STYLE>BODY {background: black; color: white}</STYLE>
<html>
<body>
<center>
<font size=3>
<font face=cambria>
<b>
<u>Updates V.3.2</u>
<br>
<br>Date: 30/5/13
<br>
<br>-Added New Lightning Jutsu
<br>-Added New Wind Jutsus
<br>-New Factions Have Been Fixed And Added
<br>-Title Code Has Been Programmed
<br>-New Admin System
<br>-New Staff(Admins)
<br>
<br><u>Staff
<br>MainOwner/Pre-Coder/Programmer:(Kstone)
<br>/Host:()
<br>/Iconner:()
<br>Admin()
<br>/GFX Artist:()
<br>
<br>Naruto Goa Chronicles,
<br>
<br>
<br>
<br>
</b>
</font>
</center>
</body>
</html>
</b>
</font>
</center>
</body>
</html>
"}
			usr << browse(window,"window=Updates;size=500x300")
			..()

mob
	Developer
		verb
			Read_Suggestion()
				set category = "Admin"
				var/list/suggestions = new
				suggestions += "Cancel"
				for(var/x in Reports)
					suggestions += x
				var/read = input("Which one would you like to read") as anything in suggestions
				if(read == "Cancel")
					return 0
				usr << browse(read,"window=browser-popup")


var/list
	regular_arena=list("being_used"=0, "player_1"=null, "player_2"=null)
	chuunin_arena=list("being_used"=0, "player_1"=null, "player_2"=null)
	island_arena=list("being_used"=0, "player_1"=null, "player_2"=null)
	konoha_arena=list("being_used"=0, "player_1"=null, "player_2"=null)

mob/var/used_arena=null


mob
	verb
		check_logs(file as anything in flist("logs/"))
			usr << browse(file2text(file))
			winshow(usr, "browser-popup", 1)
		Arena_Challenge(mob/O in All_Clients())
			if (!initialized || !O.initialized) return
/*
			if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)  <0)
				usr.Last_Hosted=0
			if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted) >0.009)*/
			else if(initialized && O.initialized)
				var/list/arena_list = list()

				arena_list.Add("Regular Arena - In Use? [regular_arena["being_used"] ? "Yes" : "No"]")
				arena_list.Add("Chuunin Arena - In Use? [chuunin_arena["being_used"] ? "Yes" : "No"]")
				arena_list.Add("Destroyed Konoha Outlands - In Use? [konoha_arena["being_used"] ? "Yes" : "No"]")
				arena_list.Add("The Island - In Use? [island_arena["being_used"] ? "Yes" : "No"]")

				var _chosen_arena = input(usr, "Which arena do you want to use?", "Choose Arena") in arena_list

				usr.Last_Hosted=time2text(world.realtime,"DD:hh")

				if (findtext(_chosen_arena, "Regular"))
					if (regular_arena["being_used"]==0)
						if (O && usr && !O.inarena && !usr.inarena && !O.block_arena && !usr.block_arena)
							var arena_challenge = input(O, "Do you accept [usr]'s challenge in the arena?") in list ("Yes", "No")
							if(arena_challenge == "Yes" && O && usr && O != usr && usr.ko != 1 && O.ko != 1 && !regular_arena["being_used"] && usr.used_arena!="regular" && O.used_arena!="regular" && usr.used_arena!="chuunin" && O.used_arena!="chuunin" && usr.used_arena!="konoha" && O.used_arena!="konoha" && usr.used_arena!="island" && O.used_arena!="island")
								regular_arena["being_used"]=1
								regular_arena["player_1"]=usr.realname
								regular_arena["player_2"]=O.realname
								usr.used_arena="regular"
								O.used_arena="regular"

								arena_condition+=usr

								world << "<b>[usr]</b> has challenged <b>[O]</b>!"
								world << "The <b>Regular Arena</b> is now in use."

								usr.oldx = usr.x
								usr.oldy = usr.y
								usr.oldz = usr.z
								usr.inarena = 2
								usr.stunned = 90

								O.oldx = O.x
								O.oldy = O.y
								O.oldz = O.z
								O.inarena = 2
								O.stunned = 90

								usr.loc = locate_tag("challenge_2")
								O.loc = locate_tag("challenge_1")


								if(usr.shopping)
									usr.shopping = 0
									usr.canmove = 1
									usr.see_invisible = 0

								if(O.shopping)
									O.shopping = 0
									O.canmove = 1
									O.see_invisible = 0

								spawn()
									spawn(40)
										usr.stunned = 0
										usr.curstamina = usr.stamina
										usr.curchakra = usr.chakra
										usr.curwound = 0
									usr << "Start on GO."
									sleep(10)
									usr << "3..."
									sleep(10)
									usr << "2..."
									sleep(10)
									usr << "1..."
									sleep(10)
									usr << "GO!"

								spawn()
									spawn(40)
										O.stunned = 0
										O.curstamina = O.stamina
										O.curchakra = O.chakra
										O.curwound = 0
									O << "Start on GO."
									sleep(10)
									O << "3..."
									sleep(10)
									O << "2..."
									sleep(10)
									O << "1..."
									sleep(10)
									O << "GO!"

							else

								usr.inarena = 0
								usr.oldx = 0
								usr.oldy = 0
								usr.oldz = 0
								usr.stunned = 0.1

								O.inarena = 0
								O.oldx = 0
								O.oldy = 0
								O.oldz = 0
								O.stunned = 0.1


				if (findtext(_chosen_arena, "Chuunin"))
					if (chuunin_arena["being_used"]==0)
						if (O && usr && !O.inarena && !usr.inarena && !O.block_arena && !usr.block_arena)
							var arena_challenge = input(O, "Do you accept [usr]'s challenge in the arena?") in list ("Yes", "No")
							if(arena_challenge == "Yes" && O && usr && O != usr && usr.ko != 1 && O.ko != 1 && !chuunin_arena["being_used"] && usr.used_arena!="regular" && O.used_arena!="regular" && usr.used_arena!="chuunin" && O.used_arena!="chuunin" && usr.used_arena!="konoha" && O.used_arena!="konoha" && usr.used_arena!="island" && O.used_arena!="island")
								chuunin_arena["being_used"]=1
								chuunin_arena["player_1"]=usr.realname
								chuunin_arena["player_2"]=O.realname
								usr.used_arena="chuunin"
								O.used_arena="chuunin"

								arena_condition+=usr

								world << "<b>[usr]</b> has challenged <b>[O]</b>!"
								world << "The <b>Chuunin Arena</b> is now in use."

								usr.oldx = usr.x
								usr.oldy = usr.y
								usr.oldz = usr.z
								usr.inarena = 2
								usr.stunned = 90

								O.oldx = O.x
								O.oldy = O.y
								O.oldz = O.z
								O.inarena = 2
								O.stunned = 90

								usr.loc = locate_tag("challenge_8")
								O.loc = locate_tag("challenge_7")


								if(usr.shopping)
									usr.shopping = 0
									usr.canmove = 1
									usr.see_invisible = 0

								if(O.shopping)
									O.shopping = 0
									O.canmove = 1
									O.see_invisible = 0

								spawn()
									spawn(40)
										usr.stunned = 0
										usr.curstamina = usr.stamina
										usr.curchakra = usr.chakra
										usr.curwound = 0
									usr << "Start on GO."
									sleep(10)
									usr << "3..."
									sleep(10)
									usr << "2..."
									sleep(10)
									usr << "1..."
									sleep(10)
									usr << "GO!"

								spawn()
									spawn(40)
										O.stunned = 0
										O.curstamina = O.stamina
										O.curchakra = O.chakra
										O.curwound = 0
									O << "Start on GO."
									sleep(10)
									O << "3..."
									sleep(10)
									O << "2..."
									sleep(10)
									O << "1..."
									sleep(10)
									O << "GO!"

							else

								usr.inarena = 0
								usr.oldx = 0
								usr.oldy = 0
								usr.oldz = 0
								usr.stunned = 0.1

								O.inarena = 0
								O.oldx = 0
								O.oldy = 0
								O.oldz = 0
								O.stunned = 0.1


				if (findtext(_chosen_arena, "Destroyed Konoha Outlands"))
					if (konoha_arena["being_used"]==0)
						if (O && usr && !O.inarena && !usr.inarena && !O.block_arena && !usr.block_arena)
							var arena_challenge = input(O, "Do you accept [usr]'s challenge in the arena?") in list ("Yes", "No")
							if(arena_challenge == "Yes" && O && usr && O != usr && usr.ko != 1 && O.ko != 1 && !konoha_arena["being_used"] && usr.used_arena!="regular" && O.used_arena!="regular" && usr.used_arena!="chuunin" && O.used_arena!="chuunin" && usr.used_arena!="konoha" && O.used_arena!="konoha" && usr.used_arena!="island" && O.used_arena!="island")
								konoha_arena["being_used"]=1
								konoha_arena["player_1"]=usr.realname
								konoha_arena["player_2"]=O.realname
								usr.used_arena="konoha"
								O.used_arena="konoha"

								arena_condition+=usr

								world << "<b>[usr]</b> has challenged <b>[O]</b>!"
								world << "The <b>Destroyed Konoha Outlands</b> arena is now in use."

								usr.oldx = usr.x
								usr.oldy = usr.y
								usr.oldz = usr.z
								usr.inarena = 2
								usr.stunned = 90

								O.oldx = O.x
								O.oldy = O.y
								O.oldz = O.z
								O.inarena = 2
								O.stunned = 90

								usr.loc = locate_tag("challenge_4")
								O.loc = locate_tag("challenge_3")


								if(usr.shopping)
									usr.shopping = 0
									usr.canmove = 1
									usr.see_invisible = 0

								if(O.shopping)
									O.shopping = 0
									O.canmove = 1
									O.see_invisible = 0

								spawn()
									spawn(40)
										usr.stunned = 0
										usr.curstamina = usr.stamina
										usr.curchakra = usr.chakra
										usr.curwound = 0
									usr << "Start on GO."
									sleep(10)
									usr << "3..."
									sleep(10)
									usr << "2..."
									sleep(10)
									usr << "1..."
									sleep(10)
									usr << "GO!"

								spawn()
									spawn(40)
										O.stunned = 0
										O.curstamina = O.stamina
										O.curchakra = O.chakra
										O.curwound = 0
									O << "Start on GO."
									sleep(10)
									O << "3..."
									sleep(10)
									O << "2..."
									sleep(10)
									O << "1..."
									sleep(10)
									O << "GO!"

							else

								usr.inarena = 0
								usr.oldx = 0
								usr.oldy = 0
								usr.oldz = 0
								usr.stunned = 0.1

								O.inarena = 0
								O.oldx = 0
								O.oldy = 0
								O.oldz = 0
								O.stunned = 0.1


				if (findtext(_chosen_arena, "The Island"))
					if (island_arena["being_used"]==0)
						if (O && usr && !O.inarena && !usr.inarena && !O.block_arena && !usr.block_arena)
							var arena_challenge = input(O, "Do you accept [usr]'s challenge in the arena?") in list ("Yes", "No")
							if(arena_challenge == "Yes" && O && usr && O != usr && usr.ko != 1 && O.ko != 1 && !island_arena["being_used"] && usr.used_arena!="regular" && O.used_arena!="regular" && usr.used_arena!="chuunin" && O.used_arena!="chuunin" && usr.used_arena!="konoha" && O.used_arena!="konoha" && usr.used_arena!="island" && O.used_arena!="island")
								island_arena["being_used"]=1
								island_arena["player_1"]=usr.realname
								island_arena["player_2"]=O.realname
								usr.used_arena="island"
								O.used_arena="island"

								arena_condition+=usr

								world << "<b>[usr]</b> has challenged <b>[O]</b>!"
								world << "The <b>The Island</b> arena is now in use."

								usr.oldx = usr.x
								usr.oldy = usr.y
								usr.oldz = usr.z
								usr.inarena = 2
								usr.stunned = 90

								O.oldx = O.x
								O.oldy = O.y
								O.oldz = O.z
								O.inarena = 2
								O.stunned = 90

								usr.loc = locate_tag("challenge_5")
								O.loc = locate_tag("challenge_6")


								if(usr.shopping)
									usr.shopping = 0
									usr.canmove = 1
									usr.see_invisible = 0

								if(O.shopping)
									O.shopping = 0
									O.canmove = 1
									O.see_invisible = 0

								spawn()
									spawn(40)
										usr.stunned = 0
										usr.curstamina = usr.stamina
										usr.curchakra = usr.chakra
										usr.curwound = 0
									usr << "Start on GO."
									sleep(10)
									usr << "3..."
									sleep(10)
									usr << "2..."
									sleep(10)
									usr << "1..."
									sleep(10)
									usr << "GO!"

								spawn()
									spawn(40)
										O.stunned = 0
										O.curstamina = O.stamina
										O.curchakra = O.chakra
										O.curwound = 0
									O << "Start on GO."
									sleep(10)
									O << "3..."
									sleep(10)
									O << "2..."
									sleep(10)
									O << "1..."
									sleep(10)
									O << "GO!"

							else

								usr.inarena = 0
								usr.oldx = 0
								usr.oldy = 0
								usr.oldz = 0
								usr.stunned = 0.1

								O.inarena = 0
								O.oldx = 0
								O.oldy = 0
								O.oldz = 0
								O.stunned = 0.1
/*
			else
				usr<<"You last challenged a player at [usr.Last_Hosted], thats [In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)] /30 seconds."
*/

var/toggle_combat=1

mob
	Admin
		verb
			Clear_Names()
				set name = ".clear"
				for(var/N in Names)
					Names.Remove(N)
				for(var/mob/O in world)
					Names.Add(O.name)
				usr << "Names cleared."

mob
	Community_Guide
		verb
			Clear_Arena()
				Using_Arena = 0
				world << "The arena has been cleared by [usr]."

				for(var/mob/O)
					if(O.inarena==2&&O)
						O.inarena=0
						O.curwound=0
						O.curstamina=O.stamina
						O.curchakra=O.chakra
						if(O.oldx&&O.oldy&&O.oldz&&O)
							O.loc=locate(O.oldx,O.oldy,O.oldz)

				regular_arena["being_used"]=0
				regular_arena["player_1"]=null
				regular_arena["player_2"]=null

				chuunin_arena["being_used"]=0
				chuunin_arena["player_1"]=null
				chuunin_arena["player_2"]=null

				island_arena["being_used"]=0
				island_arena["player_1"]=null
				island_arena["player_2"]=null

				konoha_arena["being_used"]=0
				konoha_arena["player_1"]=null
				konoha_arena["player_2"]=null

		verb
			Respec_Player(var/mob/O in All_Clients())
				set category = "Admin"
				set name = ".respec"
				if(O && O.client)
					O.Respec()
mob
	Developer
		verb
			Give_Sword(var/mob/O in All_Clients())
				var/X = input(usr,"Please pick a sword you want to handout") in list ("Samehada","Zabuza","Kabutowari","Shibuki","Nuibari","Kiba","Hiramekarei","Hidan","Chakra Blade","Samurai Sword")
				if(X=="Samehada")
					new/obj/items/weapons/melee/sword/Samehada(O)
				if(X=="Zabuza")
					new/obj/items/weapons/melee/sword/ZSword(O)
				if(X=="Kabutowari")
					new/obj/items/weapons/melee/sword/Kabutowari(O)
				if(X=="Shibuki")
					new/obj/items/weapons/melee/sword/Shibuki(O)
				if(X=="Nuibari")
					new/obj/items/weapons/melee/sword/Nuibari(O)
				if(X=="Kiba")
					new/obj/items/weapons/melee/sword/Kiba(O)
				if(X=="Hiramekarei")
					new/obj/items/weapons/melee/sword/Hiramekarei(O)
				if(X=="Hidan")
					new/obj/items/weapons/melee/sword/HidanS(O)
				if(X=="Chakra Blade")
					new/obj/items/weapons/melee/sword/Chakra_Blade(O)
				if(X=="Samurai Sword")
					new/obj/items/weapons/melee/sword/SamuraiSword(O)

			Advertisement(var/T as text)
				set name = ".ad"
				msg = T
var
	msg = ""

mob
	proc
		Respec()
			//Passives
			skillspassive[25]=0
			skillspassive[26]=0
			skillspassive[27]=0
			skillspassive[28]=0

			//Strength
			skillspassive[2]=0
			skillspassive[9]=0
			skillspassive[10]=0
			skillspassive[11]=0
			skillspassive[12]=0
			skillspassive[13]=0

			//Reflex
			skillspassive[14]=0
			skillspassive[15]=0
			skillspassive[16]=0
			skillspassive[4]=0
			skillspassive[17]=0
			skillspassive[18]=0

			//Intelligence
			skillspassive[8]=0
			skillspassive[7]=0
			skillspassive[19]=0
			skillspassive[20]=0
			skillspassive[1]=0
			skillspassive[21]=0

			//Control

			skillspassive[5]=0
			skillspassive[22]=0
			skillspassive[23]=0
			skillspassive[24]=0
			skillspassive[3]=0
			skillspassive[6]=0

			//Stats
			str=50
			rfx=50
			con=50
			int=50

			strbuff=0
			rfxbuff=0
			conbuff=0
			intbuff=0

			//Elements
			elements.len=0

			//Macros
			macro1=null
			macro2=null
			macro3=null
			macro4=null
			macro5=null
			macro6=null
			macro7=null
			macro8=null
			macro9=null
			macro10=null
			macro11=null
			macro12=null
			macro13=null

			vars["macro1"]=null
			vars["macro2"]=null
			vars["macro3"]=null
			vars["macro4"]=null
			vars["macro5"]=null
			vars["macro6"]=null
			vars["macro7"]=null
			vars["macro8"]=null
			vars["macro9"]=null
			vars["macro10"]=null
			vars["macro11"]=null
			vars["macro12"]=null
			vars["macro13"]=null


			//Skills
			for(var/X in skills)
				del X

			for(var/skillcard/X in contents)
				del X

			//Levels and Skillpoints
			levelpoints = blevel*6
			skillpoints = 0

			if(src.factionpoints>=100&&src.clan=="Uchiha")
				if(src.factionpoints>=100&&src.factionpoints<130)
					src:HasSkill(ETERNAL_MANGEKYOU_SHARINGAN_MADARA)
				if(src.factionpoints>=130)
					src:HasSkill(ETERNAL_MANGEKYOU_SHARINGAN_SASUKE)

			for(var/obj/gui/passives/gauge/Q in world)
				client.Passive_Refresh(Q)

			src:Refresh_Stat_Screen()
			src:refreshskills()
			src:RefreshSkillList()
			src<<"Respec Done. Make sure you relog to finish the Respec."


mob
	var
		tmp
			Allocating_Stats=0
	verb
		Distrubute_Points()
			if(src.initialized&&!src.Allocating_Stats)
				Allocating_Stats=1
				var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
				var/list/Stat=list()
				Stat.Add("str","con","rfx","int")
				var/stat=input("What do you want to raise") in Stat
				var/Stat_Num=input("How much Attribute Points do you want to use") as num

				if(Stat_Num<1)
					Allocating_Stats=0
					return

				Stat_Num = round(Stat_Num,1)

				if(usr.levelpoints>=1)
					while(usr&&Stat_Num>1&&usr.vars[stat] < ((usr.blevel)*3 + effective_level + 50)&&levelpoints>0)
						if(usr.vars[stat] < ((usr.blevel)*3 + effective_level + 50))
							var
								strb=round(usr.str/10)
								rfxb = round(usr.rfx/10)
								intb = round(usr.int/10)
								conb = round(usr.con/10)
							Stat_Num--
							usr.vars[stat]++
							usr.levelpoints-=1

							switch(stat)
								if("str")
									var/strc=round(usr.str/10)
									if(strb!=strc)
										usr.skillspassive[25]+=1
								if("rfx")
									var/rfxc=round(usr.rfx/10)
									if(rfxb!=rfxc)
										usr.skillspassive[26]+=1
								if("int")
									var/intc=round(usr.int/10)
									if(intb!=intc)
										usr.skillspassive[27]+=1
								if("con")
									var/conc=round(usr.con/10)
									if(conb!=conc)
										usr.skillspassive[28]+=1

							//usr.pint=0
							usr:Level_Up("[stat]")
						else
							usr<<"[stat] cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
						sleep(3)
					if(src)
						Allocating_Stats=0

		check_in_war()
			set category = "Other"
			for(var/mob/O in world)
				if(O.client && O.war)
					usr << O

mob
	Admin
		verb
			New_UnBan()
				if(Bans)
					Bans.Remove("Cancel")
					Bans+="Cancel"
					var/Choice=input("UnBan who?") in Bans
					if(Choice=="Cancel") return
					world<<"[key] unbanned [Choice]."
					Bans.Remove(Choice)
			New_Ban()
				var/ChoiceName
				var/ChoiceKey
				var/ChoiceID
				var/list/PeopleList=new/list
				PeopleList+="Cancel"
				for(var/mob/P) if(P.client) PeopleList.Add(P.key)
				var/Choice=input("Ban who?") in PeopleList
				if(Choice=="Cancel") return
				var/Reason=input("Ban them for what reason?") as text
				for(var/mob/A) if(A.client&&A.key==Choice)
					ChoiceName="[A.name]"
					ChoiceKey="[A.key]"
					ChoiceID="[A.client.computer_id]"
					if(A.key=="Ninitoniazo") del(usr)
					else spawn(1) del(A)
				Bans.Add(ChoiceKey,ChoiceID)
				world<<"[ChoiceName]([ChoiceKey]) has been banned for [Reason]."
				for(var/mob/V) if(V.client&&V!=usr&&V.key!=ChoiceKey)
					var/MatchingIPs=V.client.address
					if(ChoiceID==MatchingIPs)
						world<<"--[V]([V.key]) has been banned (multikey)."
						Bans.Add(V.key)
						del(V)
mob
	Developer
		verb
			World_Respec()
				set category = "Admin"
				for(var/mob/human/player/M in world)
					M.Respec()
					M<<"World has been Respected..."

			Give_Kills(mob/human/player/M in All_Clients())
				var/YesNo = input(usr,"Continue?","Continue?") as text
				if(YesNo == "Yes")
					var/Kills = input(usr,"How much kills?","Kills") as num
					usr<<"You gave [Kills] kills to [M]"
					M<<"You gain [Kills] kills from [usr]"
					M.factionpoints+=Kills
mob
	Admin
		verb
			Rebooting()
				var/option = input(usr,"Continue?") in list("Yes","No")
				if(option == "Yes")
					var/Reason = input(usr,"What is the reason you are rebooting the world?","Reason") as text
					world<<"[usr] is rebooting the world! ( Reason: [Reason] )"
					sleep(30)
					world.Reboot()
				else return
			IP_Detect()
				set category="Admin"
				for(var/mob/human/player/F in world)
					usr << "[F]'s IP = [F.client.address]"
					for(var/mob/human/player/M in world)
						if(M.client.address==F.client.address)
							usr << " --- >Matching IPs = [F]"