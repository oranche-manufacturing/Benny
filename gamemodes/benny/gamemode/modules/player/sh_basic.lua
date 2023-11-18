
if SERVER then
	util.AddNetworkString( "benny_syncinv" )
	util.AddNetworkString( "benny_sendinvitem" )
	util.AddNetworkString( "benny_discardinvitem" )
end

concommand.Add("benny_debug_give", function(ply, cmd, args)
	assert(SERVER, "not server")
	local inv = ply:INV_Get()
	local str = UUID_generate()

	local class = WEAPONS[args[1]]

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
		print(args[2])
		local hand = args[2]!=nil and tobool(args[2]) or wep:GetTempHandedness()
		print(hand)
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
	if wep then wep:BHolster( wep:GetTempHandedness() ) end
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
		ply:ConCommand( "benny_inv_holster" )
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
			Collapse:SetExpanded( false )
			Lays:Dock( FILL )
			Lays:SetSpaceX( ss(1) )
			Lays:SetSpaceY( ss(1) )
			for Mew, New in ipairs( v ) do
				local button = Lays:Add( "DButton" )
				button:SetSize( ss(95), ss(14) )
				--button:Dock( TOP )
				button:DockMargin( 0, 0, 0, ss(4) )

				button.Text_Name = New.Class.Name
				button.Text_Desc = New.Class.Description

				-- PROTO: These functions don't need to be remade over and over like this.
				function button:DoClick()
					RunConsoleCommand( "benny_debug_give", New.ClassName )
				end

				function button:DoRightClick()
					RunConsoleCommand( "benny_debug_give", "mag_" .. New.ClassName )
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
		local inv = ply:INV_Get()
		local active = GetConVar("benny_hud_tempactive"):GetString()
		itemlist:Clear()
		
		local maidlist = {}
		local catesmade = {}

		for i, v in pairs( ply:INV_ListFromBuckets() ) do
			local class = inv[v].Class
			local Class = WEAPONS[class]

			if !catesmade[Class.Type] then
				catesmade[Class.Type] = true
				local cate = vgui.Create( "DButton" )
				itemlist:AddItem( cate )
				cate:SetSize( 1, ss(12) )
				cate:Dock( TOP )
				cate:DockMargin( 0, 0, 0, ss(2) )

				cate.Text_Name = Class.Type

				function cate:Paint( w, h )
					surface.SetDrawColor( schemes[active]["bg"] )
					surface.DrawRect( 0, 0, w, h )
					surface.SetDrawColor( schemes[active]["fg"] )
					surface.DrawOutlinedRect( 0, 0, w, h, ss(0.5) )
					
					surface.SetTextColor( schemes[active]["fg"] )
					surface.SetFont( "Benny_10" )
					surface.SetTextPos( ss(2), ss(2) )
					surface.DrawText( self.Text_Name )
	
					return true
				end
			end

			local button = vgui.Create( "DButton" )
			itemlist:AddItem( button )
			button:SetSize( 1, ss(24) )
			button:Dock( TOP )
			button:DockMargin( 0, 0, 0, ss(2) )

			button.ID = v

			local mag = false
			if class:Left( 4 ) == "mag_" then
				mag = true
				button:SetTall( ss(11) )
			end

			if !maidlist[class] then
				maidlist[class] = table.Flip( ply:INV_Find( class ) )
			end
			local ml = maidlist[class]

			button.Text_Name = Class.Name
			button.Text_Desc = Class.Description
			button.Text_ID =  "[" .. ml[v] .. "] " .. button.ID 

			-- PROTO: These functions don't need to be remade over and over like this.
			function button:DoClick()
				local Menu = DermaMenu()

				local opt0 = Menu:AddOption( "Equip", function()
					RunConsoleCommand( "benny_inv_equip", button.ID )
				end)
				opt0:SetIcon( "icon16/control_play_blue.png" )
				
				Menu:AddSpacer()

				local opt1 = Menu:AddOption( "Equip Right", function()
					RunConsoleCommand( "benny_inv_equip", button.ID, "false" )
				end)
				opt1:SetIcon( "icon16/resultset_next.png" )

				local opt2 = Menu:AddOption( "Equip Left", function()
					RunConsoleCommand( "benny_inv_equip", button.ID, "true" )
				end)
				opt2:SetIcon( "icon16/resultset_previous.png" )

				local opt3 = Menu:AddOption( "Swap Right", function()
					RunConsoleCommand( "benny_inv_equip", button.ID, "false", "true" )
				end)
				opt3:SetIcon( "icon16/resultset_first.png" )

				local opt4 = Menu:AddOption( "Swap Left", function()
					RunConsoleCommand( "benny_inv_equip", button.ID, "true", "true" )
				end)
				opt4:SetIcon( "icon16/resultset_last.png" )

				Menu:AddSpacer()

				local opt5 = Menu:AddOption( "Holster", function()
					RunConsoleCommand( "benny_inv_holster", button.ID )
				end)
				opt5:SetIcon( "icon16/control_pause_blue.png" )

				local opt6 = Menu:AddOption( "Discard", function()
					RunConsoleCommand("benny_inv_discard", button.ID)
					self:Remove()
				end)
				opt6:SetIcon( "icon16/bin.png" )
				
				Menu:Open()
				-- timer.Simple( 0.1, function() if IsValid( itemlist ) then regen_items( itemlist ) end end )
			end

			function button:DoRightClick()
				RunConsoleCommand("benny_inv_discard", button.ID)
				self:Remove()
				-- timer.Simple( 0.1, function() if IsValid( itemlist ) then regen_items( itemlist ) end end )
			end

			function button:Paint( w, h )
				surface.SetDrawColor( schemes[active]["fg"] )
				surface.DrawRect( 0, 0, w, h )
				
				surface.SetTextColor( schemes[active]["bg"] )

				surface.SetFont( !mag and "Benny_16" or "Benny_10" )
				surface.SetTextPos( ss(2), ss(2) )
				surface.DrawText( self.Text_Name )

				if !mag then
					surface.SetFont( "Benny_12" )
					surface.SetTextPos( ss(2), ss(2 + 11) )
					surface.DrawText( self.Text_Desc )
				end

				surface.SetFont( "Benny_10" )
				local tx = surface.GetTextSize( self.Text_ID )
				surface.SetTextPos( w - ss(2) - tx, ss(2) )
				surface.DrawText( self.Text_ID )
				return true
			end
		end
	end
	concommand.Add("benny_debug_inv", function()
		if IsValid( base ) then base:Remove() end
		base = vgui.Create("DFrame")
		base:SetSize( ss(400), ss(400) )
		base:MakePopup()
		base:SetKeyboardInputEnabled( false )
		base:Center()
		local active = GetConVar("benny_hud_tempactive"):GetString()

		function base:Paint( w, h )
			surface.SetDrawColor( schemes[active]["bg"] )
			surface.DrawRect( 0, 0, w, h )
			return true
		end

		local itemlist = base:Add("DScrollPanel")
		itemlist:Dock( FILL )

		regen_items( itemlist )
	end)
end