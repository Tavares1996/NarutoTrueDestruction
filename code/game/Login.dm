client/New()
	..()
	if(src.key in Bans&&src.key!="")
		src<<"You have been Banned!"
		del src
	if(src.computer_id in Bans&&src.key!="")
		src<<"You have been Banned!"
		del src
	if(RP&&DeathList.Find(src.computer_id))
		src.mob=new/mob/spectator(null)
		return
	src << "</a>Welcome Naruto Goa Chronicles"
	src << "<a href='/'>FORUM</a>"
	src << "<a href='http://www.byond.com/games/Ninitoniazo/NarutoGoaChronicles'>HUB</a>"
	Refresh_Bounties()
	CountPlayers()

world/IsBanned(key, addr, computer_id)
	if(ckey(key) in admins)
		return ..()
	if(copytext(key, 1, 6) == "Guest")
		return list("desc" = "Guest keys are disabled. Please create a key at https://secure.byond.com/?page=Join", "address" = addr)
	if(SendInterserverMessage("is_banned", list("key" = ckey(key), "computer_id" = computer_id)))
		return list("desc" = "Game-wide banned.", "address" = addr)
	var/count=0
	for(var/client/C)
		if(block_alts && C.computer_id == computer_id && C.key != key)
			return list("desc" = "Multiple connections from a single computer are blocked on this server", "address" = addr)
		++count
	wcount=count
	if(wcount>maxplayers)
#if DM_VERSION >= 432
		world.game_state = 1
#endif
		return list("desc" = "Max player limit reached [wcount]/[maxplayers]", "address" = addr)
	else
		return ..()

client/Del()
	CountPlayers(1)
	if(!RP)
		var/mob/vrc=mob
		for(var/mob/charactermenu/x in world)
			if(!x.client)
				del(x)
		if(vrc)
			if(vrc.ko && !vrc.dojo && vrc.pk)
				vrc.FU=1
		world.SaveMob(mob,src, ckey)
		..()

	else
		var/mob/M = mob
		if(M)
			M.Store_RP()
	..()

mob/proc
	Store_RP()
		sleep(100)
		if(!src.client)
			if(src.curwound<src.maxwound)
				src.cache_loc=src.loc
				src.loc=locate(29,93,2)
mob/var/turf/cache_loc

proc/CountPlayers(mode=0)
	var/count=0
	for(var/client/C)
		++count
	if(mode) --count
	wcount = count
	if(wcount>maxplayers)
		world.game_state = 1
	else
		world.game_state = 0

mob/human/player
	Logout()
		if(capture_the_flag && capture_the_flag.HasFlag(src))
			capture_the_flag.DropFlag(src)
		online_admins << "[src.realname] has logged out."
		if(online_admins.Find(src))
			online_admins -= src
		if(inarena == 2)
			world << "[src] has logged out during an arena match!"
			for(var/mob/O in world)
				if(O.inarena==2)
					if(O.used_arena=="regular")
						regular_arena["being_used"]=0
						regular_arena["player_1"]=null
						regular_arena["player_2"]=null
						O.inarena=0
						O.used_arena=""
						O.curstamina=O.stamina
						O.curchakra=O.chakra
						O.stunned=0
						if(O.oldx&&O.oldy&&O.oldz)
							O.loc=locate(O.oldx,O.oldy,O.oldz)
							O.oldx=0
							O.oldy=0
							O.oldz=0
						Using_Arena=0

					if(O.used_arena=="chuunin")
						chuunin_arena["being_used"]=0
						chuunin_arena["player_1"]=null
						chuunin_arena["player_2"]=null
						O.inarena=0
						O.used_arena=""
						O.curstamina=O.stamina
						O.curchakra=O.chakra
						O.stunned=0
						if(O.oldx&&O.oldy&&O.oldz)
							O.loc=locate(O.oldx,O.oldy,O.oldz)
							O.oldx=0
							O.oldy=0
							O.oldz=0
						Using_Arena=0

					if(O.used_arena=="island")
						island_arena["being_used"]=0
						island_arena["player_1"]=null
						island_arena["player_2"]=null
						O.inarena=0
						O.used_arena=""
						O.curstamina=O.stamina
						O.curchakra=O.chakra
						O.stunned=0
						if(O.oldx&&O.oldy&&O.oldz)
							O.loc=locate(O.oldx,O.oldy,O.oldz)
							O.oldx=0
							O.oldy=0
							O.oldz=0
						Using_Arena=0

					if(O.used_arena=="konoha")
						konoha_arena["being_used"]=0
						konoha_arena["player_1"]=null
						konoha_arena["player_2"]=null
						O.inarena=0
						O.used_arena=""
						O.curstamina=O.stamina
						O.curchakra=O.chakra
						O.stunned=0
						if(O.oldx&&O.oldy&&O.oldz)
							O.loc=locate(O.oldx,O.oldy,O.oldz)
							O.oldx=0
							O.oldy=0
							O.oldz=0
						Using_Arena=0

		if(src.clan=="Capacity"&&src.fusion)
			src.strbuff=0
			src.conbuff=0

		if(src.controlling_yamanaka||src.Transfered)
			var/mob/human/player/X = usr.MainTarget()
			usr.client:eye = usr
			usr.client:Controling= usr
			usr.client:perspective = EYE_PERSPECTIVE
			X.Transfered=0
			usr.stunned=0
			usr.icon_state=""
			X.client:hellno= 0
			usr.mind_attack=0
			usr.controlling_yamanaka=0

		if((src.ko||src.curwound >= 50)&&src.risk>1)
			src.logger=1
			world << "[src] has logout with [src.curwound] wounds"

		if(!RP)
			tolog+=src.key
			if(tolog.len>5)
				tolog-=tolog[1]
			src.key=0
			src.MissionFail()
			src.density=0
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo)
				Minfo.PlayerLeft(src)
				if(Minfo.in_war && faction)
					if(faction.village == Minfo.village_control)
						++Minfo.defender_deaths
					else if(faction.village == Minfo.attacking_village)
						++Minfo.attacker_deaths
			src.icon=null
			src.overlays=null
			src.loc=null
			del map_pin
			del map_pin_target
			del map_pin_self
			del map_pin_squad
			sleep(50)
			del(src)
