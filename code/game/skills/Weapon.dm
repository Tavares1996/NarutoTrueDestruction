mob/var/list/tagging=new

skill
	weapon
		face_nearest = 1
		windmill_shuriken
			id = WINDMILL_SHURIKEN
			name = "Windmill Shuriken"
			icon_state = "windmill"
			default_supply_cost = 8
			default_cooldown = 30

			Use(mob/user)
				viewers(user) << output("[user]: Windmill Shuriken!", "combat_output")
				var/eicon = 'icons/projectiles.dmi'
				var/estate = "windmill-m"
				var/mob/human/player/etarget = user.NearestTarget()
				var/r = rand(1,4)
				var/angle
				var/speed = 48
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)
				spawn() advancedprojectile_angle(eicon, estate, user, speed, angle, distance=10, damage=900, wounds=r, radius=16)

		shadow_windmill_shuriken
			id = SHADOW_WINDMILL_SHURIKEN
			name = "Shadow Windmill Shuriken"
			icon_state = "sws"
			default_supply_cost = 10
			default_chakra_cost = 120
			default_cooldown = 60



			Use(mob/user)
				viewers(user) << output("[user]: Shadow Windmill Shuriken!", "combat_output")
				var/eicon = 'icons/projectiles.dmi'
				var/estate = "windmill-m"
				var/mob/human/player/etarget = user.NearestTarget()

				var/r = rand(1,6)
				var/angle
				var/speed = 40
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)

				spawn() advancedprojectile_angle(eicon, estate, user, speed, angle, distance=15, damage=1350, wounds=r, radius=16)
				sleep(1)
				spawn() advancedprojectile_angle(eicon, estate, user, speed, angle, distance=15, damage=1350, wounds=r, radius=16)




		exploding_kunai
			id = EXPLODING_KUNAI
			name = "Exploding Kunai"
			icon_state = "explkunai"
			default_supply_cost = 20
			default_cooldown = 10

			Use(mob/user)
				user.removeswords()
				var/startdir=user.dir
				flick("Throw1",user)
				var/eicon='icons/projectiles.dmi'
				var/estate="explkunai"
				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					etarget=straight_proj2(eicon,estate,8,user)
					if(etarget)
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						spawn()explosion(1200,ex,ey,ez,user)
					else
						if(startdir==EAST)
							spawn()explosion(1200,user.x+8,user.y,user.z,user)
						if(startdir==WEST)
							spawn()explosion(1200,user.x-8,user.y,user.z,user)
						if(startdir==NORTH)
							spawn()explosion(1200,user.x,user.y+8,user.z,user)
						if(startdir==SOUTH)
							spawn()explosion(1200,user.x,user.y-8,user.z,user)
				else
					var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z
					var/mob/x=new/mob(locate(ex,ey,ez))

					projectile_to(eicon,estate,user,x)
					del(x)
					spawn()explosion(1500,ex,ey,ez,user)
				user.addswords()




		exploding_note
			id = EXPLODING_NOTE
			name = "Exploding Note"
			icon_state = "explnote"
			default_supply_cost = 15
			default_cooldown = 10

			Use(mob/user)
				var/obj/explosive_tag/x=new/obj/explosive_tag(locate(user.x,user.y,user.z))
				if(user.skillspassive[20])x.trapskill=user.skillspassive[20]
				user<<"To detonate the tag, press <b>Z</b> or <b>click</b> the tag icon on the left side of your screen.Activate this in the next 5 minutes please"
				x.owner=user
				var/obj/trigger/explosive_tag/T = new(user, x)
				user.AddTrigger(T)
				spawn(600)
					if(x && user)
						user.RemoveTrigger(T)
						del(x)




		manipulate_advancing_blades
			id = MANIPULATE_ADVANCING_BLADES
			name = "Manipulate Advancing Blades"
			icon_state = "Manipulate Advancing Blades"
			default_supply_cost = 10
			default_chakra_cost = 50
			default_cooldown = 30

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.qued || user.qued2)
						Error(user, "A conflicting skill is already activated")
						return 0

			Use(mob/user)
				user.icon_state="Seal"
				user.stunned=10
				user.dir=SOUTH
				var/obj/X=new/obj(user.loc)
				X.layer=MOB_LAYER+1
				X.icon='icons/advancing.dmi'
				flick("form",X)

				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				user.overlays+=image('icons/advancing.dmi',icon_state="over")
				user.underlays+=image('icons/advancing.dmi',icon_state="under")
				sleep(2)
				user.qued=1

				user.icon_state=""
				user.stunned=0
				del(X)




		shuriken_shadow_clone
			id = SHUIRKEN_KAGE_BUNSHIN
			name = "Shuriken Shadow Clone"
			icon_state = "Shuriken Kage Bunshin no Jutsu"
			default_supply_cost = 1
			default_chakra_cost = 300
			default_cooldown = 60

			Use(mob/user)
				flick("Throw1",user)
				var/obj/Du = new/obj(user.loc)
				Du.icon='icons/projectiles.dmi'
				Du.icon_state="shuriken-m"
				Du.density=0
				sleep(1)
				walk(Du,user.dir)
				sleep(2)
				flick("Seal",user)
				for(var/mob/X in oview(0,Du))
					var/ex=Du.x
					var/ey=Du.y
					var/ez=user.z
					spawn()Poof(ex,ey,ez)
					del(Du)
					return
				var/dx=Du.x
				var/dy=Du.y
				var/dz=user.z
				spawn()Poof(dx,dy,dz)
				del(Du)
				user.ShadowShuriken(dx,dy,dz)

		twin_rising_dragons
			id = TWIN_RISING_DRAGONS
			name = "Twin Rising Dragons"
			icon_state = "Twin Rising Dragons"
			default_supply_cost = 100
			default_chakra_cost = 100
			default_cooldown = 120

			Use(mob/user)
				user.icon_state="Throw1"
				user.stunned=10
				user.overlays+='icons/twindragon.dmi'
				var/ammo=20
				sleep(15)
				while(ammo>0)
					sleep(1)
					var/angle = rand(0, 360)
					var/speed = rand(32, 64)
					spawn() advancedprojectile_angle('icons/twin_proj.dmi', "[pick(1,2,3,4)]", user, speed, angle, distance=7, damage=900, wounds=1, radius=16)
					Poof(user.x,user.y,user.z)
					ammo--
				user.icon_state=""
				user.overlays-='icons/twindragon.dmi'
				user.stunned=0

		tag_trap
			id = TAG_TRAP
			name = "Explosive Tag Trap"
			icon_state = "explosive_tag"
			default_supply_cost = 10
			default_cooldown = 165

			Use(mob/user)
				viewers(user) << output("[user]: Explosive Tag Trap!", "combat_output")
				var/mob/human/player/etarget = user.NearestTarget()
				if(!user && !etarget ||!ismob(etarget)) return
				etarget.stunned = 1
				var/obj/x = new(locate(etarget.x,etarget.y,etarget.z))
				x.layer=MOB_LAYER+1
				x.icon='icons/weapon_explode.dmi'
				x.dir=user.dir
				flick("start",x)
				var/obj/t = new/obj/tag_explode(etarget.loc)
				user.tagging += t
				user<<"<font color=black>Press Space to trigger your explosive tags."
				spawn(1000)
					if(user && x)
						del(x)
					if(user && tag && t)
						user.tagging = 0
						del(t)


		Jidanda
			id = JIDANDA
			name = "Jidanda"
			icon_state = "jidanda"
			default_supply_cost = 30
			default_cooldown = 50

			Use(mob/user)
				var/obj/jidanda/x=new/obj/jidanda(locate(user.x,user.y,user.z))
				if(user.skillspassive[20])x.trapskill=user.skillspassive[20]
				user<<"To detonate the tag, press <b>Z</b> or <b>click</b> the tag icon on the left side of your screen."
				x.owner=user
				var/obj/trigger/jidanda/T = new(user, x)
				user.AddTrigger(T)
				spawn(14000)
					if(x && user)
						user.RemoveTrigger(T)
						del(x)

obj
	tag_explode
		icon='icons/weapon_explode.dmi'
		icon_state="explode"
		layer=MOB_LAYER+1
		New()
			..()
			spawn(100)
				if(src)
					sleep(5)
					explosion(700,src.x,src.y,src.z,1,6)
					sleep(5)
					del(src)
	jidanda
		icon='icons/bomb.dmi'
		var/trapskill=0
		proc/Setoff(mob/human/o)
			var/xx=src.x
			var/xy=src.y
			var/xz=src.z
			usr=o
			src.icon=0
			var/r1=rand(0,100)
			var/r2=rand(0,100)
			var/r3=rand(0,100)
			var/r4=rand(0,100)
			if(r1>5)
				r1=1
			else
				r1=0
			if(r2>5)
				r2=1
			else
				r2=0
			if(r3>5)
				r3=1
			else
				r3=0
			if(r4>5)
				r4=1
			else
				r4=0
			if(r1)spawn()explosion(2500*(1+0.3*trapskill),xx-1,xy-1,xz,usr,1)
			if(r2)spawn()explosion(1800*(1+0.3*trapskill),xx+1,xy+1,xz,usr,1)
			if(r3)spawn()explosion(3500*(1+0.3*trapskill),xx+1,xy-1,xz,usr,1)
			if(r4)spawn()explosion(8000*(1+0.3*trapskill),xx-1,xy+1,xz,usr,1)
			explosion(10000*(1+0.3*trapskill),xx,xy,xz,usr)
			del(src)