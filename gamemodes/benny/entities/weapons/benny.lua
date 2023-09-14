
SWEP.Base = "weapon_base"

SWEP.PrintName = "Benny Weapon Handler"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

function SWEP:PrimaryAttack()
	if CLIENT then
		AddCaption( "PISTOL", Color( 61, 61, 61 ), "[Pistol shot]", 0.1, 0.5 )
	end
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