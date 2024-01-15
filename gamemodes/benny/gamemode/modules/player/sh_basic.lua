
if SERVER then
	util.AddNetworkString( "benny_sendinvitem" )
	util.AddNetworkString( "benny_discardinvitem" )
end

function BENNY.CreateItem( classname )
	local class = ItemDef(classname)

	assert( class, "Invalid Class " .. tostring(classname) )

	local item = {
		Class = classname,
		Acquisition = CurTime(),
	}

	class.Init_Item( class, item )

	--if class.Features == "firearm" then
	--	item.Loaded = ""
	--elseif class.Features == "magazine" then
	--	item.Ammo = class.Ammo
	--end
	--
	return item
end

concommand.Add("benny_debug_give", function(ply, cmd, args)
	assert(SERVER, "not server")
	local inv = ply:INV_Get()
	local str = UUID_generate()

	local newitem = BENNY.CreateItem( args[1] )
	inv[str] = newitem

	-- PROTO: WriteTable.
	net.Start( "benny_sendinvitem" )
		net.WriteString( str )
		net.WriteTable( newitem )
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
end, "arg 1: classname")

if CLIENT then
	net.Receive( "benny_sendinvitem", function()
		LocalPlayer():INV_Get()[net.ReadString()] = net.ReadTable()
	end)
	net.Receive( "benny_discardinvitem", function()
		LocalPlayer():INV_Get()[net.ReadString()] = nil
	end)
end

function InvDiscard( ply, ID )
	local inv = ply:INV_Get()
	local wep = ply:GetActiveWeapon()
	local item = inv[ID]
	-- PROTO: Check that this is the correct 'benny' weapon.
	assert( item, "That item doesn't exist. " .. tostring(item) )

	inv[ID] = nil
	net.Start( "benny_discardinvitem" )
		net.WriteString( ID )
	net.Send( ply )

	if wep:bGetInvID( false ) == ID then
		print( "Disequipped " .. ID .. " for " .. tostring(wep) )
		wep:SetWep1( "" )
		wep:SetWep1_Clip( "" )
		wep:SetClip1( 0 )
	end
	if wep:bGetInvID( true ) == ID then
		print( "Disequipped " .. ID .. " for " .. tostring(wep) )
		wep:SetWep2( "" )
		wep:SetWep2_Clip( "" )
		wep:SetClip2( 0 )
	end
	if wep:bGetMagInvID( false ) == ID then
		print( "Unloaded " .. ID .. " for " .. tostring(wep) )
		inv[wep:bGetInvID( false )].Loaded = ""
		wep:SetWep1_Clip( "" )
		wep:SetClip1( 0 )
	end
	if wep:bGetMagInvID( true ) == ID then
		print( "Unloaded " .. ID .. " for " .. tostring(wep) )
		inv[wep:bGetInvID( true )].Loaded = ""
		wep:SetWep2_Clip( "" )
		wep:SetClip2( 0 )
	end
end

concommand.Add("benny_inv_discard", function( ply, cmd, args )
	InvDiscard( ply, args[1] )
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
			-- OpenDeadeye()
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