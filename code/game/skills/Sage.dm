mob/var
	sage_mode = 0
skill
	wof
		copyable=0
		sage_mode
			id = SAGE_MODE
			name = "Sennin Mode"
			icon_state = "sage"
			default_chakra_cost = 400
			default_cooldown = 260

			IsUsable(mob/user)
				.=..()
				if(.)
					if(user.sage_mode)
						Error(user, "You already have sage mode on.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user] has activated sage mode!")
				var/buffrfx=round(user.rfx*0.24)
				var/buffstr=round(user.str*0.32)
				var/buffcon=round(user.con*0.38)

				user.rfxbuff+=buffrfx
				user.strbuff+=buffstr
				user.conbuff+=buffcon
				user.sage_mode = 1

				spawn(Cooldown(user)*7)
					if(user)
						user.sage_mode = 0
						user.rfxbuff-=round(buffrfx)
						user.strbuff-=round(buffstr)
						user.conbuff-=round(buffcon)
						viewers(user)<<output("[user]'s sage chakra has settled.", "combat_outout")