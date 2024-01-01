
-- Main menu

local meow = {
	"RESUME",
	"",
	"START GAME",
	"LOAD GAME",
	"",
	"JOIN SERVER",
	"START SERVER",
	"",
	"OPTIONS",
	"QUIT",
}

local function unimplemented()
	if mb and mb:IsValid() then mb:Remove() end
	mb = vgui.Create( "BFrame" )
	mb:SetSize( ss(160), ss(50) )
	mb:Center()
	mb:MakePopup()

	mb:SetTitle( "Woops!" )

	local oldpaint = mb.Paint
	function mb:Paint( w, h )
		oldpaint( self, w, h )
		surface.SetDrawColor( schema("fg") )
		surface.DrawOutlinedRect( 0, 0, w, h, ss(1) )

		draw.SimpleText( "That isn't implemented yet.", "Benny_12", w/2, ss(18), schema_c("fg"), TEXT_ALIGN_CENTER )
	end

	local okbutton = mb:Add("DButton")
	okbutton:SetText("")
	okbutton:SetSize( ss(30), ss(12) )
	okbutton:SetPos( mb:GetWide()/2 - okbutton:GetWide()/2, mb:GetTall() - okbutton:GetTall() - ss(6) )
	function okbutton:Paint( w, h )
		surface.SetDrawColor( schema("bg") )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( schema("fg") )
		surface.DrawOutlinedRect( 0, 0, w, h, ss(1) )
		draw.SimpleText( "OK", "Benny_10", w/2, ss(2), schema_c("fg"), TEXT_ALIGN_CENTER )
	end
	function okbutton:DoClick()
		mb:Remove()
	end
end

function CreateMainMenu()
	if mm and mm:IsValid() then mm:Remove() end
	mm = vgui.Create( "BFrame" )
	mm:SetSize( ScrW(), ScrH() )
	mm:Center()
	mm:MakePopup()
	mm:SetPopupStayAtBack( true )

	mm:SetTitle("Main Menu")

	local oldpaint = mm.Paint
	function mm:Paint( w, h )
		oldpaint( self, w, h )

		draw.SimpleText( "YOUR", "Benny_48", ss(34), self:GetTall()/2 - ss(54 + (28*3)), schema_c("fg") )
		draw.SimpleText( "NAME", "Benny_48", ss(34), self:GetTall()/2 - ss(54 + (28*2)), schema_c("fg") )
		draw.SimpleText( "IS", "Benny_48", ss(34), self:GetTall()/2 - ss(54 + (28*1)), schema_c("fg") )
		draw.SimpleText( "BENNY", "Benny_72", ss(32), self:GetTall()/2 - ss(58 + (28*0)), schema_c("fg") )
	end

	local bump = -ss(32)
	for i=#meow, 1, -1 do
		local label = meow[i]
		local spacer = label == ""
		local button = mm:Add("DButton")
		button:SetText("")
		button:SetSize( ss(256), ss(spacer and 0 or 16) )
		button:SetPos( ss(32), mm:GetTall() + ss(bump) )
		function button:Paint( w, h )
			if !spacer then
				surface.SetDrawColor( schema("bg") )
				surface.DrawRect( 0, 0, w, h )
				surface.SetDrawColor( schema("fg") )
				surface.DrawOutlinedRect( 0, 0, w, h, ss(0.5) )
		
				draw.SimpleText( label, "Benny_16", ss(4+16), ss(2), schema_c("fg") )
			end
		end
		button.DoClick = unimplemented
		bump = bump - (spacer and 12 or (16+4))
	end

end

concommand.Add("benny_ui_mainmenu", function()
	CreateMainMenu()
end)