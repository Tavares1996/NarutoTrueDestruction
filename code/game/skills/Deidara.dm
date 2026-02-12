mob/var
	ridingbird = 0
	c4 = 0
var/list
	infectedby = list()

skill
	deidara
		copyable = 0

		exploding_bird
			id = EXPLODING_BIRD
			name = "Artistic: Exploding Bird"
			icon_state = "exploading bird"
			default_chakra_cost = 250
			default_cooldown = 15

			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 10)
						Error(user, "Target too far ([distance]/10 tiles)")
						return 0

			Use(mob/human/user)
				flick("Throw1",user)
				var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/clay/bird/B=new/mob/human/clay/bird(locate(user.x,user.y,user.z),rand(600,(500+430*conmult)),user)
					spawn(1)Poof(B.x,B.y,B.z)
					spawn(3)Homing_Projectile_bang(user,B,8,etarget,1)
					spawn(50)
						if(B)
							B.Explode()

		exploding_barrage
			id = EXPLODING_BARRAGE
			name = "Artistic: Exploding Barrage"
			icon_state="small bird"
			default_chakra_cost = 800
			default_cooldown = 150

			Use(mob/human/user)
				for(var/time = 5 to 10)
					var/obj/O = new
					usr.stunned = 0.1
					O.icon = 'icons/clay-animals.dmi'
					O.icon_state="smallbird"
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
						var/tiles = 5
						while(usr && tiles > 0 && O.loc != null)
							tiles--
							var/old_loc = O.loc
							for(var/mob/m in view(0,O))
								tiles = 0
								m.Dec_Stam(rand(50,200)+150*usr:ControlDamageMultiplier(),0,usr)
								m.Wound(rand(1,5),0,usr)
								Blood2(m)
							if(tiles == 0)
								continue
							step(O,O.dir)
							if(O.loc == old_loc)
								tiles = 0
								continue
							sleep(1.25)
						explosion(rand(50,200)+150*usr:ControlDamageMultiplier(),O.x,O.y,O.z,usr,dist = 3)
						O.loc = null


		exploding_owl
			id = EXPLODING_OWL
			name = "Artistic: Exploding Owl"
			icon_state = "clay owl"
			default_chakra_cost = 400
			default_cooldown = 90

			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 20)
						Error(user, "Target too far ([distance]/20 tiles)")
						return 0

			Use(mob/human/user)
				flick("Throw1",user)
				var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/clay/owl/B=new/mob/human/clay/owl(locate(user.x,user.y,user.z),rand(300, 2000) + (300*conmult),user)
					spawn(1)
						if(B)
							Poof(B.x,B.y,B.z)
					spawn(3)
						if(B)
							Homing_Projectile_bang(user,B,8,etarget,1)
					spawn(50)
						if(B)
							B.Explode()



		exploding_spider
			id = EXPLODING_SPIDER
			name = "Artistic: Exploding Spider"
			icon_state = "exploading spider"
			default_chakra_cost = 300
			default_cooldown = 30



			Use(mob/human/user)
				flick("Throw1",user)
				user.combat("<b>Drag</b> spiders to move them. Press <b>z</b>, <b>click</b> the spider icon on the left side of your screen, or <b>double-click</b> the spider to detonate it.")
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/clay/spider/B=new/mob/human/clay/spider(user.loc,rand(2000,(1500+750*conmult)),user)
				var/obj/trigger/exploding_spider/T = new(user, B)
				user.AddTrigger(T)
				spawn(1) if(B) Poof(B.x,B.y,B.z)




		clay_kawa
			id = CLAY_KAWA
			name = "Artistic: Clay Replacement"
			icon_state = "clay kawa"
			default_chakra_cost = 100
			default_cooldown = 60

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(capture_the_flag && capture_the_flag.HasFlag(user))
						Error(user, "You can't use this jutsu while holding the flag.")
						return 0

			Use(mob/user)
				user.combat("If you press <b>z</b> or <b>click</b> the clay icon on the left side of your screen within the next 3 minutes, you will be teleported back to this location and leave a clay replacement behind.")

				var/obj/trigger/clay_kawa/T = new/obj/trigger/clay_kawa(user, user.x, user.y, user.z)
				user.AddTrigger(T)

				spawn(1800)
					if(user) user.RemoveTrigger(T)


		C2
			id = C2
			name = "Artistic: C2"
			icon_state = "c2"
			default_chakra_cost = 1300
			default_cooldown = 320

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.ridingbird)
						Error(user, "Your are using this already...")
						return 0

			Use(mob/human/user)
				user.combat("Press <b>A<b> or the <b>Attack</b> macro to fire clay animals, beware you will use up your chakra")
				var/mob/human/player/npc/kage_bunshin/x
				if(x) return
				user.ridingbird = 1
				user.icon_state="Seal"

				user.underlays+=image('icons/claybird.dmi',icon_state = "1",pixel_x=-96,pixel_y=-32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "2",pixel_x=-64,pixel_y=-32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "3",pixel_x=-32,pixel_y=-32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "4",pixel_x=0,pixel_y=-32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "5",pixel_x=32,pixel_y=-32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "6",pixel_x=64,pixel_y=-32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "7",pixel_x=96,pixel_y=-32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "8",pixel_x=-96,pixel_y=0)
				user.underlays+=image('icons/claybird.dmi',icon_state = "9",pixel_x=-64,pixel_y=0)
				user.underlays+=image('icons/claybird.dmi',icon_state = "10",pixel_x=-32,pixel_y=0)
				user.underlays+=image('icons/claybird.dmi',icon_state = "11",pixel_x=0,pixel_y=0)
				user.underlays+=image('icons/claybird.dmi',icon_state = "12",pixel_x=32,pixel_y=0)
				user.underlays+=image('icons/claybird.dmi',icon_state = "13",pixel_x=64,pixel_y=0)
				user.underlays+=image('icons/claybird.dmi',icon_state = "14",pixel_x=96,pixel_y=0)
				user.underlays+=image('icons/claybird.dmi',icon_state = "15",pixel_x=-96,pixel_y=32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "16",pixel_x=-64,pixel_y=32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "17",pixel_x=-32,pixel_y=32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "18",pixel_x=0,pixel_y=32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "19",pixel_x=32,pixel_y=32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "20",pixel_x=64,pixel_y=32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "21",pixel_x=96,pixel_y=32)
				user.underlays+=image('icons/claybird.dmi',icon_state = "22",pixel_x=-96,pixel_y=64)
				user.underlays+=image('icons/claybird.dmi',icon_state = "23",pixel_x=-64,pixel_y=64)
				user.underlays+=image('icons/claybird.dmi',icon_state = "24",pixel_x=-32,pixel_y=64)
				user.underlays+=image('icons/claybird.dmi',icon_state = "25",pixel_x=0,pixel_y=64)
				user.underlays+=image('icons/claybird.dmi',icon_state = "26",pixel_x=32,pixel_y=64)
				user.underlays+=image('icons/claybird.dmi',icon_state = "27",pixel_x=64,pixel_y=64)
				user.underlays+=image('icons/claybird.dmi',icon_state = "28",pixel_x=96,pixel_y=64)
				spawn(350)
					user.ridingbird = 0
					user.icon_state=""
					user.underlays-=image('icons/claybird.dmi',icon_state = "1",pixel_x=-96,pixel_y=-32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "2",pixel_x=-64,pixel_y=-32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "3",pixel_x=-32,pixel_y=-32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "4",pixel_x=0,pixel_y=-32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "5",pixel_x=32,pixel_y=-32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "6",pixel_x=64,pixel_y=-32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "7",pixel_x=96,pixel_y=-32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "8",pixel_x=-96,pixel_y=0)
					user.underlays-=image('icons/claybird.dmi',icon_state = "9",pixel_x=-64,pixel_y=0)
					user.underlays-=image('icons/claybird.dmi',icon_state = "10",pixel_x=-32,pixel_y=0)
					user.underlays-=image('icons/claybird.dmi',icon_state = "11",pixel_x=0,pixel_y=0)
					user.underlays-=image('icons/claybird.dmi',icon_state = "12",pixel_x=32,pixel_y=0)
					user.underlays-=image('icons/claybird.dmi',icon_state = "13",pixel_x=64,pixel_y=0)
					user.underlays-=image('icons/claybird.dmi',icon_state = "14",pixel_x=96,pixel_y=0)
					user.underlays-=image('icons/claybird.dmi',icon_state = "15",pixel_x=-96,pixel_y=32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "16",pixel_x=-64,pixel_y=32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "17",pixel_x=-32,pixel_y=32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "18",pixel_x=0,pixel_y=32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "19",pixel_x=32,pixel_y=32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "20",pixel_x=64,pixel_y=32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "21",pixel_x=96,pixel_y=32)
					user.underlays-=image('icons/claybird.dmi',icon_state = "22",pixel_x=-96,pixel_y=64)
					user.underlays-=image('icons/claybird.dmi',icon_state = "23",pixel_x=-64,pixel_y=64)
					user.underlays-=image('icons/claybird.dmi',icon_state = "24",pixel_x=-32,pixel_y=64)
					user.underlays-=image('icons/claybird.dmi',icon_state = "25",pixel_x=0,pixel_y=64)
					user.underlays-=image('icons/claybird.dmi',icon_state = "26",pixel_x=32,pixel_y=64)
					user.underlays-=image('icons/claybird.dmi',icon_state = "27",pixel_x=64,pixel_y=64)
					user.underlays-=image('icons/claybird.dmi',icon_state = "28",pixel_x=96,pixel_y=64)


		c3
			id = C3
			name = "Artistic: C3"
			icon_state = "c3"
			default_chakra_cost = 800
			default_cooldown = 160
			var/used_chakra



			ChakraCost(mob/user)
				used_chakra = user.curchakra
				if(used_chakra > default_chakra_cost)
					return used_chakra
				else
					return default_chakra_cost


			Use(mob/human/user)
				var/p
				user.usemove=1

				user.stunned+=10
				user.icon_state="Seal"
				sleep(15)
				user.icon_state=""
				user.stunned=0
				if(user.usemove)
					p=used_chakra
					flick("Throw1",user)
					var/obj/C3 = new/obj(locate(user.x,user.y,user.z))
					C3.icon='icons/C3.dmi'
					C3.layer=MOB_LAYER+2.1
					sleep(2)
					step(C3,user.dir)
					sleep(2)
					step(C3,user.dir)
					spawn()Poof(C3.x,C3.y,C3.z)
					C3.icon=null
					C3.overlays+=image('icons/C3_tl.dmi',pixel_x=-16,pixel_y=32)
					C3.overlays+=image('icons/C3_tr.dmi',pixel_x=16,pixel_y=32)
					C3.overlays+=image('icons/C3_bl.dmi',pixel_x=-16)
					C3.overlays+=image('icons/C3_br.dmi',pixel_x=16)
					var/P=p*5 + 3250*user.ControlDamageMultiplier() + rand(200,1000)
					C3.power=P
					var/obj/trigger/C3/T = new(usr, C3)

					user.combat("The C3 will automatically detonate after flashing. If you wish to detonate it faster, press <b>z</b> or <b>click</b> the C3 icon on the left side of your screen,")
					user.AddTrigger(T)
					var/bw=5
					while(bw>0 && C3)
						switch(bw)
							if(5)
								spawn(12)flick("blink",C3)
							if(4)
								spawn(5)flick("blink",C3)
								spawn(16)flick("blink",C3)
							if(3)
								spawn()flick("blink",C3)
								spawn(10)flick("blink",C3)
							if(2)
								spawn()flick("blink",C3)
								spawn(5)flick("blink",C3)
								spawn(10)flick("blink",C3)
							if(1)
								spawn(0)flick("blink",C3)
								spawn(2)flick("blink",C3)
								spawn(3)flick("blink",C3)
								spawn(5)flick("blink",C3)

						sleep(bw*5)
						bw--
					if(user)
						user.RemoveTrigger(T)
					if(C3)
						C3.overlays=0
						spawn()
							if(C3 && user) explosion(P,C3.x,C3.y,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x+1,C3.y+1,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x-1,C3.y+1,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x-1,C3.y-1,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x-1,C3.y-1,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x-2,C3.y+2,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x+2,C3.y-2,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x+2,C3.y+2,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x-2,C3.y-2,C3.z,user,0,6)
						spawn(6)
							del(C3)

		c4
			id = C4
			name = "Artistic: C4"
			icon_state = "c4"
			default_chakra_cost = 2000
			default_cooldown = 600
			var/used_chakra

			ChakraCost(mob/user)
				used_chakra = user.curchakra
				if(used_chakra > default_chakra_cost)
					return used_chakra
				else
					return default_chakra_cost

			Use(mob/human/user)
				var/mob/human/player/npc/kage_bunshin/f
				if(f) return
				user.c4 = 1
				user.stunned=10
				user.combat("Press the <b>Space</b> bar to activate explosions on any infected enemies")
				var/obj/blank/H=new/obj/blank(locate(user.x,user.y,user.z))
				if(user.icon_name=="base_m"||user.icon_name=="base_m1"||user.icon =='icons/base_m1.dmi')
					user.overlays+=image('icons/c41.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays+=image('icons/c41.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays+=image('icons/c41.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays+=image('icons/c41.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays+=image('icons/c41.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays+=image('icons/c41.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
				else if(user.icon_name=="base_m2"||user.icon == 'icons/base_m2.dmi')
					user.overlays+=image('icons/c42.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays+=image('icons/c42.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays+=image('icons/c42.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays+=image('icons/c42.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays+=image('icons/c42.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays+=image('icons/c42.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
				else if(user.icon_name=="base_m3"||user.icon == 'icons/base_m3.dmi'||user.icon_name=="base_m5"||user.icon == 'icons/base_m5.dmi')
					user.overlays+=image('icons/c43.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays+=image('icons/c43.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays+=image('icons/c43.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays+=image('icons/c43.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays+=image('icons/c43.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays+=image('icons/c43.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
				else if(user.icon_name=="base_m4"||user.icon == 'icons/base_m4.dmi')
					user.overlays+=image('icons/c44.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays+=image('icons/c44.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays+=image('icons/c44.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays+=image('icons/c44.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays+=image('icons/c44.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays+=image('icons/c44.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
				else if(user.icon_name=="base_m6"||user.icon == 'icons/base_m6.dmi')
					user.overlays+=image('icons/c45.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays+=image('icons/c45.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays+=image('icons/c45.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays+=image('icons/c45.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays+=image('icons/c45.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays+=image('icons/c45.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
				else if(user.icon_name=="base_m7"||user.icon == 'icons/base_m7.dmi')
					user.overlays+=image('icons/c46.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays+=image('icons/c46.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays+=image('icons/c46.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays+=image('icons/c46.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays+=image('icons/c46.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays+=image('icons/c46.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
				spawn(18)
					user.overlays-=image('icons/c41.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays-=image('icons/c41.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays-=image('icons/c41.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays-=image('icons/c41.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays-=image('icons/c41.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays-=image('icons/c41.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
					user.overlays-=image('icons/c42.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays-=image('icons/c42.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays-=image('icons/c42.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays-=image('icons/c42.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays-=image('icons/c42.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays-=image('icons/c42.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
					user.overlays-=image('icons/c43.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays-=image('icons/c43.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays-=image('icons/c43.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays-=image('icons/c43.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays-=image('icons/c43.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays-=image('icons/c43.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
					user.overlays-=image('icons/c44.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays-=image('icons/c44.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays-=image('icons/c44.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays-=image('icons/c44.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays-=image('icons/c44.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays-=image('icons/c44.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
					user.overlays-=image('icons/c45.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays-=image('icons/c45.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays-=image('icons/c45.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays-=image('icons/c45.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays-=image('icons/c45.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays-=image('icons/c45.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
					user.overlays-=image('icons/c46.dmi',icon_state = "1",pixel_x=-16,pixel_y=0)
					user.overlays-=image('icons/c46.dmi',icon_state = "2",pixel_x=16,pixel_y=0)
					user.overlays-=image('icons/c46.dmi',icon_state = "3",pixel_x=-16,pixel_y=32)
					user.overlays-=image('icons/c46.dmi',icon_state = "4",pixel_x=16,pixel_y=32)
					user.overlays-=image('icons/c46.dmi',icon_state = "5",pixel_x=-16,pixel_y=64)
					user.overlays-=image('icons/c46.dmi',icon_state = "6",pixel_x=16,pixel_y=64)
					user.stunned=0
					for(var/mob/human/player/x in range(8,H))
						if(x != user)
							user.combat("You have infected someone, press <b>Space</b> to activate the jutsu")
							x.combat("You have been infected by C4!")
							infectedby.Add(x)
							spawn(2)del(H)
				spawn(300)
					if(user.c4)
						user.c4 = 0
						for(var/mob/human/player/x in infectedby)
							infectedby.Remove(x)


		c0
			id = C0
			name = "Artistic: C0"
			icon_state = "c0"
			default_chakra_cost = 1000
			default_cooldown = 320
			var/used_chakra

			ChakraCost(mob/user)
				used_chakra = user.curchakra
				if(used_chakra > default_chakra_cost)
					return used_chakra
				else
					return default_chakra_cost

			Use(mob/human/user)
				if(!user) return
				user.dir=SOUTH
				user.stunned = 30
				user.overlays+=image('icons/c-0.dmi')
				sleep(15)
				user.overlays+=image('icons/c0.dmi')
				var/hit=5 + 1250*user.con/2 + rand(2000,4000)
				spawn(15)
					spawn()
						explosion(hit,user.x,user.y,user.z,user,0,6)
						explosion(hit,user.x+1,user.y+1,user.z,user,0,6)
						explosion(hit,user.x-1,user.y+1,user.z,user,0,6)
						explosion(hit,user.x-1,user.y+1,user.z,user,0,6)
						explosion(hit,user.x-1,user.y-1,user.z,user,0,6)
						explosion(hit,user.x-2,user.y+2,user.z,user,0,6)
						explosion(hit,user.x+2,user.y-2,user.z,user,0,6)
						explosion(hit,user.x+2,user.y+2,user.z,user,0,6)
						explosion(hit,user.x-2,user.y-2,user.z,user,0,6)
						explosion(hit,user.x-2,user.y+2,user.z,user,0,6)
						explosion(hit,user.x-3,user.y+3,user.z,user,0,6)
						explosion(hit,user.x+3,user.y-3,user.z,user,0,6)
						explosion(hit,user.x+3,user.y+3,user.z,user,0,6)
						explosion(hit,user.x-3,user.y-3,user.z,user,0,6)
						explosion(hit,user.x-3,user.y+3,user.z,user,0,6)
						explosion(hit,user.x-4,user.y+4,user.z,user,0,6)
						explosion(hit,user.x+4,user.y-4,user.z,user,0,6)
						explosion(hit,user.x+4,user.y+4,user.z,user,0,6)
						explosion(hit,user.x-4,user.y-4,user.z,user,0,6)
						explosion(hit,user.x-4,user.y+4,user.z,user,0,6)

						explosion(hit,user.x+5,user.y+5,user.z,user,0,6)
						explosion(hit,user.x-5,user.y-5,user.z,user,0,6)
						explosion(hit,user.x+5,user.y-5,user.z,user,0,6)
						explosion(hit,user.x-5,user.y+5,user.z,user,0,6)

						explosion(hit,user.x+6,user.y+6,user.z,user,0,6)
						explosion(hit,user.x-6,user.y-6,user.z,user,0,6)
						explosion(hit,user.x+6,user.y-6,user.z,user,0,6)
						explosion(hit,user.x-6,user.y+6,user.z,user,0,6)

						explosion(hit,user.x+7,user.y+7,user.z,user,0,6)
						explosion(hit,user.x-7,user.y-7,user.z,user,0,6)
						explosion(hit,user.x+7,user.y-7,user.z,user,0,6)
						explosion(hit,user.x-7,user.y+7,user.z,user,0,6)

						explosion(hit,user.x+8,user.y+8,user.z,user,0,6)
						explosion(hit,user.x-8,user.y-8,user.z,user,0,6)
						explosion(hit,user.x+8,user.y-8,user.z,user,0,6)
						explosion(hit,user.x-8,user.y+8,user.z,user,0,6)

						if(user)
							user.Dec_Stam(user.chakra,1,user)
							user.Wound(300,0,user)
							user.overlays-=image('icons/c0.dmi')
							user.overlays-=image('icons/c-0.dmi')
							user.stunned=0
							user.Hostile(user)
							for(var/mob/human/player/x in view(4))
								if(user && x && !x.ko)
									x.Wound(rand(10,15),0,user)
