

function SWEP:PrimaryAttack()
	local hand = self:hFlipHand( false )
	self:DevFire( hand )
	return true
end

function SWEP:SecondaryAttack()
	local hand = self:hFlipHand( true )
	self:DevFire( hand )
	return true
end

function SWEP:DevFire( hand )
	if self:bWepClass( hand ) then
		self:BFire( hand )
	elseif self:bWepClass( !hand ) then
		self:BFireAlt( !hand )
	end
end

function SWEP:BFire( hand )
	if self:bWepClass( hand ) and self:bWepClass( hand ).Func_Attack then
		if self:bWepClass( hand ).Func_Attack( self, hand ) then return end
	end
end

function SWEP:BFireAlt( hand )
	if self:bWepClass( hand ) and self:bWepClass( hand ).Func_AttackAlt then
		if self:bWepClass( hand ).Func_AttackAlt( self, hand ) then return end
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