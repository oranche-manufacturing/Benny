
-- Reload logic

SWEP.GEN_MagOut = 0
SWEP.GEN_MagIn = 0.8

SWEP.GEN_MagIn_BonusStart = 0.2
SWEP.GEN_MagIn_BonusEnd = 0.25

function SWEP:Reload( hand )
	if hand == nil then return end -- Needs to be called from the custom ones
	local p = self:GetOwner()
	local inv = p:INV_Get()
	local wep_table = self:BTable( hand )
	local wep_class = self:BClass( hand )
	if wep_table then
		if wep_class.Custom_Reload then
			if wep_class.Custom_Reload( self, wep_table ) then return end
		end
		if self:D_GetDelay( hand ) > CurTime() then
			return false
		end
		local rt = self:D_GetReloading( hand )
		if rt > 0 then
			if self.GEN_MagIn_BonusStart <= rt and rt < self.GEN_MagIn_BonusEnd then
				self:D_SetReloading( hand, 0 )
				return true
			else
				B_Sound( self, "Common.ReloadFail" )
				self:D_SetReloading( hand, 1 )
				return false
			end
		end

		local curmag = self:D_GetMagID( hand )
		if curmag != "" then
			-- self:D_SetReloading( hand, wep_class.Reload_MagOut or self.GEN_MagOut )
			-- self:D_SetReloadType( hand, 2 )
			self:Reload_MagOut( hand, self:D_GetMagID( hand ), inv )
		else
			self:D_SetReloading( hand, wep_class.Reload_MagIn or self.GEN_MagIn )
			self:D_SetReloadType( hand, 1 )
		end
		self:TPReload( hand )
	end
	return true
end

function SWEP:Reload_MagOut( hand, curmag, optinv, optwep_table, optwep_class )
	local p = self:GetOwner()
	local inv = optinv or p:INV_Get()
	local wep_table = optwep_table or self:BTable( hand )
	local wep_class = optwep_class or self:BClass( hand )

	if !inv[curmag] then
		ErrorNoHalt( "Mag isn't a valid item" )
		self:D_SetMagID( hand, "" )
		wep_table.Loaded = ""
	elseif inv[curmag].Ammo == 0 then
		if SERVER or (CLIENT and IsFirstTimePredicted()) then
			p:INV_Discard( curmag )
		end
	end

	self:D_SetMagID( hand, "" )
	self:D_SetClip( hand, 0 )
	B_Sound( self, wep_class.Sound_MagOut )
	wep_table.Loaded = ""
end

function SWEP:Reload_MagIn( hand, curmag, optinv, optwep_table, optwep_class )
	local p = self:GetOwner()
	local inv = optinv or p:INV_Get()
	local wep_table = optwep_table or self:BTable( hand )
	local wep_class = optwep_class or self:BClass( hand )
	local maglist = p:INV_FindMag( wep_table.Class )
	local mag
	
	local usedlist = {}
	for _id, mrow in pairs( inv ) do
		if mrow.Loaded and mrow.Loaded != "" then
			usedlist[mrow.Loaded] = true
			-- print( mrow.Loaded .. " Added to Mrowlist" )
		end
	end
	
	for num, mid in ipairs( maglist ) do
		if usedlist[mid] then
			-- print( "oh No we can't use " .. mid )
		else
			mag = mid
			break
		end
	end

	if mag then
		self:D_SetMagID( hand, mag )
		self:D_SetClip( hand, inv[mag].Ammo )
		wep_table.Loaded = mag
		B_Sound( self, wep_class.Sound_MagIn )
	else
		B_Sound( self, "Common.NoAmmo" )
	end
end