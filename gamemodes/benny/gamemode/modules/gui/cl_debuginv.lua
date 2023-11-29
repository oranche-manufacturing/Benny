
-- Dev inventory

local function regen_items( itemlist )
	local ply = LocalPlayer()
	local inv = ply:INV_Get()
	local active = GetConVar("benny_hud_tempactive"):GetString()
	itemlist:Clear()
	
	local maidlist = {}
	local catesmade = {}

	for i, v in pairs( ply:INV_ListFromBuckets() ) do
		local class = inv[v].Class
		local Class = WeaponGet(class)

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

			local opt1 = Menu:AddOption( "Equip Right", function()
				RunConsoleCommand( "benny_inv_equip", button.ID, "false" )
			end)
			opt1:SetIcon( "icon16/resultset_last.png" )

			local opt3 = Menu:AddOption( "Equip Right, Move Left", function()
				RunConsoleCommand( "benny_inv_equip", button.ID, "false", "true" )
			end)
			opt3:SetIcon( "icon16/resultset_next.png" )
			
			Menu:AddSpacer()

			local opt2 = Menu:AddOption( "Equip Left", function()
				RunConsoleCommand( "benny_inv_equip", button.ID, "true" )
			end)
			opt2:SetIcon( "icon16/resultset_first.png" )

			local opt4 = Menu:AddOption( "Equip Left, Move Right", function()
				RunConsoleCommand( "benny_inv_equip", button.ID, "true", "true" )
			end)
			opt4:SetIcon( "icon16/resultset_previous.png" )

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

		button.DoRightClick = function( self )
			RunConsoleCommand("benny_inv_discard", button.ID)
			self:Remove()
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