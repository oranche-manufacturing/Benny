
WEAPONS = {}

AddSound( "1911.Fire", {
	"benny/weapons/1911/01.ogg",
	"benny/weapons/1911/02.ogg",
	"benny/weapons/1911/03.ogg",
}, 140, 100, 0.5, CHAN_STATIC )

AddSound( "1911.Reload", "benny/weapons/1911/slidedrop.ogg", 140, 100, 0.5, CHAN_STATIC )

local wep = {}
WEAPONS["1911"] = wep
wep.Name = "COBRA .45"
wep.Description = "Hits hard. They don't make them like they used to! Low capacity."

wep.WModel = "models/weapons/w_pist_usp.mdl"
wep.Sound_Fire = "1911.Fire"
wep.Sound_Reload = "1911.Reload" -- placeholder

wep.Delay = (60/300)
wep.Ammo = 8
wep.Damage = 30

local wep = {}
WEAPONS["usp"] = wep
wep.Name = "USP .45"
wep.Description = "It works for hardasses around the world, it works for you. Higher capacity."

wep.WModel = "models/weapons/w_pist_usp.mdl"

wep.Delay = (60/300)
wep.Ammo = 12
wep.Damage = 30

local wep = {}
WEAPONS["glock"] = wep
wep.Name = "GLOCK-18"
wep.Description = "Superb precision but poor capacity."

wep.WModel = "models/weapons/w_pist_glock18.mdl"

wep.Delay = (60/800)
wep.Ammo = 17
wep.Damage = 18

local wep = {}
WEAPONS["nambu"] = wep
wep.Name = "NAMBU .38"
wep.Description = "Eastern revolver that hits as much as it costs. Low capacity."

wep.Delay = (60/180)
wep.Ammo = 6
wep.Damage = 26

local wep = {}
WEAPONS["anaconda"] = wep
wep.Name = "ANACONDA"
wep.Description = "Precise and kicks like a mule, but low capacity."

wep.Delay = (60/180)
wep.Ammo = 6
wep.Damage = 40

local wep = {}
WEAPONS["tmp"] = wep
wep.Name = "TMP"
wep.Description = "Precise."
wep.Delay = (60/800)
wep.Ammo = 15
wep.Damage = 18

local wep = {}
WEAPONS["mp7"] = wep
wep.Name = "MP7"
wep.Description = "Small, pistol-sized, and simple."

wep.Delay = (60/700)
wep.Ammo = 15
wep.Damage = 16

local wep = {}
WEAPONS["mp5k"] = wep
wep.Name = "MP5K"
wep.Description = "Quality manufacturing, but cumbersome."

wep.Delay = (60/700)
wep.Ammo = 15
wep.Damage = 18

local wep = {}
WEAPONS["mac11"] = wep
wep.Name = "MAC-11"
wep.Description = "More fit for combat in a phone booth."

wep.Delay = (60/800)
wep.Ammo = 16
wep.Damage = 16

local wep = {}
WEAPONS["bizon"] = wep
wep.Name = "BIZON"
wep.Description = "Unwieldy bullet storm."

wep.Delay = (60/600)
wep.Ammo = 40
wep.Damage = 16