var
	hour
	minute
	second

	number_generator

world
	New()
		..()
		hour = text2num( time2text(world.realtime, "hh") )
		minute = text2num( time2text(world.realtime, "mm") )
		second = text2num( time2text(world.realtime, "ss") )
		spawn(10) TimeLoop()

proc
	TimeLoop()
		AddSecond()
		spawn(10)
			TimeLoop()

	AddSecond()
		if( ++second >= 60 )
			AddMinute()
			second = 0

	AddMinute()
		if( ++minute >= 60 )
			AddHour()
			minute = 0

	AddHour(client/C)
		if( ++hour > 24 )
			hour = 0
		if(hour==18)
			MultiAnnounce("<span class='weather_system'>{Weather Sytem}(Night): The Sun Has Set And The World Has Darkened</span>")
			number_generator = pick(1,2)
			switch(number_generator)
				if(1)
					Snow()
				if(2)
					Rain()
			Night()
		if(hour==12)
			MultiAnnounce("<span class='weather_system'>{Weather Sytem}(Day): The Sun Has Rose To The Highest Peak</span>")
			number_generator = pick(1,2)
			switch(number_generator)
				if(1)
					Snow()
				if(2)
					Rain()
			Day()
		if(hour==6)
			MultiAnnounce("<span class='weather_system'>{Weather Sytem}(Morning): The Sun Rise's Since The Moon Has Set</span>")
			number_generator = pick(1,2)
			switch(number_generator)
				if(1)
					Snow()
				if(2)
					Rain()
			Morning()

obj/outside
	layer = EFFECTS_LAYER+2000
	Night
		icon = 'icons/Night.dmi'
	Morning
		icon = 'icons/morning.dmi'
	type
		layer = 100
		Snow
			icon='icons/snow.dmi'
		Rain
			icon='icons/rain.dmi'


area
	outside
		layer=8
		var
			lit = 1
			obj/outside/Weather
		proc
			WeatherSetInWorld(WeatherType)
				if(Weather)
					if(istype(Weather,WeatherType)) return
					overlays -= Weather
					del(Weather)
				else
					Weather = new WeatherType()
					overlays += Weather

proc
	Night()
		var/area/outside/X
		for(X in world)
			break
		if(!X) return
		X.WeatherSetInWorld(/obj/outside/Night)
	Day()
		var/area/outside/X
		for(X in world)
			break
		if(!X) return
		X.WeatherSetInWorld()
	Morning()
		var/area/outside/X
		for(X in world)
			break
		if(!X) return
		X.WeatherSetInWorld(/obj/outside/Morning)
	Snow()
		var/area/outside/X
		for(X in world)
			break
		if(!X) return
		X.WeatherSetInWorld(/obj/outside/type/Snow)
	Rain()
		var/area/outside/X
		for(X in world)
			break
		if(!X) return
		X.WeatherSetInWorld(/obj/outside/type/Rain)