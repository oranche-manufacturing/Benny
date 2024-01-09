
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

	-- 1911
	AddSound( "1911.Fire", {
		"benny/weapons/1911/01.ogg",
		"benny/weapons/1911/02.ogg",
		"benny/weapons/1911/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "1911.MagOut", "benny/weapons/1911/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "1911.MagIn", "benny/weapons/1911/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- Nambu
	AddSound( "Nambu.Fire", {
		"benny/weapons/nambu/01.ogg",
		"benny/weapons/nambu/02.ogg",
		"benny/weapons/nambu/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "Nambu.MagOut", "benny/weapons/nambu/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Nambu.MagIn", "benny/weapons/nambu/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- USP
	AddSound( "USP.Fire", {
		"benny/weapons/usp/01.ogg",
		"benny/weapons/usp/02.ogg",
		"benny/weapons/usp/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "USP.MagOut", "benny/weapons/usp/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "USP.MagIn", "benny/weapons/usp/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- M92
	AddSound( "M92.Fire", {
		"benny/weapons/m92/01.ogg",
		"benny/weapons/m92/02.ogg",
		"benny/weapons/m92/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	-- P226
	AddSound( "P226.Fire", {
		"benny/weapons/p226/01.ogg",
		"benny/weapons/p226/02.ogg",
		"benny/weapons/p226/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	-- M92
	AddSound( "M92.MagOut", "benny/weapons/m92/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "M92.MagIn", "benny/weapons/m92/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- P226
	AddSound( "P226.MagOut", "benny/weapons/p226/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "P226.MagIn", "benny/weapons/p226/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- CZ-75A


-- SMGs
	-- Bizon
	AddSound( "Bizon.Fire", {
		"benny/weapons/bizon/01.ogg",
		"benny/weapons/bizon/02.ogg",
		"benny/weapons/bizon/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "Bizon.MagOut", "benny/weapons/bizon/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Bizon.MagIn", "benny/weapons/bizon/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- MP5K
	AddSound( "MP5K.Fire", {
		"benny/weapons/mp5k/01.ogg",
		"benny/weapons/mp5k/02.ogg",
		"benny/weapons/mp5k/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "MP5K.MagOut", "benny/weapons/mp5k/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MP5K.MagIn", "benny/weapons/mp5k/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MP5K.Cock", "benny/weapons/mp5k/cock.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- MAC11
	AddSound( "MAC11.Fire", {
		"benny/weapons/mac11/01.ogg",
		"benny/weapons/mac11/02.ogg",
		"benny/weapons/mac11/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "MAC11.MagOut", "benny/weapons/mac11/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MAC11.MagIn", "benny/weapons/mac11/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- MP7
	AddSound( "MP7.Fire", {
		"benny/weapons/mp7/01.ogg",
		"benny/weapons/mp7/02.ogg",
		"benny/weapons/mp7/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "MP7.MagOut", "benny/weapons/mp7/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MP7.MagIn", "benny/weapons/mp7/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- TMP
	AddSound( "TMP.Fire", {
		"benny/weapons/tmp/01.ogg",
		"benny/weapons/tmp/02.ogg",
		"benny/weapons/tmp/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "TMP.MagOut", "benny/weapons/tmp/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "TMP.MagIn", "benny/weapons/tmp/magin.ogg", 70, 100, 0.5, CHAN_STATIC )


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

	-- M16A2
	AddSound( "M16A2.Fire", {
		"benny/weapons/m16a2/01.ogg",
		"benny/weapons/m16a2/02.ogg",
		"benny/weapons/m16a2/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "M16A2.MagOut", "benny/weapons/m16a2/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "M16A2.MagIn", "benny/weapons/m16a2/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "M16A2.Cock", "benny/weapons/m16a2/cock.ogg", 70, 100, 0.5, CHAN_STATIC )


-- Shotguns
	-- AA12
	AddSound( "AA12.Fire", "benny/weapons/aa12/01.ogg", 140, 100, 0.5, CHAN_STATIC )
	AddSound( "AA12.MagOut", "benny/weapons/aa12/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "AA12.MagIn", "benny/weapons/aa12/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	-- SPAS-12
	AddSound( "SPAS12.Fire", {
		"benny/weapons/spas12/01.ogg",
		"benny/weapons/spas12/02.ogg",
		"benny/weapons/spas12/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "SPAS12.MagOut", {
		"benny/weapons/spas12/magout-01.ogg",
		"benny/weapons/spas12/magout-02.ogg",
		"benny/weapons/spas12/magout-03.ogg",
	}, 70, 100, 0.5, CHAN_STATIC )
	AddSound( "SPAS12.MagIn", "benny/weapons/spas12/magin.ogg", 70, 100, 0.5, CHAN_STATIC )


-- Machine Guns
	-- QBB-LSW
	AddSound( "QBBLSW.Fire", {
		"benny/weapons/qbblsw/fire-01.ogg",
		"benny/weapons/qbblsw/fire-02.ogg",
		"benny/weapons/qbblsw/fire-03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	-- Stoner 63
	AddSound( "Stoner63.Fire", {
		"benny/weapons/stoner63/01.ogg",
		"benny/weapons/stoner63/02.ogg",
		"benny/weapons/stoner63/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )


-- Snipers
	-- Barrett .50
	AddSound( "Barrett.Fire", {
		"benny/weapons/barrett/fire-01.ogg",
		"benny/weapons/barrett/fire-02.ogg",
		"benny/weapons/barrett/fire-03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )
	AddSound( "Barrett.MagOut", "benny/weapons/barrett/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Barrett.MagIn", "benny/weapons/barrett/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Barrett.Cock", "benny/weapons/barrett/cock.ogg", 70, 100, 0.5, CHAN_STATIC )


end

do -- Bases

	ItemDef("base", {
		Name = "Base Item",
		Category = "base",
		Type = "base",
		Description = "Base of everything",
		Hide = true,

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
		Hide = true,

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
		Hide = true,

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
		Hide = true,

		WModel = "models/weapons/w_grenade.mdl",
		HoldType = "slam",
	})

	ItemDef("base_magazine", {
		Name = "Base Magazine",
		Category = "magazine",
		Base = "base",
		Description = "Base for magazines",
		Features = "magazine",
		Hide = true,

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

	ItemDef("cz75a", {
		Name = "CZ-75A",
		Description = "Automatic pocket machine pistol!",
		Base = "base_firearm",
		Category = "pistol",

		WModel = "models/weapons/w_pist_pmt.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.25 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Glock.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Glock.MagOut",
		Sound_MagIn = "Glock.MagIn",
		Sound_Cock = "Glock.Cock",

		--
		AmmoStd = 12,
		AutoGenMag = true,
		Delay = (60/1100),
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

	ItemDef("1911", {
		Name = "COBRA .45",
		Description = "Hits hard. They don't make them like they used to!",
		Base = "base_firearm",
		Category = "pistol",
		
		WModel = "models/weapons/w_colt.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },
		
		Sound_Fire = "1911.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_Reload = "1911.Reload",
		Sound_MagOut = "1911.MagOut",
		Sound_MagIn = "1911.MagIn",
		Sound_Cock = "Glock.Cock",
		
		--
		AmmoStd = 8,
		AutoGenMag = true,
		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Damage = 30,
		Spread = 22/60,
		SpreadAdd = 0.5,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,
		
		Reload_MagOut = 0.1,
		Reload_MagIn = 0.75,
		Reload_MagIn_Bonus1 = 0.4,
		Reload_MagIn_Bonus2 = 0.4+0.15,
		
		Speed_Move = 1,
		Speed_Aiming = 0.98,
		Speed_Reloading = 1,
		Speed_Firing = 1,
	})
	
	ItemDef("mk23", {
		Name = "MK. 23",
		Description = "If it works for hardasses around the world, it'll work for you.",
		Base = "base_firearm",
		Category = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_pist_usp.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "USP.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_Reload = "USP.Reload",
		Sound_MagOut = "USP.MagOut",
		Sound_MagIn = "USP.MagIn",
		Sound_Cock = "Glock.Cock",

		--
		AmmoStd = 12,
		AutoGenMag = true,
		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Damage = 32,
		Spread = 15/60,
		SpreadAdd = 0.4,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,

		Reload_MagOut = 0.15,
		Reload_MagIn = 0.85,
		Reload_MagIn_Bonus1 = 0.5,
		Reload_MagIn_Bonus2 = 0.5+0.12,

		Speed_Move = 1,
		Speed_Aiming = 0.98,
		Speed_Reloading = 1,
		Speed_Firing = 1,
	})

	ItemDef("nambu", {
		Name = "NAMBU .38",
		Description = "Eastern revolver that hits as hard as it costs.",
		Base = "base_firearm",
		Category = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_pist_derringer.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.3 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Nambu.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Nambu.MagOut",
		Sound_MagIn = "Nambu.MagIn",
		Sound_Cock = "Glock.Cock",

		--
		AmmoStd = 6,
		AutoGenMag = true,
		Delay = (60/180),
		Firemodes = FIREMODE_SEMI,
		Damage = 36,
		Spread = 30/60,
		SpreadAdd = 1.5,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,

		Reload_MagOut = 0.5,
		Reload_MagIn = 0.5,
		Reload_MagIn_Bonus1 = 0.2,
		Reload_MagIn_Bonus2 = 0.2+0.1,

		Speed_Move = 1,
		Speed_Aiming = 1,
		Speed_Reloading = 0.9,
		Speed_Firing = 1,
	})

	ItemDef("anaconda", {
		Name = "ANACONDA",
		Description = "Precise and kicks like a mule.",
		Base = "base_firearm",
		Category = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_357.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.1 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Anaconda.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Anaconda.MagOut",
		Sound_MagIn = "Anaconda.MagIn",
		Sound_Cock = "Glock.Cock",

		--
		AmmoStd = 6,
		AutoGenMag = true,
		Delay = (60/180),
		Firemodes = FIREMODE_SEMI,
		Damage = 55,
		Spread = 30/60,
		SpreadAdd = 6,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 6,
		SpreadDecay_End = 22,
		SpreadDecay_RampTime = 0.65,

		Reload_MagOut = 0.6,
		Reload_MagIn = 0.6,
		Reload_MagIn_Bonus1 = 0.18,
		Reload_MagIn_Bonus2 = 0.18+0.08,

		Speed_Move = 1.0,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.9,
		Speed_Firing = 0.95,
	})

end

do -- SMGs
	
	ItemDef("tmp", {
		Name = "TMP",
		Description = "Small, compact, and favored by private security.",
		Base = "base_firearm",
		Category = "smg",

		WModel = "models/weapons/w_smg_tmp_us.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "TMP.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "TMP.Reload",
		Sound_MagOut = "TMP.MagOut",
		Sound_MagIn = "TMP.MagIn",
		Sound_Cock = "MP5K.Cock",

		--
		AmmoStd = 15,
		AutoGenMag = true,
		Delay = (60/650),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 22,
		Spread = 20/60,
		SpreadAdd = 10/60,
		SpreadAddMax = 10,

		SpreadDecay_Start = 4,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.4,

		Speed_Move = 0.97,
		Speed_Aiming = 0.97,
		Speed_Reloading = 0.97,
		Speed_Firing = 0.97,
	})

	ItemDef("mp7", {
		Name = "MP7",
		Description = "Small, pistol-sized, goes through kevlar like a knife.",
		Base = "base_firearm",
		Category = "smg",

		WModel = "models/weapons/w_smg1.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "MP7.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "MP7.Reload",
		Sound_MagOut = "MP7.MagOut",
		Sound_MagIn = "MP7.MagIn",
		Sound_Cock = "MP5K.Cock",

		--
		AmmoStd = 20,
		AutoGenMag = true,
		Delay = (60/900),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 19,
		Spread = 20/60,
		SpreadAdd = 20/60,
		SpreadAddMax = 10,

		SpreadDecay_Start = 2,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.2,

		Speed_Move = 0.97,
		Speed_Aiming = 0.97,
		Speed_Reloading = 0.97,
		Speed_Firing = 0.97,
	})

	ItemDef("mp5k", {
		Name = "MP5K",
		Description = "Quality manufacturing, but a cumbersome reload.",
		Base = "base_firearm",
		Category = "smg",

		WModel = "models/weapons/w_smg_mp5k.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "MP5K.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "MP5K.Reload",
		Sound_MagOut = "MP5K.MagOut",
		Sound_MagIn = "MP5K.MagIn",
		Sound_Cock = "MP5K.Cock",

		--
		AmmoStd = 15,
		AutoGenMag = true,
		Delay = (60/750),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 22,
		Spread = 20/60,
		SpreadAdd = 10/60,
		SpreadAddMax = 10,

		SpreadDecay_Start = 3,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.3,

		Speed_Move = 0.97,
		Speed_Aiming = 0.97,
		Speed_Reloading = 0.97,
		Speed_Firing = 0.97,
	})

	ItemDef("mac11", {
		Name = "MAC-11",
		Description = "More fit for combat in a phone booth.",
		Base = "base_firearm",
		Category = "smg",

		WModel = "models/weapons/w_smg_mac10.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.1 },

		Sound_Fire = "MAC11.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "MAC11.Reload",
		Sound_MagOut = "MAC11.MagOut",
		Sound_MagIn = "MAC11.MagIn",
		Sound_Cock = "MP5K.Cock",

		--
		AmmoStd = 16,
		AutoGenMag = true,
		Delay = (60/1400),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 19,
		Spread = 60/60,
		SpreadAdd = 30/60,
		SpreadAddMax = 20,

		SpreadDecay_Start = 10,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.3,

		Speed_Move = 0.97,
		Speed_Aiming = 0.97,
		Speed_Reloading = 0.97,
		Speed_Firing = 0.97,
	})

	ItemDef("bizon", {
		Name = "BIZON",
		Description = "Unwieldy bullet storm.",
		Base = "base_firearm",
		Category = "smg",

		WModel = "models/weapons/w_smg_bizon.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.34 },

		Sound_Fire = "Bizon.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "Bizon.Reload",
		Sound_MagOut = "Bizon.MagOut",
		Sound_MagIn = "Bizon.MagIn",
		Sound_Cock = "MP5K.Cock",

		--
		AmmoStd = 40,
		AutoGenMag = true,
		Delay = (60/700),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 20,
		Spread = 40/60,
		SpreadAdd = 10/60,
		SpreadAddMax = 20,
		
		SpreadDecay_Start = 1,
		SpreadDecay_End = 10,
		SpreadDecay_RampTime = 0.6,

		Speed_Move = 0.94,
		Speed_Aiming = 0.94,
		Speed_Reloading = 0.93,
		Speed_Firing = 0.93,
	})

	ItemDef("chicom", {
		Name = "QCW-CQB-21",
		Description = "Subsonic bullpup SMG.",
		Base = "base_firearm",
		Category = "smg",

		WModel = "models/weapons/w_rif_famas.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.34 },

		Sound_Fire = "M92.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "Bizon.Reload",
		Sound_MagOut = "Bizon.MagOut",
		Sound_MagIn = "Bizon.MagIn",
		Sound_Cock = "MP5K.Cock",

		--
		AmmoStd = 36,
		AutoGenMag = true,
		Delay = (60/1050),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 18,
		Spread = 40/60,
		SpreadAdd = 33/60,
		SpreadAddMax = 20,
		
		SpreadDecay_Start = 4,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.7,

		Speed_Move = 0.95,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.94,
		Speed_Firing = 0.94,
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

	ItemDef("qbz", {
		Name = "QBZ-95",
		Description = "Bullpup assault rifle. Low profile, great in close quarters.",
		Base = "base_firearm",
		Category = "rifle",

		Icon = Material( "benny/weapons/fnc.png", "smooth" ),
		WModel = "models/weapons/w_rif_bakm.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "QBBLSW.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "FNC.MagOut",
		Sound_MagIn = "FNC.MagIn",
		Sound_Cock = "FNC.Cock",

		--
		AmmoStd = 30,
		AutoGenMag = true,
		Delay = (60/800),
		Firemodes = FIREMODE_AUTOSEMI,
		Damage = 28,
		Spread = 45/60,
		SpreadAdd = 35/60,
		SpreadAddMax = 10,
		
		SpreadDecay_Start = 12,
		SpreadDecay_End = 36,
		SpreadDecay_RampTime = 0.6,

		Reload_MagOut = 0.4,
		Reload_MagIn = 1.5,
		Reload_MagIn_Bonus1 = 0.8,
		Reload_MagIn_Bonus2 = 0.8+0.1,

		Speed_Move = 0.975,
		Speed_Aiming = 0.975,
		Speed_Reloading = 0.975,
		Speed_Firing = 0.975,
	})

	ItemDef("m16a2", {
		Name = "M16A2",
		Description = "Burst-fire assault rifle. Precise and effective at range.",
		Base = "base_firearm",
		Category = "rifle",

		Icon = Material( "benny/weapons/m16a2.png", "smooth" ),
		WModel = "models/weapons/w_rif_m16a2.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "M16A2.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "M16A2.MagOut",
		Sound_MagIn = "M16A2.MagIn",
		Sound_Cock = "M16A2.Cock",

		--
		AmmoStd = 30,
		AutoGenMag = true,
		Delay = (60/700),
		Firemodes = {
			{ Mode = 3 },
			{ Mode = 1 },
		},
		Damage = 32,
		Spread = 22/60,
		SpreadAdd = 11/60,
		SpreadAddMax = 10,
		
		SpreadDecay_Start = 0,
		SpreadDecay_End = 12,
		SpreadDecay_RampTime = 0.3,

		Reload_MagOut = 0.3,
		Reload_MagIn = 1.3,
		Reload_MagIn_Bonus1 = 0.6,
		Reload_MagIn_Bonus2 = 0.6+0.1,

		Speed_Move = 0.95,
		Speed_Aiming = 0.9,
		Speed_Reloading = 0.95,
		Speed_Firing = 0.9,
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