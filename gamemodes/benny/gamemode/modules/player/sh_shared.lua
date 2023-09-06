
local wa, wb = 0, 0

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

		--print(ad.x, ad.y)

		cmd:SetForwardMove( ad.x )
		cmd:SetSideMove( ad.y )
	end
end)

function GM:PlayerNoClip()
	return true
end

if CLIENT then
	local function ss( scale )
		return scale * ( ScrH() / 480 )
	end

	local w25, w50, w75, w100 = Color( 255, 255, 255, 0.25*255 ), Color( 255, 255, 255, 0.50*255 ), Color( 255, 255, 255, 0.75*255 ), Color( 255, 255, 255, 1.00*255 )
	local g25, g50, g75, g100 = Color( 0, 0, 0, 0.25*255 ), Color( 0, 0, 0, 0.50*255 ), Color( 0, 0, 0, 0.75*255 ), Color( 0, 0, 0, 1.00*255 )

	hook.Add( "HUDPaint", "HUDFuck", function()
		local bo = ss( 20 )
		local cr, cd = ss( 50 ), ss( 100 )

		surface.SetDrawColor( g100 )
		surface.DrawRect( bo, ScrH() - bo + cr, cd, cd )
		
		surface.SetDrawColor( w25 )
		surface.DrawLine( bo + cr, ScrH() - bo - cd, bo + cr, ScrH() - bo )
		surface.DrawLine( bo, ScrH() - bo - cr, bo + cd, ScrH() - bo - cr )

		surface.SetDrawColor( w100 )
		surface.DrawCircle( bo + cr, ScrH() - bo - cr, cr )

		local ox, oy = 0, 0
		local msp = 300

		ox = wb/msp
		oy = -wa/msp

		ox = math.Clamp( ox, -1, 1 ) * cr
		oy = math.Clamp( oy, -1, 1 ) * cr

		surface.DrawCircle( bo + cr + ox, ScrH() - bo - cr + oy, ss( 2 ) )

		-- local x, y, w, h = 0, 0, 360, 240
		-- local ow, oh = 512, 512

		-- local camera = BENNY.Cameras[BENNY_ACTIVECAMERA]
		-- local view = {
		-- 	origin = camera.Pos,
		-- 	angles = camera.Ang,
		-- 	fov = camera.FOV or 60,
		-- 	drawviewer = true
		-- }
		-- if camera.Special then
		-- 	view.origin, view.angles, view.fov = camera.Special( camera, LocalPlayer() )
		-- end
		-- view.angles.p = 0
		-- view.angles.r = 0

		-- local aratio = w/h

		-- render.RenderView( {
		-- 	origin = view.origin + Vector( 0, 0, 64 ),
		-- 	angles = Angle( 90, view.angles.y, 0 ),
		-- 	aspect = 1,
		-- 	fov = 90,
		-- 	x = x, y = y,
		-- 	w = w, h = h,
		-- 	ortho = {
		-- 		left = -ow, right = ow,
		-- 		top = -oh / aratio, bottom = oh / aratio,
		-- 	},
		-- } )
	end)
end