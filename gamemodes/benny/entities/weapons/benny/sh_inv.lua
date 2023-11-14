
-- Weapon ID
function SWEP:DGetWep( hand )
	return hand and self:GetWep2() or self:GetWep1()
end

function SWEP:DSetWep( hand, value )
	return hand and self:SetWep2( value ) or self:SetWep1( value )
end

-- Internal SWEP Clip
function SWEP:DGetClip( hand )
	return hand and self:Clip2() or self:Clip1()
end

function SWEP:DSetClip( hand, value )
	return hand and self:SetClip2( value ) or self:SetClip1( value )
end

-- Wep. Clip ID
function SWEP:DGetWepClip( hand )
	return hand and self:GetWep1Clip() or self:GetWep1Clip()
end

function SWEP:DSetWepClip( hand, value )
	return hand and self:SetWep1Clip( value ) or self:SetWep1Clip( value )
end

function SWEP:BDeploy( hand, id )
	if self:DGetWep( hand ) == id then
		return -- PROTO: If you're in the middle of holstering, cancel it
	elseif self:DGetWep( hand ) != "" then
		self:BHolster( hand )
	end
	local p = self:GetOwner()
	local inv = p:INV_Get()

	local item = inv[id]
	local class = WEAPONS[item.Class]

	assert( item, "That item doesn't exist. " .. tostring(item) )

	self:DSetWep( hand, id )
	self:DSetWepClip( hand, item.Loaded )
	
	-- PROTO: Make grenade/melee/firearm logic way way better.
	if class.Features == "firearm" then
		if item.Loaded != 0 then
			assert( item[ "Ammo" .. item.Loaded ], "That magazine doesn't exist." )
		end
			
		self:DSetClip( hand, item.Loaded == 0 and 0 or item[ "Ammo" .. item.Loaded ] )
	else
		self:DSetClip( hand, 0 )
	end
end

function SWEP:BHolster( hand )
	if self:DGetWep( hand ) == "" then
		return -- What the hell are you holstering..?
	end
	local p = self:GetOwner()
	local inv = p:INV_Get()

	local item = inv[hand and self:GetWep2() or self:GetWep1()]
	local class = WEAPONS[item.Class]

	if class.Holster then class.Holster( self ) end

	self:DSetWep( hand, "" )

	-- PROTO: Make grenade/melee/firearm logic way way better.
	if class.Features == "firearm" then
		self:DSetClip( hand, 0 )
	end
end