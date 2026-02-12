mob
	verb
		RFX_UP()
			if(usr.levelpoints>=1)
				var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
				if(usr.rfx < ((usr.blevel)*3 + effective_level + 50))
					var/rfxb=round(usr.rfx/10)

					usr.rfx++
					usr.levelpoints-=1

					var/rfxc=round(usr.rfx/10)
					if(rfxb!=rfxc)
						usr.skillspassive[26]+=1

					//usr.pint=0
					usr:Level_Up("rfx")
					winset(usr, "splabel", "text=\"[round(skillpoints)]\"")
					winset(usr, "levellabel", "text=\"[levelpoints]\"")
				else
					usr<<"'Reflex' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
		STR_UP()
			if(usr.levelpoints>=1)
				var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
				if(usr.str < ((usr.blevel)*3 + effective_level + 50))
					var/strb=round(usr.str/10)

					usr.str++
					usr.levelpoints-=1

					var/strc=round(usr.str/10)
					if(strb!=strc)
						usr.skillspassive[25]+=1

					//usr.pint=0
					usr:Level_Up("str")
					winset(usr, "splabel", "text=\"[round(skillpoints)]\"")
					winset(usr, "levellabel", "text=\"[levelpoints]\"")

				else
					usr<<"'Strength' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
		INT_UP()
			if(usr.levelpoints>=1)
				var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
				if(usr.int < ((usr.blevel)*3 + effective_level + 50))
					var/intb=round(usr.int/10)

					usr.int++
					usr.levelpoints-=1

					var/intc=round(usr.int/10)
					if(intb!=intc)
						usr.skillspassive[27]+=1

					//usr.pint=1
					usr:Level_Up("int")
					winset(usr, "splabel", "text=\"[round(skillpoints)]\"")
					winset(usr, "levellabel", "text=\"[levelpoints]\"")

				else
					usr<<"'Intelligence' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."


		CON_UP()
			if(usr.levelpoints>=1)
				var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
				if(usr.con < ((usr.blevel)*3 + effective_level + 50))
					var/conb=round(usr.con/10)

					usr.con++
					usr.levelpoints-=1

					var/conc=round(usr.con/10)
					if(conb!=conc)
						usr.skillspassive[28]+=1

					//usr.pint=0
					usr:Level_Up("con")
					winset(usr, "splabel", "text=\"[round(skillpoints)]\"")
					winset(usr, "levellabel", "text=\"[levelpoints]\"")
				else
					usr<<"'Control' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."


		Goto_Passives()
			usr.client.eye=locate_tag("maptag_skilltree_passive")
			usr.spectate=1
			usr.hidestat=1
			for(var/obj/gui/passives/gauge/Q in world)
				if(Q.pindex==25||Q.pindex==26||Q.pindex==27||Q.pindex==28)
					var/client/C=usr.client
					if(C)C.Passive_Refresh(Q)

		Goto_Nonclan()
			usr.client.eye=locate_tag("maptag_skilltree_nonclan")
			usr.spectate=1
			usr.hidestat=1
			usr:refreshskills()

		Goto_Element()
			usr.client.eye=locate_tag("maptag_skilltree_element")
			usr.spectate=1
			usr.hidestat=1
			usr:refreshskills()

		Goto_Clan()
			usr.client.eye=locate_tag("maptag_skilltree_clan")
			usr.spectate=1
			usr.hidestat=1
			usr:refreshskills()

mob/human/player
	var/has_skilltree
	verb
		check_skill_tree()
			if(!initialized)return
			if(!usr.controlmob)
				if(!EN[9])
					return
				if(!has_skilltree)
					winshow(src, "skilltree", 1)
					winset(src, "splabel", "text=\"[round(skillpoints)]\"")
					winset(src, "levellabel", "text=\"[levelpoints]\"")
					has_skilltree=1
					return
				winshow(src, "skilltree", 0)
				has_skilltree=0