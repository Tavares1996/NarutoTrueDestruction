mob/var
	tmp/hiraishin[0]
	spacetimebarrier=0
skill
	space_time
		copyable=0

		space_time_migration_teleportation
			id = SPACETIME_MIGRATION
			name = "Space-Time: Migration"
			icon_state = "migration"
			default_chakra_cost = 250
			default_cooldown = 120

			Use(mob/user)
				user.combat("If you press <b>z</b> or <b>click</b> the Space-Time Migration icon on the left side of your screen within the next 4 minutes, you will teleport your target to that location.")
				for(var/obj/trigger/kamui_teleport/T in user.triggers)
					user.RemoveTrigger(T)

				var/obj/trigger/kamui_teleport/T = new/obj/trigger/kamui_teleport(user, user.x, user.y, user.z)

				user.AddTrigger(T)

				spawn(2400)
					if(user) user.RemoveTrigger(T)

		marking
			id = SPACETIME_HIRAISHIN_MARKING
			name = "Hiraishin Marking"
			icon_state = "marking"
			default_chakra_cost = 300
			default_cooldown = 30
			copyable = 0

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.hiraishin.len>=5)
						Error(user, "You have reached your cap on kunais")
						return 0

			Use(mob/user)
				var/obj/thunder_god/O=new/obj/thunder_god(user)
				O.name="Thunder God Kunai"
				O.density=1
				O.icon='thunder_god_kunai.dmi'
				O.dir=user.dir
				O.owner = user

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

				var/tiles=5
				var/hit=0
				while(user&&O&&tiles>0&&!hit)
					var/old_loc = O.loc
					for(var/mob/M in O.loc)
						if(M!=user)
							user.hiraishin+=M
							O.loc=null
							O.icon_state="Stuck"
							hit=1
							break
					step(O,O.dir)
					tiles--
					if(O.loc == old_loc)
						tiles = 0
						continue
					sleep(1)
				if(user)
					if(!hit)
						O.name="[O.name] ([O.x],[O.y])"
						O.icon_state="Stuck"
						user.hiraishin+=O
				O.density = 0


		flying_thunder_god_technique
			id = SPACETIME_FLYING_GOD
			name = "Space Time: Flying Thunder God Technique"
			icon_state = "thundergod"
			default_chakra_cost = 600
			default_cooldown = 60

			Use(mob/user)
				var/list/L=user.hiraishin
				L+="Nevermind"
				var/atom/spot=input("Where would you like to Teleport to") as anything in L
				L-="Nevermind"
				if(spot=="Nevermind")
					default_cooldown = 3
					return
				else
					default_cooldown = initial(default_cooldown)
					L-=spot
					var/obj/mapinfo/Minfo =  locate("__mapinfo__[spot.z]")
					var/obj/mapinfo/Minfo_ =  locate("__mapinfo__[user.z]")
					if(!Minfo||!Minfo_||(capture_the_flag && capture_the_flag.HasFlag(user)))
						user<<"System stopped you from teleporting in the conditions your in"
						default_cooldown = 3
						return

					if((Minfo&&Minfo_)||user.used_arena=="regular"||user.used_arena=="chuunin"||user.used_arena=="island"||user.used_arena=="konoha")
						spawn()Poof(user.x,user.y,user.z)
						user.loc=spot.loc
						spawn()Poof(spot.x,spot.y,spot.z)
						if(istype(spot,/obj/thunder_god))
							var/obj/thunder_god/T=spot
							T.loc=null
						if(ismob(spot))
							var/mob/M=spot
							M.stunned+=1



		space_time_barrier
			id = SPACETIME_BARRIER
			name = "Space Time: Barrier"
			icon_state = "spacetimebarrier"
			default_chakra_cost = 300
			default_cooldown = 120

			Use(mob/human/user)
				viewers(user) << output("[user]: Space Time Barrier!", "combat_output")
				user.combat("This technique will be active for 30 seconds")
				user.spacetimebarrier=1
				spawn(300)
					if(user&&user.spacetimebarrier==1)
						user.spacetimebarrier=0

		time_alteration
			id = SPACETIME_TIME_ALTERATION
			name = "Space Time: Time Alteration Technique"
			icon_state = "spacetime"
			default_chakra_cost = 600
			default_cooldown = 245

			Use(mob/user)
				if(!user) return
				viewers(user) << output("[user]: Space Time: Time Alteration Technique", "combat_output")
				for(var/mob/human/M in oview(8))
					M.stunned=2
					M.movepenalty+=100
					M.usemove=1
					spawn(200)
						if(user && M)
							M.movepenalty=0
							user.movepenalty-=50
							M.movepenalty+=0
							M.usemove=0

obj
	space
		icon='icons/space.dmi'
		layer=MOB_LAYER+1
		New()
			..()
			flick("1",src)
			spawn(20)
				del(src)

obj
	thunder_god
		Click()
			if(src.owner == usr)
				if(src in oview(1,usr))
					src.Get(usr)
		verb
			Get()
				set src in oview(1)
				if(!usr.ko)
					Move(usr)
					for(var/skill/s in usr.skills)
						if(s.id == SPACETIME_FLYING_GOD)
							s.cooldown = 0
							usr.hiraishin.len-=1
			Drop()
				src.loc=locate(usr.x,usr.y,usr.z)

		New(mob/user)
			spawn()
				while(user&&src&&src.loc!=null)
					sleep(1)
				if(src)
					src.loc=null

	spaceshield
		icon='icons/spaceshield.dmi'