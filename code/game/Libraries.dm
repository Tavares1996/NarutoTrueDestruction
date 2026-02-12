//cursors
#define Default_Cursor 0
#define Client_Cursor 1
#define Server_Cursor 2


//conversions
#define TEXT_CONV 1
#define RSC_FILE_CONV 2
#define NUMBER_CONV 3


//column flag values:
#define IS_NUMERIC 1
#define IS_BINARY 2
#define IS_NOT_NULL 4
#define IS_PRIMARY_KEY 8
#define IS_UNSIGNED 16


//types
#define TINYINT 1
#define SMALLINT 2
#define MEDIUMINT 3
#define INTEGER 4
#define BIGINT 5
#define DECIMAL 6
#define FLOAT 7
#define DOUBLE 8
#define DATE 9
#define DATETIME 10
#define TIMESTAMP 11
#define TIME 12
#define STRING 13
#define BLOB 14
// TODO: Investigate more recent type additions and see if I can handle them. - Nadrew


var
	DB_SERVER = "localhost" // This is the location of your MySQL server (localhost is USUALLY fine)
	DB_PORT = 3306 // This is the port your MySQL server is running on (3306 is the default)

DBConnection
	New(dbi_handler,username,password_handler,cursor_handler)
		src.dbi = dbi_handler
		src.user = username
		src.password = password_handler
		src.default_cursor = cursor_handler
		_db_con = _dm_db_new_con()
	proc
		Connect(dbi_handler=src.dbi,user_handler=src.user,password_handler=src.password,cursor_handler)
			if(!src) return 0
			cursor_handler = src.default_cursor
			if(!cursor_handler) cursor_handler = Default_Cursor
			return _dm_db_connect(_db_con,dbi_handler,user_handler,password_handler,cursor_handler,null)

		Disconnect() return _dm_db_close(_db_con)

		IsConnected() return _dm_db_is_connected(_db_con)

		Quote(str) return _dm_db_quote(_db_con,str)

		ErrorMsg() return _dm_db_error_msg(_db_con)
		SelectDB(database_name,dbi)
			if(IsConnected()) Disconnect()
			return Connect("[dbi?"[dbi]":"dbi:mysql:[database_name]:[DB_SERVER]:[DB_PORT]"]",user,password)
		NewQuery(sql_query,cursor_handler=src.default_cursor) return new/DBQuery(sql_query,src,cursor_handler)

	var
		_db_con // This variable contains a reference to the actual database connection.
		dbi // This variable is a string containing the DBI MySQL requires.
		user // This variable contains the username data.
		password // This variable contains the password data.
		default_cursor // This contains the default database cursor data.
		//
		server = "localhost"
		port = 3306

DBQuery
	New(sql_query,DBConnection/connection_handler,cursor_handler)
		if(sql_query) src.sql = sql_query
		if(connection_handler) src.db_connection = connection_handler
		if(cursor_handler) src.default_cursor = cursor_handler
		_db_query = _dm_db_new_query()
		return ..()

	proc

		Connect(DBConnection/connection_handler) src.db_connection = connection_handler

		Execute(sql_query=src.sql,cursor_handler=default_cursor)
			Close()
			return _dm_db_execute(_db_query,sql_query,db_connection._db_con,cursor_handler,null)

		NextRow() return _dm_db_next_row(_db_query,item,conversions)

		RowsAffected() return _dm_db_rows_affected(_db_query)

		RowCount() return _dm_db_row_count(_db_query)

		ErrorMsg() return _dm_db_error_msg(_db_query)

		Columns()
			if(!columns)
				columns = _dm_db_columns(_db_query,/DBColumn)
			return columns

		GetRowData()
			var/list/columns = Columns()
			var/list/results
			if(columns.len)
				results = list()
				for(var/C in columns)
					results+=C
					var/DBColumn/cur_col = columns[C]
					results[C] = src.item[(cur_col.position+1)]
			return results

		Close()
			item.len = 0
			columns = null
			conversions = null
			return _dm_db_close(_db_query)

		Quote(str)
			return db_connection.Quote(str)

		SetConversion(column,conversion)
			if(istext(column)) column = columns.Find(column)
			if(!conversions) conversions = new/list(column)
			else if(conversions.len < column) conversions.len = column
			conversions[column] = conversion

	var
		sql // The sql query being executed.
		default_cursor
		list/columns //list of DB Columns populated by Columns()
		list/conversions
		list/item[0]  //list of data values populated by NextRow()

		DBConnection/db_connection
		_db_query

DBColumn
	var
		name
		table
		position //1-based index into item data
		sql_type
		flags
		length
		max_length

	New(name_handler,table_handler,position_handler,type_handler,flag_handler,length_handler,max_length_handler)
		src.name = name_handler
		src.table = table_handler
		src.position = position_handler
		src.sql_type = type_handler
		src.flags = flag_handler
		src.length = length_handler
		src.max_length = max_length_handler
		return ..()

	proc
		SqlTypeName(type_handler=src.sql_type)
			switch(type_handler)
				if(TINYINT) return "TINYINT"
				if(SMALLINT) return "SMALLINT"
				if(MEDIUMINT) return "MEDIUMINT"
				if(INTEGER) return "INTEGER"
				if(BIGINT) return "BIGINT"
				if(FLOAT) return "FLOAT"
				if(DOUBLE) return "DOUBLE"
				if(DATE) return "DATE"
				if(DATETIME) return "DATETIME"
				if(TIMESTAMP) return "TIMESTAMP"
				if(TIME) return "TIME"
				if(STRING) return "STRING"
				if(BLOB) return "BLOB"

/*
	DmiFontsPlus library by Lummox JR
	version 2.0	-- updated for BYOND 455 and above

	Draw text on the map using pre-rendered variable-width fonts.

	This is based on the earlier DmiFonts library but changes several features.
 */

var/const
	DF_WRAP=0
	DF_WRAP_NONE=1
	DF_WRAP_ELLIPSIS=2      // constrain last allowable line (if any) with ellipses
	DF_WRAP_ONELINE=3       // constrain each line with ellipses
	DF_WRAP_MASK=3
	DF_JUSTIFY=12
	DF_JUSTIFY_LEFT=0
	DF_JUSTIFY_RIGHT=4
	DF_JUSTIFY_CENTER=8
	DF_BREAK_FIRST=128      // GetLines() may consider a break point just before the first char
	DF_INCLUDE_AC=64        // Include leading A width and trailing C width in GetWidth() or in DrawText()
	DF_SET_WIDTH=256        // Set width to the highest multiple of 32 that will fit
	DF_NO_FORMAT=4096       // skip pre-formatting via GetLines() in DrawText()



dmifont
	var/name
	var/height      	// total height of a line
	var/ascent      	// distance above baseline (including whitespace)
	var/descent     	// distance below baseline (")
	var/avgwidth    	// average character width (")
	var/maxwidth    	// maximum character width (")
	var/overhang    	// extra width, such as from italics, for a line
	var/inleading   	// internal leading vertical space, for accent marks
	var/exleading   	// external leading vertical space, just plain blank
	var/defchar     	// default character (for undefined chars)
	var/start       	// first character
	var/end         	// last character

	/*
		In a future version of the DmiFontsPlus utility, these vars
		will be set to indicate a tile size other than 32x32 for the
		icon.
	 */
	var/tile_width_used	// tile size for files created by the DmiFontsPlus program
	var/tile_height_used
	var/icon_width_used
	var/icon_height_used

	// the source icon file
	/*
		This may be a text string to avoid resource problems, but it
		must be manually packaged.
	 */
	var/icon

	/*
		Anti-aliasing is supported via n×n squares. Essentially the font is
		rendered n times larger by the utility, and there's n×n times as much
		data. Do not set this var manually to display your font with
		anti-aliasing; it will do nothing.
	 */
	var/antialias=1

	var/tmp/ellipsiswidth=0	// width of an ellipsis, minus the C width of the last character
	var/tmp/hyphenwidth=0	// width of a hyphen, minus the C width of the last character
	var/tmp/hyphenwidthfull=0	// width of a hyphen, complete
	var/tmp/maxjustify=0

	/*
		A font's A,B,C widths starting from the first character.

		A	space to add before character
		B	space to add during character (width)
		C	space to add after character
	 */
	var/list/metrics

	var/list/defined

	var/tmp/sizex=1			// number of icons horizontally per char
	var/tmp/sizey=1			// number of icons vertically per char
	var/tmp/use_tiles

	var/tmp/tile_width
	var/tmp/tile_height
	var/tmp/icon_width
	var/tmp/icon_height
	var/tmp/icon_native
	var/tmp/blank_icon = 'blank.dmi'

	New()
#if DM_VERSION >= 455
		if(istext(world.icon_size))
			var/i = findtext(world.icon_size, "x")
			icon_width = text2num(copytext(world.icon_size, 1, i))
			icon_height = text2num(copytext(world.icon_size, i+1))
		else
			icon_width = world.icon_size
			icon_height = world.icon_size
		icon_native = !(world.map_format & TILED_ICON_MAP)
		if(!icon_native && (icon_width < 32 || icon_height < 32))	// avoid tiling
			var/icon/I = new('blank.dmi')
			I.Crop(icon_width, icon_height)
			blank_icon = fcopy_rsc(I)
#else
		icon_width = 32
		icon_height = 32
		icon_native = 0
#endif

		if(istext(icon)) icon=file(icon)
		var/preshift_height = 0
		if(!icon_native)
			if(!tile_width_used) tile_width_used = icon_width
			if(!tile_height_used)
				tile_height_used = icon_height
				if(tile_height_used != 32)
					/*
						Prior to BYOND 455 all icon sizes were multiples of 32. In
						tiled icon mode, they would be aligned to the lower tile
						boundary instead of the top. Any icons generated in the old
						format may need to be shifted north fix this alignment, so
						find out what tile size the icon would have been working with.

						This does not apply if the icon_size in use by the world has
						a height of 32, since then the alignment is always correct.
					 */
					preshift_height = max(1,round((height+31)/32)) * 32
		else
			/*
				Native icon mode. The only important thing here is to get the true
				icon size info. If not specified, assume the icons were generated
				in multiple-of-32x32 tiled form.
			 */
			if(!tile_width_used) tile_width_used = 32
			if(!tile_height_used) tile_height_used = 32
		sizex=max(1,round((maxwidth+tile_width_used-1)/tile_width_used))
		sizey=max(1,round((height+tile_height_used-1)/tile_height_used))
		if(!icon_width_used) icon_width_used = sizex * tile_width_used
		if(!icon_height_used) icon_height_used = sizey * tile_height_used
		if(preshift_height && preshift_height < icon_height_used)
			/*
				Convert an old 32x32 icon format to whatever tiled size we are now
				using by alignging it to the top of the tile. This does not apply in
				native icon mode, or if the icon already has the right alignment.
			 */
			var/icon/I = new(icon)
			I.Shift(NORTH, icon_height_used - preshift_height)
			icon = I

		use_tiles = !icon_native && (sizex>1 || sizey>1)

		var/idx=(46-start)*3
		if(idx>0 && idx<metrics.len)
			ellipsiswidth=max(0,(metrics[idx+1]+metrics[idx+2])*3+metrics[idx+3]*2)
		idx-=3	// hyphen is 45
		if(idx>0 && idx<metrics.len)
			hyphenwidth=max(0,metrics[idx+1]+metrics[idx+2])
			hyphenwidthfull=max(0,metrics[idx+1]+metrics[idx+2]+metrics[idx+3])
		idx-=39
		if(idx>0 && idx<metrics.len)
			maxjustify=max(3,metrics[idx+1]+metrics[idx+2]+metrics[idx+3])
		if(!defined)
			defined=new
			while(defined.len<start-1 && defined.len<13) defined+=null
			for(var/ch=start,ch<=end,++ch)
				var/tf=ascii2text(ch)
				if(use_tiles)
					if("[tf]0,0" in icon_states(icon))
						defined+=tf
						continue
				else if(tf in icon_states(icon))
					defined+=tf
					continue
				defined+=null
			while(defined.len<255) defined+=null
// upgrade .dm file if called for
#ifdef DMIFONTS_UPGRADE
			var/shortname="[type]"
			var/i=findtext(shortname,"/",2)
			var/j=findtext(shortname,"/",i+1)
			while(i && j)
				i=j++
				j=findtext(shortname,"/",j)
			if(i) shortname=copytext(shortname,i+1)+".dm"
			if(fexists(shortname))
				var/txt=file2text(shortname)
				if(!findtextEx(txt,"\tdefined"))
					world.log << "Upgrading [shortname]"
					var/eol
					i=findtextEx(txt,"\tmetrics")
					j=i
					while(j>1) if(text2ascii(txt,--j)>13 || (j<i-1 && text2ascii(txt,j)==text2ascii(txt,i-1))) break
					eol=copytext(txt,j+1,i)
					j=findtext(txt,")"+eol,i)
					if(j)
						var/deftxt="\tdefined = list("
						// ASCII 255 doesn't output properly because it's used for some special DM characters
						for(i=1,i<=254,)
							deftxt+="\\"+eol+"\t\t"
							do
								if(isnull(defined[i])) deftxt+="null"
								else deftxt+=((i!=34 && i!=91 && i!=92)?"\"":"\"\\")+defined[i]+"\""
								if(i>=254)
									deftxt+=")"+eol
									++i
									break
								deftxt+=", "
							while((i++)%15)
						j+=length(eol)+1
						txt=copytext(txt,1,j)+eol+deftxt+copytext(txt,j)
						fdel(shortname)
						text2file(txt,shortname)
					else
						world.log << "Upgrade of [shortname] unsuccessful."
#endif
		// minor workaround for no output of ASCII 255
		else if(defined.len<255)
			if(end<255) defined+=null
			else
				var/tf=text2ascii(255)
				if(use_tiles)
					defined+=("[tf]0,0" in icon_states(icon))?(tf):null
				else defined+=tf


	/*
		The flags argument supports partially-monospaced fonts.
		The DF_INCLUDE_AC flag is the only flag recognized by this proc.
	 */
	proc/GetWidth(text, flags=0, firstline=0)
		.=0
		var/longest=0
		if(!length(text)) return
		var/i=1
		var/idx
		while(i<=length(text))
			var/ch=text2ascii(text,i++)
			if(ch<=10)
				if(ch<=7) .+=ch		// spacers for justification
				if(ch<=9) continue	// soft-break chars
				if(. && idx && !(flags&DF_INCLUDE_AC)) .-=max(metrics[idx+3],0)
				longest=max(longest,.+firstline)
				.=0
				firstline=0
				idx=0
				continue
			idx=(ch-start)*3
			if(idx<=0 || idx>=metrics.len) idx=(defchar-start)*3
			if(!. && !(flags&DF_INCLUDE_AC)) .-=metrics[idx+1]
			.+=metrics[idx+1]+metrics[idx+2]+metrics[idx+3]
		if(. && idx && !(flags&DF_INCLUDE_AC)) .-=max(metrics[idx+3],0)
		.=max(.+firstline,longest)
		if(.>0) .+=overhang

	proc/GetCharAWidth(ch)
		var/idx=(ch-start)*3
		if(idx<=0 || idx>=metrics.len) idx=(defchar-start)*3
		return metrics[idx+1]
	proc/GetCharBWidth(ch)
		var/idx=(ch-start)*3
		if(idx<=0 || idx>=metrics.len) idx=(defchar-start)*3
		return metrics[idx+2]
	proc/GetCharCWidth(ch)
		var/idx=(ch-start)*3
		if(idx<=0 || idx>=metrics.len) idx=(defchar-start)*3
		return metrics[idx+3]
	proc/GetCharWidth(ch)
		var/idx=(ch-start)*3
		if(idx<=0 || idx>=metrics.len) idx=(defchar-start)*3
		return metrics[idx+1]+metrics[idx+2]+metrics[idx+3]

	// this is for just one line
	// return value is the index where a break occurred
	// DF_INCLUDE_AC is ignored for the trailing ellipsis (if any)
	proc/GetLineUpTo(text,xlimit,index=1,ellipsis,flags)
		var/w=0
		var/adjw=0
		var/idx
		var/breakpoint=flags&DF_BREAK_FIRST?(index):0
		var/preepoint=index		// pre-ellipsis, no break
		var/lastch=32
		var/i=index
		var/ac=flags&DF_INCLUDE_AC
		while(i<=length(text) && adjw<=xlimit)
			var/ch=text2ascii(text,i)
			if(ch==10) break
			if(lastch!=32)
				if(ch==32 || ch==9)
					if((ellipsis?(w+ellipsiswidth):adjw)<=xlimit)
						breakpoint=i
				else if(ch==8)
					if(w+(ellipsis?(hyphenwidthfull+ellipsiswidth):(ac?(hyphenwidthfull):hyphenwidth))<=xlimit)
						breakpoint=i
			++i
			lastch=ch
			idx=(ch-start)*3
			if(idx<=0 || idx>=metrics.len) idx=(defchar-start)*3
			if(!w && !ac) w-=metrics[idx+1]
			w+=metrics[idx+1]+metrics[idx+2]+metrics[idx+3]
			adjw=ac?(w):(w-max(metrics[idx+3],0))
			if((ellipsis?(w+ellipsiswidth):adjw)<=xlimit) preepoint=i
		if(adjw<=xlimit) return i
		if(breakpoint) return breakpoint
		return max(preepoint,index+1)


	// returns an x position; y you can calculate
	proc/GetNextPosition(lastlines, nexttext, dmifont/nextfont, lastindent=0, flags=0)
		if(!nextfont) nextfont=src
		if(flags&DF_INCLUDE_AC)
			return GetWidth(copytext(lastlines,GetLastLineIndex(lastlines)),DF_INCLUDE_AC)
		var/i=1
		var/j=findtext(lastlines,"\n")
		while(j)
			i=++j
			j=findtext(lastlines,"\n",j)
		if(i>length(lastlines)) return 0
		.=i>1?0:lastindent
		.+=GetWidth(copytext(lastlines,i))+GetCharCWidth(text2ascii(lastlines,length(lastlines)))
		if(length(nexttext))
			.+=nextfont.GetCharAWidth(text2ascii(nexttext))


	proc/CountLines(text)
		.=1
		var/i=findtext(text,"\n")
		while(i)
			++.
			i=findtext(text,"\n",i+1)

	proc/CountLinesConstrained(text, width=-1, flags=0, firstline=0)
		return CountLines(GetLines(text,width,flags,firstline))

	proc/GetWidthConstrained(text, width=-1, flags=0, firstline=0, maxlines=-1)
		return GetWidth(GetLines(text,width,flags,firstline,maxlines),flags)

	proc/GoodBreaks(text, width=-1, flags=0, firstline=0)
		var/i=1
		var/j
		var/line1=1
		do
			if(width<0 || (flags&DF_WRAP_NONE)) j=findtext(text,"\n",i)
			else j=GetLineUpTo(text,line1?(width-firstline):width,i,(flags&DF_WRAP_MASK)==DF_WRAP_ONELINE,flags)
			line1=0
			if(j && j<=length(text))
				var/ch=text2ascii(text,j)
				if(ch>10 && ch!=32) return 0
			i=j?(GetNextIndex(text,((flags&DF_WRAP_MASK)==DF_WRAP_ONELINE)?findtext(text,"\n",j):j)):0
		while(i)
		return 1

	proc/WillFit(text, width=-1, flags=0, firstline=0, maxlines=-1)
		var/nlines=0
		var/i=1
		var/j
		var/line1=1
		do
			++nlines
			if(width<0 || (flags&DF_WRAP_NONE)) j=findtext(text,"\n",i)
			else j=GetLineUpTo(text,line1?(width-firstline):width,i,(flags&DF_WRAP_MASK)==DF_WRAP_ONELINE,flags)
			line1=0
			if(j && j<=length(text))
				var/ch=text2ascii(text,j)
				if(ch>10 && ch!=32) return 0
			i=j?(GetNextIndex(text,((flags&DF_WRAP_MASK)==DF_WRAP_ONELINE)?findtext(text,"\n",j):j)):0
			if(nlines>=maxlines && maxlines>=0) return !i
		while(i)
		return 1

	proc/GetLines(text, width=-1, flags=0, firstline=0, maxlines=-1, list/leftover)
		var/nlines=0
		var/i=1
		var/j
		var/line1=1
		var/startofline=1		// for full justification
		do
			++nlines
			if(width<0 || (flags&DF_WRAP_MASK)==DF_WRAP_NONE) j=findtext(text,"\n",i)
			else j=GetLineUpTo(text,line1?(width-firstline):width,i,(flags&DF_WRAP_ELLIPSIS) && ((flags&DF_WRAP_NONE) || (maxlines>=0 && nlines>=maxlines)),flags)
			flags&=~DF_BREAK_FIRST
			if(j)
				var/ch=text2ascii(text,j)
				if(ch==10)
					startofline=j+1
				else
					if(ch==8)
						text=copytext(text,1,j)+"-"+copytext(text,j)
						++j
					// should this really exclude \n?
					if(flags&DF_WRAP_ELLIPSIS && j<=length(text) &&\
					   ((flags&DF_WRAP_NONE) || (maxlines>=0 && nlines>=maxlines)))
						text=copytext(text,1,j)+"..."+copytext(text,j)
						j+=3
			line1=0
			i=j?(GetNextIndex(text,((flags&DF_WRAP_MASK)==DF_WRAP_ONELINE)?findtext(text,"\n",j):j)):0
			// justification
			if(i && startofline<j && width>=0 && (flags&DF_JUSTIFY)==DF_JUSTIFY)
				var/widthleft=width-GetWidth(copytext(text,startofline,j),flags)
				var/cc=0
				var/spc=0
				var/spw=maxjustify
				var/cw=0
				for(var/spi=startofline,spi<j-1,++spi)
					var/ch=text2ascii(text,spi)
					if(ch<=10) continue
					if(ch==32) ++spc
					++cc
				if(spc*spw>=widthleft) spw=widthleft
				else
					spw*=spc
					cw=widthleft-spw
				var/spacc=0
				var/cacc=0
				var/spleft=spw
				var/cleft=cw
				for(var/spi=startofline+1,spi<j && cleft+spleft,++spi)
					var/ch=text2ascii(text,spi)
					if(ch<=10) continue
					var/space=0
					if(ch==32)
						cacc+=cw
						spacc+=spw
						if(cacc>=cc)
							var/cs=round(cacc/cc)
							cacc-=cs*cc
							space+=cs
							cleft-=cs
						if(spacc>=spc)
							var/sps=round(spacc/spc)
							spacc-=sps*spc
							space+=sps
							spleft-=sps
					else if(cleft)
						cacc+=cw
						if(cacc>=cc)
							var/cs=round(cacc/cc)
							cacc-=cs*cc
							space+=cs
							cleft-=cs
					if(space>0)
						var/spacer=""
						while(space>0)
							spacer+=ascii2text(min(space,7))
							space-=min(space,7)
						text=copytext(text,1,spi)+spacer+copytext(text,spi)
						space=length(spacer)
						spi+=space
						j+=space
						i+=space
			// end of justification
			if(i && (maxlines<0 || nlines<maxlines))
				if(j) text=copytext(text,1,j)+"\n"+copytext(text,i)
				i=j+1
				startofline=i
			else
				if(leftover)
					leftover.Cut()
					if(i) leftover+=copytext(text,i)
				if(j) text=copytext(text,1,j)
			if(nlines>=maxlines && maxlines>=0)
				if(leftover && !i) leftover.Cut()
				if(i) text=copytext(text,1,i)
				break
		while(i)

		return text

	// returns the index of the point where text was cut off due to formatting
	// 0 if the text was finished
	proc/GetCutoffIndex(text, width=-1, flags=0, firstline=0, maxlines=-1)
		var/nlines=0
		var/i=1
		var/j
		var/line1=1
		do
			++nlines
			if(width<0 || (flags&DF_WRAP_MASK)==DF_WRAP_NONE) j=findtext(text,"\n",i)
			else j=GetLineUpTo(text,line1?(width-firstline):width,i,(flags&DF_WRAP_ELLIPSIS) && ((flags&DF_WRAP_NONE) || (maxlines>=0 && nlines>=maxlines)),flags)
			flags&=~DF_BREAK_FIRST
			line1=0
			i=j?(GetNextIndex(text,((flags&DF_WRAP_MASK)==DF_WRAP_ONELINE)?findtext(text,"\n",j):j)):0
			if(nlines>=maxlines && maxlines>=0)
				return i
		while(i)
		return 0

	proc/GetLine(text,index=1)
		return copytext(text,1,index?findtext(text,"\n",index):0)
	proc/GetLastLineIndex(text,index=1)
		if(!index) return 0
		var/i=findtext(text,"\n",index)
		while(i)
			index=i
			if(++index>length(text)) return 0
			i=findtext(text,"\n",index)
		return index

	// find the next starting point after a break
	proc/GetNextIndex(text,index)
		if(index<1 || index>length(text)) return 0
		var/ch=text2ascii(text,index)
		while(index<=length(text) && (ch==32 || ch<=10))
			++index
			if(ch==10) break	// skip just past the line break
			ch=text2ascii(text,index)
		if(index>length(text)) index=0
		return index

	// return the next-highest multiple of 32
	// this is for legacy purposes, deprecated in newer code using BYOND 455 or higher
	proc/RoundUp32(n)
		return (n+31)&~31

	// create a modified font with partial monospace
	// use DF_INCLUDE_AC to render text in this format
	proc/SyncWidth(firstchar, lastchar)
		firstchar=max(firstchar,start)
		lastchar=min(lastchar,end)
		var/dmifont/newfont=new type()
		var/mw=0
		// copy over unique changes
		for(var/V in vars)
			if(vars[V]!=initial(vars[V]))
				newfont.vars[V]=vars[V]
		// copy the metrics list; it will be modified
		// remember, other lists will be shared
		newfont.metrics=metrics.Copy()
		var/idx=(firstchar-start)*3
		for(var/i=firstchar,i<lastchar,++i)
			mw=max(mw,metrics[++idx]+metrics[++idx]+metrics[++idx])
		idx=(firstchar-start)*3+1
		for(var/i=firstchar,i<lastchar,{++i;idx+=3})
			var/w=mw-(metrics[idx]+metrics[idx+1]+metrics[idx+2])
			// modify the A and C widths to widen the character
			newfont.metrics[idx]+=round(w/2,1)
			newfont.metrics[idx+2]+=round(w/2)
		return newfont


	proc/DrawText(text, x, y, width=-1, flags=0, firstline=0, maxlines=-1, icons_x=0, icons_y=0, icon/drawover, list/leftover)
		x=round(x)
		y=round(y)
		var/list/indices=new
		var/nlines=0
		var/i=1
		var/j
		var/mw=0
		var/line1=1
		if(flags&DF_SET_WIDTH)
			width=round(((width<0?GetWidth(text):width)+icon_width-1)/icon_width)*icon_width
			if((flags&DF_JUSTIFY)==DF_JUSTIFY_CENTER) x+=round(width/2)
			else if((flags&DF_JUSTIFY)==DF_JUSTIFY_RIGHT) x+=width
		if(!(flags&DF_NO_FORMAT)) text=GetLines(text,width,flags&~DF_SET_WIDTH,firstline,maxlines,leftover)
		do
			++nlines
			j=findtext(text,"\n",i)
			indices+=i
			indices+=j
			if(j) i=j+1
			else i=0
		while(i)
		mw=GetWidth(text,flags)
		if(flags&DF_JUSTIFY)
			if((flags&DF_JUSTIFY)==DF_JUSTIFY_CENTER) mw+=x-(mw>>1)
		else
			mw+=x
		if(!icons_x) icons_x=round((mw+icon_width-1)/icon_width)
		if(!icons_y) icons_y=round((y+nlines*height+icon_height-1)/icon_height)
		var/icon/icout = drawover
		if(!icout)
			icout = new(blank_icon)
			icout.setpadding = (!icon_native && icons_x == 1 && icons_y == 1) ? 1 : 0
			icout.setwidth = icons_x + icout.setpadding
			icout.setheight = icons_y
			icout.fullwidth = icout.setwidth * icon_width
			icout.fullheight = icout.setheight * icon_height
			icout.Crop(icout.fullwidth, icout.fullheight)
		var/yy=y
		line1=1
		for(var/k=1,k<indices.len,yy+=height)
			i=indices[k++]
			j=indices[k++]
			if(!j) j=length(text)+1
			var/xx=x
			var/ch=text2ascii(text,i)
			var/idx=(ch-start)*3
			if(idx<0 || idx>=metrics.len) idx=(defchar-start)*3
			if(!(flags&DF_INCLUDE_AC)) xx-=metrics[idx+1]
			if(line1) xx+=firstline
			if((flags&DF_JUSTIFY) && (flags&DF_JUSTIFY)!=DF_JUSTIFY)
				var/w=GetWidth(copytext(text,i,j),flags)
				xx-=w
				if(flags&DF_JUSTIFY_CENTER) xx+=(w>>1)
			line1=0
			while(i<j)
				ch=text2ascii(text,i++)
				if(ch<10)
					if(ch<=7) xx+=ch	// spacers
					continue	// soft-break chars
				idx=(ch-start)*3
				if(idx<0 || idx>=metrics.len) idx=(defchar-start)*3
				xx+=metrics[idx+1]
				DrawChar(ch,xx,yy,icout,metrics[idx+2])
				xx+=metrics[idx+2]+metrics[idx+3]
		return icout

	proc/DrawChar(ch,x,y,icon/ic,B=maxwidth)
		ASSERT(src)				// this seems to avert some weird bugs if drawing is done at login
		var/tf=defined[ch]
		if(!tf) tf=defined[defchar]
#if DM_VERSION >= 455
		if(icon_native)
			//world.log << "Drawing character [tf] at [x],[y]"
			ic.Blend(new/icon(icon,tf),ICON_OR,x+1,ic.fullheight-icon_height_used-y+1)
		else if(use_tiles)
#else
		if(use_tiles)
#endif
			for(var/sy=0,sy<sizey,++sy)
				for(var/sx=0,sx<B,sx+=tile_width_used)
					//world.log << "Drawing character [tf] [sx/tile_width_used],[sizey-sy-1] at [x],[y]"
					ic.BlendIcon(new/icon(icon,"[tf] [sx/tile_width_used],[sizey-sy-1]"),x+sx,y+(sy*tile_height_used),,min(tile_width_used,B-sx),min(tile_height_used,height-(sy*tile_height_used)), icon_width, icon_height)
		else
			//world.log << "Drawing character [tf] at [x],[y]"
			ic.BlendIcon(new/icon(icon,tf),x,y,,B,height,icon_width,icon_height)

	// takes a list of strings and fonts
	// a font in the list means following lines will be rendered in that font
	// a null in the list means following lines will be rendered using src as the font
	// output is a /dmifonttextline that MUST BE DELETED MANUALLY
	// leftover is filled in only if supplied
	proc/GetLinesMultiFont(list/items, width=-1, flags=0, firstline=0, maxheight=-1, list/leftover)
		var/lastline
		var/dmifont/curfont=src
		var/dmifont/nextfont=src
		var/y=0
		var/cutoff=0
		var/maxlines=0
		var/dmifonttextline/first
		var/dmifonttextline/prev
		if(leftover) leftover.Cut()
		for(var/item in items)
			if(cutoff)
				if(leftover) leftover+=item
				continue
			if(isnull(item) || item==src)
				nextfont=src
				continue
			if(istype(item,/dmifont))
				nextfont=item
				continue
			if(!istext(item)) item="[item]"
			if(!lastline)
				curfont=nextfont
				maxlines=maxheight>=0?round((maxheight-y)/curfont.height):-1
			else
				maxlines=maxheight>=0?round((maxheight-y)/curfont.height):-1
				firstline=curfont.GetNextPosition(lastline,item,nextfont,firstline,flags)
				curfont=nextfont
				if(firstline) flags|=DF_BREAK_FIRST
			lastline=curfont.GetLines(item,width,flags,firstline,maxlines)
			if(maxheight>=0) cutoff=curfont.GetCutoffIndex(item,width,flags,firstline,maxlines)
			// special case: ellipsis might follow a line that was longer than it
			// should have been; solution: cut off the last line instead
			if(cutoff && prev && width>=0 && firstline && (GetWidth(lastline,flags,firstline)>width || !curfont.GoodBreaks(item,width,flags,firstline,maxlines)))
				var/dmifonttextline/oldprev=prev
				prev=prev.prev
				if(prev) prev.next=null
				else first=null
				oldprev.prev=null
				var/oldline=oldprev.line
				var/newwidth=width-GetWidth(GetLine(lastline),flags)
				oldprev.line=oldprev.font.GetLines(oldline,newwidth,flags&~DF_BREAK_FIRST,oldprev.x,1)
				cutoff=oldprev.font.GetCutoffIndex(oldline,newwidth,flags&~DF_BREAK_FIRST,oldprev.x,1)
				if(leftover && cutoff)
					if(oldprev.font!=src) leftover+=oldprev.font
					leftover+=copytext(oldline,oldprev.font.GetNextIndex(oldline,cutoff))
				prev=new(oldprev.line,oldprev.font,oldprev.x,oldprev.y,oldprev.flags,prev)
				// first==oldprev should not happen at this point, but just be safe
				if(!first || first==oldprev) first=prev
				while(prev.next) prev=prev.next
				if(leftover)
					if((!cutoff && curfont!=src) || oldprev.font!=curfont)
						leftover+=curfont
					leftover+=item
				cutoff=1
				continue
			prev=new(lastline,curfont,firstline,y,flags,prev)
			if(!curfont.GoodBreaks(item,width,flags,firstline,maxlines)) prev.badbreak=1
			if(!first) first=prev
			while(prev.next) prev=prev.next
			flags&=~DF_BREAK_FIRST
			if(cutoff)
				if(leftover)
					if(curfont!=src) leftover+=curfont
					leftover+=copytext(item,cutoff)
				continue
			y+=(curfont.CountLines(lastline)-1)*curfont.height
			if(maxheight>=0 && y>=maxheight)
				cutoff=1
				if(curfont!=src && leftover) leftover+=curfont
		// if the leftover list begins with 2+ fonts, reduce it to only 1
		// if no text remains, empty the leftover list
		if(leftover)
			while(length(leftover) && (isnull(leftover[1]) || istype(leftover[1],/dmifont)) &&\
			  (length(leftover)==1 || isnull(leftover[2]) || istype(leftover[2],/dmifont)))
				leftover.Cut(1,2)
		// change to a single-linked list
		for(prev=first.next, prev, prev=prev.next)
			prev.prev = null
		return first

	// analog to WillFit(), matching GetLinesMultiFont() format
	proc/WillFitMultiFont(list/items, width=-1, flags=0, firstline=0, maxheight=-1)
		var/lastline
		var/dmifont/curfont=src
		var/dmifont/nextfont=src
		var/y=0
		var/maxlines=0
		for(var/item in items)
			if(isnull(item))
				nextfont=src
				continue
			if(istype(item,/dmifont))
				nextfont=item
				continue
			if(!istext(item)) item="[item]"
			maxlines=maxheight>=0?round((maxheight-y)/curfont.height):-1
			if(!lastline)
				curfont=nextfont
			else
				firstline=curfont.GetNextPosition(lastline,item,nextfont,firstline,flags)
				curfont=nextfont
				if(firstline) flags|=DF_BREAK_FIRST
			if(!curfont.WillFit(item,width,flags,firstline,maxlines)) return 0
			lastline=curfont.GetLines(item,width,flags,firstline,maxlines)
			flags&=~DF_BREAK_FIRST
		return 1

	// this uses maxheight instead of maxlines
	// items is a list, or a /dmifonttextline datum
	proc/DrawTextMultiFont(items, x, y, width=-1, flags=0, firstline=0, maxheight=-1, icons_x=0, icons_y=0, icon/drawover, list/leftover)
		var/dmifonttextline/text
		if(istype(items,/list))
			text=GetLinesMultiFont(items,width,flags,firstline,maxheight,leftover)
		else if(istype(items,/dmifonttextline))
			text=items
		else
			world.log << "DmiFonts error in DrawTextMultiFont(): items is not a list or /dmifonttextline."
			world.log << items
			return
		var/mw=0
		var/mh=y
		var/dmifonttextline/T
		if(!drawover || !icons_x || !icons_y)
			for(T=text,T,T=T.next)
				mw=max(mw,T.font.GetWidth(T.line,flags,T.x))
				mh=max(mh,T.y+T.nlines*T.font.height)
			if((flags&DF_JUSTIFY)==DF_JUSTIFY_CENTER) mw=(mw+x)>>1
			else if((flags&DF_JUSTIFY)==DF_JUSTIFY_RIGHT) mw=max(mw,x)
			else mw+=x
			if(!icons_x) icons_x=round((mw+icon_width-1)/icon_width)
			if(!icons_y) icons_y=round((mh+icon_height-1)/icon_height)
		var/icon/icout = drawover
		if(!icout)
			icout = new(blank_icon)
			icout.setpadding = (!icon_native && icons_x == 1 && icons_y == 1) ? 1 : 0
			icout.setwidth = icons_x + icout.setpadding
			icout.setheight = icons_y
			icout.fullwidth = icout.setwidth * icon_width
			icout.fullheight = icout.setheight * icon_height
			icout.Crop(icout.fullwidth, icout.fullheight)
		for(T=text,T,T=T.next)
			if(flags&DF_JUSTIFY)
				var/xx=T.x+T.width-T.firstwidth
				if((flags&DF_JUSTIFY)==DF_JUSTIFY_CENTER)
					xx+=(T.firstwidth-T.width)>>1
				T.font.DrawText(T.line,x,y+T.y,width,flags,xx,drawover=icout)
			else
				T.font.DrawText(T.line,x,y+T.y,width,flags,T.x,drawover=icout)
		return icout

	// insert soft-break and hyphen-break chars into a player's key at opportune points
	proc/KeyToBreakable(text)
		.=text
		var/last=0
		var/chclass=1
		for(var/i=1,i<=length(.),++i)
			var/ch=text2ascii(.,i)
			if(ch<=32)
				last=0
				continue
			if(ch>=48 && ch<58) chclass=3
			else if(ch>=65 && ch<=90) chclass=1
			else if(ch>=97 && ch<=122) chclass=2
			else chclass=4
			if(last==chclass) continue
			if(last==4)
				.=copytext(.,1,i)+"\t"+copytext(.,i)
				++i
			else if(last==3 || (last && (chclass&1)))
				.=copytext(.,1,i)+ascii2text(8)+copytext(.,i)
				++i
			last=chclass

	// quicky means of adding a name overlay to an atom
	// this routine assumes client.dir=NORTH (the default)
	proc/QuickName(atom/A, txt, color="#fff", outline, top, size=3, layer=FLY_LAYER)
		if(outline && !istext(outline)) outline = "#000"
		txt = GetLines(KeyToBreakable(txt), width=size*icon_width, maxlines=round(icon_height/height), flags=DF_WRAP_ELLIPSIS)
		var/icon/s = DrawText(txt, x=round(size*icon_width/2), y=(top?(icon_height-height-(outline?1:0)):(outline?1:0)),\
		                      width=size*icon_width, flags=(DF_JUSTIFY_CENTER|DF_NO_FORMAT), icons_x=size, icons_y=1)
		if(color=="#fff") color="#ffffff"
		if(outline)
			s.DFP_Outline(color, outline)
		else if(color != "#ffffff")
			s.Blend(color, ICON_MULTIPLY)
		var/obj/O = new
		O.layer = layer
		O.icon = s
#if DM_VERSION >= 455
		var/xinc = icon_width
		var/yinc = 0
		if((world.map_format & ~TILED_ICON_MAP) == ISOMETRIC_MAP)
			if(top)
				O.pixel_x = round((icon_width-s.fullwidth)/2)
				O.pixel_y = O.pixel_x
				O.pixel_z = icon_height
				if(icon_native) O.pixel_z -= round(O.pixel_x/2)	// compensate for height adjustment for big icons
			else
				O.pixel_x = round((icon_width*3-s.fullwidth)/2)
				O.pixel_y = round((-icon_width-s.fullwidth)/2)
			yinc = icon_width
		else
			O.pixel_y = top ? icon_height : -icon_height
			O.pixel_x = round((icon_width-s.fullwidth)/2)
		if(icon_native)
			A.overlays += O
		else
			for(var/i=0, i<s.setwidth, ++i)
				O.icon_state = "[i],0"
				A.overlays += O
				O.pixel_x += xinc
				O.pixel_y += yinc
#else
		O.pixel_y = top ? icon_height : -icon_height
		O.pixel_x = round((icon_width-s.fullwidth)/2)
		for(var/i=0, i<s.setwidth, ++i)
			O.icon_state = "[i],0"
			A.overlays += O
			O.pixel_x += 32
#endif

	// quicky means of adding one line of text to a game element such as a HUD
	// max length is 128 for left or right even though 159 is feasible with pixel offsets
	// BYOND 455 increases the pixel limit further but keep with 128 for back-compatibility
	proc/QuickText(atom/A, txt, color="#fff", outline, x=0, y=0, bottom, justify=DF_JUSTIFY_LEFT, layer=FLY_LAYER)
		if(outline && !istext(outline)) outline = "#000000"
		if(color=="#fff") color="#ffffff"
		if(x<0) x=0
		if(x>=icon_width) x=icon_width
		if(y+height>icon_height) y=icon_height-height
		if(y+height<icon_height-(outline?1:0)) --y
		if(y<0) y=0
		if(!x && outline) ++x
		if(!y && outline) ++y
		if(bottom) y = icon_height-height-y
		if(justify < 4) justify<<=2		// allow 1 for right, 2 for center
		justify &= DF_JUSTIFY
		if(justify == DF_JUSTIFY) justify = 0
		else if(justify == DF_JUSTIFY_CENTER) x=0
		txt = GetLines(KeyToBreakable(txt), width=((justify==DF_JUSTIFY_CENTER)?256:(128-x)), maxlines=1, flags=DF_WRAP_ELLIPSIS)
		var/w = round((GetWidth(txt)+icon_width-1)/icon_width)*icon_width
		if(justify) x = (justify==DF_JUSTIFY_CENTER) ? round(w/2) : (w-x)
		var/icon/s = DrawText(txt, x=x, y=y, width=w, flags=(justify|DF_NO_FORMAT), icons_x=w/icon_width, icons_y=1)
		if(color=="#fff") color="#ffffff"
		if(outline)
			s.DFP_Outline(color, outline)
		else if(color != "#ffffff")
			s.Blend(color, ICON_MULTIPLY)
		var/obj/O = new
		O.layer = layer
		O.icon = s
		if(justify) O.pixel_x = round((icon_width-s.fullwidth) * ((justify==DF_JUSTIFY_CENTER) ? 0.5 : 1))
#if DM_VERSION >= 455
		var/xinc = icon_width
		var/yinc = 0
		if(world.map_format == ISOMETRIC_MAP)
			O.pixel_y = O.pixel_x
			yinc = icon_width
		if(icon_native)
			A.overlays += O
		else
			for(var/i=0, i<s.setwidth, ++i)
				O.icon_state = "[i],0"
				A.overlays += O
				O.pixel_x += xinc
				O.pixel_y += yinc
#else
		for(var/i=0, i<s.setwidth, ++i)
			O.icon_state = "[i],0"
			A.overlays += O
			O.pixel_x += 32
#endif


/*
	/dmifonttextline is a double-linked list during construction, but afterwards
	is changed into a single-linked list by the proc which called new(). Changing
	to a single-linked list allows the garbage collector to readily destroy the
	datum.
 */
dmifonttextline
	var/dmifont/font
	var/line
	var/x
	var/y
	var/flags
	var/nlines
	var/width		// width of first line, but only for this item
	var/firstwidth	// width of first whole line, used for partial lines joined to longer lines
	var/badbreak	// contains a "bad break"; a wrap point in the middle of a word; set manually
	var/tmp/dmifonttextline/prev
	var/dmifonttextline/next

	New(ln,dmifont/f,_x,_y,flags,dmifonttextline/last)
		line=ln
		font=f
		x=_x
		y=_y
		src.flags=flags
		prev=last
		if(prev) prev.next=src
		nlines=font.CountLines(line)
		width=font.GetWidth(font.GetLine(line),flags)
		firstwidth=x+width
		// break off the last line
		if(nlines>1)
			var/idx=font.GetLastLineIndex(line)
			if(idx)
				next=new(copytext(line,idx--),font,0,_y+(--nlines)*font.height,flags,src)
				line=copytext(line,1,idx)
		if(x)
			var/by=y+font.ascent
			for(last=prev,last,last=last.prev)
				if(last.nlines>1) break
				last.firstwidth=firstwidth
				by=max(by,last.y+last.font.ascent)
				if(!last.x) break
			y=by-font.ascent
			for(last=prev,last,last=last.prev)
				if(last.nlines>1) break
				last.y=by-last.font.ascent
				if(!last.x) break

	proc/AnyBadBreaks()
		var/dmifonttextline/T
		for(T=src,T,T=T.next)
			if(T.badbreak)
				return 1

	proc/TotalWidth()
		.=0
		var/dmifonttextline/T
		for(T=src,T,T=T.next)
			.=max(.,T.font.GetWidth(T.line,flags,T.x))

	proc/TotalHeight()
		var/dmifonttextline/T=src
		while(T.next) T=T.next
		.=T.y+T.nlines*T.font.height


icon
	var/setwidth=1
	var/setheight=1
	var/fullwidth
	var/fullheight
	var/setpadding=1	// used if the icon is 1x1

	proc/DFP_Dilate()
		/*
			A bug in versions prior to 430 caused problems with north/south
			shifts when the icon was not square. To compensate, temporarily
			make this icon square and then 86 the leftovers
		 */
		if(world.byond_version < 430 && fullwidth != fullheight)
			var/s = max(fullwidth, fullheight)
			Crop(s, s)
		var/icon/I = new(src)
		for(var/dir=8, dir, dir>>=1)
			var/icon/J = new(I)
			J.Shift(dir,1)
			Blend(J, ICON_OR)
		if(world.byond_version < 430 && fullwidth != fullheight)
			Crop(fullwidth, fullheight)
	proc/DFP_Outline(in_color, out_color)
		var/icon/I = new(src)
		I.DFP_Dilate()
		if(out_color != "#ffffff") I.Blend(out_color, ICON_MULTIPLY)
		if(in_color != "#ffffff") Blend(in_color, ICON_MULTIPLY)
		Blend(I, ICON_UNDERLAY)

	// This is deprecated as of BYOND 455 which now allows positional blends
	proc/BlendIcon(icon/c,x,y,operation=ICON_OR,iw=32,ih=32,myw=32,myh=32)
		if(!c) return
		var/ix
		var/iy
		var/icon/ic
		var/idx
		var/oy=y-round(y/myh)*myh
		for(iy=round(max(0,y)/myh),(oy>-ih && iy<setheight),++iy)
			var/fx=round(max(0,x)/myw)
			var/ox=x-fx*myw
			for(ix=fx,(ox>-iw && ix<setwidth),++ix)
				idx = "[ix],[setheight-iy-1]"
				ic=icon(src,idx)
				if(!ic)
					idx = ""
					ic=icon(src,idx)
				if(ox || oy)
					var/icon/c2=new(c)
					if(ox) c2.Shift(EAST,ox)
					if(oy) c2.Shift(SOUTH,oy)
					ic.Blend(c2,operation)
				else
					ic.Blend(c,operation)
				Insert(ic,idx)
				ox-=myw
			oy-=myh

/*
ini_reader
	Variables
		Mode
			INIREADER_CFG - 0, This switches it to CFG (Default)
			INIREADER_INI - 1, This switches it to INI
		cLastReadLine - This is the last line that was read in the file. It is included for debugging purposes.
		list
			Config - This is the current Configuration File.
	Procedures
		New( F ) - If F is either a file, or a file name, it calls LoadConfiguration( F ). Else, it initializes Config.
		Del() - This sets Config to null.
		Trim( T ) - If T is a non-null text string, it will strip any leading or trailing spaces.
		Replace( T, What, With ) - Replaces What in T with With.
		String( Num, Char ) - Returns Num Chars.
		Escaped( T ) - Replaces \ with \\,  Carriage Return with
		CurrentScanLine() - Returns cLastReadLine
		InputConfiguration( Configuration ) - Removes in Configuration Carriage Returns and Tabs, then fills Config by calling LoadStructure.
		LoadConfiguration( Configuration ) - Loads in Configuration, then removes from the data Carriage Returns and Tabs, then fills Config by calling LoadStructure.
		LoadStructure( Number/N, data, e = 0 ) - Goes through data and sets up a Dictionary to match the configuration file exactly.
		NewConfiguration() - Resets Config and cLastReadLine
		OutputConfiguration( NewLine = CrLf, Whitespace = 1 ) - Returns OutputDictionary.
		OutputDictionary( Dictionary/Dict, Level, NewLine = CrLf, Whitespace = 1 ) - Returns the .ini format of the dictionary.
		ReadSetting( Setting, Default ) - Returns Setting in Config, or Default if it isn't found.
		RemoveSetting( Setting ) - Removes Setting in Config, if it exists.
		Root() - Returns a Deep Copy of Config.
		SaveConfiguration( FileName, NewLine = CrLf, Whitespace = 0 ) - Saves OutputDictionary's return to a file.
		WriteSetting( Setting, Val ) - Writes Val to Setting in Config, or overrides Setting with Val if it exists.
*/


#define Cr ascii2text(13)
#define Lf ascii2text(10)
#define CrLf ascii2text(13) + ascii2text(10)
#define Tab ascii2text(9)
#define islist( L ) istype( L, /list )


var
	const
		BEGINOP_INI = 91		// [
		ENDOP_INI = 93			// ]
		BEGINOP_CFG = 123		// {
		ENDOP_CFG = 125			// }

		LISTBEGIN = 60			// <
		LISTEND = 62			// >
		LISTDELIM = 44			// ,
		ASSIGNOP = 61			// =
		TERMINATEOP = 59		// ;
		STRINGOP = 34			// "
		COMMENT = "//"			//
		COMMENT_ALT = ";"		//
		BEGINCOMMENT = "/*"		//
		ENDCOMMENT = "*/"		//


		WS_SPACE = 32			// space
		WS_LINEFEED = 10		// linefeed
		WS_TAB = 9				//
		WS_RETURN = 13			//

		ESCAPESEQ = 92 			// Double Baskslash
		ES_NEWLINE = 110		// n
		ES_RETURN = 114			// r
		ES_TAB = 116			// t
		ES_QUOTE = 34			// "
		ES_BACKSLASH = 92		// Backslash

		INIREADER_CFG = 1		// Use CFG
		INIREADER_INI = 2		// Use INI

proc
	DeepCopy( list/L )
		. = new/list
		if( istype( L ) && L && L.len )
			for( var/i in L )
				if( islist( i ) )
					var/list/N = new
					N = DeepCopy( L[i] )
					.[i] = N
				else
					.[i] = L[i]
	Pos( list/L, Key = 1)
		. = 0
		if( islist( L ) )
			for( var/i in L )
				.++
				if( i == Key )
					return
		. = 0

slist
	var
		list/Item = null
	New()
		Item = new

ini_reader
	var
		Mode = INIREADER_CFG
		cLastReadLine = 0
		fspec = 0
		list
			Config = null
	New()
		..()
		NewConfiguration()
	New( F, INIMode )
		..()
		Mode = INIMode
		if( !Mode ) Mode = initial(Mode)
		if( istext( F ) && fexists( F ) )
			F = file(F)
		if( isfile( F ) )
			LoadConfiguration(F)
	Del()
		Config = null
		..()
	proc
		Trim( T )
			if( ckey(T) && istext( T ) )
				. = T
				while( text2ascii(copytext( ., 1, 2 )) <= 32 )
					. = copytext( ., 2 )
				while( text2ascii(copytext( ., length( . ))) <= 32  )
					. = copytext( ., 1, length( . ) )
		Replace( T, What, With )
			. = T
			if( istext( T ) && T && istext( What ) && istext( With )  )
				. = dd_replacetext( T, What, With )
		String( Num, Char )
			. = ""
			if( isnum(Num) && istext(Char) && Num > 0 && length(ckey(Char)))
				for( var/i = 1; i <= Num; i++ )
					. += Char
		Escaped( T )
			if( istext( T ) && ckey( T ) )
				. = Replace( T, "\\", "\\\\" )
				. = Replace( ., Lf, "\\n" )
				. = Replace( ., Cr, "\\r" )
				. = Replace( ., Tab, "\\t" )
				. = Replace( ., "\"", "\\\"" )
		CurrentScanLine()
			. = cLastReadLine
		InputConfiguration( Configuration )
			if( istext( Configuration ) && ckey( Configuration ) )
				Configuration = Replace( Configuration, ascii2text( WS_RETURN ), "" )
				Configuration = Replace( Configuration, ascii2text( WS_TAB ), "" )
				cLastReadLine = 1
				Config = LoadStructure( list(0), Configuration )
		LoadConfiguration( File )
			if( !isfile(File) && fexists( File ) )
				File = file (File)
			if( isfile( File ) )
				var
					Data
				Data = file2text( File )
				Data = Replace( Data, ascii2text( WS_RETURN ), "" )
				Data = Replace( Data, ascii2text( WS_TAB ), "" )
				cLastReadLine = 1
				Config = LoadStructure( list(0), Data )
		ListParse( list/N, data , end )
			var
				p = N[1]
				c
				ca
				sd
				nd
				np
				seq
				newval
				list/L = new
				slist/Return = new
			while( p < length(data) )
				p++
				if( p == end )
					break
				c = copytext( data, p, p + 1 )
				ca = text2ascii(c)
				if( sd )
					if( seq )
						switch( ca )
							if( ES_BACKSLASH )
								newval += "\\"
							if( ES_NEWLINE )
								newval += ascii2text(WS_LINEFEED)
							if( ES_QUOTE )
								newval += "\""
							if( ES_RETURN )
								newval += ascii2text(WS_RETURN)
							if( ES_TAB )
								newval += ascii2text(WS_TAB)
							else
								if( isnum(text2num(c)) )
									np = copytext( data, p, p + 3)
									newval += ascii2text(text2num(np))
									p += 2
								else
									newval += c
						seq = 0
					else
						if( ca == ESCAPESEQ )
							seq = 1
						else if( ca == STRINGOP )
							L += newval
							sd = 0
							newval = ""
						else if( ca == WS_LINEFEED )
							CRASH( "Invalid Assignment. Did you forget to close your list?" )
						else
							newval += c
				else if( nd )
					if( ca == WS_SPACE || ca == LISTDELIM || ca == LISTEND )
						L += text2num(newval)
						nd = 0
						newval = ""
					else
						newval += c
				else
					if( ca == STRINGOP )
						sd = 1
					else if( isnum(text2num(c)) || c == "-" || c == "." || lowertext(c) == "e" || c == "&" )
						nd = 1
						p--
					else if( ca == LISTBEGIN )
						var/list/O = list(p)
						L.len += 1
						L[L.len] = ListParse( O, data, findtext( data, ascii2text(LISTEND) , p ) +1 )
						p = O[1]
			Return.Item = L
			. = Return
			N[1] = p
		LoadStructure( list/N, data, e = 0 )
			if( istype(N) && N && istext( data ) && ckey( data ) )
				var
					p = N[1]
					c
					ca
					np
					sd
					nd
					seq
					assign
					newkey
					newval
					list/Dict = new
				while( p < length( data ) )
					p++
					if( p == e ) break
					c = copytext( data, p, p + 1 )
					ca = text2ascii(c)
					if( nd )
						if( ca == TERMINATEOP )
							Dict[Trim(newkey)] = text2num(newval)
							newkey = ""
							newval = ""
							nd = 0
							assign = 0
						else if( ca == WS_LINEFEED )
							cLastReadLine++
						else
							newval += c
					else if( sd )
						if( seq )
							switch( ca )
								if( ES_BACKSLASH )
									newval += "\\"
								if( ES_NEWLINE )
									newval += ascii2text(WS_LINEFEED)
								if( ES_QUOTE )
									newval += "\""
								if( ES_RETURN )
									newval += ascii2text(WS_RETURN)
								if( ES_TAB )
									newval += ascii2text(WS_TAB)
								else
									if( ca >= 48 && ca <= 57 )
										np = copytext( data, p, p + 3 )
										newval += ascii2text(text2num(np))
										p += 2
									else
										newval += c
							seq = 0
						else
							if( ca == ESCAPESEQ )
								seq = 1
							else if( ca == STRINGOP )
								Dict[ Trim(newkey) ] = newval
								sd = 0
								newkey = ""
								newval = ""
							else if( ca == WS_LINEFEED )
								cLastReadLine++
							else
								newval += c
					else if( assign )
						if( ca == STRINGOP )
							sd = 1
						else if( isnum(text2num(c)) || c == "-" || c == "." || lowertext(c) == "e" || c == "&" )
							nd = 1
							p--
						else if( ca == WS_LINEFEED )
							cLastReadLine++
						else if(ca == TERMINATEOP)
							assign = 0
						else if( ca == LISTBEGIN )
							var/list/O = list(p)
							Dict[Trim(newkey)] = ListParse( O, data, findtext( data, ascii2text(TERMINATEOP), p ) - 1)
							p = O[1]
							newkey = ""
						else if( ca <> WS_SPACE )
							CRASH( "Invalid Assignment. Forget an assignment operator?" )
					else
						switch( ca )
							if( BEGINOP_INI )
								continue
							if( BEGINOP_CFG )
								if( findtext( Trim(newkey), " " ) )
									CRASH( "Spaces are not allowed in key names." )
								else
									var/list/O = list(p)
									Dict[ Trim( newkey ) ] = LoadStructure( O, data )
									p = O[1]
									newkey = ""
							if( ENDOP_INI )
								if( Mode == INIREADER_INI )
									if( findtext( Trim(newkey), " ") )
										CRASH( "Spaces are not allowed in section names." )
									else
										var/list/O = list(p)
										Dict[Trim(newkey)] = LoadStructure( O, data , findtext( data, ascii2text(BEGINOP_INI), p + 1) )
										p = O[1]
										newkey = ""
										if( findtext( data, ascii2text( BEGINOP_INI ), p ) )
											p = findtext( data, ascii2text( BEGINOP_INI ), p )
										else
											break
							if( ENDOP_CFG )
								if( Mode == INIREADER_CFG )
									break
							if( ASSIGNOP )
								if( findtext( Trim( newkey ), " " ) )
									CRASH( "Spaces are not allowed in key names." )
								else
									assign = 1
							if( TERMINATEOP )
								if(newval || newkey)
									Dict[ Trim(newkey) ] = newval
									newkey = ""
									newval = ""
								else if(!newval && !newkey)
									np = findtext( data, ascii2text(WS_LINEFEED), p )
									if( np )
										cLastReadLine++
										p = np
									else
										p = length(data)
										break
							if( WS_LINEFEED )
								cLastReadLine++
								newkey += ascii2text( WS_SPACE )
							if( text2ascii(COMMENT), text2ascii(BEGINCOMMENT) )
								if( copytext( data, p, p + 2 ) == COMMENT )
									np = findtext( data, ascii2text(WS_LINEFEED), p )
									if( np )
										cLastReadLine++
										p = np
									else
										p = length(data)
										break
								else if( copytext( data, p, p + 2 ) == BEGINCOMMENT )
									np = findtext( data, ENDCOMMENT, p )
									if( np )
										var/list/L = dd_text2list( copytext( data, p, p + ( np - p ) ), ascii2text(WS_LINEFEED) )
										cLastReadLine += L.len
										p = np + 1
									else
										p = length(data)
										break
							else
								newkey += c
				. = Dict
				N[1] = p
		NewConfiguration()
			cLastReadLine = 1
			Config = new
		OutputConfiguration( NewLine = Lf, Whitespace = 1 )
			. = OutputDictionary( Config, 0, NewLine, Whitespace )
		OutputDictionary( list/Dict, Level, NewLine = Lf, Whitespace = 1 )
			var
				lt
				sp
				data
			if( istype( Dict ) && Dict )
				if( Dict.len )
					if( Whitespace )
						lt = String( Level, Tab )
						sp = " "
					for( var/i in Dict )
						if( islist(Dict[i]) )
							if( Whitespace )
								data += lt + NewLine
							if( Mode == INIREADER_INI )
								data += ascii2text(BEGINOP_INI)
								data += i
								data += ascii2text(ENDOP_INI) + NewLine
								data += OutputDictionary(Dict[i], Level, NewLine, Whitespace, i)
							else
								data += lt + i + NewLine
								data += lt + ascii2text(BEGINOP_CFG) + NewLine
								data += OutputDictionary(Dict[i], lt + 1, NewLine, Whitespace )
								data += lt + ascii2text(ENDOP_CFG) + NewLine
							if( Whitespace )
								data += NewLine
						else if( isnum(Dict[i]) )
							data += i + sp + ascii2text(ASSIGNOP) + sp + "[Dict[i]]" + ascii2text(TERMINATEOP) + NewLine
						else if( istype( Dict[i], /slist ) )
							var/slist/I = Dict[i]
							data += i + sp + ascii2text(ASSIGNOP) + sp + ascii2text(LISTBEGIN) + List2Text(I.Item) + ascii2text(LISTEND) + ascii2text(TERMINATEOP) + NewLine
						else if(i)
							data += i + sp + ascii2text(ASSIGNOP) + sp + ascii2text(STRINGOP) + Escaped( Dict[i] ) + ascii2text(STRINGOP) + ascii2text(TERMINATEOP) + NewLine
						if( Pos(Dict, i) < Dict.len )
							if( islist(Dict[i]) )
								data += NewLine
			. = data
		List2Text( list/L, Delimiter = "," )
			for( var/i = 1; i <= L.len; i++ )
				if( istype(L[i], /slist) )
					var/slist/I = L[i]
					L[i] = ascii2text(LISTBEGIN) + List2Text(I.Item,Delimiter) + ascii2text(LISTEND)
				else if( isnum( L[i] ) )
					L[i] = num2text(L[i])
				else if( istext( L[i] ) )
					L[i] = ascii2text(STRINGOP) + Escaped(L[i]) + ascii2text(STRINGOP)
			. = dd_list2text(L,Delimiter)
		ReadSetting( Setting, Default )
			if( istext( Setting ) && length( ckey( Setting ) ) && Config )
				if( Setting in Config )
					if( istype( Config[Setting], /slist ) )
						var/slist/I = Config[Setting]
						. = I.Item
					else
						. = Config[Setting]
					return
			. = Default
		RemoveSetting( Setting )
			if( istext( Setting ) && length( ckey( Setting ) ) )
				if( Setting in Config )
					Config -= Setting
		Root()
			. = DeepCopy( Config )
		SaveConfiguration( FileName, NewLine = Lf, Whitespace = 0 )
			var
				Data
			if( Mode == INIREADER_CFG )
				Data = OutputDictionary( Config, 1, NewLine, Whitespace )
			else
				Data = OutputDictionary( Config, 0, NewLine, Whitespace )
			if( fexists( FileName ) )
				fdel(FileName)
			text2file( Data, FileName )
		WriteSetting( Setting, Val )
			if( istext( Setting ) && ckey( Setting ) && !isnull(Val))
				if( Config[ Setting ] )
					if( islist(Val) )
						var/list/Dict = Val
						Config[Setting] = DeepCopy(Dict)
					else
						Config[Setting] = Val
				else
					Config[Setting] = Val

proc
	ls_heapsort(list/L)
		var/heap_size = L.len
		for(var/i=L.len*0.5, i>=1, --i)
			ls_heapify(L, i, heap_size)
		for(var/i=L.len, i>=2, --i)
			L.Swap(i, 1)
			ls_heapify(L, 1, --heap_size)

	ls_heapsort_cmp(list/L, cmp)
		var/heap_size = L.len
		for(var/i=L.len*0.5, i>=1, --i)
			ls_heapify_cmp(L, i, heap_size, cmp)
		for(var/i=L.len, i>=2, --i)
			L.Swap(i, 1)
			ls_heapify_cmp(L, 1, --heap_size, cmp)

proc	// helper procs
	ls_heapify(list/A, i, heap_size)
		var
			l
			r
			upper
		for()
			l = i+i
			r = l+1

			if(l<=heap_size && A[l]>A[i])
				upper = l
			else
				upper = i

			if(r<=heap_size && A[r]>A[upper])
				upper = r

			if(upper != i)
				A.Swap(upper, i)
				i = upper
			else break

	ls_heapify_cmp(list/A, i, heap_size, cmp)
		var
			l
			r
			upper
		for()
			l = i+i
			r = l+1

			if(l<=heap_size && call(cmp)(A[l],A[i])>0)
				upper = l
			else
				upper = i

			if(r<=heap_size && call(cmp)(A[r],A[upper])>0)
				upper = r

			if(upper != i)
				A.Swap(upper, i)
				i = upper
			else break

proc
	ls_quicksort(list/L, start=1, end=L.len)
		if(start < end)
			var/q = ls_partition(L, start, end)
			ls_quicksort(L, start, q-1)
			ls_quicksort(L, q+1, end)

	ls_quicksort_cmp(list/L, cmp, start=1, end=L.len)
		if(start < end)
			var/q = ls_partition_cmp(L, cmp, start, end)
			ls_quicksort_cmp(L, cmp, start, q-1)
			ls_quicksort_cmp(L, cmp, q+1, end)

proc	// helper procs
	ls_partition(list/L, p, r)
		var
			pivot
			m = (p + r) * 0.5
		if(L[p] > L[m])
			L.Swap(p, m)
		if(L[p] > L[r])
			L.Swap(p, r)
		if(L[m] > L[r])
			L.Swap(m, r)
		pivot = r-1
		if(r-p > 2)
			r--
			L.Swap(m, pivot)
			for()
				while(L[++p] < L[pivot]);
				while(L[--r] > L[pivot]);
				if(p < r)
					L.Swap(p, r)
				else
					break
			L.Swap(p, pivot)
			return p
		else return m

	ls_partition_cmp(list/L, cmp, p, r)
		var
			pivot
			m = (p + r) * 0.5
		if(call(cmp)(L[p],L[m]) > 0)
			L.Swap(p, m)
		if(call(cmp)(L[p],L[r]) > 0)
			L.Swap(p, r)
		if(call(cmp)(L[m],L[r]) > 0)
			L.Swap(m, r)
		pivot = r-1
		if(r-p > 2)
			r--
			L.Swap(m, pivot)
			for()
				while(call(cmp)(L[++p],L[pivot]) < 0);
				while(call(cmp)(L[--r],L[pivot]) > 0);
				if(p < r)
					L.Swap(p, r)
				else
					break
			L.Swap(p, pivot)
			return p
		else return m





///////////////////
// TEXT HANDLING //
///////////////////
/*
 This text handling library is a Deadron core library,
 providing some helpful text functions not found in BYOND.

 To include this library, click the library checkbox in the
 Lib folder of the file tree, or add this line in your code:

#include <deadron/texthandling>

 If you have suggestions or questions, please email
 ron@deadron.com.

 Copyright (c) 1999, 2000, 2001, 2002, 2003 Ronald J. Hayden. All rights reserved.

 09/12/03: Integrated Crispy's changes so dd_text2list() supports non-text items in list.
 02/10/02: Added dd_centertext() and dd_limittext().

dd_file2list(file_path, separator = "\n")
	Splits the text from the specified file into a list.
	file_path is the path to the file.
	separator is an optional delimiter between items in the file;
	it defaults to "\n", which makes each line of the file an item in the list.

	Example:

	// Read in the list of possible NPC names.
	var/list/names = dd_file2list("NPCs.txt")

dd_replacetext(text, search_string, replacement_string)
	Returns a new string replacing all occurrences of search_string in text
	with replacement_string. This is not case-sensitive.

	Example:

	verb/say(msg as text)
		// Don't let the player fake people out using line breaks when they say things.
		// Replace any instances of <BR> or /n with a space.
		var/search_string = "<BR>"
		var/replacement = " "
		var/sanitized_text = dd_replacetext(msg, search_string, replacement)

		search_string = "/n"
		sanitized_text = dd_replacetext(sanitized_text, search_string, replacement)

		view(src) << sanitized_text
		return

dd_replaceText(text, search_string, replacement_string)
	The case-sensitive version of dd_replacetext().

dd_hasprefix(text, prefix)
	Returns 1 if the text has the specified prefix, 0 otherwise.  This version is not case sensitive.

	Example:

	// Does the player's name have GM as the prefix?
	if (dd_hasprefix(name, "GM"))
		// Give them GM abilities.

dd_hasPrefix(text, prefix)
	The case-sensitive version of dd_hasprefix.

dd_hassuffix(text, suffix)
	Returns 1 if the text has the specified prefix, 0 otherwise.
	This version is not case sensitive.

dd_hasSuffix(text, suffix)
	Returns 1 if the text has the specified prefix, 0 otherwise.
	This version is case sensitive.

dd_text2list(text, separator)
	Split the text into a list, where separator is the delimiter between items.
	Returns the list. This is not case-sensitive.

	If the myText string is "a = b = c", and you call dd_text2list(myText, " = "), you get a list back with these items:
		a
		b
		c

	Example:

	// Get a list containing the names in this string.
	var/mytext = "George; Bernard; Shaw"
	var/separator = "; "
	var/list/names = dd_text2list(mytext, separator)

dd_text2List(text, separator)
	The case-sensitive version of dd_text2list().

dd_list2text(list/the_list, separator)
	Create a string by combining each element of the list,
	inserting the separator between each item.

	Example:

	// Turn this list of names into one string separated by semi-colons.
	var/list/names = list("George", "Bernard", "Shaw")
	var/separator = "; "
	var/mytext = dd_list2text(names, separator)

dd_centertext(message, length)
	Returns a new text string, centered based on the length.

	If the string is not as long as the length, spaces are added
	on both sides of the message.

	If the string is longer than the specified length, the message
	is truncated to fit to the length.

	This function is useful when laying out text on the map, where you
	might want to center a title, for example.

dd_limittext(message, length)
	If the message is longer than length, truncates the message to fit
	length. This is useful for text on the map, where you might want
	to display a player name, for example, but have to make sure it's
	not too long to fit.
*/




proc
	///////////////////
	// Reading files //
	///////////////////
	dd_file2list(file_path, separator = "\n")
		var/file
		if (isfile(file_path))
			file = file_path
		else
			file = file(file_path)
		return dd_text2list(file2text(file), separator)


    ////////////////////
    // Replacing text //
    ////////////////////
	dd_replacetext(text, search_string, replacement_string)
		// A nice way to do this is to split the text into an array based on the search_string,
		// then put it back together into text using replacement_string as the new separator.
		var/list/textList = dd_text2list(text, search_string)
		return dd_list2text(textList, replacement_string)


	dd_replaceText(text, search_string, replacement_string)
		var/list/textList = dd_text2List(text, search_string)
		return dd_list2text(textList, replacement_string)


    /////////////////////
	// Prefix checking //
	/////////////////////
	dd_hasprefix(text, prefix)
		var/start = 1
		var/end = lentext(prefix) + 1
		return findtext(text, prefix, start, end)

	dd_hasPrefix(text, prefix)
		var/start = 1
		var/end = lentext(prefix) + 1
		return findtextEx(text, prefix, start, end)


    /////////////////////
	// Suffix checking //
	/////////////////////
	dd_hassuffix(text, suffix)
		var/start = length(text) - length(suffix)
		if (start) return findtext(text, suffix, start)

	dd_hasSuffix(text, suffix)
		var/start = length(text) - length(suffix)
		if (start) return findtextEx(text, suffix, start)

	/////////////////////////////
	// Turning text into lists //
	/////////////////////////////
	dd_text2list(text, separator)
		var/textlength      = lentext(text)
		var/separatorlength = lentext(separator)
		var/list/textList   = new /list()
		var/searchPosition  = 1
		var/findPosition    = 1
		var/buggyText
		while (1)															// Loop forever.
			findPosition = findtext(text, separator, searchPosition, 0)
			buggyText = copytext(text, searchPosition, findPosition)		// Everything from searchPosition to findPosition goes into a list element.
			textList += "[buggyText]"										// Working around weird problem where "text" != "text" after this copytext().

			searchPosition = findPosition + separatorlength					// Skip over separator.
			if (findPosition == 0)											// Didn't find anything at end of string so stop here.
				return textList
			else
				if (searchPosition > textlength)							// Found separator at very end of string.
					textList += ""											// So add empty element.
					return textList

	dd_text2List(text, separator)
		var/textlength      = lentext(text)
		var/separatorlength = lentext(separator)
		var/list/textList   = new /list()
		var/searchPosition  = 1
		var/findPosition    = 1
		var/buggyText
		while (1)															// Loop forever.
			findPosition = findtextEx(text, separator, searchPosition, 0)
			buggyText = copytext(text, searchPosition, findPosition)		// Everything from searchPosition to findPosition goes into a list element.
			textList += "[buggyText]"										// Working around weird problem where "text" != "text" after this copytext().

			searchPosition = findPosition + separatorlength					// Skip over separator.
			if (findPosition == 0)											// Didn't find anything at end of string so stop here.
				return textList
			else
				if (searchPosition > textlength)							// Found separator at very end of string.
					textList += ""											// So add empty element.
					return textList

	dd_list2text(list/the_list, separator)
		var/total = the_list.len
		if (total == 0)														// Nothing to work with.
			return

		var/newText = "[the_list[1]]"										// Treats any object/number as text also.
		var/count
		for (count = 2, count <= total, count++)
			if (separator) newText += separator
			newText += "[the_list[count]]"
		return newText

	dd_centertext(message, length)
		var/new_message = message
		var/size = length(message)
		if (size == length)
			return new_message
		if (size > length)
			return copytext(new_message, 1, length + 1)

		// Need to pad text to center it.
		var/delta = length - size
		if (delta == 1)
			// Add one space after it.
			return new_message + " "

		// Is this an odd number? If so, add extra space to front.
		if (delta % 2)
			new_message = " " + new_message
			delta--

		// Divide delta in 2, add those spaces to both ends.
		delta = delta / 2
		var/spaces = ""
		for (var/count = 1, count <= delta, count++)
			spaces += " "
		return spaces + new_message + spaces

	dd_limittext(message, length)
		// Truncates text to limit if necessary.
		var/size = length(message)
		if (size <= length)
			return message
		else
			return copytext(message, 1, length + 1)

/***
#define MT_BOL	0x80 | '^'	// beginning of line

	dd_grep(regex, file_or_text)
		var/text

		if (isfile(file_or_text))
			text = file2text(file_or_text)
		else
			text = file_or_text

		return text
***/

/*
 * Using Deadron's Test library.
 */





