
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

	assert(class, "Invalid Class.")

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

if CLIENT then
	local function regen_items( itemlist )
		local ply = LocalPlayer()
		itemlist:Clear()

		for i, v in pairs( ply:INV_Get() ) do
			local button = vgui.Create( "DButton" )
			itemlist:AddItem( button )
			button:SetSize( 1, ss(36) )
			button:Dock( TOP )
			button:DockMargin( 0, 0, 0, ss(4) )

			button.Text_ID = i
			local Class = WEAPONS[v.Class]
			button.Text_Name = Class.Name
			button.Text_Desc = Class.Description

			-- PROTO: This paint function doesn't need to be remade over and over like this.
			function button:Paint( w, h )
				surface.SetDrawColor( schemes["benny"]["fg"] )
				surface.DrawRect( 0, 0, w, h )
				
				surface.SetTextColor( schemes["benny"]["bg"] )

				surface.SetFont( "Benny_16" )
				surface.SetTextPos( ss(4), ss(4) )
				surface.DrawText( self.Text_Name )

				surface.SetFont( "Benny_10" )
				surface.SetTextPos( ss(4), ss(4 + 12) )
				surface.DrawText( self.Text_Desc )

				surface.SetFont( "Benny_10" )
				surface.SetTextPos( ss(4), ss(4 + 20) )
				surface.DrawText( self.Text_ID )
				return true
			end
		end
	end
	concommand.Add("benny_debug_inv", function()
		if IsValid( base ) then base:Remove() end
		base = vgui.Create("DFrame")
		base:SetSize( ss(340), ss(240) )
		base:MakePopup()
		base:Center()

		function base:Paint( w, h )
			surface.SetDrawColor( schemes["benny"]["bg"] )
			surface.DrawRect( 0, 0, w, h )
			return true
		end

		local itemlist = base:Add("DScrollPanel")
		itemlist:Dock( FILL )

		regen_items( itemlist )
	end)
end