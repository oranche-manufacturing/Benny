
-- Deadeye Choreographer

local function QUICKDIRT( self, w, h )
	local r, g, b = schemes["benny"]["bg"]:Unpack()
	surface.SetDrawColor( r, g, b, 200 )
	surface.DrawRect( 0, 0, w, h )

	surface.SetDrawColor( schemes["benny"]["fg"] )
	surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end
local function QUICKEARTH( self, w, h )
	local r, g, b = schemes["benny"]["fg"]:Unpack()
	surface.SetDrawColor( r, g, b, 200 )
	surface.DrawRect( 0, 0, w, h )
end
local function QUICKNIL( self, w, h )
end

DEADEYE_MEM = DEADEYE_MEM or {}

function OpenDeadeye()
	if IsValid( GOD ) then GOD:Remove() end
	GOD = vgui.Create( "DFrame" )

	GOD:SetTitle( "Deadeye Choreographer" )
	GOD:SetSize( ScrW()*0.9, ScrH()*0.9 )
	GOD:Center()
	GOD:MakePopup()
	GOD:SetSizable( true )
	GOD.Paint = QUICKDIRT

	do -- Menubar
		local MENUBAR = GOD:Add( "DMenuBar" )
		MENUBAR:Dock( TOP )
		MENUBAR.Paint = QUICKDIRT

		local MENU_FILE = MENUBAR:AddMenu( "File" )
		MENU_FILE:AddOption( "New", function() table.Empty( DEADEYE_MEM ) OpenDeadeye() end )
		MENU_FILE:AddOption( "Open", function()  end )
		local MENU_EDIT = MENUBAR:AddMenu( "Edit" )
		local MENU_ABOUT = MENUBAR:AddMenu( "About" )
	end

	local NAME = {
		"X",
		"Y",
		"Z",
		"P",
		"Y",
		"R",
	}

	do -- Main
		local MAIN = GOD:Add( "DPanel" )
		MAIN:Dock( FILL )
		MAIN.Paint = QUICKNIL

		local SIDE_MODEL = MAIN:Add( "DPanel" )
		SIDE_MODEL.Paint = QUICKNIL
		local SIDE_CHOREO = MAIN:Add( "DPanel" )
		SIDE_CHOREO.Paint = QUICKDIRT

		local SIDEDIV = MAIN:Add( "DVerticalDivider" )
		SIDEDIV:Dock( FILL )
		SIDEDIV:SetTop( SIDE_MODEL )
		SIDEDIV:SetBottom( SIDE_CHOREO )
		SIDEDIV:SetDividerHeight( 8 )
		SIDEDIV:SetTopMin( 20 )
		SIDEDIV:SetBottomMin( 240 )
		SIDEDIV:SetTopHeight( 500 )

		local MODEL = SIDE_MODEL:Add( "DAdjustableModelPanel" )
		MODEL:SetFOV( 30 )
		MODEL:SetModel( "models/alyx.mdl" )
		function MODEL:LayoutEntity( Entity )
			if DEADEYE_MEM.Flex then
				for i=1, Entity:GetFlexNum() do
					if !DEADEYE_MEM.Flex[ Entity:GetFlexName( i - 1 ) ] then continue end
					Entity:SetFlexWeight( i-1, DEADEYE_MEM.Flex[ Entity:GetFlexName( i - 1 ) ] )
				end
			else
				DEADEYE_MEM.Flex = {}
				for i=1, Entity:GetFlexNum() do
					DEADEYE_MEM.Flex[ Entity:GetFlexName( i - 1 ) ] = Entity:GetFlexWeight( i - 1 )
				end
			end
			return
		end

		function MODEL:PaintOver( w, h )
			local fuckp, fucka = MODEL:GetCamPos(), MODEL:GetLookAng()
			local PX, PY, PZ, AP, AY, AR = fuckp.x, fuckp.y, fuckp.z, fucka.p, fucka.y, fucka.r
			PX, PY, PZ, AP, AY, AR = math.Round( PX ), math.Round( PY ), math.Round( PZ ), math.Round( AP ), math.Round( AY ), math.Round( AR )
			draw.SimpleText( "pos: " .. PX .. " " .. PY .. " " .. PZ, "Trebuchet24", 8, 8, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "ang: " .. AP .. " " .. AY .. " " .. AR, "Trebuchet24", 8, 8+24, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		local MODELSETTINGS = SIDE_MODEL:Add( "DScrollPanel" )
		MODELSETTINGS.Paint = QUICKDIRT

		for i=1, MODEL.Entity:GetFlexNum() do -- Model settings
			SLIDER = MODELSETTINGS:Add( "DNumSlider" )
			SLIDER.FlexID = i
			SLIDER:SetText( MODEL.Entity:GetFlexName( i - 1 ) )	-- Set the text above the slider
			local min, max = MODEL.Entity:GetFlexBounds( i - 1 )
			SLIDER:SetMin( min )
			SLIDER:SetMax( max )
			SLIDER:SetDecimals( 2 )
			SLIDER:Dock( TOP )
			SLIDER:DockMargin( 10, -5, 10, -5 )

			function SLIDER:OnValueChanged( val )
				if !DEADEYE_MEM.Flex then DEADEYE_MEM.Flex = {} end
				DEADEYE_MEM.Flex[ MODEL.Entity:GetFlexName( i - 1 ) ] = val
			end

			function SLIDER:Think()
				if DEADEYE_MEM.Flex then
					self:SetValue( DEADEYE_MEM.Flex[ MODEL.Entity:GetFlexName( i - 1 ) ] )
				end
			end
		end

		local DIVIDER = SIDE_MODEL:Add( "DHorizontalDivider" )
		DIVIDER:Dock( FILL )
		DIVIDER:SetLeft( MODEL )
		DIVIDER:SetRight( MODELSETTINGS )
		DIVIDER:SetDividerWidth( 8 )
		DIVIDER:SetLeftMin( 20 )
		DIVIDER:SetRightMin( 240 )
		DIVIDER:SetLeftWidth( 1000 )
	end
end