var/capture_the_flag/capture_the_flag
mob/var/capture_the_flag_entry=0
capture_the_flag
	var
		list
			blue_team = new
			red_team = new
		blue_score = 0
		red_score = 0

		score_goal = 4

		status

		CTF
			flag
				red/red_flag = new
				blue/blue_flag = new

	proc
		Register(mob/user)

			winset(user, "ctf_verb_join", "parent=")

			if(GetTeam(user) != "None" || status != "Registration")
				return 0

			if(blue_team.len >= red_team.len)
				red_team += user
				online_admins << "[user] has joined the Red Team"
				user.capture_the_flag_entry=1
			else if(blue_team.len < red_team.len)
				blue_team += user
				online_admins << "[user] has joined the Blue Team."
				user.capture_the_flag_entry=1

			online_admins << "Count: Blue Team: [blue_team.len] Red Team: [red_team.len]"

			if(user.shopping)
				user.shopping=0
				user.canmove=1
				user.see_invisible=0

			user.verbs-=/mob/CTF/verb/Join_CTF

			user.Load_Overlays()

			user << "You have Joined CTF"

		Leave(mob/user)
			user.capture_the_flag_entry=0
			if(GetTeam(user) == "None")
				return 0
			else if(GetTeam(user) == "Blue")
				blue_team -= user
				online_admins << "[user] has left the Blue Team."
			else if(GetTeam(user) == "Red")
				red_team -= user
				online_admins << "[user] has left the Red Team."

			if(status == "Registration")
				user << "You have left CTF"

			if(HasFlag(user))
				DropFlag(user)

			Respawn(user)

		GetTeam(mob/user)
			if(user in blue_team)
				return "Blue"
			if(user in red_team)
				return "Red"

			return "None"

		Announce(text)
			blue_team << text
			red_team << text

		Start()
			if(WAR||chuuninactive)
				End()

			world << "CTF Registration has started and you have 5 minutes to join"

			status = "Registration"

			sleep(3000)

			world << "CTF Registration is over"

			status = "Start"

			sleep(50)

			red_flag.Respawn()
			blue_flag.Respawn()

			world << "Starting CTF....."


			SpawnAll()

			Announce("First Team to Capture The Flag [score_goal] times Wins. Controls: Spacebar to Interact with the Flag.")

		End()
			world << "Capture The Flag is Over!"
			for(var/mob/x in world)
				if(x.capture_the_flag_entry)
					x.capture_the_flag_entry=0

			RespawnAll()

			del blue_flag
			del red_flag

			Del()

		RespawnAll()
			for(var/list/player_list in list(blue_team,red_team))
				for(var/mob/m in player_list)
					Leave(m)

		Respawn(mob/user)
			user.Load_Overlays()

			if(GetTeam(user) == "None")

				while(user && user.incombo)
					sleep(1)

				if(!user) return

				if(user.client && winexists(user,"ctf_verb_leave"))
					winset(user, "ctf_verb_leave", "parent=")


				user.verbs-=/mob/CTF/verb/Leave_CTF

				var/obj/Re=0
				for(var/obj/Respawn_Pt/R in world)
					if(R.ind==0)
						Re=R
					if(user.faction.village=="Konoha"&&R.ind==1)
						Re=R
					if(user.faction.village=="Suna"&&R.ind==2)
						Re=R
					if(user.faction.village=="Kiri"&&R.ind==3)
						Re=R
					if(user.faction.village=="Iwa"&&R.ind == 4)
						Re=R
				if(Re)
					user.x = Re.x
					user.y = Re.y
					user.z = Re.z
				else
					user.x=31
					user.y=74
					user.z=1

			else
				Spawn(user)

		SpawnAll()
			for(var/list/player_list in list(blue_team,red_team))
				for(var/mob/m in player_list)
					Spawn(m)

		Spawn(mob/user)
			if(user.shopping)
				user.shopping=0
				user.canmove=1
				user.see_invisible=0

			user.Load_Overlays()
			var/team = lowertext(GetTeam(user))
			user.loc = locate_tag("ctf_[team]_spawn")


		Flag(mob/user)
			user.Load_Overlays()

			if(PlaceFlag(user))
				return

			CaptureFlag(user)

		CaptureFlag(mob/user)
			if(GetTeam(user) == "None" || user.ko || user.stunned || user.Tank)
				return

			var/CTF/flag/flag = locate() in get_step(user,user.dir)

			if(!flag || !flag.team) return

			flag.SetHolder()

			if(flag.team == GetTeam(user) && flag.loc != flag.holder.loc)
				flag.Respawn()
				Announce("[flag.team] Flag has been <b>Recovered</b> by [user]")
			else if(flag.team != GetTeam(user))
				flag.Move(user)
				Announce("[flag.team] Flag has been <b>Captured</b> by [user]")

			user.Load_Overlays()

		PlaceFlag(mob/user)
			if(GetTeam(user) == "None" || !HasFlag(user))
				return


			var
				team = GetTeam(user)
				CTF
					flag/team_flag = team == "Red" ? red_flag : blue_flag
					holder/holder = team_flag.holder
					flag/flag = GetFlag(user)


			if((holder in get_step(user,user.dir)) && team_flag.holder.loc == team_flag.loc)

				Announce("[user] has scored for the [team] Team")

				user.movepenalty=0

				flag.Respawn()

				Score(user)

				user.Load_Overlays()

				return 1

		HasFlag(mob/user)
			var/CTF/flag/flag = GetFlag(user)

			if(flag)
				return 1

			else return 0

		DropFlag(mob/user)
			if(!HasFlag(user)) return

			var/CTF/flag/flag = GetFlag(user)

			flag.loc = user.loc

			Announce("[flag.team] Flag has been <b>Dropped</b> by [user]")

			user.Load_Overlays()

		GetFlag(mob/user)
			var/CTF/flag/flag = locate() in user

			return flag

		Score(mob/user,score = 1)
			var/team = lowertext(GetTeam(user))
			vars["[team]_score"] += score
			CheckScore()

		ShowScore()
			Announce("<font size=+1><span class='ctf'>Scores: Blue: [blue_score] Red: [red_score]")

		CheckScore()
			var/winner
			if(blue_score >= score_goal)
				Announce("<font size=+1><span class='ctf'>Blue Team Wins!")
				winner = "Blue"

			else if (red_score >= score_goal)
				Announce("<font size=+1><span class='ctf'>Red Team Wins!")
				winner = "Red"

			ShowScore()


			if(winner)
				Winner(winner)
				End()
		Winner(team)
			if(!team || team == "None")
				return

			for(var/mob/x in world)
				if(x.capture_the_flag_entry)
					x.capture_the_flag_entry=0
			var/list/winners = new

			if(team == "Red")
				winners = red_team
			if(team == "Blue")
				winners = blue_team

			for(var/mob/m in winners)
				var
					lpgain = 2000*lp_mult_two
					mgain = pick(2500,3000,3500)

				m.body+=lpgain
				m <<"You gained [lpgain] Level Points for winning CTF!"
				m.money += mgain
				m << "You recieved [mgain] Dollars for winning CTF!"
mob
	CTF
		verb
			Leave_CTF()
				set category="War"
				winset(src, "ctf_menu", "parent=")

				if(!capture_the_flag) return

				capture_the_flag.Leave(src)

			Join_CTF()
				winset(src, "ctf_menu", "parent=")
				if(!capture_the_flag) return
				capture_the_flag.Register(src)




mob
	Admin
		verb
			CTF()
				set hidden = 1
				set name = ".ctf"
				world<<"<font size=+1><span class='ctf'>[name] has started CTF!</span>"

				del capture_the_flag

				capture_the_flag = new

				capture_the_flag.Start()

			END_CTF()
				set hidden = 1
				set name = ".end-ctf"

				world<<"<font size=+1><span class='ctf'>[name] has ended CTF!</span>"

				if(capture_the_flag)
					capture_the_flag.End()




CTF
	parent_type = /obj
	density = 1
	layer = 99999
	var
		team
	flag
		icon = 'icons/ctf_flag.dmi'
		var
			CTF/holder/holder

		proc
			SetHolder()
				if(holder != initial(holder)) return

				holder = locate(initial(holder)) in world
				holder.flag = src

			Respawn()
				SetHolder()
				loc = holder.loc

		red
			icon_state = "red"
			team = "Red"
			holder = /CTF/holder/red

		blue
			icon_state = "blue"
			team = "Blue"
			holder = /CTF/holder/blue

	holder
		icon_state = "no_flag"
		var/CTF/flag/flag


		red
			icon = 'icons/ctf_red.dmi'
		blue
			icon = 'icons/ctf_blue.dmi'

