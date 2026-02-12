skill
	nara
		copyable = 0




		shadow_binding
			id = SHADOW_IMITATION
			name = "Shadow Binding"
			icon_state = "shadow_imitation"
			default_chakra_cost = 50
			default_cooldown = 8



			ChakraCost(mob/user)
				if(!user.mane)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.mane)
					return ..(user)
				else
					return 0


			Use(mob/user)
				if(user.mane)
					user.combat("Remove!")
					user.mane=0
					ChangeIconState("shadow_imitation")
					return
				user.icon_state="Seal"
				user.stunned=10
				sleep(15)
				viewers(user) << output("[user]: Shadow Binding!", "combat_output")
				var/targets[] = user.NearestTargets(num=4)
				if(targets && targets.len)
					for(var/mob/human/player/etarget in targets)
						spawn()
							var/obj/trailmaker/o=new/obj/trailmaker/Shadow()
							var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,8,etarget)
							if(result)
								user.stunned=0
								o.icon=0
								++user.mane
								ChangeIconState("cancel_shadow")
								result.underlays+='icons/shadow.dmi'
								result.maned=user.key
								var/cost=10
								var/resultx=Roll_Against(user.con+user.conbuff-user.conneg,result.str+result.strbuff-result.strneg,100)
								if(resultx>=6)
									cost=user.chakra/60
								if(resultx==5)
									cost=user.chakra/50
								if(resultx==4)
									cost=user.chakra/40
								if(resultx==3)
									cost=user.chakra/35
								if(resultx==2)
									cost=user.chakra/20
								if(resultx==1)
									cost=user.chakra/10
								var/rx=result.x
								var/ry=result.y
								result.stunned = 3

								while(user && user.mane && user.curchakra>cost&&result&&result.x==rx&&result.y==ry)
									user.curchakra-=cost
									sleep(10)
								del(o)
								if(result)
									result.underlays-='icons/shadow.dmi'
									result.maned=0
									result.stunned=1
									if(user) spawn()result.Hostile(user)
							if(user)
								user.mane = max(0, user.mane - 1)
								if(!user.mane)
									user.icon_state=""
									user.stunned=0
									default_cooldown=40
									ChangeIconState("shadow_imitation")
				else
					var/obj/trailmaker/o=new/obj/trailmaker/Shadow()
					var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
					if(result)
						spawn()
							user.stunned=0
							o.icon=0
							user.mane=1
							ChangeIconState("cancel_shadow")
							var/cost=10
							result.underlays+='icons/shadow.dmi'
							result.maned=user.key
							var/resultx=Roll_Against(user.con+user.conbuff-user.conneg,result.str+result.strbuff-result.strneg,100)
							if(resultx>=6)
								cost=user.chakra/60
							if(resultx==5)
								cost=user.chakra/50
							if(resultx==4)
								cost=user.chakra/40
							if(resultx==3)
								cost=user.chakra/35
							if(resultx==2)
								cost=user.chakra/20
							if(resultx==1)
								cost=user.chakra/10
							var/rx=result.x
							var/ry=result.y
							result.stunned = 3
							while(result&&user&&user.mane && user.curchakra>cost&& result.x==rx&&result.y==ry)
								user.curchakra-=cost
								sleep(20)
							del(o)

							if(result)
								result.underlays-='icons/shadow.dmi'
								result.maned=0
								result.stunned=1
								if(user) spawn()result.Hostile(user)
							if(user)
								user.icon_state=""
								user.stunned=0
								user.mane=0
								ChangeIconState("shadow_imitation")
					else if(user)
						user.icon_state=""
						user.stunned=0
						user.mane=0




		shadow_neck_bind
			id = SHADOW_NECK_BIND
			name = "Shadow Neck Bind"
			icon_state = "shadow_neck_bind"
			default_chakra_cost = 100
			default_cooldown = 5



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.mane)
						Error(user, "Cannot be used without Shadow Binding active")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Shadow Neck Bind!", "combat_output")
				var/conmult = user.ControlDamageMultiplier()
				for(var/mob/human/x in oview(8))
					if(x.maned==user.key)
						var/obj/o =new/obj(locate(x.x,x.y,x.z))
						o.layer=MOB_LAYER+1
						o.icon='icons/shadowneckbind.dmi'
						spawn(18)
							if(x && !x.icon_state)
								flick("hurt",x)
						flick("choke",o)
						spawn(20)
							del(o)
						if(x) x.Dec_Stam((1000+(500*conmult)),0,user)
						spawn(50)if(x) x.Hostile(user)




		shadow_sewing
			id = SHADOW_SEWING_NEEDLES
			name = "Shadow Sewing"
			icon_state = "shadow_sewing_needles"
			default_chakra_cost = 200
			default_cooldown = 80
			var
				active_needles = 0



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Shadow Sewing!", "combat_output")
				user.icon_state="Seal"
				spawn(10)
					user.icon_state = ""
				user.stunned=10
				var/conmult = user.ControlDamageMultiplier()
				var/targets[] = user.NearestTargets(num=3)
				for(var/mob/human/player/target in targets)
					++active_needles
					spawn()
						var/obj/trailmaker/o=new/obj/trailmaker/Shadowneedle(locate(user.x,user.y,user.z))
						var/mob/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,target,1,1,0,0,1,user)
						if(result)
							result.Dec_Stam(rand(600, (700+150*conmult)), 0, user)
							result.Wound(rand(3, 5), 0, user)
							if(!result.ko && !result.protected)
								result.move_stun = 20
								spawn()Blood2(result,user)
								o.icon_state="still"
								spawn()result.Hostile(user)
						--active_needles
						if(active_needles <= 0)
							user.stunned = 0
						del(o)
					spawn()
						var/obj/trailmaker/o=new/obj/trailmaker/Shadowneedle(locate(user.x,user.y,user.z))
						var/mob/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,target,1,1,0,0,1,user)
						if(result)
							result.Dec_Stam(rand(600, (700+150*conmult)), 0, user)
							result.Wound(rand(3, 5), 0, user)
							if(!result.ko && !result.protected)
								result.move_stun = 20
								spawn()Blood2(result,user)
								o.icon_state="still"
								spawn()result.Hostile(user)
						--active_needles
						if(active_needles <= 0)
							user.stunned = 0
						del(o)
					spawn()
						var/obj/trailmaker/o=new/obj/trailmaker/Shadowneedle(locate(user.x,user.y,user.z))
						var/mob/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,target,1,1,0,0,1,user)
						if(result)
							result.Dec_Stam(rand(600, (700+150*conmult)), 0, user)
							result.Wound(rand(3, 5), 0, user)
							if(!result.ko && !result.protected)
								result.move_stun = 20
								spawn()Blood2(result,user)
								o.icon_state="still"
								spawn()result.Hostile(user)
						--active_needles
						if(active_needles <= 0)
							user.stunned = 0
						del(o)
