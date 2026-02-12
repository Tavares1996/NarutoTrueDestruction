mob/var/tobirama=0
skill
	forbidden
		copyable = 0

		hashirama_summon
			id = HASHIRAMA_SUMMON
			name = "Edo Tensai: Hashirama"
			icon_state = "senju_summon"
			default_chakra_cost = 1000
			default_cooldown = 240
			default_seal_time = 15

			Use(mob/user)
				viewers(user) << output("[user]:<font colour=#6E6A6B> Impure World Resurrection!", "combat_output")
				if(!user) return
				var/obj/x = new/obj(locate(user.x+1,user.y,user.z))
				x.layer = MOB_LAYER+1
				x.icon = 'icons/edo_tensai.dmi'
				flick("coffin",x)
				x.icon_state = "alive(senju)"
				sleep(35)
				var/mob/human/player/npc/o = new/mob/human/player/npc(locate(x.x,x.y-1,x.z))
				del(x)

				spawn()
					o.icon = 'icons/hokage.dmi'
					o.name = "Hashirama Senju"
					o.faction = user.faction
					o.mouse_over_pointer=faction_mouse[o.faction.mouse_icon]
					o.stamina = 20000
					o.chakra = 5000
					o.curstamina = 20000
					o.curchakra = 5000
					o.str += 750
					o.rfx += 550
					o.int += 250
					o.con += 750
					o.blevel = 150
					user.pet += o
					o.ownerkey=user.key
					o.owner = user
					o.senjublood = 1
					o.supplies = 1000
					o.killable=1
					o.clan = "Capacity"
					//Skills
					o.skillsx=list(KAWARIMI,SHUNSHIN,WINDMILL_SHURIKEN,WOOD_JUTSU,FOUR_PILLAR_PRISON_JUTSU,VINE_CAMP,DOTON_CHAMBER,DOTON_CHAMBER_CRUSH,DOTON_EARTH_FLOW,SUITON_VORTEX,SUTION_SHOCKWAVE,DOTON_EARTH_SHAKING_PALM,DOTON_EARTH_DRAGON)

					spawn(2100)
						if(user && o)
							user << "Your Summoning is gone."
							del(o)

		tobirama_summon
			id = TOBIRAMA_SUMMON
			name = "Edo Tensai: Tobirama"
			icon_state = "tobirama_summon"
			default_chakra_cost = 1000
			default_cooldown = 240
			default_seal_time = 15

			Use(mob/user)
				viewers(user) << output("[user]:<font colour=#6E6A6B> Impure World Resurrection!", "combat_output")
				if(!user) return
				var/obj/x = new/obj(locate(user.x+1,user.y,user.z))
				x.layer = MOB_LAYER+1
				x.icon = 'icons/edo_tensai.dmi'
				flick("coffin",x)
				x.icon_state = "alive(tobirama)"
				sleep(35)
				var/mob/human/player/npc/o = new/mob/human/player/npc(locate(x.x,x.y-1,x.z))
				del(x)

				spawn()
					o.icon = 'icons/hokage2.dmi'
					o.name = "Tobirama Senju"
					o.faction = user.faction
					o.mouse_over_pointer=faction_mouse[o.faction.mouse_icon]
					o.stamina = 15000
					o.chakra = 5000
					o.curstamina = 15000
					o.curchakra = 5000
					o.str += 650
					o.rfx += 600
					o.int += 350
					o.con += 650
					o.blevel = 150
					user.pet += o
					o.tobirama = 1
					o.killable=1
					o.ownerkey=user.key
					o.owner = user
					o.supplies = 1000
					o.clan = "Capacity"
					//Skills
					o.skillsx=list(KAWARIMI,SHUNSHIN,WINDMILL_SHURIKEN,SUITON_VORTEX,SUTION_SHOCKWAVE,SUITON_GUNSHOT,DOTON_CHAMBER,DOTON_CHAMBER_CRUSH,DOTON_EARTH_FLOW,SUITON_DRAGON,SUITON_SHARK_GUN,SUITON_SHARK,SUITON_COLLISION_DESTRUCTION,SUITON_PRISON,DOTON_EARTH_SHAKING_PALM,DOTON_EARTH_DRAGON,SUITON_CLONE)

					spawn(2100)
						if(user && o)
							user << "Your Summoning is gone."
							del(o)

//Jutsu for Hashirama :)

mob/var
	trees = 0
	vinecamp = 0
	fourpillar = 0

skill
	wood
		copyable=0
		four_pillar_prison_jutsu
			id = FOUR_PILLAR_PRISON_JUTSU
			name = "Wood Release: Four Pillar Prison Jutsu"
			icon_state = "fourpillars"
			default_chakra_cost = 150
			default_cooldown = 60

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.fourpillar)
						Error(user, "Wait for cooldown [user]....")
						return 0
					if(!user.MainTarget())
						Error(user, "You need a target to use this jutsu")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Wood Release: Four Pillar Prison Jutsu!", "combat_output")
				user.stunned=3
				user.icon_state="Seal"
				spawn(18) user.icon_state=""
				var/mob/human/player/T = usr.NearestTarget()

				var/obj/A = new/obj/Fourpillar(locate(T.x,T.y,T.z))
				sleep(3)
				T.stunned=2
				var/obj/B = new/obj/Fourpillar(locate(T.x+1,T.y,T.z))
				sleep(3)
				T.stunned=2
				var/obj/C = new/obj/Fourpillar(locate(T.x,T.y+1,T.z))
				sleep(3)
				T.stunned=2
				var/obj/D = new/obj/Fourpillar(locate(T.x+1,T.y+1,T.z))
				sleep(3)
				T.stunned=2
				var/obj/E = new/obj/Fourpillar(locate(T.x,T.y,T.z))
				sleep(3)
				T.stunned=2
				var/obj/F = new/obj/Fourpillar(locate(T.x-1,T.y,T.z))
				sleep(3)
				T.stunned=2
				var/obj/G = new/obj/Fourpillar(locate(T.x,T.y-1,T.z))
				sleep(3)
				T.stunned=2
				var/obj/H = new/obj/Fourpillar(locate(T.x-1,T.y-1,T.z))
				sleep(3)
				T.stunned=10
				user.pet += A
				user.pet += B
				user.pet += C
				user.pet += D
				user.pet += E
				user.pet += F
				user.pet += G
				user.pet += H
				if(user.ko)
					for(var/obj/Fourpillar/R in user.pet)
						del(R)
				spawn(120)
					if(user && T)
						T.stunned = 0
						for(var/obj/Fourpillar/J in user.pet)
							del(J)
		vine_encampment_jutsu
			id = VINE_CAMP
			name = "Wood Release: Vine Encampment Jutsu"
			icon_state = "vinecamp"
			default_chakra_cost = 100
			default_cooldown = 65

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.vinecamp)
						Error(user, "Wait for cooldown [user]....")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]:Wood Release: Vine Encampment Jutsu!", "combat_output")
				var/conmult = user.ControlDamageMultiplier()
				user.stunned=3
				var/mob/human/player/T = usr.NearestTarget()
				user.icon_state="Seal"
				if(T)
					var/obj/S=new/obj/Vine_Encampment(locate(T.x,T.y,T.z))
					T.stunned = 30
					T.Dec_Stam((100 + 300*conmult),0,user)
					user.icon_state=""
					spawn(150)
						if(user && T)
							T.stunned=0
							user.stunned=0
							del(S)
				else
					for(var/mob/human/player/target in oview(3))
						var/obj/V=new/obj/Vine_Encampment(locate(target.x,target.y,target.z))
						target.stunned=30
						target.Dec_Stam((100 + 300*conmult),0,user)
						user.icon_state=""
						spawn(150)
							if(user && target)
								target.stunned=0
								user.stunned=0
								del(V)

		nativity_of_a_world_of_trees
			id = WORLD_TREES
			name = "Wood Release: Nativity of a World of Trees"
			icon_state = "worldtrees"
			default_chakra_cost = 1100
			default_cooldown = 150

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.trees)
						Error(user, "Wait for cooldown [user]....")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Wood Release: Nativity of a World of Trees!", "combat_output")
				user.trees=1
				for(var/mob/human/player/M in oview(20))
					if(M && user && !M.ko && !istype(M,/mob/corpse))
						var/obj/a=new/obj/Senjutree(locate(M.x,M.y,M.z))
						var/obj/b=new/obj/Senjutree(locate(M.x+1,M.y,M.z))
						var/obj/c=new/obj/Senjutree(locate(M.x,M.y+1,M.z))
						var/obj/d=new/obj/Senjutree(locate(M.x+1,M.y+1,M.z))
						var/obj/e=new/obj/Senjutree(locate(M.x-1,M.y,M.z))
						var/obj/f=new/obj/Senjutree(locate(M.x,M.y-1,M.z))
						var/obj/g=new/obj/Senjutree(locate(M.x-1,M.y-1,M.z))
						user.pet+=a
						user.pet+=b
						user.pet+=c
						user.pet+=d
						user.pet+=e
						user.pet+=f
						user.pet+=g
						usr.curchakra-=200
						M.Dec_Stam(rand(50,100))
						M.shun = 0
						M.stunned += 25
						spawn(250)
							if(user)
								user.trees=0
								for(var/obj/Senjutree/x in user.pet)
									del(x)


		wood_jutsu
			id = WOOD_JUTSU
			name = "Wood Release: Rising Pillar"
			icon_state = "wood_jutsu"
			default_chakra_cost = 300
			default_cooldown = 40
			default_seal_time = 5

			Use(mob/human/user)
				var/mob/human/player/etarget = user.NearestTarget()
				var/conmult = user.ControlDamageMultiplier()
				if(!user.icon_state)
					user.icon_state="Seal"
					spawn(10) user.icon_state=""
				user.stunned=10
				if(etarget)
					new/obj/wood_jutsu(locate(etarget.x,etarget.y,etarget.z))
					etarget.Dec_Stam((rand(50,100)*conmult),0,user)
				else
					if(user.dir==NORTH)
						new/obj/wood_jutsu(locate(user.x,user.y+2,user.z))
					if(user.dir==SOUTH)
						new/obj/wood_jutsu(locate(user.x,user.y-2,user.z))
					if(user.dir==WEST)
						new/obj/wood_jutsu(locate(user.x-2,user.y,user.z))
					if(user.dir==EAST)
						new/obj/wood_jutsu(locate(user.x+2,user.y,user.z))


obj
	Senjutree
		icon='icons/Senjutree.dmi'
		density=1
		layer=TURF_LAYER+2
		New()
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "5",pixel_x=0,pixel_y=32)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "6",pixel_x=32,pixel_y=32)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "7",pixel_x=-32,pixel_y=64)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "8",pixel_x=0,pixel_y=64)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "9",pixel_x=32,pixel_y=64)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "10",pixel_x=-32,pixel_y=96)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "11",pixel_x=0,pixel_y=96)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "12",pixel_x=32,pixel_y=96)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "13",pixel_x=-32,pixel_y=128)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "14",pixel_x=0,pixel_y=128)
			src.overlays+=image('icons/Senjutree.dmi',icon_state = "15",pixel_x=32,pixel_y=128)
			..()
			spawn(800)
				if(src)
					del(src)
	Fourpillar
		icon='icons/fourpillar.dmi'
		density=1
		layer=9999999
		opacity=1
		New()
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "1",pixel_x=-64,pixel_y=0)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "2",pixel_x=-32,pixel_y=0)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "3",pixel_x=0,pixel_y=0)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "4",pixel_x=32,pixel_y=0)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "5",pixel_x=64,pixel_y=0)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "6",pixel_x=-64,pixel_y=32)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "7",pixel_x=-32,pixel_y=32)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "8",pixel_x=0,pixel_y=32)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "9",pixel_x=32,pixel_y=32)
			src.overlays+=image('icons/fourpillar.dmi',icon_state = "10",pixel_x=64,pixel_y=32)
			..()
			spawn(800)
				if(src)
					del(src)
	Vine_Encampment
		icon='icons/Vinecamp.dmi'
		density=1
		layer=9999999
		opacity=1
		New()
			src.overlays+=image('icons/Vinecamp.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
			src.overlays+=image('icons/Vinecamp.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
			src.overlays+=image('icons/Vinecamp.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
			src.overlays+=image('icons/Vinecamp.dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
			src.overlays+=image('icons/Vinecamp.dmi',icon_state = "5",pixel_x=0,pixel_y=32)
			src.overlays+=image('icons/Vinecamp.dmi',icon_state = "6",pixel_x=32,pixel_y=32)
			..()
			spawn(800)
				if(src)
					del(src)
	wood_jutsu
		icon = 'icons/wood_jutsu.dmi'
		density = 1
		layer = MOB_LAYER + 1
		New()
			..()
			spawn(20)
				if(src)
					del(src)