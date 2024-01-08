
-- Settings panel

-- 0 = checkbox, 1 = slider, 2 = string, 3 = binder
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
			{ 2, "Like traditional akimbo, pressing Left Mouse will shoot an offhand firearm." },
		{ 0, "benny_wep_ao_grenades",		"Grenades Override Primary Attack" },
			{ 2, "Pressing Left Mouse will throw an offhand grenade." },
		{ 0, "benny_wep_ao_junk",			"Junk Overrides Primary Attack" },
			{ 2, "Pressing Left Mouse will throw offhand junk." },
		{ 3, "benny_bind_reload",			"Reload" },
		{ 3, "benny_bind_reloada",			"Reload Alt" },
	},
	[3] = {
		{ 4, function( Scroll )
			local Butt = Scroll:Add("DLabel")
			Butt:Dock(TOP)
			Butt:DockMargin( ss(24+4), 0, 0, 0 )
			Butt:SetText( "Character Appearance" )

			local Down = Scroll:Add("DComboBox")
			Down:Dock( TOP )
			Down:DockMargin( ss(24), 0, ss(24), ss(2) )
			Down:SetValue( ConVarSV_String("tempchar") )
			Down:AddChoice( "Benny",	"benny" )
			Down:AddChoice( "Nikki",	"nikki" )
			Down:AddChoice( "Igor",		"igor" )
			Down:AddChoice( "Yang-Hao",	"yanghao" )

			Down:AddChoice( "z: CIA",		"mp_cia" )
			Down:AddChoice( "z: PLASOF",	"mp_plasof" )
			Down:AddChoice( "z: MILITIA",	"mp_militia" )
			Down:AddChoice( "z: ARNG",		"mp_natguard" )
			Down:AddChoice( "z: VIPER",		"mp_viper" )
			Down:AddChoice( "z: HALO",		"mp_halo" )
			
			function Down:OnSelect( index, value, data )
				RunConsoleCommand( "benny_tempchar", data )
				RunConsoleCommand( "benny_hud_tempactive", data )
			end
		end },

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
			Butt:DockMargin( 0, ss(2), 0, ss(2) )
			Butt:SetText( v[3] )
			Butt:SetConVar( v[2] )
		elseif v[1] == 1 then
			local Butt = Scroll:Add("DNumSlider")
			Butt:Dock(TOP)
			Butt:DockMargin( 0, ss(2), 0, ss(2) )
			Butt:SetText( v[3] )
			Butt:SetConVar( v[2] )
			Butt:SetMin( v[4] )
			Butt:SetMax( v[5] )
			Butt:SetDecimals( v[6] )
		elseif v[1] == 2 then
			local Butt = Scroll:Add("DLabel")
			Butt:Dock(TOP)
			Butt:DockMargin( ss(12), ss(-4), 0, 0 )
			Butt:SetText( v[2] )
		elseif v[1] == 3 then
			local Butt = Scroll:Add("DLabel")
			Butt:Dock(TOP)
			Butt:DockMargin( ss(24+4), 0, 0, 0 )
			Butt:SetText( v[3] )

			local Butt = Scroll:Add("DBinder")
			Butt:Dock(TOP)
			Butt:DockMargin( ss(24), 0, ss(24), ss(2) )
			Butt:SetText( v[2] )
			
			function Butt:OnChange( num )
				RunConsoleCommand( v[2], num )
			end
		elseif v[1] == 4 then
			v[2]( Scroll )
		end
	end
end

function OpenSettingsMenu()
	if IsValid( SettingsMenu ) then SettingsMenu:Remove() return end
	local Base = vgui.Create("BFrame")
	SettingsMenu = Base
	Base:SetTitle("Settings")
	Base:SetSize( ss(300), ss(300) )
	Base:Center()
	Base:MakePopup()
	Base:SetKeyboardInputEnabled( false )

	do -- Sect 1
		local Sect = Base:Add("BCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:DockMargin( 0, 0, 0, ss(2) )
		Sect:SetLabel("HUD")

		genpan( Base, Sect, conf[1] )
	end

	do -- Sect 2
		local Sect = Base:Add("BCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:DockMargin( 0, 0, 0, ss(2) )
		Sect:SetLabel("Controls")

		genpan( Base, Sect, conf[2] )
	end

	do -- Sect 3
		local Sect = Base:Add("BCollapsibleCategory")
		Sect:Dock(TOP)
		Sect:DockMargin( 0, 0, 0, ss(2) )
		Sect:SetLabel("Preferences")

		genpan( Base, Sect, conf[3] )
	end
end

concommand.Add("benny_ui_settings", function()
	OpenSettingsMenu()
end)