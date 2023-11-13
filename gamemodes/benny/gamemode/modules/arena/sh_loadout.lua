
-- Benny quirk system

PERKS = {}

CAT_MENTAL = 1
CAT_PHYSICAL = 2
CAT_TRAINING = 3
CAT_OPERATIONAL = 4

PERKS[CAT_MENTAL] = {}
PERKS[CAT_PHYSICAL] = {}
PERKS[CAT_TRAINING] = {}
PERKS[CAT_OPERATIONAL] = {}

PERKS[CAT_MENTAL]["overprepared"]			= 1 -- Magazines & grenades take less inventory space
PERKS[CAT_MENTAL]["resilience"]				= 1 -- Near immunity to fall damage
PERKS[CAT_MENTAL]["paranoid"]				= 2 -- Indicator when being targeted from outside your FoV.
PERKS[CAT_MENTAL]["stoic"]					= 2 -- Flinch less from damage.
PERKS[CAT_MENTAL]["bloodthirsty"]			= 2 -- Instantly regenerate health from melee and thrown kills
PERKS[CAT_MENTAL]["relentless"]				= 3 -- Faster melee swings on a hit.

PERKS[CAT_PHYSICAL]["sling"]				= 1 -- Hipfire accuracy increase
PERKS[CAT_PHYSICAL]["armpadding"]			= 2 -- No health damage when blocking blunt melee, but stamina damage still applies
PERKS[CAT_PHYSICAL]["stabkevlar"]			= 2 -- Half health damage when blocking sharp melee, but stamina damage still applies
PERKS[CAT_PHYSICAL]["tacticalgloves"]		= 2 -- Switch weapons faster
PERKS[CAT_PHYSICAL]["platecarrier"]			= 3 -- More inventory slots (+2?)
PERKS[CAT_PHYSICAL]["lightweight"]			= 3 -- Aim down sights faster.

PERKS[CAT_TRAINING]["freerunner"]			= 1 -- Faster vaulting of kinds
PERKS[CAT_TRAINING]["legday"]				= 1 -- Higher vaulting
PERKS[CAT_TRAINING]["readyup"]				= 1 -- Weapon is ready faster after sprinting
PERKS[CAT_TRAINING]["hitman"]				= 2 -- Take down enemies without revealing their location
PERKS[CAT_TRAINING]["athletic"]				= 2 -- Infinite sprint
PERKS[CAT_TRAINING]["counters"]				= 3 -- Perfect blocks on melee damage stuns enemies.

PERKS[CAT_OPERATIONAL]["blindeye"]			= 1 -- Enemy electronics take much longer to spot you.
PERKS[CAT_OPERATIONAL]["scavenger"]			= 1 -- Replenish ammo from enemy corpses.
PERKS[CAT_OPERATIONAL]["deadsilence"]		= 2 -- Move almost quietly.
PERKS[CAT_OPERATIONAL]["blastresponse"]		= 2 -- Enemies damaged by explosions show up on radar.
PERKS[CAT_OPERATIONAL]["offthegrid"]		= 3 -- Don't show up on radar
PERKS[CAT_OPERATIONAL]["wiretap"]			= 3 -- Hack into enemy equipment