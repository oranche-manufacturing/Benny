
function SWEP:Drop( hand )
	if self:bWepClass( hand ) then
		local p = self:GetOwner()
		self:EmitSound( "weapons/slam/throw.wav", 70, 100, 1, CHAN_STATIC )

		if SERVER then
			local throw = ents.Create( "b-item" )
			throw:SetPos( p:EyePos() + p:EyeAngles():Forward()*16 )
			throw:SetAngles( p:EyeAngles() )
			throw:SetOwner( p )
			throw:InitSpecial(self:bWepClass( hand ).WModel)
			throw:SetPhysicsAttacker( p )
			throw:Spawn()
			local throwp = throw:GetPhysicsObject()
			assert( throwp:IsValid(), "Benny Drop: Physics object invalid" )
			throwp:SetVelocityInstantaneous( (p:EyeAngles()+Angle(-7,0,0)):Forward()*1000 )
			if self:bWepClass( hand ).ClassName == "m16a2" then
				throwp:SetAngleVelocityInstantaneous( Vector( 360*-0.2, 360*1, 360*0 ) )
			else
				throwp:SetAngleVelocityInstantaneous( Vector( 360*-0.25, 360*10, 360*0.25 ) )
			end
		end

		if SERVER or CLIENT and IsFirstTimePredicted() then
			--InvDiscard( p, self:bGetInvID( hand ) )
		end
		self:SetJustThrew( CurTime() + 0.25 )
		self:SetJustThrewHand( hand )
		self:bWepTable( hand ).Thrown = true
		p:AddVCDSequenceToGestureSlot( GESTURE_SLOT_JUMP, p:SelectWeightedSequence( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE ), 0, true )

	end
end
