
function SWEP:GetStat( hand, stat )
	local Hand = ((hand==true and "Left Hand") or (hand==false and "Right Hand"))
	assert( self:bWepClass( hand ), "No weapon in " .. Hand .. " (Trying to get stat " .. stat .. ")" )
	local thereturn = (self:bWepClass( hand ) and self:bWepClass( hand )[stat])
	assert( thereturn, "No stat for " .. stat .. " ( " .. Hand .. " )" )
	return thereturn
end

function BENNY_GetStat( class, stat )
	assert( class, "No class" )
	local thereturn = class[stat]
	assert( thereturn, "No stat for " .. stat )
	return thereturn
end

function SWEP:hFlipHand( hand )
	hand = hand or false
	local p = self:GetOwner()
	local lt = self:bWepClass( true )
	local flip = false
	if lt then
		if lt.Features == "firearm" then
			flip = p:GetInfoNum( "benny_wep_ao_firearms", 1 )==1
		elseif lt.Features == "grenade" then
			flip = p:GetInfoNum( "benny_wep_ao_grenades", 0 )==1
		else
			flip = p:GetInfoNum( "benny_wep_ao_junk", 0 )==1
		end
	else
		--return false
	end
	return ((flip and !hand) or (!flip and hand))
end

function SWEP:C_AttackDown( hand )
	if self:hFlipHand() then hand = !hand end
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
	local item = self:bWepTable( hand )
	if item then
		local class = WeaponGet(item.Class)
		if class.Custom_Holster then class.Custom_Holster( self, item, class, hand ) end
	end

	self:bSetInvID( hand, "" )
	self:bSetMagInvID( hand, "" )
	self:bSetIntClip( hand, 0 )
end

function SWEP:BSpread( hand )
	return self:bWepClass( hand ).Spread + self:bGetSpread( hand )
end

