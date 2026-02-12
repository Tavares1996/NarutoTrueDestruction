obj
	trigger
		icon = 'icons/gui_triggers.dmi'
		layer = 11

		var
			mob/user

		proc
			Use()
				if(capture_the_flag && capture_the_flag.HasFlag(user)) return

		Click()
			if(usr == user && !user.ko)
				Use()


		New(loc)
			. = ..()
			if(ismob(loc))
				user = loc




mob
	var/triggers[0]


	proc
		AddTrigger(trigger_type)
			if(trigger_type)
				if(ispath(trigger_type, /obj/trigger))
					triggers += new trigger_type(src)
				else if(istype(trigger_type, /obj/trigger))
					triggers += trigger_type
				RefreshTriggers()


		RemoveTrigger(obj/trigger/trigger)
			if(client && (src.Transfered || src.controlling_yamanaka))
				return
			else
				if(trigger)
					if(client) client.screen -= trigger
					triggers -= trigger
					trigger.loc = null
					RefreshTriggers()


		RefreshTriggers()
			if(client)
				for(var/i = 1; i <= triggers.len; ++i)
					var/obj/trigger/T = triggers[i]
					client.screen -= T
					var/rev_index = triggers.len - i
					T.screen_loc = "1:8,[round(rev_index/2) + 2]:[rev_index%2*16]"
					client.screen += T


mob/var/mindtag=0

obj
	trigger
		kawarimi
			icon_state = "kawarimi"



			var
				recall_x
				recall_y
				recall_z



			New(loc, kx, ky, kz)
				. = ..(loc)
				recall_x = kx
				recall_y = ky
				recall_z = kz


			Use()
				if(capture_the_flag && capture_the_flag.HasFlag(user)) return
				if(!user.incombo)
					if(recall_z == user.z)
						Poof(user.x, user.y, user.z)

						new/obj/log(locate(user.x,user.y,user.z))
						user.loc = locate(recall_x,recall_y,recall_z)
						user.icon_state=""
						user.overlays -= image('icons/water_prison.dmi',icon_state="0,0",pixel_x=-16)
						user.overlays -= image('icons/water_prison.dmi',icon_state="1,0",pixel_x=16)
						user.overlays -= image('icons/water_prison.dmi',icon_state="0,1",pixel_x=-16,pixel_y=32)
						user.overlays -= image('icons/water_prison.dmi',icon_state="1,1",pixel_x=16,pixel_y=32)

						user.stunned=2

						user.RemoveTrigger(src)

		explosive
			icon_state = "explosive"


			var
				recall_x
				recall_y
				recall_z



			New(loc, kx, ky, kz)
				.=..(loc)
				recall_x = kx
				recall_y = ky
				recall_z = kz


			Use()
				if(!user.incombo)
					if(recall_z == user.z)
						Poof(user.x, user.y, user.z)

						new/obj/explosive(user,user.x,user.y,user.z)
						user.loc = locate(recall_x,recall_y,recall_z)

						user.stunned=2

						user.RemoveTrigger(src)

		mind_tag
			icon_state = "mind_tag"


			Use()
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget.mindtag)
					spawn(1)
						if(etarget)
							user.client:eye = etarget
							user.client:Controling= etarget
							user.client:perspective = EYE_PERSPECTIVE
							etarget.Transfered=1
							etarget.client:hellno = etarget
							user.controlling_yamanaka=1
						else
							user.combat("No target has been found or the target has ran out of your view")
							return
						sleep(100)
						user.client:eye = user
						user.client:Controling= user
						user.client:perspective = EYE_PERSPECTIVE
						etarget.Transfered=0
						etarget.client:hellno= 0
						etarget.mindtag=0
						user.controlling_yamanaka=0
				else
					return



		clay_kawa
			icon_state = "clay kawa"


			var
				recall_x
				recall_y
				recall_z



			New(loc, kx, ky, kz)
				.=..(loc)
				recall_x = kx
				recall_y = ky
				recall_z = kz


			Use()
				if(capture_the_flag && capture_the_flag.HasFlag(user)) return
				if(!user.incombo)
					if(recall_z == user.z)
						Poof(user.x, user.y, user.z)

						new/obj/clay_kawa(user,user.x,user.y,user.z)
						user.loc = locate(recall_x,recall_y,recall_z)

						user.stunned=2

						user.RemoveTrigger(src)




		C3
			icon_state="C3"



			var/obj/C3



			New(loc, tagobj)
				. = ..(loc)
				C3 = tagobj


			Use()
				if(!C3)
					user.RemoveTrigger(src)
				else
					C3.overlays=0

					var/P=C3.power

					spawn()
						if(user && C3) explosion(P, C3.x, C3.y, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x+1, C3.y+1, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x-1, C3.y+1, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x-1, C3.y-1, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x-1, C3.y-1, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x-2, C3.y+2, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x+2, C3.y-2, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x+2, C3.y+2, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x-2, C3.y-2, C3.z, user, 0, 6)

					spawn(6) del(C3)

					user.RemoveTrigger(src)




		explosive_tag
			icon_state = "exploding tag"



			var
				obj/explosive_tag/ex_tag



			New(loc, tagobj)
				. = ..(loc)
				ex_tag = tagobj


			Use()
				if(!ex_tag)
					user.RemoveTrigger(src)
				else if(ex_tag in oview(8, user))
					var/xx = ex_tag.x
					var/xy = ex_tag.y
					var/xz = ex_tag.z
					del(ex_tag)

					explosion(2000, xx, xy, xz, user)
					user.RemoveTrigger(src)



		jidanda
			icon_state = "jidanda"

			var
				obj/jidanda/ex_tag

			New(loc, tagobj)
				. = ..(loc)
				ex_tag = tagobj

			Use()
				if(!ex_tag)
					user.RemoveTrigger(src)
				else if(ex_tag in oview(8, user))
					var/xx = ex_tag.x
					var/xy = ex_tag.y
					var/xz = ex_tag.z
					del(ex_tag)

					explosion((rand(1000,2000)*user.ControlDamageMultiplier())/1.5, xx, xy, xz, user)
					user.RemoveTrigger(src)



		exploding_spider
			icon_state = "exploding spider"

			var
				mob/human/clay/spider/spider

			New(loc, spidermob)
				. = ..(loc)
				spider = spidermob

			Use()
				if(!spider)
					user.RemoveTrigger(src)
				else if(spider in oview(8, user))
					spider.Explode()
					user.RemoveTrigger(src)




obj/var/power=0