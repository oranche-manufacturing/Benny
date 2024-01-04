
-- The benny weapon handles the weapon pickups you find throughout the game.

SWEP.Base								= "weapon_base"

SWEP.PrintName							= "Benny Weapon Handler"

SWEP.ViewModel							= "models/weapons/c_pistol.mdl"
SWEP.ViewModelFOV						= 10
SWEP.WorldModel							= "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize					= 0
SWEP.Primary.DefaultClip				= 0
SWEP.Primary.Automatic					= true
SWEP.Primary.Ammo						= "none"

SWEP.Secondary.ClipSize					= 0
SWEP.Secondary.DefaultClip				= 0
SWEP.Secondary.Automatic				= true
SWEP.Secondary.Ammo						= "none"

AddCSLuaFile( "sh_statregen.lua" )
include		( "sh_statregen.lua" )
AddCSLuaFile( "sh_firing.lua" )
include		( "sh_firing.lua" )
AddCSLuaFile( "sh_inv.lua" )
include		( "sh_inv.lua" )
AddCSLuaFile( "sh_stat2.lua" )
include		( "sh_stat2.lua" )
AddCSLuaFile( "sh_holdtypes.lua" )
include		( "sh_holdtypes.lua" )
AddCSLuaFile( "sh_reload.lua" )
include		( "sh_reload.lua" )

AddCSLuaFile( "cl_wm.lua" )
if CLIENT then
	include		( "cl_wm.lua" )
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Aim" )
	self:NetworkVar( "Float", 1, "Delay1" )
	self:NetworkVar( "Float", 2, "Delay2" )
	self:NetworkVar( "Float", 3, "GrenadeDownStart" )
	self:NetworkVar( "Float", 4, "Wep1_Spread" )
	self:NetworkVar( "Float", 5, "Wep2_Spread" )
	self:NetworkVar( "Float", 6, "Wep1_ShotTime" )
	self:NetworkVar( "Float", 7, "Wep2_ShotTime" )
	self:NetworkVar( "Float", 8, "Wep1_Holstering" )
	self:NetworkVar( "Float", 9, "Wep2_Holstering" )
	self:NetworkVar( "Float", 10, "Wep1_Reloading" )
	self:NetworkVar( "Float", 11, "Wep2_Reloading" )
	self:NetworkVar( "String", 0, "Wep1" )
	self:NetworkVar( "String", 1, "Wep2" )
	self:NetworkVar( "String", 2, "Wep1_Clip" )
	self:NetworkVar( "String", 3, "Wep2_Clip" )
	self:NetworkVar( "Int", 0, "Wep1_Burst" )
	self:NetworkVar( "Int", 1, "Wep2_Burst" )
	self:NetworkVar( "Int", 2, "Wep1_Firemode" )
	self:NetworkVar( "Int", 3, "Wep2_Firemode" )
	self:NetworkVar( "Int", 4, "Wep1_ReloadType" )
	self:NetworkVar( "Int", 5, "Wep2_ReloadType" )
	self:NetworkVar( "Bool", 0, "UserAim" )
	self:NetworkVar( "Bool", 1, "GrenadeDown" )

	self:SetWep1_Firemode( 1 )
	self:SetWep2_Firemode( 1 )

	self:SetWep1_Holstering( -1 )
	self:SetWep2_Holstering( -1 )

	self:SetWep1_Reloading( -1 )
	self:SetWep2_Reloading( -1 )
end

function SWEP:B_Ammo( hand, value )
	local p = self:GetOwner()
	local inv = p:INV_Get()
	self:bSetIntClip( hand, value )
	assert( self:bGetMagInvID( hand ) != "", "There is no magazine loaded!" )
	inv[ self:bGetMagInvID( hand ) ].Ammo = value
end

function SWEP:B_Firemode( alt )
	return self:bWepClass( alt ).Firemodes[ self:bGetFiremode( alt ) ]
end

function SWEP:B_FiremodeName( alt )
	local mode = self:B_Firemode( alt ).Mode
	if mode == 1 then
		return "SEMI"
	elseif mode == math.huge then
		return "AUTO"
	else
		return mode .. "RND"
	end
end

hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_TempForAim", function( ply, button )
	local wep = ply:BennyCheck()
	if wep then
		if button == KEY_F then
			if tobool(ply:GetInfoNum("benny_wep_toggleaim", 1)) then
				wep:SetUserAim( !wep:GetUserAim() )
			else
				wep:SetUserAim( true )
			end
		end

		if button == ply:GetInfoNum("benny_bind_reload", KEY_R) then
			wep:Reload( wep:hFlipHand( false ) )
		end

		if button == ply:GetInfoNum("benny_bind_reloada", KEY_T) then
			wep:Reload( wep:hFlipHand( true ) )
		end
	end
end)

hook.Add( "PlayerButtonUp", "Benny_PlayerButtonUp_TempForAim", function( ply, button )
	local wep = ply:BennyCheck()
	if wep then
		if button == KEY_F then
			if !tobool(ply:GetInfoNum("benny_wep_toggleaim", 0)) then
				wep:SetUserAim( false )
			end
		end
	end
end)

function SWEP:BStartHolster( hand )
	if self:bGetHolsterTime( hand ) == -1 then
		B_Sound( self, "Common.Holster" )
		-- print( "Holstering the " .. (hand and "LEFT" or "RIGHT") )
		self:bSetHolsterTime( hand, 0 )
		self:bSetReloadTime( hand, -1 )
		self:bSetReloadType( hand, 0 )
	end
end

function SWEP:BThinkHolster( hand )
	if self:bGetHolsterTime( hand ) >= 0 then
		self:bSetHolsterTime( hand, math.Approach( self:bGetHolsterTime( hand ), 1, FrameTime() / 0.35 ) )
	end
	if self:bGetHolsterTime( hand ) == 1 then
		self:bSetHolsterTime( hand, -1 )
		self:bSetReloadTime( hand, -1 )
		self:bSetReloadType( hand, 0 )
		self:BHolster( hand )
		local p = self:GetOwner()
		local req = self:bGetReqInvID( hand )
		local inv = p:INV_Get()
		if req != "" and inv[req] then
			self:BDeploy( hand, req )
		end
	end
end

function SWEP:Think()
	local p = self:GetOwner()
	local inv = p:INV_Get()

	local wep1 = self:bWepTable( false )
	local wep1c = self:bWepClass( false )
	local wep2 = self:bWepTable( true )
	local wep2c = self:bWepClass( true )

	if self:bGetReqInvID( false ) != "" and self:bGetReqInvID( true ) != "" and self:bGetReqInvID( false ) == self:bGetReqInvID( true ) then
		self:bSetReqInvID( false, "" )
		self:bSetReqInvID( true, "" )
		if CLIENT then chat.AddText( "Same weapons on ReqID, both holstered" ) end
	end
	for i=1, 2 do
		local hand = i==2
		if self:bGetReqInvID( hand ) != "" and !inv[self:bGetReqInvID( hand )] then
			self:bSetReqInvID( hand, "" )
		end
		local req = self:bGetReqInvID( hand )
		local req_o = self:bGetReqInvID( !hand )
		local curr = self:bGetInvID( hand )
		local curr_o = self:bGetInvID( !hand )
		if req != curr then
			-- Don't allow holstering from this weapon if...
			-- Just know, this feels bad.
			if self:bGetReloadTime( hand ) > 0 then
				-- hold
			elseif self:bWepClass( hand ) and self:bGetShotTime( hand ) + self:GetStat( hand, "ShootHolsterTime" ) > CurTime() then
				-- hold
			else
				if curr != "" then
					-- require holster first
					self:BStartHolster( hand )
				else
					local otherhasthis = curr_o == req
					if req != "" then
						if otherhasthis then
							self:BStartHolster( !hand )
						else
							self:BDeploy( hand, req )
						end
					else
						self:BStartHolster( hand )
					end
				end
			end
		end

		self:BThinkHolster( hand )

		do -- Reload logic
			if self:bGetReloadTime( hand ) != -1 then
				local rlt = self:bGetReloadType( hand )
				-- TODO: Unshitify this.
				if RealTime() >= self:bGetReloadTime( hand ) + (rlt == 1 and self:GetStat( hand, "Reload_MagIn" ) or rlt == 2 and self:GetStat( hand, "Reload_MagOut" )) then
					if rlt == 1 then
						if SERVER or (CLIENT and IsFirstTimePredicted() ) then
							self:Reload_MagIn( hand, self:bGetMagInvID( hand ), inv )
						end
					elseif rlt == 2 then
					end
					self:bSetReloadTime( hand, -1 )
					self:bSetReloadType( hand, 0 )
					-- Do reload stuff.
				end
			end
		end
	end

	self:SetAim( math.Approach( self:GetAim(), self:GetUserAim() and 1 or 0, FrameTime()/0.2 ) )

	for i=1, 2 do
		local hand = i==2
		if !self:C_AttackDown( hand ) then
			self:bSetBurst( hand, 0 )
		end
	end

	for i=1, 2 do
		local hand = i==2
		local wep, wepc = self:bWepTable( hand ), self:bWepClass( hand )
		if wepc and wepc.Features == "firearm" and self:bGetIntDelay( hand ) < CurTime()-0.01 then
			local mweh = math.Remap( CurTime(), self:bGetShotTime( hand ), self:bGetShotTime( hand ) + self:GetStat( hand, "SpreadDecay_RampTime" ), 0, 1 )
			mweh = math.Clamp( mweh, 0, 1 )
			local decayfinal = Lerp( math.ease.InExpo( mweh ), self:GetStat( hand, "SpreadDecay_Start" ), self:GetStat( hand, "SpreadDecay_End" ) )
			self:bSetSpread( hand, math.Approach( self:bGetSpread( hand ), 0, decayfinal * FrameTime() ) )
		end
	end

	local ht = "normal"
	if self:bWepClass( false ) and self:bGetHolsterTime( false ) < 0 then
		ht = "passive"
		if self:GetUserAim() then
			if self:bWepClass( true ) then
				ht = "duel"
			else
				ht = self:GetStat( false, "HoldType" )
			end
		end
	end

	if ht == "normal" and self:GetHoldType() != "normal" then
		self:TPHolster( false )
	elseif ht != "normal" and self:GetHoldType() == "normal" then
		self:TPDraw( false )
	end
	
	for i=1, 2 do
		local hand = i==2
		if self:bWepClass( hand ) then
			if self:bWepClass( hand ).Custom_Think then
				self:bWepClass( hand ).Custom_Think( self, self:bWepTable( hand ), self:bWepClass( hand ), hand )
			end
		end
	end

	self:SetWeaponHoldType(ht)
	self:SetHoldType(ht)

	return true
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end