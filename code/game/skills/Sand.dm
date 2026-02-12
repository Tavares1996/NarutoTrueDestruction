mob/var/shukaku_cloak=0
skill
	sand_control
		copyable = 0


		sand_spear
			id = SAND_SPEAR
			name = "Sand Spear"
			icon_state = "sand_spear"
			default_chakra_cost = 700
			default_cooldown = 90

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.qued || user.qued2)
						Error(user, "A conflicting skill is already activated")
						return 0
					var/has_sand = 0
					for(var/mob/human/sandmonster/X in oview(10,user))
						has_sand = 1
						break
					if(!has_sand)
						for(var/turf/Terrain/Sand/X in oview(10,user))
							has_sand = 1
							break
					if(!has_sand)
						Error(user, "No sand available")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Spear!", "combat_output")
				user.stunned=1
				var/turf/From=null
				for(var/mob/human/sandmonster/X in oview(10,user))
					if(!From)
						From=X.loc
				if(!From)
					for(var/turf/Terrain/Sand/X in oview(10,user))
						if(!From)
							From=X
							break
				if(From)
					var/eicon='icons/Shukaku spear.dmi'
					var/estate=""
					var/mob/human/player/etarget = user.NearestTarget()

					if(!etarget)
						etarget=straight_proj2(eicon,estate,8,From)
						if(etarget)
							etarget.Dec_Stam(rand(1000,2000),0,user)
							etarget.Wound(rand(3,6),0,user)
							etarget.stunned=2
							Blood(etarget.x,etarget.y,etarget.z)
							var/obj/s=new/obj/sandshield(etarget.loc)
							spawn(20) del(s)
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))

						projectile_to(eicon,estate,From,x)
						var/obj/s=new/obj/sandshield(x.loc)
						for(var/mob/human/M in view(2,x))
							M.Dec_Stam(rand(1000,2000),0,user)
							M.Wound(rand(3,6),0,user)
							M.stunned=2
							Blood(M.x,M.y,M.z)
						del(x)
						spawn(20) del(s)

		shukaku_armor
			id = SHUKAKU_ARMOR
			name = "Shukaku Armor"
			icon_state = "shukaku_armor"
			default_chakra_cost = 450
			default_cooldown = 1500

			IsUsable(mob/user)
				.=..()
				if(.)
					if(user.gate||!user.Get_Sand_Pet())
						Error(user, "You can't use this jutsu; you're trying to stack or you don't have any active sand summon's.")
						return 0
					if(user.shukaku_cloak)
						Error(user, "You are already using this jutsu.")
						return 0
					if(user.ironskin)
						Error(user, "You are not allowed to use this jutsu in collaberation with the one active already.")
						return 0
					if(user.sandarmor)
						Error(user, "You are not allowed to use this jutsu in collaberation with the one active already.")
						return 0

			Cooldown(mob/user)
				return default_cooldown

			Use(mob/user)
				var/time
				if(user)
					user.protected = 1000
				time=(user.con/4)+5
				user.combat("You have gained access to bijuu defense, you will now be invulnerable for [time] seconds")
				user.shukaku_cloak = 1
				user.Affirm_Icon()
				spawn()
					while(user && user.shukaku_cloak && user.protected && time>0)
						if(user.curchakra>0&&user)
							user.curchakra-=rand(20,35)
						sleep(10)
						if(prob(20)&&user)
							sleep(1)
							user.curwound+=rand(1,2)
							user.combat("You have suffered a little bit of damage due to your collaberation with the demon bijuu shukaku")
					if(time <= 0 || !user.shukaku_cloak || !user)
						if(user)
							user.special=0
							if(user&&user.protected>0) user.protected=0
							user.shukaku_cloak=0
							user.Affirm_Icon()


		sand_summon
			id = SAND_SUMMON
			name = "Sand Summoning"
			icon_state = "sand_control"
			default_chakra_cost = 300
			default_cooldown = 10

			Use(mob/human/user)
				var/lim=0
				for(var/mob/human/x in user.pet)
					if(x)
						if(++lim > 3)
							del(x)
				if(!istype(user.pet, /list))user.pet=new/list
				viewers(user) << output("[user]: Sand Summoning!", "combat_output")

				var/mob/human/p=new/mob/human/sandmonster(user.loc)
				user.pet+=p
				p.initialized=1
				p.faction = user.faction
				p.con=user.con

				spawn()
					var/ei=1
					while(ei)
						ei=0
						for(var/mob/human/x in oview(10,p))
							if(x==user)
								ei=1
						sleep(20)
					if(p)
						//user.pet-=p
						del(p)




		sand_unsummon
			id = SAND_UNSUMMON
			name = "Sand Unsummoning"
			icon_state = "sand_unsummon"
			default_chakra_cost = 20
			default_cooldown = 3



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Unsummoning!", "combat_output")
				for(var/mob/human/sandmonster/X in user.pet)
					del(X)




		sand_shield
			id = SAND_SHIELD
			name = "Sand Shield"
			icon_state = "sand_shield"
			default_chakra_cost = 100
			default_cooldown = 20



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.Get_Sand_Pet())
						Error(user, "Cannot be used without summoned sand")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Shield!", "combat_output")
				var/mob/p=user.Get_Sand_Pet()

				if(p)
					p.density=0
					while(user && get_dist(user, p) > 1)
						user.stunned=2
						step_to(p,user,1)
						sleep(1)
						if(!p)
							if(user) user.stunned=0
							break
					if(!user)
						return
					if(p)
						p.invisibility=30
						var/obj/x=new/obj/sandshield(user.loc)
						user.protected=10
						while(user && user.protected)
							user.stunned=2
							sleep(1)
						if(user)
							user.stunned=0
						del(x)
						if(p)
							p.invisibility=1
							p.density=1




		desert_funeral
			id = DESERT_FUNERAL
			name = "Desert Funeral"
			icon_state = "desert_funeral"
			default_chakra_cost = 400
			default_cooldown = 120



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					if(!user.Get_Sand_Pet())
						Error(user, "Cannot be used without summoned sand")
						return 0



			Use(mob/human/user)
				var/mob/p=user.Get_Sand_Pet()
				var/mob/human/etarget = user.MainTarget()
				viewers(user) << output("[user]: Desert Funeral!", "combat_output")

				if(p)
					p.density=0
					var/effort=5
					while(p && etarget && get_dist(etarget, p) > 1 && effort > 0)
						step_to(p,etarget,0)
						sleep(2)
						effort--
					walk(p,0)
					if(!etarget || !p)
						return
					if(get_dist(etarget, p) <= 1)
						p.loc = etarget.loc
						var/target_loc = etarget.loc

						etarget.stunned=10
						p.layer=MOB_LAYER+1
						p.icon='icons/Gaara.dmi'
						p.icon_state="D-funeral"
						p.overlays=0
						for(var/obj/u in user.pet)
							user.pet-=u
						flick("D-Funeral-flick",p)

						sleep(20)
						spawn(50)
							if(p)
								del(p)
						if(etarget && etarget.loc == target_loc)
							etarget.Dec_Stam(3000+(rand(100,250)*user:ControlDamageMultiplier()),0,user)
							etarget.Wound(rand(5,15),0,user)
							etarget.Hostile(user)




		sand_armor
			id = SAND_ARMOR
			name = "Sand Armor"
			icon_state = "sand_armor"
			default_chakra_cost = 400
			default_cooldown = 90

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.ironskin)
						Error(user, "You are not allowed to use this jutsu in collaberation with the one active already.")
						return 0
					if(user.sandarmor)
						Error(user, "You are already using this jutsu.")
						return 0
					if(user.shukaku_cloak)
						Error(user, "You are not allowed to use this jutsu in collaberation with the one active already.")
						return 0
					if(user.gate)
						Error(user, "You can't use this jutsu; you're trying to stack or you don't have any active sand summon's.")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Armor!", "combat_output")
				user.sandarmor=rand(5,8)
				spawn()
					while(user && user.sandarmor)
						sleep(1)
					if(!user) return
					user.stunned=5
					user.protected=5
					user.dir=SOUTH
					var/obj/o = new/obj/sandarmor(user.loc)
					flick("break",o)
					o.density=0
					user.icon_state=""
					sleep(10)
					del(o)
					if(!user) return
					user.stunned=0
					user.protected=0




		sand_shuriken
			id = SAND_SHURIKEN
			name = "Sand Shuriken"
			icon_state = "sand_shuriken"
			default_chakra_cost = 300
			default_cooldown = 40



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.qued || user.qued2)
						Error(user, "A conflicting skill is already activated")
						return 0
					var/has_sand = 0
					for(var/mob/human/sandmonster/X in oview(10,user))
						has_sand = 1
						break
					if(!has_sand)
						for(var/turf/Terrain/Sand/X in oview(10,user))
							has_sand = 1
							break
					if(!has_sand)
						Error(user, "No sand available")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Sand Shuriken!", "combat_output")

				user.stunned=1

				var/turf/From=null
				for(var/mob/human/sandmonster/X in oview(10,user))
					if(!From)
						From=X.loc
				if(!From)
					for(var/turf/Terrain/Sand/X in oview(10,user))
						if(!From)
							From=X
							break
				if(From)
					var/obj/O = new/obj(From)
					O.icon='icons/sandshuriken.dmi'
					O.icon_state="sand"
					O.density=0
					O.layer=MOB_LAYER+1
					sleep(2)
					var/t=0
					while(O && user && O.loc != user.loc)
						step_to(O,user,0)
						t++
						sleep(5)
						for(var/mob/M in O.loc)
							if(M!=user)
								O.loc=null
								M.Dec_Stam(20*user.ControlDamageMultiplier(), 0, user)
						if(t>100)
							if(O)
								O.loc = null
							if(user)
								user.icon_state=""
								user.stunned=0
							return
					if(O)
						O.loc = null

						if(user)
							user.overlays+=image('icons/sandshuriken.dmi',icon_state="sand")

							user.qued2=1

					if(user)
						user.icon_state=""
						user.stunned=0




obj
	sandarmor
		icon='icons/sandarmor.dmi'
		icon_state="break"
		layer=MOB_LAYER+1




mob/proc
	Get_Sand_Pet()
		for(var/mob/human/sandmonster/X in src.pet)
			if(X && get_dist(X, src) <= 10 && !X.tired)
				return X


	Return_Sand_Pet(mob/owner)
		var/mob/human/sandmonster/x=src
		if(!x.tired)
			spawn()
				x.density=0
				walk_to(x,owner,0,1)
				sleep(6)
				x.density=1
				walk(x,0)
				x.tired=0
