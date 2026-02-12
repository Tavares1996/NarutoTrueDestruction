skill
	medic
		face_nearest = 1
		heal
			id = MEDIC
			name = "Medical: Heal"
			icon_state = "medical_jutsu"
			default_chakra_cost = 60
			default_cooldown = 5

			Use(mob/user)
				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					for(var/mob/human/M in get_step(user,user.dir))
						etarget=M
						break

				if(etarget&&(etarget in oview(user,1)))
					var/turf/p=etarget.loc
					user.icon_state="Throw2"

					user.stunned=2
					sleep(20)
					if(etarget && etarget.x==p.x && etarget.y==p.y)
						etarget.overlays+='icons/base_chakra.dmi'
						sleep(3)
						if(!etarget)
							return
						user.icon_state=""
						etarget.overlays-='icons/base_chakra.dmi'
						var/conroll=rand(1,2*(user.con+user.conbuff-user.conneg))
						var/woundroll=rand(round((etarget.curwound)/3),(etarget.curwound))
						if(conroll>woundroll && woundroll)
							var/effect=round(conroll/(woundroll))//*pick(1,2,3)
							if(user.skillspassive[23])effect*=(1 + 0.15*user.skillspassive[23])
							if(effect>etarget.curwound)
								effect=etarget.curwound

							etarget.curwound-=effect
							user.combat("Healed [etarget] [effect] Wound")
							if(etarget.curwound<=0)
								etarget.curwound=0
						else
							user.combat("You failed to do any healing!")
					user.icon_state=""



		heal_wave
			id = MEDIC_WAVE
			name = "Medical: Healing Wave"
			icon_state = "heal_wave"
			default_chakra_cost = 500
			default_cooldown = 60

			Use(mob/user)
				if(!user) return
				for(var/mob/human/player/etarget in oview(3,user))
					if(user && etarget)
						var/turf/p=etarget.loc
						user.icon_state="Throw2"
						user.stunned=20
						spawn(20)
							if(etarget && etarget.x==p.x && etarget.y==p.y)
								etarget.overlays+=image('icons/heal_wave.dmi',icon_state = "1",pixel_x=0,pixel_y=0)
								etarget.overlays+=image('icons/heal_wave.dmi',icon_state = "2",pixel_x=32,pixel_y=0)
								sleep(20)
								if(!etarget)
									return
								user.icon_state=""
								etarget.overlays-=image('icons/heal_wave.dmi',icon_state = "1",pixel_x=0,pixel_y=0)
								etarget.overlays-=image('icons/heal_wave.dmi',icon_state = "2",pixel_x=32,pixel_y=0)
								var/conroll=rand(1,2*(user.con+user.conbuff-user.conneg))
								var/woundroll=rand(round((etarget.curwound)/3),(etarget.curwound))
								if(conroll>woundroll && woundroll)
									var/effect=round(conroll/(woundroll))//*pick(1,2,3)
									if(user.skillspassive[23])effect*=(10 + 0.50*user.skillspassive[23])
									if(effect>etarget.curwound)
										effect=etarget.curwound
									etarget.curwound-=effect
									user.combat("Healed [etarget] [effect] Wound")
									if(etarget.curwound<=0)
										etarget.curwound=0
									etarget.overlays+='icons/heal_wave.dmi'
								else
									user.combat("You failed to do any healing!")
							user.icon_state=""





		poison_mist
			id = POISON_MIST
			name = "Medical: Poison Mist"
			icon_state = "poisonbreath"
			default_chakra_cost = 420
			default_cooldown = 60

			Use(mob/human/user)
				var/mox=0
				var/moy=0
				user.icon_state="Seal"
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
				user.stunned=10
				var/poisoning=1
				var/list/smogs=new()
				var/flagloc
				spawn()
					while(user && poisoning)
						var/list/poi=new()
						for(var/obj/XQ in smogs)
							for(var/mob/human/player/MA in view(0,XQ))
								if(!poi.Find(MA))
									poi+=MA
						for(var/mob/PP in poi)
							var/PEn0r=1 + round(1*user.ControlDamageMultiplier())
							if(PEn0r>5)
								PEn0r=5
							if(PP.protected || PP.ko)
								PEn0r=0
							PP.Poison+=PEn0r
							if(PP.movepenalty<20)
								PP.movepenalty=25
							PP.Hostile(user)

						sleep(10)

				flagloc=locate(user.x+mox,user.y+moy,user.z)

				spawn()
					var/obj/Poison_Poof/S1=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S2=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S3=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S4=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S5=new/obj/Poison_Poof(flagloc)
					smogs+=S1
					smogs+=S2
					smogs+=S3
					smogs+=S4
					smogs+=S5
					if(mox==1||mox==-1)
						spawn() if(S1)S1.Spread(5*mox,6,192,smogs)
						spawn() if(S2)S2.Spread(6.5*mox,4,192,smogs)
						spawn() if(S3)S3.Spread(8*mox,0,192,smogs)
						spawn() if(S4)S4.Spread(5*mox,-6,192,smogs)
						spawn() if(S5)S5.Spread(6.5*mox,-4,192,smogs)
					else
						spawn() if(S1)S1.Spread(6,5*moy,192,smogs)
						spawn() if(S2)S2.Spread(4,6.5*moy,192,smogs)
						spawn() if(S3)S3.Spread(0,8*moy,192,smogs)
						spawn() if(S4)S4.Spread(-6,5*moy,192,smogs)
						spawn() if(S5)S5.Spread(-4,6.5*moy,192,smogs)
				spawn(19)
					flagloc=locate(user.x+mox*2,user.y+moy*2,user.z)
					var/obj/Poison_Poof/S1=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S2=new/obj/Poison_Poof(flagloc)

					var/obj/Poison_Poof/S4=new/obj/Poison_Poof(flagloc)
					var/obj/Poison_Poof/S5=new/obj/Poison_Poof(flagloc)
					smogs+=S1
					smogs+=S2

					smogs+=S4
					smogs+=S5
					if(mox==1||mox==-1)
						spawn()if(S1)S1.Spread(5*mox,6,160,smogs)
						spawn()if(S2)S2.Spread(6.5*mox,4,160,smogs)
						spawn()if(S4)S4.Spread(5*mox,-6,160,smogs)
						spawn()if(S5)S5.Spread(6.5*mox,-4,160,smogs)
					else
						spawn()if(S1)S1.Spread(6,5*moy,160,smogs)
						spawn()if(S2)S2.Spread(4,6.5*moy,160,smogs)
						spawn()if(S4)S4.Spread(-6,5*moy,160,smogs)
						spawn()if(S5)S5.Spread(-4,6.5*moy,160,smogs)

				sleep(40)
				if(user)
					user.stunned=0
					user.icon_state=""
				sleep(80)
				poisoning=0
				for(var/obj/BO in smogs)
					del(BO)




		chakra_scalpel
			id = MYSTICAL_PALM
			name = "Medical: Chakra Scalpel"
			icon_state = "mystical_palm_technique"
			default_chakra_cost = 100
			default_cooldown = 30


			ChakraCost(mob/user)
				if(!user.scalpol)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.scalpol)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				if(user.scalpol)
					user.special=0
					user.scalpol=0
					user.weapon=new/list()
					user.Load_Overlays()
					ChangeIconState("mystical_palm_technique")
				else
					user.combat("This skill requires precison. Wait between attacks for critical damage!")
					user.scalpol=1
					user.overlays+='icons/chakrahands.dmi'
					user.special=/obj/chakrahands
					user.removeswords()
					user.weapon=list('icons/chakraeffect.dmi')
					user.Load_Overlays()
					ChangeIconState("mystical_palm_technique_cancel")




		cherry_blossom_impact
			id = CHAKRA_TAI_RELEASE
			name = "Medical: Cherry Blossom Impact"
			icon_state = "chakra_taijutsu_release"
			default_chakra_cost = 100
			default_cooldown = 10



			Use(mob/human/user)
				user.stunned=1
				user.overlays+='icons/sakurapunch.dmi'
				user.combat("Attack Quickly! Your chakra will drain until you attack.")
				sleep(5)
				user.overlays-='icons/sakurapunch.dmi'
				if(user.stunned<=1)
					user.stunned=0
				user.sakpunch=1
				sleep(10)
				spawn()
					while(user && user.sakpunch && user.curchakra>100)
						user.curchakra-=100
						sleep(10)
					if(user) user.sakpunch=0




		body_disruption_stab
			id = IMPORTANT_BODY_PTS_DISTURB
			name = "Medical: Body Disruption Stab"
			icon_state = "important_body_ponts_disturbance"
			default_chakra_cost = 100
			default_cooldown = 180

			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 2)
						Error(user, "Target too far ([distance]/2 tiles)")
						return 0


			Use(mob/human/user)
				var/mob/human/player/etarget = user.NearestTarget()
				var/CX=rand(1,(user.con+user.conbuff-user.conneg))
				if(!etarget) return
				else
					var/Cx=rand(1,(etarget.con+etarget.conbuff-etarget.conneg))
					if(CX>Cx)
						user.combat("Nervous system disruption succeeded!")
						etarget.combat("Your nervous system has been attacked, you are unable to control your muscles!")
						etarget.overlays+='icons/disturbance.dmi'
						spawn(20)
							etarget.overlays-='icons/disturbance.dmi'
						etarget.movement_map = list()
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						var/list/dirs2 = dirs.Copy()
						for(var/orig_dir in dirs)
							var/new_dir = pick(dirs2)
							dirs2 -= new_dir
							etarget.movement_map["[orig_dir]"] = new_dir
						spawn(600)
							if(etarget) etarget.movement_map = null
					else
						user.combat("Nervous system disruption failed!")




		creation_rebirth
			id = PHOENIX_REBIRTH
			name = "Medical: Creation Rebirth"
			icon_state = "pheonix_rebirth"
			default_chakra_cost = 800
			default_cooldown = 1200
			copyable = 0



			Use(mob/human/user)
				user.protected=10
				user.icon_state="hurt"
				user.overlays+='icons/rebirth.dmi'
				user.stunned+=3
				spawn(30)
					user.overlays-='icons/rebirth.dmi'
					user.protected=0
					user.icon_state=""
				sleep(30)
				if(!user.ko)
					var/oldwound=user.curwound
					user.curwound-=100
					if(user.curwound<0)
						user.curwound=0
					var/oldstam=user.curstamina
					user.curstamina=round(user.stamina*1.25)
					user.combat("[oldwound-user.curwound] Wounds and [user.curstamina - oldstam] Stamina healed!")




		poisoned_needles
			id = POISON_NEEDLES
			name = "Medical: Poisoned Needles"
			icon_state = "poison_needles"
			default_supply_cost = 5
			default_cooldown = 60
			face_nearest = 0



			Use(mob/human/user)
				user.icon_state="Throw1"
				user.stunned=10
				sleep(5)
				var/list/hit=new
				var/oX=0
				var/oY=0
				var/devx=0
				var/devy=0
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))
				if(user.dir==NORTH)
					oY=1
					devx=8
				if(user.dir==SOUTH)
					oY=-1
					devx=8
				if(user.dir==EAST)
					oX=1
					devy=8
				if(user.dir==WEST)
					oX=-1
					devy=8
				spawn()
					if(user)
						hit+=advancedprojectile_returnloc(/obj/needle,user,(32*oX),(32*oY),5,100,user.x,user.y,user.z)
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +devx,32*oY + devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +1.5*devx,32*oY + 1.5*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +-1*devx,32*oY + -1*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +-1.5*devx,32*oY + -1.5*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				sleep(5)
				if(user)
					user.stunned=0
					user.icon_state=""
				spawn(20)
					for(var/mob/human/M in hit)
						spawn()
							if(M && !M.ko && !M.protected && M!=user)
								M.Poison+=rand(4,8)
								M.Dec_Stam(500,user)
								M.Hostile(user)




obj
	chakrahands
		icon='icons/chakrahands.dmi'
		layer=FLOAT_LAYER




	Poison_Poof
		proc
			PixelMove(dpixel_x, dpixel_y, list/smogs)
				var/new_pixel_x = pixel_x + dpixel_x
				var/new_pixel_y = pixel_y + dpixel_y


				while(abs(new_pixel_x) > 16)
					var/kloc = loc
					if(new_pixel_x > 16)
						new_pixel_x -= 32
						var/Phail=0

						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						x++

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

					else if(new_pixel_x < -16)
						new_pixel_x += 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						x--

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

				while(abs(new_pixel_y) > 16)
					var/kloc = loc
					if(new_pixel_y > 16)
						new_pixel_y -= 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						y++

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

					else if(new_pixel_y < -16)
						new_pixel_y += 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						y--

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc)

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
