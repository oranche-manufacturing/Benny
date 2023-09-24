
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

function ss( scale )
	return math.Round( scale * ( ScrH() / 480 ) )
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
			weight = 0
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
		local inv = p:INV_Get()
		local wep1 = wep.B_WepT1
		local wep1c = wep.B_ClassT1
		local wep2 = wep.B_WepT2
		local wep2c = wep.B_ClassT2

		if false then -- Debug
			local ox, oy = 170, 24
			surface.SetFont( "Benny_12" )
			surface.SetTextColor( scheme["fg"] )

			surface.SetTextPos( ss(ox), ss(oy) )
			surface.DrawText( "Wep1: " .. wep:GetWep1() )

			local num = 1
			if wep1 then for i, v in pairs( wep1 ) do
				surface.SetTextPos( ss(ox+16), ss(oy+10*num) )
				surface.DrawText( i .. ": " .. v )
				num = num + 1
			end end

			surface.SetTextPos( ss(ox+128), ss(oy) )
			surface.DrawText( "Wep2: " .. wep:GetWep2() )

			if wep2 then for i, v in pairs( wep2 ) do
				surface.SetTextPos( ss(ox+128+16), ss(oy+10*num) )
				surface.DrawText( i .. ": " .. v )
				num = num + 1
			end end
		end

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

			surface.SetDrawColor( scheme["fg"] )
			surface.DrawRect( sw - b - ss(w-4), sh - b + ss(16) - ss(BOXHEIGHT-4), ss(29), ss(10) )

			surface.SetFont( "Benny_12" )
			surface.SetTextColor( scheme["bg"] )
			surface.SetTextPos( sw - b - ss(w-7), sh - b + ss(16) - ss(BOXHEIGHT-4) )
			surface.DrawText( wep1c.Firemode or "???" )

			surface.SetFont( "Benny_12" )
			local text = wep:Clip1() .. " - MAG 3"
			local tw = surface.GetTextSize( text )
			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( sw - b - ss(4) - tw, sh - b - ss(24) )
			surface.DrawText( text )

			for i=1, math.max( wep:Clip1(), wep.B_ClassT1.Ammo ) do
				surface.SetDrawColor( scheme["fg"] )
				surface.DrawOutlinedRect( sw - b - ss(3+4) - ( ss(5) * (i-1) ), sh - b - ss(8+4), ss(3), ss(8), ss(0.5) )
				if i <= wep:Clip1() then
					surface.DrawRect( sw - b - ss(3+4) - ( ss(5) * (i-1) ), sh - b - ss(8+4), ss(3), ss(8) )
				end
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

	-- [UUID_generate()] = {
	-- 	Clip1 = 20,
	-- 	Mag1 = 12,
	-- 	Mag2 = 9,
	-- 	Mag3 = 17,
	-- }
	do -- Inventory
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