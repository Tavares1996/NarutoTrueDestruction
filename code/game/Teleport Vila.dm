mob
	Admin
		verb
			Teleport_Villages()
				switch(input(src,"Teleport Villages") in list ("Admin","Konoha","Kiri","Suna","Cha no Kuni","Kawa","Ishi","Cancel"))
					if ("Sala Admin")
						usr.loc= locate(/turf/T.Admin)
					if ("Konoha")
						usr.loc= locate(/turf/T.Konoha)
					if ("Kiri")
						usr.loc= locate(/turf/T.Kiri)
					if ("Suna")
						usr.loc= locate(/turf/T.Suna)
					if ("Cha no Kuni")
						usr.loc= locate(/turf/T.ChanoKuni)
					if ("Kawa")
						usr.loc= locate(/turf/T.Kawa)
					if ("Ishi")
						usr.loc= locate(/turf/T.Ishi)
/*					if ("")
						usr.loc= locate(x,y,z) our (/turf/Teleport1) */



turf
	T.Konoha
	T.Suna
	T.Kiri
	T.ChanoKuni
	T.Ishi
	T.Kawa
	T.Admin