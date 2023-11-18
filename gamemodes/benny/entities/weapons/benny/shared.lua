
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
AddCSLuaFile( "sh_holdtypes.lua" )
include		( "sh_holdtypes.lua" )

AddCSLuaFile( "cl_wm.lua" )
if CLIENT then
	include		( "cl_wm.lua" )
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Aim" )
	self:NetworkVar( "Float", 1, "Delay1" )
	self:NetworkVar( "Float", 2, "Delay2" )
	self:NetworkVar( "Float", 3, "GrenadeDownStart" )
	self:NetworkVar( "String", 0, "Wep1" )
	self:NetworkVar( "String", 1, "Wep2" )
	self:NetworkVar( "String", 2, "Wep1_Clip" )
	self:NetworkVar( "String", 3, "Wep2_Clip" )
	self:NetworkVar( "Int", 0, "Wep1_Burst" )
	self:NetworkVar( "Int", 1, "Wep2_Burst" )
	self:NetworkVar( "Int", 2, "Wep1_Firemode" )
	self:NetworkVar( "Int", 3, "Wep2_Firemode" )
	self:NetworkVar( "Bool", 0, "UserAim" )
	self:NetworkVar( "Bool", 1, "GrenadeDown" )
	self:NetworkVar( "Bool", 2, "TempHandedness" )

	self:SetWep1_Firemode( 1 )
	self:SetWep2_Firemode( 1 )
end

function SWEP:PrimaryAttack()
	self:BFire( self:GetTempHandedness() )
	return true
end

-- BENNY shit
function SWEP:BTable( alt )
	return self:GetOwner():INV_Get()[ alt and self:GetWep2() or self:GetWep1() ]
end

function SWEP:BClass( alt )
	local ta =  self:BTable( alt )
	if ta then
		return WEAPONS[ ta.Class ]
	else
		return false
	end
end

function SWEP:B_Ammo( hand, value )
	local p = self:GetOwner()
	local inv = p:INV_Get()
	self:D_SetClip( hand, value )
	assert( self:D_GetMagID( hand ) != "", "There is no magazine loaded!" )
	inv[ self:D_GetMagID( hand ) ].Ammo = value
end

function SWEP:B_Firemode( alt )
	return self:BClass( alt ).Firemodes[ self:D_GetFiremode( alt ) ]
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

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Reload()
	local p = self:GetOwner()
	local inv = p:INV_Get()
	if p:KeyPressed( IN_RELOAD ) then
		local hand = self:GetTempHandedness()
		local wep_table = self:BTable( hand )
		local wep_class = self:BClass( hand )
		if wep_table then
			if wep_class.Reload then
				if wep_class.Reload( self, wep_table ) then return end
			end
			if self:D_GetDelay( hand ) > CurTime() then
				return false
			end

			local mid = self:D_GetMagID( hand )
			if SERVER or (CLIENT and IsFirstTimePredicted()) then
				if mid != "" then
					if inv[mid].Ammo == 0 then
						if SERVER or (CLIENT and IsFirstTimePredicted()) then
							p:INV_Discard( mid )
						end
					end

					self:D_SetMagID( hand, "" )
					self:D_SetClip( hand, 0 )
					B_Sound( self, wep_class.Sound_MagOut )
					wep_table.Loaded = ""
				else
					local maglist = p:INV_FindMag( "mag_" .. wep_table.Class )
					local mag = maglist[1]
					if mag then
						self:D_SetMagID( hand, mag )
						self:D_SetClip( hand, inv[mag].Ammo )
						wep_table.Loaded = mag
						B_Sound( self, wep_class.Sound_MagIn )
					else
						B_Sound( self, "Common.NoAmmo" )
					end
				end
			end
			self:TPReload( self:GetTempHandedness() )
		end
	end
	return true
end

CreateClientConVar( "benny_toggleaim", 0, true, true )

function SWEP:Think()
	local p = self:GetOwner()

	if tobool(p:GetInfoNum("benny_toggleaim", 0)) then
		if p:KeyPressed( IN_ATTACK2 ) then
			self:SetUserAim( !self:GetUserAim() )
		end
	else
		self:SetUserAim( p:KeyDown( IN_ATTACK2 ) )
	end

	if p:KeyPressed( IN_ZOOM ) and (SERVER or (CLIENT and IsFirstTimePredicted())) then
		self:SetTempHandedness( !self:GetTempHandedness() )
	end

	self:SetAim( math.Approach( self:GetAim(), self:GetUserAim() and 1 or 0, FrameTime()/0.2 ) )

	if !p:KeyDown( IN_ATTACK ) then
		self:SetWep1_Burst( 0 )
		self:SetWep2_Burst( 0 )
	end

	local ht = "normal"
	if self:GetUserAim() then
		if self:BClass( false ) then
			if self:BClass( true ) then
				ht = "duel"
			else
				ht = self:BClass( false ).HoldType or "revolver"
			end
		end
	end

	if ht == "normal" and self:GetHoldType() != "normal" then
		self:TPHolster( self:GetTempHandedness() )
	elseif ht != "normal" and self:GetHoldType() == "normal" then
		self:TPDraw( self:GetTempHandedness() )
	end
	
	if self:BClass( false ) then
		if self:BClass( false ).Think then
			self:BClass( false ).Think( self, self:BTable( false ) )
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