mob/var/obj/armarmor2
mob/var/obj/sholder
mob/proc/EQUIP(cat,ref)
	switch(cat)
		if("special")
			src.special=ref
		if("undershirt")
			src.undershirt=ref
		if("pants")
			src.pants=ref
		if("overshirt")
			src.overshirt=ref
		if("shoes")
			src.shoes=ref
		if("legarmor")
			src.legarmor=ref
		if("armor")
			src.armor=ref
		if("armarmor")
			src.armarmor=ref
		if("armarmor2")
			src.armarmor2=ref
		if("glasses")
			src.glasses=ref
		if("facearmor")
			src.facearmor=ref
		if("cloak")
			src.cloak=ref
		if("back")
			src.back=ref
		if("weapon")
			src.weapon=ref
		if("sholder"||"sholders")
			src.sholder=ref
	src.rfxneg-=src.hindrance
	src.hindrance=0
	src.AC=50
	for(var/obj/items/O in src.contents)
		if(O.equipped)
			src.hindrance+=(O.hind/100)*src.rfx
			src.AC+=O.acmod
	src.rfxneg+=src.hindrance

mob/var/hindrance=0

obj/items/equipable
	New()
		..()
		var/d
		if(src.acmod)
			d+="AC-mod=[acmod] "
		if(src.hind)
			d+="Rfx-Hinderance=[hind]% "
		if(src.namemod)
			d+="Name-Modifier=[namemod] "
		if(d)src.desc=d

obj/items/equipable/newsys
	icon_state="gui"

	proc/Use(var/mob/u)
		set hidden=1
		set category=null
		var/equ=src.equipped
		usr=u
		for(var/obj/items/O in usr.contents)
			if(O.armor==src.cat||O.cat==src.cat)
				O.overlays=0
				O.equipped=0
				O.overlays+=O.macover
		if(equ)
		//	if(src.namemod)
		//		usr.name=usr.realname
			usr.EQUIP(cat,0)

		else
		//	if(src.namemod)
			//	usr.name=src.namemod
			src.equipped=1
			usr.EQUIP(cat,itm)

			src.overlays+='icons/Equipped.dmi'

		usr.Load_Overlays()
	Click()
		Use(usr)


