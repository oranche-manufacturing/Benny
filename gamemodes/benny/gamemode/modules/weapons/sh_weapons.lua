
local FIREMODE_AUTO = {
	{ Mode = math.huge },
}
local FIREMODE_AUTOSEMI = {
	{ Mode = math.huge },
	{ Mode = 1 },
}
local FIREMODE_SEMI = {
	{ Mode = 1 },
}

do -- Sound definitions

	AddSound( "Common.Unload", "benny/weapons/unload.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Dryfire.Pistol", "benny/weapons/common/06-13.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Dryfire.Rifle", "benny/weapons/common/06-12.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Deploy", "benny/weapons/common/magpouch.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Holster", "benny/weapons/common/magpouchin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.NoAmmo", "benny/weapons/noammo.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.ReloadFail", "benny/hud/reloadfail.ogg", 70, 100, 0.1, CHAN_STATIC )

-- Pistols
	-- Deagle
	AddSound( "Deagle.Cock", "benny/weapons/deagle/cock.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- Glock
	AddSound( "Glock.Fire", {
		"benny/weapons/glock/01.ogg",
		"benny/weapons/glock/02.ogg",
		"benny/weapons/glock/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "Glock.MagOut", "benny/weapons/glock/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Glock.MagIn", "benny/weapons/glock/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Glock.Cock", "benny/weapons/glock/cock.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- Anaconda
	AddSound( "Anaconda.Fire", {
		"benny/weapons/anaconda/01.ogg",
		"benny/weapons/anaconda/02.ogg",
		"benny/weapons/anaconda/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "Anaconda.MagOut", "benny/weapons/anaconda/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Anaconda.MagIn", "benny/weapons/anaconda/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

-- Rifles
	-- FNC
	AddSound( "FNC.Fire", {
		"benny/weapons/fnc/01.ogg",
		"benny/weapons/fnc/02.ogg",
		"benny/weapons/fnc/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "FNC.MagOut", "benny/weapons/fnc/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "FNC.MagIn", "benny/weapons/fnc/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "FNC.Cock", "benny/weapons/fnc/cock.ogg", 70, 100, 0.5, CHAN_STATIC )


end

do -- Bases

	ItemDef("base", {
		Name = "Base Item",
		Category = "base",
		Type = "base",
		Description = "Base of everything",

		WModel = "models/weapons/w_357.mdl",

		Speed_Move = 1,
		Speed_Aiming = 1,
		Speed_Reloading = 1,
		Speed_Firing = 1,
		Speed_FiringTime = 0.2,
		ShootHolsterTime = 0,

		Func_Attack = function( self, hand )
		end,

		Func_AttackAlt = function( self, hand )
		end,

		Func_Reload = function( self, hand )
		end,

		Func_Deploy = function( self, hand )
		end,

		Func_HolsterStart = function( self, hand )
		end,

		Func_HolsterFinish = function( self, hand )
		end,
	})

	ItemDef("base_firearm", {
		Name = "Base Firearm",
		Category = "base",
		Base = "base",
		Description = "Base for firearms",
		Features = "firearm",

		WModel = "models/weapons/w_pistol.mdl",
		HoldType = "pistol",

		-- Firearm specific
		Firemodes = {
			{
				Mode = 1,
			},
		},

		Damage = 0,
		AmmoStd = 1,
		Pellets = 1,
		Delay = 60/600,

		Spread = 0,
		SpreadAdd = 0,
		SpreadAddMax = 1,
		
		SpreadDecay_Start = 1,
		SpreadDecay_End = 2,
		SpreadDecay_RampTime = 1,
		
		Reload_MagOut = 0.2,
		Reload_MagIn = 0.8,
		Reload_MagIn_Bonus1 = 0.56,
		Reload_MagIn_Bonus2 = 0.56+0.1,

		Func_Attack = function( self, hand )
			if self:GetAim() == 1 then
				local p = self:GetOwner()
				local wep_table = self:bWepTable( hand )
				local wep_class = self:bWepClass( hand )
				if self:bGetIntDelay( hand ) > CurTime() then
					return
				end
				if self:bGetHolsterTime( hand ) > 0 then
					return
				end
				if self:bGetIntClip( hand ) == 0 then
					if self:bGetBurst( hand ) >= 1 then
						return
					end
					B_Sound( self, wep_class.Sound_DryFire )
					self:bSetBurst( hand, self:bGetBurst( hand ) + 1 )
					return
				end
				if self:bGetBurst( hand ) >= self:B_Firemode( hand ).Mode then
					return
				end
				
				if !ConVarSV_Bool("cheat_infiniteammo") then
					self:B_Ammo( hand, self:bGetIntClip( hand ) - 1 )
				end
		
				B_Sound( self, wep_class.Sound_Fire )
				self:TPFire( hand )
				self:CallFire( hand )
		
				self:bSetIntDelay( hand, CurTime() + wep_class.Delay )
				self:bSetBurst( hand, self:bGetBurst( hand ) + 1 )
				self:bSetSpread( hand, math.Clamp( self:bGetSpread( hand ) + wep_class.SpreadAdd, 0, wep_class.SpreadAddMax ) )
				self:bSetShotTime( hand, CurTime() )
		
				
				if CLIENT and IsFirstTimePredicted() then
					-- PROTO: This is shit! Replace it with a function that gets the right model.
					if IsValid(hand and self.CWM_Left or self.CWM) and (hand and self.CWM_Left or self.CWM):GetAttachment( 1 ) then
						local vStart = (hand and self.CWM_Left or self.CWM):GetAttachment( 1 ).Pos
						local ed = EffectData()
						ed:SetOrigin( vStart )
						ed:SetEntity( self )
						ed:SetAttachment( (hand and 16 or 0) + 1 )
						util.Effect( "benny_muzzleflash", ed )
					end
				end
			end
		end,

		Func_AttackAlt = function( self, hand )
			if self:bGetIntDelay( hand ) > CurTime() then
				return
			end
			self:bSetIntDelay( hand, CurTime() + 0.45 )

			self:TPCustom( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, 0.36 )

			local p = self:GetOwner()

			local tr = {
				start = p:EyePos(),
				endpos = p:EyePos() + p:EyeAngles():Forward()*64,
				mins = Vector( -8, -8, -8 ),
				maxs = Vector( 8, 8, 8 ),
				filter = p,
				collisiongroup = COLLISION_GROUP_PLAYER,
			}
			-- debugoverlay.SweptBox( tr.start, tr.endpos, tr.mins, tr.maxs, angle_zero, 3, Color( 255, 255, 255, 0 ))

			if p:IsPlayer() then p:LagCompensation( true ) end
			tr = util.TraceHull(tr)
			if p:IsPlayer() then p:LagCompensation( false ) end

			if tr.HitWorld then
				self:EmitSound( "physics/concrete/concrete_block_impact_hard1.wav", 70, 150 + util.SharedRandom( "Benny_RifleMelee", -20, 20 ), 0.25 )
			elseif tr.Entity and tr.Entity != NULL then
				self:EmitSound( "benny/violence/bodysplat_mix.ogg", 70, 100 + util.SharedRandom( "Benny_RifleMelee", -10, 10 ), 0.25 )

				if SERVER then
					local dmginfo = DamageInfo()
					dmginfo:SetAttacker( p )
					dmginfo:SetInflictor( self )
					dmginfo:SetDamage( 34 )
					
					dmginfo:SetDamagePosition( tr.HitPos )
					dmginfo:SetDamageForce( tr.Normal*100*34 )

					tr.Entity:TakeDamageInfo( dmginfo )
				end
				
			else
				self:EmitSound( "weapons/slam/throw.wav", 70, 200 + util.SharedRandom( "Benny_RifleMelee", -20, 20 ), 0.25 )
			end
		end,
	})

	local q1, q2 = Vector( -1, -1, -1 ), Vector( 1, 1, 1 )
	ItemDef("base_melee", {
		Name = "Base Melee",
		Category = "melee",
		Base = "base",
		Description = "Base for melee weapons",
		Features = "melee",

		WModel = "models/weapons/w_crowbar.mdl",
		HoldType = "melee",

		Damage = 34,
		Force = 100,
		Delay = 0.45,
		Range = 64,
		HullSize = 2,

		Func_Attack = function( self, hand )
			if self:bGetIntDelay( hand ) > CurTime() then
				return
			end
			local wep_table = self:bWepTable( hand )
			local wep_class = self:bWepClass( hand )
			self:bSetIntDelay( hand, CurTime() + wep_class.Delay )

			self:TPCustom( wep_class.GestureFire[1], wep_class.GestureFire[2] )

			local p = self:GetOwner()

			q1[1] = -wep_class.HullSize
			q1[2] = -wep_class.HullSize
			q1[3] = -wep_class.HullSize
			q2[1] = wep_class.HullSize
			q2[2] = wep_class.HullSize
			q2[3] = wep_class.HullSize
			local range = p:EyeAngles():Forward()
			range:Mul(wep_class.Range)
			range:Add(p:EyePos())
			local tr = {
				start = p:EyePos(),
				endpos = range,
				mins = q1,
				maxs = q2,
				filter = p,
				collisiongroup = COLLISION_GROUP_PLAYER,
			}
			-- debugoverlay.SweptBox( tr.start, tr.endpos, tr.mins, tr.maxs, angle_zero, 3, Color( 255, 255, 255, 0 ))

			if p:IsPlayer() then p:LagCompensation( true ) end
			tr = util.TraceHull(tr)
			if p:IsPlayer() then p:LagCompensation( false ) end

			if tr.HitWorld then
				self:EmitSound( "physics/concrete/concrete_block_impact_hard1.wav", 70, 150 + util.SharedRandom( "Benny_RifleMelee", -20, 20 ), 0.25 )
			elseif tr.Entity and tr.Entity != NULL then
				self:EmitSound( "benny/violence/bodysplat_mix.ogg", 70, 100 + util.SharedRandom( "Benny_RifleMelee", -10, 10 ), 0.25 )

				if SERVER then
					local dmginfo = DamageInfo()
					dmginfo:SetAttacker( p )
					dmginfo:SetInflictor( self )
					dmginfo:SetDamage( wep_class.Damage )
					
					dmginfo:SetDamagePosition( tr.HitPos )
					dmginfo:SetDamageForce( tr.Normal*wep_class.Force*wep_class.Damage )

					tr.Entity:TakeDamageInfo( dmginfo )
				end
				
			else
				self:EmitSound( "weapons/slam/throw.wav", 70, 200 + util.SharedRandom( "Benny_RifleMelee", -20, 20 ), 0.25 )
			end
		end,

		Func_AttackAlt = function( self, hand )
		end,
	})

	ItemDef("base_grenade", {
		Name = "Base Grenade",
		Category = "grenade",
		Base = "base",
		Description = "Base for grenades",
		Features = "grenade",

		WModel = "models/weapons/w_grenade.mdl",
		HoldType = "slam",
	})

	ItemDef("base_magazine", {
		Name = "Base Magazine",
		Category = "magazine",
		Base = "base",
		Description = "Base for magazines",
		Features = "magazine",

		WModel = "models/weapons/w_slam.mdl",
		HoldType = "slam",
	})

end

do -- Melee

	ItemDef("bat", {
		Name = "ALUMINUM BAT",
		Description = "Bonk!",
		Base = "base_melee",

		MAdj = Vector( 3, -2, 3 ),
		MAdjA = Angle( 0, 0, 180 ),
		WModel = "models/benny/wep/melee_bat.mdl",
		HoldType = "melee2",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		--
		Damage = 34,
		Force = 100,
		Delay = 0.45,
		Range = 72,
		HullSize = 2,
	})

	ItemDef("bat_wood", {
		Name = "BASEBALL BAT",
		Description = "There's my ball!",
		Base = "base_melee",

		MAdj = Vector( 3, -2, 3 ),
		MAdjA = Angle( 0, 0, 180 ),
		WModel = "models/benny/wep/melee_bat.mdl",
		HoldType = "melee2",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		--
		Damage = 34,
		Force = 100,
		Delay = 0.5,
		Range = 72,
		HullSize = 2,
	})

	ItemDef("machete", {
		Name = "MACHETE",
		Description = "Chop chop!",
		Base = "base_melee",

		MAdj = Vector( 3, -2, 0 ),
		MAdjA = Angle( 0, 0, 180 ),
		WModel = "models/benny/wep/melee_machete.mdl",
		HoldType = "melee",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		--
		Damage = 34,
		Force = 100,
		Delay = 0.4,
		Range = 64,
		HullSize = 2,
	})

	ItemDef("kabar", {
		Name = "KABAR",
		Description = "Shank shank!",
		Base = "base_melee",

		MAdj = Vector( 3, -2, 0 ),
		MAdjA = Angle( 0, 0, 180 ),
		WModel = "models/benny/wep/melee_kabar.mdl",
		HoldType = "knife",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, 0.0 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		--
		Damage = 34,
		Force = 100,
		Delay = 0.35,
		Range = 48,
		HullSize = 2,
	})

	ItemDef("baton", {
		Name = "BATON",
		Description = "Excessive force!",
		Base = "base_melee",

		MAdj = Vector( 3, -2, 0 ),
		MAdjA = Angle( 0, 0, 180 ),
		WModel = "models/benny/wep/melee_baton.mdl",
		HoldType = "melee2",
		GestureFire = { ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, 0.3 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		--
		Damage = 34,
		Force = 100,
		Delay = 0.45,
		Range = 64,
		HullSize = 2,
	})

end

do -- Pistols

	ItemDef("deagle", {
		Name = "DEAGLE",
		Description = "Autoloading .50 caliber pistol.",
		Base = "base_firearm",
		Category = "pistol",

		WModel = "models/weapons/w_pist_deagle.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.25 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Anaconda.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Anaconda.MagOut",
		Sound_MagIn = "Anaconda.MagIn",
		Sound_Cock = "Deagle.Cock",

		--
		AmmoStd = 7,
		AutoGenMag = true,
		Delay = (60/180),
		Firemodes = FIREMODE_SEMI,
		Damage = 47,
		Spread = 30/60,
		SpreadAdd = 4,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 8,
		SpreadDecay_End = 25,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 0.95,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.95,
		Speed_Firing = 0.95,
		Speed_FiringTime = 0.5,
	})

	ItemDef("glock", {
		Name = "GLOCK-18",
		Description = "Bullet storm. Lasts about a second or so, just like you!",
		Base = "base_firearm",
		Category = "pistol",

		WModel = "models/weapons/w_pist_glock18.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.25 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Glock.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Glock.MagOut",
		Sound_MagIn = "Glock.MagIn",
		Sound_Cock = "Glock.Cock",

		--
		AmmoStd = 17,
		AutoGenMag = true,
		Delay = (60/900),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 22,
		Spread = 60/60,
		SpreadAdd = 0.8,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,

		Reload_MagOut = 0.25,
		Reload_MagIn = 1.1,
		Reload_MagIn_Bonus1 = 0.8,
		Reload_MagIn_Bonus2 = 0.8+0.08,

		Speed_Move = 1,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.95,
		Speed_Firing = 0.95,
	})

end

do -- Rifles

	ItemDef("fnc", {
		Name = "FNC PARA",
		Description = "Run of the mill automatic assault rifle.",
		Base = "base_firearm",
		Category = "rifle",

		Icon = Material( "benny/weapons/fnc.png", "smooth" ),
		WModel = "models/weapons/w_rif_ar556.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "FNC.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "FNC.MagOut",
		Sound_MagIn = "FNC.MagIn",
		Sound_Cock = "FNC.Cock",

		--
		AmmoStd = 30,
		AutoGenMag = true,
		Delay = (60/700),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 30,
		Spread = 30/60,
		SpreadAdd = 22/60,
		SpreadAddMax = 10,
		
		SpreadDecay_Start = 0,
		SpreadDecay_End = 12,
		SpreadDecay_RampTime = 0.2,

		Reload_MagOut = 0.3,
		Reload_MagIn = 1.3,
		Reload_MagIn_Bonus1 = 0.8,
		Reload_MagIn_Bonus2 = 0.8+0.1,

		Speed_Move = 0.95,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.95,
		Speed_Firing = 0.95,
	})

end

for i, v in SortedPairs( WEAPONS ) do
	if v.AutoGenMag then
		ItemDef("mag_" .. i, {
			Name = "MAG: " .. v.Name,
			Base = "base_magazine",

			Ammo = v.AmmoStd,
		})
	end
end
--[[
ItemDef("deagle", {
	Name = "DEAGLE",
	Description = "Autoloading .50 caliber pistol.",
	Base = "base_firearm",
	Type = "pistol",

	Icon = Material( "benny/weapons/mk23.png", "smooth" ),
	WModel = "models/weapons/w_pist_deagle.mdl",
	HoldType = "revolver",
	GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.5 },
	GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

	Sound_Fire = "Anaconda.Fire",
	Sound_DryFire = "Common.Dryfire.Pistol",
	Sound_MagOut = "Anaconda.MagOut",
	Sound_MagIn = "Anaconda.MagIn",
	Sound_Cock = "Deagle.Cock",

	Delay = (60/180),
	Firemodes = FIREMODE_SEMI,
	Damage = 47,
	Spread = 30/60,
	SpreadAdd = 4,
	SpreadAddMax = 15,
	
	SpreadDecay_Start = 8,
	SpreadDecay_End = 25,
	SpreadDecay_RampTime = 0.5,

	Speed_Move = 0.95,
	Speed_Aiming = 0.95,
	Speed_Reloading = 0.95,
	Speed_Firing = 0.95,
	Speed_FiringTime = 0.5,

	Features = "firearm",
})
]]