
if SERVER then
	util.AddNetworkString( "benny_syncinv" )
	util.AddNetworkString( "benny_sendinvitem" )
	util.AddNetworkString( "benny_discardinvitem" )
end

concommand.Add("benny_debug_give", function(ply, cmd, args)
	assert(SERVER, "not server")
	local inv = ply:INV_Get()
	local str = UUID_generate()

	local class = WeaponGet(args[1])

	assert(class, "Invalid Class.")

	local item = {
		Class = args[1],
		Acquisition = CurTime(),
	}

	if class.Features == "firearm" then
		item.Loaded = ""
	elseif class.Features == "magazine" then
		item.Ammo = class.Ammo
	end

	inv[str] = item

	-- PROTO: WriteTable.
	net.Start( "benny_sendinvitem" )
		net.WriteString( str )
		net.WriteTable( item )
	net.Send( ply )
end,
function(cmd, args)
	args = string.Trim(args:lower())
	local meow = {}
	for i, v in SortedPairs( WEAPONS ) do
		if string.lower(i):find(args) then
			table.insert( meow, cmd .. " " .. i )
		end
	end
	return meow
end, "arg 1: player ent index, arg 2: classname")

-- PROTO: Move this all into weapon code.
concommand.Add("benny_inv_equip", function( ply, cmd, args )
	local wep = ply:BennyCheck()
	if wep then
		local hand = args[2]!=nil and tobool(args[2])
		local id = args[1]
		local swap_or_replace = tobool(args[3])

		local L, R = true, false
		local curr_r = wep:D_GetID( false )
		local curr_l = wep:D_GetID( true )

		if hand == R then
			if curr_r == id then
				-- We already have this equipped
				return
			elseif swap_or_replace and curr_r != "" then
				-- We already have something equipped here, move it to the offhand
				wep:BDeploy( L, curr_r )
			elseif curr_l == id then
				-- You have the gun we want, snatched
				wep:BHolster( L )
			end
			wep:BDeploy( R, id )
		elseif hand == L then
			if curr_l == id then
				-- We already have this equipped
				return
			elseif swap_or_replace and curr_l != "" then
				-- We already have something equipped here, move it to the offhand
				wep:BDeploy( R, curr_l )
			elseif curr_r == id then
				-- You have the gun we want, snatched
				wep:BHolster( R )
			end
			wep:BDeploy( L, id )
		end
	end
end,
function(cmd, args)
	args = string.Trim(args:lower())
	local meow = {}
	for i, v in SortedPairs( Entity(1):INV_Get() ) do
		if string.lower(i):find(args) then
			table.insert( meow, cmd .. " " .. i )
		end
	end
	return meow
end, "arg 1: item id, arg 2 does offhand")

-- PROTO: Move this all into weapon code.
concommand.Add("benny_inv_holster", function( ply, cmd, args )
	local wep = ply:BennyCheck()
	if wep then
		if wep:D_GetID( false ) == args[1] then
			wep:BHolster( false )
		elseif wep:D_GetID( true ) == args[1] then
			wep:BHolster( true )
		end
	end
end)

concommand.Add("benny_inv_sync", function( ply, cmd, args )
	local inv = ply:INV_Get()

	-- PROTO: WriteTable.
	net.Start("benny_syncinv")
		net.WriteUInt( table.Count( inv ), 4 )
		for ID, Data in pairs( inv ) do
			net.WriteString( ID )
			net.WriteTable( Data )
		end
	net.Send( ply )
end)

concommand.Add("benny_inv_discard", function( ply, cmd, args )
	local inv = ply:INV_Get()
	local wep = ply:GetActiveWeapon()
	local item = inv[args[1]]
	-- PROTO: Check that this is the correct 'benny' weapon.
	assert( item, "That item doesn't exist. " .. tostring(item) )

	inv[args[1]] = nil
	net.Start( "benny_discardinvitem" )
		net.WriteString( args[1] )
	net.Send( ply )

	if wep:GetWep1() == args[1] then
		wep:SetWep1( "" )
		wep:SetWep1_Clip( "" )
		wep:SetClip1( 0 )
	end
	if wep:GetWep2() == args[1] then
		wep:SetWep2( "" )
		wep:SetWep2_Clip( "" )
		wep:SetClip2( 0 )
	end
end)

-- Network to client
if CLIENT then
	net.Receive( "benny_syncinv", function( len, ply )
		local ply = LocalPlayer()
		local inv = ply:INV_Get()

		table.Empty( inv )
		for i=1, net.ReadUInt( 4 ) do
			inv[net.ReadString()] = net.ReadTable()
		end
	end)
	net.Receive( "benny_sendinvitem", function( len, ply )
		local ply = LocalPlayer()
		ply:INV_Get()[net.ReadString()] = net.ReadTable()
	end)
	net.Receive( "benny_discardinvitem", function( len, ply )
		local ply = LocalPlayer()
		ply:INV_Get()[net.ReadString()] = nil
	end)
end

hook.Add( "PlayerDeathSound", "Benny_PlayerDeathSound", function( ply )
	return true -- we don't want the default sound!
end )

function GM:ShowHelp( ply )
	if SERVER then
		ply:SendLua( [[OpenSMenu()]] )
	end
end

function GM:ShowTeam( ply )
	if SERVER then
		ply:SendLua( [[OpenDeadeye()]] )
	end
end

function GM:ShowSpare1( ply )
	if SERVER then
		ply:ConCommand( "benny_gui_settings" )
	end
end

function GM:ShowSpare2( ply )
	if SERVER then
		ply:ConCommand( "benny_gui_spscore" )
	end
end