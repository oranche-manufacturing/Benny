
-- 

BENNY.Cameras = {}

BENNY.Cameras["main"] = {
	Type = "Standard",
	Pos = Vector( 235.24, 0, 280 ),
	Ang = Angle( 75, -180, 0 ),
	FOV = 67,
	Corner1 = Vector( 240, -240, 0 ),
	Corner2 = Vector( -240, 240, -130 ),
	v1 = Vector( 180, 0, -128 ),
	v2 = Vector( -180, 0, -128 ),
	Special = function( self, ply )
		local pos = Vector()
		pos:Set( self.Pos )
		local ang = Angle()
		ang:Set( self.Ang )

		debugoverlay.Cross( self.v1, 8, 0, color_white, true )
		debugoverlay.Cross( self.v2, 8, 0, color_white, true )

		local amt = math.TimeFraction( self.v1.x, self.v2.x, ply:GetPos().x )
		amt = math.Clamp( amt, 0, 1 )
		ang.p = ang.p - ( 23 * amt )
		pos.x = pos.x - ( 270/2 * amt )
		return pos, ang, self.FOV
	end
}


BENNY.Cameras["hall"] = {
	Type = "Fixed",
	Pos = Vector( 794, -40, 84 ),
	Ang = Angle( 29, 180, 0 ),
	Corner1 = Vector( 273, -111, 0 ),
	Corner2 = Vector( 751, 99, -130 ),
	v1 = Vector( 400, 0, -128 ),
	v2 = Vector( 630, 0, -128 ),
	FOV = 67,
	Special = function( self, ply )
		local pos = Vector()
		pos:Set( self.Pos )
		local ang = Angle()
		ang:Set( self.Ang )

		debugoverlay.Cross( self.v1, 8, 0, color_white, true )
		debugoverlay.Cross( self.v2, 8, 0, color_white, true )

		local amt = math.TimeFraction( self.v1.x, self.v2.x, ply:GetPos().x )
		amt = math.Clamp( amt, 0, 1 )
		ang.p = ang.p + ( 32 * amt )
		pos.x = pos.x - ( 50 * (1-amt) )
		return pos, ang, self.FOV
	end
}


BENNY.Cameras["racks"] = {
	Type = "Standard",
	Pos = Vector( 120, 0, 280 ),
	Ang = Angle( 60, 180, 0 ),
	Corner1 = Vector( 890, 135, 0 ),
	Corner2 = Vector( -253, 765, -130 ),
	v1 = Vector( 870, 135, -130 ),
	v2 = Vector( 760, 135, -130 ),
	v3 = Vector( 890, 135, -130 ),
	v4 = Vector( -253, 135, -130 ),
	FOV = 75,
	Special = function( self, ply )
		local pos = Vector()
		pos:Set( ply:GetPos() )
		pos:Add( self.Pos )
		local ang = Angle()
		ang:Set( self.Ang )

		debugoverlay.Cross( self.v1, 8, 0, color_white, true )
		debugoverlay.Cross( self.v2, 8, 0, color_white, true )

		pos.x = math.Clamp( pos.x, -200, 890 )
		pos.y = math.Clamp( pos.y, 300, 600 )

		do -- close to back wall
			local amt = math.TimeFraction( self.v1.x, self.v2.x, ply:GetPos().x )
			amt = math.Clamp( amt, 0, 1 )
			-- pos.x = pos.x - ( (150) * (1-amt) )
			ang.p = ang.p + ( 10 * (1-amt) )
		end

		do -- stretch
			local amt = math.TimeFraction( self.v3.x, self.v4.x, ply:GetPos().x )
			amt = math.Clamp( amt, 0, 1 )
			-- pos.x = pos.x - ( (1143) * (amt) )
		end


		return pos, ang, self.FOV
	end
}

BENNY_ACTIVECAMERA = "main"

local c_over = CreateConVar( "benny_cam_override", "" )
local c_unlock = CreateConVar( "benny_cam_unlock", 0 )

hook.Add( "CalcView", "MyCalcView", function( ply, pos, ang, fov )
	if c_unlock:GetBool() then return end
	for i, v in pairs( BENNY.Cameras ) do
		if v.Corner1 and v.Corner2 then
			if ply:GetPos():WithinAABox( v.Corner1, v.Corner2 ) then
				BENNY_ACTIVECAMERA = i
				break
			end
		end
	end
	local camera = BENNY.Cameras[BENNY_ACTIVECAMERA]
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
			for i=1, 7 do
				if i==1 then
					bloink[i]:SetValue( BENNY_ACTIVECAMERA:GetPos()[1] )
				elseif i==2 then
					bloink[i]:SetValue( BENNY_ACTIVECAMERA:GetPos()[2] )
				elseif i==3 then
					bloink[i]:SetValue( BENNY_ACTIVECAMERA:GetPos()[3] )
				elseif i==4 then
					bloink[i]:SetValue( -BENNY_ACTIVECAMERA:GetAngles()[1] )
				elseif i==5 then
					bloink[i]:SetValue( BENNY_ACTIVECAMERA:GetAngles()[2] )
				elseif i==6 then
					bloink[i]:SetValue( BENNY_ACTIVECAMERA:GetAngles()[3] )
				elseif i==7 then
					bloink[i]:SetValue( BENNY_ACTIVECAMERA.FOV )
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
	print( string.format("Vector( %f, %f, %f )", tr.HitPos.x, tr.HitPos.y, tr.HitPos.z ) )
	print( tr.Entity )
end)