mob
	var
		Dojotime=0
		Ztime=0
		Social=0
		Skilltime=0
		Staminatime=0
		ezing=0
		lastskill=0
		watercount=0
mob/proc
	EZ_Loop()
		set background = 1
		var/laststam=0
		var/lastZ=0
		var/lastskill2=0
		var/list/Roview=new()
		var/rbody=0
		spawn()
			while(src.client)
				if(src.pk &&!src.AFK && src.curstamina>src.stamina && src.curchakra>src.chakra)
					sleep(100)
				else
					if(!src.waterlogged)
						src.watercount--
					if(src.body!=rbody)
						rbody=src.body
						src.Social+=10
						for(var/mob/X in oview(3,src))
							if(X.client&&(!(X in Roview)))
								src.Social=0
						Roview=new/list()

						for(var/mob/X in oview(3,src))
							if(X.client)
								Roview+=X

						if(src.lastskill==lastskill2)
							Skilltime+=10
						else
							Skilltime=0
						lastskill2=src.lastskill
						if(laststam==src.curstamina)
							Staminatime+=10
						else
							Staminatime=0
						if(lastZ==src.z)
							Ztime+=10
						else
							Ztime=0
						lastZ=src.z
						if(src.dojo)
							src.Dojotime+=10
						else
							src.Dojotime=0

						laststam=src.curstamina
/*
						if(src.Social>900||src.Ztime>3000||src.Staminatime>900||src.Skilltime>300)
							if(!src.ezing)
								src<<"<b>Your method of training has become repetitive, you wont get any stronger until you fight in new ways and in new situations!</b>"
								world.log<<"EZ ALERT: name[src] key[src.key],address=[src.client.address], Social[Social], Ztime[Ztime], Dojotime[Dojotime], Staminatime[Staminatime], Skilltime[Skilltime]"
							src.ezing=1
							client.SaveMob()
							del(client)
						else
							src.ezing=0*/
				sleep(100)//10 seconds
				if(EZOFF)
					return

var
	EZOFF=0
mob/Admin/verb
	EZ_Checker_Toggle()
		if(EZOFF)
			EZOFF=0
			for(var/mob/human/player/X in world)
				if(X.client)
					spawn()X.EZ_Loop()
		else
			EZOFF=1
		usr<<"EZOFF=[EZOFF]"