
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

	assert(class, "Invalid Class " .. tostring(class))

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

hook.Add( "PlayerDeathSound", "Benny_PlayerDeathSound", function( ply )
	return true -- we don't want the default sound!
end )

if CLIENT then
hook.Add( "PlayerButtonDown", "Benny_PlayerButtonDown_Dev", function( ply, button )
	local wep = ply:BennyCheck()

	if IsFirstTimePredicted() then
		if button == KEY_F1 then
			OpenSettingsMenu()
		elseif button == KEY_F2 then
			OpenDebugInv()
		elseif button == KEY_F3 then
			OpenSMenu()
		elseif button == KEY_F4 then
			OpenDeadeye()
		elseif button == KEY_F5 then
		elseif button == KEY_F6 then
		elseif button == KEY_F7 then
		elseif button == KEY_F8 then
		elseif button == KEY_F9 then
		elseif button == KEY_F11 then
		elseif button == KEY_F12 then
		end
	end
end)
end