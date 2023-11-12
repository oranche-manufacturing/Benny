AddCSLuaFile()

ENT.Type = "anim"

ENT.Fuse = 0

local size = Vector( 4, 4, 4 )
local sizem = -size

function ENT:Initialize()
	self:SetModel( "models/weapons/w_eq_fraggrenade_thrown.mdl" )
	if SERVER then
		self:PhysicsInitBox( sizem, size, SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMaterial("Brick")
			phys:Wake()
		end
	else
		self:SetModelScale( 2 )
	end
	return
end

function ENT:Think()
	if SERVER and self.Fuse <= CurTime() then
		self:Explode()
		self:Remove()
	end
	return
end

local explosionflags = 0x2 + 0x4 + 0x80
function ENT:Explode()
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetFlags( explosionflags )
	util.Effect( "Explosion", effectdata )

	local dmg = DamageInfo()
	dmg:SetDamage( 125 )
	dmg:SetAttacker( self:GetOwner() )
	util.BlastDamageInfo( dmg, self:GetPos(), 140 )
	return
end

function ENT:PhysicsCollide( data, phys )
	if ( data.Speed > 100 ) then phys:SetVelocity( data.OurNewVelocity/2 ) end
end