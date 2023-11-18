AddCSLuaFile()

local mat_flash, mat_arm, mat_beam, mat_spark = Material( "benny/effects/flash.png" ), Material( "benny/effects/flash_arm.png" ), Material( "benny/effects/flash_beam.png" ), Material( "benny/effects/flash_spark.png" )

local rba = Vector( 8, 8, 8 )
local rbb = -rba

function EFFECT:Init( data )
	-- Because CEffectData is a shared object, we can't just store it and use its' properties later
	-- Instead, we store the properties themselves
	self.offset = data:GetOrigin()
	self.angles = data:GetAngles()
	self.el = data:GetEntity()
	self.en = data:GetEntity()
	if IsValid(self.en.CWM) then self.en = self.en.CWM end
	self.ea = data:GetAttachment()
	self.particles = 1

	self.CreationTime = CurTime()
	self.DieTime = CurTime() + 0.05

	self:SetRenderBounds( rbb, rba )

	self.RandomRoll1 = math.Rand( 0, 1 )
	self.RandomRoll2 = math.Rand( 0, 1 )
	--self.RandomRoll3 = math.Rand( 0, 1 )

	local dlight = DynamicLight( self.el:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self.el:GetPos() + self.el:GetAngles():Forward()*24 + self.el:GetAngles():Up()*16
		dlight.r = 255
		dlight.g = 200
		dlight.b = 150
		dlight.Brightness = 4
		dlight.Size = 72*1.5
		dlight.DieTime = CurTime() + 0.07
		dlight.Decay = 72*20
	end
	
	-- Smoke!
	local atti = self.en:GetAttachment( self.ea )
	if true then
		local emitter = ParticleEmitter( atti.Pos, false )
		for i=1, 2 do
			local p = emitter:Add( "particles/smokey", atti.Pos )
			if p then
				p:SetAngles( atti.Ang )
				p:SetVelocity( atti.Ang:Forward()*64 + VectorRand( -32, 32 ) )
				p:SetGravity( Vector( 0, 0, 50 ))
				p:SetRoll( 0 )
				p:SetRollDelta( math.pi*.5 )
				p:SetColor( 255, 255, 255 )
				p:SetLifeTime( 0 )
				p:SetDieTime( 1 )
				p:SetLighting( true )
				p:SetStartAlpha( 14 )
				p:SetEndAlpha( 0 )
				p:SetStartSize( 8 )
				p:SetEndSize( 64 )
			end
		end
	end
	
	-- Spark!
	local atti = self.en:GetAttachment( self.ea )
	if true then
		local emitter = ParticleEmitter( atti.Pos, false )
		for i=1, 8 do
			local p = emitter:Add( mat_spark, atti.Pos )
			if p then
				p:SetAngles( atti.Ang )
				p:SetVelocity( atti.Ang:Forward()*64*i )
				p:SetRoll( math.Rand( 0, 1 )*math.pi*2*8 )
				p:SetRollDelta( 0 )
				p:SetColor( 255, 255, 255 )
				p:SetLifeTime( 0 )
				p:SetDieTime( .05 )
				p:SetLighting( false )
				p:SetStartAlpha( 63 )
				p:SetEndAlpha( 0 )
				p:SetStartSize( 4 )
				p:SetEndSize( 2 )
			end
		end
	end
end

function EFFECT:Think()
	return (self.DieTime >= CurTime()) -- Return false to kill
end

function EFFECT:Render()
	local atti = self.en:GetAttachment( self.ea )
	local tf = 1-math.TimeFraction( self.DieTime, self.CreationTime, CurTime() )

	-- Big flash!
	if true then
		local emitter = ParticleEmitter( atti.Pos + EyeAngles():Forward()*-16, false )
		for i=1, 1 do
			local p = emitter:Add( mat_flash, atti.Pos )
			if p then
				p:SetAngles( atti.Ang )
				p:SetVelocity( vector_origin )
				p:SetRoll( 0 )
				p:SetRollDelta( 0 )
				p:SetColor( 255, 255, 255 )
				p:SetLifeTime( 0 )
				p:SetDieTime( FrameTime()+0.001 )
				p:SetStartAlpha( 255 )
				p:SetEndAlpha( 255 )
				p:SetStartSize( Lerp( tf, 6, 0 ) )
				p:SetEndSize( Lerp( tf, 6, 0 ) )
				p:SetNextThink( CurTime() )
				p:SetThinkFunction( function( pa )
					timer.Simple( 0, function()
						pa:SetStartAlpha( 0 )
						pa:SetEndAlpha( 0 )
					end)
					pa:SetNextThink( CurTime() )
				end)
			end
		end
	end


	-- Long stick!
	if true then
		local emitter = ParticleEmitter( atti.Pos, false )
		for i=1, 1 do
			local p = emitter:Add( mat_beam, atti.Pos )
			if p then
				p:SetAngles( atti.Ang )
				p:SetVelocity( atti.Ang:Forward() / (2^16) )
				p:SetRoll( 0 )
				p:SetRollDelta( 0 )
				p:SetColor( 255, 250, 150 )
				p:SetLifeTime( 0 )
				p:SetDieTime( FrameTime()+0.001 )
				p:SetStartAlpha( math.Clamp( Lerp( tf, 127, -127 ), 0, 255 ) )
				p:SetEndAlpha( math.Clamp( Lerp( tf, 127, -127 ), 0, 255 ) )
				p:SetStartSize(		Lerp( tf, 16, 4 ) )
				p:SetStartLength(	Lerp( tf, 12, 16 ) )
				p:SetEndSize(		Lerp( tf, 16, 4 ) )
				p:SetEndLength(		Lerp( tf, 12, 16 ) )
				p:SetNextThink( CurTime() )
				p:SetThinkFunction( function( pa )
					timer.Simple( 0, function()
						pa:SetStartAlpha( 0 )
						pa:SetEndAlpha( 0 )
					end)
					pa:SetNextThink( CurTime() )
				end)
			end
		end
	end

	-- Big arms!
	if true then
		local emitter = ParticleEmitter( atti.Pos, false )
		for i=0, 3 do

			local meep = Angle( atti.Ang )
			meep:RotateAroundAxis( atti.Ang:Right(), (i/4)*360 + (self.RandomRoll1*360) )
			meep:RotateAroundAxis( atti.Ang:Up(), 90 )

			local pointy = atti.Ang:Forward()
			pointy:Mul( 0.25 )
			pointy:Add( meep:Forward() )

			local p = emitter:Add( mat_arm, atti.Pos )
			if p then
				p:SetAngles( atti.Ang )
				p:SetVelocity( pointy )
				p:SetRoll( 0 )
				p:SetRollDelta( 0 )
				p:SetColor( 255, 255, 230 )
				p:SetLifeTime( 0 )
				p:SetDieTime( FrameTime()+0.001 )
				p:SetStartAlpha( 	Lerp( tf, 64, 0 ) )
				p:SetEndAlpha( 		Lerp( tf, 64, 0 ) )
				p:SetStartSize(		Lerp( tf, 1, 12 ) )
				p:SetStartLength(	Lerp( tf, 10, 1 ) )
				p:SetEndSize(		Lerp( tf, 1, 12 ) )
				p:SetEndLength(		Lerp( tf, 10, 1 ) )
				p:SetNextThink( CurTime() )
				p:SetThinkFunction( function( pa )
					timer.Simple( 0, function()
						pa:SetStartAlpha( 0 )
						pa:SetEndAlpha( 0 )
					end)
					pa:SetNextThink( CurTime() )
				end)
			end
		end
	end
end