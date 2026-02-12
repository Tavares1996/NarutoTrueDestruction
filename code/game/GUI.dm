obj
	decoy
		density=1
		New()
			var/tx
			while(src)
				tx=src.x
				walk(src,src.dir)
				sleep(1)
				tx=src.x
				sleep(1)
				if(tx==src.x)
					if(src.dir==EAST)
						src.dir=WEST
					else
						src.dir=EAST

obj/kunai_melee
	icon='icons/kunai_melee.dmi'
obj/Kunai_Holster
	icon='icons/Kunai_Holster.dmi'
	layer=FLOAT_LAYER-7
obj/arm_guards
	icon='icons/arm_guards.dmi'
	layer=FLOAT_LAYER-5
obj/sasuke_cloth
	icon='icons/sasuke_cloth.dmi'
	layer=FLOAT_LAYER-2


obj
	gui
		layer=9
	gui/fakecards
		rfx_uparrow
			Click()
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
					else
						usr<<"'Reflex' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."


		str_uparrow
			Click()
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

					else
						usr<<"'Strength' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."

		int_uparrow
			Click()
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
					else
						usr<<"'Intelligence' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."

		con_uparrow
			Click()
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
					else
						usr<<"'Control' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."

	gui/fakecards
	gui/fakecards/dull
		layer=999
		icon='icons/gui.dmi'
		icon_state="dull"


	gui/fakecards/Buy
		icon='pngs/buy.png'
		Click()


var/Bindables=list("Remove Bind","Q","W","E","R","T","Y","I","O","P","G","H","J","K","L","X","C","V","B","N","M","`","-","=",",",".","/","{","}","\\","Tab","Back")

obj/var/macover
obj
	gui/skillcards
		layer=10
		var
			exempt=0

		attackcard
			layer=10
			exempt=1
			code=39
			icon='icons/gui.dmi'
			icon_state="attack"
			New(client/C)
				if(!C||!istype(C,/client))return
				if(istype(C,/client))
					screen_loc=""
					C.screen+=src
					..()
				else
					if(istype(C,/mob))
						var/mob/M=C
						if(M.client)
							screen_loc=""
							M.client.screen+=src
			Click()
				if(istype(usr,/mob/human/player))
					if(usr.Primary)
						var/mob/human/Puppet/P =usr.Primary
						if(P)
							P.Melee(usr)
						return
					usr:attackv()

		interactcard
			exempt=1
			code=68
			icon='icons/gui.dmi'
			icon_state="interact0"
			New(client/C)

				if(!C||!istype(C,/client))return
				screen_loc=""
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					usr:interactv()

		usecard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="use"
			code=103
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc=""
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					if(usr.Puppet1 && usr.Puppet1!=usr.Primary && !usr.Primary)
						usr.Primary=usr.Puppet1
						walk(usr.Primary,0)
						usr.client.eye=usr.Puppet1
						return
					else if(usr.Puppet2 && usr.Puppet2!=usr.Primary)
						if(usr.Puppet1 && usr.Puppet1==usr.Primary)
							usr.Primary=usr.Puppet2
							walk(usr.Primary,0)
							usr.client.eye=usr.Puppet2
							return
						else if(!usr.Puppet1)
							usr.Primary=usr.Puppet2
							walk(usr.Primary,0)
							usr.client.eye=usr.Puppet2
							return
					else if(usr.Puppet2 || usr.Puppet1)
						usr.Primary=0
						usr.client.eye=usr.client.mob
						return
					usr:usev()

		skillcard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="skill"
			code=98
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc=""
				C.screen+=src
				..()

		untargetcard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="untarget"
			code=102
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc=""
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					usr.FilterTargets()
					for(var/target in usr.targets)
						usr.RemoveTarget(target)
					usr << "Untargeted"

		treecard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="skilltree"
			code=101
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc="1,17"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					usr:check_skill_tree()

		defendcard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="defend"
			code=50
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc=""
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					if(usr.Puppet1)
						var/mob/human/Puppet/P =usr.Puppet1
						if(P)
							P.Def(usr)
					if(usr.Puppet2)
						var/mob/human/Puppet/P =usr.Puppet2
						if(P)
							P.Def(usr)
					usr.Primary=0
					if(usr.client) usr.client.eye=usr.client.mob
					usr:defendv()

		triggercard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="trigger"
			code=252
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc="1,17"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player) && !usr.ko)
					if(usr.triggers && usr.triggers.len && usr.triggers[usr.triggers.len])
						var/obj/trigger/T = usr.triggers[usr.triggers.len]
						T.Use()

obj/log
	icon='icons/log.dmi'
	icon_state=""
	density=1
	New()
		src.icon_state="kawa"
		spawn(20)
			del(src)

obj/clay_kawa
	icon='icons/log.dmi'
	icon_state=""
	density=1
	var
		mob/Owner=null

	New(mob/human/player/p,newx,newy,newz)
		src.loc=locate(newx,newy,newz)
		src.Owner=p
		src.icon_state="clay"
		spawn(20)
			src.Explode()

	proc/Explode()
		if(src.icon)
			src.icon=null

			var/mob/human/player/user = src.Owner
			var/conmult = user.ControlDamageMultiplier()
			var/power=rand(300,(700+400*conmult))

			src.density=0
			explosion(power,src.x,src.y,src.z,src.Owner,0,3)

			del(src)
mob
	var
		BMM=0



obj
	gui
		hudbar
			icon='icons/hudbar.dmi'

			layer=9
			Q
				icon_state="1,0"
				New(client/C)
					if(C)
						screen_loc="1,1"
						C.screen+=src
						..()
			W
				icon_state="2,0"
				New(client/C)
					if(C)
						screen_loc="2,1"
						C.screen+=src
						..()
			Z
				icon_state="1,1"
				New(client/C)
					if(C)
						screen_loc="1,2"
						C.screen+=src
						..()
			X
				icon_state="2,1"
				New(client/C)
					if(C)
						screen_loc="2,2"
						C.screen+=src
						..()
			Y
				icon_state="3,1"
				New(client/C)
					if(C)
						screen_loc="3,2"
						C.screen+=src
						..()
			A
				icon_state="`"
				New(client/C)
					if(C)
						screen_loc="3,1"
						C.screen+=src
						..()
			B
				icon_state="1"
				New(client/C)
					if(C)
						screen_loc="4,1"
						C.screen+=src
						..()
			C
				icon_state="2"
				New(client/C)
					if(C)
						screen_loc="5,1"
						C.screen+=src
						..()
			D
				icon_state="3"
				New(client/C)
					if(C)
						screen_loc="6,1"
						C.screen+=src
						..()
			E
				icon_state="4"
				New(client/C)
					if(C)
						screen_loc="7,1"
						C.screen+=src
						..()
			F
				icon_state="5"
				New(client/C)
					if(C)
						screen_loc="8,1"
						C.screen+=src
						..()
			G
				icon_state="6"
				New(client/C)
					if(C)
						screen_loc="9,1"
						C.screen+=src
						..()
			H
				icon_state="7"
				New(client/C)
					if(C)
						screen_loc="10,1"
						C.screen+=src
						..()
			I
				icon_state="8"
				New(client/C)
					if(C)
						screen_loc="11,1"
						C.screen+=src
						..()
			J
				icon_state="9"
				New(client/C)
					if(C)
						screen_loc="12,1"
						C.screen+=src
						..()
			K
				icon_state="0"
				New(client/C)
					if(C)
						screen_loc="13,1"
						C.screen+=src
						..()
			L
				icon_state="-"
				New(client/C)
					if(C)
						screen_loc="14,1"
						C.screen+=src
						..()
			M
				icon_state="="
				New(client/C)
					if(C)
						screen_loc="15,1"
						C.screen+=src
						..()
			N
				icon_state="16,0"
				New(client/C)
					if(C)
						screen_loc="16,1"
						C.screen+=src
						..()
			O
				icon_state="15,1"
				New(client/C)
					if(C)
						screen_loc="15,2"
						C.screen+=src
						..()
			P
				icon_state="16,1"
				New(client/C)
					if(C)
						screen_loc="16,2"
						C.screen+=src
						..()
		placeholder
			icon='icons/gui.dmi'
			layer=9
			mouse_drop_zone=1
			var
				orig=1

			New(client/C)
				if(C)
					var/mob/X=C.mob
					if(orig)
						X.player_gui+=new/obj/gui/placeholder/placeholder1(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder2(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder3(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder4(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder5(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder6(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder7(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder8(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder9(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder0(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder11(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder12(C)
						X.player_gui+=new/obj/gui/placeholder/placeholder13(C)
					else
						..()
			placeholder13
				orig=0
				New(client/C)
					screen_loc="3,1"
					icon_state="3,0"
					C.screen+=src
					..()
			placeholder1
				orig=0
				New(client/C)
					screen_loc="4,1"
					icon_state="4,0"
					C.screen+=src
					..()
			placeholder2
				orig=0
				New(client/C)
					screen_loc="5,1"
					icon_state="5,0"
					C.screen+=src
					..()
			placeholder3
				orig=0
				New(client/C)
					screen_loc="6,1"
					icon_state="6,0"
					C.screen+=src
					..()
			placeholder4
				orig=0
				New(client/C)
					screen_loc="7,1"
					icon_state="7,0"
					C.screen+=src
					..()
			placeholder5
				orig=0
				New(client/C)
					screen_loc="8,1"
					icon_state="8,0"
					C.screen+=src
					..()
			placeholder6
				orig=0
				New(client/C)
					screen_loc="9,1"
					icon_state="9,0"
					C.screen+=src
					..()
			placeholder7
				orig=0
				New(client/C)
					screen_loc="10,1"
					icon_state="10,0"
					C.screen+=src
					..()
			placeholder8
				orig=0
				New(client/C)
					screen_loc="11,1"
					icon_state="11,0"
					C.screen+=src
					..()
			placeholder9
				orig=0
				New(client/C)
					screen_loc="12,1"
					icon_state="12,0"
					C.screen+=src
					..()
			placeholder0
				orig=0
				New(client/C)
					screen_loc="13,1"
					icon_state="13,0"
					C.screen+=src
					..()
			placeholder11
				orig=0
				New(client/C)
					screen_loc="14,1"
					icon_state="14,0"
					C.screen+=src
					..()
			placeholder12
				orig=0
				New(client/C)
					screen_loc="15,1"
					icon_state="15,0"
					C.screen+=src
					..()
	gui
		skillcards
			mouse_drop_zone=1
			layer=11
			verb
				Remove()
					set category=null
						del(src)
				Set_Custom_Macro()
					set category=null
					var/C
					var/S=null
					if(!S)
						C=input(usr,"Bind Key to Card","Custom Macro") in Bindables
						if(C=="Remove Bind")
							src.cust_macro=null
							src.overlays-=src.macover
							src.macover=null
							winset(usr, "custom_macro_[C]", "parent=")
							return
					else
						C=S
					for(var/obj/O in usr.contents)
						if(O.cust_macro==C)
							O.cust_macro=null
							O.overlays-=O.macover
							O.macover=null

					src.cust_macro=C
					src.macover=image('fonts/Cambriacolor.dmi',icon_state="[C]")
					src.overlays+=src.macover
					winset(usr, "custom_macro_[C]", "parent=macro;name=\"[C]+REP\";command=\"custom-macro \\\"[C]\\\"\"")
mob
	verb
		macchat()
			set name="macchat"
			set hidden = 1
			if(istype(usr,/mob/human/player))
				winset(usr, "default_input", "focus=true")
		macuntarget()
			set name="macuntarget"
			set hidden = 1
			if(istype(usr,/mob/human/player))
				usr.FilterTargets()
				for(var/target in usr.targets)
					usr.RemoveTarget(target)
				usr << "Untargeted"
		macskilltree()
			set name="macskilltree"
			set hidden = 1
			if(istype(usr,/mob/human/player))
				usr:check_skill_tree()
		macskill()
			set name = "macskill"
			set hidden=1
			if(istype(usr,/mob/human/player))
				for(var/obj/gui/skillcards/skillcard/O in usr.client.screen)
					spawn()O.Click()
		macattack()
			set name = "macattack"
			set hidden=1
			if(istype(usr,/mob/human/player))
				for(var/obj/gui/skillcards/attackcard/O in usr.client.screen)
					spawn()O.Click()
		macdefend()
			set name = "macdefend"
			set hidden=1
			if(istype(usr,/mob/human/player))
				for(var/obj/gui/skillcards/defendcard/O in usr.client.screen)
					spawn()O.Click()
		macinteract()
			set name = "macinteract"
			set hidden=1
			if(istype(usr,/mob/human/player))
				for(var/obj/gui/skillcards/interactcard/O in usr.client.screen)
					spawn()O.Click()
			else if(istype(usr,/mob/charactermenu))
				if(!EN[10])
					return
				if(!usr:hasspaced)
					usr:hasspaced = 1
					if(!checkservs)
						usr.loc = locate_tag("maptag_select")
		macuse()
			set name = "macuse"
			set hidden=1
			if(istype(usr,/mob/human/player))
				for(var/obj/gui/skillcards/usecard/O in usr.client.screen)
					spawn()O.Click()
		mactrigger()
			set name = "mactrigger"
			set hidden=1
			if(istype(usr,/mob/human/player) && !usr.ko)
				if(usr.triggers && usr.triggers.len && usr.triggers[usr.triggers.len])
					var/obj/trigger/T = usr.triggers[usr.triggers.len]
					T.Use()
		mac1()
			set name = "mac1"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro1)
				usr.macro1.Activate(usr)
		mac2()
			set name = "mac2"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro2)
				usr.macro2.Activate(usr)
		mac3()
			set name = "mac3"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro3)
				usr.macro3.Activate(usr)
		mac4()
			set name = "mac4"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro4)
				usr.macro4.Activate(usr)
		mac5()
			set name = "mac5"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro5)
				usr.macro5.Activate(usr)
		mac6()
			set name = "mac6"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro6)
				usr.macro6.Activate(usr)
		mac7()
			set name = "mac7"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro7)
				usr.macro7.Activate(usr)
		mac8()
			set name = "mac8"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro8)
				usr.macro8.Activate(usr)
		mac9()
			set name = "mac9"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro9)
				usr.macro9.Activate(usr)
		mac0()
			set name = "mac0"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro10)
				usr.macro10.Activate(usr)
		mac11()
			set name = "mac11"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro11)
				usr.macro11.Activate(usr)
		mac12()
			set name = "mac12"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro12)
				usr.macro12.Activate(usr)
		mac13()
			set name = "mac13"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro13)
				usr.macro13.Activate(usr)

		custom_macro(var/S as text)//custommac
			set name ="custom_macro"
			set hidden=1
			if(!istype(usr,/mob/human/player))return
			for(var/obj/O in usr.client.screen)
				if(O.cust_macro==S)
					spawn()O.Click()
					return
			for(var/obj/O in usr.contents)
				if(O.cust_macro==S)
					spawn()O.Click()
					return

obj/var/cust_macro=null
