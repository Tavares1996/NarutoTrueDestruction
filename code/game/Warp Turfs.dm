turf/warp
	EpicWarp
		Enter(atom/movable/O)
			. = ..()
			if(. && istype(O,/mob/human/player))
				var/mob/human/player/M = O
				if(M.client)
					if(M.risk >=1)
						usr<<"You cant run inside,please wait 5 minutes before you can enter"
						return 0
					if(needgenin)
						if(M.rank == "Academy Student")
							usr<<"You need to pass your Genin exam first!!!"
							return 0
					if((needvillage && needvillage != M.faction.village))
						return 0

	EpicWarpi
		Enter(atom/movable/O)
			. = ..()
			if(. && ismob(O))
				var/mob/M = O
				if(M.client)
					if(M.risk >=1)
						usr<<"You cant run inside,please wait 5 minnutes before you can enter"
						return 0
					if(needgenin)
						if(M.rank == "Academy Student")
							usr<<"You need to pass your Genin exam firi!!!"
							return 0
					if(needvillage && needvillage != M.faction.village)
						return 0