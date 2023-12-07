
-- Audio & caption system

CAPTIONS = {}
CAPTIONS["en-us"] = {}


function RegisterCaption( Name, Subject, Color, Text, TypeTime, LifeTime, Bold, Italic )
	CAPTIONS["en-us"][Name] = {
		Name = Subject,
		Color = Color,
		Text = Text,
		TypeTime = TypeTime,
		LifeTime = LifeTime,
		Bold = Bold,
		Italic = Italic,
	}
end

RegisterCaption("1911.Fire", "Cobra .45", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("1911.Reload", "Cobra .45", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("Bizon.Fire", "Bizon", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("Bizon.Reload", "Bizon", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("TMP.Fire", "TMP", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("TMP.Reload", "TMP", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("USP.Fire", "USP", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("USP.Reload", "USP", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("Glock.Fire", "Glock", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("Glock.Reload", "Glock", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("MP5K.Fire", "MP5K", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("MP5K.Reload", "MP5K", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("MAC11.Fire", "MAC11", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("MAC11.Reload", "MAC11", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("MP7.Fire", "MP7", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("MP7.Reload", "MP7", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("Anaconda.Fire", "Anaconda", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("Anaconda.Reload", "Anaconda", color_white, "[reload]", 0.1, 0.5, false, true )
RegisterCaption("Nambu.Fire", "Nambu", color_white, "[fire]", 0.1, 0.5, false, true )
RegisterCaption("Nambu.Reload", "Nambu", color_white, "[reload]", 0.1, 0.5, false, true )

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

AddSound( "Common.Deploy", "benny/weapons/common/06-07.ogg", 70, 100, 0.2, CHAN_STATIC )
AddSound( "Common.Holster", "benny/weapons/common/06-09.ogg", 70, 100, 0.2, CHAN_STATIC )
RegisterCaption("Common.Deploy", "DEBUG", color_white, "[deploy]", 0.1, 0.5, false, true )
RegisterCaption("Common.Holster", "DEBUG", color_white, "[holster]", 0.1, 0.5, false, true )

CAPTIONS = CAPTIONS["en-us"]