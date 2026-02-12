proc
	ctf_start()
		del capture_the_flag
		capture_the_flag = new
		capture_the_flag.Start()
	war_start()
		Start_War()
	ctf_end()
		if(capture_the_flag)
			capture_the_flag.End()
	war_end()
		WAR = 0
		for(var/mob/human/M in world)
			if(M.war)
				M.war=0
				Player.Remove(M)
				var/obj/Respawn_Pt/Re=null
				for(var/obj/Respawn_Pt/R in world)
					if(R.ind==0)
						Re=R
					if(M.faction.village=="Konoha"&&R.ind==1)
						Re=R
					if(M.faction.village=="Suna"&&R.ind==2)
						Re=R
					if(M.faction.village=="Kiri"&&R.ind==3)
						Re=R
				if(Re)
					M.x = Re.x
					M.y = Re.y
					M.z = Re.z
				else
					M.x=31
					M.y=74
					M.z=1
var/reboot=0
world
	New()
		.=..()
		spawn() Auto_System()
		spawn() Auto_Reboot()
	proc
		Auto_System()
			set background = 1
			sleep(600*60*1.5)
			var/pick_event=rand(1,2)
			switch(pick_event)
				if(1)
					if(!capture_the_flag&&!WAR&&!chuuninactive&&!reboot)
						spawn() ctf_start()
						MultiAnnounce("<span class='auto_event'>{System}: The system has randomly generated capture the flag event!</span>")
						spawn() Auto_System()
						sleep(600*60)
						if(capture_the_flag)
							MultiAnnounce("<span class='auto_event'>{System}: Due to the event running too long, the system has executed the event!</span>")
							spawn() ctf_end()
					else if(capture_the_flag&&!WAR&&!chuuninactive&&!reboot)
						spawn() war_start()
						MultiAnnounce("<span class='auto_event'>{System}: The system has randomly generated a war event!</span>")
						spawn() Auto_System()
						sleep(600*60)
						if(WAR)
							MultiAnnounce("<span class='auto_event'>{System}: Due to the event running too long, the system has executed the event!</span>")
							spawn() war_end()
					else if(chuuninactive&&!reboot)
						spawn() Auto_System()
						MultiAnnounce("<span class='auto_event'>{System}: Due to errors, the system has been automatically reset!</span>")
					else if(reboot)
						MultiAnnounce("<span class='auto_event'>{System}: Due to a reboot in process the system has stopped the event!</span>")
				if(2)
					if(!capture_the_flag&&!WAR&&!chuuninactive&&!reboot)
						spawn() war_start()
						MultiAnnounce("<span class='auto_event'>{System}: The system has randomly generated a war event!</span>")
						spawn() Auto_System()
						sleep(600*60)
						if(WAR)
							MultiAnnounce("<span class='auto_event'>{System}: Due to the event running too long, the system has executed the event!</span>")
							spawn() war_end()
					else if(!capture_the_flag&&WAR&&!chuuninactive&&!reboot)
						spawn() ctf_start()
						MultiAnnounce("<span class='auto_event'>{System}: The system has randomly generated capture the flag event!</span>")
						spawn() Auto_System()
						sleep(600*60)
						if(capture_the_flag)
							MultiAnnounce("<span class='auto_event'>{System}: Due to the event running too long, the system has executed the event!</span>")
							spawn() ctf_end()
					else if(chuuninactive&&!reboot)
						spawn() Auto_System()
						MultiAnnounce("<span class='auto_event'>{System}: Due to errors, the system has been automatically reset!</span>")
					else if(reboot)
						MultiAnnounce("<span class='auto_event'>{System}: Due to a reboot in process the system has stopped the event!</span>")
		Auto_Reboot()
			set background = 1
			sleep(600*60*24)
			MultiAnnounce("<span class='auto_event'>{System}: Rebooting world in 10 seconds</span>")
			reboot=1
			sleep(50)
			MultiAnnounce("<span class='auto_event'>{System}: Saving all files...</span>")
			for(var/mob/M in world) if(M.client)
				sleep(10)
				M.client << "<font color=red>{System}: You have been saved"
				M.client.SaveMob()
			MultiAnnounce("<span class='auto_event'>{System}: Rebooting in 5</span>")
			sleep(10)
			MultiAnnounce("<span class='auto_event'>{System}: Rebooting in 4</span>")
			sleep(10)
			MultiAnnounce("<span class='auto_event'>{System}: Rebooting in 3</span>")
			sleep(10)
			MultiAnnounce("<span class='auto_event'>{System}: Rebooting in 2</span>")
			sleep(10)
			MultiAnnounce("<span class='auto_event'>{System}: Rebooting in 1</span>")
			sleep(10)
			MultiAnnounce("<span class='auto_event'>{System}: Has rebooted the world, Please be patient</span>")
			spawn() world.Reboot()