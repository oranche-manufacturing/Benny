

function SWEP:PrimaryAttack()
	local dual = self:BTable( false ) and self:BTable( true )
	if dual then
		self:BFire( true )
	else
		self:BFire( false )
	end
	return true
end

function SWEP:SecondaryAttack()
	local dual = self:BTable( false ) and self:BTable( true )
	if dual then
		self:BFire( false )
	else
		self:BFire( true )
	end
	return true
end

function SWEP:BFire( hand )
	if self:BTable( hand ) then
		local p = self:GetOwner()
		local wep_table = self:BTable( hand )
		local wep_class = self:BClass( hand )

		if wep_class.Custom_Fire then
			if wep_class.Custom_Fire( self, wep_table, wep_class, hand ) then return end
		end
		if self:D_GetDelay( hand ) > CurTime() then
			return
		end
		if self:D_GetBurst( hand ) >= self:B_Firemode( hand ).Mode then
			return
		end
		if self:D_GetClip( hand ) == 0 then
			B_Sound( self, wep_class.Sound_DryFire )
			self:D_SetDelay( hand, CurTime() + 0.2 )
			return
		end
		
		self:B_Ammo( hand, self:D_GetClip( hand ) - 1 )

		B_Sound( self, wep_class.Sound_Fire )
		self:TPFire( hand )
		self:CallFire( hand )

		self:D_SetDelay( hand, CurTime() + wep_class.Delay )
		self:D_SetBurst( hand, self:D_GetBurst( hand ) + 1 )

		
		if CLIENT and IsFirstTimePredicted() then
			if IsValid(self.CWM) then
				local vStart = self.CWM:GetAttachment( 1 ).Pos
				--local vPoint = p:GetEyeTrace().HitPos
				--local effectdata = EffectData()
				--effectdata:SetStart( vStart )
				--effectdata:SetOrigin( vPoint )
				--util.Effect( "ToolTracer", effectdata )
				local ed = EffectData()
				ed:SetOrigin( vStart )
				--ed:SetAngles( Angle() )
				ed:SetEntity( self )
				ed:SetAttachment( 1 )
				util.Effect( "benny_muzzleflash", ed )
			end
		end
	end
end

function SWEP:CallFire( hand )
	local p = self:GetOwner()
	local class = self:BClass( hand )
	local spread = class.Spread or 0
	for i=1, class.Pellets or 1 do
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
			Force = class.Damage/10,
			Src = p:EyePos(),
			Dir = dir:Forward(),
			IgnoreEntity = p,
			Callback = self.BulletCallback,
		} )

		-- self:FireCL( tr )
		-- self:FireSV( tr )
	end
end

function SWEP:BulletCallback()
	return true
end



function SWEP:FireCL( tr )
	if CLIENT and IsFirstTimePredicted() then
		do
			local vStart = self.CWM:GetAttachment( 1 ).Pos
			local vPoint = tr.HitPos
			local effectdata = EffectData()
			effectdata:SetStart( vStart )
			effectdata:SetOrigin( vPoint )
			effectdata:SetEntity( self )
			effectdata:SetScale( 1025*12 )
			effectdata:SetFlags( 1 )
			util.Effect( "Tracer", effectdata )
		end
		-- util.DecalEx( Material( util.DecalMaterial( "Impact.Concrete" ) ), tr.Entity, tr.HitPos, tr.HitNormal, color_white, 1, 1 )
		do
			local effectdata = EffectData()
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetStart( tr.StartPos )
			effectdata:SetSurfaceProp( tr.SurfaceProps )
			effectdata:SetEntity( tr.Entity )
			effectdata:SetDamageType( DMG_BULLET )
			util.Effect( "Impact", effectdata )
		end
	end
end

function SWEP:FireSV( tr )
	local class = self:BClass( false )
	if SERVER and IsValid( tr.Entity ) then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage( class.Damage )
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamageType( DMG_BULLET )
		dmginfo:SetDamagePosition( tr.HitPos )
		tr.Entity:TakeDamageInfo( dmginfo )
	end
end