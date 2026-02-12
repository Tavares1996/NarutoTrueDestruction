mob/human/var

	show_name = 1
	tmp/image/name_img[]

mob/human
	New()

		. = ..()
		spawn(1)CreateName(255, 255, 255)
	Login()
		CreateName(255, 255, 255, 0, 0, 0)
		. = ..()

	proc/CreateName(r=255, g=255, b=255, br=0, bg=0, bb=0)
		if(!show_name) return
		if(name=="player")return

		if(name_img && istype(name_img,/list) && name_img.len)
			for(var/image/I in name_img)
				del I

		name_img = new /list()

	MouseEntered()
		if(show_name)
			for(var/image/I in name_img)
				usr.client.images += I
		. = ..()
	MouseExited()
		if(show_name)
			for(var/image/I in name_img)
				usr.client.images -= I
		. = ..()