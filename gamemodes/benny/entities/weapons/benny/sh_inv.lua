

local fallbackstat = {
	["Reload_MagOut"] = 0.2,
	["Reload_MagIn"] = 0.8,
	["Reload_MagIn_Bonus1"] = 0.56,
	["Reload_MagIn_Bonus2"] = 0.56+0.1,
	["Sound_Cock"] = "Glock.Cock",
	["Damage"] = 0,
	["Pellets"] = 1,
	["Firemodes"] = { { Mode = 1 } },
	["Delay"] = 0,
	["Ammo"] = 0,
	["Spread"] = 0,
	["SpreadAdd"] = 0,
	["SpreadDecay_Start"] = 0,
	["SpreadDecay_End"] = 0,
	["SpreadDecay_RampTime"] = 0,
	["Speed_Move"] = 1,
	["Speed_Aiming"] = 1,
	["Speed_Reloading"] = 1,
	["Speed_Firing"] = 1,
	["Speed_FiringTime"] = 0.2,
	["ShootHolsterTime"] = 0,
}

function SWEP:GetStat( hand, stat )
	local thereturn = (self:BClass( hand ) and self:BClass( hand )[stat] or fallbackstat[stat])
	assert( thereturn, "No stat for " .. stat )
	return thereturn
end

function BENNY_GetStat( class, stat )
	assert( class, "No class" )
	local thereturn = (class[stat] or fallbackstat[stat])
	assert( thereturn, "No stat for " .. stat )
	return thereturn
end

function SWEP:C_DualCheck()
	local p = self:GetOwner()
	local lt = self:BClass( true )
	if lt then
		if lt.Features == "firearm" then
			return p:GetInfoNum( "benny_wep_ao_firearms", 1 )==1
		elseif lt.Features == "grenade" then
			return p:GetInfoNum( "benny_wep_ao_grenades", 0 )==1
		else
			return p:GetInfoNum( "benny_wep_ao_junk", 0 )==1
		end
	else
		return false
	end
end

function SWEP:C_AttackDown( hand )
	if self:C_DualCheck() then hand = !hand end
	return (hand == true) and self:GetOwner():KeyDown( IN_ATTACK2 ) or (hand == false) and self:GetOwner():KeyDown( IN_ATTACK )
end

function SWEP:BDeploy( hand, id )
	assert( isbool(hand), "You forgot the hand." )
	assert( isstring(id), "You forgot the ID." )
	if self:bGetInvID( hand ) == id then
		-- This breaks prediction somewhat!!
		-- return -- PROTO: If you're in the middle of holstering, cancel it
	elseif self:bGetInvID( hand ) != "" then
		return--self:BHolster( hand )
	end
	local p = self:GetOwner()
	local inv = p:INV_Get()

	local item = inv[id]
	local class = WeaponGet(item.Class)

	assert( item, "That item doesn't exist. " .. tostring(item) )

	self:bSetInvID( hand, id )
	self:bSetMagInvID( hand, "" )
	self:bSetIntClip( hand, 0 )
	self:bSetSpread( hand, 0 )
	self:bSetIntDelay( hand, CurTime() + 0.35 )
	B_Sound( self, "Common.Deploy" )
	if item.Loaded and item.Loaded != "" then
		local mid = item.Loaded
		local midi = inv[ mid ]
		if !midi then
			item.Loaded = ""
			error( "Deploy: Magazine doesn't exist in the inventory!! " .. tostring(mid) .. " item.Loaded removed." )
		end
		self:bSetMagInvID( hand, mid )
		self:bSetIntClip( hand, midi.Ammo )
	end
end

function SWEP:BHolster( hand )
	if self:bGetInvID( hand ) == "" then
		return -- What the hell are you holstering..?
	end

	local p = self:GetOwner()
	--B_Sound( self, "Common.Holster" )
	local item = self:BTable( hand )
	if item then
		local class = WeaponGet(item.Class)
		if class.Custom_Holster then class.Custom_Holster( self, item, class, hand ) end
	end

	self:bSetInvID( hand, "" )
	self:bSetMagInvID( hand, "" )
	self:bSetIntClip( hand, 0 )
end

function SWEP:BSpread( hand )
	return self:BClass( hand ).Spread + self:bGetSpread( hand )
end

