
do -- Toolgun

	local ToolGunTools = {
		["ammocrate"] = function( self, p, tr )
			if SERVER then
				local summon = ents.Create( "benny_equipment_ammo" )
				summon:SetPos( tr.HitPos + tr.HitNormal )
				summon:Spawn()
			end
		end,
		["summon_human"] = function( self, p, tr )
			if SERVER then
				local summon = ents.Create( "benny_npc_human" )
				summon:SetPos( tr.HitPos + tr.HitNormal )
				local ang = Angle( 0, p:EyeAngles().y+0, 0 )
				summon:SetAngles( ang )
				summon:Spawn()
			end
		end,
		["remover"] = function( self, p, tr )
			if SERVER then
				local ent = tr.Entity
				if IsValid( ent ) then
					ent:Remove()
					return
				end
			end
		end,
	}
	local function CreateSelect()
		local Frame = vgui.Create( "DFrame" )
		Frame:SetSize( 300, 85 )
		Frame:SetTitle( "Toolgun Select" )
		Frame:Center()
		Frame:MakePopup()

		local Text = Frame:Add( "DLabel" )
		Text:Dock( TOP )
		Text:DockMargin( 10, 0, 10, 0 )
		Text:SetText( "Select a tool." )

		local List = Frame:Add( "DComboBox" )
		List:Dock( TOP )
		List:SetValue(GetConVar("benny_wep_toolgun"):GetString())
		List:DockMargin( 10, 0, 10, 0 )
		for i, v in SortedPairs( ToolGunTools ) do
			List:AddChoice( i )
		end
		List.OnSelect = function( self, index, value )
			RunConsoleCommand( "benny_wep_toolgun", value )
			Frame:Remove()
		end
	end
	WEAPONS["toolgun"] = {
		Name = "TOOL GUN",
		Description = "Developer development device. Hold ALT for Remover",
		Type = "special",

		WModel = "models/weapons/w_toolgun.mdl",
		HoldType = "revolver",
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,

		Custom_Fire = function( self, data )
			if self:GetDelay1() > CurTime() then
				return true
			end
			self:SetDelay1( CurTime() + 0.2 )
		
			local p = self:GetOwner()
		
			local tr = p:GetEyeTrace()
			local tool = p:KeyDown( IN_WALK ) and "remover" or p:GetInfo( "benny_wep_toolgun" )
			if ToolGunTools[tool] then ToolGunTools[tool]( self, p, tr ) else return true end
		
			if CLIENT and IsFirstTimePredicted() then
				local vStart = self:GetAttachment( 1 ).Pos
				local vPoint = tr.HitPos
				local effectdata = EffectData()
				effectdata:SetStart( vStart )
				effectdata:SetOrigin( vPoint )
				util.Effect( "ToolTracer", effectdata )
			end
		
			-- Return true to skip weapon logic
			return true
		end,
		
		Custom_Reload = function( self, data )
			if CLIENT then
				CreateSelect()
			end
		
			-- Return true to skip weapon logic
			return true
		end,

		Features = "firearm",
	}

	
	WEAPONS["camera"] = {
		Name = "CAMERA",
		Description = "Developer development device",
		Type = "special",

		WModel = "models/maxofs2d/camera.mdl",
		HoldType = "camera",
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,

		Custom_Fire = function( self, data )
			if self:GetDelay1() > CurTime() then
				return true
			end
			self:SetDelay1( CurTime() + 0.2 )
		
			local p = self:GetOwner()

			if CLIENT and IsFirstTimePredicted() then
				local zp, za, zf = p:EyePos(), p:EyeAngles(), 90
				RunConsoleCommand( "benny_cam_override", zp.x .. " " .. zp.y .. " " .. zp.z .. " " .. za.p .. " " .. za.y .. " " .. za.r .. " " .. zf )
			end
		
			-- Return true to skip weapon logic
			return true
		end,
		
		Custom_Reload = function( self, data )
			RunConsoleCommand( "benny_cam_override", "" )
			
			-- Return true to skip weapon logic
			return true
		end,
		
		Custom_DisableSpecialMovement = function( self, data )
			-- Return true to skip weapon logic
			if self:GetUserAim() then
				return true
			end
		end,

		Custom_CalcView = function( self, data )
			if self:GetUserAim() and GetConVar("benny_cam_override"):GetString() == "" then
				data.drawviewer = false
				data.origin = self:GetOwner():EyePos()
				data.angles = self:GetOwner():EyeAngles()
				return true -- Return true to halt
			end

		end,

		Features = "firearm",
	}
end

do -- Handguns

end

do -- SMGs & PDWs

end

do -- Shotguns

	WEAPONS["spas12"] = {
		Name = "SPAS-12",
		Description = "Heavy metal pump-action shotgun.",
		Type = "shotgun",

		WModel = "models/weapons/w_shotgun.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.5 },

		Sound_Fire = "SPAS12.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "SPAS12.MagOut",
		Sound_MagIn = "SPAS12.MagIn",

		Delay = (60/120),
		Firemodes = FIREMODE_SEMI,
		Ammo = 8,
		Damage = 10,
		Pellets = 8,
		Spread = 150/60,
		SpreadAdd = 150/60,
		SpreadAddMax = 20,
		
		SpreadDecay_Start = 2,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.7,

		Speed_Move = 0.93,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.85,
		Speed_Firing = 0.75,

		Features = "firearm",
	}

	WEAPONS["doublebarrel"] = {
		Name = "D/B",
		Description = "Pocket-sized double-barrelled rocket of fun!",
		Type = "shotgun",

		WModel = "models/weapons/w_shot_shorty.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.5 },

		Sound_Fire = "SPAS12.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "SPAS12.MagOut",
		Sound_MagIn = "SPAS12.MagIn",

		Delay = (60/120),
		Firemodes = FIREMODE_SEMI,
		Ammo = 2,
		Damage = 10,
		Pellets = 8,
		Spread = 300/60,
		SpreadAdd = 150/60,
		SpreadAddMax = 20,
		
		SpreadDecay_Start = 10,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 0.95,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.9,
		Speed_Firing = 0.9,

		Features = "firearm",
	}

	WEAPONS["overunder"] = {
		Name = "O/U",
		Description = "Full-length double-barrelled bar fight finisher.",
		Type = "shotgun",

		WModel = "models/weapons/w_shot_kozlice.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.5 },

		Sound_Fire = "SPAS12.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "SPAS12.MagOut",
		Sound_MagIn = "SPAS12.MagIn",

		Delay = (60/120),
		Firemodes = FIREMODE_SEMI,
		Ammo = 2,
		Damage = 10,
		Pellets = 8,
		Spread = 130/60,
		SpreadAdd = 130/60,
		SpreadAddMax = 20,
		
		SpreadDecay_Start = 10,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 0.93,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.85,
		Speed_Firing = 0.85,

		Features = "firearm",
	}

	WEAPONS["aa12"] = {
		Name = "AA-12",
		Description = "Magazine fed powerhouse.",
		Type = "shotgun",

		WModel = "models/weapons/w_shot_br99.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.5 },

		Sound_Fire = "AA12.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "AA12.MagOut",
		Sound_MagIn = "AA12.MagIn",

		Delay = (60/180),
		Firemodes = FIREMODE_AUTO,
		Ammo = 8,
		Damage = 8,
		Pellets = 8,
		Spread = 250/60,
		SpreadAdd = 150/60,
		SpreadAddMax = 20,
		
		SpreadDecay_Start = 700/60,
		SpreadDecay_End = 30,
		SpreadDecay_RampTime = 1,

		Reload_MagOut = 0.5,
		Reload_MagIn = 1.5,
		Reload_MagIn_Bonus1 = 1.2,
		Reload_MagIn_Bonus2 = 1.2+0.1,

		Speed_Move = 0.92,
		Speed_Aiming = 0.92,
		Speed_Reloading = 0.5,
		Speed_Firing = 0.334,
		Speed_FiringTime = 0.5,

		Features = "firearm",
	}

end

do -- Rifles

	WEAPONS["fnc"] = {
		Name = "FNC PARA",
		Description = "Run of the mill automatic assault rifle.",
		Type = "rifle",

		Icon = Material( "benny/weapons/fnc.png", "smooth" ),
		WModel = "models/weapons/w_rif_ar556.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "FNC.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "FNC.MagOut",
		Sound_MagIn = "FNC.MagIn",
		Sound_Cock = "FNC.Cock",

		Delay = (60/700),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 30,
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

		Features = "firearm",
	}

	WEAPONS["qbz"] = {
		Name = "QBZ-95",
		Description = "Bullpup assault rifle. Low profile, great in close quarters.",
		Type = "rifle",

		Icon = Material( "benny/weapons/fnc.png", "smooth" ),
		WModel = "models/weapons/w_rif_bakm.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "QBBLSW.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "FNC.MagOut",
		Sound_MagIn = "FNC.MagIn",
		Sound_Cock = "FNC.Cock",

		Delay = (60/800),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 30,
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

		Features = "firearm",
	}

	WEAPONS["m16a2"] = {
		Name = "M16A2",
		Description = "Burst-fire assault rifle. Precise and effective at range.",
		Type = "rifle",

		Icon = Material( "benny/weapons/m16a2.png", "smooth" ),
		WModel = "models/weapons/w_rif_m16a2.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "M16A2.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "M16A2.MagOut",
		Sound_MagIn = "M16A2.MagIn",
		Sound_Cock = "M16A2.Cock",

		Delay = (60/700),
		Firemodes = {
			{ Mode = 3 },
			{ Mode = 1 },
		},
		Ammo = 30,
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

		Features = "firearm",
	}

end

do -- Sniper rifles

	WEAPONS["barrett"] = {
		Name = "BARRETT .50c",
		Description = "Semi-automatic .50 slinger. Turns people into slushie!",
		Type = "sniper",

		Icon = Material( "benny/weapons/m16a2.png", "smooth" ),
		WModel = "models/weapons/w_snip_awp.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.1 },

		Sound_Fire = "Barrett.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "Barrett.MagOut",
		Sound_MagIn = "Barrett.MagIn",
		Sound_Cock = "Barrett.Cock",
		
		ShootHolsterTime = 1,

		Delay = (60/140),
		Firemodes = FIREMODE_SEMI,
		Ammo = 5,
		Damage = 99,
		Spread = 5/60,
		SpreadAdd = 9,
		SpreadAddMax = 18,
		
		SpreadDecay_Start = 4,
		SpreadDecay_End = 22,
		SpreadDecay_RampTime = 1,

		Reload_MagOut = 0.5,
		Reload_MagIn = 1.5,
		Reload_MagIn_Bonus1 = 1.0,
		Reload_MagIn_Bonus2 = 1.0+0.1,

		Speed_Move = 0.75,
		Speed_Aiming = 0.75,
		Speed_Reloading = 0.5,
		Speed_Firing = 0.334,
		Speed_FiringTime = 1,

		Features = "firearm",
	}

end

do -- Machine guns

	WEAPONS["stoner63"] = {
		Name = "STONER 63",
		Description = "Box-fed light machine gun that maintains mid-range authority.",
		Type = "machinegun",
		
		WModel = "models/weapons/w_mach_hk21e.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.3 },

		Sound_Fire = "Stoner63.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "M16A2.MagOut",
		Sound_MagIn = "M16A2.MagIn",
		
		Delay = (60/650),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 75,
		Damage = 32,
		Spread = 26/60,
		SpreadAdd = 22/60,
		SpreadAddMax = 10,
		
		SpreadDecay_Start = 4,
		SpreadDecay_End = 36,
		SpreadDecay_RampTime = 0.6,

		Speed_Move = 0.8,
		Speed_Aiming = 0.75,
		Speed_Reloading = 0.5,
		Speed_Firing = 0.334,

		Features = "firearm",
	}

	WEAPONS["qbblsw"] = {
		Name = "QBB-LSW-42",
		Description = "Bullpup mag-fed light machine gun that excels in close quarters.",
		Type = "machinegun",
		
		WModel = "models/weapons/w_mach_mg36.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.3 },

		Sound_Fire = "QBBLSW.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "M16A2.MagOut",
		Sound_MagIn = "M16A2.MagIn",
		
		Delay = (60/850),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 60,
		Damage = 29,
		Spread = 36/60,
		SpreadAdd = 33/60,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 6,
		SpreadDecay_End = 36,
		SpreadDecay_RampTime = 0.4,

		Speed_Move = 0.8,
		Speed_Aiming = 0.8,
		Speed_Reloading = 0.75,
		Speed_Firing = 0.334,

		Features = "firearm",
	}

end

do -- Grenades, nothing here is guaranteed.

	local function GrenadeFire( self, data, class, hand )
		local p = self:GetOwner()
		if self:GetGrenadeDown() then
			return true
		end
		if self:bGetHolsterTime( hand ) > 0 then
			return true
		end

		self:SetGrenadeDown( true )
		self:SetGrenadeDownStart( CurTime() )

		return true
	end

	local function GrenadeReload( self, data )
		return true
	end

	local function GrenadeCreate( self, data )
		-- PROTO: See to getting this done better. Maybe it's spawned while priming the nade for low CL-SV/phys delay?
		local p = self:GetOwner()
		local class = WeaponGet(data.Class)
		local GENT = ents.Create( class.GrenadeEnt )
		GENT:SetOwner( p )
		local ang = p:EyeAngles()
		ang.p = ang.p - 5
		GENT:SetPos( p:EyePos() + (ang:Forward()*16) )
		GENT:SetAngles( ang + Angle( 0, 0, -90 ) )
		GENT.Fuse = self:GetGrenadeDownStart() + class.GrenadeFuse
		GENT:Spawn()

		local velocity = ang:Forward() * 1500
		velocity:Mul( Lerp( math.TimeFraction( 90, 0, ang.p ), 0, 1 ) )
		-- velocity:Add( p:EyeAngles():Up() * 500 * Lerp( math.TimeFraction( 0, -90, p:EyeAngles().p ), 0, 1 ) )

		GENT:GetPhysicsObject():SetVelocity( velocity )
	end

	local function GrenadeThrow( self, data )
		local p = self:GetOwner()
		local class = WeaponGet(data.Class)
		self:SetGrenadeDown( false )
		-- TEMP: Do this right!
		if !class.GrenadeCharge then self:SetGrenadeDownStart( CurTime() ) end
		--
		local hand = (self:bWepTable( true ) and self:bWepTable( true ).Class == data.Class) or false
		self:TPFire( hand )
		if SERVER then GrenadeCreate( self, data ) end
		local id = self:bGetInvID( hand )
		self:BHolster( hand )

		if SERVER or (CLIENT and IsFirstTimePredicted()) then
			p:INV_Discard( id )
		end

		-- local subsequent = p:INV_Find( data.Class )[1]
		-- if subsequent then
		-- 	self:BDeploy( hand, subsequent )
		-- end
	end

	local function GrenadeThink( self, data, class, hand )
		local p = self:GetOwner()
		local class = WeaponGet(data.Class)
		if self:GetGrenadeDown() then
			if true or ( CurTime() >= (self:GetGrenadeDownStart() + class.GrenadeFuse) ) then
				GrenadeThrow( self, data )
			end
		end
		return true
	end

	local function GrenadeHolster( self, data )
		if self:GetGrenadeDown() then
			GrenadeThrow( self, data )
		end
		return true
	end

	WEAPONS["g_frag"] = {
		Name = "FRAG GRENADE",
		Description = "Pull the pin and throw it the hell away!",
		Type = "grenade",

		Custom_Fire = GrenadeFire,
		Custom_Reload = GrenadeReload,
		Custom_Think = GrenadeThink,
		Custom_Holster = GrenadeHolster,
		GrenadeEnt = "benny_grenade_frag",
		GrenadeFuse = 4,
		GrenadeCharge = true,
		
		WModel = "models/weapons/w_eq_fraggrenade.mdl",
		HoldType = "grenade",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

		Features = "grenade",
	}

	WEAPONS["g_semtex"] = {
		Name = "SEMTEX GRENADE",
		Description = "Long, audible fuse, but sticks to whatever it touches.",
		Type = "grenade",

		Custom_Fire = GrenadeFire,
		Custom_Reload = GrenadeReload,
		Custom_Think = GrenadeThink,
		Custom_Holster = GrenadeHolster,
		GrenadeEnt = "benny_grenade_semtex",
		GrenadeFuse = 4,
		GrenadeCharge = true,
		
		WModel = "models/weapons/w_eq_flashbang.mdl",
		HoldType = "grenade",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

		Features = "grenade",
	}

	WEAPONS["g_molotov"] = {
		Name = "MOLOTOV COCKTAIL",
		Description = "Alcoholic bottle of flame!",
		Type = "grenade",

		Custom_Fire = GrenadeFire,
		Custom_Reload = GrenadeReload,
		Custom_Think = GrenadeThink,
		Custom_Holster = GrenadeHolster,
		GrenadeEnt = "benny_grenade_molotov",
		GrenadeFuse = 4,
		GrenadeCharge = true,
		
		WModel = "models/weapons/w_eq_flashbang.mdl",
		HoldType = "grenade",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

		Features = "grenade",
	}

	WEAPONS["g_tknife"] = {
		Name = "THROWING KNIFE",
		Description = "Lightweight knife to throw and pick back up.",
		Type = "grenade",

		Custom_Fire = GrenadeFire,
		Custom_Reload = GrenadeReload,
		Custom_Think = GrenadeThink,
		Custom_Holster = GrenadeHolster,
		GrenadeEnt = "benny_grenade_tknife",
		GrenadeFuse = 4,
		GrenadeCharge = true,
		
		WModel = "models/weapons/w_eq_flashbang.mdl",
		HoldType = "grenade",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

		Features = "grenade",
	}

	WEAPONS["g_smoke"] = {
		Name = "SMOKE GRENADE",
		Description = "Smoke bomb used to conceal a position, and makes enemies cough.",
		Type = "grenade",

		Custom_Fire = GrenadeFire,
		Custom_Reload = GrenadeReload,
		Custom_Think = GrenadeThink,
		Custom_Holster = GrenadeHolster,
		GrenadeEnt = "benny_grenade_smoke",
		GrenadeFuse = 4,
		GrenadeCharge = true,
		
		WModel = "models/weapons/w_eq_flashbang.mdl",
		HoldType = "grenade",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

		Features = "grenade",
	}

	WEAPONS["g_flashbang"] = {
		Name = "FLASHBANG",
		Description = "Stun grenade that gives off a bright flash and a loud 'bang'.",
		Type = "grenade",

		Custom_Fire = GrenadeFire,
		Custom_Reload = GrenadeReload,
		Custom_Think = GrenadeThink,
		Custom_Holster = GrenadeHolster,
		GrenadeEnt = "benny_grenade_flashbang",
		GrenadeFuse = 2,
		GrenadeCharge = false,
		
		WModel = "models/weapons/w_eq_flashbang.mdl",
		HoldType = "grenade",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

		Features = "grenade",
	}

	WEAPONS["g_prox"] = {
		Name = "PROXIMITY MINE",
		Description = "Mine that bounces into the air.",
		Type = "grenade",

		Custom_Fire = GrenadeFire,
		Custom_Reload = GrenadeReload,
		Custom_Think = GrenadeThink,
		Custom_Holster = GrenadeHolster,
		GrenadeEnt = "benny_grenade_prox",
		GrenadeFuse = 4,
		GrenadeCharge = true,
		
		WModel = "models/weapons/w_eq_flashbang.mdl",
		HoldType = "grenade",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

		Features = "grenade",
	}

end

do -- Equipment, nothing here is guaranteed.

	WEAPONS["e_medkit"] = {
		Name = "MEDKIT",
		Description = "Station that regenerates a portion of health.",
		Type = "equipment",
		
		WModel = "models/weapons/w_eq_flashbang.mdl",

		Features = "grenade",
	}

	WEAPONS["e_ammo"] = {
		Name = "AMMO CRATE",
		Description = "Station that replenishes ammo.",
		Type = "equipment",
		
		WModel = "models/weapons/w_eq_flashbang.mdl",

		Features = "grenade",
	}

end

-- Ammo generator

for class, data in SortedPairs( WEAPONS ) do
	if data.Features == "firearm" then
		WEAPONS["mag_" .. class] = {
			Name = "MAG: " .. WEAPONS[class].Name,
			Description = "Magazine for the " .. WEAPONS[class].Name .. ".",
			Type = "magazine",

			WModel = "models/weapons/w_pist_glock18.mdl",
			HoldType = "slam",

			Ammo = WEAPONS[class].Ammo,

			Features = "magazine",
		}
	end
end