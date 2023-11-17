
-- Weapon ID
function SWEP:D_GetID( hand )
	return hand and self:GetWep2() or self:GetWep1()
end

function SWEP:D_SetID( hand, value )
	return hand and self:SetWep2( value ) or self:SetWep1( value )
end

-- Wep. Clip ID
function SWEP:D_GetMagID( hand )
	return hand and self:GetWep2_Clip() or self:GetWep1_Clip()
end

function SWEP:D_SetMagID( hand, value )
	print( "SetMagID: " .. tostring(hand) .. " given " .. value )
	return hand and self:SetWep2_Clip( value ) or self:SetWep1_Clip( value )
end

-- Weapon Firemode
function SWEP:D_GetFiremode( hand )
	assert( hand != nil )
	return hand and self:GetWep2_Firemode() or self:GetWep1_Firemode()
end

function SWEP:D_SetFiremode( hand, value )
	assert( hand != nil )
	return hand and self:SetWep2_Firemode( value ) or self:SetWep1_Firemode( value )
end

-- Weapon Burst
function SWEP:D_GetBurst( hand )
	assert( hand != nil )
	return hand and self:GetWep2_Burst() or self:GetWep1_Burst()
end

function SWEP:D_SetBurst( hand, value )
	assert( hand != nil )
	return hand and self:SetWep2_Burst( value ) or self:SetWep1_Burst( value )
end

-- Internal SWEP Delay
function SWEP:D_GetDelay( hand )
	assert( hand != nil )
	return hand and self:GetDelay2() or self:GetDelay1()
end

function SWEP:D_SetDelay( hand, value )
	assert( hand != nil )
	return hand and self:SetDelay2( value ) or self:SetDelay1( value )
end

-- Internal SWEP Clip
function SWEP:D_GetClip( hand )
	assert( hand != nil )
	return hand and self:Clip2() or self:Clip1()
end

function SWEP:D_SetClip( hand, value )
	assert( hand != nil )
	return hand and self:SetClip2( value ) or self:SetClip1( value )
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