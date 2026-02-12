mob/var
	fusion = 0
	jutsunumber = 0
	SSkinR = 0


skill
	body_replacement
		id = KAWARIMI
		name = "Body Replacement"
		icon_state = "kawarimi"
		default_chakra_cost = 50
		default_cooldown = 30

		IsUsable(mob/user)
			. = ..()
			if(.)
				if(capture_the_flag && capture_the_flag.HasFlag(user))
					Error(user, "You can't use this jutsu while holding the flag.")
					return 0

		Use(mob/user)
			user.combat("If you press <b>z</b> or <b>click</b> the log icon on the left side of your screen within the next 4 minutes, you will be teleported back to this location.")

			// Removing old kawas
			for(var/obj/trigger/kawarimi/T in user.triggers)
				user.RemoveTrigger(T)

			for(var/obj/trigger/explosive/T in user.triggers)
				user.RemoveTrigger(T)

			var/obj/trigger/kawarimi/T = new/obj/trigger/kawarimi(user, user.x, user.y, user.z)
			user.AddTrigger(T)

			spawn(2400)
				if(user) user.RemoveTrigger(T)

	body_explosive
		id = EXPLOSIVE
		name = "Body Replacement: Explosive Kawa"
		icon_state = "explosive"
		default_chakra_cost = 150
		default_supply_cost = 10
		default_cooldown = 30

		IsUsable(mob/user)
			. = ..()
			if(.)
				if(capture_the_flag && capture_the_flag.HasFlag(user))
					Error(user, "You can't use this jutsu while holding the flag.")
					return 0

		Use(mob/user)
			user.combat("If you press <b>z</b> or <b>click</b> the log icon on the left side of your screen within the next 4 minutes, you will be teleported back to this location.")
			if(capture_the_flag && capture_the_flag.GetTeam(user) != "None")
				capture_the_flag.DropFlag(user)

			for(var/obj/trigger/kawarimi/T in user.triggers)
				user.RemoveTrigger(T)

			for(var/obj/trigger/explosive/T in user.triggers)
				user.RemoveTrigger(T)

			var/obj/trigger/explosive/T = new/obj/trigger/explosive(user, user.x, user.y, user.z)
			user.AddTrigger(T)

			spawn(2400)
				if(user) user.RemoveTrigger(T)

	body_flicker
		id = SHUNSHIN
		name = "Body Flicker"
		icon_state = "shunshin"
		default_chakra_cost = 50
		default_cooldown = 5

		IsUsable(mob/user)
			. = ..()
			if(.)
				if(capture_the_flag && capture_the_flag.HasFlag(user))
					Error(user, "You can't use this jutsu while holding the flag.")
					return 0

		Use(mob/human/user)
			var/mob/human/player/etarget = user.MainTarget()

			if(!user.icon_state)
				flick(user, "Seal")

			sleep(1)
			if(!user) return

			if(!etarget)
				user.combat("<b>Double-click</b> on an empty section of ground within 5 seconds to teleport there.")
				user.shun = 1
				spawn(50)
					if(user) user.shun = 0
			else
				if(etarget && etarget.z == user.z)
					if(user.skillspassive[4])
						if(user.lightning_armor&&etarget.player_target&&user.super_speed_contract>0)
							user.AppearBefore(etarget)
							etarget.player_target=0
							user.super_speed_contract-=1
						else user.AppearBehind(etarget)
					else
						user.AppearBefore(etarget)

			user.stunned += 1.5 - (0.5 * user.skillspassive[4]) //2.7 if you want stun :3

		Cooldown(mob/user)
			if(user.skillspassive[4] == 5)
				return 1
			else
				return ..()




	clone
		id = BUNSHIN
		name = "Clone"
		icon_state = "bunshin"
		default_chakra_cost = 10
		default_cooldown = 30



		Use(mob/user)
			if(!user.icon_state)
				flick(user,"Seal")

			var/mob/human/player/npc/bunshin/o = new/mob/human/player/npc/bunshin(locate(user.x,user.y,user.z))
			spawn(2)
				o.icon = user.icon
				o.overlays = user.overlays
				o.name = "[user.name]"
				o.bunshinowner = user.key
				o.faction = user.faction
				o.dir = user.dir
				o.mouse_over_pointer = user.mouse_over_pointer
				o.life = 30

			Poof(o.x,o.y,o.z)

			spawn(1)o.CreateName(255, 255, 255)

			user.BunshinTrick(list(o))




	shadow_clone
		id = KAGE_BUNSHIN
		name = "Shadow Clone"
		icon_state = "kagebunshin"
		default_chakra_cost = 400
		default_cooldown = 45


		Use(mob/user)
			viewers(user) << output("[user]: Shadow Clone!", "combat_output")
			for(var/mob/human/player/npc/kage_bunshin/O in world)
				if(O.ownerkey==user.key)
					del(O)
			flick("Seal",user)
			var/mob/human/player/npc/kage_bunshin/X = new/mob/human/player/npc/kage_bunshin(user.loc)
			if(user.client) user.client.eye=X

			X.ownerkey=user.key
			user.controlmob=X
			spawn(2)
				X.icon=user.icon
				X.overlays=user.overlays
				X.underlays=user.underlays
				X.con=user.con
				X.str=user.str
				X.rfx=user.rfx
				X.int=user.int
				X.name="[user.name]"
			spawn(1)X.CreateName(255, 255, 255)
			spawn() X.regeneration2()

			user.BunshinTrick(list(X))




	multiple_shadow_clone
		id = TAJUU_KAGE_BUNSHIN
		name = "Multiple Shadow Clone"
		icon_state = "taijuu_kage_bunshin"
		default_chakra_cost = 350
		default_cooldown = 60
		var/used_chakra



		ChakraCost(mob/user)
			used_chakra = user.curchakra
			if(used_chakra > default_chakra_cost)
				return used_chakra
			else
				return default_chakra_cost


		Use(mob/user)
			for(var/mob/human/player/npc/kage_bunshin/O in world)
				if(O.ownerkey==user.key)
					del(O)
			flick("Seal",user)

			viewers(user) << output("[user]: Multiple Shadow Clone!", "combat_output")
			user.combat("<b>Click</b> to move your bunshins. Press <b>F</b> to have them attack your target(s).")
			user.tajuu=1
			var/list/options=new
			for(var/turf/x in oview(4,user))
				if(!x.density)
					options+=x
			var/list/B = new
			var/am=0


			while(used_chakra>default_chakra_cost && am<=20 && options.len)
				used_chakra-=default_chakra_cost
				var/turf/next=pick(options)
				spawn()Poof(next.x,next.y,next.z)
				B+=new/mob/human/player/npc/kage_bunshin(locate(next.x,next.y,next.z))
				am++


			for(var/mob/human/player/npc/kage_bunshin/O in B)
				O.Squad=B
				//tricks+=O
				spawn(2)
					O.icon=user.icon
					O.faction=user.faction
					O.mouse_over_pointer=user.mouse_over_pointer
					O.temp=1200
					O.overlays+=user.overlays
					O.name=user.name
					spawn(1)O.CreateName(255, 255, 255)
					spawn()O.AIinitialize()
					for(var/skill/X in user.skills)
						O.AddSkill(X.id)

				O.owner=user

				O.killable=1

				user.pet+=O

			user.BunshinTrick(B)

			spawn(600)
				for(var/mob/human/player/npc/kage_bunshin/U in B)
					if(locate(U) in world)
						spawn()Poof(U.x,U.y,U.z)
						user.tajuu=0
						del(U)




	exploding_shadow_clone
		id = EXPLODING_KAGE_BUNSHIN
		name = "Exploding Shadow Clone"
		icon_state = "exploading bunshin"
		default_chakra_cost = 400
		default_cooldown = 45


		Use(mob/user)
			viewers(user) << output("[user]: Shadow Clone!", "combat_output")
			for(var/mob/human/player/npc/kage_bunshin/O in world)
				if(O.ownerkey==user.key)
					del(O)
			flick("Seal",user)
			var/mob/human/player/npc/kage_bunshin/X = new/mob/human/player/npc/kage_bunshin(user.loc)
			if(user.client) user.client.eye=X

			X.ownerkey=user.key
			user.controlmob=X
			spawn(2)
				X.icon=user.icon
				X.overlays=user.overlays
				X.underlays=user.underlays
				X.con=user.con
				X.str=user.str
				X.rfx=user.rfx
				X.int=user.int
				X.exploading=1
				X.name="[user.name]"
			spawn(1)X.CreateName(255, 255, 255)
			spawn() X.regeneration2()

			user.BunshinTrick(list(X))




	transform
		id = HENGE
		name = "Transform"
		icon_state = "henge"
		default_chakra_cost = 40
		default_cooldown = 60



		IsUsable(mob/user)
			. = ..()
			if(.)
				if(!user.MainTarget())
					Error(user, "No Target")
					return 0


		Use(mob/human/player/user)

			if(!user.icon_state)
				flick(user,"Seal")

			viewers(user) << output("[user]: Transform!", "combat_output")
			var/mob/human/player/etarget = user.MainTarget()

			if(etarget && !istype(etarget, /mob/human/clay) && !istype(etarget, /mob/human/sandmonster))
				Poof(user.x, user.y, user.z)

				user.icon = etarget.icon
				user.name = etarget.name

				user.CreateName(255, 255, 255)

				user.overlays= etarget.overlays
				user.mouse_over_pointer = etarget.mouse_over_pointer
				user.henged = 1




	rasengan
		id = RASENGAN
		name = "Rasengan"
		icon_state = "rasengan"
		default_chakra_cost = 300
		default_cooldown = 90

		Use(mob/human/player/user)
			viewers(user) << output("[user]: Rasengan!", "combat_output")
			user.stunned=10
			var/obj/x = new(locate(user.x,user.y,user.z))
			x.layer=MOB_LAYER+1
			x.icon='icons/rasengan.dmi'
			x.dir=user.dir
			flick("create",x)
			user.overlays+=/obj/rasengan
			spawn(30)
				del(x)
			sleep(10)
			if(user)
				user.stunned=0
				user.combat("Press <b>A</b> to use Rasengan on someone. If you take damage it will dissipate!")
				user.rasengan=1


	oodama_rasengan
		id = OODAMA_RASENGAN
		name = "Large Rasengan"
		icon_state = "oodama_rasengan"
		default_chakra_cost = 500
		default_cooldown = 140



		Use(mob/human/player/user)
			viewers(user) << output("[user]: Large Rasengan!", "combat_output")
			user.stunned=10
			var/obj/x = new(locate(user.x,user.y,user.z))
			x.layer=MOB_LAYER-1
			x.icon='icons/oodamarasengan.dmi'
			x.dir=user.dir
			flick("create",x)
			user.overlays+=/obj/oodamarasengan
			spawn(30)
				del(x)
			sleep(30)
			if(user)
				user.rasengan=2
				user.stunned=0
				user.combat("Press <b>A</b> before the Oodama Rasengan dissapates to use it on someone. If you take damage it will dissipate!")
				spawn(100)
					if(user && user.rasengan==2)
						user.ORasengan_Fail()




	camouflaged_hiding
		id = CAMOFLAGE_CONCEALMENT
		name = "Camouflaged Hiding"
		icon_state = "Camouflage Concealment Technique"
		default_chakra_cost = 100
		default_cooldown = 60
		default_seal_time = 5

		Use(mob/human/player/user)
			user.camo=1
			user.icon='icons/base_invisible.dmi'
			user.overlays=0
			Poof(user.x,user.y,user.z)




	chakra_leech
		id = CHAKRA_LEECH
		name = "Chakra Leech"
		icon_state = "chakra_leach"
		default_chakra_cost = 100
		default_cooldown = 60



		Use(mob/human/player/user)
			user.stunned=2
			user.icon_state="Throw2"
			sleep(5)
			user.overlays+='icons/leech.dmi'
			var/mob/gotcha=0
			var/turf/getloc=0
			for(var/mob/human/eX in get_step(user,user.dir))
				if(!eX.ko && !eX.protected)
					eX.overlays+='icons/leech.dmi'
					eX.move_stun=30
					gotcha=eX
					getloc=locate(eX.x,eX.y,eX.z)
			while(gotcha && gotcha.loc==getloc && (abs(user.x-gotcha.x)*abs(user.y-gotcha.y))<=1)
				user.stunned=2
				sleep(5)
				if(!gotcha) break
				var/conmult = user.ControlDamageMultiplier()
				gotcha.curchakra-= round(50*conmult)
				user.curchakra+=round(50*conmult)
				gotcha.Hostile(user)
				if(gotcha.curchakra<0)
					gotcha.overlays-='icons/leech.dmi'
					gotcha.curstamina=0
					gotcha=0

				if(user.curchakra>user.chakra*1.5)
					user.curchakra=user.chakra*1.5
			user.overlays-='icons/leech.dmi'
			if(gotcha)
				gotcha.overlays-='icons/leech.dmi'
			user.icon_state=""




client
	DblClick(atom/thing, atom/loc, control, params)
		if(mob.shun && isloc(loc))
			if(!loc || !loc.Enter(usr) || !loc.icon || loc.type == /turf || !(loc in oview(mob)))
				return

			if(!mob.loc.icon || mob.loc.type==/turf || mob.loc.density)
				return

			var/area/ex = loc.loc
			if(ex.covericon)
				return

			mob.shun = 0

			mob.stunned += 2.7 - (0.5 * mob.skillspassive[4])
			mob:AppearAt(loc.x, loc.y, loc.z)
		else
			..()




mob/human/player/npc
	bunshin
		initialized=1
		protected=0
		ko=0



		var
//			bunshinowner=1
			bunshintype=0
			life=60



		New()
			..()
			spawn()
				while(src.life>0)
					sleep(10)
					src.life--

				if(src.invisibility<=2)
					Poof(src.x,src.y,src.z)
				src.invisibility=4
				src.targetable=0
				src.density=0
				spawn(50)
					del(src)


		Dec_Stam(x,xpierce,mob/attacker, hurtall)
			return


		Wound(x,xpierce, mob/attacker, reflected)
			return




	kage_bunshin
		initialized=1
		protected=0
		ko=0



		var
//			ownerkey=""
//			owner=""
			temp=0
			exploading=0
			lightning=0



		New()
			..()
			spawn()src.Stun_Drain()

			spawn(10)
				if(temp)
					spawn(temp)
						src.Hostile()


		Dec_Stam(x,xpierce,mob/attacker, hurtall)
			return


		Wound(x,xpierce, mob/attacker, reflected)
			return




obj
	oodamarasengan
		icon='icons/oodamarasengan.dmi'
		icon_state="rasengan"
		layer=MOB_LAYER+1
	oodamarasengan2
		icon='icons/oodamarasengan.dmi'
		icon_state="PunchA-1"
		layer=MOB_LAYER+1
obj
	rasengan
		icon='icons/rasengan.dmi'
		icon_state="rasengan"
		layer=MOB_LAYER+1
	rasengan2
		icon='icons/rasengan.dmi'
		icon_state="PunchA-1"
		layer=MOB_LAYER+1




mob/proc
	Shunshin_Teleport(atom/dest)
		icon_state="Run"
		canwalk=0
		var/shun_speed = (32+skillspassive[4]*10)
		var/dx = dest.x - x
		var/dy = dest.y - y
		var/distance = sqrt(dx*dx + dy*dy)
		var/shun_time = round(distance*32/shun_speed)
		//M_Projectile_Target(O,mob/user,power,iterations,speed,atom/target)
		M_Projectile_Target(src,src,0,shun_time,shun_speed,dest)
		canwalk=1
		icon_state=""

	ORasengan_Fail()
		src.rasengan=0
		src.overlays-=/obj/oodamarasengan
		src.overlays-=/obj/oodamarasengan2
		var/obj/o=new/obj(locate(src.x,src.y,src.z))
		o.layer=MOB_LAYER-1
		o.icon='icons/oodamarasengan.dmi'
		flick("failed",o)
		spawn(50)
			del(o)
	ORasengan_Hit(mob/x,mob/u,xdir)
		u.overlays-=/obj/oodamarasengan
		u.overlays-=/obj/oodamarasengan2
		u.rasengan=0
		var/conmult=(u.con+u.conbuff-u.conneg)/100
		x.cantreact=1
		spawn(30)
			x.cantreact=0
		var/obj/o=new/obj/oodamaexplosion(locate(x.x,x.y,x.z))
		o.layer=MOB_LAYER-1
		if(!x.icon_state)
			x.icon_state="hurt"
		x.stunned=10
		u.stunned=10
		x.Wound(rand(15,30),0,u)
		x.Earthquake(20)
		sleep(20)
		del(o)
		x.stunned=0
		u.stunned=0
		x.Knockback(10,xdir)
		explosion(50,x.x,x.y,x.z,u,1)
		if(x)
			x.Dec_Stam(1500+750*conmult,0,u)

			x.stunned+=3
			if(!x.ko)
				x.icon_state=""
			x.Hostile(u)
	Rasengan_Fail()
		src.rasengan=0
		src.overlays-=/obj/rasengan
		src.overlays-=/obj/rasengan2
		var/obj/o=new/obj(locate(src.x,src.y,src.z))
		o.layer=MOB_LAYER+1
		o.icon='icons/rasengan.dmi'
		flick("failed",o)
		spawn(50)
			del(o)
	Rasengan_Hit(mob/x,mob/u,xdir)
		u.overlays-=/obj/rasengan
		u.overlays-=/obj/rasengan2
		u.rasengan=0
		var/conmult=(u.con+u.conbuff-u.conneg)/100
		x.cantreact=1
		spawn(30)	// Can we please not forget to make sure things are still valid after any sleep or spawn call.
			if(x)	x.cantreact=0
		var/obj/o=new/obj(locate(x.x,x.y,x.z))
		o.icon='icons/rasengan.dmi'
		o.layer=MOB_LAYER+1
		if(!x.icon_state)
			x.icon_state="hurt"

		flick("hit",o)

		x.Earthquake(10)
		spawn(50)
			del(o)
		sleep(10)
		if(x)
			x.Knockback(10,xdir)
			if(x)	// Knockback sleeps, I think. It really shouldn't though.
				explosion(50,x.x,x.y,x.z,u,1)
				x.Dec_Stam(1000+500*conmult,0,u)
				x.stunned+=3
				if(!x.ko)
					x.icon_state=""
				x.Hostile(u)


	BunshinTrick(list/bunshins)
		FilterTargets()
		for(var/mob/M in targeted_by)
			var/max_targets = M.MaxTargets()
			var/active = (src in M.active_targets)
			if(!active)
				max_targets -= M.MaxActiveTargets()

			var/result=Roll_Against((int+intbuff-intneg)*(1 + 0.05*skillspassive[20]),(M.int+M.intbuff-M.intneg)*(1 + 0.05*M.skillspassive[20]),100)
			if(result > 3 && !M.sharingan)
				var/list/valid_targets = list(src)
				valid_targets += bunshins
				var/picked_targets = 0
				while(valid_targets.len && picked_targets < max_targets)
					var/target = pick(valid_targets)
					valid_targets -= target
					M.AddTarget(target, active, silent=1)
					++picked_targets
			else
				var/list/valid_targets = bunshins.Copy()
				var/picked_targets = 0
				while(valid_targets.len && picked_targets < (max_targets - 1))
					var/target = pick(valid_targets)
					valid_targets -= target
					M.AddTarget(target, 0, silent=1)
					++picked_targets
				M.AddTarget(src, active, silent=1)

obj/explosive
	icon='icons/explosive.dmi'
	icon_state=""
	density=1
	var
		mob/Owner=null

	New(mob/human/player/p,newx,newy,newz)
		src.loc=locate(newx,newy,newz)
		src.Owner=p
		flick("flick",src)
		spawn(1)
			src.Explode()

	proc/Explode()
		if(src.icon)
			src.icon=null

			var/mob/human/player/user = src.Owner
			var/conmult = user.ControlDamageMultiplier()
			var/power=rand(100,(300+300*conmult))

			src.density=0
			explosion(power,src.x,src.y,src.z,src.Owner,0,3)

			del(src)