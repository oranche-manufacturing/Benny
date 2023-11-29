
-- Dev spawnmenu

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
		Collapse:SetExpanded( i!="magazine" )
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
				chat.AddText( "Gave " .. New.Class.Name )
			end

			function button:DoRightClick()
				RunConsoleCommand( "benny_debug_give", "mag_" .. New.ClassName )
				chat.AddText( "Gave " .. WeaponGet("mag_"..New.ClassName).Name )
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