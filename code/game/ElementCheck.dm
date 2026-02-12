//Dont use this
mob
	proc
		Check_Element(mob/user=src)
			user = src
			if(!user.lastskill)
				return 0
			switch(user.lastskill)

				//earth
				if(DOTON_IRON_SKIN) return 2
				if(DOTON_CHAMBER) return 2
				if(DOTON_EARTH_FLOW) return 2
				if(DOTON_CHAMBER_CRUSH) return 2
				if(DOTON_RESURRECTION_TECHNIQUE) return 2
				if(DOTON_EARTH_DRAGON) return 2
				if(DOTON_EARTH_SHAKING_PALM) return 2
				if(DOTON_PRISON_DOME) return 2
				if(DOTON_MOLE) return 2
				if(DOTON_HEAD_HUNTER) return 2

				//fire
				if(KATON_GREAT_FIREBALL) return 3
				if(KATON_FIREBALL) return 3
				if(KATON_PHOENIX_FIRE) return 3
				if(KATON_ASH_BURNING) return 3
				if(KATON_DRAGON_FIRE) return 3
				if(KATON_TAJUU_PHOENIX_FIRE) return 3
				if(KATON_PHEONIX) return 3
				if(KATON_DRAGON_HEAD) return 3

				//water
				if(SUITON_DRAGON) return 4
				if(SUITON_VORTEX) return 4
				if(SUTION_SHOCKWAVE) return 4
				if(SUITON_COLLISION_DESTRUCTION) return 4
				if(SUITON_PRISON) return 4
				if(SUITON_SHARK) return 4
				if(SUITON_GUNSHOT) return 4
				if(SUITON_SHARK_GUN) return 4
				if(SUITON_HIDDEN_MIST) return 4
				if(SUITON_CLONE) return 4

				//lightning
				if(CHIDORI) return 5
				if(CHIDORI_CURRENT) return 5
				if(CHIDORI_SPEAR) return 5
				if(LIGHTNING_KAGE_BUNSHIN) return 5
				if(CHIDORI_NEEDLES) return 5
				if(RAIKIRI) return 5
				if(THUNDER_BINDING) return 5
				if(KIRIN) return 5
				if(LIGHTNING_FALSE_DARKNESS) return 5

				//wind
				if(FUUTON_WIND_BLADE) return 6
				if(FUUTON_GREAT_BREAKTHROUGH) return 6
				if(FUUTON_PRESSURE_DAMAGE) return 6
				if(FUUTON_AIR_BULLET) return 6
				if(FUUTON_VACUUM_WAVE) return 6
				if(FUUTON_SHURIKEN) return 6
				if(FUUTON_RASENSHURIKEN) return 6
				if(FUUTON_HURRICANE) return 6

				else return 0

