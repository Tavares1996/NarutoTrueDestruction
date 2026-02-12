mob/var
	afteryou=0
	levitation_active=0


obj/interactable
	paper
		verb
			Interact()
				set hidden=1
				set src in oview(1)

mob/human/npc/shopnpc
	interact="Shop"
	verb
		Shop()
			set src in oview(1)
			set hidden=1
			src.Check_Sales(usr)

mob/human/npc/clothing_shop_npc
	interact="Shop"
	verb
		Shop()
			set src in oview(1)
			set hidden=1
			src.Check_Sales(usr)

mob/human/npc/doctornpc
	interact="Doctor"

	verb
		Heal()
			set src in oview(1)
			set hidden=1
			usr<<"Hello, if you need to recover there are beds to the right up the stairs. (press space/interact to get in one)"

obj
	haku_ice
		var/dissipate_count = 0
		icon = 'icons/haku_ice.dmi'
		New()
			. = ..()
			spawn()
				flick("create", src)
				while(src)
					sleep(1)
					++dissipate_count
					for(var/mob/human/M in loc)
						if(M.clan == "Haku")
							dissipate_count = 0
							break
					if(dissipate_count > 50) del src

mob/var/movin=0
mob/var/afteryou_cool=0

mob/human
	Move(turf/loc,dirr)
		if(!src.loc)
			for(var/obj/Respawn_Pt/R in world)
				if((!faction || (faction.village=="Missing"&&R.ind==0))||(faction.village=="Konoha"&&R.ind==1)||(faction.village=="Suna"&&R.ind==2)||(faction.village=="Kiri"&&R.ind==3))
					loc = R.loc
					break
		if(!loc)
			return
		if(!src.canwalk)
			return

		if(istype(src,/mob/human/clay))
			. = ..()
			for(var/area/XE in oview(src,0))
				if(istype(XE,/area/nopkzone))
					var/mob/human/clay/spider/S = src
					if(istype(src,/mob/human/clay/spider) && S.explode && istype(S.explode,/mob/human/player))
						for(var/obj/trigger/exploding_spider/T in S.explode.triggers)
							if(T.spider == src) S.explode.RemoveTrigger(T)
					del src
			return
		if(istype(src,/mob/human/Puppet))
			for(var/area/nopkzone/S in oview(src,0))
				src.curwound=900
				src.curstamina=0
				src.Hostile()
		if(istype(src,/mob/human/sandmonster)||istype(src,/mob/human/player/npc))
			if(src.icon_state!="D-funeral" && !src.stunned)
				goto fin
			else
				return 0
		if(!density||canmove==0||stunned||kstun||asleep||mane||ko||src.icon_state=="ko"||!src.initialized||handseal_stun)
			return
		if(src.client && src.client.inputting)
			return 0
		if(src.incombo)
			return 0
		if(src.frozen)
			return 0

		if(istype(src,/mob/spectator))
			src.density=0
			src.icon=null
			goto fin

		if(Iswater(usr.x,usr.y,usr.z)&&usr.fusion)
			var/cont
			cont=rand(250,640)
			if(usr.conbuff>250) return
			else usr.conbuff+=round(cont/220)
			if(usr.strbuff>200) return
			else usr.strbuff+=round(cont/250)


		if(capture_the_flag&&capture_the_flag.HasFlag(src))
			src.movepenalty+=1

		if(src.mole)
			if(src.curchakra>src.chakraregen || !src.curchakra<=0)
				src.stunned=0
				src.curchakra-=rand(40,100)
				src.movepenalty+=5
			else if(src.curchakra<src.chakraregen && src.curchakra<=0)
				src.stunned+=1

		if(src.mist_active)
			for(var/mob/human/player/X in oview(6,src))
				if(X.mist_active||src.mist_active)
					spawn()
						start
						if(!X in oview(6,src))
							break
						new/obj/MistEffect(X.client)
						sleep(3)
						if(!X in oview(6,src))
							break
						new/obj/MistEffect2(X.client)
						sleep(3)
						if(!X in oview(6,src))
							break
						new/obj/MistEffect3(X.client)
						sleep(3)
						if(!X in oview(6,src))
							break
						new/obj/MistEffect4(X.client)
						sleep(3)
						if(X in oview(6,src) || src in oview(6,X))
							goto start

		var/i=0
		i=Iswater(loc.x,loc.y,loc.z)
		if(i)
			var/obj/haku_ice/ice = locate(/obj/haku_ice) in loc
			if(!ice)
				if(clan == "Haku")
					new /obj/haku_ice(loc)
				else
					if(curchakra>5)
						curchakra-=5
						waterlogged=1
						watercount++
					else if(curstamina>25)
						curstamina-=25
						waterlogged=1
						watercount++
					else
						return 0

		for(var/mob/human/npc/bounty/B in view(usr,1))
			for(var/mob/corpse/C in src.carrying)
				switch(input("Would you like to cash in your corpses' bountys?!","Corpse Bounty") in list ("Yes","No"))
					if("Yes")
						src.money+=C.corpsebounty
						src<<"Gained [C.corpsebounty] money"
						var/list/Team
						if(usr.squad)
							Team = list()
							for(var/mob/U in usr.squad.online_members)
								if(U in range(src,25))
									Team += U
						if(usr.squad)
							for(var/mob/U in Team)
								U.money+=C.corpsebounty
								U<<"Gained [C.corpsebounty] money"
								U<<'Cash.wav'
						for(var/mob/human/M in world)
							M.carrying-=C
						C.carryingme=null
						C.corpsebounty=0
						C.name="[C.name]<font color =green>CASHED IN!"
						C.loc = locate(/turf/cage1)
						src<<'Cash.wav'

		if(src.Tank)
			for(var/mob/human/Xe in get_step(src,src.dir))
				if(Xe!=src && !Xe.ko && !Xe.protected && (Xe.client/*||istype(Xe,/mob/human/player/npc/kage_bunshin)*/))
					var/obj/t = new/obj(Xe.loc)
					t.icon='icons/gatesmack.dmi'
					flick("smack",t)
					del(t)
					if(src.Tank==3)
						spawn()Xe.Dec_Stam((src.rfx+src.rfxbuff-rfxneg)*pick(1,3)+600,1,src)
					else if(src.Tank==4)
						spawn()Xe.Dec_Stam((src.rfx+src.rfxbuff-rfxneg)*pick(2,6)+600,1,src)
					else
						spawn()Xe.Dec_Stam((src.str+src.strbuff-strneg)*pick(1,3)+400,1,src)
					spawn()Xe.Hostile(src)
					if(!Xe.Tank)
						Xe.loc=locate(src.x,src.y,src.z)
						Xe.icon_state="Hurt"


					spawn()
						if(!Xe.Tank)
							Xe.Knockback(5,turn(src.dir, 180))
						else
							Xe.Knockback(5,src.dir)
						Xe.icon_state=""
				else
					src.loc=locate(Xe.x,Xe.y,Xe.z)

			if(movin)
				return ..()
			if(dirr==src.dir)
				src.movin=1
				walk(src,src.dir,1)
				sleep(3)
				walk(src,0)
				src.movin=0
				return 1
			else
				return ..()
		if(!EN[14])
			return ..()
		if(!src.movedrecently)
			src.movedrecently++
			if(src.movedrecently>10)
				src.movedrecently=10

		if(src.isguard)
			src.icon_state=""
			src.isguard=0
		for(var/obj/Bonespire/P in get_step(src,src.dir))
			if(P.causer==src)
				P.density=0
				spawn(2)
					if(P)
						P.density=1
		for(var/turf/P in get_step(src,src.dir))
			if(!P.icon || P.type==/turf)
				return 0
		if(src.sleeping)
			src.sleeping=0
			src.icon_state=""
		if(length(carrying))
			for(var/mob/X in carrying)
				X.loc=src.loc
		fin

		. = ..()
		if(src.HasSkill(BLOOD_BIND))
			for(var/obj/undereffect/B in src.loc)
				if(B.uowner)src.Blood_Add(B.uowner)

		src.Get_Global_Coords()

		//Levelwarp
		var/wa=0
		if(src.x==100 && (src.dir==EAST||src.dir==NORTHEAST||src.dir==SOUTHEAST))

			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/y=src.y
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX+1 && OP.oY==eY)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(1,y,NM.z)
					wa=1
					src.Get_Global_Coords()


		if(src.x==1 && (src.dir==WEST||src.dir==NORTHWEST||src.dir==SOUTHWEST))
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/y=src.y
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX-1 && OP.oY==eY)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(100,y,NM.z)
					wa=1
					src.Get_Global_Coords()

		if(src.y==100 && (src.dir==NORTH||src.dir==NORTHEAST||src.dir==NORTHWEST))
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/x=src.x
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX && OP.oY==eY-1)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(x,1,NM.z)
					wa=1
					src.Get_Global_Coords()

		if(src.y==1 && (src.dir==SOUTH||src.dir==SOUTHWEST||src.dir==SOUTHEAST))
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/x=src.x
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX && OP.oY==eY+1)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(x,100,NM.z)
					wa=1
					src.Get_Global_Coords()
		//~~~~
		if(!afteryou_cool && wa)
			if(pick(0,1))
				var/squadsize=pick(1,2,3,4)
				squadsize=min(squadsize,afteryou)
				afteryou_cool=1
				afteryou-=squadsize
				spawn(30)
					var/lvl=1
					if(MissionClass=="D")
						lvl=limit(1,round(src.blevel * rand(0.4,1)),30)
					if(MissionClass=="C")
						lvl=limit(1,round(src.blevel * rand(0.7,1.1)),60)
					if(MissionClass=="B")
						lvl=limit(1,round(src.blevel * rand(0.8,1.2)),80)
					if(MissionClass=="A")
						lvl=limit(1,round(src.blevel * rand(0.9,1.3)),100)
					if(MissionClass=="S")
						lvl=limit(1,round(src.blevel * rand(1,1.3)),100)

					Ambush(src,lvl,squadsize)

		else
			if(wa)
				spawn(200)
					afteryou_cool=0
		for(var/mob/human/player/npc/Q in oview(5))
			if(Q.following==src)
				Q.nextstep=src.dir
			for(var/area/XE in oview(src,0))
				if(istype(XE,/area/nopkzone))
					src.Hostile()
		if(istype(src,/mob/human/sandmonster)||istype(src,/mob/human/player/npc))
			canmove=0
			spawn(1)
				canmove=1
			return
		for(var/obj/x in oview(0))
			if(istype(x,/obj/caltrops))
				x:E(src)
		for(var/obj/x in oview(1))
			if(istype(x,/obj/trip))
				x:E(src)
		src.runlevel++
		if(src.runlevel>8)
			src.runlevel=8

		spawn(10)
			src.runlevel--
			if(src.levitate && src.runlevel<=3)
				src.pixel_y=0
				src.icon_state=""
				src.levitation_active=0
			else if(src.icon_state=="Run" &&src.runlevel<=3)
				src.icon_state=""
		if(src.runlevel>4 &&!src.Size)
			if(!src.icon_state&&!src.rasengan&&!src.larch&&src.levitate)
				src.icon_state="Seal"
				src.levitation_active=1

				start
				if(src)src.pixel_y+=1
				sleep(2)
				if(src)src.pixel_y+=1.5
				sleep(3)
				if(src)src.pixel_y-=1.5
				sleep(2)
				if(src)src.pixel_y-=1
				if(src.runlevel>4)
					goto start

			else if(!src.icon_state&&!src.rasengan&&!src.larch&&!src.levitate)
				src.icon_state="Run"
		else
			if(src.levitate&&src.icon_state=="Seal")
				src.icon_state=""
				src.levitation_active=0
			else if(src.icon_state=="Run")
				src.icon_state=""

		canmove=0
		sleep(1)
		if(usr.Size==1)
			src.movepenalty=25
		if(usr.Size==2)
			src.movepenalty=35
		if(src.movepenalty>50)
			src.movepenalty=50
		if(move_stun)
			if(!movepenalty)
				movepenalty = 10
			sleep(round(movepenalty/5))
		else
			sleep(round(movepenalty/10))
		if(src.leading)
			sleep(3)
		canmove=1


mob/var/movement_map
client
	West()
		if(src.mob.controlmob)
			step(mob.controlmob,WEST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,WEST) in oview(20,src.mob))
				step(src.mob.Primary,WEST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x>0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[WEST]"]
			step(mob, dir)
			return
		..()

	East()
		if(src.mob.controlmob)
			step(mob.controlmob,EAST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,EAST) in oview(20,src.mob))
				step(src.mob.Primary,EAST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_x<0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))
		if(user &&user.pixel_y)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))

		if(mob.movement_map)
			var/dir = mob.movement_map["[EAST]"]
			step(mob, dir)
			return
		..()

	North()
		if(src.mob.controlmob)
			step(mob.controlmob,NORTH)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,NORTH) in oview(20,src.mob))
				step(src.mob.Primary,NORTH)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y<0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[NORTH]"]
			step(mob, dir)
			return
		..()

	South()
		if(src.mob.controlmob)
			step(mob.controlmob,SOUTH)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,SOUTH) in oview(20,src.mob))
				step(src.mob.Primary,SOUTH)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y>0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[SOUTH]"]
			step(mob, dir)
			return
		..()

	Southeast()
		if(src.mob.controlmob)
			step(mob.controlmob,SOUTHEAST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,SOUTHEAST) in oview(20,src.mob))
				step(src.mob.Primary,SOUTHEAST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y>0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x<0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[SOUTHEAST]"]
			step(mob, dir)
			return
		..()

	Northeast()
		if(src.mob.controlmob)
			step(mob.controlmob,NORTHEAST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,NORTHEAST) in oview(20,src.mob))
				step(src.mob.Primary,NORTHEAST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y<0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x<0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[NORTHEAST]"]
			step(mob, dir)
			return
		..()

	Southwest()
		if(src.mob.controlmob)
			step(mob.controlmob,SOUTHWEST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,SOUTHWEST) in oview(20,src.mob))
				step(src.mob.Primary,SOUTHWEST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y>0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x>0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[SOUTHWEST]"]
			step(mob, dir)
			return
		..()

	Northwest()
		if(src.mob.controlmob)
			step(mob.controlmob,NORTHWEST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,NORTHWEST) in oview(20,src.mob))
				step(src.mob.Primary,NORTHWEST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y<0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x>0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[NORTHWEST]"]
			step(mob, dir)
			return
		..()
mob
	verb
		interactv()
			set name="Interact"
			set hidden = 1
			if(usr.camo)
				usr.Affirm_Icon()
				usr.Load_Overlays()
				usr.camo=0
			if(usr.lastwitnessing && usr.sharingan && usr:HasSkill(SHARINGAN_COPY))
				var/skill/uchiha/sharingan_copy/copy = usr:GetSkill(SHARINGAN_COPY)
				var/skill/copied = copy.CopySkill(usr.lastwitnessing)
				usr.combat("<b><font color=#faa21b>Copied [copied]!</b></font>")
				usr.lastwitnessing=0
				return
			if(usr.incombo)
				return

			if(src.hydrated==1)
				if(usr.hozuki==0)
					var/time=rand(3,4)
					usr << "Hydrification <br><font color=green>On</br>"
					usr.hozuki=1
					usr.usemove=1
					usr.Affirm_Icon()
					spawn()
						while(time > 0)
							usr.protected=100
							time--
							sleep(10)
							if(time <= 0)
								usr.hozuki=0
								usr.usemove=0
								usr.Affirm_Icon()
								usr << "Hydrification <br><font color=red>Off</br>"
								usr.protected=0
					return
				else
					usr << "Stop trying to spam this you noob!"
					return

			if(src.boil_active)
				if(src.boil_damage==6)
					src << "PH Balance = <font color=#FF0000>Two"
					src.boil_damage=5
				else if(src.boil_damage==5)
					src << "PH Balance = <font color=#F62217>Three"
					src.boil_damage=4
				else if(src.boil_damage==4)
					src << "PH Balance = <font color=#FF3300>Four"
					src.boil_damage=3
				else if(src.boil_damage==3)
					src << "PH Balance = <font color=#FF6600>Five"
					src.boil_damage=2
				else if(src.boil_damage==2)
					src << "PH Balance = <font color=#FF6633>Six"
					src.boil_damage=1
				else if(src.boil_damage==1)
					src << "PH Balance = <font color=#C80000>One"
					src.boil_damage=6

			if(usr.c4)
				usr.c4 = 0
				var/hit=(5 + 230*usr.con/50)*3
				for(var/mob/human/player/x in infectedby)
					if(!x.ko && !istype(x,/mob/corpse))
						spawn()explosion(hit,x.x,x.y,x.z,usr,0,6)
						spawn()explosion(hit,x.x,x.y,x.z,usr,0,6)
						infectedby.Remove(x)
						x.Hostile(usr)
						return

			if(((usr.usedelay>0&&usr.pk)||usr.stunned||handseal_stun||usr.paralysed)&&!usr.ko)
				return
			usr.usedelay++

			if(usr.controlling)
				return

			if(istype(usr,/mob/human/player))
				if(capture_the_flag && capture_the_flag.GetTeam(usr) != "None")
					capture_the_flag.Flag(usr)

			var/ o=0
			var/inttype=0
			if(usr.leading)usr.leading=0

			if(usr.spectate && usr.client)
				usr.spectate=0
				usr.client.eye=usr.client.mob
				src.hidestat=0
				return
			if(usr.controlmob || usr.tajuu)
				for(var/mob/human/player/npc/kage_bunshin/X in world)
					if(X.ownerkey==usr.key || X.owner==usr)
						var/dx=X.x
						var/dy=X.y
						var/dz=X.z
						if(dx&&dy&&dz)
							if(!X:exploading&&!X:lightning)
								spawn()Poof(dx,dy,dz)
							else
								if(X:exploading)
									X:exploading=0
									spawn()explosion(rand(1000,2500),dx,dy,dz,X)
									X.icon=0
									X.targetable=0
									X.stunned=100
									X.invisibility=100
									X.density=0
									sleep(30)
								if(X:lightning)
									X:lightning=0
									X.icon=0
									X.targetable=0
									X.stunned=100
									X.invisibility=100
									X.density=0
									var/conmult = X.ControlDamageMultiplier()
									for(var/turf/t in oview(2,X))
										spawn()Electricity(t.x,t.y,t.z,30)
									spawn()AOExk(dx,dy,dz,2,(500+150*conmult),30,X,0,1.5,1)
									Electricity(dx,dy,dz,30)
									sleep(5)
						if(X)
							if(locate(X) in usr.pet)
								usr.pet-=X
							X.loc=null
				usr.tajuu=0
				usr.controlmob=0
				if(usr.client && usr.client.mob)
					usr.client.eye=usr.client.mob
					src.hidestat=0
			spawn(30)
				usr.Respawn()
			for(var/obj/interactable/oxe in oview(1))
				oxe:Interact()
				return

			for(var/mob/human/npc/x in oview(1))
				if(x == usr.MainTarget())
					o=1
					inttype=x.interact
				if(o)
					if(inttype=="Talk")
						x:Talk()
					if(inttype=="Shop")
						x:Shop()

			for(var/mob/human/player/npc/x in oview(1))
				if(x == usr.MainTarget())
					o=1
					inttype=x.interact
					if(x.aggro&& !usr.Missionstatus)
						o=0
				if(o)
					if(inttype=="Talk")
						x:Talk()
					if(inttype=="Shop")
						x:Shop()

			if(src in tagging in oview(10,usr))
				for(var/obj/tag_explode/t in src.tagging)
					flick("explosive",t)
					del(t)
				for(var/mob/human/player/x in src.tagging)
					spawn()explosion(200, x.x, x.y, x.z, src, 2, 2)
					spawn()explosion(200, x.x, x.y, x.z, src, 2, 2)
					spawn()explosion(200, x.x, x.y, x.z, src, 2, 2)
					spawn()explosion(200, x.x, x.y, x.z, src, 2, 2)
					spawn()explosion(200, x.x, x.y, x.z, src, 2, 2)
					src.tagging = 0

			if(!usr.MainTarget())
				for(var/obj/explosive_tag/U in oview(0,usr))
					usr.Tag_Interact(U)
					return
				for(var/obj/jidanda/U in oview(0,usr))
					usr.Tag_Interact(U)
					return
				var/new_target
				for(var/mob/human/M in oview(2, usr))
					if(!new_target)
						new_target = M
					if(get_dist(M, usr) < get_dist(usr, new_target))
						new_target = M
				if(new_target) usr.AddTarget(new_target, active=1)

			if(usr.henged)
				usr.name=usr.realname
				usr.henged=0
				usr.mouse_over_pointer=faction_mouse[usr.faction.mouse_icon]
				Poof(usr.x,usr.y,usr.z)
				usr:CreateName(255, 255, 255)
				usr.Affirm_Icon()
				usr.Load_Overlays()
mob/proc/Blood_Add(mob/V)
	if(V)
		if(!bloodrem.Find(V))
			bloodrem+=V

		spawn(600)
			bloodrem-=V

mob/var/pill=0
mob/var/combo=0
mob
	proc
		Dec_Stam(x,xpierce,mob/attacker, hurtall,taijutsu, internal)
			////s_damage(src,x,"#000000")
			if(src.levitate&&src.levitation_active&&prob(10))
				src.combat("Due to levitation, you have avoid taking any damage")
				return
			if(src.InSusanoo==1)
				src.DefenceSusanoo-=rand(1,3)
				src.SusanooHP-=x*4
				src.combat("Susanoo: [x] damage sustained! [src.DefenceSusanoo]/[src.SusanooHP]")
				if(src.DefenceSusanoo<=0)
					src.SusanooHP-=x*4
				if(src.SusanooHP<=0)
					if(src.INSASUKESUSANOO==1)
						src.InSusanoo=0
						src.INSASUKESUSANOO=0
						src<<"Susanoo has been destroyed!"
						src.overlays-=image('sasukecomplete.dmi',icon_state="s1",pixel_x=-80)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s2",pixel_x=-48)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s3",pixel_x=-16)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s4",pixel_x=16)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s5",pixel_x=48)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s6",pixel_x=80)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s7",pixel_x=112)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s8",pixel_x=-80,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s9",pixel_x=-48,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s10",pixel_x=-16,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s11",pixel_x=16,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s12",pixel_x=48,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s13",pixel_x=80,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s14",pixel_x=112,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s15",pixel_x=-80,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s16",pixel_x=-48,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s17",pixel_x=-16,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s18",pixel_x=16,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s19",pixel_x=48,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s20",pixel_x=80,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s21",pixel_x=-80,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s22",pixel_x=-48,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s23",pixel_x=-16,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s24",pixel_x=16,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s25",pixel_x=48,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s26",pixel_x=80,pixel_y=96)
						src.overlays-=image('icons/sasukeaura.dmi')
					else
						src.InSusanoo=0
						src<<"Susanoo has been destroyed!"
						src.overlays-=image('itachi susanoo.dmi',icon_state="0,0",pixel_x=-64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="1,0",pixel_x=-32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="2,0")
						src.overlays-=image('itachi susanoo.dmi',icon_state="3,0",pixel_x=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="4,0",pixel_x=64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="0,1",pixel_x=-64,pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="1,1",pixel_x=-32,pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="2,1",pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="3,1",pixel_x=32,pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="1,2",pixel_x=-32,pixel_y=64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="2,2",pixel_y=64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="3,2",pixel_x=32,pixel_y=64)
						src.overlays-=image('icons/itachi aura.dmi')
					return
			if(!internal && attacker && attacker.skillspassive[16] && attacker != src)
				FilterTargets()
				if(!(attacker in active_targets))
					if(attacker in targets)
						x*= (1 + 0.5*attacker.skillspassive[16])
					else
						x*= (1 + 0.10*attacker.skillspassive[16])
			if(taijutsu && attacker && !internal && attacker.skillspassive[10])
				var/pr=attacker.skillspassive[10] *3
				var/y=x*pr/100
				x-=y
				if(toggle_combat==1)
					src.combat("<font color=#eca940>You took [y] Piercing Stamina damage from [attacker]!")
//				s_damage(src,y,"#000000")
				src.curstamina-=y
			if(!xpierce && !internal && length(src.pet))
				for(var/mob/human/sandmonster/S in src.pet)
					if(S.loc==src.loc)
						flick("hurt",S)
						S.hp--
						if(S.hp<=0)
							del(S)
						return

			if(src.AIKawa && !internal)
				Poof(src.x,src.y,src.z)
				new/obj/log(locate(src.x,src.y,src.z))
				var/turf/T=locate(src.AIKawa)
				if(T)
					src.loc=locate(src.AIKawa)
				src.AIKawa=null
				return

			if((src.pill==2 || src.Size) && !internal)
				if(x>2)
					x=round(x*0.70)
			var/fu=0
			for(var/area/nopkzone/oox in oview(0,src))
				fu=1
			if(fu)
				return
			if((locate(/obj/Shield) in oview(1,src)) && !internal)
				return
			if(src.ko)
				return
			if(src.isguard && !internal)
				var/y=x/2
				x=y
			if(clan == "Battle Conditioned" && !xpierce)
				x = x * 0.75
			if(src.protected && !internal)
				return
			if(attacker)
				if(attacker!=src && !src.ko)
					src.lasthostile=attacker.key

			if(src.crystal_armor&&!xpierce)
				x = x * 0.75
				flick('icons/crystal_break.dmi',x)
			if(paper_armor && !xpierce)
				x = x * 0.8
			if(lightning_armor && !xpierce)
				x = x * 0.77

			if(sandarmor && !xpierce && !internal)
				--sandarmor
				return
			if(boneharden && !internal)
				while(curchakra > 0 && x > 0)
					--curchakra
					x -= 5
				x = max(0, x)
			if(src.spacetimebarrier&&!xpierce&&!internal)
				if(!attacker||!src) return
				var/obj/space/f = new/obj/space(src.loc)
				spawn(20) del(f)
				var/X=rand(1,5)
				var/V=pick(1,2)
				switch(V)
					if(1)
						if(attacker)
							attacker.loc = (locate(src.x+X,src.y+X,src.z))
							flick('icons/space1.dmi',attacker)
							attacker.Facedir(src)
						else return
					if(2)
						if(attacker)
							attacker.loc = (locate(src.x-X,src.y-X,src.z))
							flick('icons/space1.dmi',attacker)
							attacker.Facedir(src)
						else return
				var/mob/F = attacker
				F.stunned=rand(3,4)
				src.spacetimebarrier=0
				return

			if(src.petals)
				flick('icons/petals.dmi',src)
				sleep(3)
				src.AppearBehind(attacker)
				if(attacker)attacker.RemoveTarget(src)
				return

			if(src.kaiten && !internal)
				return

			if(x<=0)
				return

			if(src.ironskin==1&&!xpierce && !internal)
				src.curstamina-=round(x/2)
				return
			if(toggle_combat==1)
				src.combat("<font color=#eca940>You took [x] Stamina damage from [attacker]!")
//				////s_damage(src,x,"#000000")
			if(attacker && x && attacker.client&&istype(src,/mob/human/player/npc/creep))
				var/mob/human/player/npc/creep/C=src
				C.lasthurtme=attacker
			src.curstamina-=x
			if(client&&attacker&&attacker.clan == "Ruthless")
				attacker.adren+=round(x/250)
			if(src.asleep)
				src.asleep=0
				src.stunned=0
		Wound(x,xpierce, mob/attacker, reflected)
			if(src.levitate&&src.levitation_active&&prob(10))
				src.combat("Due to levitation, you have avoid taking any damage")
				return
			if(src.InSusanoo==1)
				src.DefenceSusanoo-=rand(1,3)
				src.SusanooHP-=x*4
				src.combat("Susanoo: [x] damage sustained! [src.DefenceSusanoo]/[src.SusanooHP]")
				if(src.DefenceSusanoo<=0)
					src.SusanooHP-=x*4
				if(src.SusanooHP<=0)
					if(src.INSASUKESUSANOO==1)
						src.InSusanoo=0
						src.INSASUKESUSANOO=0
						src<<"Susanoo has been destroyed!"
						src.overlays-=image('sasukecomplete.dmi',icon_state="s1",pixel_x=-80)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s2",pixel_x=-48)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s3",pixel_x=-16)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s4",pixel_x=16)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s5",pixel_x=48)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s6",pixel_x=80)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s7",pixel_x=112)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s8",pixel_x=-80,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s9",pixel_x=-48,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s10",pixel_x=-16,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s11",pixel_x=16,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s12",pixel_x=48,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s13",pixel_x=80,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s14",pixel_x=112,pixel_y=32)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s15",pixel_x=-80,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s16",pixel_x=-48,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s17",pixel_x=-16,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s18",pixel_x=16,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s19",pixel_x=48,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s20",pixel_x=80,pixel_y=64)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s21",pixel_x=-80,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s22",pixel_x=-48,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s23",pixel_x=-16,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s24",pixel_x=16,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s25",pixel_x=48,pixel_y=96)
						src.overlays-=image('sasukecomplete.dmi',icon_state="s26",pixel_x=80,pixel_y=96)
						src.overlays-=image('icons/sasukeaura.dmi')
					else
						src.InSusanoo=0
						src<<"Susanoo has been destroyed!"
						src.overlays-=image('itachi susanoo.dmi',icon_state="0,0",pixel_x=-64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="1,0",pixel_x=-32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="2,0")
						src.overlays-=image('itachi susanoo.dmi',icon_state="3,0",pixel_x=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="4,0",pixel_x=64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="0,1",pixel_x=-64,pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="1,1",pixel_x=-32,pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="2,1",pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="3,1",pixel_x=32,pixel_y=32)
						src.overlays-=image('itachi susanoo.dmi',icon_state="1,2",pixel_x=-32,pixel_y=64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="2,2",pixel_y=64)
						src.overlays-=image('itachi susanoo.dmi',icon_state="3,2",pixel_x=32,pixel_y=64)
						src.overlays-=image('icons/itachi aura.dmi')
					return
			if(reflected && !src.ko)
				src.curwound+=x
				src.combat("<font color=#eca940>You took [x] Wound damage from [attacker]!")
				return

			if(reflected && !src.ko)
				if(src.clan=="Capacity")
					src.SSkinR=rand(1,10)
					if(src.SSkinR==1)
						src.stamina-=x*1
						src.chakra-=x*1
						src.combat("You took [x] Wound damage from [attacker]!<font color =aqua>( Shark Skin stops wounds! )")
						return
				src.curwound+=x
				src.combat("You took [x] Wound damage from [attacker]!")
				return

			if(src.clan=="Battle Conditioned")
				src.SSkinR=rand(1,30)
				if(src.SSkinR==1)
					viewers(src) << "[src]Took no wounds [attacker]([x])!"
					src.curwound-=x
					return

			if(attacker && attacker.skillspassive[16] && attacker != src)
				FilterTargets()
				if(!(attacker in active_targets))
					if(attacker in targets)
						x*= (1 + 0.5*attacker.skillspassive[16])
					else
						x*= (1 + 0.10*attacker.skillspassive[16])

			if(src.Tank && x>10 && xpierce < 3)
				x=10

			if(attacker)
				if(istype(attacker,/mob/human/Puppet))
					if(attacker in src.pet|| attacker==vars["Puppet1"]||attacker==vars["Puppet2"])
						return

			for(var/mob/human/Puppet/P in pet)
				if(P==attacker)
					return

			if(pill == 2 && xpierce < 3)
				x = round(x*0.80)
			if(Size && xpierce < 3)
				if(x>2)
					x=round(x*0.70)
				if(x>20)
					x=20
			if(clan == "Jashin" && xpierce < 3)
				if(x>100)
					x=100
			if(src.skillspassive[12] && xpierce < 3)
				var/y=0
				var/stamhurt=0
				while(y<x && (stamhurt+120) < curstamina)
					y++
					if(prob(3*src.skillspassive[12]))
						x--
						stamhurt+=120
				spawn()src.Dec_Stam(stamhurt,attacker=attacker,internal=1)

			if(attacker!=src)
				var/fu=0
				for(var/area/nopkzone/oox in oview(0,src))
					fu=1
				if(fu)
					return
				if(!xpierce)
					if(clan == "Battle Conditioned")
						x = x * 0.75
				if((locate(/obj/Shield) in oview(1,src)) && xpierce < 3)
					return
				if(src.ko)
					return
				if(src.protected && xpierce < 3)
					return
				if(paper_armor && !xpierce)
					x = x * 0.8

				if(lightning_armor && !xpierce)
					x = x * 0.77

				if(crystal_armor && !xpierce)
					flick('icons/crystal_break.dmi',x)
					x = x * 0.8
				if(attacker)
					if(attacker!=src && !src.ko)
						src.lasthostile=attacker.key
				if(istype(src,/mob/human/player/npc))
					if(!src:aggro)
						return
				if(src.sandarmor && !xpierce)
					src.sandarmor--
					return
				if(boneharden && xpierce < 2)
					while(curchakra >= 10 && x>=1)
						curchakra -= 10
						--x
			//	if(src.dojo)
				//	return

				if(src.kaiten && xpierce < 3)
					return
				if(istype(src,/mob/human/npc))
					return
				if(src.ironskin==1&&!xpierce)
					src.Dec_Stam(x*100,1,attacker)
					return
			var/Ax=src.AC
			if(src.isguard)
				Ax=100
			if(Ax>100)
				Ax=100

			var/p1= x* (100-Ax)/100
			var/p2= x* (Ax)/100 *(100/(src.str+src.strbuff-src.strneg))
			if(x>=1 && (p1+p2)<=1)
				if(Ax<100)
					p1=1
					p2=0

			usr=src
			if(istype(src, /mob/human) && src:HasSkill(MASOCHISM))
				var/Rlim=round(src.rfx/2.5)-src.rfxbuff
				var/Slim=round(src.str/2.5)-src.strbuff
				if(Rlim<0)
					Rlim=0
				if(Slim<0)
					Slim=0
				var/R=round(src.rfx/10)
				var/S=round(src.str/10)
				if(R>Rlim)
					R=Rlim
				if(S>Slim)
					S=Slim
				src.rfxbuff+=R
				src.strbuff+=S
				spawn(200)
					src.rfxbuff-=R
					src.strbuff-=S
					if(src.rfxbuff<=0)
						src.rfxbuff=0
					if(src.strbuff<=0)
						src.strbuff=0

			if(xpierce<2)
				x=round(p1 + p2, 1)
			if(x<=0)
				return
			src.curwound+=x
			src.combat("<font color=#eca940>You took [x] Wound damage from [attacker]!")

			if(usr.controlling_yamanaka&&usr&&!src.protected)
				if(usr)
					var/mob/Mind_Contract=src.Transfered
					if(Mind_Contract)
						Mind_Contract.Wound(x+3,3,usr,1)
						if(Mind_Contract)
							Mind_Contract.Hostile(usr)
						if(Mind_Contract)
							Mind_Contract.combat("You've taken Wound damage from [usr]")
							combat("As a result of attempting to hurt [Mind_Contract] has given you [x] wound damage as well")

			if(usr.Contract &&!reflected&&!src.protected)
				var/obj/C = usr.Contract
				if(usr.loc==C.loc)
					if(usr.Contract2)
						var/mob/F=usr.Contract2
						F.Wound(x,3,usr,1)
						if(F)
							F.Hostile(usr)
						if(F)
							if(src.clan=="Capacity")
								src.SSkinR=rand(1,10)
								if(src.SSkinR==1)
									src.curstamina-=x*1
									src.curchakra-=x*1
									F.combat("You've taken Wound damage from the Blood Contract with [usr]!!<font color =aqua>( Shark Skin <font color =red>FAILS<font color =aqua> takes the wound! )")
									combat("Your blood contract with [F] has given them [x] wound damage!!<font color =aqua><B> But shark skin takes the wounds!</B>")
									return
							F.combat("You've taken Wound damage from the Blood Contract with [usr]!!")
							combat("Your blood contract with [F] has given them [x] wound damage!!")

			if(client&&attacker&&attacker.clan == "Ruthless")
				attacker.adren+=x

			if(src.asleep)
				src.asleep=0
				src.stunned=0

mob
	proc
		Hostile(mob/human/player/attacker)
			if(attacker && src.faction && attacker.faction && (src.faction.village!=attacker.faction.village ||src.faction.village=="Missing"))
				if(src) spawn() src.register_opponent(attacker)
				if(attacker) spawn() attacker.register_opponent(src)
			if(istype(src,/mob/human/clay))
				spawn() src:Explode()
				return

			if(phenged)
				if(faction)mouse_over_pointer=faction_mouse[faction.mouse_icon]
				src.name=src.realname
				src.phenged=0
				spawn() Poof(src.x,src.y,src.z)
				src.overlays=0
				src:CreateName(255, 255, 255)
				var/mob/example=new src.type()
				src.icon=example.icon
				del(example)

			if(src.spacetimebarrier)
				if(!attacker||!src) return
				var/obj/space/f = new/obj/space(src.loc)
				spawn(20) del(f)
				var/X=rand(1,5)
				var/V=pick(1,2)
				switch(V)
					if(1)
						attacker.loc = (locate(src.x+X,src.y+X,src.z))
						flick('icons/space1.dmi',attacker)
						attacker.Facedir(src)
					if(2)
						attacker.loc = (locate(src.x-X,src.y-X,src.z))
						flick('icons/space1.dmi',attacker)
						attacker.Facedir(src)
				var/mob/B = attacker
				B.stunned=rand(3,4)
				src.spacetimebarrier=0
				return

			if(src.petals&&src)
				flick('icons/petals.dmi',src)
				sleep(3)
				src.AppearBehind(attacker)
				if(attacker) attacker.RemoveTarget(src)
				return

			if(using_crow)
				using_crow = 0
				protected = 3
				flick("Form", src)
				sleep(10)
				if(!src) return

				src.AppearBehind(attacker)

				flick("Reform", src)
				spawn()
					var/list/Gen = new
					for(var/turf/O in oview(attacker))
						if(O.density != 1)
							Gen += O
					var/turf/P = pick(Gen)
					var/Move = 10
					var/obj/Shur = new(locate(P.x, P.y, P.z))
					Shur.icon = 'icons/crow_gen.dmi'
					flick("T", Shur)
					sleep(6)
					Shur.icon_state = "T2"
					Shur.density = 1
					if(!Shur) return
					while(Shur && src && Move)
						sleep(1)
						step_to(Shur, attacker)
						Move--
						if(attacker in oview(1, Shur) && Shur)
							del Shur
							attacker.stunned = 5
							attacker.overlays += 'icons/crow_gen.dmi'
							spawn()
								while(attacker.stunned && attacker)
									sleep(1)
								if(attacker)
									attacker.overlays -= 'icons/crow_gen.dmi'
					if(Shur)
						del Shur
				return

			if(src.medicing)
				src.medicing=0
			if(src.qued)
				spawn() src.Deque(0)
			if(src.qued2)
				spawn() src.Deque2(0)
			src.mane=0
			src.usemove=0
			if(src.leading)
				src.leading=0
			if(istype(src,/mob/human/player/npc))
				if(attacker && attacker!=src && !(attacker.MissionTarget==src && (attacker.MissionType=="Escort"||attacker.MissionType=="Escort PvP")))
					if(!istype(attacker,/mob/human/player/npc/creep))spawn()src:Aggro(attacker)
			if(src.henged)
				src.henged=0
				src.mouse_over_pointer=faction_mouse[faction.mouse_icon]
				src.name=src.realname
				spawn() Poof(src.x,src.y,src.z)
				src:CreateName(255, 255, 255)
				src.Affirm_Icon()
				src.Load_Overlays()


			if(src.sleeping)
				combat("You were startled awake!")
			src.sleeping=0
			if(istype(src,/mob/human/npc))
				return
			if(istype(src,/mob/human/sandmonster))
				var/mob/human/sandmonster/xi =src
				xi.hp--
				if(xi.hp<=0)
					del(xi)
				return
			if(src.rasengan==1)
				src.Rasengan_Fail()
			if(src.rasengan==2)
				src.ORasengan_Fail()
			if(src.rasengan==3)
				src.Rasenshuriken_Fail()

			if(istype(src,/mob/human/player/npc/bunshin))
				if(src:bunshintype==0)
					spawn() Poof(src.x,src.y,src.z)
					src.invisibility=100
					src.target=-15
					src.loc=locate(0,0,0)
					src.targetable=0
					src.density=0
					src.targetable=0
					src.loc=locate(0,0,0)
					spawn(500)
						del(src)
			if(istype(src,/mob/human/player/npc/kage_bunshin))
				var/mob/human/player/npc/kage_bunshin/x = src
				spawn()
					var/dx=src.x
					var/dy=src.y
					var/dz=src.z
					if(!src:exploading&&!src:lightning)
						spawn()Poof(dx,dy,dz)
					else
						if(src:exploading)
							src:exploading=0
							spawn()explosion(rand(1000,2500),dx,dy,dz,src)
							src.icon=0
							src.targetable=0
							src.stunned=100
							src.invisibility=100
							src.density=0
							sleep(30)
						if(src:lightning)
							src:lightning=0
							src.icon=0
							src.targetable=0
							src.stunned=100
							src.invisibility=100
							src.frozen=1
							var/conmult = x.ControlDamageMultiplier()
							for(var/turf/t in oview(2,src))
								spawn()Electricity(t.x,t.y,t.z,30)
							spawn()AOExk(dx,dy,dz,2,(500+150*conmult),30,src,0,1.5,1)
							Electricity(dx,dy,dz,30)
							sleep(5)
					src:aggro=0
					src:aggrod=0
					src:dead=1
					src.stunned=100

					src.loc=locate(0,0,0)
					for(var/mob/human/player/p in world)
						if(p.key==src:ownerkey)
							p.controlmob=0
							p.client.eye=p.client.mob
					src.invisibility=100
					src.target=-15
					src.targetable=0
					src.density=0
					src.targetable=0
					spawn(100)
						del(src)
			if(attacker)
				if(attacker!=src && !src.ko && src.curstamina>0)
					src.lasthostile=attacker.key
			if(src.asleep)
				src.asleep=0
				src.stunned=0
				src.icon_state=""

			if(attacker&&attacker.client&&src.faction&&attacker.faction&&src.faction.village!=attacker.faction.village && !src.alertcool)
				src.alertcool=180
				var/onit=0
				var/list/options=new/list()
				for(var/turf/x in oview(8,src))
					if(!x.density)
						options+=x

				if(EN[5])
					if(length(options))
						spawn() for(var/mob/human/player/npc/OMG in world)
							if(!OMG.client&&OMG.z==src.z && onit<2)
								sleep(200)
								if(OMG&&attacker&&OMG.z==attacker.z)
									var/turf/nextt=pick(options)
									options-=nextt
									OMG.AppearAt(nextt.x,nextt.y,nextt.z)
									if(OMG.nisguard&&OMG.faction.village==src.faction.village&&attacker)
										onit++
										spawn()OMG.Aggro(attacker)
										if(get_dist(attacker,OMG)>10)
											walk_to(OMG,attacker,4,1)

										spawn()
											var/eie=0
											while(attacker && OMG && get_dist(attacker,OMG)>20 &&eie<10)
												eie++
												step_to(OMG,src,4)
												sleep(5)
											if(OMG)
												walk(OMG,0)
											spawn() if(OMG && attacker) OMG.Aggro(attacker)
											if(OMG && attacker && get_dist(attacker,OMG)>10)
												if(OMG.z==attacker.z)
													OMG.AppearAt(attacker.x,attacker.y,attacker.z)

var
	fourpointo=1
mob
	var
		c=0
		cc=0
		isguard=0
		dzed=0

mob
	proc/Graphiked2()
		var/image/O = image('icons/critical.dmi',src,icon_state="1",pixel_x=-6)
		var/image/O2 = image('icons/critical.dmi',src,icon_state="2",pixel_x=26)
		world<<O
		world<<O2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		del(O)
		del(O2)

	proc/Graphiked(icon/I)
		var/image/O = image(I,src)
		world<<O
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		del(O)

	proc/Combo(mob/M,r)
		if(src.skillspassive[13]&& src.combo<(1+src.skillspassive[13])&&!src.gate)
			src.combo++
			var/C=src.combo
			spawn(50)
				if(src.combo==C)
					src.combo=0

		if(M && src)

			if(M.using_crow)
				M.using_crow = 0
				M.protected = 2.5
				flick("Form", M)
				sleep(10)
				if(!M || !src) return
				M.AppearBehind(src)
				flick("Reform", M)
				spawn()
					var/list/Gen = new
					for(var/turf/O in oview(src))
						if(O.density != 1)
							Gen += O
					var/turf/P = pick(Gen)
					var/Move = 10
					var/obj/Shur = new(locate(P.x, P.y, P.z))
					Shur.icon = 'icons/crow_gen.dmi'
					flick("T", Shur)
					sleep(6)
					Shur.icon_state = "T2"
					Shur.density = 1
					if(!Shur) return
					while(Shur && src && Move > 0)
						sleep(1)
						step_to(Shur, src)
						Move--
						if(src in oview(1, Shur) && Shur)
							del Shur
							src.stunned = 5
							src.overlays += 'icons/crow_gen.dmi'
							spawn()
								while(src.stunned && src)
									sleep(1)
								if(src)
									src.overlays -= 'icons/crow_gen.dmi'
					if(Shur)
						del Shur
				return

			var/boom=0
			if(src.sakpunch2||usr.Size)
				src.sakpunch2=0
				boom=1
			var/blk=0

			spawn()if(M) M.Hostile(src)

			if(usr.beast_mode == 1)
				var/beastdamx=round((usr.str+usr.strbuff)*rand(10,50)/100)
				var/wounddam=pick(0,2)
				M.Dec_Stam(beastdamx, 0, usr)
				src.combat("Hit [M] for [beastdamx] Stamina and [wounddam] Wounds!")
				M.Wound(wounddam, 0, usr)

			if(usr.fusion)
				var/fusiondamx=round((usr.con+usr.conbuff)*rand(10,50)/100)
				if(usr.fusion&&Iswater(usr.x,usr.y,usr.z)&&Iswater(M.x,M.y,M.z))
					if(M)
						var/damage
						damage=rand(10,300)
						if(M)
							M.curchakra-=damage
							M.Dec_Stam(fusiondamx, 0, usr)
							usr.curchakra+=damage
						src.combat("Hit [M] for [fusiondamx] Stamina and Loses [damage] chakra!")
						if(usr) return
						else
							if(usr.curchakra>usr.chakra)
								usr.curchakra=usr.chakra
								usr.combat("You have are not allowed to go over your chakra limit")
							else
								if(usr) usr.curchakra+=damage

			if(src.scalpol)
				if(!M.icon_state)
					flick("hurt",M)


				var/critchan2=src.scalpoltime/10 * rand(2,5)
				critchan2 = min(critchan2, 33)
				src.scalpoltime=0
				if(prob(critchan2))
				//Critical..
					var/critdamx=round((usr.con+usr.conbuff)*rand(20,60)/10)
					var/wounddam=round(((rand(1,4)/2)*(usr.con+usr.conbuff-usr.conneg))/150)
					M.Dec_Stam(critdamx, 0, usr)
					M.movepenalty+=rand(2,4)
					if(toggle_combat==1)
						src.combat("Critical hit [M] for [critdamx] Stamina damage and [wounddam] Wounds!")
					//s_damage(M,critdamx,"#000000")
					spawn() if(M) M.Graphiked2()
					M.Wound(wounddam, 0, usr)
				else
					var/critdamx=round((usr.con+usr.conbuff)*rand(50,100)/100)
					var/wounddam=pick(0,1)
					M.Dec_Stam(critdamx, 0, usr)
					M.movepenalty+=rand(0,2)
					if(toggle_combat==1)
						src.combat("Hit [M] for [critdamx] Stamina damage and [wounddam] Wounds!")
				//	s_damage(M,critdamx,"#000000")

					M.Wound(wounddam, 0, usr)


				src.scalpoltime=0
				return

			for(var/mob/human/P in get_step(M,M.dir))
				if(P==src)
					blk=1

			if(M.isguard && src && blk && !boom)
				src.combat("[M] Blocked!")
				M.c--
				src.attackbreak+=10
				flick("hurt",src)

				M.icon_state=""
				M.isguard=0
				M.cantreact = 1
				spawn(15)
					M.cantreact = 0
				return
			usr=src

			if(!M.icon_state)
				flick("hurt",M)

			var/xp=0
			var/yp=0
			if(M.x>src.x)
				xp=1
			if(M.x<src.x)
				xp=-1
			if(M.y>src.y)
				yp=1
			if(M.y<src.y)
				yp=-1
			src.pixel_x=4*xp
			src.pixel_y=4*yp


			var/deltamove=0

			if(src.gentlefist)
				spawn() if(M) M.Chakrahit3()
				if(prob(50)) M.Wound(pick(1,2),0,src)
				++M.gentle_fist_block
				spawn(100)
					if(M) --M.gentle_fist_block
			else
				spawn()smack(M,rand(-10,10),rand(-5,15))
			var/critdam=0
			var/critchan=5

			if(bonedrill)
				var/time=0
				var/go=0
				var/location=M.loc
				while(go<=6&&src&&M&&!M.ko&&M.loc==location)
					src.icon_state="Throw1"
					M.icon_state="hurt"
					time++
					if(time>5)
						go++
						if(M)
							M.Dec_Stam(100+50*src:ControlDamageMultiplier(),3,src)
							M.Wound(rand(0,2),1,src)
							M.movepenalty+=rand(2,5)
							if(prob(70)&&M)
								Blood2(M)
								M.Earthquake(5)
						time=0
					sleep(1)
				if(src)
					src.icon_state=""
				if(M)
					M.icon_state=""
				return

			if(boom)
				M.Earthquake(5)
				critdam=round((usr.con+usr.conbuff+usr.str+usr.strbuff)*rand(1,2)) +600
				if(usr.Size==1)
					critdam=round((usr.str+usr.strbuff)*rand(2,4)) +700
				if(usr.Size==2)
					critdam=round((usr.str+usr.strbuff)*rand(3,5.5)) +800
				M.Dec_Stam(critdam,0,usr)
				M.movepenalty+=20
				if(!usr.Size)
					src.combat("Hit [M] for [critdam] damage with a chakra infused critical hit!!")
				//	s_damage(M,critdam,"#000000")
				else
					src.combat("Hit [M] for [critdam] with your massive fist!!")
				//	s_damage(M,critdam,"#000000")
				spawn() if(M) M.Graphiked2()

				if(!usr.Size)spawn()explosion(50,M.x,M.y,M.z,usr,1)
				if(src)
					src.pixel_x=0
					src.pixel_y=0
				if(M)
					M.pixel_y=0
					M.pixel_x=0
				M.Knockback(rand(5,10),src.dir)
				return
			if(prob(critchan))
				//Critical..

				if(!usr.gentlefist)
					critdam=round((usr.str+usr.strbuff)*rand(15,40)/10) *(1+0.10*src.skillspassive[2])
				else
					critdam=round((usr.con+usr.conbuff)*rand(15,40)/10)*(1+0.10*src.skillspassive[2])
				M.movepenalty+=10
				src.combat("Critical hit!")
				spawn()if(M) M.Graphiked2()


			var/outcome = Roll_Against(usr.rfx+usr.rfxbuff-usr.rfxneg, M.rfx+M.rfxbuff-M.rfxneg, rand(80,120))
			var/damage_stat
			if(!usr.gentlefist)
				damage_stat = usr.str+usr.strbuff-usr.strneg
			else
				damage_stat = usr.con+usr.conbuff-usr.conneg

			var/m=damage_stat/150

			if(src.gate>=5)
				m*=1.5

			var/dam=0

			switch(outcome)
				if(6)
					deltamove+=3
					M.c+=4
					dam=round(150*m)
				if(5)
					deltamove+=2
					M.c+=3.5
					dam=round(115*m)
				if(4)
					deltamove+=1
					M.c+=3
					dam=round(100*m)
				if(3)
					deltamove+=1
					M.c+=2.5
					dam=round(70*m)
				if(2)
					//deltamove+=3
					M.c+=2
					dam=round(40*m)
				if(1)
					//deltamove+=3
					M.c+=2
					dam=round(30*m)
				if(0)
					//deltamove+=2
					M.c+=2
					dam=round(20*m)

			if(M.c>13)
				if(prob(10))
					spawn()if(M) M.Knockback(1,src.dir)
					spawn(1)
						step(src,src.dir)
			if(combo)
				dam*=1+0.20*combo
			var/DD=dam+critdam

			M.Dec_Stam(DD, 0, usr,0,1)

			for(var/mob/human/v in view(1))
				if(v.client)
					if(toggle_combat==1)
						v.combat("[M] was hit for [DD] damage by [src]!")
				//	s_damage(M,DD,"#000000")

			M.movepenalty += deltamove/2
			var/dazeresist=8*src.skillspassive[9]

			if(M.c > 20 && !M.cc &&!prob(dazeresist) )//combo pwned!!
				M.dzed=1
				M.cc=150
				M.icon_state="hurt"
				var/dazed=30
				dazed*= 1 + 0.1*src.skillspassive[11]
				M.move_stun=round(dazed,0.1)

				spawn() if(M) M.Graphiked('icons/dazed.dmi')
				spawn() if(M) smack(M,0,0)
				src.combat("[M] is dazed!")
				spawn()
					while(M&&M.move_stun)
						sleep(1)
					if(M)
						M.icon_state=""
						M.dzed=0
						M.c=0

			sleep(3)
			if(src)
				src.pixel_x=0
				src.pixel_y=0
			if(M)
				M.pixel_y=0
				M.pixel_x=0


mob/var/camo=0


mob
	proc
		attackv(mob/M)
			set name = "Attack"
			set hidden = 1
			var/weirdflick=0
			if(!EN[16])
				return
			if(src.Tank)
				return

			if(src.controlmob)
				usr=controlmob
				src=controlmob
				weirdflick=1

			if(src.camo)
				src.Affirm_Icon()
				src.Load_Overlays()
				src.camo=0

			if(usr.sakpunch)
				usr.sakpunch=0
				usr.sakpunch2=1

			if(src.Transfered||src.controlling_yamanaka)
				return

			spawn(10)
				usr.sakpunch2=0

			if(usr.leading)
				usr.leading=0
				return

			if(usr.cantreact)
				return

			var/r=0
			if(!M)

				if(usr.incombo || usr.frozen || usr.ko)
					return

				if(usr.isguard)
					usr.icon_state=""
					usr.isguard=0

				Pk_Check()

				if(istype(usr,/mob/human/player/npc))
					var/ans=pick(1,2,3,4)
					if(usr.Size||usr.bonedrill||usr.MorningP)ans=5
					r=ans
					if(ans==1)
						spawn()flick("PunchA-1",usr)
					if(ans==2)
						spawn()flick("PunchA-2",usr)
					if(ans==3)
						spawn()flick("KickA-1",usr)
					if(ans==4)
						spawn()flick("KickA-2",usr)
					if(ans==5)
						usr.icon_state="PunchA-1"
						spawn(6)
							usr.icon_state=""

				if(usr.sleeping || usr.mane || !usr.canattack)
					return

				if(usr.NearestTarget()) usr.FaceTowards(usr.NearestTarget())

				if(!usr.pk)
					if(!usr.nudge)
						usr.combat("Nudge")
						usr.nudge=1

						spawn(10)
							usr.nudge=0
						for(var/mob/human/player/o in get_step(usr,usr.dir))
							if(o.density==1 && !o.sleeping)
								o.Knockback(1,usr.dir)
								o.move_stun=5
								o.density=0
								spawn(5)
									o.density=1

						for(var/mob/human/clay/o in get_step(usr,usr.dir))
							o.Explode()
					return

				if(usr.ridingbird)
					if(usr.curchakra>=200)
						usr.curchakra-=200
						for(var/time = 1 to 3)
							var/obj/O = new
							usr.stunned = 0.1
							O.icon = 'icons/clay-attack.dmi'
							O.icon_state = "[rand(1,3)]"
							O.layer = MOB_LAYER + 0.1
							O.dir = usr.dir
							O.density = 0
							O.pixel_x = rand(-16,16)
							O.pixel_y = rand(-16,16)
							var/list/dirs = new
							if(usr.dir == NORTH || usr.dir == SOUTH)
								dirs += EAST
								dirs += WEST
							if(usr.dir == NORTH)
								dirs += NORTH
								if(usr.dir == SOUTH)
									dirs += SOUTH
							if(usr.dir == EAST || usr.dir == WEST || usr.dir == SOUTHEAST || usr.dir == SOUTHWEST || usr.dir == NORTHEAST || usr.dir == NORTHWEST)
								dirs += SOUTH
								dirs += NORTH
								if(usr.dir == EAST || usr.dir == SOUTHEAST || usr.dir == NORTHEAST)
									dirs += EAST
								if(usr.dir == WEST || usr.dir == SOUTHWEST || usr.dir == NORTHWEST)
									dirs += WEST
							O.loc = get_step(usr,pick(dirs))
							sleep(0.05)
							spawn()
								var/tiles = rand(10,15)
								while(usr && tiles > 0 && O.loc != null)
									tiles--
									var/old_loc = O.loc
									for(var/mob/m in view(0,O))
										tiles = 0
										m.Dec_Stam(190*usr:ControlDamageMultiplier(),0,usr)
										m.Wound(rand(0,2),0,usr)
										Blood2(m)
									if(tiles == 0)
										continue
									step(O,O.dir)
									if(O.loc == old_loc)
										tiles = 0
										continue
									sleep(1.25)
								explosion(190*usr:ControlDamageMultiplier(),O.x,O.y,O.z,usr,dist = 1)
								O.loc = null
								usr.protected = 0
								return
					else
						usr<<"You do not have the required chakra for this. [usr.curchakra]/200"
						return 0

				if(usr.rasengan)
					if(usr.rasengan==1)
						usr.overlays-=/obj/rasengan
						usr.overlays+=/obj/rasengan2
						sleep(1)
						flick("PunchA-1",usr)

						var/i=0
						for(var/mob/human/o in get_step(usr,usr.dir))
							if(!o.ko && !o.protected)
								i=1
								if(usr.rasengan==1)
									Rasengan_Hit(o,usr,usr.dir)
						if(i==0)
							Rasengan_Fail()
						return

					if(usr.rasengan==2)
						usr.overlays-=/obj/oodamarasengan
						usr.overlays+=/obj/oodamarasengan2
						sleep(1)
						flick("PunchA-1",usr)
						var/i=0
						for(var/mob/human/o in get_step(usr,usr.dir))
							if(!o.ko && !o.protected)
								i=1
								if(usr.rasengan==2)
									ORasengan_Hit(o,usr,usr.dir)
						if(i==0)
							ORasengan_Fail()
						return
				if(usr.rasengan==3)
					usr.overlays-=/obj/rasenshuriken
					usr.overlays+=/obj/rasenshuriken2
					sleep(1)
					flick("PunchA-1",usr)
					var/i=0
					for(var/mob/human/o in get_step(usr,usr.dir))
						if(!o.ko && !o.protected)
							i=1
							if(usr.rasengan==3)
								Rasenshuriken_Hit(o,usr,usr.dir)
					if(i==0)
						Rasenshuriken_Fail()
					return
				if(usr.Aki)
					weirdflick=1

				if(usr.pet)
					var/mob/human/player/t = usr.MainTarget()
					if(usr && t)
						for(var/mob/human/player/npc/x in usr.pet)
							if(t == usr) return
							if(x.stunned) return
							step_towards(x,t)
							spawn()x.Aggro(t)
							spawn()x.usev(t)
							spawn()x.Aggro(t)

				if(usr.stunned||usr.kstun||usr.handseal_stun)
					return

				if(usr.attackbreak)
					return

				var/trfx=usr.rfx+usr.rfxbuff-usr.rfxneg
				if(trfx<75)
					usr.attackbreak=10
				else if(trfx<100)
					usr.attackbreak=8
				else if(trfx<125)
					usr.attackbreak=6
				else if(trfx<150)
					usr.attackbreak=5
				else if(trfx<175)
					usr.attackbreak=4
				else if(trfx<200)
					usr.attackbreak=3
				else if(trfx<250)
					usr.attackbreak=2

				var/rx=rand(1,8)

				if(usr.gentlefist)
					rx=rand(1,6)
				if(usr.scalpol)
					spawn() flick("w-attack",usr)

				else
					if(usr.larch||usr.bonedrill)
						if(bonedrill)
							bonedrilluses--
						rx = 1
					if(!istype(usr,/mob/human/player/npc))
						if(usr.Size)
							usr.icon_state="PunchA-1"
							spawn(6)
								usr.icon_state=""

						else if(!weirdflick)
							if(rx>=1 && rx<=3)
								spawn()flick("PunchA-1",usr)
								r=1

							if(rx>=4 && rx<=6)
								spawn()flick("PunchA-2",usr)
								r=2
							if(rx==7)
								spawn()flick("KickA-1",usr)
								r=3
							if(rx==8)
								spawn()flick("KickA-2",usr)
								r=4

						else
							if(rx>=1 && rx<=3)
								spawn()
									r=1
									usr.icon_state="PunchA-1"
									sleep(5)
									usr.icon_state=""

							if(rx>=4 && rx<=6)
								spawn()
									r=2
									usr.icon_state="PunchA-2"
									sleep(5)
									usr.icon_state=""

							if(rx==7)
								spawn()
									r=3
									usr.icon_state="KickA-1"
									sleep(5)
									usr.icon_state=""
							if(rx==8)
								spawn()
									r=4
									usr.icon_state="KickA-2"
									sleep(5)
									usr.icon_state=""

			var/deg=0
			var/hassword=usr.hassword
			var/attack_range = 1
			if(hassword)deg+=2
			if(usr.Size==1)
				deg=15
				attack_range = 2
			if(usr.Size==2)
				deg=25
				attack_range = 2

			if(usr.move_stun)
				deg = (deg * 1.5) + 5

			usr.canattack = 0
			spawn(4+deg)
				usr.canattack = 1

			var/mob/target
			if(M)
				target = M
			else
				target = usr.NearestTarget()

			var/mob/T

			if(target)
				if(usr.gate >= 6 && usr.MorningP==1)
					spawn()
						var/eicon='icons/fireball.dmi'
						var/estate=""
						var/strmult = usr.str
						var/wounddam=rand(1,4)
						usr.Wound(wounddam, 0, usr)
						strmult+= usr.str
						var/ex=target.x
						var/ey=target.y
						var/ez=target.z
						var/mob/x=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,usr,x)
						del(x)
						spawn()AOE(ex,ey,ez,1,(100 +40*strmult),20,usr,3,1,1)
						spawn()Fire(ex,ey,ez,1,20)
						spawn()FireAOE(ex, ey, ez, 1, (100 +20*strmult), 20, usr, 1, 0)
				if(usr.MorningP==1)
					usr.MorningP=0
					usr << "font color=white>Morning Peacock has been deactivated"

				if(usr.sage_mode&&prob(40)&&usr)
					if(get_dist(target, usr) < 3)
						usr:AppearBefore(target)
						spawn(3)usr:AppearBehind(target)
						usr.Combo(target,r)
						spawn()usr.Taijutsu(target)

				if(usr.gate >= 4 && !usr.gatepwn && usr.MorningP!=1)
					if(get_dist(target, usr) < 5)
						usr:AppearBefore(target)
						usr.dir = get_dir(src, target)
						usr.Combo(T,r)

						spawn()usr.Taijutsu(T)
						sleep(1)
				if(usr.lightning_armor==2)
					if(get_dist(target, usr) < 8&&prob(70))
						usr:AppearBefore(target)
						usr.dir = get_dir(src, target)
						usr.Combo(T,r)

						spawn()usr.Taijutsu(T)
						sleep(1)
				else
					if(target in oview(attack_range))
						T = target

				if(M)
					T = M

				if(T && !T.ko && !T.paralysed)
					if(usr.gate >= 5)
						var/obj/smack=new/obj(locate(T.x,T.y,T.z))
						smack.icon='icons/gatesmack.dmi'
						smack.layer=MOB_LAYER+1
						flick("smack",smack)
						spawn(4)
							del(smack)

					usr.Combo(T,r)

					spawn()usr.Taijutsu(T)
					return

				if(usr.lightning_armor>=1)
					if(get_dist(T, usr) < 2&&!T.ko&&T)
						if(T&&!T.player_target&&prob(50)&&usr.super_speed_contract<=3)
							T.player_target=1
							usr.super_speed_contract+=1
							usr.combat("You are able to use one move or instantly teleport infront of the target with shunshin one time within 30 seconds")
							spawn(300)
								if(T)
									T.player_target=0
									usr.super_speed_contract-=1
						else return

					usr.Combo(T,r)

					spawn()usr.Taijutsu(T)
					return

			var/last_turf = usr.loc
			var/iterations = 0

			do
				last_turf = get_step(last_turf,usr.dir)
				T=locate() in last_turf
			while(++iterations < attack_range && (!T || T.ko || T.paralysed))

			if(T&&T.ko==0&&T.paralysed==0)
				if(usr.gate >= 5)
					var/obj/smack=new/obj(locate(T.x,T.y,T.z))
					smack.icon='icons/gatesmack.dmi'
					smack.layer=MOB_LAYER+1
					flick("smack",smack)
					spawn(4)
						del(smack)

				usr.Combo(T,r)

				spawn()usr.Taijutsu(T)

		defendv()
			set name= "Defend"
			set hidden=1

			if(src.gate>=6)
				if(usr.MorningP==1)
					usr.MorningP=0
					usr<<"<font color=#F88017>Morning Peacock <font color=green>(DEACTIVATED!)"
					usr.overlays-='fire hands.dmi'
					return
				if(usr.MorningP==0)
					usr.MorningP=1
					usr<<"<font color=#F88017>Morning Peacock <font color=green>(ACTIVATED!)"
					usr.overlays+='fire hands.dmi'
					return

				if(src.Transfered||src.controlling_yamanaka)
					return
/*
			if(src.Intangibilty==1)
				if(usr.stm==0)
					var/time=rand(3,4)
					usr << "Intangible"
					usr.stm=1
					usr.usemove=1
					while(time > 0)
						usr.protected=100
						time--
						sleep(10)
						if(time <= 0)
							usr.stm=0
							usr.usemove=0
							usr << "Lost Intangability"
							usr.protected=0
					return
*/
			for(var/mob/human/sandmonster/M in usr.pet)
				spawn() if(M) M.Return_Sand_Pet(usr)

			if(usr.controlmob)
				return 0

			if(usr.pet)
				for(var/mob/human/player/npc/p in usr.pet)
					spawn()
						if(usr && p)
							p.aggrod = 1
							var/list/options = list()
							if(options.len)
								var/skill/x
								do
									x = pick(options)
									options -= x
								while(options.len && !x.IsUsable(p))
								if(x && x.IsUsable(p))
									x.Activate(p)
									return

			if(usr.Size||usr.Tank)
				return

			if(!EN[16])
				return

			usr.usedelay++

			if(usr.leading)
				usr.leading=0
				return

			if(usr.cantreact || usr.spectate || usr.larch || usr.sleeping || usr.mane || usr.ko || !usr.canattack)
				return

			if(usr.skillspassive[21] && usr.gen_effective_int && !usr.gen_cancel_cooldown)
				var/cancel_roll = Roll_Against(usr.gen_effective_int,(usr.con+usr.conbuff-usr.conneg)*(1 + 0.05*(usr.skillspassive[21]-1)),100)
				if(cancel_roll < 3)
					if(usr.sight == (BLIND|SEE_SELF|SEE_OBJS)) // darkness gen
						usr.sight = 0

				usr.gen_cancel_cooldown = 1
				spawn(100)
					usr.gen_cancel_cooldown = 0

			if(usr.MainTarget()) usr.FaceTowards(usr.MainTarget())

			if(usr.rasengan==1)
				usr.Rasengan_Fail()
			if(usr.rasengan==2)
				usr.ORasengan_Fail()
			if(usr.rasengan==3)
				usr.Rasenshuriken_Fail()

			if(usr.controlmob)
				usr=usr.controlmob

			if(usr.stunned||usr.kstun||usr.handseal_stun)
				return

			if(usr.isguard==0)
				usr.icon_state="Seal"
				usr.isguard=1

/*
if(usr&&usr.fusion)

					var/mob/human/player/target = usr.NearestTarget()

					if(usr.fusion&&Iswater(usr.x,usr.y,usr.z)&&Iswater(target.x,target.y,target.z))
						rx=rand(1,6)
						if(target)
							var/damage
							damage=rand(10,300)
							target.curchakra-=damage
							if(usr) return
							else
								if(usr.curchakra>usr.chakra)
									usr.curchakra=usr.chakra
									usr.combat("You have are not allowed to go over your chakra limit")
								else
									if(usr) usr.curchakra+=damage*/

mob/proc/Get_Hair_RGB()
	src.hair_color=input(usr, "What color would you like your hair to be?") as color

obj
	skilltree
		Back
			Click()
				usr.client.eye=usr.client.mob
				usr.hidestat=0
				usr.spectate=0
		Next_Page
			Click()
				usr.client.eye=locate_tag("maptag_x")
				usr.spectate = 1
				usr.hidestat = 1
				usr:refreshskills()
		Next_Page_2
			Click()
				usr.client.eye=locate_tag("maptag_y")
				usr.spectate = 1
				usr.hidestat = 1
				usr:refreshskills()
		Back_Clan
			Click()
				usr.client.eye=locate_tag("maptag_skilltree_clan")
				usr.spectate = 1
				usr.hidestat = 1
				usr:refreshskills()
		Back_Clan_2
			Click()
				usr.client.eye=locate_tag("maptag_x")
				usr.spectate = 1
				usr.hidestat = 1
				usr:refreshskills()
mob/human/npc/dojoowner
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1
			alert(usr,"Welcome to the Dojo, this place isnt quite a pk zone and its not quite a no-pk zone. In the dojo, you can fight but youll never be wounded, its a safe place to spar and train.")
mob/human/npc/barber
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1
			switch(input2(usr,"Would you like to get your hair cut?", "Barber",list ("Yes","No")))
				if("Yes")
					usr.hidestat=1
					usr.GoCust()

mob/human/npc/headbandguy
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1
			if(usr.rank!="Academy Student")
				for(var/obj/items/equipable/Headband/x in usr.contents)
					del(x)
				switch(input2(usr,"What Type of Headband would you like?", "Headband",list ("Blue","#000000","Red")))
					if("Red")
						new/obj/items/equipable/Headband/Red(usr)
					if("Blue")
						new/obj/items/equipable/Headband/Blue(usr)
					if("#000000")
						new/obj/items/equipable/Headband/Black(usr)
			else
				usr<<"You get a Headband only when you graduate!"
mob/human/npc
	New()
		..()
		Load_Overlays()

mob/human/npc/teachernpc3
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1

mob/human/npc/teachernpc2
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1

proc
	smack(mob/M,dx,dy)
		if(!M) return
		if(wregenlag>2)
			return
		var/Px=dx+M.pixel_x
		var/Py=dy+M.pixel_y
		var/obj/X=new/obj(M.loc)
		X.pixel_x=Px
		X.pixel_y=Py
		X.layer=M.layer
		X.layer++
		X.density=0
		X.icon='icons/twack.dmi'
		flick("fl",X)
		sleep(7)
		X.loc = null
		//del(X)

//teacher!
mob/human/npc/teachernpc
	interact="Talk"
	verb
		Talk_r()
			set src in oview(1)
			alert(usr,"In Naruto GOA, you don't talk to npcs by right clicking on them, double click an npc first to target it (signified by a red arrow) then press Space or the button labeled 'Spc' on the screen.")
		Talk()
			set src in oview(1)
			set hidden=1
