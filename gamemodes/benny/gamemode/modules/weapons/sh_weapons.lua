

do -- Sound definitions

	AddSound( "Anaconda.Fire", {
		"benny/weapons/anaconda/01.ogg",
		"benny/weapons/anaconda/02.ogg",
		"benny/weapons/anaconda/03.ogg",
	}, 140, 100, 0.5, CHAN_STATIC )

	AddSound( "Anaconda.MagOut", "benny/weapons/anaconda/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Anaconda.MagIn", "benny/weapons/anaconda/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Deagle.Cock", "benny/weapons/deagle/cock.ogg", 70, 100, 0.5, CHAN_STATIC )

	AddSound( "Common.Unload", "benny/weapons/unload.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Dryfire.Pistol", "benny/weapons/common/06-13.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Dryfire.Rifle", "benny/weapons/common/06-12.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Deploy", "benny/weapons/common/magpouch.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.Holster", "benny/weapons/common/magpouchin.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.NoAmmo", "benny/weapons/noammo.ogg", 70, 100, 0.5, CHAN_STATIC )
	AddSound( "Common.ReloadFail", "benny/hud/reloadfail.ogg", 70, 100, 0.1, CHAN_STATIC )

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

		Func_Attack2 = function( self, hand )
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
		end,
	})

	ItemDef("base_melee", {
		Name = "Base Melee",
		Category = "base",
		Base = "base",
		Description = "Base for melee weapons",
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
		Delay = 60/600,

		Spread = 0,
		SpreadAdd = 0,
		SpreadAddMax = 1,
		
		SpreadDecay_Start = 1,
		SpreadDecay_End = 2,
		SpreadDecay_RampTime = 1,

		Func_Attack = function( self, hand )
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

do -- Pistols
	ItemDef("deagle", {
		Name = "DEAGLE",
		Description = "Autoloading .50 caliber pistol.",
		Base = "base_firearm",
		Category = "pistol",

		WModel = "models/weapons/w_pist_deagle.mdl",
		HoldType = "revolver",

		Sound_Fire = "Anaconda.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_MagOut = "Anaconda.MagOut",
		Sound_MagIn = "Anaconda.MagIn",
		Sound_Cock = "Deagle.Cock",

		--
		AmmoStd = 7,
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

	ItemDef("mag_deagle", {
		Name = "MAG: DEAGLE 7-rnd",
		Base = "base_magazine",

		Ammo = 7,
	})


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