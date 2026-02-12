mob/proc
	Credits()
		var/A={""}
		winshow(usr, "browser-popup", 1)
		src<< browse(A)
var
	tourney=0
	list/fighter_reg=new
	list/mutelist=new

mob
	GM
		verb
			Regen_Lag(i as num)
				if(i<1)
					i=1
				if(i>5)
					i=5
				wregenlag=i
				usr<<"world/regenlag=[wregenlag]"
			Variable_Analysis(atom/movable/x in world)
				var/T="<b><u><font size=+1>[x.name]</b></u></font><br><br>"
				var/X
				for(X in x.vars)
					T+="[X] = [x.vars[X]] <br>"
					if(istype(x.vars[X],/list))
						for(var/O in x.vars[X])
							T+="   [O] <br>"
				winshow(usr, "browser-popup", 1)
				usr<<browse(T)
			Spectate(mob/human/player/x in All_Clients())
				usr.spectate=1
				usr.client.eye=x
				usr<<"<font size=+1>Spectating, Hit the Interact Button or Space to return. (Only your vision has changed, your character is still in the same spot.)</font>"

mob
	Community_Guide
		verb
			Announce()
				var/T=input("Announce in all servers")as text
				MultiAnnounce("<font color=#fff67f><b>[usr]</b>: [T]</font>")
			Local_Announce()
				var/T=input("Announce in this server only")as text
				world<<"<font color=#fff67f><b>[usr]</b>: [T]</font>"
			Mute(mob/human/o in All_Clients())
				o.mute=2
				world<<"[o.realname] is muted"
				mutelist+=o.client.computer_id
			UnMute(mob/human/o in All_Clients())
				o.mute=0
				mutelist-=o.client.computer_id
				world<<"[o.realname] is unmuted"
			UnMute_all()
				mutelist=new/list()
				for(var/mob/human/x in world)
					if(x.mute)
						UnMute(x)

mob
	Admin
		verb
			Rank(mob/human/player/M in All_Clients(), rank in list("Academy Student","Genin","Chuunin","Special Jounin","Jounin","Elite Jounin"))
				M.rank=rank

			Save_ALL()
				for(var/mob/human/player/O in world)
					if(O.client && O.initialized)
						spawn()O.client.SaveMob()
			Test_World2()
				var/obj/O=locate(/obj/testbeacon2)
				var/turf/X=O.loc
				usr.Move(X)
			Test_World_Take2(mob/x in oview(10))
				var/obj/O=locate(/obj/testbeacon2)
				var/turf/X=O.loc
				x.Move(X)
			Test_World()
				var/obj/O=locate(/obj/testbeacon)
				var/turf/X=O.loc
				usr.Move(X)
			Test_World_Take(mob/x in oview(10))
				var/obj/O=locate(/obj/testbeacon)
				var/turf/X=O.loc
				x.Move(X)
			UNHENGE()
				for(var/mob/human/player/x in world)
					if(x.henged)
						x.name=x.realname
						x.mouse_over_pointer=faction_mouse[x.faction.mouse_icon]
						x.henged=0
						Poof(x.x,x.y,x.z)
						x.CreateName(255, 255, 255)
						x.Affirm_Icon()
						x.Load_Overlays()
			BingoSort()
				world.bingosort()
			Have_Tourney()
				set category="Tournament"
				tourney=1
				world<<"<font color=Blue size= +1>[usr.realname] Has started a Tourney, you can watch by clicking on Watch_Fight in your commands tab!</font>"
			Register_Fighter(mob/human/player/x in All_Clients())
				set category="Tournament"
				fighter_reg+=x
			Unregister_Fighter(x in fighter_reg)
				set category="Tournament"
				fighter_reg-=x
			End_Tourney()
				set category="Tournament"
				tourney=0
			Pick_Combatant(mob/human/player/x in All_Clients())
				set category="Tournament"
				if(x.client)
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
					x.stunned=0
					x<<"Wait for 1,2,3 Go."
					world<<"<font color=Blue size= +1>[x.realname] Has entered the Arena!</font>"
					x.loc=locate(69,72,3)
			Start_Fight()
				set category="Tournament"
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
					if(x.inarena==1 && !x.cexam)
						x.pk=1
						x.dojo=0
			Declare_Winner()
				set category="Tournament"
				for(var/mob/human/player/x in world)
					if(x.inarena==1 &&x.z==3||x.inarena==2 &&x.z==3)
						world<<"<font color=Blue size= +1>[x.realname] Has won!</font>"
						x.inarena=0
						x.curwound=0
						x.curstamina=x.stamina
						x.curchakra=x.chakra
						if(x.oldx &&x.oldy && x.oldz)
							x.loc=locate(x.oldx,x.oldy,x.oldz)
							x.oldx=0
							x.oldy=0
							x.oldz=0
			Earthquake_Effect(max_steps=10 as num, offset_min=-2 as num, offset_max=2 as num)
				Earthquake(max_steps, offset_min, offset_max)


mob
	Tourney
		verb
			Check_Registered_Fighters()
				set category="Tournament"
				for(var/mob/x in fighter_reg)
					usr<<"<b><font color=red>[x.realname]</b></font>"

			Watch_Fight()
				set category="Tournament"
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

var
	B1="NoOne"
	B2="NoOne"
	B3="NoOne"
	B4="NoOne"
	B5="NoOne"
	B6="NoOne"
	B7="NoOne"
	B8="NoOne"
	B9="NoOne"

mob
	verb
		Track_Bijuu_Wilders()
			usr<<"<b><font color=brown>One Tails Shakaku:[B1]"
			usr<<"<b><font color=blue>Two Tails Nibi:[B2]"
			usr<<"<b><font color=green>Three Tails Sanbi:[B3]"
			usr<<"<b><font color=red>Four Tails Yonbi:[B4]"
			usr<<"<b><font color=white>Five Tails Gobi:[B5]"
			usr<<"<b><font color=grey>Six Tails Rokubi:[B6]"
			usr<<"<b><font color=purple>Seven Tails Shichibi:[B7]"
			usr<<"<b><font color=brown>Eight Tails Hachibi:[B8]"
			usr<<"<b><font color=red>Nine Tails Kyuubi:[B9]"
			usr<<"<b><font color=black>Ten Tails is in the Making so no one has it"

mob
	Developer
		verb
			Change_B1()
				B1=input("Who is the Shukaku Wilder?")as text
			Change_B2()
				B2=input("Who is the Nibi Wilder?")as text
			Change_B3()
				B3=input("Who is the Sanbi Wilder?")as text
			Change_B4()
				B4=input("Who is the Yonbi Wilder?")as text
			Change_B5()
				B5=input("Who is the Gobi Wilder?")as text
			Change_B6()
				B6=input("Who is the Rokubi Wilder?")as text
			Change_B7()
				B7=input("Who is the Shichibi Wilder?")as text
			Change_B8()
				B8=input("Who is the Hachibi Wilder?")as text
			Change_B9()
				B9=input("Who is the Kyuubi Wilder?")as text
