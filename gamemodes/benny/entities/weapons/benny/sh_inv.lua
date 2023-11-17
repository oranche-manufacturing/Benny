
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
	local class = WEAPONS[item.Class]

	assert( item, "That item doesn't exist. " .. tostring(item) )

	self:D_SetID( hand, id )
	if item.Loaded then
		local mid = inv[ item.Loaded ]
		if mid then
			self:D_SetMagID( hand, item.Loaded )
			self:D_SetClip( hand, mid.Ammo )
		end
	end
	
	-- PROTO: Make grenade/melee/firearm logic way way better.
	if class.Features == "firearm" then
		-- if item.Loaded != "" then
		-- 	assert( inv[ item.Loaded ], "That magazine doesn't exist." )
		-- end
			
		-- self:D_SetClip( hand, item.Loaded == "" and 0 or inv[ "Ammo" .. item.Loaded ] )
	else
		self:D_SetClip( hand, 0 )
	end
end

function SWEP:BHolster( hand )
	if self:D_GetID( hand ) == "" then
		return -- What the hell are you holstering..?
	end
	local p = self:GetOwner()

	local item = p:INV_Get()[ self:D_GetID( hand ) ]
	if item then
		local class = WEAPONS[item.Class]
		if class.Holster then class.Holster( self, self:BTable( hand ) ) end
	end

	self:D_SetID( hand, "" )
	self:D_SetMagID( hand, "" )
	self:D_SetClip( hand, 0 )
end