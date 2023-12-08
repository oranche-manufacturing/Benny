
-- Predicted weapon switching

local dads = {
	[KEY_1] = 1,
	[KEY_2] = 2,
	[KEY_3] = 3,
	[KEY_4] = 4,
	[KEY_5] = 5,
	[KEY_6] = 6,
	[KEY_7] = 7,
	[KEY_8] = 8,
	[KEY_9] = 9,
	[KEY_0] = 0,
}

local function beatup( ply, num )
	local weighted = ply:INV_Weight()
	local inv = ply:INV_Get()
	local iflip = table.Flip( inv )

	local invid = 0
	for _, item in pairs( weighted ) do
		local class = WeaponGet(item.Class)
		if class.Features == "firearm" or class.Features == "grenade" then
			invid = invid + 1
			if num == invid then
				--RunConsoleCommand( "benny_inv_equip", iflip[item], "false", "false" )
				if ply:KeyDown(IN_ZOOM) then
					return ply:SetReqID2(iflip[item])
				else
					return ply:SetReqID1(iflip[item])
				end
			end
		end
	end
	return ply:SetReqID1( "" )
end

hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_Inv", function( ply, button )
	local wep = ply:BennyCheck()

	if dads[button] then
		beatup( ply, dads[button] )
	end
end)