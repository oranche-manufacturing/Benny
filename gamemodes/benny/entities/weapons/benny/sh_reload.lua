
-- Reload logic

function SWEP:Reload( hand )
	if hand == nil then return end -- Needs to be called from the custom ones
	local p = self:GetOwner()
	local inv = p:INV_Get()
	local wep_table = self:bWepTable( hand )
	local wep_class = self:bWepClass( hand )
	if wep_table then
		if wep_class.Custom_Reload then
			if wep_class.Custom_Reload( self, wep_table ) then return end
		end
		if self:bGetIntDelay( hand ) > CurTime() then
			return false
		end
		local rt = self:bGetReloadTime( hand )
		if rt > 0 then
			local rtt = self:bGetReloadType( hand )
			-- TODO: Unshitify this.
			if rtt == 1 then
				if (rt+self:GetStat( hand, "Reload_MagIn_Bonus1" )) <= RealTime() and RealTime() <= (rt+self:GetStat( hand, "Reload_MagIn_Bonus2" )) then
					self:bSetReloadTime( hand, 0 )
					return true
				else
					B_Sound( self, "Common.ReloadFail" )
					self:bSetReloadTime( hand, RealTime() )
					return false
				end
			else
				return false
			end
		end

		local curmag = self:bGetMagInvID( hand )
		if curmag != "" then
			self:bSetReloadTime( hand, RealTime() )
			self:bSetReloadType( hand, 2 )
			B_Sound( self, wep_class.Sound_MagOut )
			self:Reload_MagOut( hand, self:bGetMagInvID( hand ), inv )
		elseif self:GetBestLoadableMagazine( hand, wep_table.Class, inv, wep_table ) then
			self:bSetReloadTime( hand, RealTime() )
			self:bSetReloadType( hand, 1 )
			B_Sound( self, wep_class.Sound_MagIn )
		else
			B_Sound( self, "Common.NoAmmo" )
		end
		self:TPReload( hand )
	end
	return true
end

function SWEP:Reload_MagOut( hand, curmag, optinv, optwep_table, optwep_class )
	local p = self:GetOwner()
	local inv = optinv or p:INV_Get()
	local wep_table = optwep_table or self:bWepTable( hand )
	local wep_class = optwep_class or self:bWepClass( hand )

	if !inv[curmag] then
		-- PROTO: This happens sometimes. I'm commenting it so it doesn't look like anything broke, because it didn't.
		-- ErrorNoHalt( "Mag isn't a valid item" )
		self:bSetMagInvID( hand, "" )
		wep_table.Loaded = ""
	elseif inv[curmag].Ammo == 0 then
		if SERVER or (CLIENT and IsFirstTimePredicted()) then
			p:INV_Discard( curmag )
		end
	end

	self:bSetMagInvID( hand, "" )
	self:bSetIntClip( hand, 0 )
	--B_Sound( self, wep_class.Sound_MagOut )
	wep_table.Loaded = ""
end

function SWEP:GetLoadableMagazines( hand, class, optinv, optwep_table )
	local p = self:GetOwner()
	local inv = optinv or p:INV_Get()
	local wep_table = optwep_table or self:bWepTable( hand )
	local maglist = p:INV_FindMag( wep_table.Class )
	
	local usedlist = {}
	for _id, mrow in pairs( inv ) do
		if mrow.Loaded and mrow.Loaded != "" then
			usedlist[mrow.Loaded] = true
		end
	end

	return maglist
end

function SWEP:GetBestLoadableMagazine( hand, class, optinv, optwep_table )
	local p = self:GetOwner()
	local inv = optinv or p:INV_Get()
	local wep_table = optwep_table or self:bWepTable( hand )
	local maglist = p:INV_FindMag( wep_table.Class )
	local mag = false
	
	local usedlist = {}
	for _id, mrow in pairs( inv ) do
		if mrow.Loaded and mrow.Loaded != "" then
			usedlist[mrow.Loaded] = true
		end
	end
	
	for num, mid in ipairs( maglist ) do
		if usedlist[mid] then
		else
			mag = mid
			break
		end
	end

	return mag
end

function SWEP:Reload_MagIn( hand, curmag, optinv, optwep_table, optwep_class )
	local p = self:GetOwner()
	local inv = optinv or p:INV_Get()
	local wep_table = optwep_table or self:bWepTable( hand )
	local wep_class = optwep_class or self:bWepClass( hand )
	local mag = self:GetBestLoadableMagazine( hand, wep_table.Class )

	if mag then
		self:bSetMagInvID( hand, mag )
		self:bSetIntClip( hand, inv[mag].Ammo )
		wep_table.Loaded = mag
		B_Sound( self, wep_class.Sound_Cock )
	else
		B_Sound( self, "Common.NoAmmo" )
	end
end