AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "benny_grenade"

ENT.Model = "models/weapons/w_eq_fraggrenade_thrown.mdl"

local explosionflags = 0x2 + 0x4 + 0x80
function ENT:Explode()
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetFlags( explosionflags )
	util.Effect( "Explosion", effectdata )

	self:Remove()
	return
end