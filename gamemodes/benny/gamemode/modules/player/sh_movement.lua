
-- Movement

local wa, wb = 0, 0

local blop = Angle()

hook.Add( "CreateMove", "CamFuck", function( cmd )
	if BENNY_ACTIVECAMERA and LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP then
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

		cmd:ClearMovement()
		cmd:SetForwardMove( ad.x )
		cmd:SetSideMove( ad.y )

		if x != 0 or y != 0 then
			local thing = Vector( x, -y, 0 ):Angle()
			thing.y = thing.y + an.y
			blop.y = math.ApproachAngle( blop.y, thing.y, FrameTime() * 360 )
		end
		cmd:SetViewAngles( blop )

	end
end)

function GM:PlayerNoClip()
	return true
end