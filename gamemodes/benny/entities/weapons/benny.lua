
SWEP.Base = "weapon_base"

SWEP.PrintName = "Benny Weapon Handler"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

function SWEP:PrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Reload()
	return true
end

function SWEP:Think()
	self:SetWeaponHoldType("normal")
	self:SetHoldType("normal")
	return true
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end