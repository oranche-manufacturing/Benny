
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

local FIRST = {
	"left_lowerer",
	"left_outer_raiser",
	"left_inner_raiser",
	"left_cheek_puffer",
	"left_cheek_raiser",
	"left_lid_closer",
	"left_lid_droop",
	"left_lid_raiser",
	"left_lid_tightener",
	"left_mouth_drop",
	"left_upper_raiser",
	"left_dimpler",
	"left_funneler",
	"left_part",
	"left_puckerer",
	"left_stretcher",
	"left_corner_depressor",
	"left_corner_puller",
}

local SECOND = {
	"jaw_clencher",
	"jaw_drop",
	"jaw_sideways",
	
	"lip_bite",
	"lower_lip",
	"presser",
	"tightener",
	"wrinkler",
	"dilator",

	"bite",
	"blink",
	"half_closed",
	"chin_raiser",
	"mouth_sideways",
	"sneer_left",

	"body_rightleft",
	"chest_rightleft",
	"eyes_rightleft",
	"eyes_updown",
	"gesture_rightleft",
	"gesture_updown",
	"head_forwardback",
	"head_rightleft",
	"head_tilt",
	"head_updown",
}

local SIDE_L = {
	["left_cheek_puffer"] 			= "right_cheek_puffer",
	["left_cheek_raiser"] 			= "right_cheek_raiser",
	["left_corner_depressor"] 		= "right_corner_depressor",
	["left_corner_puller"] 			= "right_corner_puller",
	["left_lid_closer"] 			= "right_lid_closer",
	["left_lid_droop"] 				= "right_lid_droop",
	["left_lid_raiser"] 			= "right_lid_raiser",
	["left_lid_tightener"] 			= "right_lid_tightener",
	["left_upper_raiser"] 			= "right_upper_raiser",
	["left_outer_raiser"] 			= "right_outer_raiser",
	["left_inner_raiser"] 			= "right_inner_raiser",
	["left_mouth_drop"] 			= "right_mouth_drop",
	["left_dimpler"] 				= "right_dimpler",
	["left_funneler"] 				= "right_funneler",
	["left_part"] 					= "right_part",
	["left_puckerer"] 				= "right_puckerer",
	["left_stretcher"] 				= "right_stretcher",
	["left_lowerer"] 				= "right_lowerer",
}

local SIDE_R = {
	["right_cheek_puffer"] 			= "left_cheek_puffer",
	["right_cheek_raiser"] 			= "left_cheek_raiser",
	["right_corner_depressor"] 		= "left_corner_depressor",
	["right_corner_puller"] 		= "left_corner_puller",
	["right_lid_closer"] 			= "left_lid_closer",
	["right_lid_droop"] 			= "left_lid_droop",
	["right_lid_raiser"] 			= "left_lid_raiser",
	["right_lid_tightener"] 		= "left_lid_tightener",
	["right_upper_raiser"] 			= "left_upper_raiser",
	["right_outer_raiser"] 			= "left_outer_raiser",
	["right_inner_raiser"] 			= "left_inner_raiser",
	["right_mouth_drop"] 			= "left_mouth_drop",
	["right_dimpler"] 				= "left_dimpler",
	["right_funneler"] 				= "left_funneler",
	["right_part"] 					= "left_part",
	["right_puckerer"] 				= "left_puckerer",
	["right_stretcher"] 			= "left_stretcher",
	["right_lowerer"] 				= "left_lowerer",
}

local PRETTY = {
	["left_outer_raiser"] 			= "Brow Outer Raiser",
	["left_inner_raiser"] 			= "Brow Inner Raiser",
	["left_lowerer"] 				= "Brow Lowerer",
	["left_cheek_puffer"] 			= "Cheek Puffer",
	["left_cheek_raiser"] 			= "Cheek Raiser",
	["left_lid_closer"] 			= "Lid Closer",
	["left_lid_droop"] 				= "Lid Droop",
	["left_lid_raiser"] 			= "Lid Raiser",
	["left_lid_tightener"] 			= "Lid Tightener",
	["left_mouth_drop"] 			= "Mouth Drop",
	["left_upper_raiser"] 			= "Lip Upper Raiser",
	["left_dimpler"] 				= "Lip Dimpler",
	["left_funneler"] 				= "Lip Funneler",
	["left_part"] 					= "Lip Part",
	["left_puckerer"] 				= "Lip Puckerer",
	["left_stretcher"] 				= "Lip Stretcher",
	["left_corner_depressor"] 		= "Lip Corner Depr.",
	["left_corner_puller"] 			= "Lip Corner Puller",

	["right_outer_raiser"] 			= "Brow Outer Raiser",
	["right_inner_raiser"] 			= "Brow Inner Raiser",
	["right_lowerer"] 				= "Brow Lowerer",
	["right_cheek_puffer"] 			= "Cheek Puffer",
	["right_cheek_raiser"] 			= "Cheek Raiser",
	["right_lid_closer"] 			= "Lid Closer",
	["right_lid_droop"] 			= "Lid Droop",
	["right_lid_raiser"] 			= "Lid Raiser",
	["right_lid_tightener"] 		= "Lid Tightener",
	["right_mouth_drop"] 			= "Mouth Drop",
	["right_upper_raiser"] 			= "Lip Upper Raiser",
	["right_dimpler"] 				= "Lip Dimpler",
	["right_funneler"] 				= "Lip Funneler",
	["right_part"] 					= "Lip Part",
	["right_puckerer"] 				= "Lip Puckerer",
	["right_stretcher"] 			= "Lip Stretcher",
	["right_corner_depressor"] 		= "Lip Corner Depr.",
	["right_corner_puller"] 		= "Lip Corner Puller",

	["jaw_clencher"] 				= "Jaw Clencher",
	["jaw_drop"] 					= "Jaw Drop",
	["jaw_sideways"] 				= "Jaw Sideways",
	
	["lip_bite"] 					= "Lip Bite",
	["lower_lip"] 					= "Lip Lower Depr.",
	["presser"] 					= "Lip Presser",
	["tightener"] 					= "Lip Tightener",
	["wrinkler"] 					= "Nose Wrinkler",
	["dilator"] 					= "Nose Dilator",

	["bite"] 						= "Bite",
	["blink"] 						= "Blink",
	["half_closed"] 				= "Half Closed",
	["chin_raiser"] 				= "Chin Raiser",
	["mouth_sideways"] 				= "Mouth Sideways",
	["sneer_left"] 					= "Sneer Left",

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

local function makeme( id, parent, ent, no_dock )
	local SLIDER = parent:Add( "DNumSlider" )
	SLIDER:SetText( PRETTY[ ent:GetFlexName( id ) ] or ent:GetFlexName( id ) )
	local min, max = ent:GetFlexBounds( id )
	SLIDER:SetMin( min )
	SLIDER:SetMax( max )
	SLIDER:SetDecimals( 2 )
	SLIDER:SetTall( 18 )
	if !no_dock then
		SLIDER:Dock( TOP )
		SLIDER:DockMargin( 10, 0, 10, 0 )
	end

	SLIDER.Label:SetWide( 90 )
	function SLIDER:PerformLayout() return end

	function SLIDER:OnValueChanged( val )
		if !DEADEYE_MEM.Flex then DEADEYE_MEM.Flex = {} end
		DEADEYE_MEM.Flex[ ent:GetFlexName( id ) ] = val
	end

	function SLIDER:Think()
		if DEADEYE_MEM.Flex then
			self:SetValue( DEADEYE_MEM.Flex[ ent:GetFlexName( id ) ] )
		end
	end
	return SLIDER
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

		do -- Model side (top)
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
				draw.SimpleText( "fov: " .. math.Round( MODEL:GetFOV() ), "Trebuchet24", 8, 4+48, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end

			local MODELPSHEET = SIDE_MODEL:Add( "DPropertySheet" )
			MODELPSHEET.Paint = QUICKDIRT

			local MODELSETTINGS = SIDE_MODEL:Add( "DScrollPanel" )
			MODELSETTINGS.Paint = QUICKDIRT

			MODELPSHEET:AddSheet( "Actor Alyx", MODELSETTINGS )

			local flexlist = {}
			for i=0, MODEL.Entity:GetFlexNum()-1 do -- Model settings
				flexlist[MODEL.Entity:GetFlexName( i )] = true
			end

			local madelist = {}

			
			local MARKF = MODELSETTINGS:Add( "DHorizontalDivider" )
			MARKF:Dock( TOP )
			MARKF:DockMargin( 130, 0, -140, 0 )
			MARKF:SetDividerWidth( 0 )
			local LABELR = MODELSETTINGS:Add("DLabel")
			LABELR:SetText( "Right" )
			local LABELL = MODELSETTINGS:Add("DLabel")
			LABELL:SetText( "Left" )
			MARKF:SetLeft( LABELR )
			MARKF:SetRight( LABELL )
			local old = MARKF.PerformLayout
			function MARKF:PerformLayout( w, h )
				self:SetLeftWidth( w / 2 )
				old( self, w, h )
			end

			for v, i in ipairs( FIRST ) do
				local MARK = MODELSETTINGS:Add( "DHorizontalDivider" )
				MARK:Dock( TOP )
				MARK:DockMargin( 10, -4, 10, -4 )
				MARK:SetDividerWidth( 0 )

				local SLIDERA = makeme( MODEL.Entity:GetFlexIDByName( SIDE_L[i] ), MODELSETTINGS, MODEL.Entity, true )
				local SLIDERB = makeme( MODEL.Entity:GetFlexIDByName( i ), MODELSETTINGS, MODEL.Entity, true )
				madelist[SIDE_L[i]] = true
				madelist[i] = true
				MARK:SetLeft( SLIDERA )
				MARK:SetRight( SLIDERB )
				local old = MARK.PerformLayout
				function MARK:PerformLayout( w, h )
					self:SetLeftWidth( w / 2 )
					old( self, w, h )
				end
			end

			for v, i in SortedPairs( SECOND ) do
				if !madelist[i] then
					local id = MODEL.Entity:GetFlexIDByName( i )
					makeme( id, MODELSETTINGS, MODEL.Entity )
					madelist[i] = true
				end
			end

			for i, v in SortedPairs( flexlist ) do
				if !madelist[i] then
					local id = MODEL.Entity:GetFlexIDByName( i )
					makeme( id, MODELSETTINGS, MODEL.Entity )
					madelist[i] = true
				end
			end

			local DIVIDER = SIDE_MODEL:Add( "DHorizontalDivider" )
			DIVIDER:Dock( FILL )
			DIVIDER:SetLeft( MODEL )
			DIVIDER:SetRight( MODELPSHEET )
			DIVIDER:SetDividerWidth( 8 )
			DIVIDER:SetLeftMin( 20 )
			DIVIDER:SetRightMin( 240 )
			DIVIDER:SetLeftWidth( 800 )
		end

		do -- Choreo side (bottom)
			local PLAY = SIDE_CHOREO:Add( "DButton" )
			PLAY:SetPos( 4, 4 )
			PLAY:SetSize( 80, 20 )
			PLAY:SetText( "Play/Pause" )
			PLAY.Paint = QUICKDIRT

			local SPEED = SIDE_CHOREO:Add( "DNumSlider" )
			SPEED:SetPos( 4+4+80, 4 )
			SPEED:SetSize( 180, 20 )
			SPEED:SetText( "Speed" )
			SPEED.Label:SetWide( 0 )
			function SPEED:PerformLayout()
				return true
			end
			SPEED:SetMin( 0 )
			SPEED:SetMax( 100 )
			SPEED:SetValue( 100 )
			SPEED:SetDecimals( 0 )
			SPEED.Paint = QUICKDIRT

			do
				local BLINKY = SIDE_CHOREO:Add( "DPanel" )
				BLINKY:SetPos( 4, 4+4+20 )
				BLINKY.Paint = QUICKDIRT
				function BLINKY:PerformLayout( w, h )
					local par = SIDE_CHOREO
					BLINKY:SetSize( par:GetWide() - 8, par:GetTall() - 20 - 12 )
				end
			end
		end
	end
end

if IsValid( GOD ) then OpenDeadeye() end

concommand.Add("benny_ui_deadeye", function()
	OpenDeadeye()
end)