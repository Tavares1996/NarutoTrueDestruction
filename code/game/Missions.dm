obj
	items
		Mission_Scroll
			icon='icons/mission.dmi'
			Click()
				var/mob/M
				for(var/mob/human/player/XE in world)
					if(XE==usr.MissionTarget)
						M=XE

				if(M)
					var/Xicon_state=""

					var/filename="player__"
					var/icon/I=icon('blank.dmi')
					filename+="_[M.icon]_[Xicon_state]___"
					if(M.icon)
						I.Blend(icon(M.icon,Xicon_state),ICON_OVERLAY)
					for(var/X in M.overlays)
						if(X && X:icon)
							I.Blend(icon(X:icon,Xicon_state),ICON_OVERLAY)
							filename+="[X:icon]_[Xicon_state]__"
					filename+=".png"
					var/T={"<font size = 1><font face=Courier><Center><STYLE>BODY {background: black; color: white}</STYLE>
					<table border=1 cellspacing=10><html><body text=white link=white vlink=white alink=white>""}
					T+="<tr><td>Target</td><td>Rank</td><td>Description</td><br></tr>"
					usr<<browse_rsc(I, filename)
					T+={"<tr><td><img src="[filename]">:[usr.MissionTarget]</td><td>[usr.MissionClass]</td><td>[usr.GetDiscription(usr)]</td></tr>"}
					winshow(usr, "browser-popup", 1)
					usr << browse(T)
mob
	LocationEnter(dropoff)
		if(usr.MissionType=="Escort"||usr.MissionType=="Escort PvP")
			for(var/mob/human/player/x in world)
				if(x.MissionTarget==usr.MissionTarget && x.MissionType=="Kill Npc PvP")
					x.MissionFail()
			for(var/mob/x in oview(4,usr))
				if(x==usr.MissionTarget && usr.MissionLocation==dropoff)
					usr.MissionComplete()

	proc
		MissionFail(noduh)
			usr=src
			var/list/P=Pvp_Escort

			P.Remove(src)
			Pvp_Escort=P
			src.MissionTarget=0
			for(var/obj/items/Mission_Scroll/p in usr.contents)
				del(p)
			if(usr.Missionstatus)
				usr.Missionstatus=0
				if(!noduh)
					alert(usr,"You have failed your mission..")

			for(var/mob/human/player/npc/X in world)
				if(X.missionowner==usr)
					X.onquest=0
					X.missionowner=0
					X.loc=locate(X.origx,X.origy,X.origz)
		RankGrade()
			if(!src.faction) return
			if(src.faction.village == "Missing")
				src.rankgrade=3
			else
				switch(src.rank)
					if("Academy Student")
						src.rankgrade=0
					if("Genin")
						src.rankgrade=1 //D,C
					if("Chuunin")
						src.rankgrade=2 //C,B
					if("Special Jounin", "Anbu")
						src.rankgrade=3 //B,A
					if("Jounin", "Anbu Captain")
						src.rankgrade=4 //A,S
					if("Elite Jounin")
						src.rankgrade=5
			return src.rankgrade
		MissionComplete()
			if(src.Missionstatus)
				usr=src
				var/list/P=Pvp_Escort
				src.MissionTarget=0
				P.Remove(src)
				Pvp_Escort=P
				usr.MissionTimeLeft=-1
				var/zMissionClass=usr.MissionClass
				var/zpay=usr.pay
				var/poolpay=zpay

				var/list/Team
				if(usr.squad)
					Team = list()
					for(var/mob/U in usr.squad.online_members)
						if(U in range(src,25))
							Team += U

				if(length(Team))
					if(src.Membership||src.Membership_2_Month)
						poolpay=zpay+2*zpay*(length(Team)-1)
					else
						poolpay=zpay+1*zpay*(length(Team)-1)
					var/totalclass=0
					for(var/mob/Q in Team)
						totalclass+=Q.RankGrade()

					for(var/mob/U in Team)
						var/rankgrade = U.RankGrade()
						switch(zMissionClass)
							if("D")
								U.Rank_D++
								var/lppool = (1000 + 1.05*900*(length(Team)-1))
								var/lpgain = round((lppool/length(Team))/2 + (rankgrade/totalclass)*lppool/2)
								U.body+=lpgain
								U<<"You gained [lpgain] Level Points!"
							if("C")
								U.Rank_C++
								var/lppool = (2500 + 1.05*1300*(length(Team)-1))
								var/lpgain = round((lppool/length(Team))/2 + (rankgrade/totalclass)*lppool/2)
								U.body+=lpgain
								U<<"You gained [lpgain] Level Points!"
							if("B")
								U.Rank_B++
								var/lppool = (3000 + 1.05*1600*(length(Team)-1))
								var/lpgain = round((lppool/length(Team))/2 + (rankgrade/totalclass)*lppool/2)
								U.body+=lpgain
								U<<"You gained [lpgain] Level Points!"
							if("A")
								U.Rank_A++
								var/lppool = (4000 + 1.05*2100*(length(Team)-1))
								var/lpgain = round((lppool/length(Team))/2 + (rankgrade/totalclass)*lppool/2)
								U.body+=lpgain
								U<<"You gained [lpgain] Level Points!"
							if("S")
								U.Rank_S++
								var/lppool = (5000 + 1.05*7000*(length(Team)-1))
								var/lpgain = round((lppool/length(Team))/2 + (rankgrade/totalclass)*lppool/2)
								U.body+=lpgain
								U<<"You gained [lpgain] Level Points!"

						var/xpay= (poolpay/length(Team))/2
						if(totalclass)
							if(src.Membership||src.Membership_2_Month)
								xpay+= (rankgrade/totalclass)* (poolpay/2)
							else
								xpay+= (rankgrade/totalclass)* (poolpay/2)

						if(src.Membership||src.Membership_2_Month)
							U.money+=(xpay*5)*4
							U<<"Congratulations on completing your mission! You recieved [(xpay*5)*4] Dollars!"
						else
							U.money+=(xpay*3)*4
							U<<"Congratulations on completing your mission! You recieved [(xpay*3)*4] Dollars!"

				else
					switch(usr.MissionClass)
						if("D")
							usr.Rank_D++
							usr.body+=250*lp_mult_two
							usr<<"You gained [250*lp_mult_two] Level Points!"
						if("C")
							usr.Rank_C++
							usr.body+=300*lp_mult_two
							usr<<"You gained [300*lp_mult_two] Level Points!"
						if("B")
							usr.Rank_B++
							usr.body+=400*lp_mult_two
							usr<<"You gained [400*lp_mult_two] Level Points!"
						if("A")
							usr.Rank_A++
							usr.body+=500*lp_mult_two
							usr<<"You gained [500*lp_mult_two] Level Points!"
						if("S")
							usr.Rank_S++
							usr.body+=1000*lp_mult_two
							usr<<"You gained [1000*lp_mult_two] Level Points!"
					usr<<"Congratulations on completing your mission! You recieved [(zpay*3)*4] Dollars!"
					usr.money+=(zpay*3)*4

				spawn()
					usr.Missionstatus=0
					for(var/mob/human/player/npc/X in world)
						if(X.missionowner==usr)

							X.missionowner=0
							sleep(300)
							X.onquest=0
							X.loc=locate(X.origx,X.origy,X.origz)
					for(var/obj/items/Mission_Scroll/p in usr.contents)
						del(p)
				usr.pay=0
mob
	Admin
		verb
			Give_Mission(var/mob/human/player/X in view(10))
				var/rank = input2(usr,"Pick a Rank","Mission", list("A","B","C","D","Nevermind"))
				X.GetMission(rank)
			Check_Mission_NPCS()
				usr<<"Kawa"
				for(var/mob/human/player/npc/X in Town_Kawa)
					usr<<"[X]: onquest=[X.onquest]"
				usr<<"Cha"
				for(var/mob/human/player/npc/X in Town_Cha)
					usr<<"[X]: onquest=[X.onquest]"
				usr<<"Ishi"
				for(var/mob/human/player/npc/X in Town_Ishi)
					usr<<"[X]: onquest=[X.onquest]"
				usr<<"Konoha"
				for(var/mob/human/player/npc/X in Town_Konoha)
					usr<<"[X]: onquest=[X.onquest]"
				usr<<"Suna"
				for(var/mob/human/player/npc/X in Town_Suna)
					usr<<"[X]: onquest=[X.onquest]"
				usr<<"Kiri"
				for(var/mob/human/player/npc/X in Town_Mist)
					usr<<"[X]: onquest=[X.onquest]"

var/list/Town_Kawa=new()
var/list/Town_Cha=new()
var/list/Town_Ishi=new()
var/list/Town_Konoha=new()
var/list/Town_Suna=new()
var/list/Town_Mist=new()


mob/human/npc/missions
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1
			if(alert(usr,"Would you like to take a mission?","Mission","Yes","No")=="Yes")
				switch(input2(usr,"What Rank Mission would you like? I recomend if it is above D rank to do it in a Squad. The Requirements are: D-Genin, C-Genin, B-Chuunin, A-Special Jounin, S-Jounin","Get Mission",list("S","A","B","C","D")))

					if("S")
						if(usr.MissionCool>2)
							alert(usr,"Sorry you have to wait ~[round(usr.MissionCool/60)+1]Minutes to do another mission")
							return
						alert(usr,"Sorry No S-Rank Missions are being made available at this time.")

					if("A")
						if(usr.MissionCool>2)
							alert(usr,"Sorry you have to wait ~[round(usr.MissionCool/60)+1]Minutes to do another mission")
							return
						if(usr.RankGrade2()>=4)
							usr.GetMission("A")
						else
							alert(usr,"Sorry you dont meet the Rank requirement to get this mission type")
					if("B")
						if(usr.MissionCool>2)
							alert(usr,"Sorry you have to wait ~[round(usr.MissionCool/60)+1]Minutes to do another mission")
							return
						if(usr.RankGrade2()>=3)
							usr.GetMission("B")
						else
							alert(usr,"Sorry you dont meet the Rank requirement to get this mission type")
					if("C")
						if(usr.MissionCool>2)
							alert(usr,"Sorry you have to wait ~[round(usr.MissionCool/60)+1]Minutes to do another mission")
							return
						if(usr.RankGrade2()>=2)
							usr.GetMission("C")
						else
							alert(usr,"Sorry you dont meet the Rank requirement to get this mission type")
					if("D")
						if(usr.MissionCool>2)
							alert(usr,"Sorry you have to wait ~[round(usr.MissionCool/60)+1]Minutes to do another mission")
							return
						if(usr.RankGrade2()>=1)
							usr.GetMission("D")
						else
							alert(usr,"Sorry you dont meet the Rank requirement to get this mission type")


mob
	proc
		GetMission(rank)
			if(!EN[6])
				return
			usr=src
			src.MissionFail(1)

			for(var/obj/items/Mission_Scroll/p in usr.contents)
				del(p)

			usr.Missionstatus=1 // has a mission 2=failure 3 = success
			var/pik
			var/list/NPCpik=new/list()
			NPCpik+=Town_Kawa
			if(faction.village != "Missing") NPCpik+=Town_Cha
			NPCpik+=Town_Ishi
			for(var/mob/human/player/npc/X in NPCpik)
				if(X.onquest)
					NPCpik-=X


			if(rank=="D")
				pik=1
				usr.MissionClass="D"
				alert(usr,"Here is your D-Rank Mission Scroll")
				usr.afteryou=pick(100;0,100;1,20;2)
			if(rank=="C")
				pik=pick(2,3)
				usr.MissionClass="C"
				usr.afteryou=pick(100;1,50;2)
				alert(usr,"Here is your C-Rank Mission Scroll, This is an urgent mission and you only have 30 minutes to do it!(You fail if you sleep or die)")
			if(rank=="B")//escort targeted person, assasinate targeted person, capture the scroll
				if(!PvP_Switch)
					pik=5
				else
					if(length(Pvp_Escort))
						pik=6
					else
						pik=5
				PvP_Switch=!PvP_Switch
				usr.MissionClass="B"
				usr.afteryou=pick(50;1,100;2,100;3,50;4)
				alert(usr,"Here is your B-Rank Mission Scroll, This is an urgent mission and you only have 30 minutes to do it!(You fail if you sleep or die)")

			if(rank=="A")//Hostile zones. (Steal a scroll, kill somebody, Rescue prisoner)
				pik=pick(3,8,9)
				usr.afteryou=pick(10;3,50;4,100;5,100;6,150;7,100;8,50;9)

				if(pik==9)
					NPCpik=new/list()
					for(var/mob/human/player/O in world)
						if(O.client && O.initialized && (!O.AFK||O.pk) && O.faction && O.faction.village!=usr.faction.village)
							NPCpik+=O
					if(!length(NPCpik))
						pik=8
				if(pik==8)
					NPCpik=new/list()
					var/Kcount=0
					var/Scount=0
					var/Mcount=0
					for(var/mob/human/player/OM in world)
						if(OM.client && OM.faction)
							if(OM.faction.village=="Konoha")
								Kcount++
							if(OM.faction.village=="Kiri")
								Mcount++
							if(OM.faction.village=="Suna")
								Scount++
					if(usr.faction.village!="Konoha" && Kcount>10)
						NPCpik+=Town_Konoha
					if(usr.faction.village!="Suna" && Scount>10)
						NPCpik+=Town_Suna
					if(usr.faction.village!="Kiri" && Mcount>10)
						NPCpik+=Town_Mist
					usr.afteryou=pick(50;1,100;2,100;3,100;4,50;5)
				usr.MissionClass="A"
				alert(usr,"Here is your A-Rank Mission Scroll, This is an urgent mission and you only have 30 minutes to do it!(You fail if you sleep or die)")
			if(rank=="S")//Very rare, programmed events, sometimes yeild special items(techniques even)
				NPCpik=new/list()
			new/obj/items/Mission_Scroll(usr)
			if(length(NPCpik)<=0)
				alert(usr,"There arent any available [rank]-Rank missions right this moment")
				for(var/obj/items/Mission_Scroll/p in usr.contents)
					del(p)
				usr.Missionstatus=0
				return
			src.GetMission2(pik,NPCpik)
		GetMission2(indec,list/targetl)
			var/list/dropoffs=list("Kawa no Kuni","Cha no Kuni","Ishi no Kuni")
			usr=src
			switch(indec)
				if(1)
					var/MissionType= "Delivery"
					var/mob/human/player/npc/X  = pick(targetl)
					X.onquest=1
					X.missionowner=usr
					usr.MissionType=MissionType
					usr.Hastargetpos=1
					usr.MissionTarget=X
					usr.TargetLocation=X.locationdisc
					usr.MissionTime=0
					usr.MissionTimeLeft=-1
					usr.pay=rand(50, 60) + rand(50, 60)
				if(2)
					var/MissionType= "Escort"
					var/mob/human/player/npc/X  = pick(targetl)
					X.onquest=1
					usr.Hastargetpos=1
					X.missionowner=usr
					usr.MissionType=MissionType
					usr.MissionTarget=X
					usr.MissionTime=1800
					usr.MissionTimeLeft=1800
					usr.TargetLocation=X.locationdisc
					dropoffs.Remove(X.locationdisc)
					if(usr.faction.village)
						dropoffs+=usr.faction.village
						if(usr.faction.village=="Missing")
							dropoffs-=usr.faction.village
					usr.MissionLocation=pick(dropoffs)
					usr.pay=rand(80, 100) + rand(90, 110)
				if(3)
					var/MissionType= "Assasinate"
					var/mob/human/player/npc/X  = pick(targetl)
					X.onquest=1
					usr.Hastargetpos=1
					X.missionowner=usr
					usr.MissionType=MissionType
					usr.MissionTime=1800
					usr.MissionTimeLeft=1800
					usr.MissionTarget=X
					usr.TargetLocation=X.locationdisc
					usr.pay=rand(70, 110) + rand(90, 130)
				if(4)
					var/MissionType= "Assasinate Difficult"
					var/mob/human/player/npc/X  = pick(targetl)
					X.onquest=1
					usr.Hastargetpos=1
					usr.MissionType=MissionType
					X.missionowner=usr
					usr.MissionTarget=X
					usr.MissionTime=1800
					usr.MissionTimeLeft=1800
					usr.TargetLocation=X.locationdisc
					usr.pay=rand(110, 160) + rand(140, 190)
				if(5)
					var/MissionType= "Escort PvP"
					var/mob/human/player/npc/X  = pick(targetl)
					X.onquest=1
					usr.MissionType=MissionType
					usr.Hastargetpos=1
					X.missionowner=usr
					usr.MissionTarget=X
					usr.MissionTime=1800
					usr.MissionTimeLeft=1800
					usr.TargetLocation=X.locationdisc
					Pvp_Escort+=usr
					for(var/mob/human/player/O in world)
						if(O && O.client && O.faction && O.faction.village!=usr.faction.village && O.faction.village!="Missing" && O.RankGrade()>=2)
							O<<"<font color=#00b84d><b>(PVP Mission Alert):[usr] has just started a B-rank Escort Mission</b></font>"
					dropoffs.Remove(X.locationdisc)
					if(usr.faction.village)
						dropoffs+=usr.faction.village
						if(usr.faction.village=="Missing")
							dropoffs-=usr.faction.village
					usr.MissionLocation=pick(dropoffs)
					usr.pay=rand(115, 150) + rand(155, 190)
				if(6)
					var/MissionType= "Kill Npc PvP"
					usr.MissionType=MissionType
					usr.Hastargetpos=1
					again
					var/mob/human/player/X
					if(length(Pvp_Escort))
						var/list/OX = new
						for(var/mob/O in Pvp_Escort)
							if(O.faction.village!=usr.faction.village)
								OX+=O
						if(!OX || !OX.len)
							Missionstatus = 0
							return
						X = pick(OX)
					else
						for(var/obj/items/Mission_Scroll/p in usr.contents)
							del(p)
						usr.Missionstatus=0
						return
					if(!X.client || !X.MissionTarget)
						Pvp_Escort-=X
						goto again
					usr.MissionTarget=X.MissionTarget
					usr.TargetLocation=X.MissionTarget:locationdisc
					usr.pay=rand(105, 140) + rand(155, 190)
				if(8)
					var/MissionType= "Invade PvP"
					var/mob/human/player/npc/X  = pick(targetl)
					X.onquest=1
					usr.MissionType=MissionType
					usr.Hastargetpos=1
					X.missionowner=usr
					usr.MissionTarget=X
					usr.MissionTime=1800
					usr.MissionTimeLeft=1800
					usr.TargetLocation=X.locationdisc
					for(var/mob/human/player/O in world)
						if(O.client && O.faction && O.faction.village!=usr.faction.village)
							if(X.locationdisc=="Konoha" && O.faction.village=="Konoha")
								O<<"<font color=#00b84d><b>(PVP Mission Alert):[usr] has just started an A-rank NPC Assasination Mission on [X], who is part of your village!</b></font>"
							if(X.locationdisc=="Suna" && O.faction.village=="Suna")
								O<<"<font color=#00b84d><b>(PVP Mission Alert):[usr] has just started an A-rank NPC Assasination Mission on [X], who is part of your village!</b></font>"
							if(X.locationdisc=="Kiri" && O.faction.village=="Kiri")
								O<<"<font color=#00b84d><b>(PVP Mission Alert):[usr] has just started an A-rank NPC Assasination Mission on [X], who is part of your village!</b></font>"
					usr.pay=rand(145, 250) + rand(205, 310)
				if(9)
					var/MissionType= "Assasinate Player PvP"
					var/mob/human/player/X  = pick(targetl)
					usr.MissionType=MissionType
					usr.MissionTarget=X
					usr.Hastargetpos=0
					usr.MissionTime=1800
					usr.MissionTimeLeft=1800
					usr.TargetLocation=X.faction.village
					usr.pay=rand(175, 280) + rand(175, 280)
			var/mob/human/player/npc/M=usr.MissionTarget
			if(M&&!M.client)
				M.onquest=1
			usr.MissionCool=900
var
	list/Pvp_Escort=new/list()
	PvP_Switch=0

mob
	proc
		GetDiscription(var/mob/human/player/X)
			usr=X
			var/tex
			switch(usr.MissionType)
				if("Escort")
					tex="Your job is to Escort [usr.MissionTarget] who you can find at [usr.TargetLocation], to [usr.MissionLocation]. "
				if("Escort PvP")
					tex="Your job is to Escort [usr.MissionTarget] who you can find at [usr.TargetLocation], to [usr.MissionLocation]. "
				if("Delivery")
					tex="Your job is to Deliver a package to [usr.MissionTarget] who you can find at [usr.TargetLocation]."
				if("Assasinate")
					tex="Your job is to track down [usr.MissionTarget] who you can find at [usr.TargetLocation] and kill him."
				if("Assasinate Player PvP")
					tex="Your job is to track down [usr.MissionTarget] who you can find at [usr.TargetLocation] and kill him."
				if("Invade PvP")
					tex="Your job is to track down [usr.MissionTarget] who you can find at [usr.TargetLocation] and kill him."
				if("Kill Npc PvP")
					tex="Your job is to track down [usr.MissionTarget] who you can find at [usr.TargetLocation] and kill him."
				if("War")
					tex="Your job is to go to [usr.TargetLocation] and kill [usr.MissionTarget] enemy shinobi."
			if(usr.MissionTime)
				tex+="<br>Keep in mind you are on a time restriction, you will fail the mission if you run out of time or use a bed."
			return tex