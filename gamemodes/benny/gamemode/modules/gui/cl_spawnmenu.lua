
-- Dev spawnmenu

function GM:OnSpawnMenuOpen()
end
function GM:OnSpawnMenuClose()
end

local function yea()
	return true
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
	},
	{
		Name = "Lethality",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return math.Clamp( math.Remap( class.Damage * (class.Pellets or 1), 12, 50, 0, 1 ), 0, 1 )
		end,
	},
	{
		Name = "Suppression",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			local dps = class.Damage * (1/class.Delay)
			return math.Clamp( math.Remap( dps, 50, 550, 0, 1 ), 0, 1 )
		end,
	},
	{
		Name = "Range",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return 0
		end,
	},
	{
		Name = "Precision",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return math.Clamp( math.Remap( class.Spread, 1/60, 2, 1, 0 ), 0, 1 )
		end,
	},
	{
		Name = "Control",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return math.Clamp( math.Remap( class.SpreadAdd * (1/class.Delay), 1, 13, 1, 0 ), 0, 1 )
		end,
	},
	{
		Name = "Handling",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return 0
		end,
	},
	{
		Name = "Maneuvering",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return 0
		end,
	},
	{
		Name = "Mobility",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return 0
		end,
	},
	{
		Name = "Stability",
		Size = 12,
		Font = "Benny_10",
		Stat = function( class )
			return 0
		end,
	},
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

local c_F = 184
local c_D = 184
local c_C = 90
local c_B = 60
local c_A = 12
local c_S = 0

local function rank( perc )
	local letter
	local color
	if perc <= 1/10 then
		letter = "F"

		local ler = math.Remap( perc, 0, 1/10, 0, 1 )
		color = HSVToColor( c_F, 0, .4 )
	elseif perc <= 3/10 then
		letter = "D"

		local ler = math.Remap( perc, 1/10, 3/10, 0, 1 )
		color = HSVToColor( Lerp( ler, c_F, c_D ), Lerp( ler, 0.0, 0.5 ), .4 )
	elseif perc <= 5/10 then
		letter = "C"

		local ler = math.Remap( perc, 3/10, 5/10, 0, 1 )
		color = HSVToColor( Lerp( ler, c_D, c_C ), Lerp( ler, 0.5, 0.5 ), Lerp( ler, 0.4, 0.6 ) )
	elseif perc <= 7/10 then
		letter = "B"

		local ler = math.Remap( perc, 5/10, 7/10, 0, 1 )
		color = HSVToColor( Lerp( ler, c_C, c_B ), Lerp( ler, 0.5, 0.7 ), Lerp( ler, 0.6, 0.8 ) )
	elseif perc <= 9/10 then
		letter = "A"

		local ler = math.Remap( perc, 7/10, 9/10, 0, 1 )
		color = HSVToColor( Lerp( ler, c_B, c_A ), Lerp( ler, 0.7, 0.75 ), .80 )
	elseif perc <= 1 then
		letter = "S"

		local ler = math.Remap( perc, 9/10, 1, 0, 1 )
		color = HSVToColor( Lerp( ler, c_A, c_S ), Lerp( ler, 0.75, 0.75 ), .80 )
	end
	return letter, color
end

function OpenSMenu()
	if IsValid( smenu ) then smenu:Remove() return end
	local active = GetConVar("benny_hud_tempactive"):GetString()
	smenu = vgui.Create("BFrame")
	smenu:SetSize( ss(640), ss(360) )
	smenu:SetTitle("Developer Spawnmenu")
	smenu:MakePopup()
	smenu:SetKeyboardInputEnabled( false )
	smenu:Center()

	local itemlist = smenu:Add("DScrollPanel")
	itemlist:Dock( FILL )
	smenu:Center()

	local statlist = smenu:Add("DPanel")
	statlist:SetWide( ss(320) )
	statlist:Dock( RIGHT )
	statlist:DockMargin( ss(2), 0, 0, 0 )
	statlist:DockPadding( ss(2), ss(2), ss(2), ss(2) )
	function statlist:Paint( w, h )
		surface.SetDrawColor( schema("fg") )
		surface.DrawOutlinedRect( 0, 0, w, h, ss(0.5) )
	end

	for i, us in ipairs( mewer ) do
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
					--perc = math.abs(math.sin(CurTime()*math.pi/(i^2)*10))
					--perc = (CurTime()*0.2+i/4) % 2
					--if perc > 1 then
					--	perc = 2-perc
					--end
					--perc = math.Remap( perc, 0, 1, 0.3, 0.8)
					local rank, col = rank( perc )
					surface.SetDrawColor( schema("fg") )
					surface.DrawRect( ss(60), 0, ss(1), h )
					draw.SimpleText( rank, us.Font, ss(60+4), ss(2), schema_c("fg") )
					surface.DrawRect( ss(60)+h, 0, ss(1), h )

					surface.SetDrawColor( col )
					local width = w-(ss(60+1.5)+h)
					surface.DrawRect( ss(60+1)+h, h*.125, math.max( ss(1), width*perc ), h*.75 )
					for i=1, 10 do
						if i==1 then continue end
						surface.SetDrawColor( schema("fg", i%2==1 and 0.01 or 1) )
						surface.DrawRect( ss(60)+h + width*(i-1)/10, 0, ss(1), h )
					end
				end
			end

			return true
		end
	end

	local createlist = {}
	
	for ClassName, Class in pairs( WEAPONS ) do
		if !createlist[Class.Type] then
			createlist[Class.Type] = {}
		end

		table.insert( createlist[Class.Type], { ClassName = ClassName, Class = Class } )
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