
-- The benny weapon handles the weapon pickups you find throughout the game.

SWEP.Base = "weapon_base"

SWEP.PrintName = "Benny Weapon Handler"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Aim" )
end

function SWEP:PrimaryAttack()
	if self:Clip1() == 0 then
		self:EmitSound( "benny/weapons/common/06-13.ogg", 80, 100, 1, CHAN_STATIC )
		return
	end
	
	if CLIENT then
		AddCaption( "PISTOL", Color( 61, 61, 61 ), "[Pistol shot]", 0.1, 0.5 )
	end

	self:EmitSound( "benny/weapons/1911/0".. math.random(1,3) ..".ogg", 110, 100, 1, CHAN_STATIC )

	self:SetClip1( self:Clip1() - 1 )
	return true
end

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Reload()
	self:SetClip1( 17 )
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