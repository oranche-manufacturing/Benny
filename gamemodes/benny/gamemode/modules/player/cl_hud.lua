
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

hook.Add( "HUDShouldDraw", "Benny_HUDShouldDraw", function( name )
	if ( hide[ name ] ) then return false end
end )

local HSCALE = CreateClientConVar( "benny_hud_scale", 2, true, false, "HUD scaling", 0, 4 )

function ss( scale )
	return scale*HSCALE:GetInt()--math.Round( scale * ( ScrH() / 480 ) * HSCALE:GetFloat() )
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
		28,
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
	for _, size in pairs(sizes) do
		surface.CreateFont( "BennyS_" .. size, {
			font = "Carbon Plus Bold",
			size = ss(size),
			weight = 0,
			scanlines = ss(1),
			blursize = ss(3),
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
	["nikki"] = {
		fg = Color( 255, 174, 210 ),
		bg = Color(37, 12, 40 ),
		caption = Color( 255, 174, 210 ),
		name = "NIKKI",
	},
	["igor"] = {
		fg = Color( 253, 208, 207 ),
		bg = Color( 32, 14, 12 ),
		caption = Color( 253, 78, 77 ),
		name = "IGOR",
	},
	["yanghao"] = {
		fg = Color( 157, 187, 253 ),
		bg = Color( 19, 21, 28 ),
		caption = Color( 87, 187, 253 ),
		name = "YANG-HAO",
	},
	["mp_cia"] = {
		fg = Color( 93, 118, 215 ),
		bg = Color( 25, 23, 47 ),
		caption = Color( 87, 187, 253 ),
		name = "CIA",
	},
	["mp_plasof"] = {
		fg = Color( 255, 103, 103 ),
		bg = Color( 35, 25, 20 ),
		caption = Color( 87, 187, 253 ),
		name = "PLASOF",
	},
	["mp_militia"] = {
		fg = Color( 255, 199, 133 ),
		bg = Color( 33, 18, 18 ),
		caption = Color( 87, 187, 253 ),
		name = "MILITIA",
	},
	["mp_natguard"] = {
		fg = Color( 208, 226, 132 ),
		bg = Color( 23, 25, 23 ),
		caption = Color( 87, 187, 253 ),
		name = "ARNG",
	},
	["mp_viper"] = {
		fg = Color( 255, 230, 245 ),
		bg = Color( 40, 30, 30 ),
		caption = Color( 87, 187, 253 ),
		name = "VIPER",
	},
	["mp_halo"] = {
		fg = Color( 200, 255, 246 ),
		bg = Color( 30, 40, 38 ),
		caption = Color( 87, 187, 253 ),
		name = "HALO",
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

function schema( i1, i2, alpha )
	return schemes[i1][i2].r, schemes[i1][i2].g, schemes[i1][i2].b, alpha*255
end

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
local heartbeatcol = Color(255, 255, 255, 255)
local mat_dot = Material("benny/hud/xhair/dot.png", "mips smooth")
local mat_long = Material("benny/hud/xhair/long.png", "mips smooth")
local mat_dot_s = Material("benny/hud/xhair/dot_s.png", "mips smooth")
local mat_long_s = Material("benny/hud/xhair/long_s.png", "mips smooth")
local spacer_long = 2 -- screenscaled
local gap = 24

bucket_selected = bucket_selected or 1
item_selected = item_selected or 1

CreateClientConVar( "benny_hud_tempactive", "benny", true, false )

hook.Add( "HUDPaint", "Benny_HUDPaint", function()
	local sw, sh = ScrW(), ScrH()
	local b = ss(20)
	local p = LocalPlayer()
	-- PROTO: Make sure this is the 'benny' weapon.
	local wep = p:GetActiveWeapon()

	local active = GetConVar("benny_hud_tempactive"):GetString()
	local scheme = schemes[active]

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

		heartbeatcol.a = math.ease.OutQuint(1-ti)*255
		surface.SetDrawColor( heartbeatcol )
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
		if !(IsValid(wep) and wep:GetClass() == "benny") then
			print( "Failed to retrieve 'benny' weapon!" )
			return
		end
		local inv = p:INV_Get()
		local wep1 = wep:BTable( false )
		local wep1c = wep:BClass( false )
		local wep2 = wep:BTable( true )
		local wep2c = wep:BClass( true )

		local w, h = 156, 100
		local BOXHEIGHT = 84--44

		if wep1 then
			-- BG
			surface.SetDrawColor( scheme["bg"] )
			surface.DrawRect( sw - b - ss(w), sh - b - ss(BOXHEIGHT), ss(w), ss(BOXHEIGHT) )
			
			if wep1c.Icon then
				local gunsize = 128
				surface.SetDrawColor( scheme["fg"] )
				surface.SetMaterial( wep1c.Icon )
				-- surface.DrawTexturedRectRotated( sw - b - ss(w/2), sh - b - ss(BOXHEIGHT/2), ss(32), ss(32), 0 )
				surface.DrawTexturedRectUV( sw - b - ss(w/2 + gunsize/2), sh - b - ss(BOXHEIGHT/2 - 8 + gunsize/2/2), ss(gunsize), ss(gunsize/2), 1, 0, 0, 1 )
			end

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

			-- PROTO: Make grenade/melee/firearm logic way way better.
			if wep1c.Features == "firearm" then
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
				surface.SetTextPos( sw - b - ss(4) - tw, sh - b - ss(25) )
				surface.DrawText( text )

				surface.SetFont( "Benny_12" )
				local bx = 1
				local count = math.max( wep:Clip1(), wep:BClass( false ).Ammo )
				local size = ss(10)
				local by = ss(2)
				if count>90 then
					size = ss(2)
					by = -ss(6)
				elseif count>60 then
					size = ss(2)
					by = -ss(6)
				elseif count>30 then
					size = ss(4)
					by = -ss(4)
				end
				for i=1, count do
					surface.SetDrawColor( scheme["fg"] )
					local a_x, a_y = sw - b - ss(3+4) - ( ss(5) * (bx-1) ), sh - b - ss(8+4) - by, ss(3)
					if count>90 then
						-- surface.DrawLine( a_x, a_y, a_x, a_y + size )
						surface.DrawLine( a_x, a_y, a_x, a_y + size )
						surface.DrawLine( a_x + ss(2)+1, a_y, a_x + ss(2)+1, a_y + size )
					else
						surface.DrawOutlinedRect( a_x, a_y, ss(3), size, ss(0.5) )
					end
					if i <= wep:Clip1() then
						surface.DrawRect( a_x, a_y, ss(3), size )
					end
					if i%30 == 0 then
						if count>90 then
							by = by + ss(3)
						elseif count>60 then
							by = by + ss(4)
						elseif count>30 then
							by = by + ss(6)
						else
							by = by + ss(10)
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
					math.max(ss(0.5), 1) )

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

			-- local prog = {
			-- 	{
			-- 		Text = "SUPP. 09",
			-- 		Bar = 0.7,
			-- 		Icon = Material("benny/hud/atts/supp.png", ""),
			-- 	},
			-- 	{
			-- 		Text = "LIGHT",
			-- 		Bar = "ON",
			-- 		Icon = Material("benny/hud/atts/light.png", ""),
			-- 	},
			-- 	{
			-- 		Text = "ENERGY",
			-- 		Bar = 0.2,
			-- 		Icon = Material("benny/hud/atts/energy.png", ""),
			-- 	},
			-- }

			-- Attachments?
			if false then for i, v in ipairs( prog ) do
				local ATTBOX = 24
				local ATTLEN = 64
				local bump = ss(2)
				-- BG
				surface.SetDrawColor( scheme["bg"] )
				local x, y = sw - b - ss(w - ((ATTLEN+2)*(i-1))), sh - b - ss(BOXHEIGHT+ATTBOX+4)
				surface.DrawRect( x, y, ss(ATTLEN), ss(ATTBOX) )
	
				-- Text bar
				surface.SetDrawColor( scheme["fg"] )
				surface.DrawRect( x+bump, y+bump, ss(ATTBOX-4), ss(ATTBOX-4) )

				render.PushFilterMag( TEXFILTER.LINEAR )
				render.PushFilterMin( TEXFILTER.LINEAR )
					surface.SetMaterial( v.Icon )
					surface.SetDrawColor( scheme["bg"] )
					surface.DrawTexturedRect( x+bump, y+bump, ss(ATTBOX-4), ss(ATTBOX-4) )
				render.PopFilterMag()
				render.PopFilterMin()
	
				surface.SetFont( "Benny_8" )
				surface.SetTextColor( scheme["fg"] )
				surface.SetTextPos( x+bump + ss(ATTBOX-2), y+bump - ss(1) )
				surface.DrawText( v.Text )

				if isstring(v.Bar) then
					surface.SetFont( "Benny_8" )
					surface.SetTextColor( scheme["fg"] )
					surface.SetTextPos( x+bump + ss(ATTBOX-2), y+bump - ss(1-7) )
					surface.DrawText( v.Bar )
				else
					surface.DrawOutlinedRect( x+bump + ss(ATTBOX-2), y+bump - ss(1-7), ss(30), ss(6), ss(0.5) )
					surface.DrawRect( x+bump + ss(ATTBOX-2), y+bump - ss(1-7), ss(30)*v.Bar, ss(6) )
				end
	
				-- surface.SetFont( "Benny_12" )
				-- surface.SetTextColor( scheme["fg"] )
				-- surface.SetTextPos( x+bump + ss(ATTBOX-1), y+bump - ss(1) )
				-- surface.DrawText( "10" )
			end end
		end
		

		if wep:GetUserAim() then -- Crosshair
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

			pl_x = math.Round( pl_x )
			pl_y = math.Round( pl_y )
			ps_x = math.Round( ps_x )
			ps_y = math.Round( ps_y )
			
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

			local mow = math.Round( CurTime() % 2 )
			local tex = mow == 0 and "NO AMMO" or mow == 1 and "LOW AMMO" or mow == 2 and "[R] RELOAD"

			surface.SetFont( "Benny_16" )
			local tox, toy = surface.GetTextSize( tex )
			local box, boy = ss( 8 ) + tox, ss( 18 )
			surface.SetDrawColor( scheme["bg"] )
			-- surface.DrawRect( ps_x - box/2, ps_y + ss( 96 ) - boy/2 - ss( 2 ), box, boy )

			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( ps_x - tox/2, ps_y + ss( 96 ) - toy/2 )
			-- surface.DrawText( tex )
		end
	end

	do -- Quickinv

		local inv = p:INV_Get()
		local gap = ss(1)
		local size_textx = ss(96)
		local size_texty = ss(12)
		local size_texty_sel = ss(36)
		local size_num = ss(12)
		local size_thi = ss(0.5)
		
		local nextwe = ss(96+2)
		local nextwe_no = ss(12+2)
		local item_start = ss(14)
		local item_gap = ss(12+2)
		local item_gap_sel = ss(36+2)

		local inventorylist = p:INV_Buckets()

		local bump = 0
		for i, bucket in ipairs( inventorylist ) do
			surface.SetDrawColor( scheme["bg"] )
			surface.DrawRect( bump + b, b, size_num, size_num )

			if i==bucket_selected then
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

			local ybump = 0
			if i!=bucket_selected then
				for d, item in ipairs( bucket ) do
					surface.SetDrawColor( scheme["bg"] )
					surface.DrawRect( bump + b, (item_start+ybump) + b, size_texty, size_texty )
					ybump = ybump + (item_gap)
				end
				bump = bump + (nextwe_no)
			else
				for d, item in ipairs( bucket ) do
					local idata = WEAPONS[inv[item].Class]
					local sel = d==item_selected
					surface.SetDrawColor( scheme["bg"] )
					surface.DrawRect( bump + b, (item_start+ybump) + b, size_textx, (sel and size_texty_sel or size_texty) )
					if sel then
						surface.SetDrawColor( scheme["fg"] )
						surface.DrawRect( bump + b + gap, (item_start+ybump) + b + gap, size_textx - (gap*2), (sel and size_texty_sel or size_texty) - (gap*2) )

						surface.SetTextColor( scheme["bg"] )
						-- PROTO: This is just useful information for me.
						surface.SetFont( "Benny_8" )
						local num = 0
						for i, v in pairs( inv[item] ) do
							surface.SetTextPos( bump + b + ss(3), (item_start+ybump) + b + ss(1+6+(4*num)) )
							surface.DrawText( i .. " : " .. v )
							num = num +1
						end
					else
						surface.SetTextColor( scheme["fg"] )
					end
					surface.SetFont( "Benny_12" )
					surface.SetTextPos( bump + b + ss(3), (item_start+ybump) + b + ss(1) )
					surface.DrawText( idata.Name )

					surface.SetFont( "Benny_8" )
					surface.SetTextPos( bump + b + size_textx - surface.GetTextSize(item) - ss(3), (item_start+ybump) + b + ss(1) )
					surface.DrawText( item )
					ybump = ybump + (d==item_selected and item_gap_sel or item_gap)
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

	local arena = true
	if arena then
		surface.SetDrawColor( scheme["bg"] )

		local r_x, r_y, r_w, r_h = sw/2 - ss(180/2), b, ss(180), ss(30)
		local ib, ic = ss(20), ss(2)
		surface.DrawRect( r_x, r_y, r_w, r_h )

		do -- Time
			local tt = string.FormattedTime( 60-(CurTime() % 60) )
			local d1, d2
			if tt.m > 0 then
				d1 = tt.m -- .. ":"
				d2 = tt.s
				if tt.h > 0 then
					-- d1 = tt.h .. ":" .. d1
				end
			else
				d1 = tt.s -- .. "."
				d2 = math.floor( tt.ms )
			end

			d1 = string.format( "%02i", d1 )
			d2 = string.format( "%02i", d2 )

			if tt.h > 0 then
				d1 = tt.h .. ":" .. d1 .. ":"
			elseif tt.m > 0 then
				d1 = d1 .. ":"
			else
				d1 = d1 .. "."
			end
			
			surface.SetFont( "Benny_36")
			local tx = surface.GetTextSize( d1 )

			local c1, c2, c3, c4 = schema( active, "fg", ((tt.ms/100)%1))

			surface.SetTextColor( c1, c2, c3, c4 )
			surface.SetTextPos( ib + r_x + ss( 24 ) - tx, r_y )
			surface.SetFont( "BennyS_36")
			surface.DrawText( d1 )

			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( ib + r_x + ss( 24 ) - tx, r_y )
			surface.SetFont( "Benny_36")
			surface.DrawText( d1 )

			surface.SetTextColor( c1, c2, c3, c4 )
			surface.SetTextPos( ib + r_x + ss( 24 ), r_y + ss(5) )
			surface.SetFont( "BennyS_28")
			surface.DrawText( d2 )

			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( ib + r_x + ss( 24 ), r_y + ss(5) )
			surface.SetFont( "Benny_28")
			surface.DrawText( d2 )
		end
		do -- Score
			for i=0, 1 do
				local s_w, s_h = ss(100), ss(12)
				local s_x, s_y = r_x + r_w - ic - s_w, ic + r_y + (s_h*i) + (ss(2*i))

				surface.SetDrawColor( scheme["fg"] )
				if i==1 then -- Losing
					surface.DrawOutlinedRect( s_x, s_y, s_w, s_h, math.max( ss(0.5), 1 ) )
					surface.SetTextColor( scheme["fg"] )
				else
					surface.DrawRect( s_x, s_y, s_w, s_h )
					surface.SetTextColor( scheme["bg"] )
				end

				surface.SetFont( "Benny_12")
				surface.SetTextPos( s_x + ss(2), s_y + ss(1) )
				surface.DrawText( i==1 and "HALO" or "CIA" )

				local score = i==1 and "100" or "12000"
				surface.SetTextPos( s_x + s_w - surface.GetTextSize( score ) - ss(2), s_y + ss(1) )
				surface.DrawText( score )
			end
		end
	end
end )

do
	local function Equip()
		local ply = LocalPlayer()
		local buckets = ply:INV_Buckets()
		if buckets[bucket_selected] and buckets[bucket_selected][item_selected] then
			RunConsoleCommand( "benny_inv_equip", buckets[bucket_selected][item_selected] )
		end
	end
	local function Wrap( ply, num )
		local buckets = ply:INV_Buckets()
		if !buckets[num] then return end
		if bucket_selected == num then
			item_selected = item_selected + 1
			if item_selected > #buckets[bucket_selected] then
				item_selected = 1
			end
		else
			bucket_selected = num
			item_selected = 1
		end
		Equip()
	end
	local qt = {
		["invnext"] = function( ply )
			local buckets = ply:INV_Buckets()
			item_selected = item_selected + 1
			for i=1, #buckets do
				if item_selected > #buckets[bucket_selected] then
					bucket_selected = bucket_selected + 1
					item_selected = 1
				end
				if bucket_selected > #buckets then bucket_selected = 1 item_selected = 1 end
				if buckets[bucket_selected][item_selected] then
					Equip()
					break
				end
			end
		end,
		["invprev"] = function( ply )
			local buckets = ply:INV_Buckets()
			item_selected = item_selected - 1
			for i=1, #buckets do
				if item_selected < 1 then
					bucket_selected = bucket_selected - 1
					if bucket_selected < 1 then bucket_selected = #buckets end
					item_selected = #buckets[bucket_selected]
					if buckets[bucket_selected][item_selected] then
						Equip()
						break
					end
				end
			end
			Equip()
		end,
		["slot1"] = function( ply )
			Wrap( ply, 1 )
		end,
		["slot2"] = function( ply )
			Wrap( ply, 2 )
		end,
		["slot3"] = function( ply )
			Wrap( ply, 3 )
		end,
		["slot4"] = function( ply )
			Wrap( ply, 4 )
		end,
		["slot5"] = function( ply )
			Wrap( ply, 5 )
		end,
		["slot6"] = function( ply )
			Wrap( ply, 6 )
		end,
		["slot7"] = function( ply )
			Wrap( ply, 7 )
		end,
		["slot8"] = function( ply )
			Wrap( ply, 8 )
		end,
		["slot9"] = function( ply )
			Wrap( ply, 9 )
		end,
		["slot0"] = function( ply )
			Wrap( ply, 0 )
		end,
	}
	hook.Add( "PlayerBindPress", "Benny_PlayerBindPress", function( ply, bind, pressed, code )
		if qt[bind] and pressed then
			qt[bind]( ply )
			return true
		end
	end)
end