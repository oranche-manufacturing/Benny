
-- Weapon ID
function SWEP:D_GetID( hand )
	return (hand == true) and self:GetWep2() or (hand == false) and self:GetWep1()
end

function SWEP:D_SetID( hand, value )
	return (hand == true) and self:SetWep2( value ) or (hand == false) and self:SetWep1( value )
end

-- Wep. Clip ID
function SWEP:D_GetMagID( hand )
	return (hand == true) and self:GetWep2_Clip() or (hand == false) and self:GetWep1_Clip()
end

function SWEP:D_SetMagID( hand, value )
	return (hand == true) and self:SetWep2_Clip( value ) or (hand == false) and self:SetWep1_Clip( value )
end

-- Weapon Firemode
function SWEP:D_GetFiremode( hand )
	return (hand == true) and self:GetWep2_Firemode() or (hand == false) and self:GetWep1_Firemode()
end

function SWEP:D_SetFiremode( hand, value )
	return (hand == true) and self:SetWep2_Firemode( value ) or (hand == false) and self:SetWep1_Firemode( value )
end

-- Weapon Burst
function SWEP:D_GetBurst( hand )
	return (hand == true) and self:GetWep2_Burst() or (hand == false) and self:GetWep1_Burst()
end

function SWEP:D_SetBurst( hand, value )
	return (hand == true) and self:SetWep2_Burst( value ) or (hand == false) and self:SetWep1_Burst( value )
end

-- Internal SWEP Delay
function SWEP:D_GetDelay( hand )
	return (hand == true) and self:GetDelay2() or (hand == false) and self:GetDelay1()
end

function SWEP:D_SetDelay( hand, value )
	return (hand == true) and self:SetDelay2( value ) or (hand == false) and self:SetDelay1( value )
end

-- Internal SWEP Clip
function SWEP:D_GetClip( hand )
	return (hand == true) and self:Clip2() or (hand == false) and self:Clip1()
end

function SWEP:D_SetClip( hand, value )
	return (hand == true) and self:SetClip2( value ) or (hand == false) and self:SetClip1( value )
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
	if self:D_GetID( hand ) == id then
		-- This breaks prediction somewhat!!
		-- return -- PROTO: If you're in the middle of holstering, cancel it
	elseif self:D_GetID( hand ) != "" then
		self:BHolster( hand )
	end
	local p = self:GetOwner()
	local inv = p:INV_Get()

	local item = inv[id]
	local class = WeaponGet(item.Class)

	assert( item, "That item doesn't exist. " .. tostring(item) )

	self:D_SetID( hand, id )
	self:D_SetMagID( hand, "" )
	self:D_SetClip( hand, 0 )
	if item.Loaded and item.Loaded != "" then
		local mid = item.Loaded
		local midi = inv[ mid ]
		if !midi then
			item.Loaded = ""
			error( "Deploy: Magazine doesn't exist in the inventory!! " .. tostring(mid) .. " item.Loaded removed." )
		end
		self:D_SetMagID( hand, mid )
		self:D_SetClip( hand, midi.Ammo )
	end
end

function SWEP:BHolster( hand )
	if self:D_GetID( hand ) == "" then
		return -- What the hell are you holstering..?
	end

	local p = self:GetOwner()
	local item = self:BTable( hand )
	if item then
		local class = WeaponGet(item.Class)
		if class.Custom_Holster then class.Custom_Holster( self, item, class, hand ) end
	end

	self:D_SetID( hand, "" )
	self:D_SetMagID( hand, "" )
	self:D_SetClip( hand, 0 )
end