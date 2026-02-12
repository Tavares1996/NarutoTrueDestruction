mob/var/crystal_armor
skill
	crystal
		copyable = 0

		crystal_chamber
			id = CRYSTAL_CHAMBER
			name = "Crystal Release: Jade Crystal Prison "
			icon_state = "crystal_prison"
			default_chakra_cost = 250
			default_cooldown = 70
			default_seal_time = 10

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				user.stunned=1
				viewers(user) << output("[user]: Crystal Release: Jade Crystal Prison !", "combat_output")

				var/mob/human/player/etarget = user.MainTarget()

				if(etarget)
					var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z
					spawn()Crystal_Cage(ex,ey,ez,50)

					if(ex==etarget.x&&ey==etarget.y&&ez==etarget.z&&etarget)
						etarget.stunned=5
						etarget.layer=MOB_LAYER-1
						if(etarget)etarget.paralysed=1
						var/delete = 5

						spawn()
							while(etarget&&etarget.chakra>0)
								etarget.chakra-=rand(50,180)
								sleep(5)
								delete--
							if((user&&delete<=0)||(etarget&&etarget.chakra<=0))
								if(etarget)
									etarget.paralysed=0
									etarget.stunned=0

		Crystal_Spikes
			id = CRYSTAL_SPIKES
			name = "Crystal Release: Crystal Spikes"
			icon_state = "crystal_spikes"
			default_chakra_cost = 600
			default_cooldown = 75
			default_seal_time = 3

			Use(mob/user)
				viewers(user) << output("[user]: Crystal Release: Crystal Spikes!", "combat_output")
				var/mob/human/player/V = user.MainTarget()
				user.stunned=2
				user.icon_state="Seal"
				spawn(15)
					user.icon_state=""
					user.stunned = 0
				var/buff=(user.con+user.conbuff-user.conneg)/100
				if(V)
					var/obj/B = new/obj/blank(locate(V.x,V.y,V.z))
					spawn()Crystal_Spikes(B.x,B.y,B.z,50)
					spawn(50) del(B)

					for(var/mob/human/player/X in oview(2,B))
						if(!X.icon_state)
							flick("hurt",X)
						X.Dec_Stam(300 + 200*buff, 0, user)
						X.Hostile(user)
						X.Wound(rand(2,4), 0, user)
						spawn()Blood2(X)
						X.move_stun+=50
						break
				else return default_cooldown


		Crystal_Dragon
			id = CRYSTAL_DRAGON
			name = "Crystal Dragon"
			icon_state  = "crystal_dragon"
			default_chakra_cost = 100
			default_cooldown = 60
			default_seal_time = 5

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Crystal Dragon!", "combat_output")

				user.stunned=10
				var/conmult = user.ControlDamageMultiplier()
				var/obj/trailmaker/o=new/obj/trailmaker/Crystal_Dragon()
				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,14,user)
				if(result)
					result.Knockback(3,o.dir)
					spawn(1)
						del(o)
					result.Dec_Stam((800 + 550*conmult),0,user)
					spawn()result.Hostile(user)
				user.stunned=0

		Crystal_Barrier
			id = CRYSTAL_BARRIER
			name = "Crystal Release: Crystal Barrier"
			icon_state = "crystal_barrier"
			default_chakra_cost = 300
			default_cooldown = 120
			default_seal_time = 6


			Use(mob/user)
				viewers(user) << output("[user]: Crystal Release: Crystal Barrier!", "combat_output")
				spawn()CBarrier(user.x,user.y,user.z,100)
				var/obj/X = new/obj/blank(locate(user.x,user.y,user.z))

				spawn(100) del(X)

				spawn()
					while(X in world)
						for(var/mob/human/player/Area in oview(6,X))
							if(Area!=user)
								Area.move_stun+=5
							break
						if(!X in world)
							break
						sleep(2)


		crystal_armor
			id = CRYSTAL_ARMOR
			name = "Crystal Armor"
			icon_state = "crystal_armor"
			default_chakra_cost = 350
			default_cooldown = 240

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.crystal_armor)
						Error(user, "Crystal Armor is already active.")
						return 0
					if(user.ironskin)
						Error(user, "Iron Skin is active")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Crystal Armor!", "combat_output")
				user.crystal_armor=1
				user.stunned = 0.5
				var/obj/o = new
				o.icon = 'crystal_armor.dmi'
				o.layer = MOB_LAYER + 0.1
				o.loc = user.loc
				flick("on",o)
				sleep(5)
				o.loc = null
				if(!user)
					return
				spawn(Cooldown(user)*9)
					if(!user) return
					user.stunned=5
					user.protected=5
					user.dir=SOUTH
					o.loc = user.loc
					flick("off",o)
					o.density=0
					user.icon_state=""
					sleep(10)
					o.loc = null
					if(!user) return
					user.stunned=0
					user.protected=0
					user.crystal_armor=0

obj
	CrystalSpikes
		icon='icons/crystal2.dmi'
		layer=MOB_LAYER+5
		density=1

proc
	Crystal_Spikes(dx,dy,dz,dur)
		var/obj/cry1=new/obj/CrystalSpikes(locate(dx,dy,dz))
		var/obj/cry2=new/obj/CrystalSpikes(locate(dx+1,dy,dz))
		var/obj/cry4=new/obj/CrystalSpikes(locate(dx+1,dy+1,dz))
		var/obj/cry3=new/obj/CrystalSpikes(locate(dx,dy+1,dz))
		spawn()flick("cry1",cry1)
		spawn()flick("cry2",cry2)
		spawn()flick("cry3",cry3)
		flick("cry4",cry4)
		cry1.icon_state="1"
		cry2.icon_state="2"
		cry3.icon_state="3"
		cry4.icon_state="4"
		sleep(dur)
		del(cry1)
		del(cry2)
		del(cry3)
		del(cry4)



obj/crystalcage
	icon='icons/shouton.dmi'
	layer=MOB_LAYER+5
	density=1

proc/Crystal_Cage(dx,dy,dz,dur)
	var/obj/cry1=new/obj/crystalcage(locate(dx,dy,dz))
	var/obj/cry2=new/obj/crystalcage(locate(dx+1,dy,dz))
	var/obj/cry4=new/obj/crystalcage(locate(dx+1,dy+1,dz))
	var/obj/cry3=new/obj/crystalcage(locate(dx,dy+1,dz))
	spawn()flick("cry1",cry1)
	spawn()flick("cry2",cry2)
	spawn()flick("cry3",cry3)
	flick("cry4",cry4)
	cry1.icon_state="1"
	cry2.icon_state="2"
	cry3.icon_state="3"
	cry4.icon_state="4"
	sleep(dur)
	del(cry1)
	del(cry2)
	del(cry3)
	del(cry4)



obj/Cbarrier
	Cbarrier1
		layer=MOB_LAYER
		icon='cbarrier.dmi'
		icon_state="1,1"
		pixel_y=32
		density=0
	Cbarrier2
		icon='cbarrier.dmi'
		icon_state="1"
		density=1
		New()
			..()
			overlays+=/obj/Cbarrier/Cbarrier1
	Cbarrier3
		icon='cbarrier.dmi'
		icon_state="2,1"
		density=1
		New()
			..()
			overlays+=/obj/Cbarrier/Cbarrier4
	Cbarrier4
		layer=MOB_LAYER
		icon='cbarrier.dmi'
		icon_state="2"
		pixel_y=32
		density=0


proc/CBarrier(dx,dy,dz,dur)
	var/obj/w1=new/obj/Cbarrier/Cbarrier3(locate(dx,dy+5,dz))
	var/obj/w2=new/obj/Cbarrier/Cbarrier2(locate(dx-1,dy+5,dz))
	var/obj/w3=new/obj/Cbarrier/Cbarrier2(locate(dx-2,dy+5,dz))
	var/obj/w4=new/obj/Cbarrier/Cbarrier3(locate(dx-3,dy+5,dz))
	var/obj/w5=new/obj/Cbarrier/Cbarrier2(locate(dx-4,dy+5,dz))
	var/obj/w6=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy+5,dz))
	var/obj/w7=new/obj/Cbarrier/Cbarrier3(locate(dx+1,dy+5,dz))
	var/obj/w8=new/obj/Cbarrier/Cbarrier2(locate(dx+2,dy+5,dz))
	var/obj/w9=new/obj/Cbarrier/Cbarrier3(locate(dx+3,dy+5,dz))
	var/obj/w10=new/obj/Cbarrier/Cbarrier2(locate(dx+4,dy+5,dz))
	var/obj/w11=new/obj/Cbarrier/Cbarrier3(locate(dx+5,dy+5,dz))
	var/obj/w12=new/obj/Cbarrier/Cbarrier2(locate(dx,dy-5,dz))
	var/obj/w13=new/obj/Cbarrier/Cbarrier2(locate(dx-1,dy-5,dz))
	var/obj/w14=new/obj/Cbarrier/Cbarrier2(locate(dx-2,dy-5,dz))
	var/obj/w15=new/obj/Cbarrier/Cbarrier2(locate(dx-3,dy-5,dz))
	var/obj/w16=new/obj/Cbarrier/Cbarrier3(locate(dx-4,dy-5,dz))
	var/obj/w17=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy-5,dz))
	var/obj/w18=new/obj/Cbarrier/Cbarrier3(locate(dx+1,dy-5,dz))
	var/obj/w19=new/obj/Cbarrier/Cbarrier2(locate(dx+2,dy-5,dz))
	var/obj/w20=new/obj/Cbarrier/Cbarrier3(locate(dx+3,dy-5,dz))
	var/obj/w21=new/obj/Cbarrier/Cbarrier2(locate(dx+4,dy-5,dz))
	var/obj/w22=new/obj/Cbarrier/Cbarrier2(locate(dx+5,dy-5,dz))
	var/obj/w23=new/obj/Cbarrier/Cbarrier2(locate(dx-5,dy-1,dz))
	var/obj/w24=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy-2,dz))
	var/obj/w25=new/obj/Cbarrier/Cbarrier2(locate(dx-5,dy-3,dz))
	var/obj/w26=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy-4,dz))
	var/obj/w27=new/obj/Cbarrier/Cbarrier2(locate(dx+5,dy+1,dz))
	var/obj/w28=new/obj/Cbarrier/Cbarrier3(locate(dx+5,dy+2,dz))
	var/obj/w29=new/obj/Cbarrier/Cbarrier2(locate(dx+5,dy+3,dz))
	var/obj/w30=new/obj/Cbarrier/Cbarrier3(locate(dx+5,dy+4,dz))
	var/obj/w31=new/obj/Cbarrier/Cbarrier2(locate(dx+5,dy-1,dz))
	var/obj/w32=new/obj/Cbarrier/Cbarrier3(locate(dx+5,dy-2,dz))
	var/obj/w33=new/obj/Cbarrier/Cbarrier2(locate(dx+5,dy-3,dz))
	var/obj/w34=new/obj/Cbarrier/Cbarrier3(locate(dx+5,dy-4,dz))
	var/obj/w35=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy+1,dz))
	var/obj/w36=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy+2,dz))
	var/obj/w37=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy+3,dz))
	var/obj/w38=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy+4,dz))
	var/obj/w39=new/obj/Cbarrier/Cbarrier3(locate(dx-5,dy,dz))
	var/obj/w40=new/obj/Cbarrier/Cbarrier3(locate(dx+5,dy,dz))
	sleep(dur)
	del(w1)
	del(w2)
	del(w3)
	del(w4)
	del(w5)
	del(w6)
	del(w7)
	del(w8)
	del(w9)
	del(w10)
	del(w11)
	del(w12)
	del(w13)
	del(w14)
	del(w15)
	del(w16)
	del(w17)
	del(w18)
	del(w19)
	del(w20)
	del(w21)
	del(w22)
	del(w23)
	del(w24)
	del(w25)
	del(w26)
	del(w27)
	del(w28)
	del(w29)
	del(w30)
	del(w31)
	del(w32)
	del(w33)
	del(w34)
	del(w35)
	del(w36)
	del(w37)
	del(w38)
	del(w39)
	del(w40)