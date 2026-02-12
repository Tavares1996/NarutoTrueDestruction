mob/var
	Transfered=0
	petals=0
	mind_attack=0
	controlling_yamanaka=0
skill
	yamanaka
		copyable = 0

		mind_transfer
			id = MIND_TRANSFER
			name = "Yamanaka: Mind Transfer"
			icon_state = "mindtransfer"
			default_chakra_cost = 300
			default_cooldown = 120

			Use(mob/user)
				if(user.Transfered)
					user.combat("Remove!")
					user.Transfered=0
					user.client:hellno=0
					ChangeIconState("mindtransfer")
					return
				user.icon_state="Seal"
				user.stunned=10
				sleep(15)
				viewers(user) << output("[user]: Mind Transfer!", "combat_output")
				var/mob/human/etarget=user.NearestTarget()
				if(etarget)
					spawn()
						var/obj/trailmaker/o=new/obj/trailmaker/Mind_Transfer()
						var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,8,etarget)
						if(result)
							spawn(1)
								del(o)
								flick("Knockout",user)
								user.icon_state="Dead"
								user.client:eye = result
								user.client:Controling= result
								user.client:perspective = EYE_PERSPECTIVE
								result.Transfered=result
								user.controlling_yamanaka=1
								sleep(200)
								user.client:eye = user
								user.client:Controling= user
								user.client:perspective = EYE_PERSPECTIVE
								result.Transfered=0
								user.controlling_yamanaka=0
								user.icon_state=""
						else
							user.stunned=0
							user.icon_state=""

		mind_tag
			id = MIND_TAG
			name = "Yamanaka: Mind Tag"
			icon_state="mindtag"
			default_chakra_cost=5
			default_cooldown = 60

			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 2)
						Error(user, "Target too far ([distance]/2 tiles)")
						return 0

			Use(mob/user)
				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					for(var/mob/human/M in get_step(user,user.dir))
						etarget=M
						break

				if(etarget&&(etarget in oview(user,2)))
					var/turf/p=etarget.loc
					user.icon_state="Throw2"

//					user.stunned=2
//					sleep(20)
					if(etarget && etarget.x==p.x && etarget.y==p.y)
						etarget.mindtag=1
						sleep(3)
						if(!etarget)
							return
						user.icon_state=""

						user.combat("If you press <b>z</b> or <b>click</b> the tag icon on the left side of your screen within the next 1 minute, you will take control of your target you set the tag on.")

						for(var/obj/trigger/mind_tag/T in user.triggers)
							user.RemoveTrigger(T)

						var/obj/trigger/mind_tag/T = new/obj/trigger/mind_tag(user, user.x, user.y, user.z)
						user.AddTrigger(T)

						spawn(600)
							etarget.mindtag=0
							if(user) user.RemoveTrigger(T)


		mind_disturbance
			id = MIND_DISTURBANCE
			name = "Yamanaka: Mind Disturbance"
			icon_state = "minddisturbance"
			default_chakra_cost = 140
			default_cooldown = 170

			Use(mob/human/user)
				if(!user) return
				viewers(user) << output("[user]: Mind Disturbance!", "combat_output")
				for(var/mob/human/M in oview(8))
					if(M!=user)
						M.stunned=2
						M.movepenalty+=100
						spawn(200)
							if(M)
								M.movepenalty=0


		flower_bomb
			id = FLOWER_BOMB
			name = "Flower Bomb"
			icon_state = "flower_bomb"
			default_chakra_cost = 300
			default_cooldown = 45
			face_nearest = 1

			Use(mob/human/user)
				viewers(user) << output("[user]: Flower Bomb!", "combat_output")
				var/damage = (user.con+user.conbuff-user.conneg/100)*2
				var/damageX2 = (user.con+user.conbuff-user.conneg/100)*4
				var/obj/trailmaker/o=new/obj/trailmaker/Flower_Bomb()
				user.stunned=8
				user.icon_state="Throw1"
				if(user.dir==NORTH)
					spawn(2)explosion(damage,user.x,user.y+3,user.z,user,0,2)
					spawn(2)
						explosion(damage,user.x,user.y+6,user.z,user,0,2)
				else if(user.dir==SOUTH)
					spawn(2)explosion(damage,user.x,user.y-3,user.z,user,0,2)
					spawn(2)
						explosion(damage,user.x,user.y-6,user.z,user,0,2)
				else if(user.dir==EAST)
					spawn(2)explosion(damage,user.x+3,user.y,user.z,user,0,2)
					spawn(2)
						explosion(damage,user.x+6,user.y,user.z,user,0,2)
				else if(user.dir==WEST)
					spawn(2)explosion(damage,user.x-3,user.y,user.z,user,0,2)
					spawn(2)
						explosion(damage,user.x-6,user.y,user.z,user,0,2)
				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,10,user)
				if(result)
					spawn(1) del(o)
					spawn(5)
						user.icon_state=""
						user.stunned=0
					spawn()explosion(damageX2,result.x,result.y,result.z,user,0,4)
					spawn()result.Hostile(user)
					result.movepenalty+=5

				else
					spawn(5) del(o)
					if(user.dir==NORTH)
						explosion(damageX2,user.x,user.y+8,user.z,user,0,4)
					if(user.dir==SOUTH)
						explosion(damageX2,user.x,user.y-8,user.z,user,0,4)
					if(user.dir==EAST)
						explosion(damageX2,user.x+8,user.y,user.z,user,0,4)
					if(user.dir==WEST)
						explosion(damageX2,user.x-8,user.y,user.z,user,0,4)
					spawn(5)
						user.stunned=0
						user.icon_state=""


		petal_dance
			id = PETAL_DANCE
			name = "Petal Dance"
			icon_state = "petal_dance"
			default_chakra_cost = 400
			default_cooldown = 50

			Use(mob/human/user)
				viewers(user) << output("[user]: Petal Dance", "combat_output")
				user.icon_state="Seal"
				user.stunned=20
				var/obj/petal/x=new/obj/petal(user.loc)
				sleep(6)
				del(x)
				user.overlays+='icons/petal_dance.dmi'
				var/ammo=rand(((user.con/10)/4),((user.con/10)/2))
				var/icon='icons/projectiles.dmi'
				var/state="petal"
				var/petal_pierce=user.con+user.conbuff-user.conneg * 5
				while(ammo>0)
					sleep(1)
					var/angle = rand(0, 360)
					var/speed = rand(48, 80)
					spawn() advancedprojectile_angle(icon, state, user, speed, angle, distance=10, damage=petal_pierce, wounds=rand(0,2), radius=20)
					ammo--
				user.icon_state=""
				user.overlays-='icons/petal_dance.dmi'
				user.stunned=0

		petal_escape
			id = PETAL_ESCAPE
			name = "Petals"
			icon_state = "petals"
			default_chakra_cost = 200
			default_cooldown = 180

			Use(mob/user)
				viewers(user) << output("[user]: Petals!", "combat_output")
				user.combat("For 10 seconds you will completly evade attacks (YOU ARE NOT INVULNERABLE!) and teleport behind your targeted person")
				user.petals=1
				spawn(100)
					user.petals=0
				if(user)
					user.Affirm_Icon()
					user.Load_Overlays()
					user.camo=0

obj
	petal
		icon='icons/petal_dance_flick.dmi'
		layer=MOB_LAYER+1
		New()
			..()
			flick("flick",src)

obj/flick
	var
		list/dependants=new
	New()
		spawn()..()
		spawn()
			dependants+=new/obj/petal(locate(src.x,src.y,src.z))
	Del()
		for(var/obj/x in src.dependants)
			del(x)
		..()



client
	var/mob/Controling
	var/mob/hellno=0
	North()
		if(hellno)
			return
		if(Controling) step(Controling,NORTH)
		else return ..()
	South()
		if(hellno)
			return
		if(Controling) step(Controling,SOUTH)
		else return ..()
	East()
		if(hellno)
			return
		if(Controling) step(Controling,EAST)
		else return ..()
	West()
		if(hellno)
			return
		if(Controling) step(Controling,WEST)
		else return ..()
	Northwest()
		if(hellno)
			return
		if(Controling) step(Controling,NORTHWEST)
		else return ..()
	Northeast()
		if(hellno)
			return
		if(Controling) step(Controling,NORTHEAST)
		else return ..()
	Southeast()
		if(hellno)
			return
		if(Controling) step(Controling,SOUTHEAST)
		else return ..()
	Southwest()
		if(hellno)
			return
		if(Controling) step(Controling,SOUTHWEST)
		else return ..()