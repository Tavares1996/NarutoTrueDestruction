var/tmp/def = 75
var/tmp/lagset = 0
var/tmp/clag = 0
var/tmp/tick_mem = world.tick_lag
world
	proc
		Lag_Guard()
			spawn while(1)
				if(lagset == 0)
					if(world.cpu >= def)
						world.tick_lag += 1
						world.tick_lag = round(world.tick_lag)
					if(world.cpu < def)
						if(world.tick_lag == tick_mem)
							..()
						else
							world.tick_lag -= 10
							world.tick_lag = round(world.tick_lag)
				else
					if(world.cpu >= clag)
						world.tick_lag += 1
						world.tick_lag = round(world.tick_lag)
					if(world.cpu < clag)
						if(world.tick_lag == tick_mem)
							..()
						else
							world.tick_lag -= 10
							world.tick_lag = round(world.tick_lag)
				sleep(50)

client/New()
	spawn(15)
		src << ""

	..()


world
	New()
		..()
		Lag_Guard()