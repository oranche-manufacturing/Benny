AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = "models/weapons/w_eq_fraggrenade_thrown.mdl"
ENT.Fuse = 0

local size = Vector( 4, 4, 4 )
local sizem = -size

function ENT:Initialize()
	self:SetModel( self.Model )
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
	end
	return
end

local explosionflags = 0x2 + 0x4 + 0x80
function ENT:Explode()
end

function ENT:PhysicsCollide( data, phys )
	if ( data.Speed > 100 ) then phys:SetVelocity( (-data.HitNormal * data.OurNewVelocity:Length()) * 0.25 + (data.OurNewVelocity*0.5) ) phys:SetAngleVelocity( phys:GetAngleVelocity()*0.5 ) end
end