
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
AddCSLuaFile( "sh_firing.lua" )
include		( "sh_inv.lua" )
include		( "sh_inv.lua" )

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Aim" )
	self:NetworkVar( "Float", 1, "Delay1" )
	self:NetworkVar( "Float", 2, "Delay2" )
	self:NetworkVar( "String", 0, "Wep1" )
	self:NetworkVar( "String", 1, "Wep2" )
	self:NetworkVar( "Int", 0, "Wep1Clip" )
	self:NetworkVar( "Int", 1, "Wep2Clip" )
	self:NetworkVar( "Int", 2, "Wep1Burst" )
	self:NetworkVar( "Int", 3, "Wep2Burst" )
	self:NetworkVar( "Bool", 0, "UserAim" )
end

function SWEP:PrimaryAttack()
	if !self:BTable() then
		return
	end
	if self:BClass().Fire then
		if self:BClass( false ).Fire( self, self:BClass( false ), self:BTable( false ) ) then return end
	end
	if self:GetDelay1() > CurTime() then
		return
	end
	if self:GetWep1Burst() >= self:B_Firemode( false ).Mode then
		return
	end
	if self:Clip1() == 0 then
		B_Sound( self, self:BClass( false ).Sound_DryFire )
		self:SetDelay1( CurTime() + 0.2 )
		return
	end
	
	self:B_Ammo( false, self:Clip1() - 1 )

	B_Sound( self, self:BClass( false ).Sound_Fire )
	self:TPFire()
	self:CallFire()

	self:SetDelay1( CurTime() + self:BClass( false ).Delay )
	self:SetWep1Burst( self:GetWep1Burst() + 1 )
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

function SWEP:B_Ammo( alt, value )
	local clip = (alt and self:GetWep2Clip() or self:GetWep1Clip())
	assert( clip > 0, "You cannot mess with an EMPTY magazine!")
	if alt then
		self:SetClip2( value )
	else
		self:SetClip1( value )
	end
	self:BTable( alt )["Ammo" .. clip] = value
end

function SWEP:B_Firemode( alt )
	return self:BClass( alt ).Firemodes[1]
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
	if self:BTable( false ) and self:GetOwner():KeyPressed( IN_RELOAD ) then
		if self:BClass().Reload then
			if self:BClass( false ).Reload( self, self:BClass( false ), self:BTable( false ) ) then return end
		end
		if self:GetDelay1() > CurTime() then
			return false
		end

		if self:GetWep1Clip() != 0 then
			B_Sound( self, self:BClass().Sound_MagOut )
			self:SetClip1( 0 )
			self:SetWep1Clip( 0 )
			self:BTable().Loaded = 0
		else
			local maglist = { self:BTable( false ).Ammo1, self:BTable( false ).Ammo2, self:BTable( false ).Ammo3 }
			for i, v in SortedPairsByValue( maglist, true ) do
				if v == 0 then B_Sound( self, "Common.NoAmmo" ) return end
				self:BTable().Loaded = i
				self:SetWep1Clip( i )
				self:SetClip1( v )
				break
			end
			B_Sound( self, self:BClass().Sound_MagIn )
		end
		self:TPReload()
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
	self:SetAim( math.Approach( self:GetAim(), self:GetUserAim() and 1 or 0, FrameTime()/0.2 ) )

	if !p:KeyDown( IN_ATTACK ) then
		self:SetWep1Burst( 0 )
	end

	local ht = "normal"
	if self:GetUserAim() then
		if self:BClass( false ) then
			ht = self:BClass( false ).HoldType or "revolver"
		end
	end

	if ht == "normal" and self:GetHoldType() != "normal" then
		self:TPHolster()
	elseif ht != "normal" and self:GetHoldType() == "normal" then
		self:TPDraw()
	end
	
	if self:BClass( false ) then
		if self:BClass( false ).Think then
			self:BClass( false ).Think( self, self:BClass( false ), self:BTable( false ) )
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

SWEP.GestureFire			= { ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN, 0.85 }
SWEP.GestureReload			= { ACT_FLINCH_STOMACH, 0.3 }
SWEP.GestureDraw			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.75 }
SWEP.GestureHolster			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.65 }
function SWEP:TPFire()
	local target = self:BClass( false ).GestureFire
	if !target then
		target = self.GestureFire
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end
function SWEP:TPReload()
	local target = self:BClass( false ).GestureReload
	if !target then
		target = self.GestureReload
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end
function SWEP:TPDraw()
	local target = self:BClass( false ).GestureDraw
	if !target then
		target = self.GestureDraw
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end
function SWEP:TPHolster()
	local target = self:BClass( false ) and self:BClass( false ).GestureHolster
	if !target then
		target = self.GestureHolster
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end

if CLIENT then

	function SWEP:DrawWorldModel()
		local p = self:GetOwner()
		local wm = self.CWM
		local class = self:BClass( false )
		if class then
			if !IsValid(wm) then
				wm = ClientsideModel( class.WModel )
				self.CWM = wm
			end
			wm:SetModel( class.WModel )
			wm:SetNoDraw( true )
			wm:AddEffects( EF_BONEMERGE )
			wm:SetParent( p )

			-- if IsValid(p) then
			-- 	-- Specify a good position
			-- 	local offsetVec = Vector(12.8, -1.4, 2.6)
			-- 	local offsetAng = Angle(180 - 10, 180, 0)
			-- 	
			-- 	local boneid = p:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			-- 	if !boneid then return end

			-- 	local matrix = p:GetBoneMatrix(boneid)
			-- 	if !matrix then return end
 
			-- 	local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			-- 	wm:SetPos(newPos)
			-- 	wm:SetAngles(newAng)

			-- 	wm:SetupBones()
			-- else
				-- wm:SetPos(self:GetPos())
				-- wm:SetAngles(self:GetAngles())
				-- wm:SetupBones()
			-- end

			if self:GetUserAim() then wm:DrawModel() end
		end
	end
end

-- Holdtype thingys
do
	local ActIndex = {
		[ "pistol" ]		= ACT_HL2MP_IDLE_PISTOL,
		[ "smg" ]			= ACT_HL2MP_IDLE_SMG1,
		[ "grenade" ]		= ACT_HL2MP_IDLE_GRENADE,
		[ "ar2" ]			= ACT_HL2MP_IDLE_AR2,
		[ "shotgun" ]		= ACT_HL2MP_IDLE_SHOTGUN,
		[ "rpg" ]			= ACT_HL2MP_IDLE_RPG,
		[ "physgun" ]		= ACT_HL2MP_IDLE_PHYSGUN,
		[ "crossbow" ]		= ACT_HL2MP_IDLE_CROSSBOW,
		[ "melee" ]			= ACT_HL2MP_IDLE_MELEE,
		[ "slam" ]			= ACT_HL2MP_IDLE_SLAM,
		[ "normal" ]		= ACT_HL2MP_IDLE,
		[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
		[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
		[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
		[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
		[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
		[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
		[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
		[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER,

		[ "suitcase" ]		= ACT_HL2MP_IDLE,
		[ "melee_angry" ]		= ACT_HL2MP_IDLE_MELEE_ANGRY,
		[ "angry" ]		= ACT_HL2MP_IDLE_ANGRY,
		[ "scared" ]		= ACT_HL2MP_IDLE_SCARED,
		[ "zombie" ]		= ACT_HL2MP_IDLE_ZOMBIE,
		[ "cower" ]		= ACT_HL2MP_IDLE_COWER,
	}

	--[[---------------------------------------------------------
		Name: SetWeaponHoldType
		Desc: Sets up the translation table, to translate from normal
				standing idle pose, to holding weapon pose.
	-----------------------------------------------------------]]
	function SWEP:SetWeaponHoldType( t )

		t = string.lower( t )
		local index = ActIndex[ t ]

		if ( index == nil ) then
			Msg( "SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n" )
			t = "normal"
			index = ActIndex[ t ]
		end

		self.ActivityTranslate = {}
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
		self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= index + 2
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= index + 6
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= index + 6
		self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9

		-- "normal" jump animation doesn't exist
		if ( t == "normal" ) then
			self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
		end

		if ( t == "suitcase" ) then
			self.ActivityTranslate[ ACT_MP_STAND_IDLE ] = ACT_HL2MP_IDLE_SUITCASE
			self.ActivityTranslate[ ACT_MP_WALK ] = ACT_HL2MP_WALK_SUITCASE
			self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
		end

		if ( t == "rpg" ) then
			self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_IDLE_CROUCH_AR2
			self.ActivityTranslate[ ACT_MP_CROUCHWALK ] = ACT_HL2MP_WALK_CROUCH_AR2
		end

		--self:SetupWeaponHoldTypeForAI( t )

	end

	-- Default hold pos is the pistol
	SWEP:SetWeaponHoldType( "pistol" )

	--[[---------------------------------------------------------
		Name: weapon:TranslateActivity()
		Desc: Translate a player's Activity into a weapon's activity
				So for example, ACT_HL2MP_RUN becomes ACT_HL2MP_RUN_PISTOL
				Depending on how you want the player to be holding the weapon
	-----------------------------------------------------------]]
	function SWEP:TranslateActivity( act )

		if ( self.Owner:IsNPC() ) then
			if ( self.ActivityTranslateAI[ act ] ) then
				return self.ActivityTranslateAI[ act ]
			end
			return -1
		end

		if ( self.ActivityTranslate[ act ] != nil ) then
			return self.ActivityTranslate[ act ]
		end

		return -1

	end
end