
local PANEL = {
	Init = function( self )
	end,

	DoClick = function( self )
		self:GetParent():Toggle()
	end,

	UpdateColours = function( self, skin )
	end,

	Paint = function( self )
		return true
	end,

	GenerateExample = function()
	end
}

derma.DefineControl( "BCategoryHeader", "Category Header", PANEL, "DButton" )

local PANEL = {}

AccessorFunc( PANEL, "m_bSizeExpanded",		"Expanded", FORCE_BOOL )
AccessorFunc( PANEL, "m_iContentHeight",	"StartHeight" )
AccessorFunc( PANEL, "m_fAnimTime",			"AnimTime" )
AccessorFunc( PANEL, "m_bDrawBackground",	"PaintBackground", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDrawBackground",	"DrawBackground", FORCE_BOOL ) -- deprecated
AccessorFunc( PANEL, "m_iPadding",			"Padding" )
AccessorFunc( PANEL, "m_pList",				"List" )

function PANEL:Init()

	self.Header = vgui.Create( "BCategoryHeader", self )
	self.Header:Dock( TOP )
	self.Header:SetSize( ss(12), ss(12) )

	self:SetSize( ss(8), ss(8) )
	self:SetExpanded( true )
	self:SetMouseInputEnabled( true )

	self:SetAnimTime( 0.2 )
	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )

	self:SetPaintBackground( true )
end

function PANEL:Add( strName )

	local button = vgui.Create( "DButton", self )
	button.Paint = function( panel, w, h )  end
	button.UpdateColours = function( button, skin )

		if ( button.AltLine ) then

			if ( button.Depressed || button.m_bSelected ) then	return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Selected ) end
			if ( button.Hovered ) then							return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Hover ) end
			return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text )

		end

		if ( button.Depressed || button.m_bSelected ) then	return button:SetTextStyleColor( skin.Colours.Category.Line.Text_Selected ) end
		if ( button.Hovered ) then							return button:SetTextStyleColor( skin.Colours.Category.Line.Text_Hover ) end
		return button:SetTextStyleColor( skin.Colours.Category.Line.Text )

	end

	button:SetHeight( ss(8) )
	button.DoClickInternal = function()

		if ( self:GetList() ) then
			self:GetList():UnselectAll()
		else
			self:UnselectAll()
		end

		button:SetSelected( true )

	end

	button:Dock( TOP )

	self:InvalidateLayout( true )
	self:UpdateAltLines()

	return button

end

function PANEL:UnselectAll()

	for k, v in ipairs( self:GetChildren() ) do

		if ( v.SetSelected ) then
			v:SetSelected( false )
		end

	end

end

function PANEL:UpdateAltLines()

	for k, v in ipairs( self:GetChildren() ) do
		v.AltLine = k % 2 != 1
	end

end

function PANEL:Think()

	self.animSlide:Run()

end

function PANEL:SetLabel( strLabel )

	self.Header:SetText( strLabel )

end

function PANEL:SetHeaderHeight( height )

	self.Header:SetTall( height )

end

function PANEL:GetHeaderHeight()

	return self.Header:GetTall()

end

function PANEL:Paint( w, h )
	local h1 = self:GetHeaderHeight()
	local ex = self:GetExpanded()
	if ex then
		surface.SetDrawColor( schema( "fg" ) )
		surface.DrawRect( 0, 0, w, h1, ss(0.5) )
	else
		surface.SetDrawColor( schema( "fg" ) )
		surface.DrawOutlinedRect( 0, 0, w, h1, ss(0.5) )
	end

	surface.SetDrawColor( schema( "fg" ) )
	surface.DrawOutlinedRect( 0, h1, w, h-h1, ss(0.5) )
	draw.SimpleText( (ex and "- " or "> "), "Benny_12", ss(3), ss(0.5), schema_c(ex and "bg" or "fg"), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText( self.Header:GetText(), "Benny_12", ss(3+8), ss(1), schema_c(ex and "bg" or "fg"), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	return false

end

function PANEL:SetContents( pContents )

	self.Contents = pContents
	self.Contents:SetParent( self )
	self.Contents:Dock( FILL )

	if ( !self:GetExpanded() ) then

		self.OldHeight = self:GetTall()

	elseif ( self:GetExpanded() && IsValid( self.Contents ) && self.Contents:GetTall() < 1 ) then

		self.Contents:SizeToChildren( false, true )
		self.OldHeight = self.Contents:GetTall()
		self:SetTall( self.OldHeight )

	end

	self:InvalidateLayout( true )

end

function PANEL:SetExpanded( expanded )

	self.m_bSizeExpanded = tobool( expanded )

	if ( !self:GetExpanded() ) then
		if ( !self.animSlide.Finished && self.OldHeight ) then return end
		self.OldHeight = self:GetTall()
	end

end

function PANEL:Toggle()

	self:SetExpanded( !self:GetExpanded() )

	self.animSlide:Start( self:GetAnimTime(), { From = self:GetTall() } )

	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

	local open = "1"
	if ( !self:GetExpanded() ) then open = "0" end
	self:SetCookie( "Open", open )

	self:OnToggle( self:GetExpanded() )

end

function PANEL:OnToggle( expanded )

	-- Do nothing / For developers to overwrite

end

function PANEL:DoExpansion( b )

	if ( self:GetExpanded() == b ) then return end
	self:Toggle()

end

function PANEL:PerformLayout()

	if ( IsValid( self.Contents ) ) then

		if ( self:GetExpanded() ) then
			self.Contents:InvalidateLayout( true )
			self.Contents:SetVisible( true )
		else
			self.Contents:SetVisible( false )
		end

	end

	if ( self:GetExpanded() ) then

		if ( IsValid( self.Contents ) && #self.Contents:GetChildren() > 0 ) then self.Contents:SizeToChildren( false, true ) end
		self:SizeToChildren( false, true )

	else

		if ( IsValid( self.Contents ) && !self.OldHeight ) then self.OldHeight = self.Contents:GetTall() end
		self:SetTall( self:GetHeaderHeight() )

	end

	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()

	self.animSlide:Run()
	self:UpdateAltLines()

end

function PANEL:OnMousePressed( mcode )

	if ( !self:GetParent().OnMousePressed ) then return end

	return self:GetParent():OnMousePressed( mcode )

end

function PANEL:AnimSlide( anim, delta, data )

	self:InvalidateLayout()
	self:InvalidateParent()

	if ( anim.Started ) then
		if ( !IsValid( self.Contents ) && ( self.OldHeight || 0 ) < self.Header:GetTall() ) then
			-- We are not using self.Contents and our designated height is less
			-- than the header size, something is clearly wrong, try to rectify
			self.OldHeight = 0
			for id, pnl in ipairs( self:GetChildren() ) do
				self.OldHeight = self.OldHeight + pnl:GetTall()
			end
		end

		if ( self:GetExpanded() ) then
			data.To = math.max( self.OldHeight, self:GetTall() )
		else
			data.To = self:GetTall()
		end
	end

	if ( IsValid( self.Contents ) ) then self.Contents:SetVisible( true ) end

	self:SetTall( Lerp( delta, data.From, data.To ) )

end

function PANEL:LoadCookies()

	local Open = self:GetCookieNumber( "Open", 1 ) == 1

	self:SetExpanded( Open )
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetLabel( "Category List Test Category" )
	ctrl:SetSize( 300, 300 )
	ctrl:SetPadding( 10 )
	ctrl:SetHeaderHeight( 32 )

	-- The contents can be any panel, even a DPanelList
	local Contents = vgui.Create( "DButton" )
	Contents:SetText( "This is the content of the control" )
	ctrl:SetContents( Contents )

	ctrl:InvalidateLayout( true )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "BCollapsibleCategory", "Collapsable Category Panel", PANEL, "Panel" )
