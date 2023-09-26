
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

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Aim" )
	self:NetworkVar( "Float", 1, "Delay1" )
	self:NetworkVar( "Float", 2, "Delay2" )
	self:NetworkVar( "String", 0, "Wep1" )
	self:NetworkVar( "String", 1, "Wep2" )
	self:NetworkVar( "Int", 0, "Wep1Clip" )
	self:NetworkVar( "Int", 1, "Wep2Clip" )
end

function SWEP:PrimaryAttack()
	if !self:BTable() then
		return
	end
	if self:GetDelay1() > CurTime() then
		return
	end
	if self:Clip1() == 0 then
		B_Sound( self, self:BClass( false ).Sound_DryFire )
		self:SetDelay1( CurTime() + 0.2 )
		return
	end
	
	B_Sound( self, self:BClass( false ).Sound_Fire )

	self:B_Ammo( false, self:Clip1() - 1 )
	self:SetDelay1( CurTime() + self:BClass( false ).Delay )
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
	if self:BTable( false ) then
		if self:GetDelay1() > CurTime() then
			return false
		end
		self:SetDelay1( CurTime() + 0.2 )

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
	end
	return true
end

function SWEP:Think()
	local p = self:GetOwner()

	self:SetAim( math.Approach( self:GetAim(), p:KeyDown(IN_ATTACK2) and 1 or 0, FrameTime()/0.05 ) )

	local ht = "normal"
	if self:GetAim() > 0 then
		ht = "revolver"
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