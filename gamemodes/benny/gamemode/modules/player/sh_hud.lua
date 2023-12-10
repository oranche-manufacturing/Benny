
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
	local wep = ply:BennyCheck()
	local iflip = table.Flip( inv )
	local hand = ply:KeyDown(IN_ZOOM)

	local invid = 0
	for _, item in pairs( weighted ) do
		local class = WeaponGet(item.Class)
		local id = iflip[item]
		if class.Features == "firearm" or class.Features == "grenade" then
			invid = invid + 1
			if num == 0 then num = 10 end
			if num == invid then
				if id == wep:D_GetReqID( hand ) then
					-- If we are selected our currently equipped weapon, holster it.
					return wep:D_SetReqID( hand, "" )
				else
					if id == wep:D_GetID( !hand ) then
						-- If the wanted weapon is in the other hand, request to holster it.
						wep:D_SetReqID( !hand, "" )
					end
					if wep:D_GetID( !hand ) != "" and wep:D_GetID( hand ) != "" then -- If we have something in this hand, swap it with the other
						wep:D_SetReqID( !hand, wep:D_GetID( hand ) )
					end
					return wep:D_SetReqID( hand, id )
				end
			end
		end
	end
	return wep:D_SetReqID( hand, "" )
end

hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_Inv", function( ply, button )
	local wep = ply:BennyCheck()

	if dads[button] then
		beatup( ply, dads[button] )
	end
end)