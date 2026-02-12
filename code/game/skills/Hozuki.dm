mob/var
	hydrated=0
	waterarm=0
	hozuki=0
skill
	hozuki
		copyable = 0

		hydrate
			id = HYDRATION
			name = "Hydrification"
			icon_state = "hydrate"
			default_chakra_cost = 200
			default_cooldown = 260

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.hydrated)
						Error(user, "Hydrification is already active.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Hydrification!", "combat_output")
				user.combat("Press <u><b>Space</b></u> to activate hydrification to be invulnerable to attacks")
				user.hydrated=1
				spawn(Cooldown(user)*7)
					if(!user) return
					user.hydrated=0
					user.combat("Your Hydrification wore off.")


		water_gun
			id = WATER_GUN
			name = "Water Gun Technique"
			icon_state = "water gun"
			default_chakra_cost = 80
			default_cooldown = 10

			Use(mob/human/user)
				viewers(user) << output("[user]: Water Gun Technique!", "combat_output")
				flick("Throw1",user)
				var/obj/trailmaker/o=new/obj/water_shot()
				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,10,user)
				if(result)
					del(o)
					result.Dec_Stam(400+300*user:ControlDamageMultiplier(),1,user)
					spawn()Blood2(result)
					spawn()result.Hostile(user)

		water_arm
			id = WATER_ARM
			name = "Great Water Arm"
			icon_state = "waterarm"
			default_chakra_cost = 300
			default_cooldown = 280

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.waterarm)
						Error(user, "Great Water Arm is already active")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Great Water Arm Technique!", "combat_output")
				user.waterarm=1
				var/buffrfx=round(user.rfx*0.33)
				var/buffstr=round(user.str*0.23)
				user.rfxbuff+=buffrfx
				user.strbuff+=buffstr

				spawn(Cooldown(user)*9)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.strbuff-=round(buffstr)
					user.waterarm=0
					user.combat("Your Great Water Arm wore off.")


obj/water_shot
	icon='icons/water_gun.dmi'