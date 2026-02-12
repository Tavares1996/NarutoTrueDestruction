//Damage coding for s_damage

#ifndef S_DAMAGE_ICON
#define S_DAMAGE_ICON 's_blacknums.dmi'
#endif

obj/s_damage_num
	layer = FLY_LAYER
	name = " "
	icon_state = ""

proc
	Miss(mob, color)
		if(!findtext(color,"#"))
			color = colour2html(color)
		if(!mob)
			return
		var/icon/O = new
		O.icon = S_DAMAGE_ICON
		O:icon_state = "Miss"
		O += color
		if(mob)
			O:loc = mob:loc
		else
			return
		spawn(1)
			if(O) O:pixel_y++
		spawn(1)
			if(O) O:pixel_y++
		spawn(1)
			if(O) O:pixel_y++
		spawn(1)
			if(O) O:pixel_y++
		spawn(1)
			if(O) O:pixel_y++
		spawn(10)
			if(O)
				O:loc = null

//Dont use this proc, this is a poor damage code
proc/super_damage(ref, num, colour)
	if(!findtext(colour,"#"))
		colour = colour2html(colour)

	//Create a new icon copy and set its colour.
	var/icon = S_DAMAGE_ICON
	icon += colour

	num = round(num,1)

	if(num > 9999)
		num = 9999

	var/string = num2text(num)
	var/first_char
	var/second_char
	var/third_char
	var/fourth_char
	var/obj/s_damage_num/first
	var/obj/s_damage_num/second
	var/obj/s_damage_num/third
	var/obj/s_damage_num/fourth

	if(lentext(string) == 1)
		first_char = copytext(string,1,2)
		first = new

	if(lentext(string) == 2)
		second_char = copytext(string,1,2)
		second = new
		first_char = copytext(string,2,3)
		first = new

	if(lentext(string) == 3)
		third_char = copytext(string,1,2)
		third = new
		second_char = copytext(string,2,3)
		second = new
		first_char = copytext(string,3,4)
		first = new

	if(lentext(string) == 4)
		fourth_char = copytext(string,1,2)
		fourth = new
		third_char = copytext(string,2,3)
		third = new
		second_char = copytext(string,3,4)
		second = new
		first_char = copytext(string,4,5)
		first = new

	var/target = ref
	if(ismob(ref) || isobj(ref)) target = ref:loc

	if(first)  first.loc = target
	if(second) second.loc = target
	if(third)  third.loc = target
	if(fourth) fourth.loc = target

	if(first)
		first.icon = icon
		flick("---[first_char]",first)
	if(second)
		second.icon = icon
		flick("--[second_char]-",second)
	if(third)
		third.icon = icon
		flick("-[third_char]--",third)
	if(fourth)
		fourth.icon = icon
		flick("[fourth_char]---",fourth)

	spawn(1)
		if(first) first.pixel_y++
		if(second) second.pixel_y++
		if(third) third.pixel_y++
		if(fourth) fourth.pixel_y++
	spawn(1)
		if(first) first.pixel_y++
		if(second) second.pixel_y++
		if(third) third.pixel_y++
		if(fourth) fourth.pixel_y++
	spawn(1)
		if(first) first.pixel_y++
		if(second) second.pixel_y++
		if(third) third.pixel_y++
		if(fourth) fourth.pixel_y++
	spawn(1)
		if(first) first.pixel_y++
		if(second) second.pixel_y++
		if(third) third.pixel_y++
		if(fourth) fourth.pixel_y++

	spawn(10)
		if(first)  first.loc = null
		if(second) second.loc = null
		if(third)  third.loc = null
		if(fourth) fourth.loc = null

world/New()
	..()
	HtmlAssosciate("aliceblue","f0f8ff")
	HtmlAssosciate("antiquewhite","faebd7")
	HtmlAssosciate("aqua","00ffff")
	HtmlAssosciate("aquamarine","7fffd4")
	HtmlAssosciate("azure","f0ffff")
	HtmlAssosciate("beige","f5f5dc")
	HtmlAssosciate("bisque","ffe4c4")
	HtmlAssosciate("#000000","000000")
	HtmlAssosciate("blanchedalmond","ffebcd")
	HtmlAssosciate("blue","0000ff")
	HtmlAssosciate("blueviolet","8a2be2")
	HtmlAssosciate("brown","a52a2a")
	HtmlAssosciate("burlywood","deb887")
	HtmlAssosciate("cadetblue","5f9ea0")
	HtmlAssosciate("chartreuse","7fff00")
	HtmlAssosciate("chocolate","d2691e")
	HtmlAssosciate("coral","ff7f50")
	HtmlAssosciate("cornflowerblue","6495ed")
	HtmlAssosciate("cornsilk","fff8dc")
	HtmlAssosciate("crimson","dc143c")
	HtmlAssosciate("cyan","00ffff")
	HtmlAssosciate("darkblue","00008b")
	HtmlAssosciate("darkcyan","008b8b")
	HtmlAssosciate("darkgoldenrod","b8b60b")
	HtmlAssosciate("darkgrey","a9a9a9")
	HtmlAssosciate("darkgreen","006400")
	HtmlAssosciate("darkkhaki","bdb76b")
	HtmlAssosciate("darkmagenta","8b008b")
	HtmlAssosciate("darkolivegreen","556b2f")
	HtmlAssosciate("darkorange","ff8c00")
	HtmlAssosciate("darkorchid","9932cc")
	HtmlAssosciate("darkred","8b0000")
	HtmlAssosciate("darksalmon","e9967a")
	HtmlAssosciate("darkseagreen","8fbc8f")
	HtmlAssosciate("darkslateblue","483d8b")
	HtmlAssosciate("darkslategray","2f4f4f")
	HtmlAssosciate("darkturquoise","00ced1")
	HtmlAssosciate("darkviolet","9400d3")
	HtmlAssosciate("deeppink","ff1493")
	HtmlAssosciate("deepskyblue","00bfff")
	HtmlAssosciate("dimgrey","696969")
	HtmlAssosciate("dodgerblue","1e90ff")
	HtmlAssosciate("firebrick","b22222")
	HtmlAssosciate("floralwhite","fffaf0")
	HtmlAssosciate("forestgreen","228b22")
	HtmlAssosciate("fuchsia","ff00ff")
	HtmlAssosciate("gainsboro","dcdcdc")
	HtmlAssosciate("ghostwhite","f8f8ff")
	HtmlAssosciate("gold","ffd700")
	HtmlAssosciate("goldenrod","daa520")
	HtmlAssosciate("grey","808080")
	HtmlAssosciate("green","008000")
	HtmlAssosciate("greenyellow","adff2f")
	HtmlAssosciate("honeydew","f0fff0")
	HtmlAssosciate("hotpink","ff69b4")
	HtmlAssosciate("indianred","cd5c5c")
	HtmlAssosciate("indigo","4b0082")
	HtmlAssosciate("ivory","fffff0")
	HtmlAssosciate("khaki","f0e68c")
	HtmlAssosciate("lavender","e6e6fa")
	HtmlAssosciate("lavenderblush","fff0f5")
	HtmlAssosciate("lawngreen","7cfc00")
	HtmlAssosciate("lemonchiffon","fffacd")
	HtmlAssosciate("lightblue","add8e6")
	HtmlAssosciate("lightcoral","f08080")
	HtmlAssosciate("lightcyan","e0ffff")
	HtmlAssosciate("lightgoldenrodyellow","fafad2")
	HtmlAssosciate("lightgreen","90ee90")
	HtmlAssosciate("lightgrey","d3d3d3")
	HtmlAssosciate("lightpink","ffb6c1")
	HtmlAssosciate("lightsalmon","ffa07a")
	HtmlAssosciate("lightseagreen","20b2aa")
	HtmlAssosciate("lightskyblue","87cefa")
	HtmlAssosciate("lightslategrey","778899")
	HtmlAssosciate("lightsteelblue","b0c4de")
	HtmlAssosciate("lightyellow","ffffe0")
	HtmlAssosciate("lime","00ff00")
	HtmlAssosciate("limegreen","32cd32")
	HtmlAssosciate("linen","faf0e6")
	HtmlAssosciate("magenta","ff00ff")
	HtmlAssosciate("maroon","800000")
	HtmlAssosciate("mediumaquamarine","66cdaa")
	HtmlAssosciate("mediumblue","0000cd")
	HtmlAssosciate("mediumorchid","ba55d3")
	HtmlAssosciate("mediumpurple","9370db")
	HtmlAssosciate("mediumseagreen","3cb371")
	HtmlAssosciate("mediumslateblue","7b68ee")
	HtmlAssosciate("mediumspringgreen","00fa9a")
	HtmlAssosciate("mediumturquoise","48d1cc")
	HtmlAssosciate("mediumvioletred","c71585")
	HtmlAssosciate("midnightblue","191970")
	HtmlAssosciate("mintcream","f5fffa")
	HtmlAssosciate("mistyrose","ffe4e1")
	HtmlAssosciate("moccasin","ffe4b5")
	HtmlAssosciate("navajowhite","ffdead")
	HtmlAssosciate("navy","000080")
	HtmlAssosciate("oldlace","fdf5e6")
	HtmlAssosciate("olive","808000")
	HtmlAssosciate("olivedrab","6b8e23")
	HtmlAssosciate("orange","ffa500")
	HtmlAssosciate("orangered","ff4500")
	HtmlAssosciate("orchid","da70d6")
	HtmlAssosciate("palegoldenrod","eee8aa")
	HtmlAssosciate("palegreen","98fb98")
	HtmlAssosciate("paleturquoise","afeeee")
	HtmlAssosciate("palevioletred","db7093")
	HtmlAssosciate("papayawhip","ffefd5")
	HtmlAssosciate("peachpuff","ffdab9")
	HtmlAssosciate("peru","cd853f")
	HtmlAssosciate("pink","ffc0cd")
	HtmlAssosciate("plum","dda0dd")
	HtmlAssosciate("powderblue","b0e0e6")
	HtmlAssosciate("purple","800080")
	HtmlAssosciate("red","ff0000")
	HtmlAssosciate("rosybrown","bc8f8f")
	HtmlAssosciate("royalblue","4169e1")
	HtmlAssosciate("saddlebrown","8b4513")
	HtmlAssosciate("salmon","fa8072")
	HtmlAssosciate("sandybrown","f4a460")
	HtmlAssosciate("seagreen","2e8b57")
	HtmlAssosciate("seashell","fff5ee")
	HtmlAssosciate("sienna","a0522d")
	HtmlAssosciate("silver","c0c0c0")
	HtmlAssosciate("skyblue","87ceed")
	HtmlAssosciate("slateblue","6a5acd")
	HtmlAssosciate("slategray","708090")
	HtmlAssosciate("snow","fffafa")
	HtmlAssosciate("springgreen","00ff7f")
	HtmlAssosciate("steelblue","4682b4")
	HtmlAssosciate("tan","d2b48c")
	HtmlAssosciate("teal","008080")
	HtmlAssosciate("thistle","d8bfd8")
	HtmlAssosciate("tomato","ff6347")
	HtmlAssosciate("turquoise","40e0d0")
	HtmlAssosciate("violet","ee82ee")
	HtmlAssosciate("wheat","f5deb3")
	HtmlAssosciate("white","ffffff")
	HtmlAssosciate("whitesmoke","f5f5f5")
	HtmlAssosciate("yellow","ffff00")
	HtmlAssosciate("yellowgreen","a9cd32")

var/html_colours[0]

proc/HtmlAssosciate(colour, html)
	html_colours["[colour]"] = html


proc/colour2html(colour)
	var/T
	for(T in html_colours)
		if(T == colour) break
	if(!T)
		world.log << "Warning!  Could not find matching colour entry for '[colour]'."
		return "#FFFFFF"

	return ("#" + uppertext(html_colours["[colour]"]) )




//--------------Arty's Damage Coding--------------------------\\

#include "Cache.dm"

#define F_DAMAGE_LOG(SEVERITY, MSG) world.log << "\[[SEVERITY] - f_damage\] [MSG]"

#if defined(F_damage_log_errors) && !defined(F_damage_suppress_errors)
	#define F_DAMAGE_ERROR(MSG) F_DAMAGE_LOG("ERROR", MSG)
#else
	#define F_DAMAGE_ERROR(MSG)
#endif

#if defined(F_damage_log_warnings) && !defined(F_damage_suppress_warnings)
	#define F_DAMAGE_WARNING(MSG) F_DAMAGE_LOG("WARNING", MSG)
#else
	#define F_DAMAGE_WARNING(MSG)
#endif

#if defined(F_damage_log_verbose) && !defined(F_damage_suppress_verbose)
	#define F_DAMAGE_VERBOSE(MSG) F_DAMAGE_LOG("INFO", MSG)
#else
	#define F_DAMAGE_VERBOSE(MSG)
#endif

// Magic characters etc.
#define F_DAMAGE_POUND 	 35
#define ZERO 	 48
#define NINE 	 57
#define UPPER_A  65
#define UPPER_F  70
#define LOWER_A  97
#define LOWER_F  102
#define OUT_RANGE(VALUE, MIN, MAX) (VALUE < MIN || VALUE > MAX)

var/__f_damage_Cache/f_damage_cache = new()

obj/F_damage_num
	layer 		= F_damage_layer
	name 		= ""
	icon_state 	= ""
	var
		F_damageValue

proc/s_damage(atom/Target, value, color = "#ff0000", F_Damage_Horizontal_Alignment/halign = F_Damage.CENTER_ALIGN)
	if (istext(color) && text2ascii(color) != F_DAMAGE_POUND)
		color = "#[color]"
	if (!F_validColor(color))
		F_DAMAGE_ERROR("[color] passed to F_damage is not a valid color, context: [Target], [value]")
		return
	if (!isnum(value))
		F_DAMAGE_ERROR("[value] passed to F_damage is not a valid number, context: [Target], [value]")
		return
	if (!istype(Target))
		F_DAMAGE_ERROR("[Target] passed to F_damage is not at least an /atom, context: [Target], [value]")
		return
	var/list/numbers 	= new()
	var/textValue    	= num2text(value, F_Damage_sig_figures)
	var/length		 	= length(textValue)
	var/icon/targetIcon = icon(Target.icon, Target.icon_state, Target.dir) // Here's to hoping this is cheap.
	var/width			= targetIcon.Width()
	var/height			= targetIcon.Height()
	var/icon/I = f_damage_cache.get(color)
	if (I == null)
		I = new(F_damage_icon)
		I.Blend(color, ICON_MULTIPLY)
		f_damage_cache.put(color, I)
	for (var/i in 1 to length)
		var/obj/F_damage_num/O = new()
		halign.align(O, width, length, i)
		O.icon    = I
		O.pixel_y = Target.pixel_y + (height - 7)
		O.F_damageValue = copytext(textValue, i, i + 1)
		numbers += O
	if(ismob(Target) || isobj(Target))
		Target = Target.loc
	for(var/obj/F_damage_num/O in numbers)
		O.loc = Target
		flick(O.F_damageValue, O)
		spawn(10)
			del O

proc/F_validColor(value)
	if (!istext(value))
		F_DAMAGE_WARNING("[value] passed to F_validColor was not a text string")
		return FALSE
	if (text2ascii(value) != F_DAMAGE_POUND)
		F_DAMAGE_WARNING("[value] passed to F_validColor does not begin with #")
		return FALSE
	var/length = length(value)
	if (length != 7 && length != 4)
		F_DAMAGE_WARNING("[value] passed to F_validColor is [length] chars long, expecting 4 or 7")
		return FALSE
	for(var/i in (2 to length))
		var/char = text2ascii(value, i)
		if (OUT_RANGE(char, ZERO, NINE) && OUT_RANGE(char, LOWER_A, LOWER_F) && OUT_RANGE(char, UPPER_A, UPPER_F))
			F_DAMAGE_WARNING("[value] passed to F_validColor has an invalid char at position [i], must be 0-9 or a-f or A-F")
			return FALSE
	F_DAMAGE_VERBOSE("[value] passed to F_validColor is a valid colour")
	return TRUE

#undef F_DAMAGE_LOG
#undef F_DAMAGE_ERROR
#undef F_DAMAGE_WARNING
#undef F_DAMAGE_VERBOSE
#undef F_DAMAGE_POUND
#undef ZERO
#undef NINE
#undef UPPER_A
#undef UPPER_F
#undef LOWER_A
#undef LOWER_F
#undef OUT_RANGE
