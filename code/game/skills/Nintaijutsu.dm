mob/var
	super_speed_contract=0
	lightning_armor=0

	player_target=0

skill
	nintaijutsu
		copyable = 0

		lariat
			id = LARIAT
			name = "Lariat"
			icon_state = "lariat"
			default_chakra_cost = 100
			default_stamina_cost = 200
			default_cooldown = 35

			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(. && target)
					var/distance = get_dist(user, target)
					if(distance > 3&&!target.player_target)
						Error(user, "Target too far ([distance]/3 tiles)")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Lariat!", "combat_output")
				var/mob/human/etarget = user.MainTarget()
				flick("PunchA-1",user)

				if(etarget)
					if(etarget.player_target)
						etarget.player_target=0
						user.super_speed_contract-=1
				else return

				if(user&&etarget)

					user.dir=etarget.loc
					user.AppearBefore(etarget)
					spawn(3) user.AppearBehind(etarget)

					var/result=Roll_Against(user.str+user.strbuff-user.strneg,etarget.str+etarget.strbuff-etarget.strneg,60)

					if(etarget)
						if(result>=6)
							etarget.Dec_Stam(1800,0,user)
							spawn()Blood2(etarget,user)
							etarget.Wound(rand(0, 2), 0, user)
							etarget.movepenalty+=3
						if(result==5)
							etarget.Dec_Stam(1500,0,user)
							spawn()Blood2(etarget,user)
							etarget.Wound(rand(0, 1), 0, user)
						if(result==4)
							etarget.Dec_Stam(1200,0,user)
							spawn()Blood2(etarget,user)
							etarget.Wound(rand(0, 1), 0, user)
						if(result==3)
							etarget.Dec_Stam(1000,0,user)
							spawn()Blood2(etarget,user)

						if(result==2)
							etarget.Dec_Stam(800,0,user)

						if(result==1)
							etarget.Dec_Stam(600,0,user)

						spawn()etarget.Hostile(user)


		lightning_release_armor
			id = LIGHTNING_ARMOR
			name = "Nintaijutsu: Lightning Release Armor"
			icon_state = "lightning_armor"
			default_chakra_cost = 100
			default_cooldown = 280

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.lightning_armor)
						Error(user, "This jutsu is already active")
						return 0
					if(user.ironskin)
						Error(user, "Earth: Iron Skin is already active.")
						return 0

			Use(mob/user)
				if(user.gate)
					user.combat("[usr] closes the gates.")
					user.CloseGates()
				viewers(user) << output("[user]: Lightning Release Armor!", "combat_output")

				var/buffstr=round(user.str*0.10)
				var/buffcon=round(user.con*0.16)
				user.strbuff+=buffstr
				user.conbuff+=buffcon

				usr.lightning_armor=1

				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user||!user.lightning_armor) return

					user.strbuff-=round(buffstr)
					user.conbuff-=round(buffcon)
					user.lightning_armor=0
					user.Affirm_Icon()

					user.super_speed_contract=0

					user.combat("The lightning Release Armor wore off.")


		lightning_oppression_horizontal
			id = HORIZONTAL_OPPRESSION
			name = "Nintaijutsu: Lightning Oppression Horizontal"
			icon_state = "oppression"
			default_stamina_cost = 200
			default_cooldown = 15

			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(. && target)
					var/distance = get_dist(user, target)
					if(!user.NearestTarget())
						Error(user, "No Target")
						return 0
					if(distance > 2&&!target.player_target)
						Error(user, "Target too far ([distance]/2 tiles)")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning Oppression Horizontal!", "combat_output")

				var/mob/human/x = user.MainTarget()

				if(x.player_target&&x)
					x.player_target=0
					user.super_speed_contract-=1

				user.AppearBehind(x)
				flick("PunchA-1",user)

				var/generate = pick(1,3)

				if(generate==1)
					x.Dec_Stam(rand(5,200)*user.ControlDamageMultiplier()+300,0,user)
					x.Knockback(4,user.dir)
					x.Wound(rand(0, 1), 0, user)
					x.movepenalty+=4
					spawn(6) user.AppearBehind(x)
				if(generate>=2)
					x.Dec_Stam(rand(20,150)*user.ControlDamageMultiplier()+300,0,user)
					x.movepenalty+=4
					x.icon_state="hurt"
					spawn(10) x.icon_state=""

				if(x&&user) spawn()x.Hostile(user)


		lightning_release_armor_2nd
			id = LIGHTNING_ARMOR_2ND
			name = "Lightning Release Armor 2nd State"
			icon_state = "lightning_armor_2nd"
			default_chakra_cost = 0
			default_cooldown = 160

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.lightning_armor)
						Error(user, "You need lightning armor on to activate this jutsu")
						return 0
					if(user.lightning_armor>=2)
						Error(user, "This jutsu is already active")
						return 0
					if(user.ironskin)
						Error(user, "Earth: Iron Skin is already active.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Lightning Release Armor 2nd State!", "combat_output")

				usr.lightning_armor=2

				var/buffstr=round(user.str*0.05)
				var/buffcon=round(user.con*0.30)
				user.strbuff+=buffstr
				user.conbuff+=buffcon

				user.super_speed_contract=0

				user.Affirm_Icon()

				spawn()
					while(user.lightning_armor>=2)
						sleep(rand(20,40))
						if(prob(10))
							if(user) user.Wound(rand(1,3),0,user)
						else
							if(user) user.Wound(rand(0,1),0,user)

				spawn(Cooldown(user)*5)
					if(!user) return

					if(user&&user.lightning_armor==2)

						user.strbuff-=round(buffstr)
						user.conbuff-=round(buffcon)
						user.lightning_armor=0
						user.Affirm_Icon()

						user.combat("The lightning Release Armor wore off.")