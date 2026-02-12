mob/var
	curse_seal=0
skill
	genius
		copyable=0

		id = CURSE_SEAL
		name = "Curse Seal"
		default_chakra_cost = 500
		default_cooldown = 300
		icon_state = "cursed"

		IsUsable(mob/user)
			.=..()
			if(.)
				if(user.curse_seal)
					Error(user, "You're already in cursed seal")
					return 0

		Use(mob/user)
			viewers(user) << output("[user]'s skin has begun to fill with black marks..", "combat_output")

			user.curse_seal = 1
			user.dir = SOUTH
			user.stunned = 8

			if(!user) return
/*
			if(user.con>user.rfx && user.con>user.int && user.con>user.str)
				buffcon=round(user.con*0.37)
				user.conbuff+=buffcon
				if(user.rfx>user.int && user.rfx>user.str)
					buffrfx=round(user.rfx*0.28)
					user.rfxbuff+=buffrfx
				else if(user.int>user.rfx && user.int>user.str)
					buffint=round(user.int*0.28)
					user.intbuff+=buffint
				else if(user.str>user.int && user.str>user.rfx)
					buffstr=round(user.str*0.28)
					user.strbuff+=buffstr
			else if(user.str>user.rfx && user.str>user.int && user.str>user.con)
				buffstr=round(user.str*0.37)
				user.strbuff+=buffstr
				if(user.rfx>user.int && user.rfx>user.con)
					buffrfx=round(user.rfx*0.28)
					user.rfxbuff+=buffrfx
				else if(user.int>user.rfx && user.int>user.con)
					buffint=round(user.int*0.28)
					user.intbuff+=buffint
				else if(user.con>user.int && user.con>user.rfx)
					buffcon=round(user.con*0.28)
					user.conbuff+=buffcon
			else if(user.int>user.rfx && user.int>user.con && user.int>user.str)
				buffint=round(user.int*0.37)
				user.intbuff+=buffint
				if(user.rfx>user.str && user.rfx>user.con)
					buffrfx=round(user.rfx*0.28)
					user.rfxbuff+=buffrfx
				else if(user.str>user.rfx && user.str>user.con)
					buffstr=round(user.str*0.28)
					user.strbuff+=buffstr
				else if(user.con>user.str && user.con>user.rfx)
					buffcon=round(user.con*0.28)
					user.conbuff+=buffcon
			else if(user.rfx>user.con && user.rfx>user.int && user.rfx>user.str)
				buffrfx=round(user.rfx*0.37)
				user.rfxbuff+=buffrfx
				if(user.int>user.str && user.int>user.con)
					buffint=round(user.int*0.28)
					user.intbuff+=buffint
				else if(user.str>user.int && user.str>user.con)
					buffstr=round(user.str*0.28)
					user.strbuff+=buffstr
				else if(user.con>user.str && user.con>user.int)
					buffcon=round(user.con*0.28)
					user.conbuff+=buffcon
			else*/

			flick('Cs formation.dmi',user)
			sleep(10)
			if(user.stunned > 1&&user)
				user.stunned = 0
				user.Affirm_Icon()

			spawn(Cooldown(user)*8)
				if(!user) return
				user.curse_seal = 0
				viewers(user) << output("[user]'s cursed seal withdraws.")
				user.Affirm_Icon()