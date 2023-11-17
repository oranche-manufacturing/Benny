AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	self:SetModel( "models/items/boxsrounds.mdl" )
	if SERVER then
		self:SetUseType( SIMPLE_USE )

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
end

function ENT:Use( activator )
	if ( activator:IsPlayer() ) then 
		local wep = activator:GetActiveWeapon()
		local bt, bc = wep:BTable(), wep:BClass()
		for i=1, 3 do
			-- if bt["Ammo" .. i] and bt.Loaded != i then
			-- 	bt["Ammo" .. i] = bc.Ammo
			-- 	wep:BSend( { "Ammo" .. i, false, bc.Ammo } )
			-- end
		end
		self:EmitSound( "benny/weapons/mp5k/boltdrop.ogg", 70, 100, 0.5 )
	end
end