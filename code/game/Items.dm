mob/var/
	chakra_storage=0

mob/proc
	removeswords()
		if(src.specialover=="sword")
			src.weapon=new/list
			src.specialover=""
			src.Load_Overlays()
			sleep(1)

	addswords()
		for(var/obj/items/weapons/o in src.contents)
			if(o.equipped)
				o:Use(src)
				sleep(1)
				o:Use(src)
obj
	var

		nottossable=0
obj/items
	Click()
		if(src.deletable)
			var/remove=1
			for(var/obj/items/X in usr.contents)
				if(X.type==src.type)
					remove=0
			if(remove)
				del(src)
		..()
	verb
		Toss()
			set category=null
			if(!src.nottossable)
				for(var/obj/items/X in src.loc)
					if(istype(X,src.type))
						if(X.deletable)
							del(X)
				del(src)
	layer=11
	var
		posit=0
		worn=0
		deletable=0

obj/items
	var
		weapon
		armor


obj/items/usable
	var/oname
	New()
		src.oname=src.name
		src.equipped+=1
		src.name="[src.oname]([equipped])" //equipped is used for the quantity variable
	proc/Refreshcount(mob/human/player/O)
		O.busy=0
		for(var/obj/items/usable/x in O.contents)
			if(istype(x,src.type))
				x.equipped--
				x.name="[src.oname]([equipped])"
				if(x!=src)
					if(x.equipped<=0)
						del(x)
		if(src.equipped<=0)
			del(src)
	proc/Refreshcountdd(mob/human/player/O)
		for(var/obj/items/x in O.contents)
			if(istype(x,src.type))
				if(istext(equipped)) equipped = text2num(equipped)
				x.name="[src.oname]([equipped])"
				if(x!=src)
					if(istext(x.equipped)) x.equipped = text2num(x.equipped)
					if(x.equipped<=0)
						del(x)
		if(src.equipped<=0)
			del(src)
	Caltrop
		icon='icons/gui.dmi'
		icon_state="caltrop"
		code=213
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0&&usr.pk==1)
				usr.busy=1
				usr<<"Dropped Caltrops"
				var/i
				var/obj/o
				for(var/obj/caltrops in oview(0,usr))
					i=1
				if(i!=1)
					o=new/obj/caltrops(usr.loc)

				src.Refreshcount(usr)
				sleep(5)

				spawn(6000)
					if(o)
						del(o)

		Click()
			Use(usr)

	Tripwire
		icon='icons/gui.dmi'
		icon_state="tripwire"
		code=214
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0&&usr.pk==1)
				usr.busy=1
				usr.stunned=4
				usr<<"Placing Trip Wire"
				var/obj/o=new/obj/trip(usr.loc)
				if(o)o.dir=usr.dir
				sleep(40)
				usr<<"Trap Complete"
				usr.stunned=0

				src.Refreshcount(usr)
				spawn(6000)
					if(o)
						del(o)

		Click()
			Use(usr)

	Respec
		icon='icons/gui.dmi'
		code=4758
		icon_state="respec"
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.busy==0)
				usr.busy=1

				usr.Respec()
				src.Refreshcount(usr)

				usr.client.SaveMob()
				usr.busy=0

		Click()
			Use(usr)

	Antidote
		icon='icons/gui.dmi'
		icon_state="antidote"
		code=209
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u

		Click()
			Use(usr)

	Bandage
		icon='icons/gui.dmi'
		icon_state="bandage"
		code=210
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0&&usr.stunned==0&&usr.bandaged==0)
				usr.bandaged=1
				usr.busy=1
				usr.stunned=4
				usr<<"Using Bandages..."
				sleep(40)
				usr<<"20 wounds recovered"
				usr.curwound-=20
				if(usr.curwound<0)
					usr.curwound=0
				spawn(1200)
					usr.bandaged=0
				src.Refreshcount(usr)
				usr.busy=0
			else if(usr.bandaged==1)
				usr<<"Using Bandages again so soon is pointless"
				usr.busy=0

		Click()
			Use(usr)

	Scroll
		Supplyscroll
			icon='icons/gui.dmi'
			icon_state="supplyscroll"
			code=211
			proc/Use(var/mob/u)
				set hidden=1
				set category=null

				usr=u
				if(usr.ko|| usr.stunned||usr.handseal_stun)
					return
				if(usr.busy==0)
					usr.busy=1
					usr.supplies=usr.maxsupplies
					src.Refreshcount(usr)
					usr<<"You used up a supply scroll"
					usr.busy=0

			Click()
				Use(usr)

	SoldierPill
		icon='icons/gui.dmi'
		code=212
		icon_state="soldierpill"
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0)
				usr.busy=1
				if(usr.soldierpill==0)
					usr.curstamina = min(usr.curstamina+3000, usr.stamina*1.5)
					usr.soldierpill=1
					spawn(2400)
						usr.soldierpill=0
						if(usr.curstamina>usr.stamina)
							usr.curstamina=usr.stamina
					usr<<"You ate a soldier pill"
					src.Refreshcount(usr)
					usr.busy=0
				else
					usr<<"Using another Soldier Pill so soon is pointless"
					usr.busy=0


		Click()
			Use(usr)

obj/items/equipable
	Kunai_Holster
		armor="legarmor"
		icon='icons/Kunai_Holster.dmi'
		icon_state="HUD"
		code=115
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor==src.armor)
					O.overlays=0
					O.overlays+=O.macover
					O.equipped=0

			if(equ)
				usr.legarmor=0
			else
				usr.legarmor=/obj/Kunai_Holster
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Arm_Guards
		armor="armarmor"
		icon='icons/arm_guards.dmi'
		icon_state="gui"
		acmod=4
		code=222
		hind=2
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor==src.armor)
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armarmor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armarmor",/obj/arm_guards)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Sand_Gourd
		armor="armor"
		icon='members/sandgourd.dmi'
		icon_state="gui"
		code=4635
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.cloak=0
			else
				usr.cloak=/obj/members/sand_gourd
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Uchiha_Shirt
		armor="armor"
		icon='members/uchiha_shirt.dmi'
		icon_state="gui"
		code=5261
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="cloak")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.cloak=0
			else
				usr.cloak=/obj/members/uchiha_shirt
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Straw_Hat
		armor="facearmor"
		icon='members/strawhat.dmi'
		icon_state="gui"
		code=5628
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="facearmor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.cloak=0
			else
				usr.cloak=/obj/members/strawhat
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Obito_Goggles
		armor="armor"
		icon='members/Obito_Goggles.dmi'
		icon_state="gui"
		code=5261
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="facearmor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.cloak=0
			else
				usr.cloak=/obj/members/obito_goggles
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Sasuke_Clothes
		armor="cloak"
		icon='icons/sasuke_cloth.dmi'
		icon_state="gui"
		code=129
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="cloak")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.cloak=0
			else
				usr.cloak=/obj/sasuke_cloth
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Leaf
		code=224
		armor="armor"
		icon='icons/chuunin-vest.dmi'
		icon_state="HUD"
		acmod=10
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/leaf)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Sand
		armor="armor"
		icon='icons/chuunin-vest_sand.dmi'
		icon_state="HUD"
		code=225
		acmod=10
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/sand)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Mist
		armor="armor"
		icon='icons/chuunin-vest_mist.dmi'
		icon_state="HUD"
		acmod=10
		code=226
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/mist)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Rain
		code=10000
		armor="armor"
		icon='faction_icons/ourico-ame-chuunin.dmi'
		icon_state="HUD"
		acmod=10
		var/overlay_type
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/rain)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Sound
		code=10001
		armor="armor"
		icon='faction_icons/mange-sound-chuunin.dmi'
		icon_state="HUD"
		acmod=10
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/sound)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Akatsuki_Suit
		code=10003
		armor="armor"
		icon='faction_icons/akatsuki-suit.dmi'
		icon_state="HUD"
		acmod=50
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/akatsuki_suit)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Vincent_Suit
		code=70000
		armor="armor"
		icon='faction_icons/sword-chuunin.dmi'
		icon_state="HUD"
		acmod=10
		var/overlay_type
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/vincent)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Samegakure_Vest
		code=65000
		armor="armor"
		icon='faction_icons/mange-sound-chuunin3.dmi'
		icon_state="HUD"
		acmod=10
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/same)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Dark_Leagence_Suit
		code=60000
		armor="armor"
		icon='faction_icons/HunterNin-Chuunin.dmi'
		icon_state="HUD"
		acmod=50
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/dark)

			usr.Load_Overlays()
		Click()
			Use(usr)

	trench
		armor="cloak"
		black
			icon='trench/trench.dmi'
			icon_state="HUD"
			code=197
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='trench/trenchdred.dmi'
			icon_state="HUD"
			code=198
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='trench/trenchdgreen.dmi'
			icon_state="HUD"
			code=199
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='trench/trenchbrown.dmi'
			icon_state="HUD"
			code=200
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		blue
			icon='trench/trenchblue.dmi'
			icon_state="HUD"
			code=201
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		grey
			icon='trench/trenchgrey.dmi'
			icon_state="HUD"
			code=202
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		red
			icon='trench/trenchred.dmi'
			icon_state="HUD"
			code=203
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		green
			icon='trench/trenchgreen.dmi'
			icon_state="HUD"
			code=204
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		orange
			icon='trench/trenchorange.dmi'
			icon_state="HUD"
			code=205
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='trench/trenchdblue.dmi'
			icon_state="HUD"
			code=206
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		purple
			icon='trench/trenchpurple.dmi'
			icon_state="HUD"
			code=207
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/purple
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		white
			icon='trench/trenchwhite.dmi'
			icon_state="HUD"
			code=208
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	jacket
		armor="armor"
		black
			icon='jacket/jacket.dmi'
			icon_state="HUD"
			code=159
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='jacket/jacketdred.dmi'
			icon_state="HUD"
			code=160
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='jacket/jacketdgreen.dmi'
			icon_state="HUD"
			code=161
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='jacket/jacketbrown.dmi'
			icon_state="HUD"
			code=162
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		grey
			icon='jacket/jacketgrey.dmi'
			icon_state="HUD"
			code=163
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		obito
			icon='jacket/jacketobito.dmi'
			icon_state="HUD"
			code=164
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/obito
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='jacket/jacketdblue.dmi'
			icon_state="HUD"
			code=165
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

	shirt_sleeves
		armor="overshirt"
		black
			icon='icons/shirt_sleeves/shirt_sleeves.dmi'
			icon_state="HUD"
			code=185
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='icons/shirt_sleeves/shirt_sleevesdred.dmi'
			icon_state="HUD"
			code=186
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='icons/shirt_sleeves/shirt_sleevesdgreen.dmi'
			icon_state="HUD"
			code=187
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='icons/shirt_sleeves/shirt_sleevesbrown.dmi'
			icon_state="HUD"
			code=188
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		blue
			icon='icons/shirt_sleeves/shirt_sleevesblue.dmi'
			icon_state="HUD"
			code=189
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		grey
			icon='icons/shirt_sleeves/shirt_sleevesgrey.dmi'
			icon_state="HUD"
			code=190
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		red
			icon='icons/shirt_sleeves/shirt_sleevesred.dmi'
			icon_state="HUD"
			code=191
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		green
			icon='icons/shirt_sleeves/shirt_sleevesgreen.dmi'
			icon_state="HUD"
			code=192
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		orange
			icon='icons/shirt_sleeves/shirt_sleevesorange.dmi'
			icon_state="HUD"
			code=193
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='icons/shirt_sleeves/shirt_sleevesdblue.dmi'
			icon_state="HUD"
			code=194
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		purple
			icon='icons/shirt_sleeves/shirt_sleevespurple.dmi'
			icon_state="HUD"
			code=195
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/purple
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		white
			icon='icons/shirt_sleeves/shirt_sleeveswhite.dmi'
			icon_state="HUD"
			code=196
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

	cloak
		armor="cloak"
		black
			icon='cloak/cloak.dmi'
			icon_state="gui"
			code=147
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='cloak/cloakdred.dmi'
			icon_state="gui"
			code=148
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='cloak/cloakdgreen.dmi'
			icon_state="gui"
			code=149
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='cloak/cloakbrown.dmi'
			icon_state="gui"
			code=150
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		blue
			icon='cloak/cloakblue.dmi'
			icon_state="gui"
			code=151
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		grey
			icon='cloak/cloakgrey.dmi'
			icon_state="gui"
			code=152
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		red
			icon='cloak/cloakred.dmi'
			icon_state="gui"
			code=153
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		green
			icon='cloak/cloakgreen.dmi'
			icon_state="gui"
			code=154
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		orange
			icon='cloak/cloakorange.dmi'
			icon_state="gui"
			code=155
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='cloak/cloakdblue.dmi'
			icon_state="gui"
			code=156
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		purple
			icon='cloak/cloakpurple.dmi'
			icon_state="gui"
			code=157
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/purple
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		white
			icon='cloak/cloakwhite.dmi'
			icon_state="gui"
			code=158
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	Pants
		armor="pants"
		Black
			code=118
			icon='icons/pants.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Blue
			code=119
			icon='icons/pantsblue.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Red
			code=120
			icon='icons/pantsred.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		White
			code=121
			icon='icons/pantswhite.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Green
			code=122
			icon='icons/pantsgreen.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Grey
			code=123
			icon='icons/pantsgrey.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Orange
			code=124
			icon='icons/pantsorange.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Brown
			code=125
			icon='icons/pantsbrown.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightBrown
			code=126
			icon='icons/pantslightbrown.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/lightbrown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightGrey
			code=127
			icon='icons/pantslightgrey.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/lightgrey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightBlue
			code=128
			icon='icons/pantslightblue.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/lightblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	Shirt
		armor="overshirt"

		Black
			icon='icons/shirt.dmi'
			icon_state="hud"
			code=130
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Blue
			icon='icons/shirtblue.dmi'
			icon_state="hud"
			code=131
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		DarkBlue
			icon='icons/shirtdarkblue.dmi'
			icon_state="hud"
			code=132
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightBlue
			icon='icons/shirtlightblue.dmi'
			icon_state="hud"
			code=133
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Orange
			icon='icons/shirtorange.dmi'
			icon_state="hud"
			code=134
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		DarkOrange
			icon='icons/shirtdarkorange.dmi'
			icon_state="hud"
			code=135
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkorange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightOrange
			icon='icons/shirtlightorange.dmi'
			icon_state="hud"
			code=136
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightorange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Red
			icon='icons/shirtred.dmi'
			icon_state="hud"
			code=137
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		DarkRed
			icon='icons/shirtdarkred.dmi'
			icon_state="hud"
			code=138
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightRed
			icon='icons/shirtlightred.dmi'
			icon_state="hud"
			code=139
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		White
			icon='icons/shirtwhite.dmi'
			icon_state="hud"
			code=140
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Green
			icon='icons/shirtgreen.dmi'
			icon_state="hud"
			code=141
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		DarkGreen
			icon='icons/shirtdarkgreen.dmi'
			icon_state="hud"
			code=142
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightGrey
			icon='icons/shirtlightgrey.dmi'
			icon_state="hud"
			code=143
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightgrey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Grey
			icon='icons/shirtgrey.dmi'
			icon_state="hud"
			code=144
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Yellow
			icon='icons/shirtyellow.dmi'
			icon_state="hud"
			code=145
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/yellow
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	Bandage1
		armor="glasses"
		icon='icons/FaceBandage1.dmi'
		icon_state="gui"
		code=223
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="glasses")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.glasses=0
			else
				usr.glasses=/obj/Bandage/B1
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)
	Headband
		armor="face"
		verb
			Headband_Preferenes()
				switch(input2(usr,"How would you like to wear your headband?","Headband", list("Above my Hair","Under my Hair","Nevermind")))
					if("Above my Hair")
						usr.overband=0
						spawn()usr.Load_Overlays()
					if("Under my Hair")
						usr.overband=1
						spawn()usr.Load_Overlays()
		Blue
			icon='icons/gui.dmi'
			icon_state="konoha_headband"
			code=112
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="face")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.facearmor=0
				else
					usr.facearmor=/obj/headband/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Red
			icon='icons/gui.dmi'
			icon_state="konoha_headband"
			code=113
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="face")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.facearmor=0
				else
					usr.facearmor=/obj/headband/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Black
			icon='icons/gui.dmi'
			icon_state="konoha_headband"
			code=114
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="face")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.facearmor=0
				else
					usr.facearmor=/obj/headband/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

//	Kunai_m
//		icon='projectiles.dmi'
//		icon_state="kunai"
	verb/Get()
		set src in oview(1)
		new src.type(usr)

obj/items/weapons
	weapon=1

	Click()
		Use(usr)

	proc/Use(mob/u)

	verb/Get()
		set src in oview(1)
		Move(usr)

	projectile
		icon='icons/projectiles.dmi'
		itype="projectile2"

		Use(mob/u)
			usr=u
			var/equ=src.equipped
			usr.removeswords()

			for(var/obj/items/O in usr.contents)
				if(O.weapon)
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				src.equipped=0
				src.overlays=0
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

		Kunai_p
			icon_state="kunai"
			astate="kunai-m"
			accuracymod=50
			supplycost=1
			code=116
			woundmod=300
			nottossable=1

		Shuriken_p
			icon_state="shuriken"
			burst=3
			astate="shuriken-m"
			supplycost=1
			accuracymod=60
			code=146
			woundmod=100
			nottossable=3

		Needles_p
			icon_state="needles"
			astate="needle-m"
			code=117
			accuracymod=65
			burst=5
			woundmod=50
			supplycost=3
			nottossable=1

	melee
		knife
			itype="melee2"
			aspecial="knife"

			Kunai_Melee
				icon='icons/kunai_melee.dmi'
				icon_state="gui"
				code=215
				accuracymod=100
				woundmod=1
				cool=1
				Use(var/mob/u)
					var/equ=src.equipped
					usr=u
					usr.removeswords()
					for(var/obj/items/O in usr.contents)
						if(O.weapon)
							O.overlays=0
							O.equipped=0
							O.overlays+=O.macover
					if(!equ)
						src.equipped=1
						src.overlays+='icons/Equipped.dmi'
						usr.weapon=new/list

						usr.weapon+=/obj/kunai_melee

						usr.specialover="sword"
						usr.Load_Overlays()

		sword
			itype="melee"
			aspecial="sword"

			var/weapon_disp_types

			Use(var/mob/u)
				var/equ=src.equipped
				usr=u
				usr.removeswords()
				for(var/obj/items/O in usr.contents)
					if(O.weapon)
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(!equ)
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'
					usr.weapon=new/list
					usr.weapon+=src.weapon_disp_types

					usr.specialover="sword"
					usr.Load_Overlays()

			Bone_Sword
				icon='icons/gui.dmi'
				icon_state="bone_sword_item"
				accuracymod=45
				woundmod=5
				stamina_damage=25
				cool=1
				code=251
				weapon_disp_types = list(/obj/sword/b1, /obj/sword/b2, /obj/sword/b3, /obj/sword/b4)

			Sword
				icon='icons/projectiles.dmi'
				icon_state="sword"
				accuracymod=45
				woundmod=10
				stamina_damage=35
				cool=2
				code=216
				weapon_disp_types = list('sword1/swordover.dmi',/obj/sword/s1,/obj/sword/s2,/obj/sword/s3,/obj/sword/s4)

			ZSword
				icon='icons/projectiles.dmi'
				icon_state="zsword"
				accuracymod=25
				woundmod=25
				stamina_damage=50
				weapon=1
				code=217
				weight=50
				cool=4
				weapon_disp_types = list('icons/zabuza.dmi',/obj/sword/z1, /obj/sword/z2, /obj/sword/z3, /obj/sword/z4)

			HidanS
				icon='icons/projectiles.dmi'
				icon_state="HidanS"
				accuracymod=33
				woundmod=20
				stamina_damage=36
				weapon=1
				code=8888
				weight=20
				cool=2
				weapon_disp_types = list(/obj/sword/hid1, /obj/sword/hid2, /obj/sword/hid3, /obj/sword/hid4)

			Samehada
				name = "Samehada"
				icon='icons/projectiles.dmi'
				icon_state="Samehada"
				accuracymod=20
				woundmod=40
				stamina_damage=50
				weapon=1
				code=9999
				weight=50
				cool=3
				weapon_disp_types = list('icons/samehada.dmi',/obj/sword/sam1, /obj/sword/sam2, /obj/sword/sam3, /obj/sword/sam4)

			Big_Samehada
				name = "Restless Samehada"
				icon='icons/projectiles.dmi'
				icon_state="Big_Samehada"
				accuracymod=30
				woundmod=60
				stamina_damage=70
				weapon=1
				code=9375
				weight=10
				cool=2
				weapon_disp_types = list('icons/big_samehada.dmi',/obj/sword/big_sam1, /obj/sword/big_sam2, /obj/sword/big_sam3, /obj/sword/big_sam4)

			Hiramekarei
				icon='icons/projectiles.dmi'
				icon_state="Hiramekarei"
				accuracymod=40
				woundmod=15
				stamina_damage=35
				weapon=1
				code=2000003
				weight=40
				cool=3
				weapon_disp_types = list('icons/Hiramekarei/hiramekareioverlay.dmi',/obj/sword/H1,/obj/sword/H2,/obj/sword/H3,/obj/sword/H4)

			Kabutowari
				icon='icons/projectiles.dmi'
				icon_state="Kabutowari"
				accuracymod=75
				woundmod=25
				stamina_damage=34
				weapon=1
				code=2000004
				weight=50
				cool=4
				weapon_disp_types = list('icons/Kabutowari/kabutowarioverlay.dmi',/obj/sword/Ka1,/obj/sword/Ka2,/obj/sword/Ka3,/obj/sword/Ka4)

			Kiba
				icon='icons/projectiles.dmi'
				icon_state="Kiba"
				accuracymod=38
				woundmod=15
				stamina_damage=40
				weapon=1
				code=2000005
				weight=25
				cool=3
				weapon_disp_types = list('icons/Kiba/kibaoverlay.dmi',/obj/sword/Ki1,/obj/sword/Ki2,/obj/sword/Ki3,/obj/sword/Ki4)

			Nuibari
				icon='icons/projectiles.dmi'
				icon_state="Nuibari"
				accuracymod=90
				woundmod=10
				stamina_damage=25
				weapon=1
				code=2000006
				weight=10
				cool=2
				weapon_disp_types = list('icons/Nuibari/nuibarioverlay.dmi',/obj/sword/Nu1,/obj/sword/Nu2,/obj/sword/Nu3,/obj/sword/Nu4)

			Shibuki
				icon='icons/projectiles.dmi'
				icon_state="Shibuki"
				accuracymod=20
				woundmod=10
				stamina_damage=57
				weapon=1
				code=2000007
				weight=50
				cool=4
				weapon_disp_types = list('icons/Shibuki/shibukioverlay.dmi',/obj/sword/Sh1,/obj/sword/Sh2,/obj/sword/Sh3,/obj/sword/Sh4)

			SamuraiSword
				name = "Samurai Sword"
				icon='icons/projectiles.dmi'
				icon_state="samurai"
				accuracymod=35
				woundmod=10
				stamina_damage=50
				weapon=1
				code=12345
				weight=10
				cool=3
				weapon_disp_types = list('icons/samurai.dmi', /obj/sword/samurai1, /obj/sword/samurai2, /obj/sword/samurai3, /obj/sword/samurai4)

			Chakra_Blade
				icon='icons/projectiles.dmi'
				icon_state="chakra_blades"
				accuracymod=70
				woundmod=6
				stamina_damage=30
				weapon=1
				code=4754
				weight=1
				cool=1.5
				weapon_disp_types = list('icons/chakra_blades.dmi')

obj/items/var/equipped=0
obj/items/weapons
	var
		itype="projectile"
		astate=""
		woundmod=100
		stamina_damage=-1
		accuracymod=100
		supplycost=0
		cool=1
		aspecial=""
mob
	proc
		ShadowShuriken(dx,dy,dz)
			usr=src
			var/mob/dork=new/mob(locate(dx,dy,dz))
			dork.density=0
			dork.icon=null
			dork.overlays=null
			spawn(30)
				if(dork)
					del(dork)
			var/pass=1
			if(pass)
				var/ewoundmod=200
				var/eicon='icons/projectiles.dmi'
				var/estate="shuriken-m"

				flick("Throw2",usr)

				var/mob/human/etarget = usr.MainTarget()

				var/angle
				var/speed = 32
				var/spread = 3
				if(etarget)
					angle = get_real_angle(src, etarget)
				else
					angle = dir2angle(dir)

				var/r=round((ewoundmod-100)/75)

				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread*4, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread*3, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread*3, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread*4, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)

		Deque2(pass)
			src.overlays-=image('icons/sandshuriken.dmi',icon_state="sand")
			src.qued2=0
			if(pass)
				var/ewoundmod=200
				var/eicon='icons/sandshuriken.dmi'
				var/estate="shuriken"

				flick("Throw2",src)

				var/mob/human/etarget = MainTarget()

				var/angle
				var/speed = 32
				var/spread = 6
				if(etarget)
					angle = get_real_angle(src, etarget)
				else
					angle = dir2angle(dir)

				var/r=round((ewoundmod-100)/100)

				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))

		Deque(pass)
			src.overlays-=image('icons/advancing.dmi',icon_state="over")
			src.underlays-=image('icons/advancing.dmi',icon_state="under")
			src.qued=0
			if(pass)
				var/ewoundmod=200
				var/eicon='icons/projectiles.dmi'
				var/estate="kunai-m"

				flick("Throw2",usr)

				var/mob/human/etarget = usr.MainTarget()

				var/angle
				var/speed = 32
				var/spread = 6
				if(etarget)
					angle = get_real_angle(src, etarget)
				else
					angle = dir2angle(dir)

				var/r=round((ewoundmod-100)/100)

				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*4, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*3, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*3, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*4, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))


		RasenshurikenThrow(pass)
			src.overlays-=/obj/rasenshuriken
			src.overlays-=/obj/rasenshuriken2
			src.rasengan=0
			if(pass)
				var/conmult=round(src.con+src.conbuff-src.conneg)/100
				var/dx=usr.x
				var/dy=usr.y
				var/dz=usr.z
				flick("Throw2",usr)
				new/obj/rasenshuriken_projectile(src, dx, dy, dz, src.dir, conmult)

		WindShurikenThrow(pass)
			if(pass)
				var/conmult=round(src.con+src.conbuff-src.conneg)/100
				var/dx=usr.x
				var/dy=usr.y
				var/dz=usr.z
				flick("Throw1",usr)
				new/obj/wind_shuriken(src, dx, dy, dz, src.dir, conmult)


mob/verb
	usev()
		set name= "Use"
		set hidden=1
		if(usr.camo)
			usr.Affirm_Icon()
			usr.Load_Overlays()
			usr.camo=0
		if(usr.Size||usr.Tank)
			return
		if(usr.stunned||usr.handseal_stun||usr.kstun)
			return
		if(usr.qued)
			usr.Deque(1)
			return
		if(usr.qued2)
			usr.Deque2(1)
			return
		if(src.Transfered)
			return
		if(usr.incombo)
			return
		if(usr.usedelay>0||usr.stunned||usr.handseal_stun||usr.paralysed)
			return
		if(usr.move_stun)
			++usr.usedelay
		++usr.usedelay
		if(usr.larch)
			return
		if(usr.frozen)
			return
		//world<<"usr=[usr],[usr.pet],[usr.mane],[usr.canattack],[usr.pk],[usr.usedelay],[usr.stunned],[usr.paralysed]"
		if(usr.sleeping)
			return
		if(!usr.canattack)
			return
		if(usr.isguard)
			usr.icon_state=""
			usr.isguard=0
		if(usr.MainTarget()) usr.FaceTowards(usr.MainTarget())

		if(usr.rasengan==3)
			usr.RasenshurikenThrow(1)
			return

		if(usr.wind_shuriken)
			usr.WindShurikenThrow(1)
			return

		if(usr.pet)
			var/mob/human/etarget=usr.MainTarget()
			var/mob/human/pp=usr.Get_Sand_Pet()
			if(!pp)
				var/dunsomething=0
				if(etarget)
					for(var/mob/human/player/npc/kage_bunshin/X in oview(10,src))
						if(X.owner==usr)
							dunsomething=1
							if(etarget)
								spawn()X.Aggro(etarget)

				if(!dunsomething)
					goto cont
				else
					usr.combat("[usr]: Attack!!")
					return
			if(pp)
				if(etarget)
					pp:P_Attack(etarget,usr)
				else
					for(var/mob/human/q in get_step(pp,pp.dir))
						pp:P_Attack(q,usr)
				return
		cont
		if(usr.mane ||usr.canattack==0)
			return
		if(usr.pk==0)
			usr<<"this is a no pk zone!"
			return


		var/eicon
		var/estate
		var/etype
		var/ewoundmod
		var/eaccuracymod
		var/mob/etarget
		var/eburst
		var/esupplycost
		var/etypea
		var/estam
		for(var/obj/items/weapons/O in usr.contents)
			if(O.equipped==1&&O.weapon==1)
				eicon = O.icon
				estate = O.astate
				etype = O.itype
				ewoundmod = O.woundmod
				eaccuracymod = O.accuracymod
				esupplycost = O.supplycost
				usedelay = O.cool
				eburst = O.burst
				etypea = O.type
				estam = O.stamina_damage
				if(usr.clan == "Samurai")
					if(O.name=="ANBU Sword")
						O.cool = 1
					if(O.name=="Decapitator Sword")
						O.cool = 3
					if(O.name=="Samehada")
						O.cool = 3


		if(esupplycost>usr.supplies)
			return
		else
			usr.supplies-=esupplycost
			if(usr.supplies<=0)
				usr.supplies=0

		if(etype=="projectile2")
			flick("Throw1",usr)
			etarget = usr.MainTarget()
			if(!(etarget in oview(10)))
				etarget = null

			var/angle
			var/speed = 48
			var/spread = 9
			if(etarget) angle = get_real_angle(usr, etarget)
			else angle = dir2angle(usr.dir)

			spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=ewoundmod, wounds="passive")
			if(eburst>=3)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds="passive")
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds="passive")
			if(eburst>=5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=ewoundmod, wounds="passive")
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=ewoundmod, wounds="passive")

			return

		if(etype=="projectile")
			flick("Throw1",usr)
			etarget = usr.MainTarget()
			if(!(etarget in oview(10)))
				etarget = null
			if(etarget)

				var/r=rand(50,200)
				var/result=Roll_Against(usr.rfx+usr.rfxbuff-usr.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,(eaccuracymod*r)/100)
				if(result>=3)
					projectile_to(eicon,estate,usr,etarget)
				else
					projectile_to(eicon,estate,usr,locate(etarget.x,etarget.y,etarget.z))
				if(result==6)

					view(6)<<"[usr] Nailed [etarget] with a projectile"

					etarget.Wound(rand(3,10),0,usr)
					Blood2(etarget)
				if(result==5)
					view(6)<<"[usr] accurately hit [etarget] with a projectile"

					etarget.Wound(rand(1,5),0,usr)
					Blood2(etarget)
				if(result==4)
					view(6)<<"[usr] hit [etarget] dead on with a projectile"
					etarget.Wound(rand(0,1),0,usr)
				if(result==3)
					view(6)<<"[usr] partially hit [etarget] with a projectile"
				if(result>=3)

					etarget.Dec_Stam(ewoundmod/2,0,usr)
					etarget.Hostile(usr)
			else
				spawn()straight_proj(eicon,estate,usr,7,1,65,"a projectile",10,0)
				return
		if(etype=="melee2")//knife

			flick("w-attack",usr)
			var/mob/human/T = usr.NearestTarget()
			if(T)usr.FaceTowards(T)
			if(!(T in oview(1)))
				T = null
			if(!T)
				T=locate() in get_step(usr,usr.dir)
			if(T&&T.ko==0&&T.paralysed==0)
				flick("w-attack",usr)
				if(T.blocked==0)
					var/X = rand(1,(usr.rfx+usr.rfxbuff-usr.rfxneg))*100//attackroll
					var/x=rand(1,(T.rfx+T.rfxbuff-T.rfxneg))*100 //evaderoll


					var/damz=0
					var/woundz=0
					if(!T.icon_state)
						flick("hurt",T)
					damz=round((usr.rfx)*rand(10,14)/10)
					T.Dec_Stam(damz,0,usr)
					var/wound2=0
					if(prob(3*skillspassive[17]))
						wound2=pick(1,2,3,4)
						var/bleed=pick(2,4,6)
						spawn(10)
							while(bleed>0)
								bleed--
								sleep(15)
								if(T)
									T.Dec_Stam(100,0,usr)
									Blood2(T,usr)

					if(X>x)
						woundz=round(rand(ewoundmod/3,round(ewoundmod/1.5)))

						Blood2(T,usr)
					woundz+=wound2
					if(woundz)T.Wound(woundz,0,usr)

					usr.combat("[usr] hit [T] with a weapon for [damz] stamina damage and inflicting [woundz] wounds!")
				//	s_damage(T,damz,"#000000")

					spawn() if(T) T.Hostile(usr)
				else
					var/outcome3=Roll_Against(T.rfx+T.rfxbuff-T.rfxneg,usr.rfx+usr.rfxbuff-usr.rfxneg,100)
					if(outcome3>3)
						usr.stunned=2
						if(!T.icon_state)
							flick("hurt",usr)
				return

		if(etype=="melee")
			var/stuncut=1
			if(etypea==/obj/items/weapons/melee/sword/Bone_Sword)
				usr.boneuses--
				stuncut=2
			usr.stunned+=0.5/stuncut

			flick("w-attack",usr)
			var/mob/human/T = usr.NearestTarget()
			if(T)usr.FaceTowards(T)
			if(!(T in oview(1)))
				T = null
			if(!T)
				T=locate() in get_step(usr,usr.dir)
			if(T&&T.ko==0&&T.paralysed==0)
				flick("w-attack",usr)
				if(T.blocked==0)
					var/X = rand(1,(usr.rfx+usr.rfxbuff-usr.rfxneg))*eaccuracymod//attackroll
					var/x=rand(1,(T.rfx+T.rfxbuff-T.rfxneg))*100 //evaderoll

					if(etypea==/obj/items/weapons/melee/sword/HidanS)
						if(usr.clan == "Jashin")
							Blood2(T,usr)

					if(etypea==/obj/items/weapons/melee/sword/Big_Samehada)
						var/PO = rand(300, (usr.con*10))
						T.curchakra -= (PO * 0.50)
						usr.curchakra += (PO * 0.30)

					if(etypea==/obj/items/weapons/melee/sword/ZSword&&usr.clan=="Ruthless")
						if(prob(40))
							var/V = rand(1,6)
							T.Wound(V,0,usr)
							src.combat("You have taken [V] wounds from [usr]")

					if(etypea==/obj/items/weapons/melee/sword/Kiba)
						if(prob(30))
							flick('icons/electric_flick.dmi',T)
							T.stunned+=rand(1,2)

					if(etypea==/obj/items/weapons/melee/sword/Kabutowari)
						if(prob(30))
							var/extra_stam=rand(200,850)
							T.Dec_Stam(extra_stam,1,usr)
							spawn(5)
								if(T)
									usr.AppearBehind(T)
									flick("w-attack",usr)
									T.Dec_Stam(extra_stam*2,1,usr)
									Knockback(2,usr.dir)
								else return

					if(etypea==/obj/items/weapons/melee/sword/Nuibari)
						if(prob(40))
							var/Slice=rand(1,2)
							T.Wound(Slice,0,usr)
							Blood2(T,usr)
							if(prob(10))
								if(T) usr.AppearBefore(T)

					if(etypea==/obj/items/weapons/melee/sword/Hiramekarei)
						if(prob(20))
							var/Z=100*usr.ControlDamageMultiplier()
							T.curchakra-=Z

							T.Dec_Stam(Z,1,usr)

							if(usr.curchakra==usr.chakra)
								Knockback(3,usr.dir)
							if(usr.curchakra<=(usr.chakra/2))
								Knockback(2,usr.dir)
							if(usr.curchakra<=(usr.chakra/3))
								Knockback(1,usr.dir)

					if(etypea==/obj/items/weapons/melee/sword/Shibuki)
						if(prob(20))
							var/Explosive_Damage = (usr.rfx*T.rfx*usr.ControlDamageMultiplier()) / 100
							usr.protected=1
							spawn(10) usr.protected=0
							spawn()explosion(Explosive_Damage, T.x, T.y, T.z, usr, 0, 2)

					if(etypea==/obj/items/weapons/melee/sword/Samehada)
						var/PO = rand(100, usr.con)

						T.curchakra -= PO
						usr.curchakra += PO * 0.80
						usr.chakra_storage += PO

						var/obj/items/weapons/melee/sword/Big_Samehada/new_sword
						if(usr.chakra_storage>=3000&&!new_sword in usr.contents)
							new/obj/items/weapons/melee/sword/Big_Samehada(usr)
							usr.chakra_storage=0
							usr.combat("Your samehada has grown restless and has grown to a huge size")
							var/samehada_time=((usr.chakra_storage*usr.con)/usr.chakra)
							spawn()
								while(new_sword in usr.contents&&usr)
									sleep(10)
									samehada_time--
								if(samehada_time<=0)
									usr.combat("Your samehada has calmed down")
									del(new_sword in usr.contents)

						else if(usr.chakra_storage>=3000)
							usr.combat("I am sorry but you already have the ultimate samehada active")
							usr.chakra_storage=0

					if(etypea==/obj/items/weapons/melee/sword/Chakra_Blade)
						if(prob(50))
							if(usr.lastskill>=400&&usr.lastskill<=430)
								var/woundz = rand(0,2)
								var/damz = 60*usr:ControlDamageMultiplier()
								T.Wound(woundz,0,usr)
								T.Dec_Stam(damz,1,usr)
								flick('icons/earth_flick.dmi',T)
								src.combat("<font color=#663300>Earth Style Chakra Nature!</font>: [usr] hit [T] that dealt piercing of [damz] stamina damage and inflicting [woundz] wounds!")
						//		s_damage(T,damz,"#000000")
								usr.lastskill=0
							if(usr.lastskill>=100&&usr.lastskill<=120)
								var/burn = 20*usr:ControlDamageMultiplier()
								spawn()FireAOE(T.x,T.y,T.z,burn,10, usr, 0.2, 0)
								src.combat("<font color=#CC0000>Fire Style Chakra Nature!</font>: [usr] burned [T] for [burn] stamina damage!")
						//		s_damage(T,burn,"#000000")
								usr.lastskill=0
							if(usr.lastskill>=200&&usr.lastskill<=250)
								var/PO = rand(50, usr.con/2)
								T.curchakra -= PO
								usr.curchakra += PO * 0.80
								src.combat("<font color=#3366CC>Water Style Chakra Nature!</font>: [usr] drained [T]'s chakra for [PO] chakra!")
								usr.lastskill=0
							if(usr.lastskill>=500&&usr.lastskill<=510)
								var/Stun = rand(1,2)
								T.stunned=Stun
								flick('icons/electric_flick.dmi',T)
								src.combat("<font color=#00CCCC>Lightning Style Chakra Nature!</font>: [usr] stunned [T] for [Stun] seconds!")
								usr.lastskill=0
							if(usr.lastskill>=300&&usr.lastskill<=310)
								var/dam = 100*usr:ControlDamageMultiplier()
								for(var/mob/human/player/xyz in oview(2,usr))
									xyz.Dec_Stam(dam,1,usr)
									Blood2(xyz,usr)
									if(prob(30))
										xyz.stunned=1
								T.Dec_Stam(dam,1,usr)
								Blood2(T,usr)
								if(prob(15))
									T.stunned=1
								src.combat("<font color=#33CC00>Wind Style Chakra Nature!</font>: [usr] hit [T] for [dam] stamina damage and [dam] stamina damage to anyone nearby!")
						//		s_damage(T,dam,"#000000")
								usr.lastskill=0

					var/damz=0
					var/woundz=0
					if(!T.icon_state)
						flick("hurt",T)

					damz+=round((usr.rfx)*rand(1,estam)/10)
					if(usr.skillspassive[18])
						damz*=1 + 0.03*usr.skillspassive[18]
					T.Dec_Stam(damz,0,usr)
					var/wound2=0
					if(prob(3*skillspassive[17]))
						wound2=pick(1,2,3,4)
						var/bleed=pick(2,4,6)
						spawn(10)
							while(bleed>0)
								bleed--
								sleep(15)
								if(T)
									T.Dec_Stam(100,0,usr)
									Blood2(T,usr)
					if(X>x)//hit
						woundz=round(0.5*(rand(ewoundmod/3,round(ewoundmod/1.5))))

						Blood2(T,usr)
					woundz+=wound2
					if(woundz)T.Wound(woundz,0,usr)
					usr.combat("[usr] hit [T] with a weapon for [damz] stamina damage and inflicting [woundz] wounds!")
				//	s_damage(T,damz,"#000000")

					spawn() if(T && usr) T.Hostile(usr)
				else
					var/outcome3=Roll_Against(T.rfx+T.rfxbuff-T.rfxneg,usr.rfx+usr.rfxbuff-usr.rfxneg,100)
					if(outcome3>3)
						usr.stunned=2
						if(!T.icon_state)
							flick("hurt",usr)
				return

obj/projc
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)
obj/needle
	icon='icons/projectiles.dmi'
	icon_state="needle-m"
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)
obj/fireball
	icon='icons/fireball.dmi'
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)
obj
	var
		xvel=0
		yvel=0
		beenclashed=0
		mot=0
		projdisturber=0
obj/projectile
	landed(atom/movable/O,pow,wnd,daze)
		..()

		if(src.landed)
			return
		src.landed=1
		if(!O)
			if(src.icon=='icons/projectiles.dmi')
				if(src.icon_state=="shuriken-m")src.icon_state=pick("shuriken-m-clashed1","shuriken-m-clashed2","shuriken-m-clashed3") //sets the projectile to its landed in a turf icon state
				if(src.icon_state=="needle-m")src.icon_state=pick("needle-m-clashed1","needle-m-clashed2","needle-m-clashed3")
				if(src.icon_state=="kunai-m")src.icon_state=pick("kunai-m-clashed1","kunai-m-clashed2","kunai-m-clashed3")
				if(src.icon_state=="knife-m")src.icon_state="knife-m-clashed1"
				if(src.icon_state=="windmill-m")src.icon_state="windmill-m-clashed1"
			else
				src.icon=null
				src.overlays=null

			src.landed=2

			sleep(50)
			src.loc=null  //go away invisible
		if(istype(O,/mob/human))
			var/mob/human/Oc=O
			if(daze&& prob(daze))
				Oc.icon_state="hurt"
				var/dazed=3
				Oc.stunned=round(dazed,0.1)

				spawn() Oc.Graphiked('icons/dazed.dmi')

			Oc.Dec_Stam(pow,0,src.powner)  //hurt the player it hits = the power variable
			if(wnd)
				Blood(O.x,O.y,O.z)  //ew blood
				Oc.Wound(wnd,0,src.powner)


			Oc.Hostile(src.powner)
			src.loc=null  //go away invisible
		if(istype(O,/obj/projectile))
			var/obj/projectile/Oc=O
			if(Oc.landed!=2)  //dont clash with projectiles that are sticking in turfs!
				Clash(O,src) //clash O and src together
proc
	advancedprojectile_angle(icon, icon_state, mob/user, speed, angle, distance, damage, wounds=0, daze=0, radius=8, atom/from=user)
		if(!from || !speed)
			return

		if(wounds=="passive")
			if(user && user.skillspassive[14] && prob(5*user.skillspassive[14]))
				wounds=pick(1,2,3,4)
			else
				wounds=0

		if(!isnum(wounds))
			wounds = 0

		var/obj/projectile/p = new /obj/projectile(from.loc)
		p.icon = icon
		p.icon_state = icon_state

		p.owner = user
		p.radius = radius

		var/extra_list = list()
		if(wounds)
			extra_list["Wound"] = wounds
		if(daze)
			extra_list["Daze"] = daze

		M_Projectile_Degree(p, user, damage, (distance*32)/speed, speed, angle, extra_list)

	advancedprojectilen(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,mob/trueowner,radius)
		if(wnd=="passive")
			if(trueowner&& trueowner.skillspassive[14]&& prob(5*trueowner.skillspassive[14]))
				wnd=pick(1,2,3,4)
			else
				wnd=0
		if(!isnum(wnd))wnd=0
		if(!efrom)
			return
		var/obj/projectile/p = new/obj/projectile(locate(efrom.x,efrom.y,efrom.z))

		p.icon=i
		p.icon_state=estate
		if(radius)p.radius=radius
		else p.radius=8
		if(trueowner)efrom=trueowner
		p.powner=efrom
		var/speed = sqrt(xvel*xvel+yvel*yvel)
		if((!xvel && !yvel )|| speed ==0)
			del(p)
			return
		M_Projectile(p,efrom,damage,xvel,yvel,(distance*32) / speed,list("Wound"=wnd))
		return

	advancedprojectile(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,mob/trueowner,radius)
		var/obj/projectile/p = new/obj/projectile(locate(efrom.x,efrom.y,efrom.z))
		p.icon=i
		p.powner=efrom
		p.icon_state=estate
		if(radius)p.radius=radius
		else p.radius=8
		M_Projectile(p,efrom,damage,xvel,yvel,(distance * 32)/sqrt(xvel*xvel+yvel*yvel),list("Wound"=wnd))
		return

proc
	advancedprojectile_ramped(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,daze,radius)//daze as percent/100
		var/obj/projectile/p = new/obj/projectile(locate(efrom.x,efrom.y,efrom.z))
		p.icon=i
		p.powner=efrom
		p.icon_state=estate
		if(radius)p.radius=radius
		else if(pwn) p.radius=16
		else p.radius=8

		M_Projectile(p,efrom,damage,xvel,yvel,(distance * 32)/sqrt(xvel*xvel+yvel*yvel),list("Wound"=wnd,"Daze"=daze))

	advancedprojectile_returnloc(xtype,mob/efrom,xvel,yvel,distance,vel,dx,dy,dz)
		var/obj/p = new xtype(locate(dx,dy,dz))
		var/horiz=0
		var/vertic=0
		if(abs(xvel)>abs(2*yvel))
			horiz=1
		else if(abs(yvel)>abs(2*xvel))
			vertic=1
		if(!horiz&&!vertic)
			if(xvel>0 && yvel>0)
				p.dir=NORTHEAST
			if(xvel<0 && yvel>0)
				p.dir=NORTHWEST
			if(xvel>0 && yvel<0)
				p.dir=SOUTHEAST
			if(xvel<0 && yvel<0)
				p.dir=SOUTHWEST
		if(horiz)
			if(xvel>0)
				p.dir=EAST
			else
				p.dir=WEST
		if(vertic)
			if(yvel>0)
				p.dir=NORTH
			else
				p.dir=SOUTH
		p.owner=efrom
		p.xvel=xvel*vel/100
		p.yvel=yvel*vel/100
		p.beenclashed=0

		p.mot=distance
		sleep(3)
	//	walk_to(p,eto,0,1)
		while(p.mot>0&&p)
			if(p.mot<=1)
				p.icon=0
				var/xmod=0
				while(p.pixel_x>32)
					p.pixel_x-=32
					xmod++
				while(p.pixel_x<-32)
					p.pixel_x+=32
					xmod--
				var/ymod=0
				while(p.pixel_y>32)
					p.pixel_y-=32
					ymod++
				while(p.pixel_y<-32)
					p.pixel_y+=32
					ymod--
				var/ploc=locate(p.x+xmod,p.y+ymod,p.z)
				del(p)
				return ploc

			if(!p.beenclashed)
				p.pixel_x+=xvel/2
				p.pixel_y+=yvel/2

			if(p.pixel_x>=32)

				var/pass=1
				var/turf/x=locate(p.x+1,p.y,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x+1,p.y,p.z)
				//	spawn()if(p)p.pixel_x-=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc

			if(p.pixel_x<=-32)

				var/pass=1
				var/turf/x =locate(p.x-1,p.y,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x-1,p.y,p.z)
				//	spawn()if(p)p.pixel_x+=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
			if(p.pixel_y>=32)

				var/pass=1
				var/turf/x=locate(p.x,p.y+1,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x,p.y+1,p.z)
				//	spawn()if(p)p.pixel_y-=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
			if(p.pixel_y<=-32)
				var/pass=1
				var/turf/x= locate(p.x,p.y-1,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x,p.y-1,p.z)
				//	spawn()if(p)p.pixel_y+=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
			for(var/mob/human/m in oview(1,p))
				if(m!=efrom)
					p.icon=0
					if(!m.icon_state)
						flick("hurt",m)
					p.mot=0
					var/ploc=m.loc
					del(p)
					return ploc
			for(var/obj/projc/m in oview(0,p))
				if(m.owner!=p.owner&&m.beenclashed==0&&p.beenclashed==0)

					m.xvel=p.xvel*rand(60,140)/100
					m.yvel=p.xvel*rand(60,140)/100
					m.mot=m.mot/3
					m.beenclashed=1

					var/er=rand(1,3)

					m.icon_state="[m.icon_state]-clashed[er]"
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
					//clang
			sleep(1)
			if(p)
				p.mot--

		sleep(5)
		if(p)
			p.mot=0

proc
	projectile_to(i,estate,mob/efrom,atom/eto)
		if(!(efrom&&eto))return
		var/obj/p
		if(efrom)p = new/obj/proj(locate(efrom.x,efrom.y,efrom.z))
		if(p)
			p.icon=i
			p.icon_state=estate
			if(p.icon=='icons/Shukaku spear.dmi')
				p.overlays+=image('icons/Shukaku spear.dmi',icon_state="0,1",pixel_x=-16,pixel_y=16)
				p.overlays+=image('icons/Shukaku spear.dmi',icon_state="1,1",pixel_x=16,pixel_y=16)
				p.overlays+=image('icons/Shukaku spear.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16)
				p.overlays+=image('icons/Shukaku spear.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16)
				p.icon=null
				p.icon_state=null
			if(p.icon=='icons/GoukikikiHead.dmi')
				p.overlays+=image('icons/GoukikikiHead.dmi',icon_state="0,1",pixel_x=-16,pixel_y=16)
				p.overlays+=image('icons/GoukikikiHead.dmi',icon_state="1,1",pixel_x=16,pixel_y=16)
				p.overlays+=image('icons/GoukikikiHead.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16)
				p.overlays+=image('icons/GoukikikiHead.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16)
				p.icon=null
				p.icon_state=null
			if(p.icon=='icons/Dragon_Bullet.dmi')
				p.overlays+=image('icons/Dragon_Bullet.dmi',icon_state="0,1",pixel_x=-16,pixel_y=16)
				p.overlays+=image('icons/Dragon_Bullet.dmi',icon_state="1,1",pixel_x=16,pixel_y=16)
				p.overlays+=image('icons/Dragon_Bullet.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16)
				p.overlays+=image('icons/Dragon_Bullet.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16)
				p.icon=null
				p.icon_state=null
			sleep(1)
			if(p && eto)walk_to(p,eto,0,1)
			while(p&&eto&&(p.x!=eto.x ||p.y!=eto.y))
				sleep(1)
			if(eto&&istype(eto,/mob/human))
				if(!eto.icon_state)
					flick("hurt",eto)
			sleep(5)
			del(p)
proc
	projectile_to2(type,mob/efrom,atom/eto)
		var/obj/p = new type(locate(efrom.x,efrom.y,efrom.z))

		sleep(1)
		walk_to(p,eto,0,1)
		while(p.x!=eto.x ||p.y!=eto.y)
			sleep(1)
		if(istype(eto,/mob/human))
			if(!eto.icon_state)
				flick("hurt",eto)
		sleep(5)
		del(p)

obj/proj
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)


proc
	straight_proj4(eicon,estate,dist,mob/human/u,dx,dy,dz)
		var/obj/proj/M = new/obj/proj(locate(dx,dy,dz))
		M.icon=eicon
		M.icon_state=estate
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					sleep(1)
					del(M)
					return hit
			else if(!u)
				del(M)
				return


		sleep(2)
		del(M)
	straight_proj3(type,dist,mob/human/u)

		var/obj/M = new type(locate(u.x,u.y,u.z))
		spawn(20)
			if(M)
				del(M)
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					sleep(1)
					del(M)
					return hit
			else if(!u)
				del(M)
				return


		sleep(2)
	straight_proj2(eicon,estate,dist,mob/human/u)
		var/obj/proj/M = new/obj/proj(locate(u.x,u.y,u.z))
		M.icon=eicon
		M.icon_state=estate
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					sleep(1)
					del(M)
					return hit
			else if(!u)
				del(M)
				return


		sleep(2)
		del(M)
	straight_proj(eicon,estate,mob/human/u,dist,espeed,epower,ename,maxwound,minwound)
		var/obj/proj/M = new/obj/proj(locate(u.x,u.y,u.z))
		M.icon=eicon
		M.icon_state=estate
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					var/r=rand(100,200)
					var/result=Roll_Against(usr.rfx+usr.rfxbuff-usr.rfxneg,hit.rfx+hit.rfxbuff-hit.rfxneg,r)
					if(result==6)

						view(6)<<"[usr] Nailed [hit] with [ename]"

						hit.Wound(rand(minwound+3,maxwound),0,u)
						Blood2(hit)
					if(result==5)
						view(6)<<"[usr] accurately hit [hit] with [ename]"

						hit.Wound(rand(minwound+1,maxwound/2),0,u)
						Blood2(hit)
					if(result==4)
						view(6)<<"[usr] hit [hit] dead on with [ename]"

						hit.Wound(rand(minwound,minwound+1),0,u)

					if(result==3)
						view(6)<<"[usr] partially hit [hit] with [ename]"
					if(result>=3)
						hit.Dec_Stam(epower,0,u)
						if(u)
							spawn()hit.Hostile(u)
					sleep(1)
					del(M)
			else if(!u)
				del(M)
				return
		sleep(2)
		del(M)

proc/Gethairicon(i)
	var/h1i
	switch(i)
		if(1)
			h1i='icons/hair1.dmi'

		if(2)
			h1i='icons/hair2.dmi'

		if(3)
			h1i='icons/hair3.dmi'
		if(4)
			h1i='icons/hair4.dmi'
		if(5)
			h1i='icons/hair5.dmi'
		if(6)
			h1i='icons/hair6.dmi'
		if(7)
			h1i='icons/hair7.dmi'
		if(8)
			h1i='icons/hair8.dmi'
		if(9)
			h1i='icons/hair9.dmi'
		if(10)
			h1i='icons/hair10.dmi'
		if(11)
			h1i='icons/hair11.dmi'
		if(12)
			h1i='icons/hair12.dmi'
		if(13)
			h1i='icons/hair13.dmi'
		if(14)
			h1i='icons/hair14.dmi'
		if(15)
			h1i='icons/hair15.dmi'
		if(16)
			h1i='icons/hair16.dmi'
		if(17)
			h1i='icons/hair17.dmi'
		if(18)
			h1i='icons/hair18.dmi'
		if(19)
			h1i='icons/hair19.dmi'
		if(20)
			h1i='icons/hair20.dmi'
		if(21)
			h1i='icons/hair21.dmi'
		if(22)
			h1i='icons/hair22.dmi'
		if(23)
			h1i='icons/hair23.dmi'
		if(24)
			h1i='icons/hair24.dmi'
		if(25)
			h1i='icons/hair25.dmi'
		if(26)
			h1i='icons/hair26.dmi'
	return h1i
//overlay handling

mob/proc

	Load_Overlays()
		set background = 1
		if(src.Size||src.Tank)
			return
		sleep(-1)
		if(!EN[15])
			return
		src.underlays=0
		var/L[0]
		var/icon/h1i


		switch(src.hair_type)
			if(1)
				h1i=new('icons/hair1.dmi')
			if(2)
				h1i=new('icons/hair2.dmi')
			if(3)
				h1i=new('icons/hair3.dmi')
			if(4)
				h1i=new('icons/hair4.dmi')
			if(5)
				h1i=new('icons/hair5.dmi')
			if(6)
				h1i=new('icons/hair6.dmi')
			if(7)
				h1i=new('icons/hair7.dmi')
			if(8)
				h1i=new('icons/hair8.dmi')
			if(9)
				h1i=new('icons/hair9.dmi')
			if(10)
				h1i=new('icons/hair10.dmi')
			if(11)
				h1i=new('icons/hair11.dmi')
			if(12)
				h1i=new('icons/hair12.dmi')
			if(13)
				h1i=new('icons/hair13.dmi')
			if(14)
				h1i=new('icons/hair14.dmi')
			if(15)
				h1i=new('icons/hair15.dmi')
			if(16)
				h1i=new('icons/hair16.dmi')
			if(17)
				h1i=new('icons/hair17.dmi')
			if(18)
				h1i=new('icons/hair18.dmi')
			if(19)
				h1i=new('icons/hair19.dmi')
			if(20)
				h1i=new('icons/hair20.dmi')
			if(21)
				h1i=new('icons/hair21.dmi')
			if(22)
				h1i=new('icons/hair22.dmi')
			if(23)
				h1i=new('icons/hair23.dmi')
			if(24)
				h1i=new('icons/hair24.dmi')
			if(25)
				h1i=new('icons/hair25.dmi')
			if(26)
				h1i=new('icons/hair26.dmi')


		if(h1i)

			if(EN[1])h1i.Blend(src.hair_color)
			var/icon/h2i
			if(src.hair_type==11)
				h2i=new('icons/hair11o.dmi')
				if(EN[1])h2i.Blend(src.hair_color)

			var/image/h1
			var/pixy=0
			if(src.hair_type==11)
				pixy=2
			var/h2
			if(overband)
				h1=image(h1i,layer=FLOAT_LAYER-1,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-1)

			else
				h1=image(h1i,layer=FLOAT_LAYER-2,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-2)
			L+= h1
			if(h2)
				L+=h2
		if(special)L+=special
		if(undershirt) L+=undershirt
		if(pants) L+=pants
		if(overshirt) L+=overshirt
		if(shoes)L+=shoes
		if(legarmor) L+=legarmor
		if(armor)L+=armor
		if(armarmor)L+=armarmor
		if(armarmor2)L+=armarmor2
		if(glasses)L+=glasses
		if(facearmor)L+=facearmor
		if(cloak)L+=cloak
		if(sholder)L+=sholder
		if(back)L+=back
		if(weapon)L+=weapon
		if(src.gate>=1)
			L+=image('icons/gatepower.dmi',layer=FLOAT_LAYER)
		if(src.pill>=2)
			L+=image('icons/Chakra_Shroud.dmi',layer=FLOAT_LAYER)
		if(shukaku_cloak)
			L+=image('icons/Shukaku_Cloak.dmi',layer=FLOAT_LAYER-13)
		if(beast_mode)
			L+=image('icons/BeastMode.dmi',layer=FLOAT_LAYER-13)
		if(src.pill>=3)
			L+=image('icons/Butterfly Aura.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16,layer=FLOAT_LAYER)
			L+=image('icons/Butterfly Aura.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16,layer=FLOAT_LAYER)
			L+=image('icons/Butterfly Aura.dmi',icon_state="0,1",pixel_x=-17,pixel_y=17,layer=FLOAT_LAYER)
			L+=image('icons/Butterfly Aura.dmi',icon_state="1,1",pixel_x=17,pixel_y=17,layer=FLOAT_LAYER)
		if(src.bonedrill)
			L+=image('icons/bone_drill.dmi',layer=FLOAT_LAYER)
			L+=image('icons/bone_drill_N.dmi',layer=FLOAT_LAYER,pixel_y=32)
			L+=image('icons/bone_drill_S.dmi',layer=FLOAT_LAYER,pixel_y=-32)
			L+=image('icons/bone_drill_E.dmi',layer=FLOAT_LAYER,pixel_x=32)
			L+=image('icons/bone_drill_W.dmi',layer=FLOAT_LAYER,pixel_x=-32)
		if(capture_the_flag && capture_the_flag.GetTeam(src) != "None" && capture_the_flag.status != "Registration")
			var/i
			if(capture_the_flag.GetTeam(src) == "Red")
				i = 'icons/shirt_sleeves/shirt_sleevesdred.dmi'
			else
				i = 'icons/shirt_sleeves/shirt_sleevesdblue.dmi'

			L += image(i,layer=FLOAT_LAYER+5)

			if(capture_the_flag.HasFlag(src))
				L += image('icons/ctf.dmi', icon_state = "P[capture_the_flag.GetTeam(src)]",layer = 99999)
		src.hassword=0
		for(var/obj/items/weapons/O in src.contents)
			if(O.equipped==1&&O.weapon==1 && O.itype=="melee")
				src.hassword=1
		src.overlays=L



	completeLoad_Overlays(alph,scale)
		set background = 1
		sleep(-1)
		if(!EN[15])
			return
		usr.underlays=0
		var/L[0]
		var/icon/h1i


		switch(src.hair_type)
			if(1)
				h1i=new('icons/hair1.dmi')
			if(2)
				h1i=new('icons/hair2.dmi')
			if(3)
				h1i=new('icons/hair3.dmi')
			if(4)
				h1i=new('icons/hair4.dmi')
			if(5)
				h1i=new('icons/hair5.dmi')
			if(6)
				h1i=new('icons/hair6.dmi')
			if(7)
				h1i=new('icons/hair7.dmi')
			if(8)
				h1i=new('icons/hair8.dmi')
			if(9)
				h1i=new('icons/hair9.dmi')
			if(10)
				h1i=new('icons/hair10.dmi')
			if(11)
				h1i=new('icons/hair11.dmi')
			if(12)
				h1i=new('icons/hair12.dmi')
			if(13)
				h1i=new('icons/hair13.dmi')
			if(14)
				h1i=new('icons/hair14.dmi')
			if(15)
				h1i=new('icons/hair15.dmi')
			if(16)
				h1i=new('icons/hair16.dmi')
			if(17)
				h1i=new('icons/hair17.dmi')
			if(18)
				h1i=new('icons/hair18.dmi')
			if(19)
				h1i=new('icons/hair19.dmi')
			if(20)
				h1i=new('icons/hair20.dmi')
			if(21)
				h1i=new('icons/hair21.dmi')
			if(22)
				h1i=new('icons/hair22.dmi')
			if(23)
				h1i=new('icons/hair23.dmi')
			if(24)
				h1i=new('icons/hair24.dmi')
			if(25)
				h1i=new('icons/hair25.dmi')
			if(26)
				h1i=new('icons/hair26.dmi')


		if(h1i)

			if(EN[1])h1i.Blend(src.hair_color)
			var/icon/h2i
			if(src.hair_type==11)
				h2i=new('icons/hair11o.dmi')
				if(EN[1])h2i.Blend(src.hair_color)

			var/image/h1
			var/pixy=0
			if(src.hair_type==11)
				pixy=2
			var/h2
			if(overband)
				h1=image(h1i,layer=FLOAT_LAYER-1,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-1)

			else
				h1=image(h1i,layer=FLOAT_LAYER-2,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-2)
			L+= h1
			if(h2)
				L+=h2
		if(special)L+=special
		if(undershirt) L+=undershirt
		if(pants) L+=pants
		if(overshirt) L+=overshirt
		if(shoes)L+=shoes
		if(legarmor) L+=legarmor
		if(armor)L+=armor
		if(armarmor)L+=armarmor
		if(glasses)L+=glasses
		if(facearmor)L+=facearmor
		if(cloak)L+=cloak
		if(back)L+=back
		if(weapon)L+=weapon
		if(src.gate>=1)
			L+=image('icons/gatepower.dmi',layer=FLOAT_LAYER)
		var/Q[0]

		if(alph || scale)
			for(var/X in L)
				if(istype(X,/image))
					var/image/Z=X

					var/icon/E = new(Z.icon)
					if(alph)
						E.MapColors(1,0,0, 0, 0,1,0, 0, 0,0,1, 0, 0, 0, 0, alph, 0, 0, 0, 0)
					if(scale)
						E.Scale(scale,scale)
					Z.icon=E
					Q+=Z
				else

					var/obj/r = new X
					var/icon/E=new(r.icon)
					if(alph)
						E.MapColors(1,0,0, 0, 0,1,0, 0, 0,0,1, 0, 0, 0, 0, alph, 0, 0, 0, 0)
					if(scale)
						E.Scale(scale,scale)
					del(r)
					Q+=E



			src.overlays=Q
		else
			src.overlays=L
obj/var
	burst=1