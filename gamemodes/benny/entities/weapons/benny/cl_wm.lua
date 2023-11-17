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