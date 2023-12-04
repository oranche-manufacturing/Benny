
-- Settings panel

-- 0 = checkbox, 1 = slider, 2 = string
local conf = {
	[1] = {
		{ "benny_hud_enable_health",	"Health",				0 },
		{ "benny_hud_enable_active",	"Active Weapon",		0 },
		{ "benny_hud_enable_hints",		"Hints",				0 },
		{ "benny_hud_enable_hotbar",	"Hotbar",				0 },
		{ "benny_hud_scale",			"Scale",				1,	1,	4,	0 },
	},
}

function OpenSettingsMenu()
	local Base = vgui.Create("DFrame")
	Base:SetTitle("Settings")
	Base:SetSize( 800, 600 )
	Base:Center()
	Base:MakePopup()

	do -- Sect 1
		local Sect = Base:Add("DCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:SetLabel("Preferences")

		local Scroll = Base:Add("DPanel")
		Scroll:DockPadding( 10, 5, 10, 5 )
		Scroll.Paint = function() end
		Sect:SetContents( Scroll )

		for i, v in ipairs( conf[1] ) do
			if v[3] == 0 then
				local Butt = Scroll:Add("DCheckBoxLabel")
				Butt:Dock(TOP)
				Butt:DockMargin( 0, 2, 0, 2 )
				Butt:SetText( v[2] )
				Butt:SetConVar( v[1] )
			elseif v[3] == 1 then
				local Butt = Scroll:Add("DNumSlider")
				Butt:Dock(TOP)
				Butt:DockMargin( 0, 2, 0, 2 )
				Butt:SetText( v[2] )
				Butt:SetConVar( v[1] )
				Butt:SetMin( v[4] )
				Butt:SetMax( v[5] )
				Butt:SetDecimals( v[6] )
			end
		end
	end

	do -- Sect 2
		local Sect = Base:Add("DCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:SetLabel("Controls")
	end

	do -- Sect 3
		local Sect = Base:Add("DCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:SetLabel("HUD")
	end
end