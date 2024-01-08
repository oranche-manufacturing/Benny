
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

function ss( scale )
	return scale*ConVarCL_Int("hud_scale")--math.Round( scale * ( ScrH() / 480 ) * HSCALE:GetFloat() )
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

local activescheme = ConVarCL("hud_tempactive")
function schema( i2, alpha )
	local i1 = activescheme:GetString()
	return schemes[i1][i2].r, schemes[i1][i2].g, schemes[i1][i2].b, (alpha or 1)*255
end

local junker = Color( 0, 0, 0, 0 )
function schema_c( i2, alpha )
	local r,g,b,a=schema( i2, alpha )
	junker.r=r
	junker.g=g
	junker.b=b
	junker.a=a
	return junker
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
		if wehlast.text == text then
			wehlast.repeated = wehlast.repeated + 1
		else
			table.insert( weh.lines, { text = text, time_to_type=time_to_type, starttime=CurTime(), repeated = 1 } )
		end
		weh.lifetime = math.max( CurTime() + lifetime, weh.lifetime )
	else
		table.insert( captions, { name = name, color=color, lifetime=CurTime()+lifetime, lines = { { text=text, time_to_type=time_to_type, starttime=CurTime(), repeated = 1 } } })
	end
end

local color_caption = Color( 0, 0, 0, 127 )
local mat_grad = Material( "benny/hud/grad.png", "mips smooth" )

local lonk = {
	{
		Glyph = "W",
		Glyph2 = "S",
		Text1 = "MOVE",
		Text2 = "Forward and backward",
	},
	{
		Glyph = "A",
		Glyph2 = "D",
		Text1 = "STRAFE",
		Text2 = "Left and right",
	},
	{
		Spacer = true,
	},
	{
		Glyph = "R",
		Glyph2 = "T",
		Text1 = "RELOAD",
		Text2 = "Reload weapon",
	},
	{
		Glyph = "F",
		Text1 = "AIM",
		Text2 = "Enter weapon mode",
	},
	{
		Spacer = true,
	},
	{
		Glyph = "SHIFT",
		Text1 = "STUNT",
		Text2 = "Do a barrel roll",
	},
	{
		Glyph = "CTRL",
		Text1 = "STANCE",
		Text2 = "Get down",
	},
	{
		Spacer = true,
	},
	{
		Glyph = "F1",
		Text1 = "SETTINGS",
		Text2 = "Set settings",
	},
	{
		Glyph = "F2",
		Text1 = "DEV. INVENTORY",
		Text2 = "Manage inventory",
	},
	{
		Glyph = "F3",
		Text1 = "DEV. SPAWN",
		Text2 = "Cheat items in",
	},
	--{
	--	Glyph = "F4",
	--	Text1 = "CHOREOGRAPHER",
	--	Text2 = "Manage scenes",
	--},
}

-- Stew port
globhit = Vector()
globang = Angle()
tr1f = Vector()
tr2f = Vector()
local col_1 = Color(255, 255, 255, 200)
local col_1a = Color(100, 100, 255, 200)
local col_2 = Color(0, 0, 0, 255)
local col_3 = Color(255, 127, 127, 255)
local col_4 = Color(255, 222, 222, 255)
local mat_dot = Material("benny/hud/xhair/dotx.png", "smooth")
local mat_long = Material("benny/hud/xhair/long.png", "smooth")
local mat_dot_s = Material("benny/hud/xhair/dot_s.png", "mips smooth")
local mat_long_s = Material("benny/hud/xhair/long_s.png", "mips smooth")
local spacer_long = 3 -- screenscaled
local spacer = 1 -- screenscaled

local trash_vec, trash_ang = Vector(), Angle()

bucket_selected = bucket_selected or 1
item_selected = item_selected or 1

hook.Add( "HUDPaint", "Benny_HUDPaint", function()
	local sw, sh = ScrW(), ScrH()
	local Wb = sh*0.05--ss(20)
	local Hb = sh*0.05--ss(20)

	-- Wb = (sh*(4/3))
	-- Wb = (sw-Wb)/2

	local p = LocalPlayer()
	local wep = p:BennyCheck()

	local active = GetConVar("benny_hud_tempactive"):GetString()
	local scheme = schemes[active]

	if ConVarCL_Bool("hud_enable_health") then -- Health
		local b_w, b_h = ss(142), ss(32)
		local b_bh = ss(14)
		local b_bh2 = ss(8)
		local b_s = ss(4)
		local b_s2 = b_s*2
		local b_x, b_y = Wb, sh - Hb - b_h
		-- BG
		surface.SetDrawColor( scheme["bg"] )
		surface.DrawRect( b_x, b_y, b_w, b_h )

		local hp = p:Health()/100 --CurTime()*0.5 % 1
		local ti = (CurTime()*0.75 / (hp)) % 1
		
		-- Text underneath
		surface.SetFont( "Benny_18" )
		surface.SetTextColor( scheme["fg"] )
		surface.SetTextPos( b_x + ss(6), b_y + ss(3) )
		surface.DrawText( scheme["name"] )

		-- Bar
		surface.SetDrawColor( scheme["fg"] )
		surface.DrawOutlinedRect( b_x + b_s, b_y + b_s, ss(142-8), b_bh, ss( 0.5 ) )
		surface.DrawRect( b_x + b_s + ss(1), b_y + b_s + ss(1), ss(142*hp-8-2), b_bh - ss(2) )

		surface.SetDrawColor( 255, 255, 255, math.ease.OutQuint(1-ti)*255 )
		surface.SetMaterial( mat_grad )
		surface.DrawTexturedRect( b_x + b_s + ss(1), b_y + b_s + ss(1), ss(142*hp*ti-8-2), b_bh - ss(2) )

		-- Bar text
		surface.SetTextColor( scheme["bg"] )
		surface.SetTextPos( b_x + ss(6), b_y + ss(3) )
		render.SetScissorRect( b_x + b_s, b_y + b_s, b_x + b_s + ss(142*hp-8), b_y + b_s + b_bh, true ) -- Enable the rect
			surface.DrawText( scheme["name"] )
		render.SetScissorRect( 0, 0, 0, 0, false ) -- Disable after you are done

		if true then -- Stamina
			local perc = p:GetStamina()
			for i=1, 4 do
				local localperc = math.Clamp( math.Remap( perc, (0.25*(i-1)), (0.25*(i)), 0, 1 ), 0, 1 )
				surface.SetDrawColor( scheme["fg"] )
				surface.DrawOutlinedRect( b_x + b_s + ((i-1)*ss(32+2)), b_y + b_bh + ss(4+2), ss(32), b_bh2, ss(0.5) )
				surface.DrawRect( b_x + b_s + ((i-1)*ss(32+2)) + ss(1), b_y + b_bh + ss(4+2) + ss(1), ss(32*localperc) - ss(2), b_bh2 - ss(2) )
			end
		end
		
		if true then
			surface.SetDrawColor( schema("bg") )
			local s_h = ss(14)
			local s_w = ss(46)
			surface.DrawRect( b_x, b_y - s_h - ss(2), s_w, s_h )

			draw.SimpleText( string.format( "%f", p:GetVelocity():Length2D()/39.3701 ):Left( 4 ), "Benny_12", b_x + ss(4), b_y - s_h - ss(2-2), schema_c("fg") )
			draw.SimpleText( "m/s", "Benny_12", b_x + s_w - ss(4), b_y - s_h - ss(2-2), schema_c("fg"), TEXT_ALIGN_RIGHT )
		end
	end

	do -- Vaulting
		if vaultsave then
			local tex = "[SPACE] VAULT OVER"
			if vaultsave == 2 then tex = "[SPACE] MANTLE OVER" end

			surface.SetFont( "Benny_16" )
			local tox, toy = surface.GetTextSize( tex )
			local box, boy = ss( 8 ) + tox, ss( 18 )
			surface.SetDrawColor( scheme["bg"] )
			surface.DrawRect( sw/2 - box/2, sh/2 + ss( 96 ) - boy/2 - ss( 2 ), box, boy )

			surface.SetTextColor( scheme["fg"] )
			surface.SetTextPos( sw/2 - tox/2, sh/2 + ss( 96 ) - toy/2 )
			surface.DrawText( tex )
		end
	end

	if ConVarCL_Bool("hud_enable_hints") then -- Hints
		local b_w, b_h = ss(130), ss(0)
		local b_x, b_y = sw - Wb - b_w, Hb + ss(200)--sh/2 - b_h/2

		local honk = ss(1)
		local honk2 = honk*2

		local tbw, tbh, tbg = ss(6), ss(2), ss(12)

		local bump = 0
		local tbump = 0


		for _, data in ipairs( lonk ) do
			if _==1 then
				tbump = tbump + ss(4)
			end
			if data.Spacer then
				tbump = tbump + ss(5)
			else
				tbump = tbump + ss(16)
			end
			if _==#lonk then
				tbump = tbump + ss(4)
			end
		end

		b_h = b_h + tbump
		b_y = sh/2 - b_h/2

		surface.SetDrawColor( scheme["bg"] )
		surface.DrawRect( b_x, b_y, b_w, b_h )
		
		surface.SetDrawColor( scheme["fg"] )
		surface.DrawOutlinedRect( b_x + honk, b_y + honk, b_w - honk2, b_h - honk2, ss(0.5) )
		for _, data in ipairs( lonk ) do
			if _==1 then
				bump = bump + ss(4)
			end

			-- surface.SetDrawColor( 0, 100, 255, 32 )
			-- surface.DrawRect( b_x, b_y + bump, b_w, ss(16) )
			if data.Spacer then
				surface.SetDrawColor( scheme["fg"] )
				surface.DrawRect( b_x + ss(4), b_y + ss(2) + bump, b_w - ss(8), ss(1) )
				bump = bump + ss(5)
			else
				draw.SimpleText( data.Text1, "Benny_12", b_x + b_w - tbw,
				b_y + bump,
				scheme["fg"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

				draw.SimpleText( data.Text2, "Benny_8", b_x + b_w - tbw,
				b_y+ss(8) + bump,
				scheme["fg"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

				if #data.Glyph == 1 then
					surface.SetDrawColor( scheme["fg"] )
					surface.DrawOutlinedRect( b_x + tbw,
					b_y + ss(2) + bump, tbg, tbg, ss(1) )
					draw.SimpleText( data.Glyph, "Benny_12", b_x + tbw + tbg/2,
					b_y + ss(2.6) + bump,
					scheme["fg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

					if data.Glyph2 then
						surface.SetDrawColor( scheme["fg"] )
						surface.DrawOutlinedRect( b_x + tbw + tbg + ss(2),
						b_y + ss(2) + bump, tbg, tbg, ss(1) )
						draw.SimpleText( data.Glyph2, "Benny_12", b_x + tbw + tbg/2 + tbg + ss(2),
						b_y + ss(2.6) + bump,
						scheme["fg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					end
				else
					surface.SetFont( "Benny_10" )
					local tx = ss((#data.Glyph*5)+5) surface.GetTextSize( data.Glyph )
					--tx = math.max( tx + ss(8), tbg )

					surface.SetDrawColor( scheme["fg"] )
					surface.DrawOutlinedRect( b_x + tbw,
					b_y + ss(2) + bump, tx, tbg, ss(1) )
					draw.SimpleText( data.Glyph, "Benny_10", b_x + tbw + tx/2,
					b_y + ss(3.6) + bump,
					scheme["fg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				end
				bump = bump + ss(16)
			end
			if _==#lonk then
				bump = bump + ss(4)
			end
		end
	end

	
	if wep and ConVarCL_Bool("hud_enable_active") then -- Weapon
		local inv = p:INV_Get()
		local wep1 = wep:bWepTable( false )
		local wep1c = wep:bWepClass( false )
		local wep2 = wep:bWepTable( true )
		local wep2c = wep:bWepClass( true )

		for i=1, 2 do
			local hand = i==2
			if wep:bWepTable( hand ) then -- New Weapon HUD
				local wep_table = wep:bWepTable( hand )
				local wep_class = wep:bWepClass( hand )

				local p_w, p_h = ss(156), ss(64)
				local p_x, p_y = sw - p_w - Wb, Hb
				if hand then p_x = Wb end
				local pb = ss(4)
				local pb2 = pb*2

				surface.SetDrawColor( scheme["bg"] )
				surface.DrawRect( p_x, p_y, p_w, p_h )

				do -- Name tag
					local t_h = ss(15)
					surface.SetDrawColor( scheme["fg"] )
					surface.DrawRect( p_x+pb, p_y+pb, p_w-pb2, t_h )

					draw.SimpleText( wep_class.Name, "Benny_16", p_x+ss(6), p_y+ss(5), scheme["bg"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
					
					local identicallist = p:INV_Find( wep:bWepTable( hand ).Class )
					identicallist = table.Flip( identicallist )
					local numba = identicallist[ wep:bGetInvID( hand ) ]
					draw.SimpleText( "#" .. tostring(numba) .. ", " .. wep:bGetInvID( hand ), "Benny_10", p_x+p_w-pb2, p_y+ss(7), scheme["bg"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

					if wep_class.Firemodes then -- Firemode
						surface.SetDrawColor( scheme["fg"] )
						surface.DrawRect( p_x+pb, p_y + pb + t_h + ss(2), ss(30), ss(10) )

						draw.SimpleText( wep:B_FiremodeName( hand ), "Benny_12", p_x + pb + ss(14.5), p_y + pb + t_h + ss(8), scheme["bg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						-- draw.SimpleText( "[AMMO TYPE]", "Benny_10", p_x + pb + ss(30+4), p_y + pb + t_h + ss(8), scheme["fg"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
					if wep:bMagClass( hand ) then -- Ammo
						local b_w, b_h = ss(3), ss(10)
						local lw, lh = ss(2), ss(2)
						surface.SetDrawColor( scheme["fg"] )

						local ammo = math.max( wep:bGetIntClip( hand ), wep:bMagClass( hand ).Ammo )
						if ammo>30 then b_w, b_h = ss(3), ss(4) end

						local offset = b_h
						local count = 1
						for i=1, ammo do
							local thefunk = surface.DrawRect
							if i > wep:bGetIntClip( hand ) then
								thefunk = surface.DrawOutlinedRect
							end
							if i!=1 and i%30 == 1 then
								count = 1
								offset = offset + b_h + lh
							end
							thefunk( p_x + p_w - b_w - pb - ((count-1)*(b_w+lw)), p_y + p_h - offset - pb, b_w, b_h, ss(0.5) )
							count = count + 1
						end
						draw.SimpleText( wep:bGetIntClip( hand ), "Benny_12", p_x + p_w - pb - ss(1), p_y + p_h - offset - ss(12+3), scheme["fg"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

						if wep:bGetMagInvID( hand ) != wep_table.Loaded then
							surface.SetDrawColor( scheme["bg"] )
							surface.DrawRect( p_x, p_y - ss( 12+3 ), ss( 66 ), ss( 12 ) )
							draw.SimpleText( "!! Mag desync.", "Benny_12", p_x + ss( 2 ), p_y - ss( 12+2 ), scheme["fg"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
						end
					end
					if wep_class.AmmoStd then -- Magazines
						local m_w, m_h = ss( 12 ), ss( 20 )
						local m_x, m_y = p_x + p_w - m_w, p_y + p_h + ss(1)--p_x - m_w, p_y + p_h - m_h
						local bb = ss( 1 )
						local b2 = ss( 2 )
						local b3 = ss( 3 )
						local b4 = ss( 4 )
						local maglist = p:INV_FindMagSmart( wep_class.ClassName, wep:bGetInvID( hand ) )
						for id, tag in ipairs( maglist ) do
							--assert( inv[tag], "That magazine doesn't exist. " .. tag )
							local chunk = ((ss(1)+m_w)*(id-1))
							surface.SetDrawColor( scheme["bg"] )
							surface.DrawRect( m_x - chunk, m_y, m_w, m_h )

							surface.SetDrawColor( scheme["fg"] )
							surface.DrawOutlinedRect( m_x + bb - chunk, m_y + bb, m_w - b2, m_h - b2, ss( 0.5 ) )

							local s1 = (m_h - b2 - b2)
							local s2 = (m_h - b2 - b2) * (inv[tag] and ( inv[tag].Ammo / WeaponGet(inv[tag].Class).Ammo ) or 8)
							local s3 = math.floor( s2 - s1 )

							local m1, m2, m3, m4 = m_x + bb + bb - chunk, m_y + bb + bb - s3, m_w - b2 - b2, s2
							local active = tag == wep:bGetMagInvID( hand )
							local active2 = tag == wep:bGetMagInvID( !hand )
							if active or active2 then
								draw.SimpleText( active2 and "|" or "x", "Benny_10", m_x + (m_w/2) - chunk, m_y + (m_h/2), scheme["fg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							end
							surface.DrawRect( m1, m2, m3, m4 )

							if active or active2 then
								render.SetScissorRect( m1, m2, m1 + m3, m2 + m4, true )
								draw.SimpleText( active2 and "|" or "x", "Benny_10", m_x + (m_w/2) - chunk, m_y + (m_h/2), scheme["bg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
								render.SetScissorRect( 0, 0, 0, 0, false )
							end
						end
					end
				end
			end
		end
	end

	if wep then -- Crosshair
		
		local dispersion = math.rad( 1 )
		cam.Start3D()
			local lool = ( EyePos() + ( EyeAngles():Forward()*8192 ) + ( dispersion * EyeAngles():Up()*8192 ) ) :ToScreen()
		cam.End3D()
		local gap = ( (ScrH()/2) - lool.y )

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
		local touse1_primary = col_1a
		local touse2 = col_2
		if ConVarCL_String("cam_override") != "" then
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
		
		for hhhh=1, 2 do
			local hand = hhhh==2
			if wep:GetUserAim() and wep:bWepClass( hand ) then -- Crosshair
				local s, w, h = ss, ScrW(), ScrH()

				local gap = gap
				if wep:bWepClass( hand ).Spread then
					gap = gap * wep:BSpread( hand )
				end

				local meow = wep:hFlipHand()
				
				for i=1, 2 do
					local cooler = i == 1 and touse2 or (hand!=meow and touse1_primary or touse1)
					local poosx, poosy = i == 1 and ps_x or pl_x, i == 1 and ps_y or pl_y
					local mat1 = i == 1 and mat_long_s or mat_long
					local mat2 = i == 1 and mat_dot_s or mat_dot
					surface.SetDrawColor( cooler )
					local typ = wep:bWepClass( hand ).Category
					if typ == "rifle" or typ == "sniper" then
						surface.SetMaterial( mat1 )
						surface.DrawTexturedRectRotated( poosx - s(spacer_long) - gap, poosy, s(16), s(16), 0 )
						surface.DrawTexturedRectRotated( poosx + s(spacer_long) + gap, poosy, s(16), s(16), 0 )

						surface.SetMaterial( mat2 )
						surface.DrawTexturedRectRotated( poosx, poosy - gap - s(spacer), s(24), s(24), 0 )
						surface.DrawTexturedRectRotated( poosx, poosy + gap + s(spacer), s(24), s(24), 0 )
					elseif typ == "shotgun" or typ == "smg" or typ == "machinegun" then
						local smg = typ == "smg"
						local lmg = typ == "machinegun"
						surface.SetMaterial( mat1 )
						local split = smg and 3 or lmg and 4 or 8
						for i=(360/split), 360, 360/split do
							local i = i-(360/split)+180 + (lmg and 45 or 0) -- + ( CurTime()*0.25 % 1 )*360
							local ra = math.rad(i)
							local co, si, sl = math.cos(ra), math.sin(ra), s(spacer_long)
							surface.SetMaterial( mat1 )
							local fx, fy = poosx + si*gap + si*sl, poosy + co*gap + co*sl
							fx, fy = math.Round( fx ), math.Round( fy )
							surface.DrawTexturedRectRotated( fx, fy, s(16), s(16), i+(lmg and 0 or 90) )
						end
					elseif typ == "pistol" or typ == "special" then -- pistol
						surface.SetMaterial( mat2 )
						surface.DrawTexturedRectRotated( poosx - gap - s(spacer), poosy, s(24), s(24), 0 )
						surface.DrawTexturedRectRotated( poosx + gap + s(spacer), poosy, s(24), s(24), 0 )

						surface.SetMaterial( mat2 )
						surface.DrawTexturedRectRotated( poosx, poosy - gap - s(spacer), s(24), s(24), 0 )
						surface.DrawTexturedRectRotated( poosx, poosy + gap + s(spacer), s(24), s(24), 0 )
					elseif typ == "grenade" then -- grenade
						surface.SetMaterial( mat2 )
						surface.DrawTexturedRectRotated( poosx, poosy, s(32), s(32), 0 )
						surface.DrawTexturedRectRotated( poosx, poosy, s(32), s(32), 0 )
					end
				end
			end
		end

	end

	if wep and ConVarCL_Bool("hud_enable_hotbar") then -- Newinv
		local weighted = p:INV_Weight()
		local inv = p:INV_Get()
		local iflip = table.Flip( p:INV_Get())

		local b_w = 48
		local b_h = 15

		local b_x, b_y = sw - Wb, sh - Hb - ss(b_h)

		local bump = 0
		local fbump = 0

		local num, tcount = 0, table.Count( weighted )
		for _, item in pairs( weighted ) do
			num = num + 1
			local class = WeaponGet(item.Class)
			local boxsize = ss(b_w)
			fbump = fbump + boxsize
			if num != tcount then
				fbump = fbump + ss(2)
			end
		end
		b_x = b_x - fbump

		local invid = 0
		for _, item in pairs( weighted ) do
			local id = iflip[item]
			local active = wep:bGetReqInvID( false ) == id or wep:bGetReqInvID( true ) == id
			local active_r = wep:bGetReqInvID( false ) == id
			local active_l = wep:bGetReqInvID( true ) == id
			local class = WeaponGet(item.Class)
			local boxsize = ss(b_w)
			surface.SetDrawColor( scheme[active and "fg" or "bg"] )
			surface.DrawRect( b_x + bump, b_y, boxsize, ss(b_h) )
			draw.SimpleText( class.Name, "Benny_8", b_x + bump + boxsize/2, b_y + ss(4), scheme[active and "bg" or "fg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			if active then
				if active_r then
					draw.SimpleText( "R", "Benny_10", b_x + bump + boxsize - ss(2), b_y + ss(b_h) - ss(9), scheme["bg"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
				elseif active_l then
					draw.SimpleText( "L", "Benny_10", b_x + bump + ss(2), b_y + ss(b_h) - ss(9), scheme["bg"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				end
			end
			if class.Features == "firearm" or class.Features == "grenade" or class.Features == "melee" then
				invid = invid + 1
				surface.SetDrawColor( scheme[active and "bg" or "fg"] )
				surface.DrawOutlinedRect( b_x + bump + ss(1), b_y + ss(1), boxsize-ss(2), ss(b_h-2), ss(0.5) )
				if invid < 11 then
					surface.SetDrawColor( scheme[active and "fg" or "bg"] )
					surface.DrawRect( b_x + bump, b_y - ss(2+12), ss(12), ss(12) )
					draw.SimpleText( invid==10 and 0 or invid, "Benny_10", b_x + bump + ss(6), b_y - ss(2+10), scheme[active and "bg" or "fg"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				end
			end

			local maginv = p:INV_FindMagSmart( item.Class, id )
			local magbump = 0
			for _, mag in ipairs( maginv ) do
				local mitem = inv[mag]
				if !mitem then continue end
				local loaded = (item.Loaded == mag)
				local perc = mitem.Ammo/WeaponGet(mitem.Class).Ammo
				surface.SetDrawColor( scheme["bg"] )
				surface.DrawRect( b_x + bump + magbump + ss(13), b_y - ss(14), ss(3), ss(12) )
				surface.SetDrawColor( scheme["fg"] )

				local mstart = ss(10)
				local meow = math.Round(ss(10*perc))
				surface.DrawRect( b_x + bump + magbump + ss(14), b_y - ss(13) + (mstart-meow), ss(1), meow )
				magbump = magbump + ss(2)
			end
			bump = bump + boxsize + ss(2)
		end
	end

	do -- Captions
		local space = Hb
		for aaa, caption in pairs(captions) do
			if caption.lifetime <= CurTime() then captions[aaa] = nil end
			if #caption.lines == 0 then captions[aaa] = nil end
		end
		for aaa, caption in SortedPairsByMemberValue(captions, "starttime", false) do
			surface.SetFont("Benny_Caption_9I")
			local tw = 0
			for i, v in pairs( caption.lines ) do
				local repeater = ( v.repeated > 1 and (" (x" .. v.repeated .. ")") or "" )
				tw = math.max( tw, surface.GetTextSize( v.text .. repeater ) )
			end
			surface.SetFont("Benny_10")
			tw = math.max( tw, surface.GetTextSize( caption.name ) )
			space = space + ss(22)+ss(8*(#caption.lines-1))

			-- BG
			surface.SetDrawColor( color_caption )
			surface.DrawRect( (sw/2) - (ss(8)+tw)/2, sh - space - ss(0), ss(8)+tw, ss(22)+ss(8*(#caption.lines-1)) )
			
			-- PROTO: Would be nice to be able to change italics or bold inline.
			for i, v in SortedPairsByMemberValue( caption.lines, "starttime" ) do
				local repeater = ( v.repeated > 1 and (" (x" .. v.repeated .. ")") or "" )
				surface.SetFont("Benny_Caption_9I")
				surface.SetTextColor( color_white )
				surface.SetTextPos( (sw/2) - (tw/2), sh - space + ss(10) + (ss(8)*(i-1)) )
				local waah = ""
				for i=1, #v.text do
					waah = waah .. ( ((i-1)/#v.text) <= math.TimeFraction( v.starttime, v.starttime + v.time_to_type, CurTime() ) and v.text[i] or " ")
				end
				surface.DrawText( waah .. repeater )
			end

			surface.SetTextColor( caption.color )
			surface.SetFont("Benny_10")
			surface.SetTextPos( (sw/2) - (tw/2), sh - space + ss(2) )
			surface.DrawText( caption.name )
		end
	end

	if false then -- MP / Arena UI
		surface.SetDrawColor( scheme["bg"] )

		local r_x, r_y, r_w, r_h = sw/2 - ss(180/2), Hb, ss(180), ss(30)
		local ib, ic = ss(20), ss(2)
		surface.DrawRect( r_x, r_y, r_w, r_h )

		do -- Time
			local tt = string.FormattedTime( (60*1)-(CurTime() % 60) )
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

			local c1, c2, c3, c4 = schema( "fg", ((tt.ms/100)%1))

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

				local score = i==1 and "100" or "1200"
				surface.SetTextPos( s_x + s_w - surface.GetTextSize( score ) - ss(2), s_y + ss(1) )
				surface.DrawText( score )
			end
		end
	end

	if false and wep then
		local bx, by = sw/2, sh*(0.75)
		local mx = 50

		local wep1_table, wep1_class = wep:bWepTable( false ), wep:bWepClass( false )
		if wep1_table then
			draw.SimpleText( wep1_class.Name, 						"Benny_14", bx-mx, by+ss(8)*-1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( "Clip1: " .. wep:Clip1(),				"Benny_14", bx-mx, by+ss(8)*0, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( "ID1: " .. wep:GetWep1(),				"Benny_14", bx-mx, by+ss(8)*1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( "MagID1: " .. wep:bGetMagInvID( false ),	"Benny_14", bx-mx, by+ss(8)*2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			if wep1_table.Loaded then
				draw.SimpleText( "T_MagID1: " .. wep1_table.Loaded,		"Benny_14", bx-mx, by+ss(8)*3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			end
		end

		local wep2_table, wep2_class = wep:bWepTable( true ), wep:bWepClass( true )
		if wep2_table then
			draw.SimpleText( wep2_class.Name,						"Benny_14", bx+mx, by+ss(8)*-1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "Clip2: " .. wep:Clip2(),				"Benny_14", bx+mx, by+ss(8)*0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "ID2: " .. wep:GetWep2(),				"Benny_14", bx+mx, by+ss(8)*1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "MagID2: " .. wep:bGetMagInvID( true ),	"Benny_14", bx+mx, by+ss(8)*2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			if wep2_table.Loaded then
				draw.SimpleText( "T_MagID2: " .. wep2_table.Loaded,		"Benny_12", bx+mx, by+24*3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
		end
	end

	if true and wep then
		local bump1 = ss(1)
		local bump2 = ss(1)
		local bump4 = ss(2)
		local boost = ss(44)
		local r_w, r_h = ss(8), ss(72)
		for i=1, 2 do
			local hand = i==2
			if hand then boost = -boost end

			local wr = wep:bGetReloadTime( hand )
			local wrt = wep:bGetReloadType( hand )
			if wr > 0 then
				local b1 = math.TimeFraction( wr, wr + wep:GetStat( hand, "Reload_MagIn" ), wr + wep:GetStat( hand, "Reload_MagIn_Bonus1" ) )
				local b2 = math.TimeFraction( wr, wr + wep:GetStat( hand, "Reload_MagIn" ), wr + wep:GetStat( hand, "Reload_MagIn_Bonus2" ) )
				wr = math.TimeFraction( wr, wr + (wrt==1 and wep:GetStat( hand, "Reload_MagIn" ) or wrt==2 and wep:GetStat( hand, "Reload_MagOut" )), RealTime() )
				local r_x, r_y = sw/2 - r_w/2 + boost, sh/2 - r_h/2

				surface.SetDrawColor( schema("bg") )
				surface.DrawRect( r_x - bump4, r_y - bump4, r_w + bump4*2, r_h + bump4*2 )

				surface.SetDrawColor( schema("fg") )
				surface.DrawOutlinedRect( r_x - bump2, r_y - bump2, r_w + bump2*2, r_h + bump2*2, ss(0.5) )

				if wrt == 1 then
					local gump = math.Round( r_h*(1-wr) )
					surface.SetDrawColor( schema("fg") )
					surface.DrawRect( r_x, r_y+gump, r_w, r_h-gump )
				else
					local gump = math.Round( r_h*(wr) )
					surface.SetDrawColor( schema("fg") )
					surface.DrawRect( r_x, r_y+gump, r_w, r_h-gump )
				end
				
				-- TODO: Unshitify this.
				if wrt == 1 then
					local gump1 = math.Round( r_h*(1-b1) )
					local gump2 = math.Round( r_h*(1-b2) )
					surface.SetDrawColor( 255, 100, 100, 100 )
					surface.DrawRect( r_x, r_y+gump2, r_w, gump1-gump2 )
					surface.SetDrawColor( 255, 100, 100 )
					surface.DrawRect( r_x, r_y+gump1, r_w, ss(1) )
					surface.DrawRect( r_x, r_y+gump2, r_w, ss(1) )
				end
			end
		end
	end
end )

do
	local qt = {
		["slot1"] = true,
		["slot2"] = true,
		["slot3"] = true,
		["slot4"] = true,
		["slot5"] = true,
		["slot6"] = true,
		["slot7"] = true,
		["slot8"] = true,
		["slot9"] = true,
		["slot0"] = true,
	}

	hook.Add( "PlayerBindPress", "Benny_PlayerBindPress_Original", function( ply, bind, pressed, code )
		if qt[bind] and pressed then
			return true
		end
	end)
end