
-- Deadeye Choreographer

local function QUICKDIRT( self, w, h, no_bg )
	if !no_bg then
		local r, g, b = schemes["benny"]["bg"]:Unpack()
		surface.SetDrawColor( r, g, b, 200 )
		surface.DrawRect( 0, 0, w, h )
	end

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

local PRETTY = {
	["left_cheek_puffer"] 			= "Left Cheek Puffer",
	["left_cheek_raiser"] 			= "Left Cheek Raiser",
	["left_corner_depressor"] 		= "Left Corner Depressor",
	["left_corner_puller"] 			= "Left Corner Puller",
	["left_lid_closer"] 			= "Left Lid Closer",
	["left_lid_droop"] 				= "Left Lid Droop",
	["left_lid_raiser"] 			= "Left Lid Raiser",
	["left_lid_tightener"] 			= "Left Lid Tightener",
	["left_upper_raiser"] 			= "Left Upper Raiser",
	["left_outer_raiser"] 			= "Left Outer Raiser",
	["left_inner_raiser"] 			= "Left Inner Raiser",
	["left_mouth_drop"] 			= "Left Mouth Drop",
	["left_dimpler"] 				= "Left Dimpler",
	["left_funneler"] 				= "Left Funneler",
	["left_part"] 					= "Left Part",
	["left_puckerer"] 				= "Left Puckerer",
	["left_stretcher"] 				= "Left Stretcher",
	["left_lowerer"] 				= "Left Lowerer",

	["right_cheek_puffer"] 			= "Right Cheek Puffer",
	["right_cheek_raiser"] 			= "Right Cheek Raiser",
	["right_corner_depressor"] 		= "Right Corner Depressor",
	["right_corner_puller"] 		= "Right Corner Puller",
	["right_lid_closer"] 			= "Right Lid Closer",
	["right_lid_droop"] 			= "Right Lid Droop",
	["right_lid_raiser"] 			= "Right Lid Raiser",
	["right_lid_tightener"] 		= "Right Lid Tightener",
	["right_upper_raiser"] 			= "Right Upper Raiser",
	["right_outer_raiser"] 			= "Right Outer Raiser",
	["right_inner_raiser"] 			= "Right Inner Raiser",
	["right_mouth_drop"] 			= "Right Mouth Drop",
	["right_dimpler"] 				= "Right Dimpler",
	["right_funneler"] 				= "Right Funneler",
	["right_part"] 					= "Right Part",
	["right_puckerer"] 				= "Right Puckerer",
	["right_stretcher"] 			= "Right Stretcher",
	["right_lowerer"] 				= "Right Lowerer",

	["bite"] 						= "Bite",
	["blink"] 						= "Blink",
	["half_closed"] 				= "Half Closed",
	["chin_raiser"] 				= "Chin Raiser",
	["dilator"] 					= "Dilator",
	["jaw_clencher"] 				= "Jaw Clencher",
	["jaw_drop"] 					= "Jaw Drop",
	["jaw_sideways"] 				= "Jaw Sideways",
	["lip_bite"] 					= "Lip Bite",
	["lower_lip"] 					= "Lower Lip",
	["mouth_sideways"] 				= "Mouth Sideways",
	["presser"] 					= "Presser",
	["sneer_left"] 					= "Sneer Left",
	["tightener"] 					= "Tightener",
	["wrinkler"] 					= "Wrinkler",

	["body_rightleft"] 				= "Body Rightleft",
	["chest_rightleft"] 			= "Chest Rightleft",
	["eyes_rightleft"] 				= "Eyes Rightleft",
	["eyes_updown"] 				= "Eyes Updown",
	["gesture_rightleft"] 			= "Gesture Rightleft",
	["gesture_updown"] 				= "Gesture Updown",
	["head_forwardback"] 			= "Head Forwardback",
	["head_rightleft"] 				= "Head Rightleft",
	["head_tilt"] 					= "Head Tilt",
	["head_updown"] 				= "Head Updown",
}

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
		MENUBAR:DockMargin( -5, -5, -5, 8 )
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
		MODEL:SetLookAng( Angle( 0, 180, 0 ) )
		MODEL:SetCamPos( Vector( 64, 0, 64 ) )
		function MODEL:LayoutEntity( Entity )
			if DEADEYE_MEM.Flex then
				for i=0, Entity:GetFlexNum()-1 do
					if !DEADEYE_MEM.Flex[ Entity:GetFlexName( i ) ] then continue end
					Entity:SetFlexWeight( i, DEADEYE_MEM.Flex[ Entity:GetFlexName( i ) ] )
				end
			else
				DEADEYE_MEM.Flex = {}
				for i=0, Entity:GetFlexNum()-1 do
					DEADEYE_MEM.Flex[ Entity:GetFlexName( i ) ] = 0--Entity:GetFlexWeight( i )
				end
			end
			self.Entity:SetEyeTarget( self:GetCamPos() )
			return
		end

		function MODEL:PaintOver( w, h )
			QUICKDIRT( self, w, h, true )

			local fuckp, fucka = MODEL:GetCamPos(), MODEL:GetLookAng()
			local PX, PY, PZ, AP, AY, AR = fuckp.x, fuckp.y, fuckp.z, fucka.p, fucka.y, fucka.r
			PX, PY, PZ, AP, AY, AR = math.Round( PX ), math.Round( PY ), math.Round( PZ ), math.Round( AP ), math.Round( AY ), math.Round( AR )
			draw.SimpleText( "pos: " .. PX .. " " .. PY .. " " .. PZ, "Trebuchet24", 8, 4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "ang: " .. AP .. " " .. AY .. " " .. AR, "Trebuchet24", 8, 4+24, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		local MODELSETTINGS = SIDE_MODEL:Add( "DScrollPanel" )
		MODELSETTINGS.Paint = QUICKDIRT

		local flexlist = {}
		for i=0, MODEL.Entity:GetFlexNum()-1 do -- Model settings
			flexlist[MODEL.Entity:GetFlexName( i )] = true
		end

		for i, v in SortedPairs( flexlist ) do
			local id = MODEL.Entity:GetFlexIDByName( i )
			SLIDER = MODELSETTINGS:Add( "DNumSlider" )
			SLIDER:SetText( MODEL.Entity:GetFlexName( id ) )
			local min, max = MODEL.Entity:GetFlexBounds( id )
			SLIDER:SetMin( min )
			SLIDER:SetMax( max )
			SLIDER:SetDecimals( 2 )
			SLIDER:Dock( TOP )
			SLIDER:DockMargin( 10, -5, 10, -5 )

			print( MODEL.Entity:GetFlexName( id ) )

			function SLIDER:OnValueChanged( val )
				if !DEADEYE_MEM.Flex then DEADEYE_MEM.Flex = {} end
				DEADEYE_MEM.Flex[ MODEL.Entity:GetFlexName( id ) ] = val
			end

			function SLIDER:Think()
				if DEADEYE_MEM.Flex then
					self:SetValue( DEADEYE_MEM.Flex[ MODEL.Entity:GetFlexName( id ) ] )
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

if IsValid( GOD ) then OpenDeadeye() end