
-- HUD

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudPoisonDamageIndicator"] = true,
	["CHudCrosshair"] = true,
	["CHUDQuickInfo"] = true,
	["CHudSuitPower"] = true,
	["CHudZoom"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )

local HSCALE = CreateClientConVar( "benny_hud_scale", 1, true, false, "HUD scaling", 0, 4 )

function ss( scale )
	return math.Round( scale * ( ScrH() / 480 ) * HSCALE:GetFloat() )
end

local function genfonts()
	local sizes = {
		8,
		10,
		12,
		14,
		16,
		18,
		24,
		32,
		36,
		48,
		64,
		72
	}
	for _, size in pairs(sizes) do
		surface.CreateFont( "Benny_" .. size, {
			font = "Carbon Plus Bold",
			size = ss(size),
			weight = 0,
		} )
	end
	local sizes = {
		8,
		9,
		10,
		12,
	}
	for _, size in pairs(sizes) do
		for i=1, 4 do
			local add = i==1 and "" or i==2 and "B" or i==3 and "I" or i==4 and "BI"
			local mode = i==1 and "" or i==2 and " Bold" or i==3 and " Italic" or i==4 and " Bold Italic"
			surface.CreateFont( "Benny_Caption_" .. size .. add, {
				font = "Roboto" .. mode,
				size = ss(size),
				weight = 0,
			} )
		end
	end
end
genfonts()

cvars.AddChangeCallback("benny_hud_scale", function(convar_name, value_old, value_new)
	genfonts()
end, "benny_hud_scale_callback")

schemes = {
	["benny"] = {
		fg = Color( 255, 238, 169 ),
		bg = Color( 54, 44, 39 ),
		caption = Color( 255, 238, 169 ),
		name = "BENNY",
	},
	["nicky"] = {
		fg = Color( 255, 174, 210 ),
		bg = Color( 67, 32, 70 ),
		caption = Color( 255, 174, 210 ),
		name = "NICKY",
	},
	["igor"] = {
		fg = Color( 253, 168, 107 ),
		bg = Color( 122, 34, 32 ),
		caption = Color( 253, 78, 77 ),
		name = "IGOR",
	},
	["yanghao"] = {
		fg = Color( 87, 227, 253 ),
		bg = Color( 2, 58, 51 ),
		caption = Color( 87, 187, 253 ),
		name = "YANG-HAO",
	},
	["enemy"] = {
		caption = Color( 199, 0, 0 ),
		name = "ENEMY",
	},
	["pistol"] = {
		caption = Color( 61, 61, 61 ),
		name = "PISTOL",
	}
}

captions = {
	--{
	--	name = "YANG-HAO",
	--	color = schemes["yanghao"]["caption"],
	--	text = { "..." },
	--	time = 1,
	--},
	--{
	--	name = "BENNY",
	--	color = schemes["benny"]["caption"],
	--	text = { "Bleh." },
	--	time = 2,
	--},
	--{
	--	name = "NICKY",
	--	color = schemes["nicky"]["caption"],
	--	text = { "You have a big weapon, sir!" },
	--	time = 3,
	--},
	--{
	--	name = "IGOR",
	--	color = schemes["igor"]["caption"],
	--	text = { "I need more bullets!", "I need more bullets!", "I need more bullets!" },
	--	time = 4,
	--},
	--{
	--	name = "ENEMY GUARD",
	--	color = schemes["enemy"]["caption"],
	--	text = { "Bigger weapons! Bigger weapons!", "Ratatatata!" },
	--	time = 5,
	--},
}

function AddCaption( name, color, text, time_to_type, lifetime )
	if captions[#captions] and captions[#captions].name == name then
		local weh = captions[#captions]
		local wehlast = weh.lines[#weh.lines]
		local patty = string.gsub(wehlast.text, " %((x%d+)%)", "")
		if patty == text then
			wehlast.repeated = (wehlast.repeated or 1) + 1
			wehlast.text = patty .. " (x" .. wehlast.repeated .. ")"
		else
			table.insert( weh.lines, { text = text, time_to_type=time_to_type, starttime=CurTime() } )
		end
		weh.lifetime = math.max( CurTime() + lifetime, weh.lifetime )
	else
		table.insert( captions, { name = name, color=color, lifetime=CurTime()+lifetime, lines = { { text=text, time_to_type=time_to_type, starttime=CurTime() } } })
	end
end

local color_caption = Color( 0, 0, 0, 127 )
local mat_grad = Material( "benny/hud/grad.png", "mips smooth" )

-- Stew port
globhit = Vector()
globang = Angle()
tr1f = Vector()
tr2f = Vector()
local col_1 = Color(255, 255, 255, 200)
local col_2 = Color(0, 0, 0, 255)
local col_3 = Color(255, 127, 127, 255)
local col_4 = Color(255, 222, 222, 255)
local mat_dot = Material("benny/hud/xhair/dot.png", "mips smooth")
local mat_long = Material("benny/hud/xhair/long.png", "mips smooth")
local mat_dot_s = Material("benny/hud/xhair/dot_s.png", "mips smooth")
local mat_long_s = Material("benny/hud/xhair/long_s.png", "mips smooth")
local spacer_long = 2 -- screenscaled
local gap = 24

hook.Add( "HUDPaint", "Benny_HUDPaint", function()
	local sw, sh = ScrW(), ScrH()
	local b = ss(20)
	local p = LocalPlayer()
	-- PROTO: Make sure this is the 'benny' weapon.
	local wep = p:GetActiveWeapon()

	local scheme = schemes["benny"]

	do -- Health
		-- BG
		surface.SetDrawColor( scheme["bg"] )
		surface.DrawRect( b, sh - b - ss(22), ss(140), ss(14+8) )

		local hp = p:Health()/100 --CurTime()*0.5 % 1
		local ti = (CurTime()*0.75 / (hp)) % 1
		
		-- Text underneath
		surface.SetFont( "Benny_18" )
		surface.SetTextColor( scheme["fg"] )
		surface.SetTextPos( b + ss(6), sh - b - ss(22) + ss(3) )
		surface.DrawText( scheme["name"] )

		-- Bar
		surface.SetDrawColor( scheme["fg"] )
		surface.DrawRect( b + ss(4), sh - b - ss(22) + ss(4), ss((140*hp)-8), ss(14) )

		local gcol = scheme["fg"]
		local ch, cs, cl = gcol:ToHSL()
		cl = ((cl*0.0) + (1)*hp)
		gcol = HSLToColor( ch, cs, cl )
		gcol.a = ((1-ti)*255*hp) + ((1-hp)*255)
		surface.SetDrawColor( gcol )
		surface.SetMaterial( mat_grad )
		surface.DrawTexturedRect( b + ss(4), sh - b - ss(22) + ss(4), ss((140*hp*ti)-8), ss(14) )

		-- Bar text
		surface.SetTextColor( scheme["bg"] )
		surface.SetTextPos( b + ss(6), sh - b - ss(22) + ss(3) )
		render.SetScissorRect( b + ss(4), sh - b - ss(22) + ss(4), b + ss(4) + ss((140*hp)-8), sh - b - ss(22) + ss(4) + ss(14), true ) -- Enable the rect
			surface.DrawText( scheme["name"] )
		render.SetScissorRect( 0, 0, 0, 0, false ) -- Disable after you are done
	end

	do -- Weapon
		assert( IsValid(wep) and wep:GetClass() == "benny", "Failed to retrieve 'benny' weapon!" )
		local inv = p:INV_Get()
		local wep1 = wep:BTable( false )
		local wep1c = wep:BClass( false )
		local wep2 = wep:BTable( true )
		local wep2c = wep:BClass( true )

		local w, h = 150, 100
		local BOXHEIGHT = 44

		if wep1 then
			-- BG
			surface.SetDrawColor( scheme["bg"] )
			surface.DrawRect( sw - b - ss(w), sh - b - ss(BOXHEIGHT), ss(w), ss(BOXHEIGHT) )

			-- Text bar
			surface.SetFont( "Benny_18" )
			surface.SetDrawColor( scheme["fg"] )
			surface.DrawRect( sw - b - ss(w-4), sh - b - ss(BOXHEIGHT-4), ss(w-8), ss(14) )

			surface.SetTextColor( scheme["bg"] )
			surface.SetTextPos( sw - b - ss(w-6), sh - b - ss(BOXHEIGHT-3) )
			surface.DrawText( wep1c.Name or "???" )

			local fmpw = 30
			surface.SetDrawColor( scheme["fg"] )
			surface.DrawRect( sw - b - ss(w-4), sh - b + ss(16) - ss(BOXHEIGHT-4), ss(fmpw), ss(10) )

			surface.SetFont( "Benny_12" )
			local str = wep:B_FiremodeName( false )
			local tw = surface.GetTextSize( str )
			surface.SetTextColor( scheme["bg"] )
			surface.SetTextPos( sw - b - ss(w-19) - (tw/2), sh - b + ss(16) - ss(BOXHEIGHT-4) )
			surface.DrawText( str )

			surface.SetFont( "Benny_12" )
			local text = wep:GetWep1Clip() == 0 and "---" or wep:Clip1()-- .. " - MAG " .. wep:GetWep1Clip()
			local tw = surface.GetTextSize( text )
			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( sw - b - ss(4) - tw, sh - b - ss(24) )
			surface.DrawText( text )

			local bx = 1
			local by = 0
			local count = math.max( wep:Clip1(), wep:BClass( false ).Ammo )
			local size = ss(8)
			if count>90 then
				size = ss(2)
				by = by - ss(8)
			elseif count>60 then
				size = ss(2)
				by = by - ss(7)
			elseif count>30 then
				size = ss(3)
				by = by - ss(5)
			end
			for i=1, count do
				surface.SetDrawColor( scheme["fg"] )
				surface.DrawOutlinedRect( sw - b - ss(3+4) - ( ss(5) * (bx-1) ), sh - b - ss(8+4) - by, ss(3), size, ss(0.5) )
				if i <= wep:Clip1() then
					surface.DrawRect( sw - b - ss(3+4) - ( ss(5) * (bx-1) ), sh - b - ss(8+4) - by, ss(3), size )
				end
				if i%30 == 0 then
					if count>90 then
						by = by + ss(2.5)
					elseif count>60 then
						by = by + ss(3)
					else
						by = by + ss(5)
					end
					bx = 0
				end
				bx = bx + 1
			end

			local amlist = { wep:BTable( false )["Ammo" .. 1], wep:BTable( false )["Ammo" .. 2], wep:BTable( false )["Ammo" .. 3] }
			local ind = 1
			local bubby = ss(1)
			local blen, bhei = 25, 10
			for _, v in ipairs( amlist ) do
				local active = wep:GetWep1Clip() == _
				if v == 0 and !active then continue end
				local perc = v / wep:BClass( false ).Ammo

				local suuze = ss(blen*perc) - bubby*2*perc
				if v != 0 then suuze = math.max( suuze, 1 ) end
				surface.SetDrawColor( scheme["fg"] )
				surface.DrawOutlinedRect( sw - b - ss(w-4-2) + ss(fmpw) + ( ss(blen+2) * (ind-1) ),
				sh - b + ss(16) - ss(BOXHEIGHT-4),
				ss(blen),
				ss(bhei),
				ss(0.5) )

				if active then
					surface.SetTextColor( scheme["fg"] )
					surface.SetTextPos( sw - b - ss(w-4-2) + ss(fmpw/2) + ( ss(blen+2) * (ind) ) + bubby - ss(4),
					sh - b + ss(16) - ss(BOXHEIGHT-4) + bubby - ss(2) )
					surface.DrawText( "x" )
				end

				surface.SetDrawColor( scheme["fg"] )
				surface.DrawRect( sw - b - ss(w-4-2) + ss(fmpw) + ( ss(blen+2) * (ind-1) ) + bubby,
				sh - b + ss(16) - ss(BOXHEIGHT-4) + bubby,
				suuze,
				ss(bhei) - bubby*2 )

				if active then
					render.SetScissorRect( sw - b - ss(w-4-2) + ss(fmpw) + ( ss(blen+2) * (ind-1) ) + bubby,
					sh - b + ss(16) - ss(BOXHEIGHT-4) + bubby,
					sw - b - ss(w-4-2) + ss(fmpw) + ( ss(blen+2) * (ind-1) ) + bubby + suuze,
					sh - b + ss(16) - ss(BOXHEIGHT-4) + bubby + (ss(bhei) - bubby*2), true )
					surface.SetTextColor( scheme["bg"] )
					surface.SetTextPos( sw - b - ss(w-4-2) + ss(fmpw/2) + ( ss(blen+2) * (ind) ) + bubby - ss(4),
					sh - b + ss(16) - ss(BOXHEIGHT-4) + bubby - ss(2) )
					surface.DrawText( "x" )
					render.SetScissorRect( 0, 0, 0, 0, false )
				end

				ind = ind + 1
			end
		end
		

		do -- Crosshair
			local s, w, h = ss, ScrW(), ScrH()
			local pl_x, pl_y = w/2, h/2

			do
				local tr1 = util.TraceLine({
					start = p:EyePos(),
					endpos = p:EyePos() + (p:EyeAngles():Forward()*16000),
					filter = p
				})

				local tr2 = util.TraceLine({
					start = globhit,
					endpos = globhit + (globang:Forward()*16000),
					filter = p
				})

				tr1f:Set(tr1.HitPos)
				tr2f:Set(tr2.HitPos)
			end

			pl_x = tr2f:ToScreen().x
			pl_y = tr2f:ToScreen().y
			ps_x = tr2f:ToScreen().x
			ps_y = tr2f:ToScreen().y

			local touse1 = col_1
			local touse2 = col_2
			if ve then
				pl_x = tr1f:ToScreen().x
				pl_y = tr1f:ToScreen().y
				ps_x = tr1f:ToScreen().x
				ps_y = tr1f:ToScreen().y
			elseif util.TraceLine({start = tr2f, endpos = tr1f, filter = p}).Fraction != 1 and !tr2f:IsEqualTol(tr1f, 1) then
				touse1 = col_4
				touse2 = col_3
				pl_x = tr1f:ToScreen().x
				pl_y = tr1f:ToScreen().y
			end

			for i=1, 2 do
				local cooler = i == 1 and touse2 or touse1
				local poosx, poosy = i == 1 and ps_x or pl_x, i == 1 and ps_y or pl_y
				local mat1 = i == 1 and mat_long_s or mat_long
				local mat2 = i == 1 and mat_dot_s or mat_dot
				surface.SetDrawColor( cooler )
				if wep.XHairMode == "rifle" then
					surface.SetMaterial( mat1 )
					surface.DrawTexturedRectRotated( poosx - s(spacer_long) - gap, poosy, s(16), s(16), 0 )
					surface.DrawTexturedRectRotated( poosx + s(spacer_long) + gap, poosy, s(16), s(16), 0 )

					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx, poosy - gap, s(16), s(16), 0 )
					surface.DrawTexturedRectRotated( poosx, poosy + gap, s(16), s(16), 0 )
				elseif wep.XHairMode == "smg" then
					surface.SetMaterial( mat1 )
					surface.DrawTexturedRectRotated( poosx, poosy + gap + s(spacer_long), s(16), s(16), 90 )
					surface.DrawTexturedRectRotated( poosx - (math.sin(math.rad(45))*gap) - (math.sin(math.rad(45))*s(spacer_long)), poosy - (math.sin(math.rad(45))*gap) - (math.sin(math.rad(45))*s(spacer_long)), s(16), s(16), -45 )
					surface.DrawTexturedRectRotated( poosx + (math.sin(math.rad(45))*gap) + (math.sin(math.rad(45))*s(spacer_long)), poosy - (math.sin(math.rad(45))*gap) - (math.sin(math.rad(45))*s(spacer_long)), s(16), s(16), 45 )

					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx, poosy, s(16), s(16), 0 )
				else -- pistol
					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx - gap, poosy, s(24), s(24), 0 )
					surface.DrawTexturedRectRotated( poosx + gap, poosy, s(24), s(24), 0 )

					surface.SetMaterial( mat2 )
					surface.DrawTexturedRectRotated( poosx, poosy - gap, s(24), s(24), 0 )
					surface.DrawTexturedRectRotated( poosx, poosy + gap, s(24), s(24), 0 )
				end
			end
		end
	end

	do -- Quickinv
		local inv = p:INV_Get()
		local gap = ss(1)
		local size_textx = ss(96)
		local size_texty = ss(12)
		local size_num = ss(12)
		local size_thi = ss(0.5)
		
		local nextwe = ss(96+2)
		local nextwe_no = ss(12+2)
		local item_start = ss(14)
		local item_gap = ss(12+2)

		local translat = {
			["melee"]		= { 1, 1 },
			["special"]		= { 1, 2 },
			["pistol"]		= { 2, 1 },
			["smg"]			= { 3, 1 },
			["rifle"]		= { 3, 2 },
			["shotgun"]		= { 3, 3 },
		}

		local inventorylist = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
		}

		for i, bucket in ipairs( inventorylist ) do
			local temp = {}
			for id, data in pairs( inv ) do
				local idata = WEAPONS[data.Class]
				local translated = translat[idata.Type]

				if i == translated[1] then
					table.insert( temp, { data, translated[2] } )
				end
			end
			table.sort( temp, function(a, b) return b[2] > a[2] end )
			for i, v in ipairs( temp ) do
				table.insert( bucket, v[1] )
			end
		end

		-- PrintTable( it )

		local bump = 0
		for i, bucket in ipairs( inventorylist ) do
			surface.SetDrawColor( scheme["bg"] )
			surface.DrawRect( bump + b, b, size_num, size_num )

			if i==2 then
				surface.SetDrawColor( scheme["fg"] )
				surface.DrawRect( bump + b + gap, b + gap, size_num - (gap*2), size_num - (gap*2) )

				surface.SetFont( "Benny_12" )
				surface.SetTextColor( scheme["bg"] )
				surface.SetTextPos( bump + b + ss(3), b + ss(1) )
				surface.DrawText( i )
			else
				surface.SetFont( "Benny_12" )
				surface.SetTextColor( scheme["fg"] )
				surface.SetTextPos( bump + b + ss(3), b + ss(1) )
				surface.DrawText( i )
			end

			if i!=2 then
				for d, item in ipairs( bucket ) do
					surface.SetDrawColor( scheme["bg"] )
					surface.DrawRect( bump + b, (item_start+item_gap*(d-1)) + b, size_texty, size_texty )
				end
				bump = bump + (nextwe_no)
			else
				for d, item in ipairs( bucket ) do
					local idata = WEAPONS[item.Class]
					surface.SetDrawColor( scheme["bg"] )
					surface.DrawRect( bump + b, (item_start+item_gap*(d-1)) + b, size_textx, size_texty )
					if d==2 then
						surface.SetDrawColor( scheme["fg"] )
						surface.DrawRect( bump + b + gap, (item_start+item_gap*(d-1)) + b + gap, size_textx - (gap*2), size_texty - (gap*2) )

						surface.SetFont( "Benny_12" )
						surface.SetTextColor( scheme["bg"] )
						surface.SetTextPos( bump + b + ss(3), (item_start+item_gap*(d-1)) + b + ss(1) )
						surface.DrawText( idata.Name )
					else
						surface.SetFont( "Benny_12" )
						surface.SetTextColor( scheme["fg"] )
						surface.SetTextPos( bump + b + ss(3), (item_start+item_gap*(d-1)) + b + ss(1) )
						surface.DrawText( idata.Name )
					end
				end
				bump = bump + (nextwe)
			end
		end
	end

	do -- Captions
		local space = b
		for aaa, caption in pairs(captions) do
			if caption.lifetime <= CurTime() then captions[aaa] = nil end
			if #caption.lines == 0 then captions[aaa] = nil end
		end
		for aaa, caption in SortedPairsByMemberValue(captions, "starttime", false) do
			surface.SetFont("Benny_Caption_9")
			local tw = 0
			for i, v in pairs( caption.lines ) do
				tw = math.max( tw, surface.GetTextSize( v.text ) )
			end
			surface.SetFont("Benny_10")
			tw = math.max( tw, surface.GetTextSize( caption.name ) )
			space = space + ss(22)+ss(8*(#caption.lines-1))

			-- BG
			surface.SetDrawColor( color_caption )
			surface.DrawRect( (sw/2) - (ss(8)+tw)/2, sh - space - ss(0), ss(8)+tw, ss(22)+ss(8*(#caption.lines-1)) )
			
			-- PROTO: Would be nice to be able to change italics or bold inline.
			for i, v in SortedPairsByMemberValue( caption.lines, "starttime" ) do
				surface.SetFont("Benny_Caption_9I")
				surface.SetTextColor( color_white )
				surface.SetTextPos( (sw/2) - (tw/2), sh - space + ss(10) + (ss(8)*(i-1)) )
				local waah = ""
				for i=1, #v.text do
					waah = waah .. ( ((i-1)/#v.text) <= math.TimeFraction( v.starttime, v.starttime + v.time_to_type, CurTime() ) and v.text[i] or " ")
				end
				surface.DrawText( waah )
			end

			surface.SetTextColor( caption.color )
			surface.SetFont("Benny_10")
			surface.SetTextPos( (sw/2) - (tw/2), sh - space + ss(2) )
			surface.DrawText( caption.name )
		end
	end

	if false then -- Debug Inventory
		local gap = 0
		for ID, Data in pairs( p:INV_Get() ) do
			local active = (wep:GetWep2() == ID) and "Wep2" or (wep:GetWep1() == ID) and "Wep1" or ""
			surface.SetDrawColor( scheme["bg"] )
			surface.DrawRect( b + ss(4), b + ss(4) + gap, ss(240), ss(30) )

			surface.SetFont( "Benny_12" )
			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( b + ss(4 + 4), b + ss(4 + 3) + gap )
			surface.DrawText( ID .. " " .. active )

			local str = ""
			for i, v in pairs( Data ) do
				str = str .. i .. ": " .. v .. " "
			end

			surface.SetFont( "Benny_10" )
			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( b + ss(4 + 4), b + ss(4 + 3 + 8) + gap )
			surface.DrawText( str )

			surface.SetFont( "Benny_12" )
			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( b + ss(4 + 4), b + ss(4 + 3 + 8 + 8) + gap )
			-- surface.DrawText( active )
			gap = gap + ss(30+4)
		end
	end
end )