
FIREMODE_AUTO = {
	{ Mode = math.huge },
}
FIREMODE_AUTOSEMI = {
	{ Mode = math.huge },
	{ Mode = 1 },
}
FIREMODE_SEMI = {
	{ Mode = 1 },
}
WEAPONS = {}

function WeaponGet( classname )
	return WEAPONS[ classname ]
end

do -- Sound definitions

	AddSound( "1911.Fire", {
		"benny/weapons/1911/01.ogg",
		"benny/weapons/1911/02.ogg",
		"benny/weapons/1911/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "Bizon.Fire", {
		"benny/weapons/bizon/01.ogg",
		"benny/weapons/bizon/02.ogg",
		"benny/weapons/bizon/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "MP5K.Fire", {
		"benny/weapons/mp5k/01.ogg",
		"benny/weapons/mp5k/02.ogg",
		"benny/weapons/mp5k/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "MAC11.Fire", {
		"benny/weapons/mac11/01.ogg",
		"benny/weapons/mac11/02.ogg",
		"benny/weapons/mac11/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "MP7.Fire", {
		"benny/weapons/mp7/01.ogg",
		"benny/weapons/mp7/02.ogg",
		"benny/weapons/mp7/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "TMP.Fire", {
		"benny/weapons/tmp/01.ogg",
		"benny/weapons/tmp/02.ogg",
		"benny/weapons/tmp/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "Anaconda.Fire", {
		"benny/weapons/anaconda/01.ogg",
		"benny/weapons/anaconda/02.ogg",
		"benny/weapons/anaconda/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "Nambu.Fire", {
		"benny/weapons/nambu/01.ogg",
		"benny/weapons/nambu/02.ogg",
		"benny/weapons/nambu/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "USP.Fire", {
		"benny/weapons/usp/01.ogg",
		"benny/weapons/usp/02.ogg",
		"benny/weapons/usp/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "Glock.Fire", {
		"benny/weapons/glock/01.ogg",
		"benny/weapons/glock/02.ogg",
		"benny/weapons/glock/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "M92.Fire", {
		"benny/weapons/m92/01.ogg",
		"benny/weapons/m92/02.ogg",
		"benny/weapons/m92/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "P226.Fire", {
		"benny/weapons/p226/01.ogg",
		"benny/weapons/p226/02.ogg",
		"benny/weapons/p226/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "M16A2.Fire", {
		"benny/weapons/m16a2/01.ogg",
		"benny/weapons/m16a2/02.ogg",
		"benny/weapons/m16a2/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "FNC.Fire", {
		"benny/weapons/fnc/01.ogg",
		"benny/weapons/fnc/02.ogg",
		"benny/weapons/fnc/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "AA12.Fire", "benny/weapons/aa12/01.ogg", 140, 100, 0.5, CHAN_STATIC )

	AddSound( "SPAS12.Fire", {
		"benny/weapons/spas12/01.ogg",
		"benny/weapons/spas12/02.ogg",
		"benny/weapons/spas12/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "MP5K.MagOut", "benny/weapons/mp5k/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MP5K.MagIn", "benny/weapons/mp5k/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MAC11.MagOut", "benny/weapons/mac11/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MAC11.MagIn", "benny/weapons/mac11/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MP7.MagOut", "benny/weapons/mp7/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "MP7.MagIn", "benny/weapons/mp7/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "TMP.MagOut", "benny/weapons/tmp/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "TMP.MagIn", "benny/weapons/tmp/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Bizon.MagOut", "benny/weapons/bizon/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Bizon.MagIn", "benny/weapons/bizon/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Anaconda.MagOut", "benny/weapons/anaconda/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Anaconda.MagIn", "benny/weapons/anaconda/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Nambu.MagOut", "benny/weapons/nambu/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Nambu.MagIn", "benny/weapons/nambu/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "P226.MagOut", "benny/weapons/p226/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "P226.MagIn", "benny/weapons/p226/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "M92.MagOut", "benny/weapons/m92/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "M92.MagIn", "benny/weapons/m92/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "1911.MagOut", "benny/weapons/1911/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "1911.MagIn", "benny/weapons/1911/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "USP.MagOut", "benny/weapons/usp/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "USP.MagIn", "benny/weapons/usp/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Glock.MagOut", "benny/weapons/glock/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Glock.MagIn", "benny/weapons/glock/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "M16A2.MagOut", "benny/weapons/m16a2/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "M16A2.MagIn", "benny/weapons/m16a2/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "FNC.MagOut", "benny/weapons/fnc/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "FNC.MagIn", "benny/weapons/fnc/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "AA12.MagOut", "benny/weapons/aa12/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "AA12.MagIn", "benny/weapons/aa12/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "SPAS12.MagOut", {
		"benny/weapons/spas12/magout-01.ogg",
		"benny/weapons/spas12/magout-02.ogg",
		"benny/weapons/spas12/magout-03.ogg",
	}, 70, 100, 0.5, CHAN_STATIC )
	AddSound( "SPAS12.MagIn", "benny/weapons/spas12/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

	AddSound( "Common.Dryfire.Pistol", "benny/weapons/common/06-13.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Dryfire.Rifle", "benny/weapons/common/06-12.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.NoAmmo", "benny/weapons/noammo.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.ReloadFail", "benny/hud/reloadfail.ogg", 70, 100, 0.5, CHAN_STATIC )

end

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
				summon:Spawn()
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
		Description = "Developer development device",
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
			local tool = p:GetInfo( "benny_wep_toolgun" )
			if ToolGunTools[tool] then ToolGunTools[tool]( self, p, tr ) end
		
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
		Name = "DIRECTOR'S CAMERA",
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

do -- Melee

	WEAPONS["melee_bat"] = {
		Name = "BAT",
		Description = "Aluminum bat. Home run!",
		Type = "melee",

		WModel = "models/weapons/w_crowbar.mdl",
		HoldType = "melee2",

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Ammo = 0,
		Damage = 0,

		Features = "melee",
	}

	WEAPONS["melee_baton"] = {
		Name = "BATON",
		Description = "Weighty beating stick.",
		Type = "melee",

		WModel = "models/weapons/w_eq_tonfa.mdl",
		HoldType = "knife",

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Ammo = 0,
		Damage = 0,

		Features = "melee",
	}

	WEAPONS["melee_knife"] = {
		Name = "KNIFE",
		Description = "Makes for a great entrée and dessert.",
		Type = "melee",

		WModel = "models/weapons/w_knife_ct.mdl",
		HoldType = "knife",

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Ammo = 0,
		Damage = 0,

		Features = "melee",
	}

	WEAPONS["melee_machete"] = {
		Name = "MACHETE",
		Description = "Cut up foliage and people!",
		Type = "melee",

		WModel = "models/props_canal/mattpipe.mdl",
		HoldType = "melee2",

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Ammo = 0,
		Damage = 0,

		Features = "melee",
	}

end

do -- Handguns

	WEAPONS["1911"] = {
		Name = "COBRA .45",
		Description = "Hits hard. They don't make them like they used to!",
		Type = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_colt.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "1911.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_Reload = "1911.Reload",
		Sound_MagOut = "1911.MagOut",
		Sound_MagIn = "1911.MagIn",

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Ammo = 8,
		Damage = 30,
		Spread = 22/60,
		SpreadAdd = 0.5,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 1,
		Speed_Aiming = 0.95,
		Speed_Reloading = 1,
		Speed_Firing = 1,

		Features = "firearm",
	}

	WEAPONS["usp"] = {
		Name = "MK. 23",
		Description = "If it works for hardasses around the world, it'll work for you.",
		Type = "pistol",

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

		Delay = (60/300),
		Firemodes = FIREMODE_SEMI,
		Ammo = 12,
		Damage = 32,
		Spread = 15/60,
		SpreadAdd = 0.4,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 1,
		Speed_Aiming = 0.95,
		Speed_Reloading = 1,
		Speed_Firing = 1,

		Features = "firearm",
	}

	WEAPONS["glock"] = {
		Name = "GLOCK-18",
		Description = "Bullet storm. Lasts about a second or so, just like you!",
		Type = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_pist_glock18.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.25 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Glock.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Glock.MagOut",
		Sound_MagIn = "Glock.MagIn",

		Delay = (60/900),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 17,
		Damage = 22,
		Spread = 60/60,
		SpreadAdd = 0.8,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 1,
		Speed_Aiming = 0.95,
		Speed_Reloading = 0.95,
		Speed_Firing = 0.95,

		Features = "firearm",
	}

	WEAPONS["nambu"] = {
		Name = "NAMBU .38",
		Description = "Eastern revolver that hits as hard as it costs.",
		Type = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_pist_derringer.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.3 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Nambu.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Nambu.MagOut",
		Sound_MagIn = "Nambu.MagIn",

		Delay = (60/180),
		Firemodes = FIREMODE_SEMI,
		Ammo = 6,
		Damage = 36,
		Spread = 30/60,
		SpreadAdd = 1.5,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 3,
		SpreadDecay_End = 11,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 1,
		Speed_Aiming = 1,
		Speed_Reloading = 0.9,
		Speed_Firing = 0.95,

		Features = "firearm",
	}

	WEAPONS["anaconda"] = {
		Name = "ANACONDA",
		Description = "Precise and kicks like a mule.",
		Type = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_357.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.1 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "Anaconda.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Anaconda.MagOut",
		Sound_MagIn = "Anaconda.MagIn",

		Delay = (60/180),
		Firemodes = FIREMODE_SEMI,
		Ammo = 6,
		Damage = 55,
		Spread = 30/60,
		SpreadAdd = 6,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 6,
		SpreadDecay_End = 22,
		SpreadDecay_RampTime = 0.65,

		Speed_Move = 0.97,
		Speed_Aiming = 0.9,
		Speed_Reloading = 0.9,
		Speed_Firing = 0.95,

		Features = "firearm",
	}

	WEAPONS["deagle"] = {
		Name = "DEAGLE",
		Description = "Autoloading .50 caliber pistol.",
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

		Delay = (60/180),
		Firemodes = FIREMODE_SEMI,
		Ammo = 7,
		Damage = 47,
		Spread = 30/60,
		SpreadAdd = 4,
		SpreadAddMax = 15,
		
		SpreadDecay_Start = 8,
		SpreadDecay_End = 25,
		SpreadDecay_RampTime = 0.5,

		Speed_Move = 0.95,
		Speed_Aiming = 0.88,
		Speed_Reloading = 0.88,
		Speed_Firing = 0.93,

		Features = "firearm",
	}

end

do -- SMGs & PDWs

	WEAPONS["tmp"] = {
		Name = "TMP",
		Description = "Small, compact, and favored by private security.",
		Type = "smg",

		WModel = "models/weapons/w_smg_tmp_us.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "TMP.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "TMP.Reload",
		Sound_MagOut = "TMP.MagOut",
		Sound_MagIn = "TMP.MagIn",

		Delay = (60/650),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 15,
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

		Features = "firearm",
	}

	WEAPONS["mp7"] = {
		Name = "MP7",
		Description = "Small, pistol-sized, goes through kevlar like a knife.",
		Type = "smg",

		WModel = "models/weapons/w_smg1.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "MP7.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "MP7.Reload",
		Sound_MagOut = "MP7.MagOut",
		Sound_MagIn = "MP7.MagIn",

		Delay = (60/900),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 20,
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

		Features = "firearm",
	}

	WEAPONS["mp5k"] = {
		Name = "MP5K",
		Description = "Quality manufacturing, but a cumbersome reload.",
		Type = "smg",

		WModel = "models/weapons/w_smg_mp5k.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "MP5K.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "MP5K.Reload",
		Sound_MagOut = "MP5K.MagOut",
		Sound_MagIn = "MP5K.MagIn",

		Delay = (60/750),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 15,
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

		Features = "firearm",
	}

	WEAPONS["mac11"] = {
		Name = "MAC-11",
		Description = "More fit for combat in a phone booth.",
		Type = "smg",

		WModel = "models/weapons/w_smg_mac10.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.1 },

		Sound_Fire = "MAC11.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "MAC11.Reload",
		Sound_MagOut = "MAC11.MagOut",
		Sound_MagIn = "MAC11.MagIn",

		Delay = (60/1400),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 16,
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

		Features = "firearm",
	}

	WEAPONS["bizon"] = {
		Name = "BIZON",
		Description = "Unwieldy bullet storm.",
		Type = "smg",

		WModel = "models/weapons/w_smg_bizon.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.34 },

		Sound_Fire = "Bizon.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "Bizon.Reload",
		Sound_MagOut = "Bizon.MagOut",
		Sound_MagIn = "Bizon.MagIn",

		Delay = (60/700),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 40,
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

		Features = "firearm",
	}

	WEAPONS["chicom"] = {
		Name = "QCW-CQB-21",
		Description = "Subsonic bullpup SMG.",
		Type = "smg",

		WModel = "models/weapons/w_rif_famas.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, 0.34 },

		Sound_Fire = "M92.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_Reload = "Bizon.Reload",
		Sound_MagOut = "Bizon.MagOut",
		Sound_MagIn = "Bizon.MagIn",

		Delay = (60/1050),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 36,
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

		Features = "firearm",
	}

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

		Speed_Move = 0.85,
		Speed_Aiming = 0.85,
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

		Speed_Move = 0.9,
		Speed_Aiming = 0.9,
		Speed_Reloading = 0.85,
		Speed_Firing = 0.75,

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

		Speed_Move = 0.82,
		Speed_Aiming = 0.82,
		Speed_Reloading = 0.5,
		Speed_Firing = 0.334,

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

		Delay = (60/600),
		Firemodes = FIREMODE_AUTOSEMI,
		Ammo = 30,
		Damage = 30,
		Spread = 30/60,
		SpreadAdd = 22/60,
		SpreadAddMax = 10,
		
		SpreadDecay_Start = 0,
		SpreadDecay_End = 12,
		SpreadDecay_RampTime = 0.2,

		Speed_Move = 0.9,
		Speed_Aiming = 0.9,
		Speed_Reloading = 0.9,
		Speed_Firing = 0.9,

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

		Sound_Fire = "FNC.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "FNC.MagOut",
		Sound_MagIn = "FNC.MagIn",

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

		Speed_Move = 0.9,
		Speed_Aiming = 0.935,
		Speed_Reloading = 0.935,
		Speed_Firing = 0.935,

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

		Speed_Move = 0.9,
		Speed_Aiming = 0.85,
		Speed_Reloading = 0.9,
		Speed_Firing = 0.85,

		Features = "firearm",
	}

end

do -- Sniper rifles

	WEAPONS["barrett"] = {
		Name = "BARRETT .50c",
		Description = "Semi-automatic .50 slinger. Turns people into slushie!",
		Type = "sniper",

		Icon = Material( "benny/weapons/m16a2.png", "smooth" ),
		WModel = "models/weapons/w_rif_m16a2.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.3 },

		Sound_Fire = "M16A2.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "M16A2.MagOut",
		Sound_MagIn = "M16A2.MagIn",

		Delay = (60/140),
		Firemodes = {
			{ Mode = 1 },
		},
		Ammo = 5,
		Damage = 99,
		Spread = 5/60,
		SpreadAdd = 9,
		SpreadAddMax = 18,
		
		SpreadDecay_Start = 4,
		SpreadDecay_End = 22,
		SpreadDecay_RampTime = 1,

		Speed_Move = 0.75,
		Speed_Aiming = 0.75,
		Speed_Reloading = 0.5,
		Speed_Firing = 0.334,

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

		Sound_Fire = "FNC.Fire",
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

		Sound_Fire = "FNC.Fire",
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

	local function GrenadeFire( self, data )
		local p = self:GetOwner()
		if self:GetGrenadeDown() then
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
		local hand = (self:BTable( true ) and self:BTable( true ).Class == data.Class) or false
		self:TPFire( hand )
		if SERVER then GrenadeCreate( self, data ) end
		local id = self:D_GetID( hand )
		self:BHolster( hand )

		if SERVER or (CLIENT and IsFirstTimePredicted()) then
			p:INV_Discard( id )
		end

		-- local subsequent = p:INV_Find( data.Class )[1]
		-- if subsequent then
		-- 	self:BDeploy( hand, subsequent )
		-- end
	end

	local function GrenadeThink( self, data )
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

for class, data in pairs( WEAPONS ) do
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