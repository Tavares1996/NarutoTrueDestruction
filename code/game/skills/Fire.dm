skill
	fire
		face_nearest = 1
		grand_fireball
			id = KATON_FIREBALL
			name = "Fire Release: Grand Fireball"
			icon_state = "grand_fireball"
			default_chakra_cost = 150
			default_cooldown = 75
			default_seal_time = 5

			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(. && target)
					var/distance = get_dist(user, target)
					if(distance > 5)
						Error(user, "Target too far ([distance]/5 tiles)")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=black> Fire Release: Grand Fireball!", "combat_output")
				user.icon_state = "Seal"
				user.overlays += 'icons/breathfire.dmi'
				user.stunned=3
				var/dir = user.dir
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir
				var/conmult = user.ControlDamageMultiplier()
				if(dir == NORTH)
					spawn() AOE(user.x, user.y + 3, user.z, 2, (50 + 50*conmult), 50, user, 3, 2)
					spawn() Fire(user.x, user.y + 3, user.z, 2, 50)
					spawn()FireAOE(user.x,user.y + 3,user.z, 4, (15*conmult), 90, user, 0.2, 0)
				if(dir == SOUTH)
					spawn() AOE(user.x, user.y - 3, user.z, 2, (50 + 50*conmult), 50, user, 3, 2)
					spawn() Fire(user.x, user.y - 3, user.z, 2, 50)
					spawn()FireAOE(user.x,user.y - 3,user.z, 4, (15*conmult), 90, user, 0.2, 0)
				if(dir == EAST)
					spawn() AOE(user.x + 3, user.y, user.z, 2, (50 + 50*conmult), 50, user, 3, 2)
					spawn() Fire(user.x + 3, user.y, user.z, 2, 50)
					spawn()FireAOE(user.x + 3,user.y,user.z, 4, (15*conmult), 90, user, 0.2, 0)
				if(dir == WEST)
					spawn() AOE(user.x - 3, user.y, user.z, 2, (50 + 50*conmult), 50, user, 3, 2)
					spawn() Fire(user.x - 3, user.y, user.z, 2, 50)
					spawn()FireAOE(user.x - 3,user.y,user.z, 4, (15*conmult), 90, user, 0.2, 0)
				spawn(30)
					user.icon_state = ""
					user.overlays -= 'icons/breathfire.dmi'



		hosenka
			id = KATON_PHOENIX_FIRE
			name = "Fire Release: Hôsenka"
			icon_state = "katon_phoenix_immortal_fire"
			default_chakra_cost = 50
			default_cooldown = 10

			Use(mob/human/user)
				user.icon_state="Seal"

				viewers(user) << output("[user]:<font color=black> Fire Release: Hôsenka!", "combat_output")

				spawn()
					var/eicon='icons/fireball.dmi'
					var/estate=""
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/player/etarget = user.NearestTarget()

					if(!etarget)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
							spawn()Fire(ex,ey,ez,1,20)
							spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 1, 0)
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))

						projectile_to(eicon,estate,user,x)
						del(x)
						spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
						spawn()Fire(ex,ey,ez,1,20)
						spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5*conmult), 40, user, 1, 0)
					user.icon_state=""



		burning_ash
			id = KATON_ASH_BURNING
			name = "Fire Release: Ash Accumulation Burning"
			icon_state = "katon_ash_product_burning"
			default_chakra_cost = 450
			default_cooldown = 120
			default_seal_time = 7

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=black> Fire Release: Ash Accumulation Burning!", "combat_output")

				user.icon_state="Seal"
				user.overlays+='icons/breathfire2.dmi'
				user.stunned=2
				var/dir = user.dir
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir
				var/conmult = user.ControlDamageMultiplier()
				if(dir==NORTH)
					spawn()AOE(user.x,user.y+5,user.z,4,(30*conmult),90,user,0.6,0,0)
					spawn()Ash(user.x,user.y+5,user.z,100)
					spawn()FireAOE(user.x,user.y+5,user.z, 4, (10*conmult), 100, user, 0.6, 0)
				if(dir==SOUTH)
					spawn()AOE(user.x,user.y-5,user.z,4,(30*conmult),90,user,0.6,0,0)
					spawn()Ash(user.x,user.y-5,user.z,100)
					spawn()FireAOE(user.x,user.y-5,user.z, 4, (10*conmult), 100, user, 0.6, 0)
				if(dir==EAST)
					spawn()AOE(user.x+5,user.y,user.z,4,(30*conmult),90,user,0.6,0,0)
					spawn()Ash(user.x+5,user.y,user.z,100)
					spawn()FireAOE(user.x+5,user.y,user.z, 4, (10*conmult), 100, user, 0.6, 0)
				if(dir==WEST)
					spawn()AOE(user.x-5,user.y,user.z,4,(30*conmult),90,user,0.6,0,0)
					spawn()Ash(user.x-5,user.y,user.z,100)
					spawn()FireAOE(user.x-5,user.y,user.z, 4, (10*conmult), 100, user, 0.6, 0)
				spawn(23)
					if(user)
						user.icon_state=""
						user.overlays-='icons/breathfire2.dmi'



		fire_dragon_flaming_projectile
			id = KATON_DRAGON_FIRE
			name = "Fire Release: Fire Dragon Flaming Projectile"
			icon_state = "dragonfire"
			default_chakra_cost = 500
			default_cooldown = 70
			default_seal_time = 4



			Use(mob/human/user)
				user.icon_state="Seal"
				viewers(user) << output("[user]:<font color=black> Fire Release: Fire Dragon Flaming Projectile!", "combat_output")
				user.stunned=15
				var/image/I2=image('icons/dragonfire.dmi',icon_state="overlay")
				user.overlays+=I2
				var/obj/trailmaker/o=new/obj/trailmaker/Dragon_Fire()
				o.layer=MOB_LAYER+2

				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,14,user)
				if(result)
					result.move_stun=100

					spawn(45)
						del(o)
						user.overlays-=I2
						user.stunned=0
						if(result)result.move_stun=0
					o.overlays+=image('icons/dragonfire.dmi',icon_state="hurt")
					var/turf/T=result.loc
					var/conmult = user.ControlDamageMultiplier()
					result.Dec_Stam(rand(1500,2000)+500*conmult,0,user)
					spawn()result.Wound(rand(5,10)+round(conmult),0,user)
					var/ie=3
					while(result&&T==result.loc && ie>0)
						ie--
						result.Dec_Stam(rand(250,600)+50*conmult,0,user)
						spawn()result.Wound(rand(1,3)+round(conmult/2),0,user)
						spawn()result.Hostile(user)
						sleep(15)

				else
					user.stunned=0
					user.overlays-=I2
				user.icon_state=""

		fire_phoenix_nail_flower
			id = KATON_PHOENIX_NAIL_FLOWER
			name = "Fire Phoenix Nail Flower"
			icon_state = "pheonix"
			default_chakra_cost = 350
			default_cooldown = 80
			face_nearest = 1

			Use(mob/human/user)
				viewers(user) << output("[user]: Fire Phoenix Nail Flower!", "combat_output")
				var/eicon='icons/projectiles.dmi'
				var/estate="pheonix"
				if(!user.icon_state)
					user.icon_state="Seal"
					spawn(10)
						user.icon_state=""
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))
				var/angle
				var/speed = 35
				var/spread = 9
				if(etarget)
					angle = get_real_angle(user, etarget)
				else
					angle = dir2angle(user.dir)
				var/damage = 50*user.ControlDamageMultiplier()
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*1, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*3, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*3, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*1, distance=10, damage=damage, wounds=1)

		great_fireball_technique
			id = KATON_GREAT_FIREBALL
			name = "Fire Release: Great Fireball Technique"
			icon_state = "great_fireball"
			default_chakra_cost = 300
			default_cooldown = 60
			default_seal_time = 2

			Use(mob/user)
				viewers(user) << output("[user]:<font color=black> Fire Release: Great Fireball Technique!", "combat_output")
				user.stunned = 0.1
				user.icon_state = "Seal"
				spawn(10)
					user.icon_state = ""
				var/fireball/fire = new(get_step(user,user.dir))
				fire.owner = user
				fire.dir = user.dir
				var/tiles = 20
				spawn()
					walk(fire, fire.dir, 1)
					while(user && tiles > 0)
						for(var/mob/human/O in view(1,fire))
							if(O != user)
								O.Dec_Stam(rand(200,700) * user:ControlDamageMultiplier(),0,user)
								O.Wound(rand(1,3),0,user)
								O.movepenalty += 10
								O.Hostile(user)
						tiles--
						sleep(3)
					if(fire)
						fire.loc = null

		burning_dragon_head
			id = KATON_DRAGON_HEAD
			name = "Fire Release: Burning Dragon Head"
			icon_state = "burning_dragon_head"
			default_chakra_cost = 1500
			default_cooldown = 380
			default_seal_time = 30

			Use(mob/human/user)
				user.stunned=2
				viewers(user) << output("[user]:<font color=black> Fire Release : Burning Dragon Head", "combat_output")
				spawn()
					var/eicon='icons/GoukikikiHead.dmi'
					var/estate=""
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/player/etarget = user.NearestTarget()
					if(!etarget)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,4,(40*conmult),300,user,0.2,0,0)
							spawn()Gfireball(ex,ey,ez,400)
							spawn()FireAOE(ex,ey,ez, 4, (20*conmult), 200, user, 0.2, 0)
							sleep(2)
							ex=etarget.x
							ey=etarget.y
							ez=etarget.z
							spawn()AOE(ex,ey,ez,4,(40*conmult),300,user,0.2,0,0)
							spawn()Gfireball(ex,ey,ez,400)
							spawn()FireAOE(ex,ey,ez, 4, (20*conmult), 200, user, 0.2, 0)
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,user,x)
						del(x)
						spawn()AOE(ex,ey,ez,4,(40*conmult),300,user,0.2,0,0)
						spawn()Gfireball(ex,ey,ez,400)
						spawn()FireAOE(ex,ey,ez, 4, (20*conmult), 200, user, 0.2, 0)
						sleep(2)
						ex=etarget.x
						ey=etarget.y
						ez=etarget.z
						var/mob/z=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,user,z)
						del(z)
						spawn()AOE(ex,ey,ez,4,(40*conmult),300,user,0.2,0,0)
						spawn()Gfireball(ex,ey,ez,400)
						spawn()FireAOE(ex,ey,ez, 4, (20*conmult), 200, user, 0.2, 0)

		barage_hosenka
			id = KATON_TAJUU_PHOENIX_FIRE
			name = "Fire Release: Hôsenka Barrage"
			icon_state = "tajuuhosenka"
			default_chakra_cost = 450
			default_cooldown = 165
			default_seal_time = 10

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=black> Fire Release: Tajuu Hôsenka!", "combat_output")
				spawn()
					var/eicon='icons/fireball.dmi'
					var/estate=""
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/player/etarget = user.NearestTarget()
					if(!etarget)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
							spawn()Fire(ex,ey,ez,1,20)
							spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
							spawn()Fire(ex,ey,ez,1,20)
							spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
							spawn()Fire(ex,ey,ez,1,20)
							spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
							spawn()Fire(ex,ey,ez,1,20)
							spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
							spawn()Fire(ex,ey,ez,1,20)
							spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,user,x)
						spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
						spawn()Fire(ex,ey,ez,1,20)
						spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						ex=etarget.x
						ey=etarget.y
						ez=etarget.z
						var/mob/d=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,user,d)
						spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
						spawn()Fire(ex,ey,ez,1,20)
						spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						ex=etarget.x
						ey=etarget.y
						ez=etarget.z
						var/mob/s=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,user,s)
						spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
						spawn()Fire(ex,ey,ez,1,20)
						spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						ex=etarget.x
						ey=etarget.y
						ez=etarget.z
						var/mob/a=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,user,a)
						spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
						spawn()Fire(ex,ey,ez,1,20)
						spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						sleep(1.5)
						ex=etarget.x
						ey=etarget.y
						ez=etarget.z
						var/mob/q=new/mob(locate(ex,ey,ez))
						projectile_to(eicon,estate,user,q)
						spawn()AOE(ex,ey,ez,1,(50 + 10*conmult),20,user,3,1,1)
						spawn()Fire(ex,ey,ez,1,20)
						spawn()FireAOE(ex, ey, ez, 1, (25 + 7.5 *conmult), 40, user, 0.5, 0)
						del(x)
						del(d)
						del(s)
						del(a)
						del(q)

fireball
	parent_type = /obj
	New(loc)
		..(loc)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "0,0",pixel_x = -48,pixel_y = -32)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "1,0",pixel_x = -16,pixel_y = -32)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "2,0",pixel_x = 16,pixel_y = -32)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "3,0",pixel_x = 48,pixel_y = -32)

		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "0,1",pixel_x = -48)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "1,1",pixel_x = -16)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "2,1",pixel_x = 16)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "3,1",pixel_x = 48)

		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "0,2",pixel_x = -48,pixel_y = 32)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "1,2",pixel_x = -16,pixel_y = 32)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "2,2",pixel_x = 16,pixel_y = 32)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "3,2",pixel_x = 48,pixel_y = 32)

		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "0,3",pixel_x = -48,pixel_y = 64)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "1,3",pixel_x = -16,pixel_y = 64)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "2,3",pixel_x = 16,pixel_y = 64)
		overlays += image(icon = 'icons/great_fireball.dmi',icon_state = "3,3",pixel_x = 48,pixel_y = 64)