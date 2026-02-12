mob/var/active=0
mob/var/earth_mole_timer=0
skill
	earth
		iron_skin
			id = DOTON_IRON_SKIN
			name = "Earth Release: Iron Skin"
			icon_state = "doton_iron_skin"
			default_chakra_cost = 150
			default_cooldown = 240

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.ironskin)
						Error(user, "Earth: Iron Skin is already active.")
						return 0
					if(user.shukaku_cloak)
						Error(user, "You are not allowed to use this jutsu in collaberation with the one active already.")
						return 0
					if(user.sandarmor)
						Error(user, "You are not allowed to use this jutsu in collaberation with the one active already.")
						return 0
					if(user.gate)
						Error(user, "You can't use this jutsu; you're trying to stack.")
						return 0
					if(user.lightning_armor)
						Error(user, "You can't use this jutsu; you're trying to stack.")
						return 0
					if(user.lightning_armor>=2)
						Error(user, "You can't use this jutsu; you're trying to stack.")
						return 0

			Use(mob/human/user)
				if(user.boneharden)
					user.combat("Your bones unharden")
					user.boneharden=0
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Iron Skin!", "combat_output")

				user.ironskin=1
				user.Affirm_Icon()

				var/T = 300 + round(150 * user.ControlDamageMultiplier())
				spawn(T)
					if(user)
						user.ironskin=0
						user.reIcon()
						user.Affirm_Icon()




		dungeon_chamber
			id = DOTON_CHAMBER
			name = "Earth Release: Dungeon Chamber of Nothingness"
			icon_state = "Dungeon Chamber of Nothingness"
			default_chakra_cost = 100
			default_cooldown = 40
			default_seal_time = 5



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0


			Use(mob/human/user)
				user.stunned=1
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Dungeon Chamber of Nothingness!", "combat_output")

				var/mob/human/player/etarget = user.MainTarget()
				if(!etarget)
					for(var/mob/human/M in oview(1))
						if(!M.protected && !M.ko)
							etarget=M
				if(etarget)
					var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z
					spawn()Doton_Cage(ex,ey,ez,100)
					sleep(4)
					if(etarget)
						if(ex==etarget.x&&ey==etarget.y&&ez==etarget.z)
							etarget.stunned=10
							etarget.layer=MOB_LAYER-1
							etarget.paralysed=1
							spawn()
								while(etarget&&ex==etarget.x&&ey==etarget.y&&ez==etarget.z)
									sleep(2)
								if(etarget)
									etarget.paralysed=0
									etarget.stunned=0
							spawn(100)
								if(etarget)
									etarget.paralysed=0




		dungeon_chamber_crush
			id = DOTON_CHAMBER_CRUSH
			name = "Earth Release: Split Earth Revolution Palm"
			icon_state = "doton_split_earth_turn_around_palm"
			default_chakra_cost = 250
			default_cooldown = 70
			default_seal_time = 5

			Use(mob/human/user)
				user.stunned=3
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Split Earth Revolution Palm!", "combat_output")

				for(var/obj/earthcage/o in oview(8))
					o.icon='icons/dotoncagecrushed.dmi'
					for(var/mob/human/m in oview(1,o))
						m.Crush(user)
						break




		earth_flow_river
			id = DOTON_EARTH_FLOW
			name = "Earth Release: Earth Flow River"
			icon_state = "earthflow"
			default_chakra_cost = 400
			default_cooldown = 60
			default_seal_time = 5

			Use(mob/human/user)
				user.stunned=1
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Earth Flow River!", "combat_output")

				var/obj/O=new(locate(user.loc))
				O.icon='icons/earthflow.dmi'
				O.icon_state="overlay"
				O.dir=user.dir

				sleep(1)
				var/obj/trailmaker/Mud_Slide/o=new/obj/trailmaker/Mud_Slide(locate(user.x,user.y,user.z))
				o.density=0
				var/distance=15
				var/user_dir = user.dir
				while(o && distance>0 && user)
					if(!step(o, user_dir))
						break
					var/conmult = user.ControlDamageMultiplier()
					for(var/mob/human/player/M in o.loc)
						if(M!=user && !(M in o.gotmob))
							o.gotmob+=M
							M.Dec_Stam(700+200*conmult,0,user)
							spawn()M.Hostile(user)

					for(var/turf/T in get_step(o,user_dir))
						if(T.density)
							distance=1
					sleep(1)

					distance--
					for(var/mob/human/player/M in o.gotmob)
						M.Dec_Stam(80+20*conmult,0,user)
						spawn()M.Hostile(user)
				del(O)
				del(o)


		hiding_like_a_mole
			id = DOTON_MOLE
			name = "Earth Release: Hiding Like a Mole"
			icon_state = "hiding_like_a_mole"
			default_chakra_cost = 300
			default_seal_time = 10

			Use(mob/human/user)
				if(user.active!=1)
					viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Hiding Like a Mole Technique!", "combat_output")
					user.active = 1
					user.earth_mole_timer = user.con/10
					user << "You are able to be [user.earth_mole_timer] seconds underground before you get restored back to the top"
					var/obj/x = new/obj/mole_in(locate(user.x,user.y,user.z))
					for(var/mob/human/player/v in range(100,user))
						if(v)v.RemoveTarget(user)
					spawn(5) user.invisibility=1
					spawn(8) del(x)
					var/obj/z = new/obj/crater_mole(locate(user.x,user.y,user.z))
					spawn(50) del(z)
					user.mole=1
					user.lastskill = 0
					spawn() user.mole_timer()

				else if(user.active >= 1)
					default_cooldown=120
					user.mole=0
					user.invisibility=0
					user.movepenalty=0
					user.earth_mole_timer = 0
					user.stunned=0
					user.active=0
					var/obj/y = new/obj/mole_out(locate(user.x,user.y,user.z))
					spawn(5) del(y)
					var/obj/c = new/obj/crater_mole(locate(user.x,user.y,user.z))
					spawn(50) del(c)


		head_hunter
			id = DOTON_HEAD_HUNTER
			name = "Earth Release: Head Hunter"
			icon_state = "head_hunter"
			default_chakra_cost = 200
			default_cooldown = 90

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.mole)
						Error(user, "You need to be underground to be able to use this jutsu")
						return 0

			Use(mob/human/user)
				var/mob/human/player/x = user.MainTarget()
				if(x in range(2,user))
					x.icon_state="hunter"
					var/mob/new_person
					new_person = x
					var/obj/g = new/obj/crater_mole(locate(new_person.x,new_person.y,new_person.z))
					viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Head Hunter Technique!", "combat_output")
					if(user.curchakra>=user.chakra)
						new_person.stunned=10
						spawn(100) new_person.icon_state=""
					else if(user.curchakra>=(user.chakra/2))
						new_person.stunned=7
						spawn(70) new_person.icon_state=""
					else if(user.curchakra>=(user.chakra/3))
						new_person.stunned=5
						spawn(5) new_person.icon_state=""
					new_person.Dec_Stam(user.con+user.conbuff-user.conneg/5,0,user)
					user.mole=0
					user.invisibility=0
					user.movepenalty=0
					user.stunned=0
					user.earth_mole_timer = 0
					user.active=0
					var/obj/y = new/obj/mole_out(locate(user.x,user.y,user.z))
					spawn(5) del(y)
					spawn(30) del(g)
					var/obj/c = new/obj/crater_mole(locate(user.x,user.y,user.z))
					spawn(50) del(c)
				else
					user << "Please get closer, Head Hunter jutsu cannot used great than two tiles away from the enemy"
					default_cooldown = 15
					return

		earth_dragon
			id = DOTON_EARTH_DRAGON
			name = "Earth Style: Earth Stone Dragon"
			icon_state = "earth_dragon"
			default_chakra_cost = 400
			default_cooldown = 90

			Use(mob/user)
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Earth Dragon!", "combat_output")
				user.stunned = 1
				user.icon_state = "Seal"
				spawn(10)
					user.icon_state = ""
				var/earth_dragon/earth = new(get_step(user,user.dir))
				earth.owner = user
				earth.dir = user.dir
				var/tiles = 50
				spawn()
					walk(earth, earth.dir, 1)
					while(user && tiles > 0)

						for(var/mob/human/O in view(1,earth))
							if(O != user && O)
								O.Dec_Stam(450 * user:ControlDamageMultiplier(),0,user)
								if(prob(20))
									O.Wound(rand(0,1),0,user)
								O.movepenalty += 10
								O.Hostile(user)
								if(O)
									O.Knockback(1,3)
						tiles--
						sleep(3)
					if(earth)
						earth.loc = null


		resurrection_technique_corpse_soil
			id = DOTON_RESURRECTION_TECHNIQUE
			name = "Earth Release: Resurrection Technique, Corpse Soil"
			icon_state = "resurrection"
			default_chakra_cost = 1500
			default_cooldown = 450

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Resurrection Technique, Corpse Soil!", "combat_output")
				if(!user) return
				var/found=0
				for(var/mob/corpse/C in oview(10,user))
					if(user.carrying.Find(C))
						found=1
						user.stunned=10
						C.invisibility = 10
						var/mob/R = new/mob/Resurrection(locate(C.x,C.y,C.z))
						user.dir=get_dir(user,C)
						user.resurrection = 1
						spawn(50)
							del(R)
							user<<"<font color=grey>Your Corpse Has Awaken!"
							user.combat("Press the A button to attack and press F if you want your corpse to use a jutsu(beware he won't always use a jutsu)")
							var/mob/human/player/npc/o = new/mob/human/player/npc(locate(C.x,C.y,C.z))
							spawn()
								o.icon = C.icon
								o.overlays += 'icons/reanimation.dmi'
								o.name = "[C.name] (Revived)"
								o.faction = C.faction
								o.dir = user.dir
								o.mouse_over_pointer = C.mouse_over_pointer
								o.stamina = C.stamina*0.5
								o.chakra = C.chakra*0.5
								o.curstamina = C.stamina*0.5
								o.curchakra = C.chakra*0.5
								o.str += C.str*0.5
								o.rfx += C.rfx*0.5
								o.int += C.int*0.5
								o.con += C.con*0.5
								o.blevel = C.blevel
								user.pet += o
								o.ownerkey = user.key
								o.owner = user
								o.killable=1

								for(var/skill/X in user.skills)
									o.AddSkill(X.id)

								del(C)

								spawn(450)
									if(user && o)
										user.resurrection = 0
										del(o)

					if(!found)
						user<<"You need to be carrying a corpse."
						default_cooldown = 120
						return


		earth_shaking_palm
			id = DOTON_EARTH_SHAKING_PALM
			name = "Earth Release: Earth Shaking Palm"
			icon_state = "earth_palm"
			default_chakra_cost = 1000
			default_cooldown = 180
			default_seal_time = 4

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Earth Shaking Palm!", "combat_output")
				var/earth_damage = user.ControlDamageMultiplier()
				user.icon_state="Seal"
				spawn(15)
					user.icon_state=""
				user.stunned=2
				user.protected=4
				var/obj/x=new/obj/ground_destruction(user.loc)
				spawn()AOExk(user.x,user.y,user.z,3,earth_damage*user.blevel,6,user,0,1,1)
				spawn(5) del(x)
				for(var/stun = user.blevel/10,stun>0,stun--)
					spawn(10)
						user.movepenalty+=5

		doton_prison_dome
			id = DOTON_PRISON_DOME
			name = "Earth Release: Earth Prison Dome of Magnificent Nothingess"
			icon_state = "doton_chamber"
			default_chakra_cost = 1500
			default_cooldown = 300
			default_seal_time = 4

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=#8A4117> Earth Release: Earth Prison Dome of Magnificent Nothingess!", "combat_output")

				var/time=0
				var/R=0
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/target = user.MainTarget()
				var/distance = get_dist(user, target)

				if(!target || distance > 1)
					user.combat("Target too far ([distance]/1 tiles) please get close to the target")
					user.stunned=5

					user.icon_state="Seal"
					spawn(5)	user.icon_state=""

					sleep(5)

					var/obj/X = new/obj/doton_shield(user.loc)

					user.protected=10
					user.larch=1
					time=5

					while(time > 0)
						sleep(10)
						user.protected=10
						user.stunned+=1
						time--
					if(time<=0)
						user.larch=0
						user.stunned=0
						user.protected=0
						del(X)

				else
					user.stunned = 3
					user.icon_state = "Seal"
					spawn(5) user.icon_state=""

					var/obj/Z = new/obj/shield(target.loc)
					sleep(5)

					del(Z)

					var/obj/Y = new/obj/doton_shield(target.loc)
					time=pick(4,8)
					user.icon_state="Throw2"
					user.overlays+='icons/leech.dmi'
					user.dir=target.loc

					while(time > 0)
						sleep(10)
						target.stunned += 2
						user.stunned +=2
						R=rand(35,60)
						if(!target)
							del(Y)
							user.stunned=0
							target.stunned=0
							user.overlays-='icons/leech.dmi'
							user.icon_state=""
							break
						target.curchakra-= round(R*conmult)
						user.curchakra+=round(R*conmult)
						target.Hostile(user)
						time--
					if(target.curchakra<0)
						target.curstamina=0
						user.overlays-='icons/leech.dmi'
						user.icon_state=""
						del(Y)

					if(time<=0)
						del(Y)
						user.stunned=0
						target.stunned=0
						user.overlays-='icons/leech.dmi'
						user.icon_state=""

mob/proc/mole_timer()
	spawn(10)
		src.earth_mole_timer--
		if(src.earth_mole_timer <= 0 && src.mole && active)
			src.mole=0
			src.invisibility=0
			src.movepenalty=0
			src.earth_mole_timer = 0
			src.stunned=0
			src.active=0
			var/obj/y = new/obj/mole_out(locate(src.x,src.y,src.z))
			spawn(5) del(y)
			var/obj/c = new/obj/crater_mole(locate(src.x,src.y,src.z))
			spawn(50) del(c)
			return
		else if(src.earth_mole_timer > 0 && src.mole)
			src.mole_timer()
			return

obj/crater_mole
	icon = 'icons/hiding_like_a_mole.dmi'
	icon_state="state"
	pixel_y=-15

obj/shield
	icon='icons/doton_crush.dmi'
	one
		layer=MOB_LAYER+1
		density=1
		pixel_x = 32
		pixel_y = -32
		New()
			..()
			flick("bottom_right",src)
	two
		layer=MOB_LAYER+1
		density=1
		pixel_x = -32
		pixel_y = -32
		New()
			..()
			flick("bottom_left",src)
	three
		layer=MOB_LAYER+1
		density=1
		New()
			..()
			flick("center",src)
	four
		layer=MOB_LAYER+1
		density=1
		pixel_x = -32
		New()
			..()
			flick("center_left",src)
	five
		layer=MOB_LAYER+1
		density=1
		pixel_x = 32
		New()
			..()
			flick("center_right",src)
	six
		layer=MOB_LAYER+1
		density=1
		pixel_x = -32
		pixel_y = 32
		New()
			..()
			flick("top_left",src)
	seven
		layer=MOB_LAYER+1
		density=1
		pixel_y = 32
		New()
			..()
			flick("top_center",src)
	eight
		layer=MOB_LAYER+1
		density=1
		pixel_x = 32
		pixel_y = 32
		New()
			..()
			flick("top_right",src)
	nine
		layer=MOB_LAYER+1
		density=1
		pixel_y = -32
		New()
			..()
			flick("bottom_center",src)

obj/doton_shield_231
	var
		list/dependants=new
	New()
		spawn()..()
		spawn()
			dependants+=new/obj/shield/one(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/two(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/three(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/four(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/five(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/six(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/seven(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/eight(locate(src.x,src.y,src.z))
			dependants+=new/obj/shield/nine(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.dependants)
			del(x)
		..()


obj
	doton_shield
		icon = 'icons/doton shield.dmi'
		icon_state = "center"
		density = 1
		layer = MOB_LAYER + 0.1

		New(location)
			..(location)

			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "bottom_left", pixel_x = -32, pixel_y = -32)
			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "bottom_center", pixel_y = -32)
			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "bottom_right", pixel_x = 32, pixel_y = -32)

			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "center_left", pixel_x = -32)
			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "center_right", pixel_x = 32)

			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "top_left", pixel_x = -32, pixel_y = 32)
			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "top_center", pixel_y = 32)
			overlays += image(icon = 'icons/doton shield.dmi', icon_state = "top_right", pixel_x = 32, pixel_y = 32)


mob
	Resurrection
		icon = 'icons/reanimation2.dmi'
		icon_state = ""
		density=1
		layer=999
		New()
			spawn(150)
				if(src)
					del(src)

		interact="Talk"
		verb
			Talk()
				set src in oview(1)
				set hidden=1
				alert(usr,"Your Reanimation Jutsu is incomplete!.")
				return 0

mob/human/proc
	Crush(mob/u)
		src.Wound(rand(15,30),0,u)
		src.Dec_Stam(rand(3000-8000),0,u)
		spawn()Blood2(src,u)
		spawn()src.Hostile(u)

earth_dragon
	parent_type = /obj
	icon = 'icons/Earth_Dragon.dmi'
	density = 1
	New(loc)
		..(loc)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "0,0",pixel_x = -48,pixel_y = 0)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "1,0",pixel_x = -16,pixel_y = 0)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "2,0",pixel_x = 16,pixel_y = 0)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "3,0",pixel_x = 48,pixel_y = 0)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "0,1",pixel_x = -48,pixel_y = 32)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "1,1",pixel_x = -16,pixel_y = 32)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "2,1",pixel_x = 16,pixel_y = 32)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "3,1",pixel_x = 48,pixel_y = 32)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "0,2",pixel_x = -48,pixel_y = 64)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "1,2",pixel_x = -16,pixel_y = 64)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "2,2",pixel_x = 16,pixel_y = 64)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "3,2",pixel_x = 48,pixel_y = 64)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "0,3",pixel_x = -48,pixel_y = 96)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "1,3",pixel_x = -16,pixel_y = 96)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "2,3",pixel_x = 16,pixel_y = 96)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "3,3",pixel_x = 48,pixel_y = 96)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "0,4",pixel_x = -48,pixel_y = 128)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "1,4",pixel_x = -16,pixel_y = 128)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "2,4",pixel_x = 16,pixel_y = 128)
		overlays += image(icon = 'Earth_Dragon.dmi',icon_state = "3,4",pixel_x = 48,pixel_y = 128)


obj
	earthcrush_one
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-80
		New()
			..()
			flick("0,0",src)
	earthcrush_two
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-48
		New()
			..()
			flick("1,0",src)
	earthcrush_three
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		New()
			..()
			flick("2,0",src)
	earthcrush_four
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		New()
			..()
			flick("3,0",src)
	earthcrush_five
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=48
		New()
			..()
			flick("4,0",src)
	earthcrush_six
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=80
		New()
			..()
			flick("5,0",src)
	earthcrush_seven
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-80
		pixel_y=32
		New()
			..()
			flick("0,1",src)
	earthcrush_eight
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-48
		pixel_y=32
		New()
			..()
			flick("1,1",src)
	earthcrush_nine
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=32
		New()
			..()
			flick("2,1",src)
	earthcrush_ten
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=32
		New()
			..()
			flick("3,1",src)
	earthcrush_eleven
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=48
		pixel_y=32
		New()
			..()
			flick("4,1",src)
	earthcrush_twelve
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=80
		pixel_y=32
		New()
			..()
			flick("5,1",src)
	earthcrush_thirteen
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-80
		pixel_y=64
		New()
			..()
			flick("0,2",src)
	earthcrush_fourteen
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-48
		pixel_y=64
		New()
			..()
			flick("1,2",src)
	earthcrush_fifteen
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=64
		New()
			..()
			flick("2,2",src)
	earthcrush_sixteen
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=64
		New()
			..()
			flick("3,2",src)
	earthcrush_seventeen
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=48
		pixel_y=64
		New()
			..()
			flick("4,2",src)
	earthcrush_eighteen
		icon='icons/ground_tremble.dmi'
		layer=MOB_LAYER+1
		pixel_x=80
		pixel_y=64
		New()
			..()
			flick("5,2",src)

obj/ground_destruction
	var
		list/ground=new
	New()
		spawn()..()
		spawn()
			ground+=new/obj/earthcrush_one(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_two(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_three(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_four(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_five(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_six(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_seven(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_eight(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_nine(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_ten(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_eleven(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_twelve(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_thirteen(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_fourteen(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_fifteen(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_sixteen(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_seventeen(locate(src.x,src.y,src.z))
			ground+=new/obj/earthcrush_eighteen(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.ground)
			del(x)
		..()



obj
	mole_o
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=-20
		New()
			..()
			flick("out 1,0",src)
	mole_w
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=-20
		New()
			..()
			flick("out 0,0",src)
	mole_t
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=12
		New()
			..()
			flick("out 1,1",src)
	mole_f
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=12
		New()
			..()
			flick("out 0,1",src)

obj/mole_in
	var
		list/boom=new
	New()
		spawn()..()
		spawn()
			boom+=new/obj/mole_o(locate(src.x,src.y,src.z))
			boom+=new/obj/mole_w(locate(src.x,src.y,src.z))
			boom+=new/obj/mole_t(locate(src.x,src.y,src.z))
			boom+=new/obj/mole_f(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.boom)
			del(x)
		..()


obj
	mole_one
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=-20
		New()
			..()
			flick("out 1,0",src)
	mole_two
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=-20
		New()
			..()
			flick("out 0,0",src)
	mole_three
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=16
		pixel_y=12
		New()
			..()
			flick("out 1,1",src)
	mole_four
		icon='icons/hiding_like_a_mole.dmi'
		layer=MOB_LAYER+1
		pixel_x=-16
		pixel_y=12
		New()
			..()
			flick("out 0,1",src)

obj/mole_out
	var
		list/hl=new
	New()
		spawn()..()
		spawn()
			hl+=new/obj/mole_one(locate(src.x,src.y,src.z))
			hl+=new/obj/mole_two(locate(src.x,src.y,src.z))
			hl+=new/obj/mole_three(locate(src.x,src.y,src.z))
			hl+=new/obj/mole_four(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.hl)
			del(x)
		..()