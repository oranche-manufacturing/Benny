
-- HUD

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudPoisonDamageIndicator"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )

function ss( scale )
	return scale * ( ScrH() / 480 )
end

hook.Add( "HUDPaint", "Benny_HUDPaint", function()
	surface.SetDrawColor( 0, 0, 0, 0 )
	surface.DrawRect( 0, 0, 256, 256 )
end )