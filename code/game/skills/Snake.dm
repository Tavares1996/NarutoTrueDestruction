skill
	snake
		copyable = 0

		Rashoumon
			id = RASHOUMON
			name = "Summoning: Rashoumon"
			icon_state = "rashomon"
			default_chakra_cost = 500
			default_cooldown = 25
			default_seal_time = 5

			Use(mob/human/user)
				viewers(user) << output("[user]: Rashoumon!", "combat_output")

				for(var/mob/human/player/x in oview(10))
					if(x!=user)
						x.stunned=2

				var/obj/X = new/obj/blank(locate(user.x,user.y,user.z))
				var/obj/R = new/obj/Rashoumon(locate(X.x,X.y,X.z))
				del(X)

				if(user)
					user.protected=100
					spawn(50) if(user) user.protected=0

				spawn(100)
					if(R in world)
						del(R)

		snake_ambush
			id = SNAKE_AMBUSH
			name = "Snake: Serpent Ambush"
			icon_state = "snake_ambush"
			default_chakra_cost = 500
			default_cooldown = 170
			default_seal_time = 7

			Use(mob/human/user)
				user.stunned=1
				viewers(user) << output("[user]: Snake: Serpent Ambush!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					user.icon_state="Seal"
					spawn(10)
						user.icon_state=""
						user.stunned=0
					var/turf/L=etarget.loc
					sleep(5)
					var/hit=0
					if(L && L==etarget.loc)
						hit=1
						etarget.stunned=3
						user.stunned=0

					var/obj/O =new(locate(L.x,L.y,L.z))
					O.layer=MOB_LAYER+3
					O.overlays+=image('icons/oro_snake_attack.dmi',pixel_x=0,pixel_y=0)
					var/found=0

					for(var/obj/Water/X in oview(4,user))
						found++
						break
					if(found>10)found=10
					if(hit && etarget)
						etarget.Dec_Stam((1400 + 400*conmult + found*50),0,user)
						spawn()etarget.Hostile(user)
					sleep(50)
					if(etarget)etarget.stunned=0

					if(O)del(O)

		snake_bind
			id = SNAKE_BIND
			name = "Snake: Shadow Snake Bind"
			icon_state = "snake_wrap"
			default_chakra_cost = 200
			default_cooldown = 150
			default_seal_time = 6


			IsUsable(mob/user)
				. = ..()
				if(.)
					var/mob/human/player/etarget = user.MainTarget()
					if(!etarget)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, etarget)
					if(distance > 10)
						Error(user, "Target too far ([distance]/10 tiles)")
						return 0

			Use(mob/human/user)
				var/mob/human/player/etarget = user.MainTarget()
				user.stunned=0
				viewers(user) << output("[user]: Snake: Shadow Snake Bind!", "combat_output")
				etarget.overlays+='icons/snakebind.dmi'
				etarget.stunned=5
				spawn(50)
					if(!etarget) return
					Blood2(etarget)
					etarget.overlays-='icons/snakebind.dmi'
					etarget.stunned=0
					etarget.curwound+=5
					etarget.move_stun+=2

		snake_hands
			id = SNAKE_HANDS
			name = "Snake: Hidden Shadow Snake Hands"
			icon_state = "snake_hands"
			default_chakra_cost = 50
			default_cooldown = 50

			Use(mob/human/user)

				viewers(user) << output("[user]: Snake: Hidden Shadow Snake Hands!", "combat_output")
				spawn()
					var/eicon='icons/snakehands.dmi'
					var/estate=""
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/player/etarget = user.NearestTarget()

					if(!etarget)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()Poof(etarget)
							spawn()AOE(ex,ey,ez,1,(1000 + 50*conmult),20,user,3,.3)
							spawn()Blood2(etarget)
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))

						projectile_to(eicon,estate,user,x)
						del(x)
						spawn()Poof(etarget)
						spawn()AOE(ex,ey,ez,1,(1000 +50*conmult),20,user,3,.3)
						spawn()Blood2(etarget)
					user.icon_state=""

		many_snake_hands
			id = MANY_SNAKE_HANDS
			name = "Snake: Many Hidden Shadow Snake Hands"
			icon_state = "snake_hands2"
			default_chakra_cost = 300
			default_cooldown = 120
			default_seal_time = 4

			Use(mob/human/user)

				viewers(user) << output("[user]: Snake: Many Hidden Shadow Snake Hands!", "combat_output")

				spawn()
					var/eicon='icons/snakehands.dmi'
					var/estate=""
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/player/etarget = user.NearestTarget()

					var/numOfHosenkas = 5

					for (var/i = 0; i < numOfHosenkas; i++)
						if(!etarget)
							etarget=straight_proj2(eicon,estate,8,user)
							if(etarget)
								Poof()
						else
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							var/mob/x=new/mob(locate(ex,ey,ez))

							projectile_to(eicon,estate,user,x)
							del(x)
							spawn()Poof(etarget)
							spawn()AOE(ex,ey,ez,1,(1000 + 60*conmult),20,user,3,.3)
							spawn()Blood2(etarget)


		skin_shedding
			id = SKIN_SHEDDING
			name = "Snake: Skin Shedding"
			icon_state = "skin_shed"
			default_chakra_cost = 2000
			default_cooldown = 400
			default_seal_time = 25

			Use(mob/human/user)
				viewers(user) << output("[user]: Snake: Skin Shedding!", "combat_output")
				Poof(user.x, user.y, user.z)
				new/mob/skin(user.loc,user)
				user.curwound-=rand(10,40)
				if(user.curwound<0)
					user.curwound=0

		skin_wear
			id = SKIN_WEAR
			name = "Snake: Skin Pick Up"
			icon_state = "skin_wear"
			default_chakra_cost = 1000
			default_cooldown = 150
			default_seal_time = 10

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.carrying.len)
						Error(user, "You have to be carrying a discarded skin or corpse to use this jutsu")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Snake: Skin Pick Up!", "combat_output")

				var/mob/human/player/etarget = user.MainTarget()

				if(user.carrying.len)
					etarget = user.carrying.len
					Poof(user.x, user.y, user.z)
					new/mob/corpse(user.loc,user)

					user.icon = etarget.icon
					user.name = etarget.skinowner

					user.CreateName(255, 255, 255)

					user.overlays= etarget.overlays
					user.mouse_over_pointer = etarget.mouse_over_pointer

mob/skin
	layer=MOB_LAYER-0.1
	density=0
	var/carryingme=0
	New(loc,mob/M)
		for(var/skill/O in M.skills)
			src.AddSkill(O.id)
		src.loc=loc
		src.icon=M.icon
		src.overlays+=M.overlays
		src.name="[M.name]'s Skin"
		src.skinowner="[M.name]"
		src.icon_state="Dead"
		src.dir=M.dir
		src.blevel=M.blevel
		if(RP)
			M.invisibility=100
			M.density=0
			M.stunned=9999999
		spawn(200)
			src.loc=null

	Click()

		if(carryingme)
			var/mob/human/X = carryingme
			X.carrying-=src
			carryingme=0

		else
			usr.carrying+=src
			carryingme=usr
			usr<<"You start carrying [src]"

obj/Rashoumon
	icon='icons/Rashoumon2.dmi'
	density=1
	layer=999
	New()
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "1",pixel_x=-96,pixel_y=0)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "2",pixel_x=-64,pixel_y=0)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "3",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "4",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "5",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "6",pixel_x=64,pixel_y=0)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "7",pixel_x=96,pixel_y=0)

		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "8",pixel_x=-96,pixel_y=32)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "9",pixel_x=-64,pixel_y=32)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "10",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "12",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "13",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "14",pixel_x=64,pixel_y=32)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "15",pixel_x=96,pixel_y=32)

		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "16",pixel_x=-96,pixel_y=64)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "17",pixel_x=-64,pixel_y=64)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "18",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "19",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "20",pixel_x=32,pixel_y=64)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "21",pixel_x=64,pixel_y=64)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "22",pixel_x=96,pixel_y=64)

		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "23",pixel_x=-64,pixel_y=96)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "24",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "25",pixel_x=0,pixel_y=96)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "26",pixel_x=32,pixel_y=96)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "27",pixel_x=64,pixel_y=96)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "28",pixel_x=96,pixel_y=96)

		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "29",pixel_x=-64,pixel_y=128)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "30",pixel_x=-32,pixel_y=128)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "31",pixel_x=0,pixel_y=128)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "32",pixel_x=32,pixel_y=128)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "33",pixel_x=64,pixel_y=128)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "34",pixel_x=96,pixel_y=128)

		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "35",pixel_x=-96,pixel_y=160)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "36",pixel_x=-64,pixel_y=160)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "37",pixel_x=-32,pixel_y=160)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "38",pixel_x=0,pixel_y=160)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "39",pixel_x=32,pixel_y=160)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "40",pixel_x=64,pixel_y=160)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "41",pixel_x=96,pixel_y=160)

		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "42",pixel_x=-64,pixel_y=192)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "43",pixel_x=-32,pixel_y=192)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "44",pixel_x=0,pixel_y=192)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "45",pixel_x=32,pixel_y=192)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "46",pixel_x=64,pixel_y=192)
		src.overlays+=image('icons/Rashoumon2.dmi',icon_state = "47",pixel_x=96,pixel_y=192)
		..()
		spawn(110)
			if(src)
				del(src)