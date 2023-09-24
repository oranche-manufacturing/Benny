
-- Audio & caption system

CAPTIONS = {}
CAPTIONS["en-us"] = {}

CAPTIONS["en-us"]["1911.Fire"] = {
	Name = "Cobra .45",
	Color = color_white,
	Text = "[fire]",
	Bold = false,
	Italic = true,
	TypeTime = 0.1,
	LifeTime = 0.5,
}
CAPTIONS["en-us"]["1911.Reload"] = {
	Name = "Cobra .45",
	Color = color_white,
	Text = "[reload]",
	Bold = false,
	Italic = true,
	TypeTime = 0.1,
	LifeTime = 0.5,
}

CAPTIONS["en-us"]["Bizon.Fire"] = {
	Name = "Bizon",
	Color = color_white,
	Text = "[fire]",
	Bold = false,
	Italic = true,
	TypeTime = 0.1,
	LifeTime = 0.5,
}
CAPTIONS["en-us"]["Bizon.Reload"] = {
	Name = "Bizon",
	Color = color_white,
	Text = "[reload]",
	Bold = false,
	Italic = true,
	TypeTime = 0.1,
	LifeTime = 0.5,
}

CAPTIONS = CAPTIONS["en-us"]

SOUNDS = {}

function AddSound( name, path, sndlevel, pitch, volume, channel )
	SOUNDS[name] = {
		path = path,
		sndlevel = sndlevel or 70,
		pitch = pitch or 100,
		volume = volume or 1,
		channel = channel or CHAN_STATIC,
	}
end

local screwup = SERVER and Color(150, 255, 255) or Color(255, 200, 150)

function B_Sound( ent, tag )
	if !tag then return end
	local tagt = SOUNDS[tag]
	if !tagt then MsgC( screwup, "Invalid sound " .. tag .. "\n" ) return end
	local path, sndlevel, pitch, volume, channel = tagt.path, tagt.sndlevel, tagt.pitch, tagt.volume, tagt.channel
	if istable( path ) then
		path = path[math.Round(util.SharedRandom( "B_Sound", 1, #path ))]
	end
	ent:EmitSound( path, sndlevel, pitch, volume, channel )
	if CLIENT and IsFirstTimePredicted() then
		if CAPTIONS[tag] then
			local capt = CAPTIONS[tag]
			AddCaption( capt.Name, capt.Color, capt.Text, capt.TypeTime, capt.LifeTime )
		else
			MsgC( screwup, "No caption defined for " .. tag .. "\n" )
		end
	end
end