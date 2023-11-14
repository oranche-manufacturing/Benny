
local small = Vector( 1, 1, 1 )
local smale = -small

local moe = Vector( 0, 0, 1/16 )

local dmaxs = Vector( 16, 16, 48 )
local dmins = Vector( -16, -16, 0 )

local dW = Color( 255, 255, 255, 0 )
local dB = Color( 0, 0, 0, 0 )
local dS = Color( 255, 0, 0, 0 )
local dC = Color( 0, 0, 255, 0 )

hook.Add( "PlayerTick", "Benny_PlayerTick", function( ply, mv )
	if ply:GetVaultTransition() == 0 then
		ply:SetVaultDebuff( math.Approach( ply:GetVaultDebuff(), 0, FrameTime()/0.4 ) )
	end
end)

function VaultReady( ply, pos, ang, forw, side )
	if ply:NoclippingAndNotVaulting() then return false end
	local wantdir = Vector( forw, -side, 0 ):GetNormalized()
	wantdir:Rotate( Angle( 0, ang.y, 0 ) )
	local cum = pos + wantdir*16

	local ts, te = cum + Vector( 0, 0, 22 ), cum + Vector( 0, 0, 65 )
	local bottom, top = ply:GetHull()
	if ply:Crouching() then bottom, top = ply:GetHullDuck() end
	local tr = util.TraceHull( {
		start = ts,
		endpos = te,
		mins = bottom,
		maxs = top,
		filter = ply,
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
	if CLIENT then vaultsave = false end
	if vault then
		local epic = LerpVector( vault.FractionLeftSolid, v2, v3 )
		epic:Add( moe )
		
		local bottom, top = ply:GetHull()
		if ply:Crouching() then bottom, top = ply:GetHullDuck() end
		local tr = util.TraceHull( {
			start = epic,
			endpos = epic,
			mins = bottom,
			maxs = top,
			filter = ply,
		} )
		if !tr.AllSolid then
			if CLIENT then vaultsave = true end
			if mv:KeyDown( IN_JUMP ) then
				ply:SetVaultPos1( pos )
				ply:SetVaultPos2( epic )
				ply:SetVaultTransition( 1 )
				-- mv:SetOrigin( epic )
				-- mv:SetVelocity( Vector( 0, 0, 0 ) )
				ply:SetVaultDebuff( 1 )
			end
		end
	end
	if ply:GetVaultTransition() != 0 then
		ply:SetVaultTransition( math.Approach( ply:GetVaultTransition(), 0, FrameTime()/0.3 ) )
		mv:SetOrigin( LerpVector( math.ease.OutCirc( 1-ply:GetVaultTransition() ), ply:GetVaultPos1(), ply:GetVaultPos2() ) )
		mv:SetVelocity( Vector( 0, 0, 0 ) )
		ply:SetVaultDebuff( 1 )
		ply:SetMoveType( (ply:GetVaultTransition() == 0) and MOVETYPE_WALK or MOVETYPE_NOCLIP )
		return true
	end
end)