skill
	jashin
		copyable = 0




		stab_self
			id = MASOCHISM
			name = "Stab Self"
			icon_state = "masachism"
			default_chakra_cost = 0
			default_cooldown = 6



			Use(mob/user)
				var/body_part=pick(
					"Foot",
					"Head",
					"Arm",
					"Heart",
				)

				oviewers(user) << output("[user] stabbed himself in the [body_part]!", "combat_output")
				user.combat("You stabbed yourself!")
				var/mob/F
				if(user.Contract)
					var/obj/C = user.Contract
					if(user.loc==C.loc)
						if(user.Contract2)
							F=user.Contract2

				switch(body_part)
					if("Foot")
						user.Wound(6,3,user)
						if(F)
							F.combat("You have been stabbed in the [body_part]!")
							F.stunned=rand(2,3)
					if("Head")
						user.Wound(8,3,user)
						if(F)F.combat("You have been stabbed in the [body_part]!")
						var/bleed=pick(2,4,6)
						spawn(10)
							while(bleed>0)
								bleed--
								sleep(15)
								if(F)
									F.Dec_Stam(200,0,usr)
									Blood2(F,user)
					if("Arm"||"Leg")
						user.Wound(4,3,user)
						if(F)
							F.combat("You have been stabbed in the [body_part]!")
							F.move_stun+=rand(30,50)
					if("Heart")
						user.Wound(10,3,user)
						if(F)F.combat("You have been stabbed in the [body_part]!")
				Blood2(user)




		blood_possession
			id = BLOOD_BIND
			name = "Sorcery: Death-Ruling Possession Blood"
			icon_state = "blood contract"
			default_chakra_cost = 450
			default_cooldown = 200



			Use(mob/user)
				var/list/Choose=user.bloodrem.Copy()
				for(var/mob/human/F in Choose)
					if(F.protected||F.ko||F.z!=user.z)
						Choose-=F

				var/mob/T=new()
				T.name="Nevermind"
				Choose+=T
				var/mob/C=input3(user,"Pick somebody to put a curse on","Blood Contract",Choose)
				if(C!=T)
					user.bloodrem.Cut()
					var/obj/jashin_circle/J=new(user.loc)
					user.Contract=J
					user.Contract2=C
					user.icon='icons/jashin_base.dmi'
					spawn(1800)
						if(J)
							J.loc = null
							if(user)
								user.Contract = null
								user.Contract2=0
								user.Affirm_Icon()
				else if(T=="Nevermind")
					default_cooldown = 3




		wound_regeneration
			id = WOUND_REGENERATION
			name = "Wound Regeneration"
			icon_state = "wound regeneration"
			default_chakra_cost = 100
			default_cooldown = 15



			Use(mob/user)
				user.overlays+='icons/base_chakra.dmi'
				user.usemove=1
				sleep(5)
				user.overlays-='icons/base_chakra.dmi'

				sleep(25)
				if(!user)
					return
				if(user.usemove)
					user.curwound-=rand(2,10)
					user.usemove=0
				if(user.curwound<0)
					user.curwound=0




		immortality
			id = IMMORTALITY
			name = "Immortality"
			icon_state = "imortality"
			default_chakra_cost = 400
			default_cooldown = 500

			Use(mob/user)
				if(user.immortality<500)
					var/found=0
					for(var/mob/corpse/C in oview(10,user))
						found=1
						user.immortality+=60+C.blevel*2
						user.combat("You pray to Jashin to grant you immortality and sacrifice [C], you gain [60+C.blevel*2] seconds of Immortality!")
						user.icon_state="Chakra"
						user.stunned=10

						sleep(100)
						user.icon_state=""
						if(C)del(C)
						user.stunned=0
						break
					if(!found)
						return
					if(user.immortality>500)
						user.immortality=500
						default_cooldown = 650
