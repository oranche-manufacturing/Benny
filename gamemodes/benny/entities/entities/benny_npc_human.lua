AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

if CLIENT then
	return
end

function ENT:Initialize()
	self:SetModel( "models/barney.mdl" )
	self.loco:SetDesiredSpeed( 100 )		-- Walk speed
	self.loco:SetStepHeight( 22 )
end

function ENT:RunBehaviour()
	while ( true ) do
		-- find the furthest away hiding spot
		local pos = self:FindSpot( "random", { type = 'hiding', radius = 1000 } )

		if pos then
			self:StartActivity( ACT_WALK )
			self:MoveToPos( pos )
		end
		self:StartActivity( ACT_IDLE )

		coroutine.wait(1)

		coroutine.yield()
	end
end

function ENT:OnContact( ent )
	if ent != game.GetWorld() then
		print( ent )
	end
end


function ENT:Think()
end