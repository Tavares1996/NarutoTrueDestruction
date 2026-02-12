var/RP=0
mob/var/list/carrying=new
proc
	RPMode()
		for(var/turf/warp/EpicWarp/W in world)
			if(W.RPdis)
				del(W)

		for(var/mob/human/player/npc/X in world)
			if(X.nisguard)
				del(X)
		for(var/area/nopkzone/W in world)
			var/turf/T=W.loc
			del(W)
			new/area/pkzone(locate(T))
mob
	spectator
		density=0
		New()
			..()
			src<<"You've been logged on as a spectator, this means you have died this round on your current IP Address"
mob/corpse
	layer=MOB_LAYER-0.1
	density=0
	var
		carryingme=0
		corpsebounty=0
	New(loc,mob/M)
		..()
		src.icon=M.icon
		src.overlays+=M.overlays
		src.name="[M.name]'s Corpse([M.blevel],[M.bounty])"
		src.corpsebounty+=rand(100,500)
		if(M.blevel>=150 && M.blevel<=200)
			src.name="<font color=red>Dangerous(Level 5)<font color =white>[M.name]'s Corpse([M.blevel],[M.bounty])"
		if(M.blevel>=130 && M.blevel<150)
			src.name="<font color=orange>Dangerous(Level 4)<font color =white>[M.name]'s Corpse([M.blevel],[M.bounty])"
		if(M.blevel>=100 && M.blevel<130)
			src.name="<font color=green>Dangerous(Level 3)<font color =white>[M.name]'s Corpse([M.blevel],[M.bounty])"
		if(M.blevel>=80 && M.blevel<100)
			src.name="<font color=pink>Dangerous(Level 2)<font color =white>[M.name]'s Corpse([M.blevel],[M.bounty])"
		if(M.blevel>=50 && M.blevel<80)
			src.name="<font color=purple>Dangerous(Level 1)<font color =white>[M.name]'s Corpse([M.blevel],[M.bounty])"
		src.icon_state="Dead"
		src.dir=M.dir
		src.blevel=M.blevel
		src.corpsebounty=M.bounty

	Click()
		if(carryingme)
			var/mob/human/X = carryingme
			X.carrying-=src
			carryingme=0
		else
			usr.carrying+=src
			carryingme=usr
			usr<<"You start carrying [src]"


