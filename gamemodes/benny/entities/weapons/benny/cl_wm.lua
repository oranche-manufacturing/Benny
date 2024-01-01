function SWEP:DrawWorldModel()
	local p = self:GetOwner()
	do
		local wm = self.CWM
		local class = self:bWepClass( false )
		if class then
			if !IsValid(wm) then
				wm = ClientsideModel( class.WModel )
				self.CWM = wm
			end
			wm:SetModel( class.WModel )
			wm:SetNoDraw( true )
			wm:AddEffects( EF_BONEMERGE )
			wm:SetParent( p )
			if true or self:GetUserAim() then wm:DrawModel() end
		else
			if IsValid(wm) then wm:Remove() end
		end
	end
	do
		local wm = self.CWM_Left
		local class = self:bWepClass( true )
		if class then
			if !IsValid(wm) then
				wm = ClientsideModel( class.WModel )
				self.CWM_Left = wm
			end
			wm:SetModel( class.WModel )
			wm:SetNoDraw( true )
			
			if IsValid(p) then
				-- Specify a good position
				wm:SetPos( vector_origin )
				wm:SetAngles( angle_zero )
				wm:SetupBones()

				local pv = wm:GetBoneMatrix( wm:LookupBone( "ValveBiped.Bip01_R_Hand" ) ):GetTranslation()
				local pa = wm:GetBoneMatrix( wm:LookupBone( "ValveBiped.Bip01_R_Hand" ) ):GetAngles()
				pv.x = -pv.x
				pv.y = pv.y
				pv.z = -pv.z
				pa.p = -pa.p
				pa.r = pa.r + 180
				
				local boneid = p:LookupBone("ValveBiped.Bip01_L_Hand") -- Right Hand
				if !boneid then return end

				local matrix = p:GetBoneMatrix(boneid)
				if !matrix then return end

				local newPos, newAng = LocalToWorld(pv, pa, matrix:GetTranslation(), matrix:GetAngles())

				wm:SetPos(newPos)
				wm:SetAngles(newAng)

				wm:SetupBones()
			else
				wm:SetPos(self:GetPos())
				wm:SetAngles(self:GetAngles())
				wm:SetupBones()
			end

			if true or self:GetUserAim() then wm:DrawModel() end
		else
			if IsValid(wm) then wm:Remove() end
		end
	end
end