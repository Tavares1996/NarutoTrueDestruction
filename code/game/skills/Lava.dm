skill
	lava
		copyable = 0

		lava_release_quicklime_congealing_technique
			id = LAVA_RELEASE_QUICKLIME
			name = "Lava Release: Quicklime Congealing Technique"
			icon_state = "quicklime"
			default_chakra_cost = 250
			default_cooldown = 30

			Use(mob/human/user)
				var/obj/corrosion_blob/O=new/obj/corrosion_blob(user)
				O.density=0
				O.dir=user.dir

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

				var/tiles=8
				var/hit=0
				while(user&&O&&tiles>0&&!hit)
					for(var/mob/M in O.loc)
						if(M!=user)
							O.loc=null
							hit=1
							spawn()
								M.stunned+=3
								M.overlays+='icons/corrosion_hit.dmi'
								new/obj/corrosion(user,M.loc,1)
								while(M&&M.stunned>0)
									M.icon_state="hurt"
									sleep(1)
								if(M)
									M.icon_state=""
									M.overlays-='icons/corrosion_hit.dmi'
							break
					step(O,O.dir)
					tiles--
					sleep(1)
				if(!hit)
					new/obj/corrosion(user,O.loc,1)
					O.loc=null






obj
	corrosion_blob
		icon='icons/corrosion.dmi'
		icon_state="blob"
/*
	quicklime
		icon='icons/corrosion.dmi'
		left
			pixel_x=-32
			icon_state="left"
		right
			pixel_x=32
			icon_state="right"
		middle
			icon_state="middle"

	quicklime_full
		var
			list/dependants=new
		New()
			spawn()..()
			spawn()
				dependants+=new/obj/quicklime/left(locate(src.x,src.y,src.z))
				dependants+=new/obj/quicklime/right(locate(src.x,src.y,src.z))
				dependants+=new/obj/quicklime/middle(locate(src.x,src.y,src.z))
*/
	corrosion
		icon='icons/corrosion.dmi'
		icon_state="middle"
		New(mob/user,location,jutsu)
			.=..()
			loc=location
			pixel_x=rand(-16,16)
			pixel_y=rand(-16,16)
			owner = user
			if(jutsu)
				spawn()new/obj/corrosion(user,locate(x+1,y+1,z))
				spawn()new/obj/corrosion(user,locate(x-1,y-1,z))
				spawn()new/obj/corrosion(user,locate(x-1,y,z))
				spawn()new/obj/corrosion(user,locate(x+1,y,z))
				spawn()new/obj/corrosion(user,locate(x,y+1,z))
				spawn()new/obj/corrosion(user,locate(x,y-1,z))
				spawn()new/obj/corrosion(user,locate(x-1,y+1,z))
				spawn()new/obj/corrosion(user,locate(x+1,y-1,z))
			spawn(300)
				src.loc=null
		proc/E(mob/human/o)
			if(o==owner) return
			usr=o
			spawn()
				usr.stunned+=5
				usr.overlays+='corrosion_hit.dmi'
				while(usr&&usr.stunned>0)
					usr.icon_state="hurt"
					sleep(1)
				if(usr)
					usr.icon_state=""
					usr.overlays-='corrosion_hit.dmi'
				src.loc=null
			..()