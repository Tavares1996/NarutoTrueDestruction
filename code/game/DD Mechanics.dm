//Dont use this
		src.mob.keys = "north"
		spawn(1) src.mob.keys = null
		src.mob.keys = "east"
		spawn(1) src.mob.keys = null
		src.mob.keys = "west"
		spawn(1) src.mob.keys = null
		src.mob.keys = "south"
		spawn(1) src.mob.keys = null

mob/verb
	Dash_Activation()
		if(!src.dash_active)
			src << "<u><font color = green>Double Dash has been activated!</u>/font>"
			src.dash_active = TRUE
		else if(src.dash_active)
			src << "<u><font color = red>Double Dash has been deactivated!</u>/font>"
			src.dash_active = FALSE

mob/var
	//Activation Variable
	dash_active = FALSE
	//List of keys
	list/last_key = list()
	//Restriction booleans
	_boolNorth
	_boolSouth
	_boolEast
	_boolWest
	keys


		if(src.key=="Ninitoniazo"/*&&src.dash_active*/)
			if(src.keys=="north"&&!"North" in usr.last_key)
				if(_boolNorth)	return
				else last_key += "North"
			if(src.keys=="south"&&!"South" in last_key)
				if(_boolSouth)	return
				else last_key += "South"
			if(src.keys=="west"&&!"West" in last_key)
				if(_boolWest)	return
				else last_key += "West"
			if(src.keys=="east"&&!"East" in last_key)
				if(_boolEast)	return
				else last_key += "East"

			spawn()
				if(usr.last_key.Find("North")&&!usr._boolNorth)
					step(src, NORTH)
					usr._boolNorth = TRUE
					spawn(15) if(usr._boolNorth) usr._boolNorth = FALSE
					usr.last_key -= "North"
				else if(usr.last_key.Find("South")&&!usr._boolSouth)
					step(src, SOUTH)
					usr._boolSouth = TRUE
					spawn(15) if(usr._boolSouth) usr._boolSouth = FALSE
					usr.last_key -= "South"
				else if(usr.last_key.Find("East")&&!usr._boolEast)
					step(src, EAST)
					usr._boolEast = TRUE
					spawn(15) if(usr._boolEast) usr._boolNorth = FALSE
					usr.last_key -= "East"
				else if(usr.last_key.Find("West")&&!usr._boolWest)
					step(src, WEST)
					usr._boolWest = TRUE
					spawn(15) if(usr._boolWest) usr._boolWest = FALSE
					usr.last_key -= "West"
				else return