
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

	local invid = 0
	for _, item in pairs( weighted ) do
		local class = WeaponGet(item.Class)
		local id = iflip[item]
		if class.Features == "firearm" or class.Features == "grenade" then
			invid = invid + 1
			if num == 0 then num = 10 end
			if num == invid then
				if ply:KeyDown(IN_ZOOM) then
					if id == wep:D_GetID( true ) then
						return ply:SetReqID2("")
					else
						return ply:SetReqID2(id)
					end
				else
					if id == wep:D_GetID( false ) then
						return ply:SetReqID1("")
					else
						return ply:SetReqID1(id)
					end
				end
			end
		end
	end
	if ply:KeyDown(IN_ZOOM) then
		return ply:SetReqID2( "" ) 
	else
		return ply:SetReqID1( "" )
	end
end

hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_Inv", function( ply, button )
	local wep = ply:BennyCheck()

	if dads[button] then
		beatup( ply, dads[button] )
	end
end)