mob/var/hearts
skill
	scavenger
		copyable = 0

		heart_extraction
			id = HEART_EXTRACTION
			name = "Heart Extraction"
			icon_state = "heart_extraction"
			default_chakra_cost = 300
			default_cooldown = 120


			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.carrying.len)
						Error(user, "You have to be carrying a corpse to use this Jutsu")
						return 0
					if(user.hearts>=5)
						Error(user, "You have reached your Maximum Capacity on Hearts")
						return 0


			Use(mob/user)
				for(var/mob/corpse/C in oview(1,user))
					if(user.carrying.Find(C))
						user.dir=get_dir(user,C)
						user.icon_state="Throw2"
						user.stunned=3
						sleep(30)
						Blood2(C)
						if(!user) return
						user.hearts+=1
						user.combat("You have taken [C]'s Heart! You now have a Total of [user.hearts] hearts.")
						user.icon_state=""
						spawn(5)
							if(C)del(C)
						user.stunned=0
						if(user.hearts > 5)
							user.hearts = 5
						break

		generate_heart
			id = GENERATE_HEART
			name = "Heart Generation"
			icon_state = "heart_generation"
			default_chakra_cost = 1650
			default_cooldown = 300

			IsUsable(mob/user)
				.=..()
				if(.)
					if(user.hearts>= 5)
						Error(user, "You have reached your Maximum Capacity on Hearts")
						return 0

			Use(mob/user)
				if(user)
					user.stunned = 20
					spawn(200)
						if(user.stunned)
							user.stunned=0
					user.combat("You have successfully generated an artifical heart.")
					user.hearts+= 1
					user.combat("You now have [user.hearts] hearts.")
					if(user.hearts > 5)
						user.hearts = 5

