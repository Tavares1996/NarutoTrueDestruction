mob
	var
		fang_over_fang = 0
		double_fang_over_fang = 0
		tmp/beast_mode = 0

skill
	inuzuka
		copyable = 0

		fang_over_fang
			id = FANG_OVER_FANG
			name = "Fang Over Fang"
			icon_state = "fang_over_fang"
			default_stamina_cost = 200
			default_chakra_cost = 300
			default_cooldown = 40

			Use(mob/user)
				if(capture_the_flag && capture_the_flag.GetTeam(user) != "None")
					capture_the_flag.DropFlag(user)

				var
					time = 15
					py = -16
					px = -32

				user.icon='icons/base_invisible.dmi'
				user.overlays = new

				Poof(user.x,user.y,user.z)

				var/list/images = list(
										image(icon = 'icons/fang_over_fang.dmi',icon_state = "0,0",layer = MOB_LAYER + 0.1,pixel_x = 0 + px,pixel_y = 0 + py),
										image(icon = 'icons/fang_over_fang.dmi',icon_state = "1,0",layer = MOB_LAYER + 0.1,pixel_x = 32 + px,pixel_y = 0 + py),
										image(icon = 'icons/fang_over_fang.dmi',icon_state = "2,0",layer = MOB_LAYER + 0.1,pixel_x = 64 + px,pixel_y = 0 + py),

										image(icon = 'icons/fang_over_fang.dmi',icon_state = "0,1",layer = MOB_LAYER + 0.1,pixel_x = 0 + px,pixel_y = 32 + py),
										image(icon = 'icons/fang_over_fang.dmi',icon_state = "1,1",layer = MOB_LAYER + 0.1,pixel_x = 32 + px,pixel_y = 32 + py),
										image(icon = 'icons/fang_over_fang.dmi',icon_state = "2,1",layer = MOB_LAYER + 0.1,pixel_x = 64 + px,pixel_y = 32 + py),

										image(icon = 'icons/fang_over_fang.dmi',icon_state = "0,2",layer = MOB_LAYER + 0.1,pixel_x = 0 + px,pixel_y = 64 + py),
										image(icon = 'icons/fang_over_fang.dmi',icon_state = "1,2",layer = MOB_LAYER + 0.1,pixel_x = 32 + px,pixel_y = 64 + py),
										image(icon = 'icons/fang_over_fang.dmi',icon_state = "2,2",layer = MOB_LAYER + 0.1,pixel_x = 64 + px,pixel_y = 64 + py),

										)

				for(var/image/i in images)
					user.overlays += i

				user.fang_over_fang = 1
				user.Tank=3

				sleep(time * 10)

				if(user)
					user.fang_over_fang = 0
					user.Tank=0

					for(var/image/i in images)
						user.overlays -= i

					user.reIcon()
					user.Load_Overlays()
					user.Load_Overlays()


		double_fang_over_fang
			id = DOUBLE_FANG_OVER_FANG
			name = "Double Fang Over Fang"
			icon_state = "double_fang_over_fang"
			default_stamina_cost = 200
			default_chakra_cost = 400
			default_cooldown = 90



			IsUsable(mob/user)
				. = ..()
				if(.)
					var/mob/human/dog = locate() in user.pet

					if(!dog)
						Error(user, "You need a dog to use this jutsu")
						return 0

			Use(mob/user)
				if(capture_the_flag && capture_the_flag.GetTeam(user) != "None")
					capture_the_flag.DropFlag(user)

				var
					mob/human/dog/dog = locate() in user.pet
					time = 15
					py = -16
					px = -32

				dog.status = "double_fang_over_fang"
				dog.loc = null

				user.icon='icons/base_invisible.dmi'
				user.overlays = new

				Poof(user.x,user.y,user.z)

				var/list/images = list(
										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "0,0",layer = MOB_LAYER + 0.1,pixel_x = 0 + px,pixel_y = 0 + py),
										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "1,0",layer = MOB_LAYER + 0.1,pixel_x = 32 + px,pixel_y = 0 + py),
										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "2,0",layer = MOB_LAYER + 0.1,pixel_x = 64 + px,pixel_y = 0 + py),

										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "0,1",layer = MOB_LAYER + 0.1,pixel_x = 0 + px,pixel_y = 32 + py),
										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "1,1",layer = MOB_LAYER + 0.1,pixel_x = 32 + px,pixel_y = 32 + py),
										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "2,1",layer = MOB_LAYER + 0.1,pixel_x = 64 + px,pixel_y = 32 + py),

										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "0,2",layer = MOB_LAYER + 0.1,pixel_x = 0 + px,pixel_y = 64 + py),
										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "1,2",layer = MOB_LAYER + 0.1,pixel_x = 32 + px,pixel_y = 64 + py),
										image(icon = 'icons/double_fang_over_fang.dmi',icon_state = "2,2",layer = MOB_LAYER + 0.1,pixel_x = 64 + px,pixel_y = 64 + py),

										)

				for(var/image/i in images)
					user.overlays += i

				user.double_fang_over_fang = 1
				user.Tank=4

				sleep(time * 10)

				if(user)
					user.double_fang_over_fang = 0
					user.Tank=0

					for(var/image/i in images)
						user.overlays -= i

					user.reIcon()
					user.Load_Overlays()

				if(dog)
					if(user)
						dog.loc = user.loc
					dog.status = initial(dog.status)


		whistle
			id = WHISTLE
			name = "Whistle"
			icon_state = "whistle"
			default_stamina_cost = 300
			default_cooldown = 240

			Cooldown(mob/user)
				var/mob/human/dog/dog = locate() in user.pet

				if(!dog)
					return ..(user)
				else
					return 3


			Use(mob/user)
				var/mob/human/dog/dog = locate() in user.pet

				if(dog)
					user.combat("You have unsummoned your dog")
					del dog

				else

					dog = new

					dog.loc = get_step(user,user.dir)
					dog.owner = user

					if(!istype(user.pet, /list))user.pet=new/list

					user.pet += dog

					dog.stamina = user.stamina * 0.75
					dog.curstamina = dog.stamina
					dog.str=user.str * 0.75
					dog.con=user.con * 0.75
					dog.int=user.int * 0.75
					dog.rfx=user.rfx * 0.75
					dog.faction=user.faction
					dog.mouse_over_pointer=user.mouse_over_pointer
					dog.name= "[user]'s Dog"

					for(var/mob/human/player/npc/x)
						x=dog
						x.killable=1
						break

					spawn()
						while(user && dog)
							var/mob/enemy = user.MainTarget()

							if(dog.status == "normal")
								var/list/dont_attack = list(user,dog)
								if(enemy && (user in view(dog)) && (!dont_attack.Find(enemy)))
									step_towards(dog,enemy)
									if(enemy in get_step(dog,dog.dir))
										dog.attack(enemy)
								else

									step_towards(dog,user)
									if(user.z != dog.z)
										dog.loc = user.loc

						if(dog.curstamina<=0)
							del dog

							sleep(rand(1,2))

						if(!user) del dog

		dynamic_marking
			id = DYNAMIC_MARKING
			name = "Dynamic Marking"
			icon_state = "dynamicmarking"
			default_chakra_cost = 650
			default_cooldown = 160



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					if(!user.Get_Dog_Pet())
						Error(user, "Cannot be used without your pet!")
						return 0



			Use(mob/human/user)
				spawn()
					var/mob/p=user.Get_Dog_Pet()
					var/mob/human/etarget = user.MainTarget()
					viewers(user) << output("[user]: Dynamic Marking!", "combat_output")

					if(p)
						p.density=0
						var/effort=20
						while(p && etarget && get_dist(etarget, p) > 4 && effort > 0)
							step_to(p,etarget,4)
							sleep(1)
							effort--
						walk(p,0)
						if(!etarget || !p)
							return
						if(get_dist(etarget, p) <= 4)
							p.loc = etarget.loc
							var/target_loc = etarget.loc

							etarget.stunned=2
							p.layer=MOB_LAYER+1
							p.icon='icons/Dog.dmi'
							p.icon_state="Marking"
							for(var/obj/u in user.pet)
								user.pet-=u
							flick("Marking",p)
							sleep(15)
							spawn(30)
								if(p)
									del(p)

							if(etarget && etarget.loc == target_loc)
								etarget.movepenalty+=250
								etarget.Hostile(user)


		beastmode
			id = BEAST_MODE
			name = "Beast Mode"
			icon_state = "beastmode"
			default_cooldown = 300
			copyable = 0


			Use(mob/user)
				viewers(user) << output("[user] has activated Beast Mode!")

				user.beast_mode = 1
				user.Affirm_Icon()
				if(!user) return

				spawn(Cooldown(user)*8)

					if(user)
						user.beast_mode = 0
						user.strbuff = 0
						user.rfxbuff = 0
						user.Affirm_Icon()
						viewers(user)<<output("[user]'s Beast chakra has settled.", "combat_outout")

mob/proc
	Get_Dog_Pet()
		for(var/mob/human/dog/X in src.pet)
			if(X && get_dist(X, src) <= 10 && !X.tired)
				return X

mob/human
	dog
		layer = MOB_LAYER + 0.1
		density=1
		icon='icons/Dog.dmi'
		icon_state=""

		initialized=1

		var
			mob/owner_user
			status = "normal"
			attack_cool = 0

		New()
			spawn()
				src.nopkloop()
			spawn()
				src.regeneration2()

		KO()
			if(src.curstamina<=0)
				owner_user << "Your dog has died."
			del src

		proc
			attack(mob/enemy)
				if(attack_cool) return

				attack_cool = 1
				spawn(rand(2,8))
					attack_cool = 0

				var/mob/user = owner_user
				var/damage = round((str + strbuff)*rand(50,150)/100)
				enemy.Dec_Stam(damage)
				enemy.Hostile(user)
				flick("Attack",src)
		nopkloop()
			if(curstamina <= 0 || curchakra <= 0)
				KO()
			..()