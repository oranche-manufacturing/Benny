
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
AddSound( "1911.MagOut", "benny/weapons/1911/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
AddSound( "1911.MagIn", "benny/weapons/1911/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
AddSound( "USP.MagOut", "benny/weapons/usp/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
AddSound( "USP.MagIn", "benny/weapons/usp/magin.ogg", 70, 100, 0.5, CHAN_STATIC )
AddSound( "Glock.MagOut", "benny/weapons/glock/magout.ogg", 70, 100, 0.5, CHAN_STATIC )
AddSound( "Glock.MagIn", "benny/weapons/glock/magin.ogg", 70, 100, 0.5, CHAN_STATIC )

AddSound( "Common.Dryfire.Pistol", "benny/weapons/common/06-13.ogg", 70, 100, 0.5, CHAN_STATIC )
AddSound( "Common.Dryfire.Rifle", "benny/weapons/common/06-12.ogg", 70, 100, 0.5, CHAN_STATIC )
AddSound( "Common.NoAmmo", "benny/weapons/noammo.ogg", 70, 100, 0.5, CHAN_STATIC )

local wep = {}
WEAPONS["1911"] = wep
wep.Name = "COBRA .45"
wep.Description = "Hits hard. They don't make them like they used to!"

wep.WModel = "models/weapons/w_pist_usp.mdl"
wep.Sound_Fire = "1911.Fire"
wep.Sound_DryFire = "Common.Dryfire.Pistol"
wep.Sound_Reload = "1911.Reload" -- placeholder
wep.Sound_MagOut = "1911.MagOut" -- placeholder
wep.Sound_MagIn = "1911.MagIn" -- placeholder

wep.Delay = (60/300)
wep.Firemodes = FIREMODE_SEMI
wep.Ammo = 8
wep.Damage = 30

local wep = {}
WEAPONS["usp"] = wep
wep.Name = "USP .45"
wep.Description = "If it works for hardasses around the world, it works for you."

wep.WModel = "models/weapons/w_pist_usp.mdl"
wep.Sound_Fire = "USP.Fire"
wep.Sound_DryFire = "Common.Dryfire.Pistol"
wep.Sound_Reload = "USP.Reload" -- placeholder
wep.Sound_MagOut = "USP.MagOut" -- placeholder
wep.Sound_MagIn = "USP.MagIn" -- placeholder

wep.Delay = (60/300)
wep.Firemodes = FIREMODE_SEMI
wep.Ammo = 12
wep.Damage = 30

local wep = {}
WEAPONS["glock"] = wep
wep.Name = "GLOCK-18"
wep.Description = "Bullet storm. Lasts about a second or so, just like you!"

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "Glock.Fire"
wep.Sound_DryFire = "Common.Dryfire.Pistol"
wep.Sound_MagOut = "Glock.MagOut" -- placeholder
wep.Sound_MagIn = "Glock.MagIn" -- placeholder

wep.Delay = (60/800)
wep.Firemodes = FIREMODE_AUTOSEMI
wep.Ammo = 17
wep.Damage = 18

local wep = {}
WEAPONS["nambu"] = wep
wep.Name = "NAMBU .38"
wep.Description = "Eastern revolver that hits as hard as it costs."

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "Nambu.Fire"
wep.Sound_DryFire = "Common.Dryfire.Pistol"
wep.Sound_MagOut = "Nambu.MagOut" -- placeholder
wep.Sound_MagIn = "Nambu.MagIn" -- placeholder

wep.Delay = (60/180)
wep.Firemodes = FIREMODE_SEMI
wep.Ammo = 6
wep.Damage = 26

local wep = {}
WEAPONS["anaconda"] = wep
wep.Name = "ANACONDA"
wep.Description = "Precise and kicks like a mule."

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "Anaconda.Fire"
wep.Sound_DryFire = "Common.Dryfire.Pistol"
wep.Sound_MagOut = "Anaconda.MagOut" -- placeholder
wep.Sound_MagIn = "Anaconda.MagIn" -- placeholder

wep.Delay = (60/180)
wep.Firemodes = FIREMODE_SEMI
wep.Ammo = 6
wep.Damage = 40

local wep = {}
WEAPONS["tmp"] = wep
wep.Name = "TMP"
wep.Description = "Precise and sharp, like a damn suit's pet."

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "TMP.Fire"
wep.Sound_DryFire = "Common.Dryfire.Rifle"
wep.Sound_Reload = "TMP.Reload" -- placeholder
wep.Sound_MagOut = "TMP.MagOut" -- placeholder
wep.Sound_MagIn = "TMP.MagIn" -- placeholder

wep.Delay = (60/700)
wep.Firemodes = FIREMODE_AUTOSEMI
wep.Ammo = 15
wep.Damage = 18

local wep = {}
WEAPONS["mp7"] = wep
wep.Name = "MP7"
wep.Description = "Small, pistol-sized, and simple."

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "MP7.Fire"
wep.Sound_DryFire = "Common.Dryfire.Rifle"
wep.Sound_Reload = "MP7.Reload" -- placeholder
wep.Sound_MagOut = "MP7.MagOut" -- placeholder
wep.Sound_MagIn = "MP7.MagIn" -- placeholder

wep.Delay = (60/700)
wep.Firemodes = FIREMODE_AUTOSEMI
wep.Ammo = 15
wep.Damage = 16

local wep = {}
WEAPONS["mp5k"] = wep
wep.Name = "MP5K"
wep.Description = "Quality manufacturing, but cumbersome."

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "MP5K.Fire"
wep.Sound_DryFire = "Common.Dryfire.Rifle"
wep.Sound_Reload = "MP5K.Reload" -- placeholder
wep.Sound_MagOut = "MP5K.MagOut" -- placeholder
wep.Sound_MagIn = "MP5K.MagIn" -- placeholder

wep.Delay = (60/700)
wep.Firemodes = FIREMODE_AUTOSEMI
wep.Ammo = 15
wep.Damage = 18

local wep = {}
WEAPONS["mac11"] = wep
wep.Name = "MAC-11"
wep.Description = "More fit for combat in a phone booth."

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "MAC11.Fire"
wep.Sound_DryFire = "Common.Dryfire.Rifle"
wep.Sound_Reload = "MAC11.Reload" -- placeholder
wep.Sound_MagOut = "MAC11.MagOut" -- placeholder
wep.Sound_MagIn = "MAC11.MagIn" -- placeholder

wep.Delay = (60/800)
wep.Firemodes = FIREMODE_AUTOSEMI
wep.Ammo = 16
wep.Damage = 16

local wep = {}
WEAPONS["bizon"] = wep
wep.Name = "BIZON"
wep.Description = "Unwieldy bullet storm."

wep.WModel = "models/weapons/w_pist_glock18.mdl"
wep.Sound_Fire = "Bizon.Fire"
wep.Sound_DryFire = "Common.Dryfire.Rifle"
wep.Sound_Reload = "Bizon.Reload" -- placeholder
wep.Sound_MagOut = "Bizon.MagOut" -- placeholder
wep.Sound_MagIn = "Bizon.MagIn" -- placeholder

wep.Delay = (60/600)
wep.Firemodes = FIREMODE_AUTOSEMI
wep.Ammo = 30
wep.Damage = 16