skill
	lightning
		chidori
			id = CHIDORI
			name = "Lightning Release: Chidori"
			icon_state = "chidori"
			default_chakra_cost = 400
			default_cooldown = 90
			default_seal_time = 5

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Chidori!", "combat_output")
				user.overlays+='icons/chidori.dmi'

				var/mob/human/etarget = user.MainTarget()
				user.stunned=100
				spawn()

					if(!etarget)
						user.stunned=0
						sleep(10)
						var/ei=11
						while(!etarget && ei>0)
							for(var/mob/human/o in get_step(user,user.dir))
								if(!o.ko&&!o.protected)
									etarget=o
							ei--
							walk(user,user.dir)
							sleep(1)
							walk(user,0)

						if(etarget)
							var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
							if(result>=5)
								user.combat("[user] Critically hit [etarget] with the Chidori")
								etarget.combat("[user] Critically hit [etarget] with the Chidori")
								etarget.Wound(rand(25,35),1,user)
								etarget.Dec_Stam(rand(3500,4500),1,user)

								if(etarget.clan == "Scavenger" || etarget.hearts)
									etarget.hearts--
									etarget.combat("You've lost a heart from the damage!")

							if(result==4||result==3)
								user.combat("[user] Managed to partially hit [etarget] with the Chidori")
								etarget.combat("[user] Managed to partially hit [etarget] with the Chidori")
								etarget.Wound(rand(5,10),1,user)
								etarget.Dec_Stam(rand(1000,2000),1,user)

								if(etarget.clan == "Scavenger" || etarget.hearts)
									etarget.hearts--
									etarget.combat("You've lost a heart from the damage!")

							if(result>=3)
								spawn()ChidoriFX(user)
								etarget.move_stun=50
								spawn()Blood2(etarget,user)
								spawn()etarget.Hostile(user)
								spawn()user.Taijutsu(etarget)
							if(result<3)
								user.combat("You Missed!!!")
								if(!user.icon_state)
									flick("hurt",user)
						user.overlays-='icons/chidori.dmi'
						var/conmult = user.ControlDamageMultiplier()
						for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
					else if(etarget)
						user.usemove=1
						spawn(20)
							user.overlays-='icons/chidori.dmi'
						sleep(20)
						etarget = user.MainTarget()
						var/inrange=(etarget in oview(user, 10))
						user.stunned=0

						if(etarget && user.usemove==1 && inrange)
							var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
							if(result>=5)
								user.combat("[user] Critically hit [etarget] with the Chidori")
								etarget.combat("[user] Critically hit [etarget] with the Chidori")
								etarget.Wound(rand(25,40),1,user)
								etarget.Dec_Stam(rand(3500,4500),1,user)

								if(etarget.clan == "Scavenger" || etarget.hearts)
									etarget.hearts--
									etarget.combat("You've lost a heart from the damage!")

							if(result==4||result==3)
								user.combat("[user] Managed to partially hit [etarget] with the Chidori")
								etarget.combat("[user] Managed to partially hit [etarget] with the Chidori")
								etarget.Wound(rand(5,15),1,user)
								etarget.Dec_Stam(rand(1500,2500),1,user)
							if(result<3)
								user.combat("[user] Partially Missed [etarget] with the Chidori,[etarget] is damaged by the electricity!")
								etarget.combat("[user] Partially Missed [etarget] with the Chidori,[etarget] is damaged by the electricity!")
								etarget.Dec_Stam(rand(100,800),1,user)

							if(user.AppearMyDir(etarget))
								if(result>=3)
									spawn()ChidoriFX(user)
									etarget.move_stun=50
									spawn()Blood2(etarget,user)
									spawn()etarget.Hostile(user)
									spawn()user.Taijutsu(etarget)
								if(result<3)
									user.combat("You Missed!!!")
									if(!user.icon_state)
										flick("hurt",user)
						var/conmult = user.ControlDamageMultiplier()
						for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)



		chidori_spear
			id = CHIDORI_SPEAR
			name = "Lightning Release: Chidori Spear"
			icon_state = "raton_sword_form_assasination_technique"
			default_chakra_cost = 350
			default_cooldown = 90
			face_nearest = 1



			Use(mob/human/user)
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Chidori Spear!", "combat_output")

				user.stunned=10

				user.overlays+='icons/ratonswordoverlay.dmi'
				sleep(5)

				var/obj/trailmaker/o=new/obj/trailmaker/Raton_Sword()
				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,14,user)
				if(result)
					spawn(50)
						del(o)
					result.Dec_Stam(rand(1500,4300),1,user)
					spawn()result.Wound(rand(10,20),1,user)
					spawn()Blood2(result,user)
					spawn()result.Hostile(user)
					result.move_stun=50
					spawn(50)
						user.stunned=0
						user.overlays-='icons/ratonswordoverlay.dmi'
						var/conmult = user.ControlDamageMultiplier()
						for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
				else
					user.stunned=0
					user.overlays-='icons/ratonswordoverlay.dmi'
					var/conmult = user.ControlDamageMultiplier()
					for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
						spawn()Electricity(w.x,w.y,w.z,50)
						spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
					for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
						spawn()Electricity(e.x,e.y,e.z,50)
						spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)




		chidori_current
			id = CHIDORI_CURRENT
			name = "Lightning Release: Chidori Current"
			icon_state = "chidori_nagashi"
			default_chakra_cost = 100
			default_cooldown = 20
			face_nearest = 1



			Use(mob/human/user)
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Chidori Current!", "combat_output")

				user.icon_state="Seal"
				user.stunned=5

				var/conmult = user.ControlDamageMultiplier()

				if(!user.waterlogged)
					spawn()
						spawn()Electricity(user.x+1,user.y,user.z,30)
						spawn()Electricity(user.x-1,user.y,user.z,30)
						spawn()Electricity(user.x,user.y+1,user.z,30)
						spawn()Electricity(user.x,user.y-1,user.z,30)
						spawn()Electricity(user.x+1,user.y+1,user.z,30)
						spawn()Electricity(user.x-1,user.y+1,user.z,30)
						spawn()Electricity(user.x+1,user.y-1,user.z,30)
						spawn()Electricity(user.x-1,user.y-1,user.z,30)
					spawn()AOExk(user.x,user.y,user.z,1,(500+150*conmult),30,user,0,1.5,1)
					Electricity(user.x,user.y,user.z,30)
				else
					for(var/turf/x in oview(2))
						spawn()Electricity(x.x,x.y,x.z,30)
					spawn()AOExk(user.x,user.y,user.z,2,(500+150*conmult),30,user,0,1.5,1)
					Electricity(user.x,user.y,user.z,30)

				user.stunned=0
				user.icon_state=""
				for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
					spawn()Electricity(w.x,w.y,w.z,50)
					spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
				for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
					spawn()Electricity(e.x,e.y,e.z,50)
					spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)




		chidori_needles
			id = CHIDORI_NEEDLES
			name = "Lightning Release: Chidori Needles"
			icon_state = "chidorisenbon"
			default_chakra_cost = 200
			default_cooldown = 30
			face_nearest = 1



			Use(mob/human/user)
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Chidori Needles!", "combat_output")
				var/eicon='icons/chidorisenbon.dmi'
				var/estate=""

				if(!user.icon_state)
					user.icon_state="Throw1"
					user.overlays+='icons/raitonhand.dmi'
					spawn(13)
						user.icon_state=""
						user.overlays-='icons/raitonhand.dmi'
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))

				var/angle
				var/speed = 35.5
				var/spread = 5.5
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)

				var/damage = 30*user.ControlDamageMultiplier()

				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0.5, daze=6.5)
				sleep(3.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0.5, daze=6.5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0.5, daze=6.5)
				for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
					spawn()Electricity(w.x,w.y,w.z,50)
					spawn()AOExk(w.x,w.y,w.z,1,(rand(500,100)),50,user,0,1.5,1)
				for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
					spawn()Electricity(e.x,e.y,e.z,50)
					spawn()AOExk(e.x,e.y,e.z,1,(rand(500,100)),50,user,0,1.5,1)

		lightning_clone
			id = LIGHTNING_KAGE_BUNSHIN
			name = "Lightning Release: Kage Bunshin"
			icon_state = "lightning_bunshin"
			default_chakra_cost = 500
			default_cooldown = 60

			Use(mob/user)
				for(var/mob/human/player/npc/kage_bunshin/O in world)
					if(O.ownerkey==user.key)
						del(O)
				flick("Seal",user)

				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Kage Bunshin!", "combat_output")
				var/mob/human/player/npc/kage_bunshin/X = new/mob/human/player/npc/kage_bunshin(locate(user.x,user.y,user.z))
				user.client.eye=X
				X.ownerkey=user.key
				user.controlmob=X
				spawn(2)
					X.icon=user.icon
					X.overlays=user.overlays
					X.underlays=user.underlays
					X.faction=user.faction
					X.lightning=1
					X.mouse_over_pointer=user.mouse_over_pointer
					X.con=user.con
					X.str=user.str
					X.rfx=user.rfx
					X.int=user.int

					X.name="[user.name]"
					spawn(1)X.CreateName(255, 255, 255)

				spawn() X.regeneration2()

				if(user) user.BunshinTrick(list(X))
				for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
					spawn()Electricity(w.x,w.y,w.z,50)
					spawn()AOExk(w.x,w.y,w.z,1,(rand(500,100)),50,user,0,1.5,1)
				for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
					spawn()Electricity(e.x,e.y,e.z,50)
					spawn()AOExk(e.x,e.y,e.z,1,(rand(500,100)),50,user,0,1.5,1)


		false_darkness
			id = LIGHTNING_FALSE_DARKNESS
			name = "Lightning Release: False Darkness"
			icon_state = "falsedarkness"
			default_chakra_cost = 350
			default_cooldown = 90
			var
				active_state = 0

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: False Darkness!", "combat_output")
				user.icon_state="Seal"
				spawn(10)
					user.icon_state = ""
				user.stunned=3
				var/conmult = user.ControlDamageMultiplier()
				var/targets[] = user.NearestTargets(num=3)
				for(var/mob/human/player/target in targets)
					++active_state
					spawn()
						var/obj/trailmaker/o=new/obj/trailmaker/Falsedarkness(locate(user.x,user.y,user.z))
						var/mob/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,10,target,1,1,0,0,1,user)
						if(result)
							result.Dec_Stam(rand(200, (400+300*conmult)), 0, user)
							result.Wound(rand(1, 8), 0, user)
							result.icon_state="hurt"
							result.move_stun=20
							spawn(15) result.icon_state=""
							if(!result.ko && !result.protected)
								spawn()Blood2(result,user)
								o.icon_state="still"
								spawn()result.Hostile(user)
						--active_state
						if(active_state <= 0)
							user.stunned = 0
						del(o)
						for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(rand(500,100)),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(rand(500,100)),50,user,0,1.5,1)


		Chidori_Needles_Barage
			id = CHIDORI_NEEDLES_BARAGE
			name = "Lightning Needles Barage"
			icon_state = "SenbonBarage"
			default_chakra_cost = 1200
			default_cooldown = 120
			face_nearest = 1
			copyable = 0

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.RankGrade2()!=5)
						Error(user, "You must be S rank to use this Jutsu")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Chidori Needles!", "combat_output")
				var/eicon='icons/electricity.dmi'
				var/estate=""

				if(!user.icon_state)
					user.icon_state="Throw1"
					user.overlays+='icons/raitonhand.dmi'
					spawn(20)
						user.icon_state=""
						user.overlays-='icons/raitonhand.dmi'
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))

				var/angle
				var/speed = 28.5
				var/spread = 8.5
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)

				var/damage = 25+15*user.ControlDamageMultiplier()


				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				sleep(5)
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				sleep(5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=10)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*4, distance=10, damage=damage, wounds=0, daze=15)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*5, distance=10, damage=damage, wounds=0, daze=15)
				sleep(5)



		Raikiri
			id = RAIKIRI
			name = "Lightning Release: Raikiri"
			icon_state = "Raikiri"
			default_chakra_cost = 600
			default_cooldown = 150
			default_seal_time = 5

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Raikiri!", "combat_output")
				user.overlays+='icons/raikiri.dmi'

				var/mob/human/etarget = user.MainTarget()
				user.stunned=100
				spawn()

					if(!etarget)
						user.stunned=0
						sleep(10)
						var/ei=11
						while(!etarget && ei>0)
							for(var/mob/human/o in get_step(user,user.dir))
								if(!o.ko&&!o.protected)
									etarget=o
							ei--
							walk(user,user.dir)
							sleep(1)
							walk(user,0)

						if(etarget)
							var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,50)
							if(result>=5)
								user.combat("[user] Perfectly assasinated [etarget] with the Raikiri")
								etarget.combat("[user] You have been perfectly assasinaed by [etarget] with the Raikiri")
								etarget.Wound(rand(40,50),1,user)
								etarget.Dec_Stam(rand(4500,7000),1,user)

								if(etarget.clan == "Scavenger" || etarget.hearts)
									etarget.hearts-=2
									etarget.combat("You've lost 2 hearts from the damage!")

							if(result==4||result==3)
								user.combat("[user] Managed to partially hit [etarget] with the Raikiri")
								etarget.combat("[user] Managed to partially hit [etarget] with the Raikiri")
								etarget.Wound(rand(15,20),1,user)
								etarget.Dec_Stam(rand(2000,3500),1,user)

								if(etarget.clan == "Scavenger" || etarget.hearts)
									etarget.hearts--
									etarget.combat("You've lost a heart from the damage!")

							if(result>=3)
								spawn()ChidoriFX(user)
								etarget.move_stun=50
								spawn()Blood2(etarget,user)
								spawn()etarget.Hostile(user)
								spawn()user.Taijutsu(etarget)
							if(result<3)
								user.combat("You Missed!!!")
								if(!user.icon_state)
									flick("hurt",user)
						user.overlays-='icons/raikiri.dmi'
						var/conmult = user.ControlDamageMultiplier()
						for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
					else if(etarget)
						user.usemove=1
						spawn(20)
							user.overlays-='icons/raikiri.dmi'
						sleep(20)
						etarget = user.MainTarget()
						var/inrange=(etarget in oview(user, 10))
						user.stunned=0

						if(etarget && user.usemove==1 && inrange)
							var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
							if(result>=5)
								user.combat("[user] Perfectly assasinated [etarget] with the Raikiri")
								etarget.combat("[user] Perfectly assasinated [etarget] with the Raikiri")
								etarget.Wound(rand(50,60),1,user)
								etarget.Dec_Stam(rand(4500,8000),1,user)

								if(etarget.clan == "Scavenger" || etarget.hearts)
									etarget.hearts-=2
									etarget.combat("You've lost 2 hearts from the damage!")

							if(result==4||result==3)
								user.combat("[user] Managed to partially hit [etarget] with the Raikiri")
								etarget.combat("[user] Managed to partially hit [etarget] with the Raikiri")
								etarget.Wound(rand(15,30),1,user)
								etarget.Dec_Stam(rand(1500,4500),1,user)

								if(etarget.clan == "Scavenger" || etarget.hearts)
									etarget.hearts--
									etarget.combat("You've lost a heart from the damage!")

							if(result<3)
								user.combat("[user] Partially Missed [etarget] with the Raikiri,[etarget] is damaged by the electricity!")
								etarget.combat("[user] Partially Missed [etarget] with the Raikiri,[etarget] is damaged by the electricity!")
								etarget.Dec_Stam(rand(500,1500),1,user)

							if(user.AppearMyDir(etarget))
								if(result>=3)
									spawn()ChidoriFX(user)
									etarget.move_stun=50
									spawn()Blood2(etarget,user)
									spawn()etarget.Hostile(user)
									spawn()user.Taijutsu(etarget)
								if(result<3)
									user.combat("You Missed!!!")
									if(!user.icon_state)
										flick("hurt",user)
						var/conmult = user.ControlDamageMultiplier()
						for(var/turf/New_Turfs/Outside/Wire/w in oview(10))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)

//Need to fix runtime errors with this jutsu, for some reason the compiler doesnt read the blank object acting as the center of the entire jutsu. I think i gotta make the object to read as a mob
		thunder_binding
			id = THUNDER_BINDING
			name = "Lightning Release: Thunder Binding"
			icon_state = "thunder_binding"
			default_chakra_cost = 400
			default_cooldown = 140
			default_seal_time = 10

			IsUsable(mob/user)
				.=..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				var/mob/human/X = user.MainTarget()
				viewers(user) << output("[user]:<font color =aqua> Lightning Release: Thunder Binding!", "combat_output")

				user.icon_state="Seal"
				user.stunned=99

				var/conmult = user.ControlDamageMultiplier()

				if(X)
					var/obj/thunder_binding_animation/x = new/obj/thunder_binding_animation(locate(X.x+3,X.y+3,X.z))
					var/obj/thunder_binding_animation/z = new/obj/thunder_binding_animation(locate(X.x-3,X.y+3,X.z))
					var/obj/thunder_binding_animation/y = new/obj/thunder_binding_animation(locate(X.x-3,X.y-3,X.z))
					var/obj/thunder_binding_animation/u = new/obj/thunder_binding_animation(locate(X.x+3,X.y-3,X.z))
					sleep(5)
					var/obj/thunder_binding_right/A = new/obj/thunder_binding_right(locate(x.x,x.y,x.z))
					var/obj/thunder_binding_left/S = new/obj/thunder_binding_left(locate(z.x,z.y,z.z))
					var/obj/thunder_binding_left/D = new/obj/thunder_binding_left(locate(y.x,y.y,y.z))
					var/obj/thunder_binding_right/F = new/obj/thunder_binding_right(locate(u.x,u.y,u.z))
					var/obj/blank/H=new/obj/blank(locate(D.x+3,D.y+3,D.z))
					user.stunned=0
					user.icon_state=""
					del(x)
					del(z)
					del(y)
					del(u)

					spawn()

						//middle
						spawn()Electricity(H.x,H.y,H.z,30)
						//nagashi distance
						spawn()Electricity(H.x+1,H.y,H.z,30)
						spawn()Electricity(H.x-1,H.y,H.z,30)
						spawn()Electricity(H.x,H.y+1,H.z,30)
						spawn()Electricity(H.x,H.y-1,H.z,30)
						spawn()Electricity(H.x+1,H.y+1,H.z,30)
						spawn()Electricity(H.x-1,H.y+1,H.z,30)
						spawn()Electricity(H.x+1,H.y-1,H.z,30)
						spawn()Electricity(H.x-1,H.y-1,H.z,30)
						//outer distance
						spawn()Electricity(H.x+2,H.y,H.z,30)
						spawn()Electricity(H.x-2,H.y,H.z,30)
						spawn()Electricity(H.x+2,H.y+1,H.z,30)
						spawn()Electricity(H.x-2,H.y+1,H.z,30)
						spawn()Electricity(H.x+2,H.y-1,H.z,30)
						spawn()Electricity(H.x-2,H.y-1,H.z,30)
						spawn()Electricity(H.x,H.y+2,H.z,30)
						spawn()Electricity(H.x,H.y-2,H.z,30)
						spawn()Electricity(H.x+1,H.y+2,H.z,30)
						spawn()Electricity(H.x+1,H.y-2,H.z,30)
						spawn()Electricity(H.x-1,H.y+2,H.z,30)
						spawn()Electricity(H.x-1,H.y-2,H.z,30)
						spawn()Electricity(H.x+2,H.y+2,H.z,30)
						spawn()Electricity(H.x-2,H.y+2,H.z,30)
						spawn()Electricity(H.x+2,H.y-2,H.z,30)
						spawn()Electricity(H.x-2,H.y-2,H.z,30)

					spawn()AOExk(H.x,H.y,H.z,2,(500+350*conmult),30,user,0,1.5,1)
					Electricity(H.x,H.y,H.z,30)
					spawn(1)
						del(H)
						del(A)
						del(S)
						del(D)
						del(F)
					for(var/turf/New_Turfs/Outside/Wire/w in oview(7))
						spawn()Electricity(w.x,w.y,w.z,50)
						spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
					for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
						spawn()Electricity(e.x,e.y,e.z,50)
						spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
				else
					default_cooldown = 4
					user.combat("Failed due to no target, cooldown is 4")
					return

		kirin
			id = KIRIN
			name = "Lightning Release: Kirin"
			icon_state = "kirin"
			default_chakra_cost = 2500
			default_cooldown = 550
			default_seal_time = 15

			Use(mob/human/user)
				user.stunned=2
				viewers(user) << output("[user]:<font color =aqua>Lightning Release: Kirin!", "combat_output")
				spawn()
					var/mob/human/player/etarget = user.NearestTarget()
					if(etarget==null)
						usr<<"Need a target to Kirin!"
						return
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))
						var/obj/K = new/obj/Kirin(locate(ex,ey+3,ez))
						sleep(3.5)
						step_towards(K,x)
						sleep(3.5)
						step_towards(K,x)
						sleep(3.5)
						step_towards(K,x)
						user.curchakra=50
						user.Dec_Stam(rand(1000,2000),0,user)
						etarget.Dec_Stam(rand(4000,6000),user)
						for(var/turf/t in oview(x,7))
							spawn()Electricity(t.x,t.y,t.z,200)
						spawn()AOExk(x.x,x.y,x.z,6,user.con*2.5+user.conbuff+user.rfx*2+user.rfxbuff,200,user,0,1.5,1)
						Electricity(x.x,x.y,x.z,200)
						spawn(80)
							del(x)
							del(K)
						var/conmult = user.ControlDamageMultiplier()
						for(var/turf/New_Turfs/Outside/Wire/w in oview(7))
							spawn()Electricity(w.x,w.y,w.z,50)
							spawn()AOExk(w.x,w.y,w.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)
						for(var/turf/New_Turfs/Outside/Electricity/e in oview(10))
							spawn()Electricity(e.x,e.y,e.z,50)
							spawn()AOExk(e.x,e.y,e.z,1,(user.con+user.conbuff+conmult/2),50,user,0,1.5,1)

obj/Kirin
	icon='Kirin(smaller).dmi'
	density=0
	New()
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "5",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "6",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "7",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "8",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/Kirin(smaller).dmi',icon_state = "6",pixel_x=32,pixel_y=64)
		..()

obj
	lightning_one
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		New()
			..()
			flick("anime 0,0",src)
	lightning_two
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=32
		New()
			..()
			flick("anime 0,1",src)
	lightning_three
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=64
		New()
			..()
			flick("anime 0,2",src)
obj
	lightning_four
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		density=1
		icon_state="left 0,0"
	lightning_five
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=32
		icon_state="left 0,1"
	lightning_six
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=64
		icon_state="left 0,2"
obj
	lightning_seven
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		density=1
		icon_state="right 0,0"
	lightning_eight
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=32
		icon_state="right 0,1"
	lightning_nine
		icon='icons/binding.dmi'
		layer=MOB_LAYER+1
		pixel_y=64
		icon_state="right 0,2"

obj/blank2
	icon='blank.dmi'


obj/blank
	var
		list/area=new
	New()
		spawn()..()
		spawn()
			area+=new/obj/blank2(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.area)
			del(x)
		..()

obj/thunder_binding_animation
	var
		list/thunder=new
	New()
		spawn()..()
		spawn()
			thunder+=new/obj/lightning_one(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_two(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_three(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.thunder)
			del(x)
		..()
obj/thunder_binding_left
	var
		list/thunder=new
	New()
		spawn()..()
		spawn()
			thunder+=new/obj/lightning_four(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_five(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_six(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.thunder)
			del(x)
		..()
obj/thunder_binding_right
	var
		list/thunder=new
	New()
		spawn()..()
		spawn()
			thunder+=new/obj/lightning_seven(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_eight(locate(src.x,src.y,src.z))
			thunder+=new/obj/lightning_nine(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.thunder)
			del(x)
		..()