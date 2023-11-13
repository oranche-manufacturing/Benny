
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_benny" )
	ply:SetModel( "models/player/police.mdl" )
	ply:SetViewOffset( Vector( 0, 0, 64 ) )
	ply:SetViewOffsetDucked( Vector( 0, 0, 50 ) )
	ply:SetPlayerColor( Vector( 0.275, 0.2, 0.145 ) )
	ply:Give( "benny" )

	ply:SetCrouchedWalkSpeed( 0.3 )
	ply:SetDuckSpeed( 0.1 )
	ply:SetUnDuckSpeed( 0.1 )
	ply:SetSlowWalkSpeed( 100 )
	ply:SetWalkSpeed( 160 )
	ply:SetRunSpeed( 220 )
	ply:SetStepSize( 16 )
end

if SERVER then
	util.AddNetworkString( "benny_syncinv" )
	util.AddNetworkString( "benny_sendinvitem" )
	util.AddNetworkString( "benny_discardinvitem" )
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
		Loaded = 1,
		Ammo1 = class.Ammo,
		Ammo2 = class.Ammo,
		Ammo3 = class.Ammo,
		Acquisition = CurTime(),
	}

	inv[str] = item

	-- PROTO: WriteTable.
	net.Start( "benny_sendinvitem" )
		net.WriteString( str )
		net.WriteTable( item )
	net.Send( ply )

	local slot = tonumber(args[2])

	if slot == 1 then
		wep:SetWep1( str )
		wep:SetWep1Clip( item.Loaded )
		wep:SetClip1( item[ "Ammo" .. item.Loaded ] )
	elseif slot == 2 then
		wep:SetWep2( str )
		wep:SetWep2Clip( item.Loaded )
		wep:SetClip2( item[ "Ammo" .. item.Loaded ] )
	else
		
	end
end)

-- PROTO: Move this all into weapon code.
concommand.Add("benny_inv_equip", function( ply, cmd, args )
	local inv = ply:INV_Get()
	local wep = ply:GetActiveWeapon()
	local item = inv[args[1]]
	local class = WEAPONS[item.Class]
	-- PROTO: Check that this is the correct 'benny' weapon.
	assert( item, "That item doesn't exist. " .. tostring(item) )

	wep:SetWep1( args[1] )
	wep:SetWep1Clip( item.Loaded )
	
	-- PROTO: Make grenade/melee/firearm logic way way better.
	if class.Features == "firearm" then
		if item.Loaded != 0 then
			assert( item[ "Ammo" .. item.Loaded ], "That magazine doesn't exist." )
		end
		wep:SetClip1( item.Loaded == 0 and 0 or item[ "Ammo" .. item.Loaded ] )
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
		wep:SetWep1Clip( 0 )
		wep:SetClip1( 0 )
	end
	if wep:GetWep2() == args[1] then
		wep:SetWep2( "" )
		wep:SetWep2Clip( 0 )
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

-- Debug inv
if CLIENT then
	function GM:OnSpawnMenuOpen()
		RunConsoleCommand( "benny_debug_inv" )
	end
	function GM:OnSpawnMenuClose()
		if IsValid( base ) then base:Remove() end
	end
	
	function OpenSMenu()
		if IsValid( smenu ) then smenu:Remove() return end
		local active = GetConVar("benny_hud_tempactive"):GetString()
		smenu = vgui.Create("DFrame")
		smenu:SetSize( ss(1+(96+2)*4), ss(360) )
		smenu:MakePopup()
		smenu:SetKeyboardInputEnabled( false )
		smenu:Center()

		function smenu:Paint( w, h )
			surface.SetDrawColor( schemes[active]["bg"] )
			surface.DrawRect( 0, 0, w, h )
			return true
		end

		local itemlist = smenu:Add("DScrollPanel")
		itemlist:Dock( FILL )

		-- local List = vgui.Create( "DIconLayout", itemlist )
		-- List:Dock( FILL )
		-- List:SetSpaceX( 5 )
		-- List:SetSpaceY( 5 )


		local createlist = {}
		
		for ClassName, Class in pairs( WEAPONS ) do
			if !createlist[Class.Type] then
				createlist[Class.Type] = {}
			end

			table.insert( createlist[Class.Type], { ClassName = ClassName, Class = Class } )
		end


		for i, v in SortedPairs( createlist ) do
			local Collapse = itemlist:Add( "DCollapsibleCategory" )
			Collapse:Dock( TOP )
			Collapse:SetLabel( i )
			local Lays = itemlist:Add( "DIconLayout" )
			Collapse:SetContents( Lays )
			Lays:Dock( FILL )
			Lays:SetSpaceX( ss(1) )
			Lays:SetSpaceY( ss(1) )
			for Mew, New in ipairs( v ) do
				local button = Lays:Add( "DButton" )
				button:SetSize( ss(96), ss(14) )
				--button:Dock( TOP )
				button:DockMargin( 0, 0, 0, ss(4) )

				button.Text_Name = New.Class.Name
				button.Text_Desc = New.Class.Description

				-- PROTO: These functions don't need to be remade over and over like this.
				function button:DoClick()
					RunConsoleCommand( "benny_debug_give", LocalPlayer():EntIndex(), 0, New.ClassName )
				end

				function button:DoRightClick()
				end

				function button:Paint( w, h )
					surface.SetDrawColor( schemes[active]["fg"] )
					surface.DrawRect( 0, 0, w, h )
					
					surface.SetTextColor( schemes[active]["bg"] )

					surface.SetFont( "Benny_12" )
					surface.SetTextPos( ss(2), ss(2) )
					surface.DrawText( self.Text_Name )

					-- surface.SetFont( "Benny_10" )
					-- surface.SetTextPos( ss(4), ss(4 + 12) )
					-- surface.DrawText( self.Text_Desc )
					return true
				end
			end
		end

	end
	local function regen_items( itemlist )
		local ply = LocalPlayer()
		local active = GetConVar("benny_hud_tempactive"):GetString()
		itemlist:Clear()

		for i, v in pairs( ply:INV_Get() ) do
			local button = vgui.Create( "DButton" )
			itemlist:AddItem( button )
			button:SetSize( 1, ss(36) )
			button:Dock( TOP )
			button:DockMargin( 0, 0, 0, ss(4) )

			button.ID = i
			local Class = WEAPONS[v.Class]
			button.Text_Name = Class.Name
			button.Text_Desc = Class.Description

			-- PROTO: These functions don't need to be remade over and over like this.
			function button:DoClick()
				RunConsoleCommand("benny_inv_equip", button.ID)
				timer.Simple( 0.1, function() if IsValid( itemlist ) then regen_items( itemlist ) end end )
			end

			function button:DoRightClick()
				RunConsoleCommand("benny_inv_discard", button.ID)
				timer.Simple( 0.1, function() if IsValid( itemlist ) then regen_items( itemlist ) end end )
			end

			function button:Paint( w, h )
				surface.SetDrawColor( schemes[active]["fg"] )
				surface.DrawRect( 0, 0, w, h )
				
				surface.SetTextColor( schemes[active]["bg"] )

				surface.SetFont( "Benny_16" )
				surface.SetTextPos( ss(4), ss(4) )
				surface.DrawText( self.Text_Name )

				surface.SetFont( "Benny_12" )
				surface.SetTextPos( ss(4), ss(4 + 12) )
				surface.DrawText( self.Text_Desc )

				surface.SetFont( "Benny_12" )
				local tx = surface.GetTextSize( self.ID )
				surface.SetTextPos( w - ss(4) - tx, ss(4) )
				surface.DrawText( self.ID )
				return true
			end
		end
	end
	concommand.Add("benny_debug_inv", function()
		if IsValid( base ) then base:Remove() end
		base = vgui.Create("DFrame")
		base:SetSize( ss(400), ss(240) )
		base:MakePopup()
		base:SetKeyboardInputEnabled( false )
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