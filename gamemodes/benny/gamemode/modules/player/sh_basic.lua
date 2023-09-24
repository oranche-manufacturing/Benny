
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