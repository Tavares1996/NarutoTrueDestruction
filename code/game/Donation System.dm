mob/var
	donation_points=0
	Membership_Time
	Membership_2_Month=0
	Membership=0
	Membership_Time_2
var/member_name=""

mob
	Developer/verb
		Give_Donation_Points(mob/human/player/X in All_Clients())
			var/Donation_Points = input(usr,"How many points do you want to give","Points") as num
			src <<"You gave [Donation_Points] points to [X]"
			X.donation_points += Donation_Points
			X <<"You now have [X.donation_points] Donation Points"
	verb
		Donate()
			var/donate = input(src,"You have [src.donation_points] Donation Points to spend")\
			in list("Membership 1 Month | Cost: 10","Membership 2 Month | Cost: 15","1000 Skill Points | Cost: 5","3000 Skill Points | Cost: 10","7000 Skill Points | Cost: 15","12000 Skill Points | Cost: 25","Level 60 | Cost: 10","Level 90 | Cost: 20","Level 120 | Cost: 30","Level 150 | Cost: 40","Remove 5 V.Kills | Cost: 5","Remove 10 V.Kills | Cost: 10","Remove 15 V.Kills | Cost: 15","+10000 Money | Cost: 5","+20000 Money | Cost: 10","+30000 Money | Cost: 15","Eternal Mangekyou (Itachi) | Cost: 30","Eternal Mangekyou (Sasuke) | Cost: 30","Cancel")
			if(donate=="1000 Skill Points | Cost: 5"&&src.donation_points>=5)
				src.donation_points-=5
				src.skillpoints+=1000
				src << "Donation Points left: [src.donation_points]"
				src << "You now have [src.skillpoints] skillpoints"
			if(donate=="3000 Skill Points | Cost: 10"&&src.donation_points>=10)
				src.donation_points-=10
				src.skillpoints+=3000
				src << "Donation Points left: [src.donation_points]"
				src << "You now have [src.skillpoints] skillpoints"
			if(donate=="7000 Skill Points | Cost: 15"&&src.donation_points>=15)
				src.donation_points-=15
				src.skillpoints+=7000
				src << "Donation Points left: [src.donation_points]"
				src << "You now have [src.skillpoints] skillpoints"
			if(donate=="12000 Skill Points | Cost: 25"&&src.donation_points>=25)
				src.donation_points-=25
				src.skillpoints+=12000
				src << "Donation Points left: [src.donation_points]"
				src << "You now have [src.skillpoints] skillpoints"
			if(donate=="Level 60 | Cost: 10"&&src.donation_points>=10)
				src.donation_points-=10
				Auto_Set_Level(src,60)
				src << "Donation Points left: [src.donation_points]"
			if(donate=="Level 90 | Cost: 20"&&src.donation_points>=20)
				src.donation_points-=20
				Auto_Set_Level(src,90)
				src << "Donation Points left: [src.donation_points]"
			if(donate=="Level 120 | Cost: 30"&&src.donation_points>=30)
				src.donation_points-=30
				Auto_Set_Level(src,120)
				src << "Donation Points left: [src.donation_points]"
			if(donate=="Level 150 | Cost: 40"&&src.donation_points>=40)
				src.donation_points-=40
				Auto_Set_Level(src,150)
				src << "Donation Points left: [src.donation_points]"
			if(donate=="Remove 5 V.Kills | Cost: 5"&&src.donation_points>=5)
				src.donation_points-=5
				src.VillageKills-=5
				if(src.VillageKills<0)
					src.VillageKills=0
				src << "Donation Points left: [src.donation_points]"
			if(donate=="Remove 10 V.Kills | Cost: 10"&&src.donation_points>=10)
				src.donation_points-=10
				src.VillageKills-=10
				if(src.VillageKills<0)
					src.VillageKills=0
				src << "Donation Points left: [src.donation_points]"
			if(donate=="Remove 15 V.Kills | Cost: 15"&&src.donation_points>=20)
				src.donation_points-=15
				src.VillageKills-=15
				if(src.VillageKills<0)
					src.VillageKills=0
				src << "Donation Points left: [src.donation_points]"
			if(donate=="+10000 Money | Cost: 5"&&src.donation_points>=5)
				src.donation_points-=5
				src.money+=10000
				src << "Donation Points left: [src.donation_points]"
				src << "The amount of money you currently got is [src.money]"
			if(donate=="+20000 Money | Cost: 10"&&src.donation_points>=10)
				src.donation_points-=10
				src.money+=20000
				src << "Donation Points left: [src.donation_points]"
				src << "The amount of money you currently got is [src.money]"
			if(donate=="+30000 Money | Cost: 15"&&src.donation_points>=15)
				src.donation_points-=15
				src.money+=30000
				src << "Donation Points left: [src.donation_points]"
				src << "The amount of money you currently got is [src.money]"
			if(donate=="Eternal Mangekyou (Sasuke) | Cost: 30"&&src.donation_points>=30&&src.clan=="Uchiha")
				src.donation_points-=30
				src:AddSkill(ETERNAL_MANGEKYOU_SHARINGAN_SASUKE)
				src.RefreshSkillList()
				src << "Donation Points left: [src.donation_points]"
				src << "Please Relog"
			if(donate=="Eternal Mangekyou (Itachi) | Cost: 30"&&src.donation_points>=30&&src.clan=="Uchiha")
				src.donation_points-=30
				src:AddSkill(ETERNAL_MANGEKYOU_SHARINGAN_MADARA)
				src.RefreshSkillList()
				src << "Donation Points left: [src.donation_points]"
				src << "Please Relog"
			if(donate=="Membership 1 Month | Cost: 10"&&src.donation_points>=10)
				src.donation_points-=10
				src.Membership=1
				src.Membership_Time=time2text(world.realtime,"DD:hh")
				member_name="<font color=#01DF01>[src.name]"
				src.name=member_name
				src.realname=member_name
				src << "You have brought Membership: 1 Month"
				src << "Donation Points left: [src.donation_points]"
			if(donate=="Membership 2 Month | Cost: 15"&&src.donation_points>=15)
				src.donation_points-=15
				member_name="<font color=#01DF01>[src.name]"
				src.name=member_name
				src.realname=member_name
				src.Membership_2_Month=1
				src.Membership_Time_2=time2text(world.realtime,"DD:hh")
				src << "You have brought Membership: 2 Months"
				src << "Donation Points left: [src.donation_points]"
			if((donate=="Membership 1 Month | Cost: 25"||donate=="Membership 2 Month | Cost: 40")&&(src.donation_points>=15||src.donation_points>=10)&&(src.Membership||src.Membership_2_Month))
				src << "Please wait until your membership runs out and renew it"
			if((donate=="Eternal Mangekyou (Sasuke) | Cost: 30"||donate=="Eternal Mangekyou (Itachi) | Cost: 30")&&src.donation_points>=30&&!src.clan=="Uchiha")
				src << "You have to be an uchiha to get this skill"
			if(donate=="Cancel")
				return
		Donation_Prices()
			var/window = {"
<html>
<head>
<style>
body {background: black; color: white}
</style>
</head>
<body>
<center>
<font face=cambria>
<b>
<u><font size=3>Donation Point Prices</u>
<br>
<br><font colour=#58D3F7><font size=2>£0.60 or $1.00 : 1 point
<br><font colour=#58D3F7><font size=2>£7 or $15.00 : 15 points
<br><font colour=#58D3F7><font size=2>£17 or $25.00 : 25 points
<br><font colour=#58D3F7><font size=2>£25 or $35.00 : 35 points
<br><font colour=#58D3F7><font size=2>£35 or $ 40.00 : 45 points
<br>
<font color=red>Terms of Donating: You will not be refunded for any reason so don't ask for a refund once you donated.</font>
<form action="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CASSVGV58GTPQ" method="post">
<input type="" name="" value="">
</form>
<br>
<u><font colour=#58D3F7><font size=3>Naruto Goa Chronicles </u>
<br>
</b>
</font>
</center>
</body>
</html>
</b>
</font>
</center>
</body>
</html>
"}
			usr << browse(window,"window=Updates;size=300x300")
			..()

mob
	proc
		Auto_Set_Level(mob/human/player/M in All_Clients(), level as num)
			level = min(200, level)
			while(M && M.blevel < level)
				M.body=Req2Level(M.blevel)+1
				M.bodycheck()
				sleep(4)
			usr<<"Complete!"