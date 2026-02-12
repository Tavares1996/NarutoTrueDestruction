skill
	capacity
		copyable = 0

		fusion
			id = SHARK_FUSION
			name = "Shark Fusion"
			icon_state = "fusion"
			default_chakra_cost = 150
			default_cooldown = 400

			Use(mob/human/user)
				user.combat("<font color=#5CB3FF ><b> You turn into a shark like figure</b>")
				user.dir=SOUTH
				user.stunned=1
				flick('icons/shark_animation.dmi', user)
				sleep(10)

				if(!user) return

				user.fusion=1
				user.jutsunumber=rand(2,4)
				user.combat("You are able to use water jutsu without water [user.jutsunumber] times")
				user.Affirm_Icon()

				spawn(Cooldown(user)*7)
					if(!user) return
					user.fusion=0
					user.jutsunumber=0
					user.Affirm_Icon()