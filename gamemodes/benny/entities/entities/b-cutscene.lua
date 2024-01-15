
AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/benny/test.mdl" )
	self:ResetSequence( "test" )
end

function ENT:Think()
	self:NextThink( CurTime() )
	return true
end