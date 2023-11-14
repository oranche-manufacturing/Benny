
-- Weapon ID
function SWEP:D_GetID( hand )
	return hand and self:GetWep2() or self:GetWep1()
end

function SWEP:D_SetID( hand, value )
	return hand and self:SetWep2( value ) or self:SetWep1( value )
end

-- Wep. Clip ID
function SWEP:D_GetMagID( hand )
	return hand and self:GetWep1Clip() or self:GetWep1Clip()
end

function SWEP:D_SetMagID( hand, value )
	return hand and self:SetWep1Clip( value ) or self:SetWep1Clip( value )
end

-- Weapon Firemode
function SWEP:D_GetFiremode( hand )
	return hand and self:GetWep2_Firemode() or self:GetWep1_Firemode()
end

function SWEP:D_SetFiremode( hand, value )
	return hand and self:SetWep2_Firemode( value ) or self:SetWep1_Firemode( value )
end

-- Internal SWEP Delay
function SWEP:D_GetDelay( hand )
	return hand and self:Clip2() or self:Clip1()
end

function SWEP:D_SetDelay( hand, value )
	return hand and self:SetDelay2( value ) or self:SetDelay1( value )
end

-- Internal SWEP Clip
function SWEP:D_GetClip( hand )
	return hand and self:Clip2() or self:Clip1()
end

function SWEP:D_SetClip( hand, value )
	return hand and self:SetClip2( value ) or self:SetClip1( value )
end

function SWEP:BDeploy( hand, id )
	assert( isbool(hand), "You forgot the hand." )
	assert( isstring(id), "You forgot the ID." )
	if self:D_GetID( hand ) == id then
		return -- PROTO: If you're in the middle of holstering, cancel it
	elseif self:D_GetID( hand ) != "" then
		self:BHolster( hand )
	end
	local p = self:GetOwner()
	local inv = p:INV_Get()

	local item = inv[id]
	local class = WEAPONS[item.Class]

	assert( item, "That item doesn't exist. " .. tostring(item) )

	self:D_SetID( hand, id )
	self:D_SetMagID( hand, item.Loaded )
	
	-- PROTO: Make grenade/melee/firearm logic way way better.
	if class.Features == "firearm" then
		if item.Loaded != 0 then
			assert( item[ "Ammo" .. item.Loaded ], "That magazine doesn't exist." )
		end
			
		self:D_SetClip( hand, item.Loaded == 0 and 0 or item[ "Ammo" .. item.Loaded ] )
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
	self:D_SetClip( hand, 0 )
end