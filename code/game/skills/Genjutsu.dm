mob/var/using_crow = 0
skill
	genjutsu
		temple_of_nirvana
			id = SLEEP_GENJUTSU
			name = "Genjutsu: Temple of Nirvana"
			icon_state = "sleep_genjutsu"
			default_chakra_cost = 250
			default_cooldown = 200

			Use(mob/user)
				user.icon_state = "Seal"
				user.stunned = 5
				spawn(50)
					user.icon_state = ""

				var/mob/human/target = user.MainTarget()
				var/turf/center = user.loc

				if(target)
					center = target.loc

				if(center)
					var/r = limit(1, round((user.int+user.intbuff-user.intneg)/75) + 1, 5)
					var/images[0]
					var/area[0]

					for(var/turf/T in range(center, r))
						images += image('icons/genjutsu2.dmi', T)
						area += T

					for(var/image/I in images)
						world << I

					var/resisted[0]
					var/failed_resist[0]

					var/time = 10
					while(time > 0)
						sleep(1)
						for(var/mob/human/M in range(center, r))
							if(M.isguard && M.skillspassive[21] && !(M in failed_resist))
								var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(M.con+M.conbuff-M.conneg)*(1 + 0.05*(M.skillspassive[21]-1)),100)
								if(resist_roll < 4)
									resisted += M
								else
									failed_resist += M
						--time

					for(var/mob/human/M in range(center, r))
						if(M != user && !(M in resisted))
							M.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							flick("Knockout", M)
							M.icon_state = "Dead"
							M.asleep = 1
							M.stunned = 20
							spawn()
								while(M && M.stunned>0 && M.asleep)
									sleep(1)
								if(M)
									M.icon_state=""
									M.asleep=0


					for(var/image/I in images)
						del I




		fear
			id = PARALYZE_GENJUTSU
			name = "Genjutsu: Fear"
			icon_state = "paralyse_genjutsu"
			default_chakra_cost = 100
			default_cooldown = 60

			Use(mob/user)
				user.icon_state = "Seal"
				user.stunned = 2
				sleep(20)
				user.icon_state = ""

				user.FilterTargets()
				for(var/mob/human/T in user.targeted_by)
					if(T in oview(user))
						var/image/o = image('icons/genjutsu.dmi' ,T)
						T << o
						user << o
						var/result=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(T.int+T.intbuff-T.intneg)*(1 + 0.05*T.skillspassive[19]),100)
						T.FilterTargets()
						if(!(user in T.active_targets))
							--result
						if(T.skillspassive[21] && T.isguard)
							var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(T.con+T.conbuff-T.conneg)*(1 + 0.05*(T.skillspassive[21]-1)),100)
							if(resist_roll < 4)
								result = 1
						if(result >= 6)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 100
						if(result == 5)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 80
						if(result == 4)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 50
						if(result == 3)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 30
						if(result == 2)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 10
						spawn()
							while(T && T.move_stun > 0 && T.icon_state != "ko")
								sleep(1)
							del(o)


		shackling_stakes
			id = STAKES_GENJUTSU
			name = "Demonic Illusion: Shackling Stakes Technique"
			icon_state = "stakes"
			default_chakra_cost = 400
			default_cooldown = 180

			Use(mob/user)
				user.icon_state = "Seal"
				user.stunned = 99
				sleep(15)
				user.icon_state = ""
				user.stunned=0
				user.FilterTargets()
				for(var/mob/human/T in user.targeted_by)
					if(T in oview(user))
						var/image/o = image('icons/genjutsuitachi.dmi' ,T)
						T << o
						user << o
						var/result=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(T.int+T.intbuff-T.intneg)*(1 + 0.05*T.skillspassive[19]),100)
						T.FilterTargets()
						if(!(user in T.active_targets))
							--result
						if(T.skillspassive[21] && T.isguard)
							var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(T.con+T.conbuff-T.conneg)*(1 + 0.05*(T.skillspassive[21]-1)),100)
							if(resist_roll < 4)
								result = 1
						if(result >= 6)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.stunned = 10
						if(result == 5)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.stunned = 8
						if(result == 4)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.stunned = 5
						if(result == 3)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.stunned = 3
						if(result == 2)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.stunned = 1
						spawn()
							while(T && T.stunned > 0 && T.icon_state != "ko")
								sleep(1)
							del(o)



		darkness
			id = DARKNESS_GENJUTSU
			name = "Genjutsu: Darkness"
			icon_state = "darkness"
			default_chakra_cost = 800
			default_cooldown = 280

			Use(mob/user)
				user.icon_state="Seal"
				spawn(20)
					user.icon_state=""
				var/mob/human/etarget = user.MainTarget()
				if(etarget)
					var/result=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(etarget.int+etarget.intbuff-etarget.intneg)*(1 + 0.05*etarget.skillspassive[19]),80)
					if(etarget.skillspassive[21] &&etarget.isguard)
						var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(etarget.con+etarget.conbuff-etarget.conneg)*(1 + 0.05*(etarget.skillspassive[21]-1)),100)
						if(resist_roll < 4)
							result = 1
					var/image/I = image('icons/shroud.dmi',etarget)
					user<<I
					var/d=0
					if(result>=6)
						d=60
					if(result==5)
						d=30
					if(result==4)
						d=20
					if(result==3)
						d=16
					if(result==2)
						d=10
					if(d > 0)
						etarget.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
						etarget.sight=(BLIND|SEE_SELF|SEE_OBJS)
						spawn(d*10)
							if(etarget) etarget.sight=0
							del(I)

		crow
			id = CROW_GENJUTSU
			name = "Crow Genjutsu"
			icon_state = "crow_depart"
			default_cooldown = 200
			default_chakra_cost = 200

			Use(mob/user)
				if(!user) return
				user.using_crow = 1



		illusion
			id = ILLUSION_GENJUTSU
			name = "Genjutsu: Illusion"
			icon_state = "illusion"
			default_cooldown = 300
			default_chakra_cost = 600

			Use(mob/user)
				user.icon_state="Seal"
				user.stunned=30
				var/illusion_success=0
				var/obj/Illusion/x=new/obj/Illusion(user.loc)
				sleep(5)
				var/mob/human/X = user.NearestTarget()
				var/image/Y = image('icons/genjutsu_icon.dmi',X)
				for(var/mob/human/C in range(10,X))
					if(user&&X)
						var/result=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(X.int+X.intbuff-X.intneg)*(1 + 0.05*X.skillspassive[19]),80)
						var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(X.con+X.conbuff-X.conneg)*(1 + 0.05*(X.skillspassive[21]-1)),100)
						if(resist_roll < 4)
							X << "You have escaped the illusion genjutsu"
							user << "One of your targets has escaped your genjutsu"
							result = 1
							user.stunned=0
							user.icon_state=""
							del(Y)
							del(x)
							break

						X << Y
						user << Y

						if(result>=6)
							X.move_stun=100
							illusion_success=60
							X.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							del(x)

						if(result==5)
							X.move_stun=80
							illusion_success=50
							X.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							del(x)

						if(result==4)
							X.move_stun=60
							illusion_success=40
							X.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							del(x)

						if(result==3)
							X.move_stun=40
							illusion_success=30
							X.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							del(x)

						if(result==2)
							X.move_stun=20
							illusion_success=20
							X.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							del(x)

						spawn(illusion_success/3)
							if(X in oview(10,user)&&user&&X)
								del(x)
								del(Y)
								var/image/M = image('icons/genjutsuillusion.dmi',X)
								var/b

								X << M
								user << M

								if(illusion_success==40)
									b = illusion_success
									X.stunned=illusion_success/10
								if(illusion_success==30)
									b = illusion_success
									X.stunned=illusion_success/10
								if(illusion_success==20)
									b = illusion_success
									X.stunned=illusion_success/10
								if(illusion_success==15)
									b = illusion_success
									X.stunned=illusion_success/10
								if(illusion_success==10)
									b = illusion_success
									X.stunned=illusion_success/10

								if(b > 0)
									spawn(b/2)
										user.stunned=0
										user.icon_state=""
									X.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
									X.sight=(BLIND|SEE_SELF|SEE_OBJS)
									spawn()
										while(X.stunned > 0&&user)
											if(X.ko||X.stunned<=0&&X)
												del(M)
												del(Y)
												X.sight=0
												illusion_success=0
												break
											return
										if(!X||!user)
											del(M)
											del(Y)
											X.sight=0
											illusion_success=0

								else
									user << "The target has escaped your grasp"
									illusion_success=0
									user.stunned=0
									user.icon_state=""
									del(Y)
					else
						user.combat("No target has been found")
						return


		tree_bind
			id = TREE_BIND
			name = "Genjutsu: Tree Binding"
			icon_state = "tree bind"
			default_chakra_cost = 350
			default_cooldown = 340

			Use(mob/user)
				viewers(user) << output("[user]: Tree Binding!", "combat_output")
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					var/obj/tree_binding/x=new/obj/tree_binding(etarget.loc)
					etarget.overlays+=image(icon='icons/tree bind.dmi',icon_state="bind")
					etarget.stunned=9999
					spawn(50)
						del(x)
						etarget.stunned=0
						etarget.overlays-=image(icon='icons/tree bind.dmi',icon_state="bind")
obj/tree_binding
	density=0
	icon='icons/tree binding.dmi'


obj/Illusion
	New(loc)
		..(loc)
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "1",pixel_x = -32)
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "2")
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "3",pixel_x = 32)
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "4",pixel_x = -32,pixel_y = 32)
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "5",pixel_y = 32)
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "6",pixel_x = 32,pixel_y = 32)
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "7",pixel_x = -32,pixel_y = 64)
		overlays += image(icon = 'icons/illusion.dmi',icon_state = "8",pixel_y = 64)