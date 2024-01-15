AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.DieTime = CurTime() + 3
end

function ENT:InitSpecial( model )
	self:SetModel( model )

	-- Physics stuff
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Init physics only on server, so it doesn't mess up physgun beam
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	
	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	-- Make prop to fall on spawn
	self:PhysWake()

	if SERVER then
		local p = self:GetPhysicsObject()
		p:SetMass( 0 )
	end
end

function ENT:Think()
	if SERVER and self.DieTime <= CurTime() then
		self:Remove()
	end
end

function ENT:PhysicsCollide( data, phys )
	if ( data.Speed > 200 ) and data.DeltaTime > 0.2 then
		local ent = data.HitEntity
		print(ent:Health())
		if ent:IsValid() and ent:Health() > 0 then
			ent:EmitSound( ")benny/violence/bodysplat_mix2.ogg", 70, 100, 1 )

			local dmg = DamageInfo()
			dmg:SetDamageType( DMG_CLUB )
			dmg:SetDamage( 25 )
			dmg:SetAttacker( self:GetOwner() )
			dmg:SetInflictor( self )
			print( data.HitSpeed, data.HitSpeed:Length() )
			dmg:SetDamageForce( data.HitSpeed*-10 )
			dmg:SetDamagePosition( data.HitPos )
			
			ent:TakeDamageInfo( dmg )
		else
			self:EmitSound( "physics/metal/weapon_impact_hard1.wav" )
		end
	end
end