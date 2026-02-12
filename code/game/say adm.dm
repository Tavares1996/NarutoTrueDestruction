mob/Admin
	verb
		Say_adm(msg as text)
			set name = "Say adm"
			world << output ("<font color = yellow>[usr]:<font color = white>[msg]","adm_say")
			online_admins << "<font color=red><font size=3>activity in the chat ADM / MOD"
			winshow(usr, "window1",)



