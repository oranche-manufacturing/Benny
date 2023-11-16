
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
		ply:SetVaultDebuff( math.Approach( ply:GetVaultDebuff(), 0, FrameTime()/0.4 ) )
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

local VAULTCHECKDIST = 16
local VAULTMOVEDIST = 16
local MAXVAULTHEIGHT = 66
local MAXVAULTHEIGHT_V = Vector( 0, 0, MAXVAULTHEIGHT )

hook.Add( "Move", "Benny_Move", function( ply, mv )
	local ang = mv:GetMoveAngles()
	local pos = mv:GetOrigin()
	local vel = mv:GetVelocity()

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
	debugoverlay.Line( T1.StartPos, T1.HitPos, 0, T1.Hit and CR or color_white )

	if CLIENT then vaultsave = false end
	if T1.Hit then -- A challenger approaches

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
		if VertClearance != MAXVAULTHEIGHT then
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
					mv:SetOrigin( T4.HitPos )
					return true
				end
			end
		end
	end
	--debugoverlay.Box( Target+(TargetNor*16), ba, bb, 0, CR )
end)