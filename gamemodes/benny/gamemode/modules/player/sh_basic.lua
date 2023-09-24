
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_benny" )
	ply:SetModel( "models/player/combine_super_soldier.mdl" )
	ply:SetPlayerColor( Vector( 0.275, 0.2, 0.145 ) )
	ply:Give( "benny" )
end

if SERVER then
	util.AddNetworkString( "benny_sendinv" )
end

concommand.Add("benny_debug_give", function(ply, cmd, args)
	assert(SERVER, "not server")
	-- PROTO: Check for the correct 'benny' weapon.
	local ply = Entity( args[1] )
	local wep = ply:GetActiveWeapon()
	local inv = ply:INV_Get()
	local str = UUID_generate()

	local class = WEAPONS[args[3]]

	local item = {
		Class = args[3],
		Ammo = class.Ammo,
	}

	inv[str] = item

	-- PROTO: WriteTable.
	net.Start( "benny_sendinv" )
		net.WriteString( str )
		net.WriteTable( item )
	net.Send( ply )

	local slot = tonumber(args[2])

	if slot == 1 then
		wep:SetWep1( str )
		wep:SetClip1( class.Ammo )
	elseif slot == 2 then
		wep:SetWep2( str )
		wep:SetClip2( class.Ammo )
	else
		
	end
end)

if CLIENT then
	net.Receive( "benny_sendinv", function( len, ply )
		assert(CLIENT, "not client")
		local ply = LocalPlayer()
		assert(IsValid( ply ), "ply is invalid?")
		ply:INV_Get()[net.ReadString()] = net.ReadTable()
	end)
end

CAPTIONS = {
	["1911.Fire"] = {
		Name = "Cobra .45",
		Color = color_white,
		Text = "[Cobra .45 fire]",
		TypeTime = 0.1,
		LifeTime = 0.5,
	},
	["1911.Reload"] = {
		Name = "Cobra .45",
		Color = color_white,
		Text = "[Cobra .45 reload]",
		TypeTime = 0.1,
		LifeTime = 0.5,
	},
}

-- CAPTIONS["en-us"] = {}
-- CAPTIONS = CAPTIONS["en-us"]

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
	local tagt = SOUNDS[tag]
	if !tagt then MsgC( screwup, "Invalid sound " .. tag .. "\n" ) return end
	local path, sndlevel, pitch, volume, channel = tagt.path, tagt.sndlevel, tagt.pitch, tagt.volume, tagt.channel
	if istable( path ) then
		path = path[math.Round(util.SharedRandom( "B_Sound", 1, #path ))]
	end
	ent:EmitSound( path, sndlevel, pitch, volume, channel )
	if CLIENT then
		if CAPTIONS[tag] then
			local capt = CAPTIONS[tag]
			AddCaption( capt.Name, capt.Color, capt.Text, capt.TypeTime, capt.LifeTime )
		else
			MsgC( screwup, "No caption defined for " .. tag .. "\n" )
		end
	end
end