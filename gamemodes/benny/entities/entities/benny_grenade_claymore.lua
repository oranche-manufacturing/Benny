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

	local dmg = DamageInfo()
	dmg:SetDamage( 125 )
	dmg:SetAttacker( self:GetOwner() )
	util.BlastDamageInfo( dmg, self:GetPos(), 140 )

	self:Remove()
	return
end