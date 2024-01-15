
--[[



	WEAPONS["m92"] = {
		Name = "M92FS",
		Description = "Accurate pistol, but low caliber won't do much against armor.",
		Type = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_pist_elite_single.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "M92.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_Reload = "USP.Reload",
		Sound_MagOut = "USP.MagOut",
		Sound_MagIn = "USP.MagIn",

		Delay = (60/400),
		Firemodes = FIREMODE_SEMI,
		Ammo = 15,
		Damage = 30,

		Features = "firearm",
	}

	WEAPONS["p226"] = {
		Name = "P226",
		Description = "Special forces pistol in fast .357 ammo.",
		Type = "pistol",

		Icon = Material( "benny/weapons/mk23.png", "smooth" ),
		WModel = "models/weapons/w_pist_p228.mdl",
		HoldType = "revolver",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL, 0.2 },
		GestureDraw = { ACT_HL2MP_GESTURE_RELOAD_REVOLVER, 0.8 },

		Sound_Fire = "P226.Fire",
		Sound_DryFire = "Common.Dryfire.Pistol",
		Sound_Reload = "USP.Reload",
		Sound_MagOut = "P226.MagOut",
		Sound_MagIn = "P226.MagIn",

		Delay = (60/350),
		Firemodes = FIREMODE_SEMI,
		Ammo = 13,
		Damage = 30,

		Features = "firearm",
	}

	WEAPONS["cqb70"] = {
		Name = "CS-70",
		Description = "meow",
		Type = "shotgun",

		WModel = "models/weapons/w_shot_cs3.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.5 },

		Sound_Fire = "AA12.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "AA12.MagOut",
		Sound_MagIn = "AA12.MagIn",

		Delay = (60/120),
		Firemodes = FIREMODE_SEMI,
		Ammo = 4,
		Damage = 10,
		Pellets = 8,
		Spread = 150/60,

		Features = "firearm",
	}

	WEAPONS["m12ak"] = {
		Name = "M12AK",
		Description = "meow",
		Type = "shotgun",

		WModel = "models/weapons/w_shot_saiga.mdl",
		HoldType = "rpg",
		GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, 0.5 },

		Sound_Fire = "AA12.Fire",
		Sound_DryFire = "Common.Dryfire.Rifle",
		Sound_MagOut = "AA12.MagOut",
		Sound_MagIn = "AA12.MagIn",

		Delay = (60/160),
		Firemodes = FIREMODE_SEMI,
		Ammo = 5,
		Damage = 10,
		Pellets = 8,
		Spread = 150/60,

		Features = "firearm",
	}

WEAPONS["g_gas"] = {
	Name = "GAS GRENADE",
	Description = "Short burst of gas that slows and disorient targets.",
	Type = "grenade",

	Custom_Fire = GrenadeFire,
	Custom_Reload = GrenadeReload,
	Custom_Think = GrenadeThink,
	Custom_Holster = GrenadeHolster,
	GrenadeEnt = "b-gr_gas",
	GrenadeFuse = 4,
	GrenadeCharge = true,
	
	WModel = "models/weapons/w_eq_flashbang.mdl",
	HoldType = "grenade",
	GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

	Features = "grenade",
}

WEAPONS["g_claymore"] = {
	Name = "CLAYMORE",
	Description = "Mine that shoots shrapnel in a cone.",
	Type = "grenade",

	Custom_Fire = GrenadeFire,
	Custom_Reload = GrenadeReload,
	Custom_Think = GrenadeThink,
	Custom_Holster = GrenadeHolster,
	GrenadeEnt = "b-gr_claymore",
	GrenadeFuse = 4,
	GrenadeCharge = true,
	
	WModel = "models/weapons/w_eq_flashbang.mdl",
	HoldType = "grenade",
	GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

	Features = "grenade",
}

WEAPONS["g_scrambler"] = {
	Name = "SCRAMBLER",
	Description = "Disrupts enemy radar based on proximity.",
	Type = "grenade",

	Custom_Fire = GrenadeFire,
	Custom_Reload = GrenadeReload,
	Custom_Think = GrenadeThink,
	Custom_Holster = GrenadeHolster,
	GrenadeEnt = "b-gr_scrambler",
	GrenadeFuse = 4,
	GrenadeCharge = true,
	
	WModel = "models/weapons/w_eq_flashbang.mdl",
	HoldType = "grenade",
	GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

	Features = "grenade",
}

WEAPONS["g_emp"] = {
	Name = "EMP NADE",
	Description = "Disrupts enemy equipment based on proximity.",
	Type = "grenade",

	Custom_Fire = GrenadeFire,
	Custom_Reload = GrenadeReload,
	Custom_Think = GrenadeThink,
	Custom_Holster = GrenadeHolster,
	GrenadeEnt = "b-gr_emp",
	GrenadeFuse = 4,
	GrenadeCharge = true,
	
	WModel = "models/weapons/w_eq_flashbang.mdl",
	HoldType = "grenade",
	GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

	Features = "grenade",
}

WEAPONS["g_shockcharge"] = {
	Name = "SHOCK CHARGE",
	Description = "Charge that stuns and forces enemies to fire their weapons.",
	Type = "grenade",

	Custom_Fire = GrenadeFire,
	Custom_Reload = GrenadeReload,
	Custom_Think = GrenadeThink,
	Custom_Holster = GrenadeHolster,
	GrenadeEnt = "b-gr_shockcharge",
	GrenadeFuse = 4,
	GrenadeCharge = true,
	
	WModel = "models/weapons/w_eq_flashbang.mdl",
	HoldType = "grenade",
	GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

	Features = "grenade",
}

WEAPONS["g_thermobaric"] = {
	Name = "THERMOBARIC GRENADE",
	Description = "Burns through armor.",
	Type = "grenade",

	Custom_Fire = GrenadeFire,
	Custom_Reload = GrenadeReload,
	Custom_Think = GrenadeThink,
	Custom_Holster = GrenadeHolster,
	GrenadeEnt = "b-gr_thermobaric",
	GrenadeFuse = 4,
	GrenadeCharge = true,
	
	WModel = "models/weapons/w_eq_flashbang.mdl",
	HoldType = "grenade",
	GestureFire = { ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, 0 },

	Features = "grenade",
}



WEAPONS["e_tacinsertion"] = {
	Name = "TACTICAL INSERTION",
	Description = "Flare that changes your deployment location.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_cover"] = {
	Name = "DEPLOYABLE COVER",
	Description = ".",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_ddos"] = {
	Name = "DDOS",
	Description = ".",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_trophysystem"] = {
	Name = "TROPHY SYSTEM",
	Description = "Disrupts enemy equipment.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_portableradar"] = {
	Name = "PORTABLE RADAR",
	Description = "Detects nearby enemies based on proximity.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_cameraspike"] = {
	Name = "CAMERA SPIKE",
	Description = "Mountable camera that gives you a live video feed.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_recondrone"] = {
	Name = "RECON DRONE",
	Description = "Pilotable hovering recon drone that automatically marks enemies.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_gasdrone"] = {
	Name = "GAS DRONE",
	Description = "Drone that dispenses toxic gas onto an area.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_suppressionmine"] = {
	Name = "SUPPRESSION MINE",
	Description = "Mine that detonates to dispense hard-to-see sleeping gas.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

WEAPONS["e_antiarmor"] = {
	Name = "ANTI-ARMOR ROUNDS",
	Description = "Ammo crate that dispenses armor to disable vehicles.",
	Type = "equipment",
	
	WModel = "models/weapons/w_eq_flashbang.mdl",

	Features = "grenade",
}

]]