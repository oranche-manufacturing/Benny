
-- Settings panel

-- 0 = checkbox, 1 = slider, 2 = string
local conf = {
	[1] = {
		{ 0, "benny_hud_enable_health",		"Health",			},
		{ 0, "benny_hud_enable_active",		"Active Weapon",	},
		{ 0, "benny_hud_enable_hints",		"Hints",			},
		{ 0, "benny_hud_enable_hotbar",		"Hotbar",			},
		{ 1, "benny_hud_scale",				"Scale",			1,	4,	0 },
	},
	[2] = {
		{ 0, "benny_wep_ao_firearms",		"Firearms Override Primary Attack" },
			{ 2, "Pressing Left Mouse will shoot an offhand firearm." },
		{ 0, "benny_wep_ao_grenades",		"Grenades Override Primary Attack" },
			{ 2, "Pressing Left Mouse will throw an offhand grenade." },
		{ 0, "benny_wep_ao_junk",			"Junk Override Primary Attack" },
			{ 2, "Pressing Left Mouse will throw offhand junk." },
	},
}

local function genpan( Base, Sect, Conf )
	local Scroll = Base:Add("DPanel")
	Scroll:DockPadding( 10, 5, 10, 5 )
	Scroll.Paint = function() end
	Sect:SetContents( Scroll )

	for i, v in ipairs( Conf ) do
		if v[1] == 0 then
			local Butt = Scroll:Add("DCheckBoxLabel")
			Butt:Dock(TOP)
			Butt:DockMargin( 0, 2, 0, 2 )
			Butt:SetText( v[3] )
			Butt:SetConVar( v[2] )
		elseif v[1] == 1 then
			local Butt = Scroll:Add("DNumSlider")
			Butt:Dock(TOP)
			Butt:DockMargin( 0, 2, 0, 2 )
			Butt:SetText( v[3] )
			Butt:SetConVar( v[2] )
			Butt:SetMin( v[4] )
			Butt:SetMax( v[5] )
			Butt:SetDecimals( v[6] )
		elseif v[1] == 2 then
			local Butt = Scroll:Add("DLabel")
			Butt:Dock(TOP)
			Butt:DockMargin( 40, -5, 0, 0 )
			Butt:SetText( v[2] )
		end
	end
end

function OpenSettingsMenu()
	if IsValid( SettingsMenu ) then SettingsMenu:Remove() return end
	local Base = vgui.Create("BFrame")
	SettingsMenu = Base
	Base:SetTitle("Settings")
	Base:SetSize( 800, 600 )
	Base:Center()
	Base:MakePopup()
	Base:SetKeyboardInputEnabled( false )

	do -- Sect 1
		local Sect = Base:Add("DCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:SetLabel("HUD")

		genpan( Base, Sect, conf[1] )
	end

	do -- Sect 2
		local Sect = Base:Add("DCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:SetLabel("Controls")

		genpan( Base, Sect, conf[2] )
	end
end