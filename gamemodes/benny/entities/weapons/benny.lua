
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

	self:NetworkVarNotify( "Wep1", self.OnVarChanged )
	self:NetworkVarNotify( "Wep2", self.OnVarChanged )
end

function SWEP:OnVarChanged( name, old, new )
	print( name, old, new )
	if name == "Wep1" then
		self.B_WepT1 = self:GetOwner():INV_Get()[new]
		self.B_ClassT1 = WEAPONS[self.B_WepT1.Class]
	elseif name == "Wep2" then
		self.B_WepT2 = self:GetOwner():INV_Get()[new]
		self.B_ClassT2 = WEAPONS[self.B_WepT1.Class]
	end
end

function SWEP:PrimaryAttack()
	if self:GetDelay1() > CurTime() then
		return
	end
	if self:Clip1() == 0 then
		self:EmitSound( "benny/weapons/common/06-13.ogg", 80, 100, 1, CHAN_STATIC )
		self:SetDelay1( CurTime() + 0.2 )
		return
	end
	if !self:B_Wep1() then
		return
	end
	
	if CLIENT then
		AddCaption( "PISTOL", Color( 61, 61, 61 ), "[Pistol shot]", 0.1, 0.5 )
	end

	self:EmitSound( "benny/weapons/1911/0".. math.random(1,3) ..".ogg", 110, 100, 1, CHAN_STATIC )

	self:B_Ammo1( self:Clip1() - 1 )
	self:SetDelay1( CurTime() + 0.2 )
	return true
end

-- BENNY shit
function SWEP:B_Wep1()
	return self:GetOwner():INV_Get()[self:GetWep1()]
end

function SWEP:B_Wep2()
	return self:GetOwner():INV_Get()[self:GetWep2()]
end

function SWEP:B_Ammo1( value )
	self:SetClip1( value )
	self:B_Wep1().Ammo = value
end

function SWEP:B_Ammo2( value )
	self:SetClip2( value )
	self:B_Wep2().Ammo = value
end

function SWEP:B_MaxAmmo1( value )
	self:SetClip1( value )
	self:B_Wep1().Ammo = value
end

function SWEP:B_Class1()
	return WEAPONS[ self:B_Wep1().Class ]
end

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Reload()
	if self:B_Wep1() then
		self:B_Ammo1( self:B_Class1().Ammo )
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