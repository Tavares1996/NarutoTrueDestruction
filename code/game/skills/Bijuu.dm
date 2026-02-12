mob/var
	shukaku=0
	nibi=0
	sanbi=0
	yonbi=0
	gobi=0
	rokubi=0
	shichibi=0
	hachibi=0
	kyuubi=0

obj/Kyuubi
	icon='ninetails.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/ninetails.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "5",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "6",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "6.5",pixel_x=-64,pixel_y=64)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "7",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "8",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "9",pixel_x=32,pixel_y=64)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "9.5",pixel_x=64,pixel_y=64)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "10",pixel_x=-64,pixel_y=96)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "11",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "12",pixel_x=0,pixel_y=96)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "13",pixel_x=32,pixel_y=96)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "14",pixel_x=64,pixel_y=96)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "15",pixel_x=0,pixel_y=128)
		src.overlays+=image('icons/ninetails.dmi',icon_state = "16",pixel_x=32,pixel_y=128)
		..()
		spawn(500)
			if(src)
				del(src)


obj/Shukaku
	icon='shukaku.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/shukaku.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "5",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "6",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "7",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "8",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/shukaku.dmi',icon_state = "9",pixel_x=32,pixel_y=64)
		..()
		spawn(500)
			if(src)
				del(src)

obj/Hachibi
	icon='hachibi.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/hachibi.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "4",pixel_x=-96,pixel_y=32)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "5",pixel_x=-64,pixel_y=32)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "6",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "7",pixel_x=-0,pixel_y=32)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "8",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "9",pixel_x=64,pixel_y=32)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "10",pixel_x=96,pixel_y=32)

		src.overlays+=image('icons/hachibi.dmi',icon_state = "11",pixel_x=-96,pixel_y=64)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "12",pixel_x=-64,pixel_y=64)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "13",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "14",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "15",pixel_x=32,pixel_y=64)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "16",pixel_x=64,pixel_y=64)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "17",pixel_x=96,pixel_y=64)

		src.overlays+=image('icons/hachibi.dmi',icon_state = "18",pixel_x=-96,pixel_y=96)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "19",pixel_x=-64,pixel_y=96)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "20",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "21",pixel_x=0,pixel_y=96)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "22",pixel_x=32,pixel_y=96)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "23",pixel_x=64,pixel_y=96)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "24",pixel_x=96,pixel_y=96)

		src.overlays+=image('icons/hachibi.dmi',icon_state = "25",pixel_x=-96,pixel_y=128)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "26",pixel_x=-64,pixel_y=128)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "27",pixel_x=-32,pixel_y=128)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "28",pixel_x=0,pixel_y=128)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "29",pixel_x=32,pixel_y=128)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "30",pixel_x=64,pixel_y=128)
		src.overlays+=image('icons/hachibi.dmi',icon_state = "31",pixel_x=96,pixel_y=128)
		..()
		spawn(500)
			if(src)
				del(src)


obj/Sanbi
	icon='threetails.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/threetails.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/threetails.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/threetails.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/threetails.dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/threetails.dmi',icon_state = "5",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/threetails.dmi',icon_state = "6",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/threetails.dmi',icon_state = "7",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/threetails.dmi',icon_state = "8",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/threetails.dmi',icon_state = "9",pixel_x=32,pixel_y=64)
		src.overlays+=image('icons/threetails.dmi',icon_state = "10",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/threetails.dmi',icon_state = "11",pixel_x=0,pixel_y=96)
		src.overlays+=image('icons/threetails.dmi',icon_state = "12",pixel_x=32,pixel_y=96)
		..()
		spawn(500)
			if(src)
				del(src)


obj/Yonbi
	icon='fourtails.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/fourtails.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "4",pixel_x=64,pixel_y=0)

		src.overlays+=image('icons/fourtails.dmi',icon_state = "5",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "6",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "7",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "8",pixel_x=64,pixel_y=32)

		src.overlays+=image('icons/fourtails.dmi',icon_state = "9",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "10",pixel_x=-0,pixel_y=64)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "11",pixel_x=32,pixel_y=64)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "12",pixel_x=64,pixel_y=64)

		src.overlays+=image('icons/fourtails.dmi',icon_state = "13",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "14",pixel_x=-0,pixel_y=96)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "15",pixel_x=32,pixel_y=96)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "16",pixel_x=64,pixel_y=96)

		src.overlays+=image('icons/fourtails.dmi',icon_state = "17",pixel_x=-32,pixel_y=128)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "18",pixel_x=-0,pixel_y=128)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "19",pixel_x=32,pixel_y=128)
		src.overlays+=image('icons/fourtails.dmi',icon_state = "20",pixel_x=64,pixel_y=128)
		..()
		spawn(500)
			if(src)
				del(src)

obj/Nibi
	icon='Nibi.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/Nibi.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "2",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "3",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "5",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "6",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "7",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "8",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "9",pixel_x=32,pixel_y=64)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "10",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "11",pixel_x=0,pixel_y=96)
		src.overlays+=image('icons/Nibi.dmi',icon_state = "12",pixel_x=32,pixel_y=96)
		..()
		spawn(500)
			if(src)
				del(src)


obj/Shichibi
	icon='Nanabi.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "1",pixel_x=-64,pixel_y=0)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "2",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "3",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "4",pixel_x=32,pixel_y=0)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "5",pixel_x=64,pixel_y=0)

		src.overlays+=image('icons/Nanabi.dmi',icon_state = "6",pixel_x=-64,pixel_y=32)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "7",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "8",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "9",pixel_x=32,pixel_y=32)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "10",pixel_x=64,pixel_y=32)

		src.overlays+=image('icons/Nanabi.dmi',icon_state = "11",pixel_x=-64,pixel_y=64)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "12",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "13",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "14",pixel_x=32,pixel_y=64)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "15",pixel_x=64,pixel_y=64)

		src.overlays+=image('icons/Nanabi.dmi',icon_state = "16",pixel_x=-64,pixel_y=96)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "17",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "18",pixel_x=0,pixel_y=96)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "19",pixel_x=32,pixel_y=96)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "20",pixel_x=64,pixel_y=96)

		src.overlays+=image('icons/Nanabi.dmi',icon_state = "21",pixel_x=-64,pixel_y=128)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "22",pixel_x=-32,pixel_y=128)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "23",pixel_x=0,pixel_y=128)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "24",pixel_x=32,pixel_y=128)
		src.overlays+=image('icons/Nanabi.dmi',icon_state = "25",pixel_x=64,pixel_y=128)
		..()
		spawn(500)
			if(src)
				del(src)

obj/Gobi
	icon='Gobi.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/Gobi.dmi',icon_state = "1",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "2",pixel_x=0,pixel_y=0)

		src.overlays+=image('icons/Gobi.dmi',icon_state = "3",pixel_x=-64,pixel_y=32)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "4",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "5",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "6",pixel_x=32,pixel_y=32)

		src.overlays+=image('icons/Gobi.dmi',icon_state = "7",pixel_x=-64,pixel_y=64)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "8",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "9",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "10",pixel_x=32,pixel_y=64)

		src.overlays+=image('icons/Gobi.dmi',icon_state = "11",pixel_x=-64,pixel_y=96)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "12",pixel_x=-32,pixel_y=96)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "13",pixel_x=0,pixel_y=96)
		src.overlays+=image('icons/Gobi.dmi',icon_state = "14",pixel_x=32,pixel_y=96)
		..()
		spawn(500)
			if(src)
				del(src)

obj/Rokubi
	icon='Rokubi.dmi'
	density=0
	layer=MOB_LAYER
	New()
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "1",pixel_x=-64,pixel_y=0)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "2",pixel_x=-32,pixel_y=0)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "3",pixel_x=0,pixel_y=0)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "4",pixel_x=32,pixel_y=0)

		src.overlays+=image('icons/Rokubi.dmi',icon_state = "5",pixel_x=-64,pixel_y=32)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "6",pixel_x=-32,pixel_y=32)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "7",pixel_x=0,pixel_y=32)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "8",pixel_x=32,pixel_y=32)

		src.overlays+=image('icons/Rokubi.dmi',icon_state = "9",pixel_x=-64,pixel_y=64)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "10",pixel_x=-32,pixel_y=64)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "11",pixel_x=0,pixel_y=64)
		src.overlays+=image('icons/Rokubi.dmi',icon_state = "12",pixel_x=32,pixel_y=64)
		..()
		spawn(500)
			if(src)
				del(src)

skill
	bijuu
		copyable=0

		shukaku
			id = SHUKAKU
			name = "Shukaku"
			icon_state = "shukaku"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Shukaku!", "combat_output")
				world<<"<font color=gold>[usr] has activated his or her's Shukaku Tailed Beast."
				var/buffcon=round(user.con*0.80)
				var/buffstr=round(user.str*0.80)
				user.conbuff+=buffcon
				user.strbuff+=buffstr
				user.shukaku=1
				user.protected=10
				var/obj/S = new/obj/Shukaku(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/shukakuaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.conbuff-=round(buffcon)
					user.strbuff-=round(buffstr)
					user.overlays-=image('icons/shukakuaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.shukaku=0

		nibi
			id = NIBI
			name = "Nibi"
			icon_state = "nibi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Nibi!", "combat_output")
				world<<"<font color=blue>[usr] has activated his or her's Nibi Tailed Beast."
				var/buffcon=round(user.con*0.80)
				var/buffrfx=round(user.rfx*0.80)
				user.conbuff+=buffcon
				user.rfxbuff+=buffrfx
				user.nibi=1
				user.protected=10
				var/obj/S = new/obj/Nibi(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/nibiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.conbuff-=round(buffcon)
					user.rfxbuff-=round(buffrfx)
					user.overlays-=image('icons/nibiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.nibi=0

		sanbi
			id = SANBI
			name = "Sanbi"
			icon_state = "sanbi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Sanbi!", "combat_output")
				world<<"<font color=green>[usr] has activated his or her's Sanbi Tailed Beast."
				var/buffcon=round(user.con*0.80)
				var/buffint=round(user.int*0.80)
				user.conbuff+=buffcon
				user.intbuff+=buffint
				user.sanbi=1
				user.protected=10
				var/obj/S = new/obj/Sanbi(locate(user.x,user.y,user.z))
				spawn()explosion(, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/sanbiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.conbuff-=round(buffcon)
					user.intbuff-=round(buffint)
					user.overlays-=image('icons/sanbiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.sanbi=0

		yonbi
			id = YONBI
			name = "Yonbi"
			icon_state = "yonbi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Yonbi!", "combat_output")
				world<<"<font color=red>[usr] has activated his or her's Yonbi Tailed Beast."
				var/buffstr=round(user.str*0.80)
				var/buffrfx=round(user.rfx*0.80)
				user.strbuff+=buffstr
				user.rfxbuff+=buffrfx
				user.yonbi=1
				user.protected=10
				var/obj/S = new/obj/Yonbi(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/yonbiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.strbuff-=round(buffstr)
					user.rfxbuff-=round(buffrfx)
					user.overlays-=image('icons/yonbiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.yonbi=0

		gobi
			id = GOBI
			name = "Gobi"
			icon_state = "gobi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Gobi!", "combat_output")
				world<<"<font color=white>[usr] has activated his or her's Gobi Tailed Beast."
				var/buffint=round(user.int*0.80)
				var/buffrfx=round(user.rfx*0.80)
				user.intbuff+=buffint
				user.rfxbuff+=buffrfx
				user.gobi=1
				user.protected=10
				var/obj/S = new/obj/Gobi(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/gobiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.intbuff-=round(buffint)
					user.rfxbuff-=round(buffrfx)
					user.overlays-=image('icons/gobiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.gobi=0

		rokubi
			id = ROKUBI
			name = "Rokubi"
			icon_state = "rokubi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Rokubi!", "combat_output")
				world<<"<font color=grey>[usr] has activated his or her's Shukaku Tailed Beast."
				var/buffint=round(user.int*0.60)
				var/buffrfx=round(user.rfx*0.60)
				var/buffcon=round(user.con*0.60)
				user.intbuff+=buffint
				user.rfxbuff+=buffrfx
				user.conbuff+=buffcon
				user.rokubi=1
				user.protected=10
				var/obj/S = new/obj/Rokubi(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/rokubiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.intbuff-=round(buffint)
					user.rfxbuff-=round(buffrfx)
					user.conbuff-=round(buffcon)
					user.overlays-=image('icons/rokubiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.rokubi=0

		shichibi
			id = SHICHIBI
			name = "Shichibi"
			icon_state = "shichibi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Shichibi!", "combat_output")
				world<<"<font color=purple>[usr] has activated his or her's Shukaku Tailed Beast."
				var/buffstr=round(user.str*0.60)
				var/buffrfx=round(user.rfx*0.60)
				var/buffcon=round(user.con*0.60)
				user.strbuff+=buffstr
				user.rfxbuff+=buffrfx
				user.conbuff+=buffcon
				user.shichibi=1
				user.protected=10
				var/obj/S = new/obj/Shichibi(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/shichibiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.strbuff-=round(buffstr)
					user.rfxbuff-=round(buffrfx)
					user.conbuff-=round(buffcon)
					user.overlays-=image('icons/shichibiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.shichibi=0


		hachibi
			id = HACHIBI
			name = "Hachibi"
			icon_state = "hachibi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Hachibi!", "combat_output")
				world<<"<font color=brown>[usr] has activated his or her's Shukaku Tailed Beast."
				var/buffstr=round(user.str*0.60)
				var/buffrfx=round(user.rfx*0.70)
				var/buffcon=round(user.con*0.50)
				var/buffint=round(user.int*0.50)
				user.intbuff+=buffint
				user.rfxbuff+=buffrfx
				user.conbuff+=buffcon
				user.strbuff+=buffstr
				user.hachibi=1
				user.protected=10
				var/obj/S = new/obj/Hachibi(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/hachibiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.intbuff-=round(buffint)
					user.rfxbuff-=round(buffrfx)
					user.conbuff-=round(buffcon)
					user.strbuff-=round(buffstr)
					user.overlays-=image('icons/hachibiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.hachibi=0

		kyuubi
			id = KYUUBI
			name = "Kyuubi"
			icon_state = "kyuubi"
			default_chakra_cost = 100
			default_cooldown = 1000

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(usr.shukaku==1||usr.nibi==1||usr.yonbi==1||usr.sanbi==1||usr.gobi==1||usr.rokubi==1||usr.shichibi==1||usr.hachibi==1||usr.kyuubi==1)
						Error(user, "You're currently using a different bijuu. Please wait for it to end.")
						return 0

			Use(mob/user)
				viewers(user) << output("[user]: Ughh.. Tailed Beast: Kyuubi!", "combat_output")
				world<<"<font color=red>[usr] has activated his or her's Shukaku Tailed Beast."
				var/buffstr=round(user.str*0.80)
				var/buffrfx=round(user.rfx*0.50)
				var/buffcon=round(user.con*0.70)
				var/buffint=round(user.int*0.50)
				user.intbuff+=buffint
				user.rfxbuff+=buffrfx
				user.conbuff+=buffcon
				user.strbuff+=buffstr
				user.protected=10
				user.kyuubi=1
				var/obj/S = new/obj/Kyuubi(locate(user.x,user.y,user.z))
				spawn()explosion(100, S.x, S.y, S.z, user, 0, 2)
				user.overlays+=image('icons/kyuubiaura.dmi')
				user.overlays+=image('icons/bijuuaura.dmi')
				spawn(150) del(S)
				spawn(5) user.protected=0

				spawn(600)
					if(!user) return
					user.intbuff-=round(buffint)
					user.rfxbuff-=round(buffrfx)
					user.conbuff-=round(buffcon)
					user.strbuff-=round(buffstr)
					user.overlays-=image('icons/kyuubiaura.dmi')
					user.overlays-=image('icons/bijuuaura.dmi')
					user.combat("Your control over your beast fades and your chakra drops back to normal.")
					user.kyuubi=0


		bijuu_extraction
			id = BIJUU_EXTRACTION
			name = "Bijuu Extraction"
			icon_state = "extraction"
			default_chakra_cost = 2000
			default_cooldown = 1000

			IsUsable(mob/user)
				.=..()
				if(.)
					var/mob/human/T = user.MainTarget()
					var/distance = get_dist(user, T)
					if(distance > 1)
						Error(user, "Your target needs to be next to you.")
						return 0
					if(!T.stunned)
						Error(user, "Your target isn't stunned.")
						return 0
					if(!T.HasSkill(SHUKAKU)&&!T.HasSkill(NIBI)&&!T.HasSkill(SANBI)&&!T.HasSkill(YONBI)&&!T.HasSkill(GOBI)&&!T.HasSkill(ROKUBI)&&!T.HasSkill(HACHIBI)&&!T.HasSkill(SHICHIBI)&&!T.HasSkill(KYUUBI))
						Error(user, "Your target does not have a bijuu.")
						return 0
					if(istype(T,/mob/corpse))
						Error(user, "Your target must be alive! Cannot be used on corpses!")
						return 0
					if(T.curwound <= 80)
						Error(user, "Your target's wounds must be higher!")
						return 0

			Use(mob/human/user)
				var/mob/human/T = user.MainTarget()
				if(!T) return
				viewers(user) << output("[user] attempts to take [T]'s Bijuu!", "combat_output")
				spawn(10)
					user.stunned = 20
					T.stunned = 20
					T.cantreact = 1
					var/B=20
					if(prob(B))
						viewers(user) << output("[user] has successfully took [T]'s Bijuu!", "combat_output")
						usr<<"You have gained [T]'s bijuu. Please relog to finish the operation!"
						T.Wound(200)
						if(T.HasSkill(GOBI))
							T.RemoveSkill(GOBI)
							usr.AddSkill(GOBI)
						else if(T.HasSkill(SHUKAKU))
							T.RemoveSkill(SHUKAKU)
							usr.AddSkill(SHUKAKU)
						else if(T.HasSkill(NIBI))
							T.RemoveSkill(NIBI)
							usr.AddSkill(NIBI)
						else if(T.HasSkill(SANBI))
							T.RemoveSkill(SANBI)
							usr.AddSkill(SANBI)
						else if(T.HasSkill(YONBI))
							T.RemoveSkill(YONBI)
							usr.AddSkill(YONBI)
						else if(T.HasSkill(ROKUBI))
							T.RemoveSkill(ROKUBI)
							usr.AddSkill(ROKUBI)
						else if(T.HasSkill(HACHIBI))
							T.RemoveSkill(HACHIBI)
							usr.AddSkill(HACHIBI)
						else if(T.HasSkill(SHICHIBI))
							T.RemoveSkill(SHICHIBI)
							usr.AddSkill(SHICHIBI)
						else  if(T.HasSkill(KYUUBI))
							T.RemoveSkill(KYUUBI)
							usr.AddSkill(KYUUBI)
						usr.RefreshSkillList()
						T.RefreshSkillList()
					else
						viewers(user) << output("[user] has failed to take [T]'s Bijuu.", "combat_output")
						B-=3
						if(B <= 0)
							B=2
					user.stunned = 0
					T.stunned = 0


		gale_storm
			id = GALE_STORM
			name = "Fuuton Style: Gale Storm"
			icon_state = "wind1"
			default_chakra_cost = 900
			default_cooldown = 300

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.RankGrade2()!=5)
						Error(user, "You must be S rank to use this Jutsu")
						return 0

			Use(mob/human/user)
				viewers(user) << output("[user]: Gale Storm!","combat_output")

				user.stunned = 0.5
				user.icon_state = "Seal"

				spawn(8)
					user.icon_state = ""

				var/mob/human/M = user.MainTarget()
				var/obj/Q = new/gale_storm(get_step(user, user.dir))

				Q.owner = user
				Q.dir = user.dir

				spawn()

					var/time = 10

					while(user && M && Q && time > 0)
						step_to(Q, M, 1)
						time--

						sleep(3)

					if(Q)
						Q.overlays = 0
						Q.icon = 0
						Q.loc = null

		fuuton_palm
			id = WIND_PALM
			name = "Fuuton Style: Wind Palm"
			icon_state = "wind2"
			default_chakra_cost = 650
			default_cooldown = 100

			Use(mob/human/user)
				var/control_mult = user.ControlDamageMultiplier()
				var/time = 4
				var/obj/obj = new/wind_palm(get_step(user, user.dir))

				obj.owner = user
				obj.dir = user.dir

				user.stunned = 3
				user.icon_state = "Throw2"

				viewers(user) << output("[user]: Fuuton Style: Wind Revolution Palm!", "combat_output")

				spawn(30)
					user.icon_state = ""
					user.stunned = 0

				spawn()
					while(user && time)
						for(var/mob/M in oview(2, obj))
							if(M != user)
								M.Dec_Stam(rand(1000, 1500) + rand(90, 180) * control_mult, 0, user)
								M.move_stun = 20
								explosion(50, M.x, M.y, M.z, user, 1)
								M.Knockback(4, obj.dir)
						time--
						sleep(10)
					if(obj)
						obj.overlays = 0
						obj.icon = 0
						obj.loc = null








gale_storm

	parent_type = /obj

	icon = 'icons/gale storm.dmi'
	icon_state = "middle"

	layer = MOB_LAYER + 0.1
	density = 0

	New(loc)
		..(loc)

		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "top_left", pixel_x = -32, pixel_y = 32)
		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "top_middle", pixel_y = 32)
		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "top_right", pixel_x = 32, pixel_y = 32)

		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "middle_left", pixel_x = -32)
		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "middle_right", pixel_x = 32)

		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "bottom_left", pixel_x = -32, pixel_y = -32)
		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "bottom_center", pixel_y = -32)
		overlays += image(icon = 'icons/gale storm.dmi', icon_state = "bottom_right", pixel_x = 32, pixel_y = -32)



		spawn(150)
			if(src)
				loc = null

	Move()
		..()

		spawn()

			for(var/mob/M in view(2, src))
				if(M != src.owner)
					M:Dec_Stam(rand(1000, 2100) + rand(50, 150) * src.owner:ControlDamageMultiplier(), 1, src.owner)
					M.Knockback(3, src.dir)


wind_palm

	parent_type = /obj

	icon = 'icons/storm.dmi'
	icon_state = "bottom_right"

	density = 0
	layer = MOB_LAYER + 0.1

	New(loc)
		..(loc)

		overlays += image(icon = 'icons/storm.dmi', icon_state = "bottom_left", pixel_x = -32)
		overlays += image(icon = 'icons/storm.dmi', icon_state = "top_left", pixel_x = -32, pixel_y = 32)
		overlays += image(icon = 'icons/storm.dmi', icon_state = "top_right", pixel_y = 32)

		spawn(40)
			if(src)
				loc = null
