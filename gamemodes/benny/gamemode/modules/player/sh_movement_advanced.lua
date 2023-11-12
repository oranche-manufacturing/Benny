
local small = Vector( 1, 1, 1 )
local smale = -small

local moe = Vector( 0, 0, 8 )

local dmaxs = Vector( 16, 16, 48 )
local dmins = Vector( -16, -16, 0 )

local dW = Color( 255, 255, 255, 0 )
local dB = Color( 0, 0, 0, 0 )
local dS = Color( 255, 0, 0, 0 )
local dC = Color( 0, 0, 255, 0 )

hook.Add( "PlayerTick", "Benny_PlayerTick", function( ply, mv )
	ply:SetVaultDebuff( math.Clamp( ply:GetVaultDebuff() - FrameTime()/0.4	, 0, 1 ) )
end)

hook.Add( "Move", "Benny_Move", function( ply, mv )
	local ang = mv:GetMoveAngles()
	local pos = mv:GetOrigin()
	local vel = mv:GetVelocity()

	local wantdir = Vector( mv:GetForwardSpeed(), -mv:GetSideSpeed(), 0 ):GetNormalized()
	wantdir:Rotate( Angle( 0, ang.y, 0 ) )
	local cum = pos + wantdir*8

	debugoverlay.Box( cum + (SERVER and vector_up*0.1 or vector_origin), dmins, dmaxs, 0, SERVER and dS or dC )

	local ts, te = cum + Vector( 0, 0, 24 ), cum + Vector( 0, 0, 65 )
	local tr = util.TraceHull( {
		start = ts,
		endpos = te,
		mins = dmins,
		maxs = dmaxs,
		filter = ply
	} )

	for i=1, 2 do
		debugoverlay.Box( ts, smale, small, 0, tB )
		debugoverlay.Box( te, smale, small, 0, tB )
	end

	if mv:KeyPressed( IN_JUMP ) and ply:GetVaultDebuff() == 0 and tr.Hit and tr.StartSolid and !tr.AllSolid and tr.FractionLeftSolid>0 then
		print( CurTime(), "Moved!" )
		local epic = LerpVector( tr.FractionLeftSolid, ts, te )
		debugoverlay.Box( epic, smale, small, 0, SERVER and dS or dC )
		mv:SetOrigin( epic + Vector(0, 0, 1/16) )
		mv:SetVelocity( vector_origin )
		ply:SetVaultDebuff( 1 )
	end

	local speed = mv:GetMaxSpeed() * (1-ply:GetVaultDebuff())
	mv:SetMaxSpeed( speed )
	mv:SetMaxClientSpeed( speed )
end)