

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

		if ( t == "passive" ) then
			self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_IDLE_CROUCH_SLAM
			self.ActivityTranslate[ ACT_MP_CROUCHWALK ] = ACT_HL2MP_WALK_CROUCH_SLAM
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

SWEP.GestureFire			= { ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN, 0.85 }
SWEP.GestureReload			= { ACT_FLINCH_STOMACH, 0.3 }
SWEP.GestureDraw			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.75 }
SWEP.GestureHolster			= { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.65 }
function SWEP:TPFire( hand )
	if CLIENT and !IsFirstTimePredicted() then return end
	local target = self:bWepClass( hand ) and self:bWepClass( hand ).GestureFire
	if !target then
		target = self.GestureFire
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end
function SWEP:TPCustom( tg1, tg2 )
	if CLIENT and !IsFirstTimePredicted() then return end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(tg1), tg2, true )
end
function SWEP:TPReload( hand )
	if CLIENT and !IsFirstTimePredicted() then return end
	local target = self:bWepClass( hand ) and self:bWepClass( hand ).GestureReload
	if !target then
		target = self.GestureReload
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end
function SWEP:TPDraw( hand )
	if CLIENT and !IsFirstTimePredicted() then return end
	local target = self:bWepClass( hand ) and self:bWepClass( hand ).GestureDraw
	if !target then
		target = self.GestureDraw
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end
function SWEP:TPHolster( hand )
	if CLIENT and !IsFirstTimePredicted() then return end
	local target = self:bWepClass( hand ) and self:bWepClass( hand ).GestureHolster
	if !target then
		target = self.GestureHolster
	end
	self:GetOwner():AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, self:GetOwner():SelectWeightedSequence(target[1]), target[2], true )
end