mob/var
	AmaterasuOn=0
	MangOn=0
	Intangibilty=0
	eye_collection=0
	izanagi_active
	InSusanoo=0
	DefenceSusanoo=1000
	SusanooHP=15000
	INSASUKESUSANOO=0
	usingamat = 0
	InFlames = 0
	controlling=0
	kotoactive=0

var
	AmaterasusOut=0
	AmaterasusOutMax=200

obj/var
	IsAma=0
	Acooldown=0
	AOwner
	Arandom=0

obj
	amatburn
		icon='icons/Ama-burn.dmi'
		layer=MOB_LAYER+3
		density=0
var/AMATERASUTEXT="Black Fire"

obj
	amatblob
		icon='icons/ama-blob.dmi'
		layer=MOB_LAYER+3
		density=0

skill
	uchiha
		copyable = 0

		sharingan_1
			id = SHARINGAN1
			name = "Sharingan: Tomoe 2"
			icon_state = "sharingan1"
			default_chakra_cost = 150
			default_cooldown = 250

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0
			Cooldown(mob/user)
				return default_cooldown
			Use(mob/user)
				viewers(user) << output("[user]: Sharingan!", "combat_output")
				user.sharingan=1
				var/buffrfx=round(user.rfx*0.25)
				var/buffint=round(user.int*0.25)
				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)
					user.special=0
					user.sharingan=0
					user.Affirm_Icon()
					user.combat("Your sharingan deactivates.")

		sharingan_2
			id = SHARINGAN2
			name = "Sharingan: Tomoe 3"
			icon_state = "sharingan2"
			default_chakra_cost = 350
			default_cooldown = 350

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0
			Cooldown(mob/user)
				return default_cooldown
			Use(mob/user)
				viewers(user) << output("[user]: Sharingan!", "combat_output")
				user.sharingan=1
				var/buffrfx=round(user.rfx*0.33)
				var/buffint=round(user.int*0.33)
				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)
					user.special=0
					user.sharingan=0
					user.Affirm_Icon()
					user.combat("Your sharingan deactivates.")

		sharingan_copy
			id = SHARINGAN_COPY
			name = "Sharingan Copy"
			icon_state = "sharingancopy"
			var
				skill/copied_skill
			Activate(mob/user)
				if(copied_skill)
					return copied_skill.Activate(user)
				else
					Error(user, "You do not have a copied skill.")
					return 0
			IconStateChanged(skill/sk, new_state)
				if(sk == copied_skill)
					ChangeIconState(new_state)
			proc
				CopySkill(id)
					var/skill_type = SkillType(id)
					var/skill/skill
					if(!skill_type)
						skill = new /skill()
						skill.id = id
						skill.name = "Unknown Skill ([id])"
					else
						skill = new skill_type()
					skill.master = src
					copied_skill = skill
					icon_overlays = list(icon('icons/gui_badges.dmi', "sharingan_copy"))
					icon = skill.icon
					icon_state = skill.icon_state
					for(var/skillcard/card in skillcards)
						card.icon = icon
						card.icon_state = icon_state
						card.overlays = icon_overlays
					return skill

/*-------------------------Mangekyou Sharingan---------------------------*/


		mangekyou_itachi
			id = ITACHI_MANGEKYOU
			name = "Mangekyou Sharingan"
			icon_state = "mangekyouI"
			default_chakra_cost = 500
			default_cooldown = 450

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Mangekyou Sharingan!", "combat_output")
				user.sharingan=4
				user.mangekyouU++
				if(user.mangekyouU>=50)
					spawn(rand(100, 500))
						while(user && user.sharingan == 4)
							sleep(2)
							if(prob(user.mangekyouU/4)&&user)
								user.sight = (BLIND|SEE_SELF)
								sleep(rand(10, 30))
								if(user)
									user.sight = 0
							sleep(2)
				var/buffrfx=round(user.rfx*0.40)
				var/buffint=round(user.int*0.55)
				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()
				spawn()
					var/time = 300
					while(user && user.sharingan == 4 && time > 0)
						time--
						sleep(10)
					if(user && user.sharingan == 4 && time == 0)
						user.rfxbuff-=round(buffrfx)
						user.intbuff-=round(buffint)
						user.special=0
						user.sharingan=0
						user.Affirm_Icon()
						user.combat("You lose control over your mangekyou sharingan.")

		mangekyou_sasuke
			id = SASUKE_MANGEKYOU
			name = "Mangekyou Sharingan"
			icon_state = "mangekyouS"
			default_chakra_cost = 500
			default_cooldown = 450

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Mangekyou Sharingan!", "combat_output")
				user.sharingan=4
				user.mangekyouU++
				if(user.mangekyouU>=50)
					spawn(rand(100, 500))
						while(user && user.sharingan == 4)
							sleep(2)
							if(prob(user.mangekyouU/4)&&user)
								user.sight = (BLIND|SEE_SELF)
								sleep(rand(10, 30))
								if(user)
									user.sight = 0
							sleep(2)
				var/buffrfx=round(user.rfx*0.55)
				var/buffcon=round(user.con*0.40)
				user.rfxbuff+=buffrfx
				user.conbuff+=buffcon
				user.Affirm_Icon()
				spawn()
					var/time = 300
					while(user && user.sharingan == 4 && time > 0)
						time--
						sleep(10)
					if(user && user.sharingan == 4 && time == 0)
						user.rfxbuff-=round(buffrfx)
						user.conbuff-=round(buffcon)
						user.special=0
						user.sharingan=0
						user.Affirm_Icon()
						user.combat("You lose control over your mangekyou sharingan.")

/*--------------------Itachi Mangekyou Moves------------------------------*/

		Tsukuyomi
			id = TSUKUYOMI
			name = "Left Eye of the Moon: Tsukuyomi"
			icon_state = "Tsukuyomi"
			default_chakra_cost = 500
			default_cooldown = 200

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.sharingan >= 4)
						Error(user, "Mangekyou Sharingan is required to use this skill")
						return 0

			Use(mob/user)
				user.mangekyouU++
				if(user.sharingan==5)
					user.mangekyouU--
				user.icon_state="Seal"
				spawn(20)
					user.icon_state=""
				oviewers(user) << output("[user]: Tsukuyomi!", "combat_output")
				var/mob/human/etarget = user.MainTarget()
				if(etarget)
					var/result=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(etarget.int+etarget.intbuff-etarget.intneg)*(1 + 0.05*etarget.skillspassive[19]),80)
					if(etarget.skillspassive[21] &&etarget.isguard)
						var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(etarget.con+etarget.conbuff-etarget.conneg)*(1 + 0.05*(etarget.skillspassive[21]-1)),100)
						if(resist_roll < 4)
							result = 1
					var/d=0
					if(result>=6)
						d=30
					if(result==5)
						d=25
					if(result==4)
						d=20
					if(result==3)
						d=10
					if(result==2)
						d=5
					if(result==1)
						usr << "<font color=red size=4>You have failed to use tsukuyomi on [etarget]"
					if(d > 0)
						etarget.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
						etarget.sight=(BLIND|SEE_SELF|SEE_OBJS)
						etarget.stunned=8
						etarget.underlays+='icons/tsukuyomi.dmi'
						spawn()
							while(d > 0&&user&&etarget)
								d--
								sleep(10)
								if(!etarget||!user)
									d=0
							if(d <= 0)
								etarget.sight=0
								etarget.stunned=0
								etarget.underlays-='icons/tsukuyomi.dmi'

		Amaterasu
			id = AMATERASU
			name = "Right Eye of the Sun: Amaterasu"
			icon_state = "amaterasu"
			default_chakra_cost = 1500
			default_cooldown = 180

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.sharingan >= 4)
						Error(user, "Mangekyou Sharingan is required to use this skill")
						return 0

			Use(mob/human/user)
				user.mangekyouU++
				if(user.sharingan==5)
					user.mangekyouU--
				if (!user) return
				user.usingamat = 1
				viewers(user) << output("[user]'s right eye bleeds...","combat_output")
				sleep(rand(5,15))
				viewers(user) << output("[user]: Amaterasu!", "combat_output")
				var
					Burning = 0
					obj/C = new/obj/amatblob(locate(user.x, user.y, user.z))
					list/Owner = new
					mob/T = user.MainTarget()
					obj/O = /obj/amatburn
					Cx = user.ControlDamageMultiplier()
				Owner += C
				sleep(1)
				flick(C, user)
				C.dir = get_dir(C, T)
				sleep(1)
				del(C)
				if(T)
					var/obj/ROX = new/obj/amatburn(locate(T.x , T.y , T.z))
					ROX.owner = user
					T.overlays += O
					T.InFlames = 1
					Burning = rand(1, 2) + rand(0, 1)
					spawn()
						for(T)
							while(T.InFlames && Burning > 0 && T && !T.ko)
								sleep(rand(1,2))
								T.Wound(rand(4, 10))
								sleep(1)
								T.Dec_Stam(rand(200, 1000) + rand(100, 250) * Cx)
								sleep(1)
								T.Hostile(user)
								sleep(1)
								T.movepenalty += pick(5, 20)
								sleep(10)
								Burning -= 1
								user.Wound(rand(2, 4))
								sleep(5)
								user.curstamina -= rand(300, 700)
								if(Burning == 0 || Burning <= 0 || T.ko)
									user.usingamat = 0
									T.InFlames = 0
									T.overlays -= O
									viewers(user) << output("[user] closes his right eye." , "combat_putput")
									for(C in Owner)
										if( C )
											C.loc = null
									for(ROX in world)
										if(ROX.owner == user)
											ROX.loc = null
											ROX.icon = 0
											ROX.icon_state = 0
				else
					user.combat("There was no target, jutsu cancelled itself")
					default_cooldown = 10
					return

/*----------------------------Sasuke Mangekyou Moves-------------------------------*/

		Amaterasu_AOE
			id = AMATERASU_AOE
			name = "Amaterasu"
			icon_state = "AmaterasuAOE"
			default_chakra_cost = 1500
			default_cooldown = 200

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.sharingan >= 4)
						Error(user, "Mangekyou Sharingan is required to use this skill")
						return 0

			Use(mob/human/user)
				user.mangekyouU++
				if(user.sharingan==5)
					user.mangekyouU--
				viewers(user) << output("[user]'s right eye bleeds...","combat_output")
				sleep(rand(5,15))
				viewers(user) << output("[user]: Amaterasu!", "combat_output")
				var/atom/found = user
				if(!found) return

				var/mob/human/etarget = user.MainTarget()
				var/obj/Q = new/obj/amatblob(locate(found.x,found.y,found.z))

				var/steps = 100
				while(steps > 0 && etarget && Q && (Q.x!=etarget.x || Q.y!=etarget.y) && Q.z==etarget.z && user)
					sleep(1)
					step_to(Q, etarget)
					--steps

				if(!etarget)
					Q.loc = null
					return
				if(!Q) return
				Q.icon_state="none"
				sleep(0)
				if(!etarget)
					Q.loc = null
					return
				if(!Q) return

				var/list/EX=new
				EX+=new/obj/amatburn(locate(Q.x,Q.y,Q.z))

				var/turf/P = Q.loc

				Q.loc = null
				Q = null

				for(var/obj/M in EX)
					M.Facedir(P)

				sleep(0)

				var/amat_hit = 0
				while(!amat_hit)
					for(var/obj/M in EX)
						if((M.x!=P.x) || (M.y!=P.y))
							step_to(M,P,0)
						else
							amat_hit = 1

					sleep(0)

				for(var/obj/M in EX)
					if(M)
						M.icon='icons/Ama-burn.dmi'

				sleep(1)

				if(!user)
					for(var/obj/O in EX)
						O.loc = null
					return

				var/conmult = user.ControlDamageMultiplier()

				for(var/mob/human/O in P)
					O.stunned+=3
					O.Dec_Stam((rand(1000,700)+700*conmult),0,user)
					O.Wound(rand(0,25),0,user)
					O.Hostile(user)
					user.Wound(rand(10,25),0,user)
					Blood2(user,user)
					viewers(user) << output("[user] closes his right eye." , "combat_putput")
					break

				for(var/mob/human/O in oview(1,P))
					O.Dec_Stam((rand(1000,500)+700*conmult),0,user)
					O.Hostile(user)
					O.Wound(rand(0,25),0,user)
					user.Wound(rand(10,25),0,user)
					Blood2(user,user)
					viewers(user) << output("[user] closes his right eye." , "combat_putput")
					break

				spawn(30)
					for(var/obj/O in EX)
						O.loc = null

		inferno_style
			id = INFERNO_STYLE
			name = "Inferno Style: Flame Control"
			icon_state = "flame_control"
			default_chakra_cost = 450
			default_cooldown = 70

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.sharingan >= 4)
						Error(user, "Sasuke Mangekyou is required to use this skill")
						return 0

			Use(mob/user)
				if(user)
					user.mangekyouU++
					var/burning=0
					viewers(user) << output("[user]: Inferno Style Flame Control!", "combat_output")
					flick("Seal",user)
					user.stunned=1
					var/obj/trailmaker/o=new/obj/trailmaker/Inferno()
					var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,7,user)
					if(result)
						burning=rand(3,6)
						spawn(60)
							del(o)
						spawn()
							while(burning>0&&o in world)
								sleep(5)
								result.Dec_Stam(280*user:ControlDamageMultiplier(),1,user)
								result.Wound(rand(0,2),0,user)
								spawn()Blood2(result)
								burning--
								if(!o in world||burning<=0)
									spawn()result.Hostile(user)
									burning=0
									if(o in world)
										del(o)
									break

/*-----------------------------Itachi Susanoo----------------------------------------*/

		Susanoo
			id = ITACHI_SUSANOO
			name = "Susanoo The God Of Storm"
			icon_state = "susanoo itachi"
			default_chakra_cost = 2000
			default_cooldown = 400
			var/used_chakra

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.sharingan >= 4)
						Error(user, "Sasuke Mangekyou is required to use this skill")
						return 0

			ChakraCost(mob/user)
				used_chakra = user.curchakra
				if(used_chakra > default_chakra_cost)
					return used_chakra
				else
					return default_chakra_cost

			Use(mob/human/user)
				user.mangekyouU++
				viewers(user) << output("[user]: Get ready to witness destruction!", "combat_output")
				user.overlays+=image('icons/itachi aura.dmi')
				user.stunned=10
				sleep(20)
				user.stunned=0
				viewers(user) << output("[user]: Susanoo!", "combat_output")
				var/buffint=round(user.int*0.50)
				var/buffrfx=round(user.rfx*0.40)
				var/buffcon=round(user.con*0.40)
				user.InSusanoo=1
				user.overlays+=image('itachi susanoo.dmi',icon_state="0,0",pixel_x=-64)
				user.overlays+=image('itachi susanoo.dmi',icon_state="1,0",pixel_x=-32)
				user.overlays+=image('itachi susanoo.dmi',icon_state="2,0")
				user.overlays+=image('itachi susanoo.dmi',icon_state="3,0",pixel_x=32)
				user.overlays+=image('itachi susanoo.dmi',icon_state="4,0",pixel_x=64)
				user.overlays+=image('itachi susanoo.dmi',icon_state="0,1",pixel_x=-64,pixel_y=32)
				user.overlays+=image('itachi susanoo.dmi',icon_state="1,1",pixel_x=-32,pixel_y=32)
				user.overlays+=image('itachi susanoo.dmi',icon_state="2,1",pixel_y=32)
				user.overlays+=image('itachi susanoo.dmi',icon_state="3,1",pixel_x=32,pixel_y=32)
				user.overlays+=image('itachi susanoo.dmi',icon_state="1,2",pixel_x=-32,pixel_y=64)
				user.overlays+=image('itachi susanoo.dmi',icon_state="2,2",pixel_y=64)
				user.overlays+=image('itachi susanoo.dmi',icon_state="3,2",pixel_x=32,pixel_y=64)
				user.DefenceSusanoo=100
				user.intbuff+=buffint
				user.rfxbuff+=buffrfx
				user.conbuff+=buffcon
				user.SusanooHP=user.stamina
				user.SusanooHP+=user.stamina
				user.SusanooHP+=user.chakra
				user.SusanooHP+=user.chakra
				viewers(user) << output("[user] has got [user.SusanooHP] Susanoo defence!", "combat_output")
				var/time=45
				spawn()
					while(time > 0 && !user.SusanooHP==0)
						sleep(10)
						if(prob(40))
							user.Wound(rand(0,2), 0,user)
						user.intbuff-=rand(1,2)
						user.rfxbuff-=rand(1,2)
						user.conbuff-=rand(1,2)
						if(prob(5))
							spawn()Blood2(user,user)
						time--
				if(time<=0 || user.InSusanoo == 0 || user.ko || !user.sharingan==4 || !user.sharingan==5)
					if(user)
						user.InSusanoo=0
						user.SusanooHP=7500
						user.rfxbuff-=buffrfx
						user.intbuff-=buffint
						user.conbuff-=buffcon
						user.overlays-=image('itachi susanoo.dmi',icon_state="0,0",pixel_x=-64)
						user.overlays-=image('itachi susanoo.dmi',icon_state="1,0",pixel_x=-32)
						user.overlays-=image('itachi susanoo.dmi',icon_state="2,0")
						user.overlays-=image('itachi susanoo.dmi',icon_state="3,0",pixel_x=32)
						user.overlays-=image('itachi susanoo.dmi',icon_state="4,0",pixel_x=64)
						user.overlays-=image('itachi susanoo.dmi',icon_state="0,1",pixel_x=-64,pixel_y=32)
						user.overlays-=image('itachi susanoo.dmi',icon_state="1,1",pixel_x=-32,pixel_y=32)
						user.overlays-=image('itachi susanoo.dmi',icon_state="2,1",pixel_y=32)
						user.overlays-=image('itachi susanoo.dmi',icon_state="3,1",pixel_x=32,pixel_y=32)
						user.overlays-=image('itachi susanoo.dmi',icon_state="1,2",pixel_x=-32,pixel_y=64)
						user.overlays-=image('itachi susanoo.dmi',icon_state="2,2",pixel_y=64)
						user.overlays-=image('itachi susanoo.dmi',icon_state="3,2",pixel_x=32,pixel_y=64)
						user.overlays-=image('icons/itachi aura.dmi')

/*-----------------------------Sasuke Susanoo----------------------------------------*/

		Susanoo_Sasuke
			id = SASUKE_SUSANOO
			name = "Susanoo"
			icon_state = "sasukesusanoo"
			default_chakra_cost = 2000
			default_cooldown = 400
			var/used_chakra

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.sharingan >= 4)
						Error(user, "Sasuke Mangekyou is required to use this skill")
						return 0

			ChakraCost(mob/user)
				used_chakra = user.curchakra
				if(used_chakra > default_chakra_cost)
					return used_chakra
				else
					return default_chakra_cost

			Use(mob/human/user)
				user.mangekyouU++
				viewers(user) << output("[user]: Time to feel my hatred!", "combat_output")
				user.overlays+=image('icons/sasukeaura.dmi')
				user.stunned=10
				sleep(20)
				user.stunned=0
				viewers(user) << output("[user]: Susanoo!", "combat_output")
				var/buffint=round(user.int*0.30)
				var/buffrfx=round(user.rfx*0.60)
				var/buffcon=round(user.con*0.40)
				user.InSusanoo=1
				user.INSASUKESUSANOO=1
				user.overlays+=image('sasukecomplete.dmi',icon_state="s1",pixel_x=-80)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s2",pixel_x=-48)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s3",pixel_x=-16)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s4",pixel_x=16)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s5",pixel_x=48)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s6",pixel_x=80)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s7",pixel_x=112)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s8",pixel_x=-80,pixel_y=32)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s9",pixel_x=-48,pixel_y=32)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s10",pixel_x=-16,pixel_y=32)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s11",pixel_x=16,pixel_y=32)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s12",pixel_x=48,pixel_y=32)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s13",pixel_x=80,pixel_y=32)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s14",pixel_x=112,pixel_y=32)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s15",pixel_x=-80,pixel_y=64)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s16",pixel_x=-48,pixel_y=64)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s17",pixel_x=-16,pixel_y=64)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s18",pixel_x=16,pixel_y=64)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s19",pixel_x=48,pixel_y=64)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s20",pixel_x=80,pixel_y=64)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s21",pixel_x=-80,pixel_y=96)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s22",pixel_x=-48,pixel_y=96)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s23",pixel_x=-16,pixel_y=96)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s24",pixel_x=16,pixel_y=96)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s25",pixel_x=48,pixel_y=96)
				user.overlays+=image('sasukecomplete.dmi',icon_state="s26",pixel_x=80,pixel_y=96)
				user.DefenceSusanoo=100
				user.intbuff+=buffint
				user.rfxbuff+=buffrfx
				user.conbuff+=buffcon
				user.SusanooHP=user.stamina
				user.SusanooHP+=user.stamina
				user.SusanooHP+=user.chakra
				user.SusanooHP+=user.chakra
				viewers(user) << output("[user] has got [user.SusanooHP] Susanoo defence!", "combat_output")
				var/time=45
				spawn()
					while(time > 0 && !user.SusanooHP==0)
						sleep(10)
						if(prob(40))
							user.Wound(rand(0,2), 0,user)
						if(user)
							user.intbuff-=rand(1,2)
							user.rfxbuff-=rand(1,2)
							user.conbuff-=rand(1,2)
						if(prob(5))
							spawn()Blood2(user,user)
						time--
				if(time<=0 || user.InSusanoo == 0 || user.ko || !user.sharingan==4 || !user.sharingan==5)
					if(user)
						user.InSusanoo=0
						user.SusanooHP=7500
						user.INSASUKESUSANOO=0
						user.rfxbuff-=buffrfx
						user.intbuff-=buffint
						user.conbuff-=buffcon
						user.overlays-=image('sasukecomplete.dmi',icon_state="s1",pixel_x=-80)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s2",pixel_x=-48)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s3",pixel_x=-16)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s4",pixel_x=16)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s5",pixel_x=48)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s6",pixel_x=80)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s7",pixel_x=112)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s8",pixel_x=-80,pixel_y=32)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s9",pixel_x=-48,pixel_y=32)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s10",pixel_x=-16,pixel_y=32)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s11",pixel_x=16,pixel_y=32)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s12",pixel_x=48,pixel_y=32)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s13",pixel_x=80,pixel_y=32)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s14",pixel_x=112,pixel_y=32)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s15",pixel_x=-80,pixel_y=64)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s16",pixel_x=-48,pixel_y=64)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s17",pixel_x=-16,pixel_y=64)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s18",pixel_x=16,pixel_y=64)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s19",pixel_x=48,pixel_y=64)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s20",pixel_x=80,pixel_y=64)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s21",pixel_x=-80,pixel_y=96)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s22",pixel_x=-48,pixel_y=96)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s23",pixel_x=-16,pixel_y=96)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s24",pixel_x=16,pixel_y=96)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s25",pixel_x=48,pixel_y=96)
						user.overlays-=image('sasukecomplete.dmi',icon_state="s26",pixel_x=80,pixel_y=96)
						user.overlays-=image('icons/sasukeaura.dmi')

//----------------------------Danzou--------------------------\\


		izanagi
			id = IZANAGI
			name="Kinjutsu: Izanagi"
			icon_state="izanagi"
			default_chakra_cost=1000
			default_cooldown=1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.eye_collection >= 1)
						Error(user, "You havent got enough sharingan eyes ([user.eye_collection])")
						return 0
					if(user.sharingan==6)
						Error(user, "Wait for shisui's eye to deactivate to use izanagi")
						return 0

			Use(mob/user)
				user.combat("Izanagi is active for [(user.int/5)/10] amount of seconds")
				user.izanagi_active=1
				spawn(user.con/5)
					if(user.izanagi_active)
						user.combat("Izanagi has been overtimed, you lose one eye")
						user.izanagi_active=0
						if(user.eye_collection <= 0)
							return
						else
							user.eye_collection-=1
							user << "Eye total count is now [user.eye_collection]"

		Kotoamatsukami
			id = KOTOAMATSUKAMI
			name = "Kotoamatsukami"
			icon_state = "kotoamatsukami"
			default_chakra_cost = 1200
			default_cooldown = 450

			IsUsable(mob/user)
				. = ..()
				var/mob/human/player/T = user.MainTarget()
				if(.)
					if(!T)
						Error(user, "You need A Target!")
						return
					if(!user.sharingan==6)
						Error(user, "You need Shisui's eye active to use this move!")
						return

			Use(mob/human/user)
				viewers(user) << output("[user]: Kotoamatsukami!", "combat_output")
				var/mob/human/player/X = user.MainTarget()
				var/shisuitime = user.int/10
				var/CX=rand(1,(user.int+user.intbuff-user.intneg))
				if(!X) return
				else
					var/Cx=rand(1,(X.int+X.intbuff-X.intneg))

					if(!X)
						user.combat("Kotoamatsukami didn't activate due to no target")
						default_cooldown=120
						return
					else
						if(CX>Cx)
							X.movement_map = list()
							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							var/list/dirs2 = dirs.Copy()
							for(var/orig_dir in dirs)
								var/new_dir = pick(dirs2)
								dirs2 -= new_dir
								X.movement_map["[orig_dir]"] = new_dir

							user.pet += X
							user.controlling=1
							user.controlmob=X
							user.client.eye=X
							user.kotoactive=1
							X.sight=(BLIND)
							viewers(user) << output("[user]: Shisui's eye has been deactivated!", "combat_output")
							user.sharingan=0
							user.conbuff=0
							user.rfxbuff=0
							user.intbuff=0
							spawn()
								while(shisuitime > 0)
									sleep(10)
									shisuitime--
									if(shisuitime > 0 && user && user.client && X)
										user.controlmob=0
										user.controlling=0
										user.client.eye = user
										user.cantreact = 0
										user.pet-=X
										X.movement_map = null
										X.sight=0
										user.combat("Kotoamatsukami has stopped!")
										break
						else
							user.combat("Kotoamatsukami has failed!")
							viewers(user) << output("[user]: Shisui's eye has been deactivated!", "combat_output")
							user.sharingan=0
							user.conbuff=0
							user.rfxbuff=0
							user.intbuff=0

		shisui_eye
			id = SHISUI_MANGEKYOU
			name = "Sharingan: Shisui Eye"
			icon_state = "shisui"
			default_chakra_cost = 150
			default_cooldown = 270

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Activate.....!", "combat_output")
				sleep(10)
				viewers(user) << output("[user]: Shisui Mangekyou Sharingan!", "combat_output")
				user.sharingan=6
				user.Affirm_Icon()
				spawn(900)
					if(!user) return
					if(user.sharingan)
						user.special=0
						user.sharingan=0
						user.conbuff=0
						user.rfxbuff=0
						user.intbuff=0
						user.Affirm_Icon()
						user.combat("Your sharingan deactivates.")

/*---------------------------------------Eternal Mangekyou Sharingans-------------------------------------*/


		eternal_mangekyou_sharingan_madara
			id = ETERNAL_MANGEKYOU_SHARINGAN_MADARA
			name = "Eternal Mangekyou Sharingan"
			icon_state = "eternal_mangekyou"
			default_cooldown = 700
			default_chakra_cost = 50
			copyable = 0

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan == 1)
						Error(user, "Sharingan is already active. please wait for your sharingan to deactivate to use eternal mangekyou sharingan")
						return 0

			Cooldown(mob/user)
				if(!user.sharingan==7)
					return ..(user)
				else
					return 0

			Use(mob/human/user)
				if(user.sharingan==7)
					user.intbuff=0
					user.rfxbuff=0
					user.conbuff=0
					user.special=0
					user.sharingan=0
					user.Affirm_Icon()
					ChangeIconState("eternal_mangekyou")
					user.Load_Overlays()
					user.combat("Your sharingan deactivates.")
				else
					viewers(user) << output("[user]: Eternal Mangekyou Sharingan!", "combat_output")
					user.sharingan=7
					ChangeIconState("eternal_mangekyou_cancel")
					user.Load_Overlays()
					user.Affirm_Icon()


		eternal_mangekyou_sharingan_sasuke
			id = ETERNAL_MANGEKYOU_SHARINGAN_SASUKE
			name = "Eternal Mangekyou Sharingan"
			icon_state = "eternal_mangekyou_sasuke"
			default_cooldown = 700
			default_chakra_cost = 50

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan == 1)
						Error(user, "Sharingan is already active. please wait for your sharingan to deactivate to use eternal mangekyou sharingan")
						return 0

			Cooldown(mob/user)
				if(!user.sharingan==5)
					return ..(user)
				else
					return 0

			Use(mob/human/user)
				if(user.sharingan==5)
					user.intbuff=0
					user.rfxbuff=0
					user.conbuff=0
					user.special=0
					user.sharingan=0
					user.Affirm_Icon()
					ChangeIconState("eternal_mangekyou_sasuke")
					user.Load_Overlays()
					user.combat("Your sharingan deactivates.")
				else
					viewers(user) << output("[user]: Eternal Mangekyou Sharingan!", "combat_output")
					user.sharingan=5
					ChangeIconState("eternal_mangekyou_sasuke_cancel")
					user.Load_Overlays()
					user.Affirm_Icon()

obj
	trigger
		kamui_teleport
			icon_state = "STM"

			var
				recall_x
				recall_y
				recall_z

			New(loc, kx, ky, kz)
				. = ..(loc)
				recall_x = kx
				recall_y = ky
				recall_z = kz

			Use(mob/u)
				if(recall_z == user.z)
					var/mob/human/player/etarget = user.MainTarget()
					if(etarget)
						new/obj/kamui(locate(etarget.x,etarget.y,etarget.z))
						etarget.loc = locate(recall_x,recall_y,recall_z)
						etarget.Dec_Stam((rand(1000,2000)+300))
						explosion(50,etarget.x,etarget.y,etarget.z,u,1)
						etarget.stunned=2
						user.RemoveTrigger(src)
					else
						user.combat("Kamui failed because there was no target")
						user.RemoveTrigger(src)
						return

obj/kamui
	icon='icons/Kamui.dmi'
	icon_state=""
	density=1
	New()
		src.icon_state="Action"
		spawn(20)
			del(src)


turf
	Susanoo
		layer = 100
		icon='pngs/Susanoo.png'
		density = 0