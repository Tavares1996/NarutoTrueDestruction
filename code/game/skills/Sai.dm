mob/var/brush
skill
	ink
		copyable=0

		brush
			id = BRUSH
			name = "Ink: Brush"
			icon_state = "brush"
			default_chakra_cost = 30
			default_cooldown = 4

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.brush==1)
						Error(user, "You're already using your brush!")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Ink: Brush!", "combat_output")
				user.brush=1
				spawn(150)
					if(user&&user.brush==1)
						user.combat("Your ink on the page has dried!")
						user.brush=0

		ink_snake
			id = INK_SNAKE
			name = "Ink: Snake"
			icon_state = "ink_snake"
			default_chakra_cost = 50
			default_cooldown = 10

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.brush)
						Error(user, "Please use your brush jutsu first.")
						return 0

			Use(mob/human/user)
				user.brush=0
				var/obj/snake/O=new/obj/snake(user)
				O.density=0
				O.dir=user.dir

				//Location
				if(user.dir==NORTH)
					O.loc=locate(user.x,user.y+1,user.z)
				if(user.dir==SOUTH)
					O.loc=locate(user.x,user.y-1,user.z)
				if(user.dir==EAST)
					O.loc=locate(user.x+1,user.y,user.z)
				if(user.dir==WEST)
					O.loc=locate(user.x-1,user.y,user.z)
				if(user.dir==NORTHEAST)
					O.loc=locate(user.x+1,user.y+1,user.z)
				if(user.dir==NORTHWEST)
					O.loc=locate(user.x-1,user.y+1,user.z)
				if(user.dir==SOUTHEAST)
					O.loc=locate(user.x+1,user.y-1,user.z)
				if(user.dir==SOUTHWEST)
					O.loc=locate(user.x-1,user.y-1,user.z)


				var/tiles=10
				var/hit=0
				while(user&&O&&tiles>0&&!hit)
					for(var/mob/M in O.loc)
						if(M!=user)
							O.loc=null
							hit=1
							spawn()
								M.stunned+=3
								M.overlays+='Ink_snake2.dmi'
								while(M&&M.stunned>0)
									M.icon_state="hurt"
									sleep(1)
								if(M)
									M.icon_state=""
									M.overlays-='Ink_snake2.dmi'

							break
					step(O,O.dir)
					tiles--
					sleep(2)
				if(!hit)
					spawn(30)
						if(O)
							O.loc=null

		ink_beast
			id = INK_BEAST
			name = "Ink: Beast"
			icon_state = "ink_beast"
			default_chakra_cost = 200
			default_cooldown = 45

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.brush)
						Error(user, "Please use your brush jutsu first.")
						return 0

			Use(mob/human/user)
				user.brush=0
				var/obj/beast_two/O=new/obj/beast_two(user)
				O.density=0
				O.dir=user.dir

				//Location
				if(user.dir==NORTH)
					O.loc=locate(user.x,user.y+1,user.z)
				if(user.dir==SOUTH)
					O.loc=locate(user.x,user.y-1,user.z)
				if(user.dir==EAST)
					O.loc=locate(user.x+1,user.y,user.z)
				if(user.dir==WEST)
					O.loc=locate(user.x-1,user.y,user.z)
				if(user.dir==NORTHEAST)
					O.loc=locate(user.x+1,user.y+1,user.z)
				if(user.dir==NORTHWEST)
					O.loc=locate(user.x-1,user.y+1,user.z)
				if(user.dir==SOUTHEAST)
					O.loc=locate(user.x+1,user.y-1,user.z)
				if(user.dir==SOUTHWEST)
					O.loc=locate(user.x-1,user.y-1,user.z)


				var/tiles=30
				var/hit=0
				while(user&&O&&tiles>0&&!hit)
					for(var/mob/M in O.loc)
						if(M!=user)
							O.loc=null
							hit=1
							spawn()
								M.Dec_Stam(700+rand(50,200)*user:ControlDamageMultiplier(),0,user)
								M.Knockback(6,O.dir)
								while(M&&M.stunned>0)
									M.icon_state="hurt"
									sleep(1)
								if(M)
									M.icon_state=""

							break
					step(O,O.dir)
					tiles--
					sleep(2)
				if(!hit)
					spawn(30)
						if(O)
							flick('ink_beast_done.dmi', O)
							O.loc=null



		ink_bird
			id = INK_BIRD
			name = "Ink: Bird"
			icon_state  = "ink_bird"
			default_chakra_cost = 400
			default_cooldown = 90
			default_seal_time = 7

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.brush)
						Error(user, "You must have your brush for this.")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Ink: Bird!", "combat_output")
				user.brush=0
				user.stunned=10
				var/conmult = user.ControlDamageMultiplier()
				var/targets[] = user.NearestTargets(num=10)
				if(targets && targets.len)
					for(var/mob/human/player/etarget in targets)
						spawn()
							var/obj/trailmaker/o=new/obj/bird
							var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,etarget)
							if(result)
								result.Knockback(2,o.dir)
								spawn(1)
									del(o)
								result.Dec_Stam((600 + 750*conmult),0,user)
								spawn()result.Hostile(user)
				else
					var/obj/trailmaker/o=new/obj/bird
					var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
					if(result)
						result.Knockback(2,o.dir)
						spawn(1)
							del(o)
						result.Dec_Stam((600 + 750*conmult),0,user)
						spawn()result.Hostile(user)
				user.stunned=0

obj/beast_two
	var
		list/thunder=new
	New()
		spawn()..()
		spawn()
			thunder+=new/obj/beast/one(locate(src.x,src.y,src.z))
			thunder+=new/obj/beast/two(locate(src.x,src.y,src.z))
			thunder+=new/obj/beast/three(locate(src.x,src.y,src.z))
			thunder+=new/obj/beast/four(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.thunder)
			del(x)
		..()

obj
	snake
		icon='ink_snake.dmi'
	beast
		icon='ink_beast_run.dmi'
		one
			icon_state="0,0"
			pixel_x=-16
		two
			icon_state="0,1"
			pixel_x=16
		three
			icon_state="1,0"
			pixel_x=-16
			pixel_y=32
		four
			icon_state="1,1"
			pixel_x=-16
			pixel_y=32
	bird
		icon='ink_bird.dmi'