turf/dojouniversal
	kodojo
		Entered(o)
			usr=o
			if(usr.faction.village=="Konoha")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/dojo)
				..()
	sudojo
		Entered(o)
			usr=o
			if(usr.faction.village=="Suna")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/dojo)
				..()


	kidojo
		Entered(o)
			usr=o
			if(usr.faction.village=="Kiri")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/dojo)
				..()

	midojo
		Entered(o)
			usr=o
			if(usr.faction.village=="Missing")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/dojo)
				..()

	dojo
		Entered(o)
			usr=o
			if(usr.faction.village=="Missing")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/midojo)
				..()
			if(usr.faction.village=="Konoha")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/kodojo)
				..()
			if(usr.faction.village=="Kiri")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/kidojo)
				..()
			if(usr.faction.village=="Suna")
				if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
					usr.loc=locate(/turf/dojouniversal/sudojo)
				..()
