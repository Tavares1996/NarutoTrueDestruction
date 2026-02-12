mob/var/GM=0
mob/var/ADM=0
mob/var/DEV=0
mob/var/CG=0

mob/Developer
	verb
		World_Name(msg as text)
			world.name = "[msg]"
		Give_GM_CG_ADM_DEV(mob/M in All_Clients())
			switch(input("What level of Admin?") in list ("Administrator","Global Moderator","Community Guide","Developer","Demote","Nevermind"))
				if("Administrator")
					if(M.GM||M.ADM||M.DEV||M.CG)
						usr << "This person is already is a specific type of admin"
						return
					else
						M.ADM=1
						M.admin_chat="<font color=green><b>ADM</b>"
						world << "<font color=green><b>[usr] has made [M] an Admin"
						M << "<font color=red><b>Please Relog"
						return

				if("Global Moderator")
					if(M.GM||M.ADM||M.DEV||M.CG)
						usr << "This person is already is a specific type of admin"
						return
					else
						M.GM=1
						M.admin_chat="<font colour=#BE81F7><b>GM</b>"
						world << "<font color=green><b>[usr] has made [M] a Global Moderator"
						M << "<font color=red><b>Please Relog"
						return

				if("Community Guide")
					if(M.GM||M.ADM||M.DEV||M.CG)
						usr << "This person is already is a specific type of admin"
						return
					else
						M.CG=1
						M.admin_chat="<font colour=#A9D0F5><b>CG</b>"
						world << "<font color=green><b>[usr] has made [M] a Community Guide"
						M << "<font color=red><b>Please Relog"
						return

				if("Developer")
					if(M.GM||M.ADM||M.DEV||M.CG)
						usr << "This person is already is a specific type of admin"
						return
					else
						M.admin_chat="<font color=blue><b>DEV</b>"
						M.DEV=1
						world << "<font color=green><b>[usr] has made [M] a Developer"
						M << "<font color=red><b>Please Relog"
						return

				if("Demote")
					if(M.DEV)
						M.DEV=0
					if(M.CG)
						M.CG=0
					if(M.GM)
						M.GM=0
					if(M.ADM)
						M.ADM=0
					M.admin_chat = ""
					online_admins -= M
					world << "<font color=red><u>[usr] has demoted [M]"
					world.SaveMob(M)
					del(M)
					return

mob/Admin
	verb
		Give_GM_CG(mob/M in All_Clients())
			switch(input("What level of Admin?") in list ("Global Moderator","Community Guide","Demote","Nevermind"))
				if("Global Moderator")
					if(M.GM||M.ADM||M.DEV||M.CG)
						usr << "This person is already is a specific type of admin"
						return
					else
						M.GM=1
						M.admin_chat="<font colour=#BE81F7><b>GM</b>"
						world << "<font color=green><b>[usr] has made [M] a Global Moderator"
						M << "<font color=red><b>Please Relog"
						return

				if("Community Guide")
					if(M.GM||M.ADM||M.DEV||M.CG)
						usr << "This person is already is a specific type of admin"
						return
					else
						M.CG=1
						M.admin_chat="<font colour=#A9D0F5><b>CG</b>"
						world << "<font color=green><b>[usr] has made [M] a Community Guide"
						M << "<font color=red><b>Please Relog"
						return

				if("Demote")
					if(M.CG)
						M.CG=0
					if(M.GM)
						M.GM=0
					M.admin_chat = ""
					online_admins -= M
					world << "<font color=red><u>[usr] has demoted [M]"
					world.SaveMob(M)
					del(M)
					return
