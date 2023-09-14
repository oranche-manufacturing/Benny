
-- 

local debugcolor = Color( 255, 0, 255, 1 )

tempmapcameras = {}

tempmapcameras["benny_test"] = {}

tempmapcameras["benny_test"]["main"] = {
	Type = "Standard",
	Pos = Vector( -692, 0, 268 ),
	Ang = Angle( 55, 0, 0 ),
	FOV = 90,
	Checks = {
		{
			Vector( -390, 510, 0 ),
			Vector( -924, -509, -90 ),
		},
	},

	iX1 = -550,
	iX2 = -800,
	Special = function( self, ply )
		local pos = Vector()
		pos:Set( self.Pos )
		local ang = Angle()
		ang:Set( self.Ang )

		local ppos = ply:GetPos()
		pos.y = ppos.y

		do -- Angle
			local amt = math.TimeFraction( self.iX1, self.iX2, ppos.x )
			debugoverlay.Line( Vector( self.iX1, 0, 0 ), Vector( self.iX2, 0, 0 ), 0, debugcolor, true )
			amt = math.Clamp( amt, 0, 1 )
			amt = math.ease.InOutCubic( amt )
			ang.p = ang.p + ( 25 * (amt) )
			pos.x = pos.x - ( 170 * (amt) )
		end

		return pos, ang, self.FOV
	end
}

tempmapcameras["benny_test"]["grass"] = {
	Pos = Vector( -1622, -214, 284 ),
	Ang = Angle( 70, 0, 0 ),
	FOV = 90,
	Checks = {
		{
			Vector( -931, -130, 0 ),
			Vector( -1311, -319, -70 ),
		},
		{
			Vector( -1321, 506, 0 ),
			Vector( -1813, -503, -70 ),
		},
	},

	iX1 = -900,
	iX2 = -1330,

	iX3 = -1400,
	iX4 = -1750,
	Special = function( self, ply )
		local pos = Vector()
		pos:Set( self.Pos )
		local ang = Angle()
		ang:Set( self.Ang )
		local fov = self.FOV

		local ppos = ply:GetPos()
		pos.y = ppos.y

		do -- far
			local amt = math.TimeFraction( self.iX1, self.iX2, ppos.x )
			debugoverlay.Line( Vector( self.iX1, ppos.y, ppos.z ), Vector( self.iX2, ppos.y, ppos.z ), 0, debugcolor, true )
			amt = 1-math.Clamp( amt, 0, 1 )
			amt = math.ease.InOutSine( amt )
			ang.p = ang.p - ( 11 * amt )
			pos.x = pos.x + ( 400 * amt )
			fov = fov - ( 22 * amt )
		end

		do -- close
			local amt = math.TimeFraction( self.iX3, self.iX4, ppos.x )
			debugoverlay.Line( Vector( self.iX3, ppos.y, ppos.z ), Vector( self.iX4, ppos.y, ppos.z ), 0, debugcolor, true )
			amt = math.Clamp( amt, 0, 1 )
			amt = math.ease.InOutCubic( amt )
			pos.x = pos.x - ( 150 * (amt) )
			ang.p = ang.p + ( 0 * (amt) )
		end

		return pos, ang, fov
	end
}

tempmapcameras["benny_test"]["barber"] = {
	Pos = Vector( -64, -126, 54 ),
	Ang = Angle( 15, 45, 0 ),
	FOV = 90,
	Checks = {
		{
			Vector( -382, 128, 0 ),
			Vector( 128, -128, -70 ),
		},
	},

	Special = function( self, ply )
		local pos = Vector()
		pos:Set( self.Pos )
		local ang = Angle()
		ang:Set( self.Ang )
		local fov = self.FOV

		local ppos = ply:GetPos()
		pos.x = pos.x + ppos.x

		pos.x = math.max( pos.x, -378 )

		return pos, ang, fov
	end
}

BENNY_ACTIVECAMERA = nil

local c_over = CreateConVar( "benny_cam_override", "" )
local c_unlock = CreateConVar( "benny_cam_unlock", 0 )

local si = 4
local ctrace = {
	start = nil,
	endpos = nil,
	mins = Vector( -si, -si, -si ),
	maxs = Vector( si, si, si ),
	mask = MASK_SHOT_HULL,
	filter = nil,
}
local tempcam = {
	FOV = 90,

	Special = function( self, ply )
		local pos = Vector()
		local ang = Angle()
		local fov = self.FOV
		local ppos = ply:GetPos()
		local pang = ply:EyeAngles()

		pos:Set( ppos )
		ang:Add( pang )

		pos.z = pos.z + 68
		ctrace.start = pos
		ctrace.endpos = pos + ( ang:Forward() * -60 ) + ( ang:Right() * 20 )
		ctrace.filter = ply
		local tr = util.TraceHull( ctrace )

		pos = tr.HitPos

		return pos, ang, fov
	end
}

local function decide_active()
	-- print( LocalPlayer():GetPos() )
	-- BENNY_ACTIVECAMERA = tempcam
	if tempmapcameras[ game.GetMap() ] then
		for name, camera in pairs( tempmapcameras[ game.GetMap() ] ) do
			if camera.Checks then
				for i, v in ipairs(camera.Checks) do
					if LocalPlayer():GetPos():WithinAABox( v[1], v[2] ) then
						debugoverlay.Box( vector_origin, v[1], v[2], 0, debugcolor )
						BENNY_ACTIVECAMERA = camera
						return true
					end
				end
			end
		end
	end
	return false
end

hook.Add( "CalcView", "MyCalcView", function( ply, pos, ang, fov )
	if c_unlock:GetBool() then return end
	if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
	decide_active()
	local camera = BENNY_ACTIVECAMERA
	if camera then
		local view = {
			origin = camera.Pos,
			angles = camera.Ang,
			fov = camera.FOV or 60,
			drawviewer = true
		}
		if camera.Special then
			view.origin, view.angles, view.fov = camera.Special( camera, ply )
		end

		local st = c_over:GetString()
		if st != "" then
			local st = string.Explode( " ", st )
			view.origin.x	= tonumber(st[1])
			view.origin.y	= tonumber(st[2])
			view.origin.z	= tonumber(st[3])

			view.angles.x	= tonumber(st[4])
			view.angles.y	= tonumber(st[5])
			view.angles.z	= tonumber(st[6])

			view.fov		= tonumber(st[7])
		end

		view.fov = Convert( view.fov, (ScrH()/ScrW())/(3/4) )
		return view
	end
end )

function Convert( fovDegrees, ratio )
	local halfAngleRadians = fovDegrees * ( 0.5 * math.pi / 180 )
	local t = math.tan( halfAngleRadians )
	t = t * ratio
	local retDegrees = ( 180 / math.pi ) * math.atan( t )
	return retDegrees * 2
end

concommand.Add("benny_cam_panel", function()
	if IsValid( CamPanel ) then CamPanel:Remove() end
	CamPanel = vgui.Create( "DFrame" )
	local a = CamPanel
	a:SetSize( 320, 280 )
	a:Center()
	a:MakePopup()
	
	local st = c_over:GetString()
	if st == "" then
		st = "0 0 0 0 0 0 90"
	end
	st = string.Explode( " ", st )

	for i=1, 3 do
		local t = a:Add("DLabel")
		t:SetSize( 300, 14 )
		t:DockMargin( 20, 2, 20, 2 )
		t:Dock( TOP )
		t:SetText( i==1 and "Hold CONTROL to Right/Forward/Up" or
					i==2 and "Hold SHIFT to multiply 10x" or 
					i==3 and "Hold ALT to multiply 2x" )
	end

	local bloink = {}
	for i=1, 3 do
		local b = vgui.Create("DNumberWang")
		bloink[i] = b
		b:SetSize( 200, 20 )
		b:DockMargin( 20, 2, 20, 2 )
		b:SetText( st[i] )
		b:SetMinMax( -math.huge, math.huge )

		b.OnValueChanged = function(self)
			st[i] = self:GetValue()
			c_over:SetString( table.concat( st, " " ) )
		end
		
		local d = vgui.Create("DPanel")
		for u=1, 6 do
			local bu = d:Add("DButton")
			bu:Dock( LEFT )
			bu:SetSize( 29, 24 )
			bu:DockMargin( 0, 0, 2, 0 )
			local wa = 0
			if u==1 then
				wa = -10
			elseif u==2 then
				wa = -5
			elseif u==3 then
				wa = -1
			elseif u==4 then
				wa = 1
			elseif u==5 then
				wa = 5
			elseif u==6 then
				wa = 10
			end
			bu:SetText( wa )
			function bu:DoClick( )
				local wa = wa
				if input.IsKeyDown( KEY_LALT ) then
					wa = wa * 2
				end
				if input.IsKeyDown( KEY_LSHIFT ) then
					wa = wa * 10
				end
				if input.IsKeyDown( KEY_LCONTROL ) then
					local wawa = Vector()

					local new = Angle( st[4], st[5], st[6] )
					wawa = i==1 and new:Right() or i==2 and new:Forward() or new:Up()
					wawa:Mul(wa)

					st[1] = st[1] + wawa[1]
					st[2] = st[2] + wawa[2]
					st[3] = st[3] + wawa[3]
					bloink[1]:SetValue( st[1] )
					bloink[2]:SetValue( st[2] )
					bloink[3]:SetValue( st[3] )
					return
				end
				b:SetValue( b:GetValue() + wa )
			end
		end

		local c = a:Add("DHorizontalDivider")
		c:Dock( TOP )
		c:DockMargin( 10, 0, 10, 0 )
		c:SetLeft(b)
		c:SetRight(d)

	end
	for i=1, 3 do
		local b = a:Add("DNumSlider")
		bloink[i+3] = b
		b:SetSize( 200, 20 )
		b:Dock( TOP )
		b:DockMargin( 20, 2, 20, 2 )
		b:SetText( i==1 and "Pitch" or i==2 and "Yaw" or "Roll" )
		b:SetMin( -360 )
		b:SetMax( 360 )
		b:SetValue( st[i+3] )
		b:SetDecimals( 1 )

		b.OnValueChanged = function( self, val )
			val = math.NormalizeAngle( val )
			self:SetValue( val )
			
			st[i+3] = val
			c_over:SetString( table.concat( st, " " ) )
		end
	end
	do
		local b = a:Add("DNumSlider")
		bloink[7] = b
		b:SetSize( 200, 20 )
		b:Dock( TOP )
		b:DockMargin( 20, 2, 20, 2 )
		b:SetText( "Field of View" )
		b:SetMin( 0 )
		b:SetMax( 90 )
		b:SetValue( st[7] )

		b.OnValueChanged = function(self)
			st[7] = self:GetValue()
			c_over:SetString( table.concat( st, " " ) )
		end
	end
	do
		local b = vgui.Create("DButton")
		b:SetText( "Steal from current" )
		function b:DoClick()
			local ply = LocalPlayer()
			local ppos = ply:EyePos()
			local pang = ply:EyeAngles()
			for i=1, 7 do
				if i==1 then
					bloink[i]:SetValue( ppos[1] )
				elseif i==2 then
					bloink[i]:SetValue( ppos[2] )
				elseif i==3 then
					bloink[i]:SetValue( ppos[3] )
				elseif i==4 then
					bloink[i]:SetValue( pang[1] )
				elseif i==5 then
					bloink[i]:SetValue( pang[2] )
				elseif i==6 then
					bloink[i]:SetValue( pang[3] )
				elseif i==7 then
					bloink[i]:SetValue( 90 )
				end
				c_over:SetString( table.concat( st, " " ) )
			end
		end
		local d = vgui.Create("DButton")
		d:SetText( "Reset" )
		function d:DoClick()
			for i=1, 7 do
				bloink[i]:SetValue( i==7 and 90 or 0 )
			end
			c_over:SetString("")
		end
		local c = a:Add("DHorizontalDivider")
		c:Dock( TOP )
		c:DockMargin( 10, 0, 10, 0 )
		c:SetLeft(b)
		c:SetRight(d)
	end
end)

concommand.Add( "benny_dev_eyetrace", function( ply )
	local tr = ply:GetEyeTrace()
	print( string.format("Vector( %i, %i, %i )", math.Round( tr.HitPos.x ), math.Round( tr.HitPos.y ), math.Round( tr.HitPos.z ) ) )
	print( tr.Entity )
end)