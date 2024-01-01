
-- Stat2

function SWEP:bWepTable( alt )
	return self:GetOwner():INV_Get()[ ((alt==true) and self:GetWep2()) or ((alt==false) and self:GetWep1()) ]
end

function SWEP:bWepClass( alt )
	local ta = self:bWepTable( alt )
	if ta then
		return WeaponGet( ta.Class )
	else
		return false
	end
end

function SWEP:bMagTable( alt )
	return self:GetOwner():INV_Get()[ ((alt==true) and self:GetWep2_Clip()) or ((alt==false) and self:GetWep1_Clip()) ]
end

function SWEP:bMagClass( alt )
	local ta = self:bMagTable( alt )
	if ta then
		return WeaponGet( ta.Class )
	else
		return false
	end
end

-- Weapon ID
function SWEP:bGetInvID( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2() or (hand == false) and self:GetWep1()
end

function SWEP:bSetInvID( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2( value ) or (hand == false) and self:SetWep1( value )
end

-- Wep. Clip ID
function SWEP:bGetMagInvID( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_Clip() or (hand == false) and self:GetWep1_Clip()
end

function SWEP:bSetMagInvID( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_Clip( value ) or (hand == false) and self:SetWep1_Clip( value )
end

-- Weapon Firemode
function SWEP:bGetFiremode( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_Firemode() or (hand == false) and self:GetWep1_Firemode()
end

function SWEP:bSetFiremode( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_Firemode( value ) or (hand == false) and self:SetWep1_Firemode( value )
end

-- Weapon Burst
function SWEP:bGetBurst( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_Burst() or (hand == false) and self:GetWep1_Burst()
end

function SWEP:bSetBurst( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_Burst( value ) or (hand == false) and self:SetWep1_Burst( value )
end

-- Weapon Spread
function SWEP:bGetSpread( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_Spread() or (hand == false) and self:GetWep1_Spread()
end

function SWEP:bSetSpread( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_Spread( value ) or (hand == false) and self:SetWep1_Spread( value )
end

-- Weapon Spread
function SWEP:bGetShotTime( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_ShotTime() or (hand == false) and self:GetWep1_ShotTime()
end

function SWEP:bSetShotTime( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_ShotTime( value ) or (hand == false) and self:SetWep1_ShotTime( value )
end

-- Weapon Holstering Time
function SWEP:bGetHolsterTime( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_Holstering() or (hand == false) and self:GetWep1_Holstering()
end

function SWEP:bSetHolsterTime( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_Holstering( value ) or (hand == false) and self:SetWep1_Holstering( value )
end

-- Weapon Reloading Time
function SWEP:bGetReloadTime( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_Reloading() or (hand == false) and self:GetWep1_Reloading()
end

function SWEP:bSetReloadTime( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_Reloading( value ) or (hand == false) and self:SetWep1_Reloading( value )
end

-- Weapon Reload Type
function SWEP:bGetReloadType( hand )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:GetWep2_ReloadType() or (hand == false) and self:GetWep1_ReloadType()
end

function SWEP:bSetReloadType( hand, value )
	assert( hand!=nil, "Missing hand argument" )
	return (hand == true) and self:SetWep2_ReloadType( value ) or (hand == false) and self:SetWep1_ReloadType( value )
end

-- Weapon Player Requesting ID
function SWEP:bGetReqInvID( hand )
	local p = self:GetOwner()
	return (hand == true) and p:GetReqID2() or (hand == false) and p:GetReqID1()
end

function SWEP:bSetReqInvID( hand, value )
	local p = self:GetOwner()
	return (hand == true) and p:SetReqID2( value ) or (hand == false) and p:SetReqID1( value )
end

-- Internal SWEP Delay
function SWEP:bGetIntDelay( hand )
	return (hand == true) and self:GetDelay2() or (hand == false) and self:GetDelay1()
end

function SWEP:bSetIntDelay( hand, value )
	return (hand == true) and self:SetDelay2( value ) or (hand == false) and self:SetDelay1( value )
end

-- Internal SWEP Clip
function SWEP:bGetIntClip( hand )
	return (hand == true) and self:Clip2() or (hand == false) and self:Clip1()
end

function SWEP:bSetIntClip( hand, value )
	return (hand == true) and self:SetClip2( value ) or (hand == false) and self:SetClip1( value )
end