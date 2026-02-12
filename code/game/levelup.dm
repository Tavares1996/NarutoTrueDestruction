mob/human/var/tmp
	_img_str_cache
	_img_con_cache
	_img_int_cache
	_img_rfx_cache
	_img_levelpoints_cache
	_img_skillpoints_cache

mob/human/proc/Refresh_Stat_Screen()
	if(!EN[9])
		return
	if(!src)
		return
	if(!client)
		return
	if(_img_str_cache != round(str))
		_img_str_cache = round(str)
		winset(usr, "str", "text=\"[round(str)]\"")
	if(_img_con_cache != round(con))
		_img_con_cache = round(con)
		winset(usr, "con", "text=\"[round(con)]\"")
	if(_img_int_cache != round(int))
		_img_int_cache = round(int)
		winset(usr, "int", "text=\"[round(int)]\"")
	if(_img_rfx_cache != round(rfx))
		_img_rfx_cache = round(rfx)
		winset(usr, "rfx", "text=\"[round(rfx)]\"")

mob/human/proc/Refresh_Skillpoints()
	if(_img_skillpoints_cache != skillpoints)
		del src.Screen_Num[2]
		del src.Screen_Num[3]
		del src.Screen_Num[4]
		del src.Screen_Num[5]
		var/turf/over_loc = locate_tag("maptag_skilltree_skillpoints_clan")
		Screen_Num[2]=DisplayNumberO(over_loc.x,over_loc.y,over_loc.z,skillpoints,"skillpoints")
		over_loc = locate_tag("maptag_skilltree_skillpoints_nonclan")
		Screen_Num[3]=DisplayNumberO(over_loc.x,over_loc.y,over_loc.z,skillpoints,"skillpoints")
		over_loc = locate_tag("maptag_skilltree_skillpoints_element")
		Screen_Num[4]=DisplayNumberO(over_loc.x,over_loc.y,over_loc.z,skillpoints,"skillpoints")
		over_loc = locate_tag("maptag_skilltree_skillpoints_x")
		Screen_Num[5]=DisplayNumberO(over_loc.x,over_loc.y,over_loc.z,skillpoints,"skillpoints")
		_img_skillpoints_cache = skillpoints

image/var
	group=0
mob/var/jashinfix=0

mob/human/proc/Level_Up(S)
	if(clan == "Jashin")
		src.skillpoints+=40
		if(S == "int") src.skillpoints+=50
	else if(src.Membership||src.Membership_2_Month)
		src.skillpoints+=65
		if(clan == "Genius")
			if(S == "int") src.skillpoints+=75
		else
			if(S == "int") src.skillpoints+=45
	else if(clan == "Genius")
		src.skillpoints+=55
		if(S == "int") src.skillpoints+=60
	else
		src.skillpoints+=45
		if(S == "int") src.skillpoints+=35

	if(!(levelpoints % 6))
		var/strb=round(src.str/10)
		var/rfxb=round(src.rfx/10)
		var/intb=round(src.int/10)
		var/conb=round(src.con/10)

		++str
		++rfx
		++int
		++con

		var/strc=round(src.str/10)
		var/rfxc=round(src.rfx/10)
		var/intc=round(src.int/10)
		var/conc=round(src.con/10)

		if(strb!=strc)
			src.skillspassive[25]+=1
		if(rfxb!=rfxc)
			src.skillspassive[26]+=1
		if(intb!=intc)
			src.skillspassive[27]+=1
		if(conb!=conc)
			src.skillspassive[28]+=1

	src.Refresh_Stat_Screen()

mob/var/list/Screen_Num[10]
mob/proc/DisplayNumber(dx,dy,dz,num,group)
	if(num>999999)
		num=999999
	var/string=num2text(round(num),7)

	var/image/d1


	if(length(string)>=1)
		d1=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,length(string),length(string)+1)]",pixel_x=0)
		src<<d1
		src.Imgs+=d1
		d1.group=group
	if(length(string)>=2)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-1),(length(string)))]",pixel_x=-6)
	if(length(string)>=3)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-2),(length(string)-1))]",pixel_x=-12)
	if(length(string)>=4)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-3),(length(string)-2))]",pixel_x=-18)
	if(length(string)>=5)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-4),(length(string)-3))]",pixel_x=-24)
	if(length(string)>=6)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-5),(length(string)-4))]",pixel_x=-30)
	return d1
mob/proc/DisplayNumberO(dx,dy,dz,num,group)
	if(num>999999)
		num=999999
	var/string=num2text(round(num),7)

	var/image/d1


	if(length(string)>=1)
		d1=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,length(string),length(string)+1)]")
		src<<d1
		src.Imgs+=d1
		d1.group=group
	if(length(string)>=2)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-1),(length(string)))]",pixel_x=-12)
	if(length(string)>=3)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-2),(length(string)-1))]",pixel_x=-24)
	if(length(string)>=4)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-3),(length(string)-2))]",pixel_x=-36)
	if(length(string)>=5)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-4),(length(string)-3))]",pixel_x=-48)
	if(length(string)>=6)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-5),(length(string)-4))]",pixel_x=-60)
	return d1

obj/digit
	icon='icons/0numbers.dmi'