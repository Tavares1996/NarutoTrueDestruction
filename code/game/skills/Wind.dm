mob/var/wind_shuriken=0

skill
	wind
		pressure_damage
			id = FUUTON_PRESSURE_DAMAGE
			name = "Wind: Pressure Damage"
			icon_state = "futon_pressure_damage"
			base_charge = 300
			default_cooldown = 120

			Use(mob/human/user)
				user.stunned=5
				var/obj/multipart/P
				var/dir = user.dir
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir
				switch(dir)
					if(NORTH)
						P=new/obj/multipart/Pressure/PNORTH(locate(user.x,user.y+1,user.z),1)
					if(SOUTH)
						P=new/obj/multipart/Pressure/PSOUTH(locate(user.x,user.y-1,user.z),1)
					if(EAST)
						P=new/obj/multipart/Pressure/PEAST(locate(user.x+1,user.y,user.z),1)
					if(WEST)
						P=new/obj/multipart/Pressure/PWEST(locate(user.x-1,user.y,user.z),1)
					else
						return
				P.dir=dir
				var/distance=10
				while(P && distance>0)
					for(var/obj/p in P.parts)
						for(var/mob/M in p.loc)
							if(!M.pressured && M!=user)
								M.pressured=1
								spawn(100)
									if(M&&M.pressured)
										M.pressured=0
								P.Pwned+=M
								M.stunned+=90
								M.animate_movement=2

					step(P,P.dir)

					sleep(2)
					distance--

				var/damage=500 + charge * 1.5 + round(250*user.ControlDamageMultiplier())

				for(var/mob/OP in P.Pwned)
					OP.pressured=0
					OP.animate_movement=1
					OP.stunned-=90
					if(OP.stunned<0)
						OP.stunned=0
					if(!OP.ko && !OP.protected)

						user.combat("[src]: Hit [OP] for [damage] damage!")
						spawn()if(OP) OP.Dec_Stam(damage,0,user)
						spawn()if(OP) OP.Hostile(user)

				P.Del()
				user.stunned=0



		blade_of_wind
			id = FUUTON_WIND_BLADE
			name = "Wind: Blade of Wind"
			icon_state = "blade_of_wind"
			default_chakra_cost = 450
			default_cooldown = 90
			face_nearest = 1



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(. && target)
					var/distance = get_dist(user, target)
					if(distance > 1)
						Error(user, "Target too far ([distance]/1 tiles)")
						return 0


			Use(mob/human/user)
				sleep(1)

				viewers(user) << output("[user]:<font color=#4CC417> Wind Release: Blade of Wind!", "combat_output")

				user.removeswords()
				user.overlays+=/obj/sword/w1
				user.overlays+=/obj/sword/w2
				user.overlays+=/obj/sword/w3
				user.overlays+=/obj/sword/w4

				user.stunned=1

				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.NearestTarget()

				if(!etarget)
					for(var/mob/human/X in get_step(user,user.dir))
						if(!X.ko && !X.protected)
							etarget=X
				flick("w-attack",user)
				spawn(20)
					user.overlays-=/obj/sword/w1
					user.overlays-=/obj/sword/w2
					user.overlays-=/obj/sword/w3
					user.overlays-=/obj/sword/w4
				if(etarget)
					etarget.move_stun=3
					sleep(1)
					var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,100)
					if(result>=5)
						user.combat("[user] Critically hit [etarget] with the Wind Sword")
						etarget.combat("[user] Critically hit [etarget] with the Wind Sword")

						etarget.Wound(rand(10,15),0,user)
						etarget.Dec_Stam(rand(800,(800+400*conmult)),0,user)
						etarget.stunned=3

					if(result==4||result==3)
						user.combat("[user] Managed to partially hit [etarget] with the Wind Sword")
						etarget.combat("[user] Managed to partially hit [etarget] with the Wind Sword")
						etarget.Wound(rand(5,10),0,user)
						etarget.Dec_Stam(rand(300,(300+200*conmult)),0,user)
						etarget.stunned=2
					if(result>=3)
						spawn()Blood2(etarget,user)
						spawn()etarget.Hostile(user)
						etarget.stunned=1
					if(result<3)

						user.combat("You Missed!!!")
						if(!user.icon_state)
							flick("hurt",user)

				user.removeswords()
				user.addswords()




		great_breakthrough
			id = FUUTON_GREAT_BREAKTHROUGH
			name = "Wind: Great Breakthrough"
			icon_state = "great_breakthrough"
			default_chakra_cost = 70
			default_cooldown = 15
			default_seal_time = 3



			Use(mob/human/user)
				viewers(user) << output("[user]: Wind: Great Breakthrough!", "combat_output")

				user.icon_state="HandSeals"
				user.stunned=5

				var/dir = user.dir
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir

				spawn()
					WaveDamage(user,3,(200+150*user.ControlDamageMultiplier()),3,14)
				Gust(user.x,user.y,user.z,user.dir,3,14)

				user.stunned=0
				user.icon_state=""




		air_bullet
			id = FUUTON_AIR_BULLET
			name = "Wind: Refined Air Bullet"
			icon_state = "fuuton_air_bullet"
			default_chakra_cost = 350
			default_cooldown = 30
			default_seal_time = 10



			Use(mob/human/user)
				var/ux=user.x
				var/uy=user.y
				var/uz=user.z
				var/startdir=user.dir

				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()

				if(!etarget)
					etarget=straight_proj3(/obj/wind_bullet,8,user)
					if(etarget)
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						spawn()explosion_spread((1400+1500*conmult),ex,ey,ez,user)
					else
						if(startdir==EAST)
							spawn()explosion_spread((1400+1500*conmult),ux+8,uy,uz,user)
						if(startdir==WEST)
							spawn()explosion_spread((1400+1500*conmult),ux-8,uy,uz,user)
						if(startdir==NORTH)
							spawn()explosion_spread((1400+1500*conmult),ux,uy+8,uz,user)
						if(startdir==SOUTH)
							spawn()explosion_spread((1400+1500*conmult),ux,uy-8,uz,user)
				else
					var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z
					var/mob/x=new/mob(locate(ex,ey,ez))

					projectile_to2(/obj/wind_bullet,user,x)
					del(x)
					spawn()explosion_spread((3000+3000*conmult),ex,ey,ez,user)

		vacuum_sphere
			id = FUUTON_VACUUM_SPHERE
			name = "Wind Release: Vacuum Sphere"
			icon_state = "vaccum sphere"
			default_chakra_cost = 500
			default_cooldown = 100
			face_nearest = 1

			Use(mob/human/user)
				viewers(user) << output("[user]: Vacuum Sphere!", "combat_output")
				var/eicon='icons/projectiles.dmi'
				var/estate="wind"

				if(!user.icon_state)
					user.icon_state="Seal"
					spawn(20)
						user.icon_state=""

				var/angle
				var/speed = 20
				var/spread = 10
				if(user.MainTarget()) angle = get_real_angle(user, user.MainTarget())
				else angle = dir2angle(user.dir)

				var/damage = 15*user.ControlDamageMultiplier()

				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*4, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*6, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*8, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*10, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*12, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*14, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*16, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*18, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*20, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*22, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*24, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*26, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*28, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*30, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*32, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*34, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*36, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*38, distance=10, damage=damage, wounds=0)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*40, distance=10, damage=damage, wounds=0)

		vacuum_wave
			id = FUUTON_VACUUM_WAVE
			name = "Wind Release: Vacuum Wave"
			icon_state = "vacuum_wave"
			default_chakra_cost = 350
			default_cooldown = 150

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=#4CC417> Wind Release: Vacuum Wave!", "combat_output")
				var/eicon='icons/wind_vacuum_wave.dmi'
				var/x=rand(1,2)
				var/estate="[x]"
				user.stunned=3
				if(!user.icon_state)
					user.icon_state="Seal"
					spawn(15)
						user.icon_state=""
						user.stunned=0

				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))
				var/angle
				var/speed = 60
				var/spread = 6
				if(etarget)
					angle = get_real_angle(user, etarget)
				else
					angle = dir2angle(user.dir)
				var/damage=rand(100,200)*user.ControlDamageMultiplier()
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*1, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*1, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*1, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*1, distance=10, damage=damage*1.5, wounds=rand(2,4), daze=15)
				sleep(2)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*1, distance=10, damage=damage*2.5, wounds=rand(2,4), daze=15)

	rasenshuriken
		id = FUUTON_RASENSHURIKEN
		name = "Wind: Rasenshuriken"
		icon_state = "rasenshuriken"
		default_chakra_cost = 500
		default_cooldown = 160

		Use(mob/human/player/user)
			viewers(user) << output("[user]:<font color=#4CC417> Wind Release: Rasenshuriken!", "combat_output")
			user.stunned=10
			var/obj/x = new(locate(user.x,user.y,user.z))
			x.layer=MOB_LAYER-1
			x.icon='icons/rasenshuriken.dmi'
			x.dir=user.dir
			flick("create",x)
			user.overlays+=/obj/rasenshuriken
			spawn(30)
				del(x)
			sleep(30)
			if(user)
				user.rasengan=3
				user.stunned=0
				user.combat("Press <b>A</b> before the Rasenshuriken dissapates to use it on someone or press F to throw it. If you take damage it will dissipate!")
				spawn(300)
					if(user && user.rasengan==3)
						user.Rasenshuriken_Fail()

		fuuton_hurricane
			id = FUUTON_HURRICANE
			name = "Wind Release: Hurricane"
			icon_state = "fuuton_hurricane"
			default_chakra_cost = 250
			default_cooldown = 120
			face_nearest = 10
			default_seal_time = 6

			Use(mob/human/user)
				viewers(user) << output("[user]:<font color=#4CC417> Wind Release: Hurricane!", "combat_output")
				var/mob/human/player/etarget = user.MainTarget()
				var/dam=15*user.ControlDamageMultiplier()
				dam+=user.con
				Poof(user.x,user.y,user.z)
				if(etarget)
					if(etarget in view(user,10))

						etarget.overlays+='FuutonRetardation.dmi'
						Blood(etarget.x,etarget.y,etarget.z)
						Poof(etarget.x,etarget.y,etarget.z)
						spawn(30)
						etarget.overlays-='FuutonRetardation.dmi'
						Blood(etarget.x,etarget.y,etarget.z)
						Poof(etarget.x,etarget.y,etarget.z)
						etarget.movepenalty+=10
						spawn(50)
						etarget.movepenalty+=10
						Blood(etarget.x,etarget.y,etarget.z)
						Poof(etarget.x,etarget.y,etarget.z)

	wind_shuriken
		id = FUUTON_SHURIKEN
		name = "Wind Release: Shuriken"
		icon_state = "wind_shuriken"
		default_chakra_cost = 700
		default_cooldown = 100

		Use(mob/human/player/user)
			viewers(user) << output("[user]:<font color=#4CC417> Wind Release: Shuriken!", "combat_output")
			sleep(5)
			if(user)
				user.wind_shuriken=1
				user.combat("Press <b>F</b> before the wind shuriken dissappears!")
				spawn(130)
					if(user && user.wind_shuriken)
						user.wind_shuriken=0

obj
	rasenshuriken_projectile
		icon='icons/rasenshuriken.dmi'
		density=1
		var
			mob/Owner=null
			Damage=0
			hit=0

		New(mob/human/player/p, dx, dy, dz, ddir, conmult)
			..()
			src.Owner=p
			src.Damage=conmult
			src.dir=ddir
			src.loc=locate(dx,dy,dz)
			walk(src,src.dir)
			spawn(300)
				if(src&&!src.hit) del(src)

		Bump(O)
			if(istype(O,/mob))
				src.hit=1
				if(!istype(O,/mob/human/player))
					del(src)
				src.icon=0
				var/mob/p = O
				var/mob/M = src.Owner
				M.Rasenshuriken_Hit(p,M,src.dir)
				spawn() del(src)

			if(istype(O,/turf))
				var/turf/T = O
				if(T.density)
					src.hit=1
					del(src)

			if(istype(O,/obj))
				var/obj/T = O
				if(T.density)
					src.hit=1
					del(src)



obj
	wind_shuriken
		icon='icons/wind_shuriken.dmi'
		density=1
		var
			mob/Owner=null
			Damage=0
			hit=0

		New(mob/human/player/p, dx, dy, dz, ddir, conmult)
			..()
			src.Owner=p
			src.Damage=conmult
			src.dir=ddir
			src.loc=locate(dx,dy,dz)
			walk(src,src.dir)
			spawn(300)
				if(src&&!src.hit) del(src)

		Bump(O)
			if(istype(O,/mob))
				src.hit=1
				if(!istype(O,/mob/human/player))
					del(src)
				src.icon=0
				var/mob/p = O
				var/mob/M = src.Owner
				M.Wind_Shuriken_Hit(p,M,src.dir)
				spawn() del(src)

			if(istype(O,/turf))
				var/turf/T = O
				if(T.density)
					src.hit=1
					del(src)

			if(istype(O,/obj))
				var/obj/T = O
				if(T.density)
					src.hit=1
					del(src)

obj
	rasenshuriken
		icon='icons/rasenshuriken.dmi'
		icon_state="rasenshuriken"
		layer=MOB_LAYER+1
	rasenshuriken2
		icon='icons/rasenshuriken.dmi'
		icon_state="PunchA-1"
		layer=MOB_LAYER+1


mob/proc
	Rasenshuriken_Fail()
		src.rasengan=0
		src.overlays-=/obj/rasenshuriken
		src.overlays-=/obj/rasenshuriken2
		var/obj/o=new/obj(locate(src.x,src.y,src.z))
		o.layer=MOB_LAYER+1
		o.icon='icons/rasenshuriken.dmi'
		flick("failed",o)
		spawn(50)
			del(o)

	Rasenshuriken_Hit(mob/x,mob/u,xdir)
		u.overlays-=/obj/rasenshuriken
		u.overlays-=/obj/rasenshuriken2
		u.rasengan=0
		var/conmult=(u.con+u.conbuff-u.conneg)/100
		x.cantreact=1
		spawn(30)	// Can we please not forget to make sure things are still valid after any sleep or spawn call.
			if(x)	x.cantreact=0
		var/obj/o=new/obj(locate(x.x,x.y,x.z))
		o.icon='icons/rasenshuriken.dmi'
		o.layer=MOB_LAYER+1
		if(!x.icon_state)
			x.icon_state="hurt"

		flick("hit",o)

		x.Earthquake(20)
		spawn(50)
			del(o)
		sleep(10)
		if(x)
			x.Knockback(4,xdir)
			if(x)	// Knockback sleeps, I think. It really shouldn't though.
				explosion(50,x.x,x.y,x.z,u,1)
				x.Dec_Stam(1000+1000*conmult,0,u)
				if(x.clan == "Scavenger" || x.hearts)
					x.hearts=0
					x.combat("You've lost all your hearts from the damage!")
				x.stunned+=3
				if(!x.ko)
					x.icon_state=""
				x.Hostile(u)

mob/proc
	Wind_Shuriken_Hit(mob/x,mob/u,xdir)
		var/conmult=(u.con+u.conbuff-u.conneg)/100
		x.cantreact=1
		spawn(30)	// Can we please not forget to make sure things are still valid after any sleep or spawn call.
			if(x)	x.cantreact=0
		sleep(5)
		if(x)
			Blood2(x)
			x.Dec_Stam(50+25*conmult,0,u)
			x.Wound(rand(conmult/x.blevel-2,conmult/x.blevel-1))
			if(!x.ko)
				x.icon_state=""
			x.Hostile(u)

