
-- Dev spawnmenu

function GM:OnSpawnMenuOpen()
end
function GM:OnSpawnMenuClose()
end

local function yea()
	return true
end

local function rmt1( val, min, max )
	return math.Remap( val, min, max, 0, 1 )
end

local function rmt1c( val, min, max )
	return math.Clamp( rmt1( val, min, max, 0, 1 ), 0, 1 )
end

local mewer = {
	{
		Func = function( class )
			return class.Name
		end,
		Size = 18,
		SizeMultiline = 18,
		Font = "Benny_18",
	},
	{
		Func = function( class )
			return class.Description
		end,
		Size = 14,
		SizeMultiline = 12,
		Font = "Benny_12",
		-- "How easily and quickly the weapon can take out a single target.\nDoes not consider armor penetration.\nAffected by Damage and RPM."
	},
	{
		Name = "Lethality",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			local bwep =  math.Clamp( math.Remap( BENNY_GetStat( class, "Damage" ) * ( BENNY_GetStat( class, "Pellets" ) or 1 ), 14, 80, 0, 1 ), 0, 1 )
			local meowzor = math.ease.OutQuart( bwep )
			return meowzor
		end,
		-- "How much the weapon's point of aim will move around.\nAffected by various Sway stats."
	},
	{
		Name = "Suppression",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			local weight_1, weight_2 = 1, 3
			local totalscore = (weight_1 + weight_2)
			weight_1, weight_2 = weight_1/totalscore, weight_2/totalscore
			local score_1, score_2 = 1, 1

			local truedelay = ( 1 / BENNY_GetStat( class, "Delay" ) )
			if BENNY_GetStat( class, "Firemodes" )[1].Mode == 1 then
				truedelay = math.min( truedelay, 60/300 )
			end
			score_1 = rmt1c( BENNY_GetStat( class, "Damage" ) * truedelay, 100, 350 )
			score_1 = score_1 * weight_1

			score_2 = rmt1c( BENNY_GetStat( class, "AmmoStd" ), 16, 42 )
			score_2 = score_2 * weight_2

			return score_1 + score_2
		end,
		-- "How much damage the weapon can output over a long period of time.\nDoes not consider armor penetration.\nAffected by Damage, RPM, Capacity and Reload Time."
	},
	-- 
	-- 	Name = "Range",
	-- 	Size = 12,
	-- 	Font = "Benny_10",
	-- 	Stat = function( class )
	-- 		return 0
	-- 	end,
	-- 	-- "How well the weapon gains or loses damage over long distances.\nAffected by Minimum Range, Maximum Range, and damage falloff."
	-- },
	{
		Name = "Precision",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return math.Clamp( math.Remap( BENNY_GetStat( class, "Spread" ), 1/60, 2, 1, 0 ), 0, 1 )
		end,
		-- "How accurate the weapon is when firing single shots or short bursts.\nAffected by Spread and various Recoil stats."
	},
	{
		Name = "Control",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return math.Clamp( math.Remap( BENNY_GetStat( class, "SpreadAdd" ) * ( 1 / BENNY_GetStat( class, "Delay" ) ), 1, 13, 1, 0 ), 0, 1 )
		end,
		-- "How managable the weapon's recoil and spread is under sustained fire.\nAffected by RPM and various Recoil stats."
	},
	-- {
	-- 	Name = "Handling",
	-- 	Size = 12,
	-- 	Font = "Benny_10",
	-- 	Stat = function( class )
	-- 		return 0
	-- 	end,
	-- 	-- "How quickly this weapon readies from sprinting, aiming and deploying.\nAffected by Aim Down Sights Time, Sprint To Fire Time, and Deploy Time."
	-- },
	--{
	--	Name = "Maneuvering",
	--	Size = 12,
	--	Font = "Benny_10",
	--	Stat = function( class )
	--		return 0
	--	end,
	--	-- "How accurate the weapon is while not aiming.\nAffected by Hipfire Spread, Mid-air Spread, Sway, and Free Aim Angle."
	--},
	{
		Name = "Mobility",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			local weight_moving, weight_aiming, weight_reloading, weight_firing = 5, 5, 2, 1
			local totalscore = (weight_moving + weight_aiming + weight_reloading + weight_firing)
			weight_moving, weight_aiming, weight_reloading, weight_firing = weight_moving/totalscore, weight_aiming/totalscore, weight_reloading/totalscore, weight_firing/totalscore

			local score_moving, score_aiming, score_reloading, score_firing = 1, 1, 1, 1

			score_moving = rmt1c( BENNY_GetStat( class, "Speed_Move" ), 0.8, 1 )
			score_moving = score_moving * weight_moving

			score_aiming = rmt1c( BENNY_GetStat( class, "Speed_Aiming" ), 0.8, .98 )
			score_aiming = score_aiming * weight_aiming

			score_reloading = rmt1c( BENNY_GetStat( class, "Speed_Reloading" ), 0.75, 0.95 )
			score_reloading = score_reloading * weight_reloading

			score_firing = rmt1c( BENNY_GetStat( class, "Speed_Firing" ), 0.75, 0.95 )
			score_firing = score_firing * weight_firing

			return score_moving + score_aiming + score_reloading + score_firing
		end,
		-- "How fast the user can move while using this weapon.\nAffected by various Speed stats."
	},
	-- {
	-- 	Name = "Stability",
	-- 	Size = 12,
	-- 	Font = "Benny_10",
	-- 	Stat = function( class )
	-- 		return 0
	-- 	end,
	-- "How much the weapon's point of aim will move around.\nAffected by various Sway stats."- },
}

local function multlinetext(text, maxw, font)
	local content = {}
	local tline = ""
	local x = 0
	surface.SetFont(font)

	local newlined = string.Split(text, "\n")

	for _, line in pairs(newlined) do
		local words = string.Split(line, " ")

		for _, word in pairs(words) do
			local tx = surface.GetTextSize(word)

			if x + tx >= maxw then
				table.insert(content, tline)
				tline = ""
				x = surface.GetTextSize(word)
			end

			tline = tline .. word .. " "

			x = x + surface.GetTextSize(word .. " ")
		end

		table.insert(content, tline)
		tline = ""
		x = 0
	end

	return content
end

local h_F, s_F, v_F = 224,		0.00, 0.40
local h_D, s_D, v_D = 180,		0.40, 0.40
local h_C, s_C, v_C = 140,		0.40, 0.50
local h_B, s_B, v_B = 40,		0.60, 0.90
local h_A, s_A, v_A = 24,		0.70, 0.90
local h_S, s_S, v_S = 0,		0.75, 0.90

local function rank( perc )
	local letter
	local color
	if perc <= 1/10 then
		letter = "F"
		color = HSVToColor(
			h_F,
			s_F,
			v_F
		)
	elseif perc <= 3/10 then
		letter = "D"
		color = HSVToColor(
			h_D,
			s_D,
			v_D
		)
	elseif perc <= 5/10 then
		letter = "C"
		color = HSVToColor(
			h_C,
			s_C,
			v_C
		)
	elseif perc <= 7/10 then
		letter = "B"
		color = HSVToColor(
			h_B,
			s_B,
			v_B
		)
	elseif perc <= 9/10 then
		letter = "A"
		color = HSVToColor(
			h_A,
			s_A,
			v_A
		)
	elseif perc <= 1 then
		letter = "S"
		color = HSVToColor(
			h_S,
			s_S,
			v_S
		)
	end
	return letter, color
end

function OpenSMenu()
	if IsValid( smenu ) then smenu:Remove() return end
	local active = GetConVar("benny_hud_tempactive"):GetString()
	smenu = vgui.Create("BFrame")
	smenu:SetSize( ss(440), ss(360) )
	smenu:SetTitle("Developer Spawnmenu")
	smenu:MakePopup()
	smenu:SetKeyboardInputEnabled( false )
	smenu:Center()

	local itemlist = smenu:Add("DScrollPanel")
	itemlist:Dock( FILL )
	smenu:Center()

	local statlist = smenu:Add("DPanel")
	statlist:SetWide( ss(440/2) )
	statlist:Dock( RIGHT )
	statlist:DockMargin( ss(2), 0, 0, 0 )
	statlist:DockPadding( ss(2), ss(2), ss(2), ss(2) )
	function statlist:Paint( w, h )
		surface.SetDrawColor( schema("fg") )
		surface.DrawOutlinedRect( 0, 0, w, h, ss(0.5) )
	end

	-- PROTO: Do regen stats.
	do
		local BAR_NAME = statlist:Add( "DLabel" )
		BAR_NAME:SetTall( ss(18) )
		BAR_NAME:Dock( TOP )
		BAR_NAME:DockMargin( 0, 0, 0, ss(2) )
		function BAR_NAME:Paint( w, h )
			surface.SetDrawColor( schema("fg") )
			surface.DrawRect( 0, 0, w, h )

			local rang = WeaponGet( pan_active )
			draw.SimpleText( rang.Name, "Benny_18", ss(2), ss(2), schema_c("bg") )
			return true
		end
	end

	do
		local BAR_DESC = statlist:Add( "DLabel" )
		BAR_DESC:SetTall( ss(18) )
		BAR_DESC:Dock( TOP )
		BAR_DESC:DockMargin( 0, 0, 0, ss(2) )
		local lastheight = 0
		function BAR_DESC:Paint( w, h )
			surface.SetDrawColor( schema("fg") )
			surface.DrawRect( 0, 0, w, h )

			local rang = WeaponGet( pan_active )
			local multiline = multlinetext( rang.Description, w-ss(2), "Benny_12" )
			for i, v in ipairs( multiline ) do
				local line = i-1
				local height = ss( 14 + (#multiline-1)*12 )
				if lastheight != height then
					BAR_DESC:SetTall( height )
					lastheight = height
				end
				draw.SimpleText( v, "Benny_12", ss(2), ss(2+12*line), schema_c("bg") )
			end

			return true
		end
	end

	for i, us in ipairs( mewer ) do
		do continue end
		local fucker = statlist:Add( "DLabel" )
		fucker:SetTall( ss(us.Size) )
		fucker:Dock( TOP )
		fucker:DockMargin( 0, 0, 0, ss(2) )
		local lastheight = 0
		function fucker:Paint( w, h )

			if us.Stat then
				surface.SetDrawColor( schema("fg") )
				surface.DrawOutlinedRect( 0, 0, w, h, ss(0.5) )
			else
				surface.SetDrawColor( schema("fg") )
				surface.DrawRect( 0, 0, w, h )
			end

			local rang = WeaponGet( pan_active )
			if rang then
				if us.SizeMultiline then
					local multiline = multlinetext( us.Func and us.Func( rang ) or us.Name, w-ss(2), us.Font )
					for i, v in ipairs( multiline ) do
						local line = i-1
						local height = ss( us.Size + ((#multiline-1)*us.SizeMultiline) )
						if lastheight != height then
							fucker:SetTall( height )
							lastheight = height
						end
						draw.SimpleText( v, us.Font, ss(2), ss(2)+ss(us.SizeMultiline*line), schema_c(us.Stat and "fg" or "bg") )
					end
				else
					draw.SimpleText( us.Func and us.Func( rang ) or us.Name, us.Font, ss(2), ss(2), schema_c(us.Stat and "fg" or "bg") )
				end
				if us.Stat then
					local perc = us.Stat( rang )
					--perc = (CurTime()*0.2+i/4) % 2
					--if perc > 1 then
					--	perc = 2-perc
					--end
					--perc = math.Remap( perc, 0, 1, 0.3, 0.8)
					local rank, col = rank( perc )
					surface.SetDrawColor( schema("fg") )
					surface.DrawRect( ss(60), 0, ss(1), h )
					draw.SimpleText( rank, us.Font, ss(60+4), ss(2), col )
					surface.DrawRect( ss(60)+h, 0, ss(1), h )

					surface.SetDrawColor( col )
					local width = w-(ss(60+1.5)+h)
					surface.DrawRect( ss(60+1)+h, ss(3), math.max( ss(1), width*perc ), h-ss(6) )
					--surface.SetDrawColor( schema("bg") )
					--surface.DrawOutlinedRect( ss(60+1)+h, ss(0.5), width, h-ss(1), ss(2) )
					for i=1, 10 do
						if i==1 then continue end
						surface.SetDrawColor( schema("fg", i%2==1 and 0.008 or 0.12) )
						surface.DrawRect( ss(60)+h + width*(i-1)/10, 0, ss(1), h )
					end
				end
			end

			return true
		end
	end

	do
		local fucker = statlist:Add( "DLabel" )
		fucker:SetTall( ss(14) )
		fucker:Dock( TOP )
		fucker:DockMargin( 0, 0, 0, ss(2) )
		function fucker:Paint( w, h )
			do return true end
			if pan_active then
				local hm = WeaponGet( pan_active )
				surface.SetDrawColor( schema("fg") )
				surface.DrawRect( 0, 0, w, h )

				draw.SimpleText( BENNY_GetStat( hm, "AmmoStd" ) .. " rounds", "Benny_12", ss(2), ss(2), schema_c("bg") )
			end
			return true
		end
	end

	do
		local fucker = statlist:Add( "DLabel" )
		fucker:SetTall( ss(14) )
		fucker:Dock( TOP )
		fucker:DockMargin( 0, 0, 0, ss(2) )
		function fucker:Paint( w, h )
			do return true end
			if pan_active then
				local hm = WeaponGet( pan_active )
				surface.SetDrawColor( schema("fg") )
				surface.DrawRect( 0, 0, w, h )

				local fm = BENNY_GetStat( hm, "Firemodes" )
				local fms = ""

				for i,v in ipairs( fm) do
					local m =v.Mode
					if m == math.huge then
						fms = fms .. "AUTO"
					elseif m == 1 then
						fms = fms .. "SEMI"
					else
						fms = fms .. m .. "-BURST"
					end
					if i != #fm then
						fms = fms .. " / "
					end
				end
				draw.SimpleText( fms, "Benny_12", ss(2), ss(2), schema_c("bg") )
			end
			return true
		end
	end

	local createlist = {}
	
	for ClassName, Class in pairs( WEAPONS ) do
		if !createlist[Class.Category] then
			createlist[Class.Category] = {}
		end

		table.insert( createlist[Class.Category], { ClassName = ClassName, Class = Class } )
	end

	for i, v in SortedPairs( createlist ) do
		local Collapse = itemlist:Add( "BCollapsibleCategory" )
		Collapse:Dock( TOP )
		Collapse:SetLabel( i )
		Collapse:SetExpanded( false )
		Collapse:DockMargin( 0, 0, 0, ss(2) )
		Collapse:DockPadding( ss(2), ss(2), ss(2), ss(2) )
		for Mew, New in ipairs( v ) do
			local button = Collapse:Add( "DButton" )
			button:SetSize( ss(96), ss(20) )
			button:DockMargin( 0, 0, 0, ss(2) )

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

			function button:Think()
				if self:IsHovered() then
					pan_active = New.ClassName
				end
			end

			function button:Paint( w, h )
				surface.SetDrawColor( schema("fg") )
				surface.DrawOutlinedRect( 0, 0, w, h, ss(1) )
				
				draw.SimpleText( self.Text_Name, "Benny_14", w/2, ss(2), schema_c("fg"), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( self.Text_Desc, "Benny_8", w/2, ss(2+8), schema_c("fg"), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				return true
			end
		end
	end

end

concommand.Add("benny_ui_spawnmenu", function()
	OpenSMenu()
end)