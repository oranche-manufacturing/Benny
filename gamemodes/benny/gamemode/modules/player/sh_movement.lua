
-- Movement

local wa, wb = 0, 0

local blop = Angle()
local lastmoveangle = 0
local lastmoveangle_lerp
TPSOverride = TPSOverride or Angle()

hook.Add( "PlayerNoClip", "Benny_PlayerNoClip", function( ply, desiredNoClipState )
	if CLIENT then
		if desiredNoClipState then
			ply:SetEyeAngles( TPSOverride )
		else
			TPSOverride:Set( LocalPlayer():EyeAngles() )
			lastmoveangle = LocalPlayer():EyeAngles().y
			lastmoveangle_lerp = LocalPlayer():EyeAngles().y
		end
	end
end)

hook.Add( "InputMouseApply", "Benny_InputMouseApply", function( cmd, x, y, ang )
	if LocalPlayer():BennyCheck() and !LocalPlayer():NoclippingAndNotVaulting() and GetConVar("benny_cam_override"):GetString() == "" then
		TPSOverride:Add( Angle( y*0.022, -x*0.022, 0 ) )
		return true
	end
end)

hook.Add( "CreateMove", "Benny_CreateMove", function( cmd )
	if false and BENNY_ACTIVECAMERA and !LocalPlayer():NoclippingAndNotVaulting() then
		local x, y = cmd:GetForwardMove(), cmd:GetSideMove()

		local lx=input.GetAnalogValue(ANALOG_JOY_X) // Left X Axis: left -, right +
		local ly=input.GetAnalogValue(ANALOG_JOY_Y) // Left Y Axis: up -, bottom +

		local lr=input.GetAnalogValue(ANALOG_JOY_R) // Right X Axis: left -, right +
		local lu=input.GetAnalogValue(ANALOG_JOY_U) // Right Y Axis: up -, bottom +

		lx=lx/32768; ly=ly/32768; lr=lr/32768; lu=lu/32768; // Conversion to floats -1.0 - 1.0

		if lx != 0 or ly != 0 then
			x, y = ly * -320, lx * 320
		end

		wa, wb = x, y

		local ad = Vector( x, y, 0 )

		local an = Angle()
		an:Set( RenderAngles() )
		an.p = 0

		local am = Angle()
		am:Set( cmd:GetViewAngles() )
		am.p = 0

		ad:Rotate( am )
		ad:Rotate( -an )

		-- ad:Normalize()
		-- ad:Mul(320)

		--cmd:ClearMovement()
		cmd:SetForwardMove( ad.x )
		cmd:SetSideMove( ad.y )

		if x != 0 or y != 0 then
			local thing = Vector( x, -y, 0 ):Angle()
			thing.y = thing.y + an.y
			blop.y = math.ApproachAngle( blop.y, thing.y, FrameTime() * 360 )
		end
		cmd:SetViewAngles( blop )

	end

	local p = LocalPlayer()
	local w = p:GetActiveWeapon()
	if p:BennyCheck() and !LocalPlayer():NoclippingAndNotVaulting() and GetConVar("benny_cam_override"):GetString() == "" then -- FPS cam
		local aimed = w:GetUserAim()
		local opos, ang = p:CamSpot( TPSOverride )

		local lx=input.GetAnalogValue(ANALOG_JOY_X) // Left X Axis: left -, right +
		local ly=input.GetAnalogValue(ANALOG_JOY_Y) // Left Y Axis: up -, bottom +
		local lr=input.GetAnalogValue(ANALOG_JOY_R) // Right X Axis: left -, right +
		local lu=input.GetAnalogValue(ANALOG_JOY_U) // Right Y Axis: up -, bottom +
		lx=lx/32768; ly=ly/32768; lr=lr/32768; lu=lu/32768; // Conversion to floats -1.0 - 1.0

		local moveintent
		if lx != 0 or ly != 0 then
			moveintent = Vector( ly * -320, lx * 320, 0 )
		else
			moveintent = Vector( cmd:GetForwardMove(), cmd:GetSideMove(), 0 )
		end

		local dir_p, dir_y = lr>0, lu>0
		dir_p = dir_p and 1 or -1
		dir_y = dir_y and -1 or 1
		local look_p, look_y = dir_p * math.ease.InCirc( math.abs(lr) ), dir_y * math.ease.InCirc( math.abs(lu) )

		-- ang:Add( Angle( cmd:GetMouseY()*0.022, -cmd:GetMouseX()*0.022, 0 ) )
		ang:Add( Angle( look_p * 180 * 0.5 * FrameTime(), look_y * 180 * FrameTime(), 0 ) )
		ang.p = math.Clamp( ang.p, -89.9, 89.9 )
		ang:Normalize()

		if aimed then
			local tr = util.TraceLine( {
				start = opos,
				endpos = opos+(ang:Forward()*(2^16)),
				filter = p,
				mask = MASK_SOLID,
			} )

			local planner = (tr.HitPos-p:EyePos()):Angle()
			planner:Normalize()
			cmd:SetViewAngles( planner )
			lastmoveangle = planner.y
		end

		if !aimed then
			if !moveintent:IsEqualTol( vector_origin, 1 ) then
				lastmoveangle = ang.y - moveintent:Angle().y
			end
			lastmoveangle_lerp = math.ApproachAngle( lastmoveangle_lerp or lastmoveangle, lastmoveangle, FrameTime() * 360 )
			cmd:SetViewAngles( Angle( ang.p, lastmoveangle_lerp, 0 ) )
		else
			lastmoveangle_lerp = lastmoveangle
		end

		local fixang = Angle()
		fixang.y = cmd:GetViewAngles().y - ang.y
		moveintent:Rotate( fixang )


		-- cmd:ClearMovement()
		cmd:SetForwardMove( moveintent.x )
		cmd:SetSideMove( moveintent.y )
	end
end)

function GM:PlayerNoClip()
	return true
end