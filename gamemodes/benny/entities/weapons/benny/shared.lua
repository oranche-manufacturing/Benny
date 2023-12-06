
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

	self:SetWep1_Firemode( 1 )
	self:SetWep2_Firemode( 1 )
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

function SWEP:Reload( hand )
	if hand == nil then return end -- Needs to be called from the custom ones
	local p = self:GetOwner()
	local inv = p:INV_Get()
	local wep_table = self:BTable( hand )
	local wep_class = self:BClass( hand )
	if wep_table then
		if wep_class.Custom_Reload then
			if wep_class.Custom_Reload( self, wep_table ) then return end
		end
		if self:D_GetDelay( hand ) > CurTime() then
			return false
		end

		local mid = self:D_GetMagID( hand )
		if SERVER or (CLIENT and IsFirstTimePredicted()) then
			if mid != "" then
				if !inv[mid] then
					ErrorNoHalt( "Mag isn't a valid item" )
					self:D_SetMagID( hand, "" )
					wep_table.Loaded = ""
				elseif inv[mid].Ammo == 0 then
					if SERVER or (CLIENT and IsFirstTimePredicted()) then
						p:INV_Discard( mid )
					end
				end

				self:D_SetMagID( hand, "" )
				self:D_SetClip( hand, 0 )
				B_Sound( self, wep_class.Sound_MagOut )
				wep_table.Loaded = ""
			else
				local maglist = p:INV_FindMag( wep_table.Class )
				local mag
				
				local usedlist = {}
				for _id, mrow in pairs( inv ) do
					if mrow.Loaded and mrow.Loaded != "" then
						usedlist[mrow.Loaded] = true
						-- print( mrow.Loaded .. " Added to Mrowlist" )
					end
				end
				
				for num, mid in ipairs( maglist ) do
					if usedlist[mid] then
						-- print( "oh No we can't use " .. mid )
					else
						mag = mid
						break
					end
				end

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
		self:TPReload( hand )
	end
	return true
end

hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_TempForAim", function( ply, button )
	local wep = ply:BennyCheck()

	if button == KEY_F then
		if tobool(ply:GetInfoNum("benny_wep_toggleaim", 1)) then
			wep:SetUserAim( !wep:GetUserAim() )
		else
			wep:SetUserAim( true )
		end
	end

	local dual = wep:C_DualCheck()
	if button == KEY_R then
		if dual then wep:Reload( true ) else wep:Reload( false ) end
	end

	if button == KEY_T then
		if dual then wep:Reload( false ) else wep:Reload( true ) end
	end
end)

hook.Add( "PlayerButtonUp", "Benny_PlayerButtonUp_TempForAim", function( ply, button )
	local wep = ply:BennyCheck()

	if button == KEY_F then
		if !tobool(ply:GetInfoNum("benny_wep_toggleaim", 0)) then
			wep:SetUserAim( false )
		end
	end
end)

function SWEP:Think()
	local p = self:GetOwner()

	self:SetAim( math.Approach( self:GetAim(), self:GetUserAim() and 1 or 0, FrameTime()/0.2 ) )

	if !self:C_AttackDown( false ) then
		self:SetWep1_Burst( 0 )
	end
	if !self:C_AttackDown( true ) then
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
		self:TPHolster( false )
	elseif ht != "normal" and self:GetHoldType() == "normal" then
		self:TPDraw( false )
	end
	
	for i=1, 2 do
		local hand = i==2
		if self:BClass( hand ) then
			if self:BClass( hand ).Custom_Think then
				self:BClass( hand ).Custom_Think( self, self:BTable( hand ) )
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