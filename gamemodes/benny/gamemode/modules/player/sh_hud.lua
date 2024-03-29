
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
	if CLIENT and !IsFirstTimePredicted() then return end
	for _, item in pairs( weighted ) do
		local class = WeaponGet(item.Class)
		local id = iflip[item]
		if class.Equipable or class.Features == "firearm" or class.Features == "grenade" or class.Features == "melee" then
			invid = invid + 1
			if num == 0 then num = 10 end
			if num == invid then
				if id == wep:bGetReqInvID( hand ) then
					-- If we are selected our currently equipped weapon, holster it.
					return wep:bSetReqInvID( hand, "" )
				else
					if wep:bGetReqInvID( hand ) != "" then
						-- Something is in this hand

						if wep:bGetReqInvID( !hand ) != "" then
							-- Something in the other hand
							wep:bSetReqInvID( !hand, wep:bGetReqInvID( hand ) )
							wep:bSetReqInvID( hand, id )
							return
						else
							-- Nothing in the other hand
							wep:bSetReqInvID( !hand, "" )
							wep:bSetReqInvID( hand, id )
							return
						end
					else
						-- Nothing in this hand.
						if wep:bGetReqInvID( !hand ) == id then
							-- Weapon we want is in the other hand.
							wep:bSetReqInvID( !hand, "" )
							wep:bSetReqInvID( hand, id )
							return
						end
					end
					return wep:bSetReqInvID( hand, id )
				end
			end
		end
	end
	return wep:bSetReqInvID( hand, "" )
end

hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_Inv", function( ply, button )
	local wep = ply:BennyCheck()

	if dads[button] then
		beatup( ply, dads[button] )
	end
end)