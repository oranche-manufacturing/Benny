

function SWEP:PrimaryAttack()
	local dual = self:C_DualCheck()
	if dual then
		self:BFire( true )
	else
		self:BFire( false )
	end
	return true
end

function SWEP:SecondaryAttack()
	local dual = self:C_DualCheck()
	if dual then
		self:BFire( false )
	else
		self:BFire( true )
	end
	return true
end

function SWEP:BFire( hand )
	if self:bWepTable( hand ) and self:GetAim() == 1 then
		local p = self:GetOwner()
		local wep_table = self:bWepTable( hand )
		local wep_class = self:bWepClass( hand )

		if wep_class.Custom_Fire then
			if wep_class.Custom_Fire( self, wep_table, wep_class, hand ) then return end
		end
		if self:bGetIntDelay( hand ) > CurTime() then
			return
		end
		if self:bGetHolsterTime( hand ) > 0 then
			return
		end
		if self:bGetIntClip( hand ) == 0 then
			if self:bGetBurst( hand ) >= 1 then
				return
			end
			B_Sound( self, wep_class.Sound_DryFire )
			self:bSetBurst( hand, self:bGetBurst( hand ) + 1 )
			return
		end
		if self:bGetBurst( hand ) >= self:B_Firemode( hand ).Mode then
			return
		end
		
		if !ConVarSV_Bool("cheat_infiniteammo") then
			self:B_Ammo( hand, self:bGetIntClip( hand ) - 1 )
		end

		B_Sound( self, wep_class.Sound_Fire )
		self:TPFire( hand )
		self:CallFire( hand )

		self:bSetIntDelay( hand, CurTime() + wep_class.Delay )
		self:bSetBurst( hand, self:bGetBurst( hand ) + 1 )
		self:bSetSpread( hand, math.Clamp( self:bGetSpread( hand ) + wep_class.SpreadAdd, 0, wep_class.SpreadAddMax ) )
		self:bSetShotTime( hand, CurTime() )

		
		if CLIENT and IsFirstTimePredicted() then
			-- PROTO: This is shit! Replace it with a function that gets the right model.
			if IsValid(hand and self.CWM_Left or self.CWM) and (hand and self.CWM_Left or self.CWM):GetAttachment( 1 ) then
				local vStart = (hand and self.CWM_Left or self.CWM):GetAttachment( 1 ).Pos
				local ed = EffectData()
				ed:SetOrigin( vStart )
				ed:SetEntity( self )
				ed:SetAttachment( (hand and 16 or 0) + 1 )
				util.Effect( "benny_muzzleflash", ed )
			end
		end
	end
end

local bc = { effects = true, damage = true }
function SWEP:CallFire( hand )
	local p = self:GetOwner()
	local class = self:bWepClass( hand )
	local spread = self:BSpread( hand )
	for i=1, self:GetStat( hand, "Pellets" ) do
		local dir = self:GetOwner():EyeAngles()

		local radius = util.SharedRandom("benny_distance_"..tostring(hand), 0, 1, i )
		local circ = util.SharedRandom("benny_radius_"..tostring(hand), 0, math.rad(360), i )

		dir:RotateAroundAxis( dir:Right(), spread * radius * math.sin( circ ) )
		dir:RotateAroundAxis( dir:Up(), spread * radius * math.cos( circ ) )
		dir:RotateAroundAxis( dir:Forward(), 0 )
		local tr = util.TraceLine( {
			start = p:EyePos(),
			endpos = p:EyePos() + dir:Forward() * 8192,
			filter = p
		} )

		self:FireBullets( {
			Attacker = p,
			Damage = class.Damage,
			Force = ( class.Damage / 10 ) * self:GetStat( hand, "Pellets" ),
			Src = p:EyePos(),
			Dir = dir:Forward(),
			Tracer = 0,
			IgnoreEntity = p,
			Callback = function( atk, tr, dmginfo )
				if CLIENT and IsFirstTimePredicted() then
					self:FireCL( hand, tr )
				end
				return bc
			end,
		} )
	end
end

function SWEP:FireCL( hand, tr )
	-- PROTO: This is shit! Replace it with a function that gets the right model.
	local vStart = (hand and self.CWM_Left or self.CWM):GetAttachment( 1 ).Pos
	local vPoint = tr.HitPos
	local effectdata = EffectData()
	effectdata:SetStart( vStart )
	effectdata:SetOrigin( vPoint )
	effectdata:SetEntity( self )
	effectdata:SetScale( 1025*12 )
	effectdata:SetFlags( 1 )
	util.Effect( "Tracer", effectdata )
end