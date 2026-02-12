mob/var
	puppets1000=0
	human_puppet=0
skill
	puppet
		copyable = 0




		puppet_summoning
			default_cooldown = 60



			var
				puppet_num



			Cooldown(mob/user)
				var/puppet_var = "Puppet[puppet_num]"
				var/mob/human/Puppet/puppet = user.vars[puppet_var]
				if(!puppet)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: [src]!", "combat_output")
				var/puppet_var = "Puppet[puppet_num]"
				var/mob/human/Puppet/puppet = user.vars[puppet_var]
				if(!puppet && user.Puppets.len >= puppet_num && user.Puppets[puppet_num])
					var/obj/items/Puppet/P1=user.Puppets[puppet_num]
					var/typ = P1.summon
					Poof(user.x,user.y,user.z)

					puppet = new typ(user.loc)
					puppet.rfx = user.rfx
					puppet.name = P1.name
					puppet.faction = user.faction
					P1.incarnation = puppet
					user.vars[puppet_var] = puppet
					spawn() puppet.PuppetRegen(user)
				else if(puppet)
					Poof(puppet.x,puppet.y,puppet.z)
					del(puppet)




			first
				id = PUPPET_SUMMON1
				name = "Summoning: First Puppet"
				icon_state = "puppet1"
				puppet_num = 1




			second
				id = PUPPET_SUMMON2
				name = "Summoning: Second Puppet"
				icon_state = "puppet2"
				puppet_num = 2




		puppet_transform
			id = PUPPET_HENGE
			name = "Puppet Transform"
			icon_state = "puppethenge"
			default_chakra_cost = 50
			default_cooldown = 25



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.Primary)
						Error(user, "Must be directly controlling a puppet")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Puppet Transform!", "combat_output")
				if(user.Primary)
					var/mob/human/puppet = user.Primary
					if(!puppet.icon_state)
						flick(puppet,"Seal")
					Poof(puppet.x,puppet.y,puppet.z)

					puppet.icon=user.icon
					puppet.realname=puppet.name
					puppet.name=user.name
					puppet.overlays=user.overlays
					puppet.mouse_over_pointer=user.mouse_over_pointer
					puppet.phenged=1
					spawn(1200)//recover
						if(puppet && puppet.phenged)
							puppet.mouse_over_pointer=faction_mouse[puppet.faction.mouse_icon]
							puppet.name=puppet.realname
							puppet.phenged=0
							Poof(puppet.x,puppet.y,puppet.z)
							puppet.overlays=0
							puppet.icon=initial(puppet.icon)



		performance_of_one_thousand_puppets
			id = PUPPETS_1000
			name = "Red Secret Technique: Performance of one Thousand Puppets"
			icon_state = "thousand"
			default_chakra_cost = 1200
			default_cooldown = 400

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.human_puppet)
						Error(user, "Human Puppet must be activated to use this jutsu")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Behold true strength!", "combat_output")
				sleep(25)
				viewers(user) << output("[user]: Red Secret Technique!", "combat_output")
				sleep(10)
				viewers(user) << output("[user]: Performance of one Thousand Puppets!", "combat_output")
				user.combat("press <b>z</b> or <b>click</b> the puppet icon to summon puppets. Duration is based on your reflex and strength")

				user.overlays+=image('1000secret.dmi',icon_state="1",pixel_x=-48)
				user.overlays+=image('1000secret.dmi',icon_state="2",pixel_x=-16)
				user.overlays+=image('1000secret.dmi',icon_state="3",pixel_x=16)
				user.overlays+=image('1000secret.dmi',icon_state="4",pixel_x=48)
				user.overlays+=image('1000secret.dmi',icon_state="5",pixel_x=-48,pixel_y=32)
				user.overlays+=image('1000secret.dmi',icon_state="6",pixel_x=-16,pixel_y=32)
				user.overlays+=image('1000secret.dmi',icon_state="7",pixel_x=16,pixel_y=32)
				user.overlays+=image('1000secret.dmi',icon_state="8",pixel_x=48,pixel_y=32)
				user.overlays+=image('1000secret.dmi',icon_state="9",pixel_x=-48,pixel_y=64)
				user.overlays+=image('1000secret.dmi',icon_state="10",pixel_x=-16,pixel_y=64)
				user.overlays+=image('1000secret.dmi',icon_state="12",pixel_x=16,pixel_y=64)
				user.overlays+=image('1000secret.dmi',icon_state="13",pixel_x=48,pixel_y=64)
				user.overlays+=image('1000secret.dmi',icon_state="14",pixel_x=-48,pixel_y=96)
				user.overlays+=image('1000secret.dmi',icon_state="15",pixel_x=-16,pixel_y=96)
				user.overlays+=image('1000secret.dmi',icon_state="16",pixel_x=16,pixel_y=96)
				user.overlays+=image('1000secret.dmi',icon_state="17",pixel_x=48,pixel_y=96)
				user.puppets1000=1
				user.Affirm_Icon()
				var/P = 300 + round(150 * user.ControlDamageMultiplier())

				var/obj/trigger/performance_of_one_thousand_puppets/T = new/obj/trigger/performance_of_one_thousand_puppets(user, user.x, user.y, user.z)
				user.AddTrigger(T)

				spawn(P)
					if(user)
						user.puppets1000=0
						user.Affirm_Icon()
						user.Load_Overlays()
						user.RemoveTrigger(T)



		puppet_swap
			id = PUPPET_SWAP
			name = "Puppet Swap"
			icon_state = "puppetswap"
			default_chakra_cost = 100
			default_cooldown = 45



			IsUsable(mob/user)
				. = ..()
				if(.)
					var/list/valid=new
					if(user.Puppet1 && user.Puppet1.z==user.z)
						valid+=user.Puppet1
					if(user.Puppet2 && user.Puppet2.z==user.z)
						valid+=user.Puppet2
					if(!valid.len)
						Error(user, "No valid puppet")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Puppet Swap!", "combat_output")
				var/list/valid=new
				if(user.Puppet1 && user.Puppet1.z==user.z)
					valid+=user.Puppet1
				if(user.Puppet2 && user.Puppet2.z==user.z)
					valid+=user.Puppet2
				if(length(valid))
					var/mob/sw=pick(valid)
					Poof(user.x,user.y,user.z)
					var/turf/Tq=user.loc
					user.loc=sw.loc
					sw.loc=Tq
					walk(sw,0)
					user.client.eye=sw
					user.Primary=sw


		human_puppet
			id = HUMAN_PUPPET
			name = "Human Puppet"
			icon_state = "human_puppet"
			default_chakra_cost = 800
			default_cooldown = 600

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.human_puppet)
						Error(user, "You are already using this Jutsu")
						return 0

			Use(mob/user)
				user.human_puppet=1
				user.Affirm_Icon()

		puppet_weapons
			default_cooldown = 20

			var
				puppet_weap_num

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.human_puppet)
						Error(user, "You must be using the Human Puppet Technique to use this Jutsu")
						return 0

			Use(mob/human/user)
				user.PuppetSkill(puppet_weap_num,user)

			first
				id = PUPPET_WEAPON_1
				name = "Hidden Knife Shot (H)"
				icon_state = "mouthknife"
				puppet_weap_num = 1

			second
				id = PUPPET_WEAPON_2
				name = "Poison Bomb (H)"
				icon_state = "poisonbomb"
				puppet_weap_num = 2

			third
				id = PUPPET_WEAPON_3
				name = "Body Crush (H)"
				icon_state = "armbind"
				puppet_weap_num = 3

			fourth
				id = PUPPET_WEAPON_4
				name = "Poison Tipped Blade (H)"
				icon_state = "mild-poison"
				puppet_weap_num = 4

			fifth
				id = PUPPET_WEAPON_5
				name = "Needle Gun (H)"
				icon_state = "needlegun"
				puppet_weap_num = 5

			sixth
				id = PUPPET_WEAPON_6
				name = "Chakra Shield (H)"
				icon_state = "chakrashield"
				puppet_weap_num = 6


obj
	trigger
		performance_of_one_thousand_puppets
			icon_state = "performance_of_one_thousand_puppets"

		Use()
			var/mob/human/player/etarget = user.MainTarget()
			if(etarget)
				var/multiplier=(user.rfx+user.rfxbuff-user.rfxneg)/(etarget.rfx+etarget.rfxbuff-etarget.rfxneg)
				var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
				var/puppets=pick("1","2","3")
				switch(puppets)
					if("1")
						if(etarget)
							new/obj/puppet1(locate(etarget.x,etarget.y,etarget.z))
							if(result>=5)
								etarget.Dec_Stam(500*multiplier,0,user)
							if(result==4)
								etarget.Dec_Stam(400*multiplier,0,user)
							if(result==3)
								etarget.Dec_Stam(300*multiplier,0,user)
							if(result==2)
								etarget.Dec_Stam(200*multiplier,0,user)
							if(result==1)
								etarget.Dec_Stam(100*multiplier,0,user)
							if(result<=0)
								user.combat("[etarget] managed to dodge an attack from the puppets!")
								etarget.combat("You managed to dodge all of [user]'s attacks from the puppets!")
								(oviewers(user)-etarget) << output("[etarget] managed to dodge all of the [user]'s puppet attacks!", "combat_output")
							etarget.Hostile(user)
					if("2")
						if(etarget)
							new/obj/puppet2(locate(etarget.x,etarget.y,etarget.z))
							if(result>=5)
								etarget.Dec_Stam(400*multiplier,0,user)
							if(result==4)
								etarget.Dec_Stam(300*multiplier,0,user)
							if(result==3)
								etarget.Dec_Stam(200*multiplier,0,user)
							if(result==2)
								etarget.Dec_Stam(100*multiplier,0,user)
							if(result==1)
								etarget.Dec_Stam(50*multiplier,0,user)
							if(result<=0)
								user.combat("[etarget] managed to dodge an attack from the puppets!")
								etarget.combat("You managed to dodge all of [user]'s attacks from the puppets!")
								(oviewers(user)-etarget) << output("[etarget] managed to dodge all of the [user]'s puppet attacks!", "combat_output")
							etarget.Hostile(user)
					if("3")
						if(etarget)
							new/obj/puppet3(locate(etarget.x,etarget.y,etarget.z))
							if(result>=5)
								etarget.Dec_Stam(300*multiplier,0,user)
							if(result==4)
								etarget.Dec_Stam(200*multiplier,0,user)
							if(result==3)
								etarget.Dec_Stam(100*multiplier,0,user)
							if(result==2)
								etarget.Dec_Stam(70*multiplier,0,user)
							if(result==1)
								etarget.Dec_Stam(40*multiplier,0,user)
							if(result<=0)
								user.combat("[etarget] managed to dodge an attack from the puppets!")
								etarget.combat("You managed to dodge all of [user]'s attacks from the puppets!")
								(oviewers(user)-etarget) << output("[etarget] managed to dodge all of the [user]'s puppet attacks!", "combat_output")
							etarget.Hostile(user)
			else return
	puppet1
		icon='icons/1000.dmi'
		icon_state=""
		density=1
		New()
			src.icon_state="end"
			flick("flick1",src)
			spawn(20)
				del(src)

	puppet2
		icon='icons/1000.dmi'
		icon_state=""
		density=1
		New()
			src.icon_state="end"
			flick("flick2",src)
			spawn(20)
				del(src)

	puppet3
		icon='icons/1000.dmi'
		icon_state=""
		density=1
		New()
			src.icon_state="end"
			flick("flick",src)
			spawn(20)
				del(src)