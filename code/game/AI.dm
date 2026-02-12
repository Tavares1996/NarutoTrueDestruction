var

	Compatibility=0
mob/human/player/npc/creep/var/lasthurtme=0
mob/human/player/npc/proc
	NpcFollow(var/mob/P)
		if(!EN[5])
			return
		if(P)
			src.density=0
			spawn(6)
				if(!src.following)
					src.density=1
			if(!locate(P) in oview(1,src))
				spawn()src.Approach2(P)
			var/turf/newloc=0
			if(P.dir==NORTH)
				newloc=locate(P.x,P.y-1,P.z)
				for(var/turf/E in locate(newloc))
					if(E.density)
						newloc=0
			if(P.dir==SOUTH)
				newloc=locate(P.x,P.y+1,P.z)
				for(var/turf/E in locate(newloc))
					if(E.density)
						newloc=0
			if(P.dir==EAST)
				newloc=locate(P.x-1,P.y,P.z)
				for(var/turf/E in locate(newloc))
					if(E.density)
						newloc=0
			if(P.dir==WEST)
				newloc=locate(P.x+1,P.y,P.z)
				for(var/turf/E in locate(newloc))
					if(E.density)
						newloc=0
			var/tox
			var/toy
			var/toz
			if(!newloc)
				tox=P.x
				toy=P.y
				toz=P.z
			else
				tox=newloc.x
				toy=newloc.y
				toz=newloc.z
			sleep(2)
			src.loc=locate(tox,toy,toz)

			if(src.missionowner==P && src.following && !src.aggro  && P.leading && P.Missionstatus)
				sleep(5)
				spawn()src.NpcFollow(P)
			else
				src.following=0

				P.leading=0
		else
			src.following=0
			src.loc=locate(src.origx,src.origy,src.origz)
mob/human/player/npc
	proc
		AIinitialize()
			origx=src.x
			origy=src.y
			origz=src.z
			src.Get_Global_Coords()
			spawn()src.AI()
			spawn(20)
				src.curstamina=src.stamina
				src.curchakra=src.chakra

mob/human/player/npc
	New()
		..()
		if(src.questable)
			src.dietype=0
		spawn(100)
			if(!faction)
				while(!leaf_faction && !mist_faction && !sand_faction && !missing_faction) sleep(10)
				switch(locationdisc)
					if("Konoha")
						faction=leaf_faction
					if("Suna")
						faction=sand_faction
					if("Kiri")
						faction=mist_faction
					else
						faction=missing_faction
				if(faction!=missing_faction)mouse_over_pointer = faction_mouse[faction.mouse_icon]
		if(src.pants=="random")
			src.pants=pick(typesof(/obj/pants))
		if(src.overshirt=="random")
			src.overshirt=pick(typesof(/obj/shirt))
		if(src.hair_type==99)
			src.hair_type=pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,0)
		spawn()src.Affirm_Icon()


		origx=src.x
		origy=src.y
		origz=src.z
		if(src.projectiles)
			spawn()src.getweapon()
		spawn()src.completeLoad_Overlays()

		spawn()src.npcregeneration() //!
		spawn(5)
			for(var/m in src.skillsx)
				src.AddSkill(m)
			spawn()src.refreshskills()
		spawn()src.Stun_Drain() //!
		spawn()src.AI()
		src.stamina=src.blevel*55 +src.str*20
		src.chakra=190 +src.blevel*10 + src.con*2.5
		if(src.patrol)
			spawn()src.Patrol()
		spawn(20)
			src.curstamina=src.stamina
			src.curchakra=src.chakra
			src.staminaregen=round(src.stamina/100)
			src.chakraregen=round((src.chakra*3)/100)

	interact="Talk"

	verb
		Talk()
			set src in oview(1)
			set hidden=1
			if(!EN[5])
				return
			for(var/mob/human/player/X in world)
				if((X.ckey in admins) && X.z == src.z)
					X<<"usr=[usr], src=[src], aggro=[src.aggro], MissionTarget=[usr.MissionTarget], MissionType=[usr.MissionType]"
			if(src.aggro && usr.MissionTarget == src && (usr.MissionType == "Escort" || usr.MissionType == "Escort PvP"))
				alert(usr,"Sorry, i will calm down")
				src.aggro=0
				src.aggrod=0
				return
			if(!src.aggro)
				if(src.onquest && usr.MissionTarget==src)
					if(usr.MissionType=="Delivery")
						usr << "Thank you very much!"
						if(usr.MissionType=="Delivery")
							usr.MissionType=0

							usr.MissionComplete()
						return
					if((usr.MissionType=="Escort"||usr.MissionType=="Escort PvP") && !src.following)
						src.loc=locate(usr.x,usr.y,usr.z)
						usr << "Hello, I need to get to [usr.MissionLocation].  Press Space/Interact and ill stop following you."
						if(usr.z==src.z)
							spawn()src.NpcFollow(usr)
							src.following=usr
							usr.leading=src

						return
				else
					var/list/choicelist=new
					choicelist+="Ask about them"
					if(src.chattopic)
						choicelist+=src.chattopic

					choicelist+="Nevermind"

					var/Talkbout=input2(usr,"NPC Chat Options:","NPC",choicelist)
					if(Talkbout=="Ask about them")
						alert(usr,"[src.message]")
					else if(Talkbout!="Nevermind")
						usr.TalkTopic(src,Talkbout)

	verb
		Shop()
			set src in oview(1)
			set hidden=1
			if(!src.aggro)
				src.Check_Sales(usr)

mob/human
	str=50
	con=50
	rfx=50
	int=50
	stamina=1000
	chakra=300
	icon='icons/base_m1.dmi'
	icon_state=""

mob/human/player/npc
	proc
		npcHostile()
			if(!EN[5])
				return
			if(!src.aggrod||!src.aggro)
				for(var/mob/human/player/x in oview(src.agrange,src))
					if(x.client)
						if(src.bunshinowner!=x || src.ownerkey!=x.key||src.owner!=x||x.pet!=src)
							src.Aggro(x)
			sleep(30)
			return

		npcDie()
			if(!EN[5])
				return
			if(src.onquest)
				var/questdone=0

				for(var/mob/human/player/X in oview(8))
					if(X.MissionTarget==src)
						questdone=1
						if(X.MissionType=="Escort"||X.MissionType=="Escort PvP")

							X.MissionFail()
						else if(X.MissionType=="Assasinate"||X.MissionType=="Kill Npc PvP"||X.MissionType=="Invade PvP")
							X.MissionComplete()

				if(questdone)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.onquest=1
					sleep(900)
					src.onquest=0
					src.curwound=0
					src.aggro=0
					src.aggrod=0
					src.curstamina=src.stamina
					src.density=1
					src.targetable=1
					src.icon_state=""
					src.loc=locate(src.origx,src.origy,src.origz)

			src.aggro=0
			src.aggrod=0

			switch(src.dietype) //0=KO,no death 1=delayed respawn 2=death till repop
				if(0)
					src.icon_state="Dead"
					sleep(200)
					src.curwound=0
					src.curstamina=src.stamina
					src.icon_state=""
					src.aggro=0
					src.aggrod=0
					for(var/mob/human/player/npc/X in oview(5))
						if(X.aggro==src)
							X.aggro=0

				if(1)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1
					spawn(src.respawndelay)
						new src.type (locate(src.origx,src.origy,src.origz))
						del(src)

				if(2)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.target=0
					src.dead=1

				if(3)//exp gain
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.target=0
					src.dead=1

					if(istype(src,/mob/human/player/npc/creep))
						var/mob/human/player/npc/creep/C=src
						var/mob/human/player/X = C.lasthurtme
						if(X)
							var/gain=min(1500,round(1800 * src.blevel/X.blevel))*lp_mult_two
							X.body+=gain
							X<<"You gained [gain] experience points!"
							X.bodycheck()
							C.lasthurtme=null
					spawn(100)
						del(src)

		Stun_Drain()
			set background = 1
			sleep(10)
			while(src.z && src.invisibility<2)
				sleep(10)
				if(src.move_stun)
					move_stun = max(0, move_stun-10)
				if(src.stunned)
					src.stunned--
				if(src.tired)
					src.tired--

		AI()
			var/allset=0
			for(var/mob/human/player/P in oview(10))
				if(P && (P.client))
					allset=1
					break
			if(allset)
				var/didsomething=0
				if(src.wander && !src.following)
					src.Wander()
					didsomething=1
				if(src.hostile)
					src.npcHostile()
					didsomething=1
				if(!didsomething)
					sleep(50)
				if(!src.dead)
					spawn()src.AI()
			else
				sleep(50)
				if(!src.dead)
					spawn()src.AI()

		Patrol()
			set background = 1
			if(!EN[5])
				return
			var/busy=0
			var/maxspot=length(px)

			if(length(py) < length(px))
				maxspot=length(py)
			spot=1
			while(spot<maxspot &&!aggro)
				var/turf/targ=locate(px[spot],py[spot],z)
				var/list/cloc=oview(1,targ)
				while(!aggro&&dead==0&&busy<200 &&!cloc.Find(src))
					cloc=oview(1,targ)
					if(spot<=length(px) && spot<=length(py))
						if(spot<=0)
							spot=1
						var/turf/towalk=locate(px[src.spot],py[src.spot],z)
						base_StepTowards(towalk,0,5)
						busy++
					sleep(20)

				sleep(30)
				spot++

			while(!aggro&&!dead&&busy<200&&!(x==origx && y==origy)&&!aggro)
				var/turf/towalk=locate(origx,origy,z)
				base_StepTowards(towalk,0,5)
				busy++
				sleep(20)

			sleep(30)

			spot=0

			sleep(10)

			while(aggro)
				sleep(50)

			if(busy>200)
				walk(src,0)
				src.AppearAt(origx,origy,origz)
				sleep(300)
				busy=0

			if(!dead)
				spawn() Patrol()

	proc
		getweapon()
			switch(src.projectiles)
				if(1)
					var/x=new/obj/items/weapons/projectile/Kunai_p(src)
					x:Use(src)
				if(2)
					var/x=new/obj/items/weapons/projectile/Shuriken_p(src)
					x:Use(src)
				if(3)
					var/x=new/obj/items/weapons/projectile/Needles_p(src)
					x:Use(src)
				if(4)
					var/x=new/obj/items/weapons/projectile/Kunai_p(src)
					x:Use(src)

	proc
		Wander()
			set background = 1
			if(!EN[5])
				return
			if(src.dead)
				sleep(50)
				return
			if(src.npcCanmove())
				var/list/pickdirs=list(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

				top
				var/P=pick(pickdirs)
				var/turf/x = get_step(src,P)
				if(!x || x.density==1)
					pickdirs.Remove(P)
					if(length(pickdirs))goto top
				step(src,P)
				sleep(30)
				return
			else
				sleep(50)
				return

	proc
		npcCanmove()
			if(src.stunned==0 && src.ko==0 && src.maned==0 && src.kaiten==0&&src.incombo==0)
				return 1
			else
				return 0

	proc
		Aggro(var/mob/human/player/M)
			src.pk=1
			src.newaggro=1

			if(src.aggro||src.aggrod)
				sleep(15)
				src.aggro=0
				src.aggrod=0

			if(src.owner == M) return
			if(src.aggrod)
				return
			if(src.killable)
				src.AddTarget(M,1)
				src.aggro=M
				src.aggrod=1
				src.newaggro=0
				spawn()
					while(src.aggro && src.dead==0 && src.newaggro==0)
						sleep(-1)
						if(M)
							if(M.ko)
								if(src.curwound>src.maxwound)
									src.aggro=0
									src.aggrod=0
								else
									while(M.ko)
										sleep(30)
										if(!M)break

						if(src.npcCanmove())
							for(var/obj/trailmaker/I in oview(10))
								spawn()
									walk_away(src,I,5,1)
									sleep(5)
									if(I)walk_away(src,I,5,1)
									sleep(5)
									walk(src,0)

							var/list/x = oview(3,src)//changed
							if(x.Find(M))
								var/doz=pick(0,0,1)
								if(doz)
									spawn()src.Dodge(M)
							else
								var/choice=pick(1,0)
								if(choice)
									src.Approach(M)
								else
									sleep(-1)
									src.Approach2(M)
							if(src.tired==0)
								var/list/Ex = oview(5,src)
								if(Ex.Find(M))
									if(src.Squad)
										if(src.Squad[1]!=src)
											var/mob/Leader=src.Squad[1]
											var/Leaderalive=0
											for(var/mob/human/player/npc/O in oview(6))
												if(O==Leader && !O.dead)
													Leaderalive=1
											if(!Leaderalive)
												src.Squad-=src
												src.Squad[1]=src
										else
											var/list/mem=new
											for(var/mob/human/O in view(6))
												var/list/SquadL=Squad
												if(SquadL.Find(O))
													mem+=O
											if(mem.len)
												var/mob/human/player/npc/Chosen=pick(mem)
												Chosen.Action_Against(M)

									else
										src.Action_Against(M)
							if(M)
								if(abs(M.x-src.x) > 10 || abs(M.y-src.y)>10 || M.z!=src.z||M.invisibility>2)
									src.aggrod=0

									spawn(300)
										if(M&&src)
											if((abs(M.x-src.x) > 10 || abs(M.y-src.y)>10|| M.z!=src.z||M.invisibility>2)&&!src.aggrod)
												src.aggro=0
												src.aggrod=0
												for(var/mob/human/player/P in oview(10,src))
													if(aggrohist.Find(P))

														src.aggrohist=new/list()
														spawn()src.Aggro(P)

												if(src.guard||src.patrol)
													src.spot=0
													if(src.loc!=locate(src.origx,src.origy,src.origz))
														src.AppearAt(src.origx,src.origy,src.origz)
														src.dir=SOUTH
									return
							else
								src.aggro=0
								src.aggrod=0
								for(var/mob/human/player/P in oview(10,src))
									if(aggrohist.Find(P))

										src.aggrohist=new/list()
										spawn()src.Aggro(P)
								if(istype(src,/mob/human/player/npc/creep))
									var/mob/human/player/npc/creep/C = src
									if(C.ambusher)
										C.loc=null
										spawn(100)
											del(C)
								if(src.guard||src.patrol)
									src.spot=0
									if(src.loc!=locate(src.origx,src.origy,src.origz))
										src.AppearAt(src.origx,src.origy,src.origz)
										src.dir=SOUTH
							while(src.stunned)
								sleep(1)
						if(!src.delay)
							src.delay=1
						sleep(src.delay)

					if(src.newaggro)
						src.aggrohist+=M

	proc
		Approach(var/mob/human/player/M)
			if(M && src)
				if(M.z==src.z)
					src.icon_state="Run"
					var/list/options=new
					options+=get_dir(src,M)
					if(src.x==M.x||src.y==M.y)

						var/turf/Z=get_step(src,turn(get_dir(src,M),45))
						if(Z)
							if(src.Canstep(Z.x,Z.y,Z.z))
								options+=turn(get_dir(src,M),45)
							var/turf/Z2=get_step(src,turn(get_dir(src,M),-45))
							if(Z2)
								if(src.Canstep(Z2.x,Z2.y,Z2.z))
									options+=turn(get_dir(src,M),-45)
					if(length(options))
						step(src,pick(options))

					spawn(2)src.icon_state=""

		Approach2(var/mob/human/player/M)
			if(M && src)
				if(M.z==src.z)
					src.icon_state="Run"

					src.base_StepTowards(M,0,5)

					spawn(2)src.icon_state=""

	proc
		Dodge(var/mob/human/player/M)
			var/list/options=new()
			for(var/turf/x in oview(1,src))
				for(var/turf/X in oview(1,M))
					if(x==X)
						var/turf/ex = locate(X.x,X.y,X.z)
						var/mob/ey=locate(X.x,X.y,X.z)
						var/obj/ez=locate(X.x,X.y,X.z)
						if(!ex.density && !ey.density && !ez.density)
							options+=x
			if(length(options)>=1)
				step_towards(src,pick(options))

		Canstep(dx,dy,dz)
			var/turf/x1=locate(dx,dy,dz)
			var/obj/x2=locate(dx,dy,dz)
			var/mob/x3=locate(dx,dy,dz)
			if(!x1.density && !x2.density && !x3.density)
				return 1
			else
				return 0

		Action_Against(var/mob/human/player/M)
			if(src.npcCanmove())
				usr=src
				src.tired=1

				src.curchakra=src.chakra
				src.AddTarget(M,1)

//				var/whattodo=pick(300;1,50*(src.con/src.str);2,100;3,500*(src.str/src.con);4,100;5)

				var/whattodo=pick(300;1,900*(src.con/src.str);2,100;3,300*(src.str/src.con);4,100;5)

				switch(whattodo)
					if(1)//throw
						if(get_dist(src.loc,M.loc)>3)
							src.supplies=100
							src.usedelay=0
							usr.usev()
						else
							walk_away(src,M,4,1)
							sleep(2)
							walk(src,0)
							src.supplies=100
							src.usedelay=0
							usr.usev()

					if(2)//Use jutsu
						if(M)
							var/list/options = list()
							for(var/skill/sk in skills)
								if(!(sk.id in list(KAWARIMI, SHUNSHIN)))
									options += sk
							if(options.len)
								var/skill/x
								do
									x = pick(options)
									options -= x
								while(options.len && !x.IsUsable(src))
								if(x && x.IsUsable(src))
									x.Activate(src)

					if(5)//kawa set up
						if(src.HasSkill(KAWARIMI))
							src.icon_state="Seal"
							sleep(2)
							src.icon_state=""
							src.AIKawa=src.loc

					if(3)//Shunshin
						if(M&&src&&M.z==src.z && src.HasSkill(SHUNSHIN))
							src.AppearBehind(M)

					if(4)//melee!
						var/list/x = oview(3,src)
//						if(src in M.pet) return
						if(x.Find(M))
							walk_to(src,M,1,1)
							spawn(4)
							x=oview(1,src)
							if(x.Find(M))
								src.rand_attack_ani()
								src.attackv(M)
								sleep(2)
								src.rand_attack_ani()
								src.attackv(M)
								sleep(2)
								src.rand_attack_ani()
								src.attackv(M)
								sleep(3)
								src.icon_state=""
							walk_away(src,M,3,1)
							sleep(3)
							walk(src,0)

mob/var/AIKawa=0

mob/human
	var
		cooldown2=0
		Squad=0

mob/Admin/verb/Ambush_GM()
	var/list/Ambushees=new
	var/num=input("How many to ambush","Ambush") as num
	var/lvl=input("What level?") as num
	for(var/mob/human/player/O in world)
		if(O.client) Ambushees+=O
	Ambushees+="(Below me)"
	Ambushees+="(Nevermind)"
	var/pik = input("Pick somebody to be Ambushed","Ambush") in Ambushees
	if(istype(pik,/mob))
		var/mob/human/player/M = pik
		if(!lvl)lvl=M.blevel
		Ambush(pik,lvl,num)
	else
		if(pik=="(Below me)")
			Ambush(locate(usr.x,usr.y-10,usr.z),lvl,num)

mob/human/player/npc/creep/var/ambusher=0

proc/Ambush(atom/Tgt,lvl,num,notambush)
	var/list/S=new
	var/list/Landing=new
	Landing+=oview(6,Tgt)
	for(var/atom/O in oview(6,Tgt))
		if(O.density && (Landing.Find(O)||Landing.Find(O.loc)))
			if(istype(O,/turf))Landing-=O
			else Landing-=O.loc

	for(var/turf/O in oview(2,Tgt))
		if(Landing.Find(O))Landing-=O //too close

	while(num && length(Landing))
		num--
		var/turf/La=pick(Landing)
		Landing-=La
		var/mob/human/M=new/mob/human/player/npc/creep(locate(0,0,0),lvl)
		spawn(pick(1,3,5))
			if(M && La)
				M.AppearAt(La.x,La.y,La.z)
		S+=M

	for(var/mob/human/player/npc/creep/M in S)
		walk_to(M,Tgt,3,1)
		spawn(3)walk(M,0)
		M.Squad=S
		if(!notambush)M.ambusher=1
		M.mouse_over_pointer='icons/mouse_icons/rockmouse.dmi'
		if(istype(Tgt,/mob))
			spawn()M.Aggro(Tgt)

mob/human/player/npc/creep
	New(loc,lvl)
		..()
		lvl+=pick(-2,-1,0,1,2)
		lvl=max(1,lvl)
		src.name="Rock Shinobi([lvl])"

		src.blevel=lvl
		switch(pick(1,2,3,4))
			if(1)//jutsu user
				int=50+(lvl-1)*4
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*1
			if(2)//tank
				int=50+(lvl-1)*1
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*4
			if(3)//Well rounded
				int=50+round((lvl-1)*2.5)
				rfx=50+round((lvl-1)*2.5)
				con=50+round((lvl-1)*2.5)
				str=50+round((lvl-1)*2.5)
			if(4)//taijutsu user
				int=50+round((lvl-1)*1)
				rfx=50+round((lvl-1)*4)
				con=50+round((lvl-1)*1)
				str=50+round((lvl-1)*4)
		src.stamina=(src.blevel*55 +(src.str)*20)
		src.chakra=(100 + (src.con)*8)
		src.staminaregen=round(src.stamina/100)
		src.chakraregen=round((src.chakra*1.5)/100)
		src.delay=5
		if(src.rfx>150)src.delay=4
		if(src.rfx>200)src.delay=3
		if(src.rfx>250)src.delay=2
		if(src.rfx>350)src.delay=1
		var/points=round(int/40)
		var/list/valid_skills=list(WINDMILL_SHURIKEN,KATON_FIREBALL,LEAF_WHIRLWIND,NIRVANA_FIST,EXPLODING_KUNAI,/*KATON_TAJUU_PHOENIX,*/KATON_PHOENIX_FIRE,DOTON_IRON_SKIN,DOTON_CHAMBER,PARALYZE_GENJUTSU,SUITON_VORTEX,CHIDORI,FUUTON_PRESSURE_DAMAGE,CHIDORI_CURRENT,FUUTON_GREAT_BREAKTHROUGH,SLEEP_GENJUTSU,FUUTON_AIR_BULLET/*,SUITON_SYRUP_FIELD*/,LION_COMBO,IMPORTANT_BODY_PTS_DISTURB,POISON_MIST,TWIN_RISING_DRAGONS)
		while(points && valid_skills.len)
			points--
			var/newskill = pick(valid_skills)
			valid_skills -= newskill
			skillsx+=newskill

	nisguard=0
	hostile=1
	name="Rock Shinobi"
	locationdisc="Hidden Rock"
	wander=1
	questable=0
	blevel=30
	delay=5

	dietype=3//0=KO,no death 1=delayed respawn 2=death till repop 3=expgain
	str=100
	guard=0
	interact
	con=100
	rfx=100
	int=100
	stamina=4000
	chakra=700
	pants=/obj/pants/black
	undershirt=/obj/fishnet
	overshirt
	armor=/obj/plate/body/brown
	facearmor = /obj/headband/black
	hair_type=99
	hair_color="#000000"
	killable=1
	projectiles=2
	message ="..."

	skillsx=list(KAWARIMI,SHUNSHIN,BUNSHIN)

mob/human/proc
	rand_attack_ani()
		var/ans=pick(1,2,3,4)
		if(ans==1)
			src.icon_state="PunchA-1"

		if(ans==2)
			src.icon_state="PunchA-2"
		if(ans==3)
			src.icon_state="KickA-1"
		if(ans==4)
			src.icon_state="KickA-2"

var/npcdelay=3

mob/human/player/npc
	proc
		npcregeneration()
			set background = 1
			if(!EN[5])
				return
			if(src.protected)
				src.protected-=1*npcdelay

			if(src.alertcool)
				src.alertcool-=1*npcdelay
				if(src.alertcool<0)
					src.alertcool=0

			spawn(10*npcdelay)
				if(!src.aggro)
					src.curwound--
					if(src.curwound<0)
						src.curwound=0

				if(src.asleep)
					src.icon_state="Dead"
					sleep(100)
					src.asleep=0
					src.icon_state=""

				//ko stuff
				if(src.curwound>=200)
					src.curstamina=0

				if(src.curstamina<=0)
					src.Wound(rand(32,37),1)
					src.ko=1
					sleep(10)
					flick("Knockout",src)
					src.icon_state="Dead"
					src.layer=TURF_LAYER+1
					if(src.curwound<32)
						sleep(src.curwound +100)
						src.curstamina=src.stamina * ((maxwound-curwound)/maxwound)
						if(src.curchakra<src.chakra/5)
							src.curchakra=src.chakra/5 +20
						src.protected=3
						src.stunned=0
						src.ko=0
						src.icon_state=""

					else
						src.npcDie()

				if(src.ko)
					if(src.curstamina>0)
						src.ko=0
						src.icon_state=""

				//end ko stuff
				if(src.layer!=MOB_LAYER && !src.ko &&!src.incombo)
					src.layer=MOB_LAYER

				if(src.chakrablocked>0)
					src.chakraregen=0
					src.chakrablocked-=1*npcdelay
					if(src.chakrablocked<0)src.chakrablocked=0

				if(maned)
					if(stunned<3)
						stunned=2

				if(curwound<maxwound&&!mane&&!maned &&!waterlogged)
					if(curchakra<chakra)
						if(chakraregen > (chakra-curchakra))
							curchakra= chakra
						else
							curchakra +=chakraregen*npcdelay

					else
						if(curstamina<stamina)
							if((staminaregen) > (stamina-curstamina))
								curstamina=stamina
							else
								curstamina+=staminaregen*npcdelay

				if(!dead)
					spawn()npcregeneration()
