
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

function VaultReady( ply, pos, ang, forw, side )
	local wantdir = Vector( forw, -side, 0 ):GetNormalized()
	wantdir:Rotate( Angle( 0, ang.y, 0 ) )
	local cum = pos + wantdir*8

	local ts, te = cum + Vector( 0, 0, 24 ), cum + Vector( 0, 0, 65 )
	local tr = util.TraceHull( {
		start = ts,
		endpos = te,
		mins = dmins,
		maxs = dmaxs,
		filter = ply
	} )

	return (ply:GetVaultDebuff() == 0 and tr.Hit and tr.StartSolid and !tr.AllSolid and tr.FractionLeftSolid>0) and tr, ts, te or false
end

hook.Add( "SetupMove", "Benny_SetupMove", function( ply, mv, cmd )
	if !ply:OnGround() and mv:KeyDown( IN_DUCK ) then
		local newbuttons = bit.band(mv:GetButtons(), bit.bnot(IN_DUCK))
		mv:SetButtons(newbuttons)
	end
end)

hook.Add( "Move", "Benny_Move", function( ply, mv )
	local ang = mv:GetMoveAngles()
	local pos = mv:GetOrigin()
	local vel = mv:GetVelocity()

	local speed = mv:GetMaxSpeed() * (1-ply:GetVaultDebuff())
	mv:SetMaxSpeed( speed )
	mv:SetMaxClientSpeed( speed )

	local vault, v2, v3 = VaultReady( ply, pos, ang, mv:GetForwardSpeed(), mv:GetSideSpeed() )
	if mv:KeyDown( IN_JUMP ) and vault then
		local epic = LerpVector( vault.FractionLeftSolid, v2, v3 )
		mv:SetOrigin( epic + Vector(0, 0, 1/16) )
		mv:SetVelocity( Vector( 0, 0, -100 ) )
		ply:SetVaultDebuff( 1 )
	end
end)