
-- Movement

local wa, wb = 0, 0

local blop = Angle()

hook.Add( "CreateMove", "CamFuck", function( cmd )
	if LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP then
		local x, y = cmd:GetForwardMove(), cmd:GetSideMove()
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

		ad:Normalize()
		ad:Mul(320)

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