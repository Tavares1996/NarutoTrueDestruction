mob/var
	boil_damage=0
	boil_active=0
//	dragon_steam_active=0
//obj/Steam/icon = 'icons/Mist.dmi'


skill
	boil
		copyable = 0


		Boil_Release_Boil_Dragon_Bullet_Technique
			id = DRAGON_BULLET
			name = "Boil Release: Boil Dragon Bullet Technique"
			icon_state = "dragonB"
			default_chakra_cost = 1800
			default_cooldown = 220
			default_seal_time = 19

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.NearWater(10))
						Error(user, "There must be water in approximate of yourself")
						return 0

			Use(mob/human/user)

				viewers(user) << output("Boil Release: Boil Dragon Bullet Technique!", "combat_output")

				user.boil_active = 1
				user.combat("Press <b>Space</b> to change the PH balance of your mist")

				var/amount_
				var/eicon='icons/Dragon_Bullet.dmi'
				var/estate=""
				var/damz
				var/mob/human/player/target = user.NearestTarget()

				user.stunned = 99
				user.icon_state = "Seal"
				spawn(20)
					user.icon_state = ""
					user.stunned = 0

				amount_ = rand(1,10)
				user.combat("You have summoned [amount_] dragons from the water!")

				user.boil_damage = rand(1,6)

				while(amount_ > 0 && user)

					var/atom/water = user.ClosestWater(10)
					if(!water) return

					switch(user.boil_damage)
						if(1)
							damz = user:ControlDamageMultiplier() * 50
						if(2)
							damz = user:ControlDamageMultiplier() * 80
						if(3)
							damz = user:ControlDamageMultiplier() * 110
						if(4)
							damz = user:ControlDamageMultiplier() * 140
						if(5)
							damz = user:ControlDamageMultiplier() * 170
						if(6)
							damz = user:ControlDamageMultiplier() * 200

					var/obj/Q
					var/generate
					generate = rand(1,4)
					switch(generate)
						if(1)
							Q=new/obj/blank(locate(water.x+rand(1,10),water.y+rand(1,10),water.z))
						if(2)
							Q=new/obj/blank(locate(water.x-rand(1,10),water.y-rand(1,10),water.z))
						if(3)
							Q=new/obj/blank(locate(water.x-rand(1,10),water.y+rand(1,10),water.z))
						if(4)
							Q=new/obj/blank(locate(water.x+rand(1,10),water.y-rand(1,10),water.z))

					var/list/alist = list()

					alist += Q

					if(!target)

						for(var/obj/V in alist)
							target=straight_proj2(eicon,estate,8,V)
							break

						if(target)
							var/ex=target.x
							var/ey=target.y
							var/ez=target.z
							spawn()AOE_(ex,ey,ez,2,damz,300,user,3,1)
							spawn()Mist_Cloud(ex,ey,ez,1,300)

							if(user && amount_ > 0 && user.stunned > 0)
								amount_ = 0
								break

							sleep(rand(1,2))
							amount_--

					else if(target)
						var/ex=target.x
						var/ey=target.y
						var/ez=target.z
						var/mob/x=new/mob(locate(ex,ey,ez))

						for(var/obj/V in alist)
							projectile_to(eicon,estate,V,x)
							break

						del(x)
						spawn()AOE_(ex,ey,ez,2,damz,300,user,3,1)
						spawn()Mist_Cloud(ex,ey,ez,1,300)

						sleep(rand(1,2))
						amount_--

				user.boil_active = 0
				user.boil_damage = 0


		boil_release
			id = BOIL_RELEASE_SKILLED_MIST_TECHNIQUE
			name = "Boil Release: Skilled Mist Technique"
			icon_state = "skilled_mist_technique"
			default_chakra_cost = 250
			default_cooldown = 45

			Use(mob/human/user)
				var/mox=0
				var/moy=0
				user.combat("Press <b>Space</b> to change the PH balance of your mist")
				user.icon_state="Seal"
				spawn(10)
					user.icon_state=""
					user.stunned=0
				if(user.dir==NORTH)
					moy=1
				if(user.dir==SOUTH)
					moy=-1
				if(user.dir==EAST)
					mox=1
				if(user.dir==WEST)
					mox=-1
				if(!mox&&!moy)
					return
				user.stunned=1
				user.boil_active=1
				user.boil_damage=pick(1,6)
				var/boil=1
				var/list/smogs=new()
				var/flagloc
				spawn()
					while(user && boil)
						var/list/boi=new()
						for(var/obj/X in smogs)
							for(var/mob/human/player/Z in view(0,X))
								if(!boi.Find(Z))
									boi+=Z
						for(var/mob/Y in boi)
							if(Y!=user&&boil)
								switch(user.boil_damage)
									if(1)
										Y.Dec_Stam(user:ControlDamageMultiplier(),1,user)
									if(2)
										Y.Dec_Stam(100*user:ControlDamageMultiplier(),1,user)
									if(3)
										Y.Dec_Stam(200*user:ControlDamageMultiplier(),1,user)
									if(4)
										Y.Dec_Stam(300*user:ControlDamageMultiplier(),1,user)
									if(5)
										Y.Dec_Stam(400*user:ControlDamageMultiplier(),1,user)
									if(6)
										Y.Dec_Stam(500*user:ControlDamageMultiplier(),1,user)
							Y.Hostile(user)
						sleep(10)
				flagloc=locate(user.x+mox,user.y+moy,user.z)
				spawn()
					var/obj/Hmist_Poof/S1=new/obj/Hmist_Poof(flagloc)
					var/obj/Hmist_Poof/S2=new/obj/Hmist_Poof(flagloc)
					var/obj/Hmist_Poof/S3=new/obj/Hmist_Poof(flagloc)
					var/obj/Hmist_Poof/S4=new/obj/Hmist_Poof(flagloc)
					var/obj/Hmist_Poof/S5=new/obj/Hmist_Poof(flagloc)
					smogs+=S1
					smogs+=S2
					smogs+=S3
					smogs+=S4
					smogs+=S5
					if(mox==1||mox==-1)
						spawn() if(S1)S1.Spread(5*mox,6,140,smogs)
						spawn() if(S2)S2.Spread(6.5*mox,4,140,smogs)
						spawn() if(S3)S3.Spread(8*mox,0,140,smogs)
						spawn() if(S4)S4.Spread(5*mox,-6,140,smogs)
						spawn() if(S5)S5.Spread(6.5*mox,-4,140,smogs)
					else
						spawn() if(S1)S1.Spread(6,5*moy,140,smogs)
						spawn() if(S2)S2.Spread(4,6.5*moy,140,smogs)
						spawn() if(S3)S3.Spread(0,8*moy,140,smogs)
						spawn() if(S4)S4.Spread(-6,5*moy,140,smogs)
						spawn() if(S5)S5.Spread(-4,6.5*moy,140,smogs)
				spawn(19)
					flagloc=locate(user.x+mox*2,user.y+moy*2,user.z)
					var/obj/Hmist_Poof/S1=new/obj/Hmist_Poof(flagloc)
					var/obj/Hmist_Poof/S2=new/obj/Hmist_Poof(flagloc)
					var/obj/Hmist_Poof/S4=new/obj/Hmist_Poof(flagloc)
					var/obj/Hmist_Poof/S5=new/obj/Hmist_Poof(flagloc)
					smogs+=S1
					smogs+=S2
					smogs+=S4
					smogs+=S5
					if(mox==1||mox==-1)
						spawn()if(S1)S1.Spread(5*mox,6,80,smogs)
						spawn()if(S2)S2.Spread(6.5*mox,4,80,smogs)
						spawn()if(S4)S4.Spread(5*mox,-6,80,smogs)
						spawn()if(S5)S5.Spread(6.5*mox,-4,80,smogs)
					else
						spawn()if(S1)S1.Spread(6,5*moy,80,smogs)
						spawn()if(S2)S2.Spread(4,6.5*moy,80,smogs)
						spawn()if(S4)S4.Spread(-6,5*moy,80,smogs)
						spawn()if(S5)S5.Spread(-4,6.5*moy,80,smogs)
				spawn(139)
					boil=0
					user.boil_active=0
					user.boil_damage=0
					for(var/obj/G in smogs)
						del(G)

obj
	Hmist_Poof
		proc
			PixelMove(dpixel_x, dpixel_y, list/smogs)
				var/new_pixel_x = pixel_x + dpixel_x
				var/new_pixel_y = pixel_y + dpixel_y


				while(abs(new_pixel_x) > 16)
					var/kloc = loc
					if(new_pixel_x > 16)
						new_pixel_x -= 32
						var/Phail=0

						for(var/obj/Hmist_Poof/x in oview(0,src))
							Phail=1
							break

						x++

						if(!Phail)
							smogs+=new/obj/Hmist_Poof(kloc)

					else if(new_pixel_x < -16)
						new_pixel_x += 32

						var/Phail=0
						for(var/obj/Hmist_Poof/x in oview(0,src))
							Phail=1
							break

						x--

						if(!Phail)
							smogs+=new/obj/Hmist_Poof(kloc)

				while(abs(new_pixel_y) > 16)
					var/kloc = loc
					if(new_pixel_y > 16)
						new_pixel_y -= 32

						var/Phail=0
						for(var/obj/Hmist_Poof/x in oview(0,src))
							Phail=1
							break

						y++

						if(!Phail)
							smogs+=new/obj/Hmist_Poof(kloc)

					else if(new_pixel_y < -16)
						new_pixel_y += 32

						var/Phail=0
						for(var/obj/Hmist_Poof/x in oview(0,src))
							Phail=1
							break

						y--

						if(!Phail)
							smogs+=new/obj/Hmist_Poof(kloc)

				pixel_x = new_pixel_x
				pixel_y = new_pixel_y


			Spread(motx,moty,mom,list/smogs)
				while(mom>0)
					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					mom -= (abs(motx)+abs(moty))


obj
	Hmist_Poof
		icon='icons/Hazingmist.dmi'
		icon_state="cloud"
		layer = MOB_LAYER+3
		animate_movement=0
		New()
			..()
			var/c=0
			for(var/obj/Hmist_Poof/X in oview(0))
				c++
			if(c>1)
				del(src)
			else
				spawn()
					src.underlays+=image('icons/Hazingmist.dmi',icon_state="l",pixel_x=-32,layer=MOB_LAYER+2)
					src.underlays+=image('icons/Hazingmist.dmi',icon_state="r",pixel_x=32,layer=MOB_LAYER+2)

					src.underlays+=image('icons/Hazingmist.dmi',icon_state="tr",pixel_y=32,pixel_x=16,layer=MOB_LAYER+2)
					src.underlays+=image('icons/Hazingmist.dmi',icon_state="br",pixel_y=-32,pixel_x=16,layer=MOB_LAYER+2)
					src.underlays+=image('icons/Hazingmist.dmi',icon_state="tl",pixel_y=32,pixel_x=-16,layer=MOB_LAYER+2)
					src.underlays+=image('icons/Hazingmist.dmi',icon_state="bl",pixel_y=-32,pixel_x=-16,layer=MOB_LAYER+2)