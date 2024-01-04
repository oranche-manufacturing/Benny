
local small = Vector( 1, 1, 1 )
local smale = -small

local moe = Vector( 0, 0, 1/16 )

local dmaxs = Vector( 1, 1, 1 )
local dmins = -dmaxs
local dcol = Color( 255, 0, 255, 0 )

local dW = Color( 255, 255, 255, 0 )
local dB = Color( 0, 0, 0, 0 )
local dS = Color( 255, 0, 0, 0 )
local dC = Color( 0, 0, 255, 0 )

hook.Add( "PlayerTick", "Benny_PlayerTick", function( ply, mv )
	if ply:GetVaultTransition() == 0 then
		ply:SetVaultDebuff( math.Approach( ply:GetVaultDebuff(), 0, FrameTime()/0.25 ) )
	end
end)

hook.Add( "SetupMove", "Benny_SetupMove", function( ply, mv, cmd )
	if !ply:OnGround() and mv:KeyDown( IN_DUCK ) then
		local newbuttons = bit.band(mv:GetButtons(), bit.bnot(IN_DUCK))
		mv:SetButtons(newbuttons)
	end
end)

local function Vault_GetAngle( ply, pos, ang, vel )
	return true
end

local VAULTCHECKDIST = 8
local VAULTMOVEDIST = 32

local MAXVAULTHEIGHT = 64

local MAXVAULTHEIGHT_FUCKERY = MAXVAULTHEIGHT+1
local MAXVAULTHEIGHT_V = Vector( 0, 0, MAXVAULTHEIGHT_FUCKERY )

hook.Add( "Move", "Benny_Move", function( ply, mv )
	local ang = mv:GetMoveAngles()
	local pos = mv:GetOrigin()
	local vel = mv:GetVelocity()

	local speed = mv:GetMaxSpeed() * (1-ply:GetVaultDebuff())
	mv:SetMaxSpeed( speed )
	mv:SetMaxClientSpeed( speed )

	local forw, side = mv:GetForwardSpeed(), mv:GetSideSpeed()
	local ba, bb = ply:GetHull()
	if ply:Crouching() then ba, bb = ply:GetHullDuck() end
	
	
	local WishDir = Vector( forw, -side, 0 ):GetNormalized()
	WishDir:Rotate( Angle( 0, ang.y, 0 ) )

	local Target = Vector( pos )
	local TargetNor = Vector()

	if !WishDir:IsZero() then
		TargetNor:Set( WishDir )
	elseif vel:Length2D() > 100 then
		local NoZ = Vector( vel )
		NoZ.z = 0
		NoZ:Normalize()
		TargetNor:Set( NoZ )
	else
		local NoUp = Angle( ang )
		NoUp.p = 0
		TargetNor = NoUp:Forward()
	end

	local CR = HSVToColor( math.Rand( 0, 360 ), 1, 1 )
	CR.a = 8
	--debugoverlay.Box( Target, ba, bb, 0, CR )

	local Checker = Target + TargetNor*VAULTCHECKDIST
	local Desire = Target + TargetNor*VAULTMOVEDIST
	local T1 = util.TraceHull( {
		start = Target,
		endpos = Checker,
		mins = ba,
		maxs = bb,
		filter = ply,
	} )
	if CLIENT then vaultsave = false end
	if ply:GetVaultDebuff() == 0 and !ply:NoclippingAndNotVaulting() and T1.Hit then -- A challenger approaches

		-- How tall is it, basically? We still need to do a ledge check
		local T2 = util.TraceHull( {
			start = Desire + MAXVAULTHEIGHT_V,
			endpos = Desire,
			mins = ba,
			maxs = bb,
			filter = ply,
		} )
		-- debugoverlay.Box( T2.HitPos, ba, bb, 0, CR )

		-- Let's check our vertical clearance
		local Clearance = Vector( Target.x, Target.y, T2.HitPos.z )
		local T3 = util.TraceHull( {
			start = Target,
			endpos = Clearance,
			mins = ba,
			maxs = bb,
			filter = ply,
		} )
		-- debugoverlay.SweptBox( T3.StartPos, T3.HitPos, ba, bb, angle_zero, 0, CR )
		local VertClearance = T3.HitPos.z - T3.StartPos.z

		-- If we try to go so high and it's TOO high then give up
		if VertClearance > ply:GetStepSize() and VertClearance <= MAXVAULTHEIGHT then
			-- Trace from clearance to final
			local T4 = util.TraceHull( {
				start = T3.HitPos,
				endpos = T2.HitPos,
				mins = ba,
				maxs = bb,
				filter = ply,
			} )
			-- debugoverlay.SweptBox( T4.StartPos, T4.HitPos, ba, bb, angle_zero, 0, CR )

			local Compare1, Compare2 = Vector( Target.x, Target.y, 0 ), Vector( T4.HitPos.x, T4.HitPos.y, 0 )
			if !Compare1:IsEqualTol( Compare2, 1/16 ) then
				if CLIENT then vaultsave = true end

				if mv:KeyDown( IN_JUMP ) then
					ply:SetVaultPos1( ply:GetPos() )
					ply:SetVaultPos2( T4.HitPos )
					ply:SetVaultTransition( 1 )
					ply:SetVaultDebuff( 1 )
					ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_JUMP, ply:SelectWeightedSequence( ACT_GMOD_GESTURE_BOW ), 0.75, true )
					--mv:SetOrigin( T4.HitPos )
					return true
				end
			end
		end
	end

	if ply:GetVaultTransition() != 0 then
		ply:SetVaultTransition( math.Approach( ply:GetVaultTransition(), 0, FrameTime()/0.25 ) )
		local t, vp1, vp2 = ply:GetVaultTransition(), ply:GetVaultPos1(), ply:GetVaultPos2()
		local Meow = Vector( Lerp( (1-t), vp1.x, vp2.x ), Lerp( (1-t), vp1.y, vp2.y ), Lerp( math.ease.OutQuint(1-t), vp1.z, vp2.z ) )
		mv:SetOrigin( Meow )
		mv:SetVelocity( Vector( 0, 0, 0 ) )
		ply:SetVaultDebuff( 1 )
		ply:SetMoveType( (ply:GetVaultTransition() == 0) and MOVETYPE_WALK or MOVETYPE_NOCLIP )
		return true
	end

	local w = ply:BennyCheck()
	local hand = false
	if w and w:bWepClass( hand ) then
		local targetspeed = mv:GetMaxSpeed()

		targetspeed = targetspeed * w:GetStat( hand, "Speed_Move" )

		targetspeed = targetspeed * Lerp( w:GetAim(), 1, w:GetStat( hand, "Speed_Aiming" ) )

		local st = w:bGetShotTime( hand )
		targetspeed = targetspeed * (st+w:GetStat( hand, "Speed_FiringTime" ) > CurTime() and w:GetStat( hand, "Speed_Firing" ) or 1)

		targetspeed = targetspeed * (w:bGetReloadTime( hand ) > 0 and w:GetStat( hand, "Speed_Reloading" ) or 1)

		mv:SetMaxSpeed( targetspeed )
		mv:SetMaxClientSpeed( targetspeed )
	end
	--debugoverlay.Box( Target+(TargetNor*16), ba, bb, 0, CR )
end)