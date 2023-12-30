AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.BennyNPC		= true

function ENT:Nick()
	return "GEN#" .. self:EntIndex()
end

if CLIENT then
	DebugNextbot = {}
	net.Receive( "Benny_DebugNextbot", function()
		local ent = net.ReadEntity()
		if !DebugNextbot[ent] then
			DebugNextbot[ent] = {}
		end
		local t = DebugNextbot[ent]

		t.State = net.ReadString()
		t.Team = net.ReadString()
		t.Faction = net.ReadString()
		t.Rank = net.ReadUInt(8)

		t.Seeing = {}
		for i=1, net.ReadUInt(8) do
			t.Seeing[net.ReadEntity()] = true
		end

		t.Memory = {}
		for i=1, net.ReadUInt(8) do
			local memt = {}
			t.Memory[net.ReadEntity()] = memt
			for i=1, net.ReadUInt(8) do
				memt[net.ReadString()] = net.ReadType()
			end
		end
	end)
	local s = ScreenScaleH
	local function DST( text, font, x, y, color )

		for O=1, 2 do
			draw.SimpleText( text, font, x-O, y-O, color_black )
			draw.SimpleText( text, font, x, y-O, color_black )
			draw.SimpleText( text, font, x+O, y-O, color_black )

			draw.SimpleText( text, font, x-O, y, color_black )
			--draw.SimpleText( text, font, x, y, color_black )
			draw.SimpleText( text, font, x+O, y, color_black )

			draw.SimpleText( text, font, x-O, y+O, color_black )
			draw.SimpleText( text, font, x, y+O, color_black )
			draw.SimpleText( text, font, x+O, y+O, color_black )
		end

		draw.SimpleText( text, font, x, y, color )
	end
	surface.CreateFont("DNB_14", {
		font = "Bahnschrift",
		size = s(14),
	})
	surface.CreateFont("DNB_10", {
		font = "Bahnschrift",
		size = s(10),
	})
	surface.CreateFont("DNB_8", {
		font = "Bahnschrift",
		size = s(8),
	})
	surface.CreateFont("DNB_6", {
		font = "Bahnschrift",
		size = s(6),
	})
	local boost = Vector( 0, 0, 48 )
	hook.Add( "HUDPaint", "Benny_SpecialDebugNextbotView", function()
		for ent, data in pairs( DebugNextbot ) do
			if !IsValid( ent ) then
				DebugNextbot[ent] = nil
				continue
			end
			local ts = ent:GetPos()
			ts:Add(boost)
			local ts = ts:ToScreen()
			local Ox, Oy = math.floor(ts.x-s(16)), math.floor(ts.y)

			do
				local x, y = Ox, Oy

				DST( ent:Nick(), "DNB_14", x, y, color_white )
				y = y + s(12)

				DST( "RANK " .. data.Rank, "DNB_6", x, y, color_white )
				y = y + s(6)

				DST( data.Faction .. " - " .. data.Team, "DNB_6", x, y, color_white )
				y = y + s(6)

				DST( data.State, "DNB_10", x, y, color_white )
				y = y + s(10)
			end

			do
				local x, y = Ox, Oy + s(36)
				DST( "Memory:", "DNB_8", x, y, color_white )
				y = y + s(8)
				for i, v in pairs( data.Memory ) do
					if !IsValid( i ) then
						data.Memory[i] = nil
						continue
					end
					local line_y = y
					DST( "- " .. i:Nick(), "DNB_6", x+s(4), line_y, color_white )
					line_y = line_y + s(6)
					for key, value in pairs( v ) do
						local nicevalue
						if key == "LastSeenTime" then
							nicevalue = string.NiceTime( CurTime() - value ) .. " ago"
						elseif isvector( value ) then
							nicevalue = "Vector(" .. math.Round(value.x) .. ", " .. math.Round(value.y) .. ", " .. math.Round(value.z) .. ")"
						else
							nicevalue = value
						end
						DST( key, "DNB_6", x+s(4*2), line_y, color_white )
						line_y = line_y + s(4)
						DST( nicevalue, "DNB_6", x+s(4*3), line_y, color_white )
						line_y = line_y + s(6)
					end
					x = x + s(54)
				end
			end

			do
				local x, y = Ox, Oy + s(36*2)
				DST( "Seeing:", "DNB_8", x, y, color_white )
				y = y + s(8)
				for i, v in pairs( data.Seeing ) do
					if !IsValid( i ) then
						data.Seeing[i] = nil
						continue
					end
					DST( "- " .. i:Nick(), "DNB_6", x+s(8), y, color_white )
					y = y + s(6)
				end
			end

		end
	end)
	net.Receive("Benny_DebugNextbotChat", function()
		chat.AddText( Color( 200, 200, 255 ), "[" .. net.ReadEntity():Nick() .. "] ", net.ReadColor( false ), net.ReadString() )
	end)
	return
else
	util.AddNetworkString("Benny_DebugNextbot")
	util.AddNetworkString("Benny_DebugNextbotChat")
end

function ENT:DebugChat( text, color )
	net.Start("Benny_DebugNextbotChat")
		net.WriteEntity( self )
		net.WriteColor( color or Color( 200, 255, 255 ), false )
		net.WriteString( text )
	net.Broadcast()
end

function ENT:SetState( state )
	self.State = state
end

function ENT:GetState()
	return self.State
end

function ENT:RunCurrentState( func, ... )
	self.States[self:GetState()][func]( self, ... )
end

ENT.States = {
	["idle"] = {
		RunBehavior = function( self )
			--self:StartActivity( ACT_HL2MP_WALK_PASSIVE )
			--self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 100 )
			self:StartActivity( ACT_HL2MP_IDLE_RPG or ACT_HL2MP_IDLE_PASSIVE )

			coroutine.wait(5)

			coroutine.yield()
		end,
	},
	["combat"] = {
		RunBehavior = function( self )

		end,
	},
}

function ENT:BodyUpdate()
	self:BodyMoveXY()
	return
end

function ENT:OnEntitySight( ent )
	if !self.bSeeing[ent] then
		if ent.BennyNPC and ent.Faction == self.Faction then
			self:DebugChat( "Hello " .. ent:Nick() .. ".", Color( 200, 255, 200 ) )
		else
			if self.bEnemyMemory[ent] then
				local em = self.bEnemyMemory[ent]
				if CurTime()-em.LastSeenTime > 5 then
					self:DebugChat( "Eyes on " .. ent:Nick() .. "!! " .. string.NiceTime(CurTime()-em.LastSeenTime), Color( 255, 200, 100 ) )
				else
					self:DebugChat( "Reacquired " .. ent:Nick() .. "!! " .. string.NiceTime(CurTime()-em.LastSeenTime), Color( 255, 200, 100 ) )
				end
			else
				self:DebugChat( "New target " .. ent:Nick() .. "!!", Color( 255, 200, 100 ) )
			end
		end
	end
	self.bSeeing[ent] = true
end

function ENT:OnEntitySightLost( ent )
	self.bSeeing[ent] = nil
end

function ENT:Initialize()
	self:SetModel( "models/player/infoplayerrealism.mdl" )
	self.loco:SetDesiredSpeed( 100 )		-- Walk speed
	self.loco:SetStepHeight( 22 )
	self:SetShouldServerRagdoll( false )
	self:SetFOV( 45 )
	
	self:SetState("idle")

	self.Team = nil
	self.Faction = "ALPHA"

	self.bEnemyMemory = {}
	self.bSeeing = {}

	self.Rank = math.random( 0, 255 )
end

function ENT:RunBehaviour()
	while ( true ) do
		self:RunCurrentState( "RunBehavior", self )
	end
end

function ENT:OnContact( ent )
end

function ENT:Think()
	for ent, _ in pairs( self.bSeeing ) do
		if !IsValid(ent) or !_ then
			self.bSeeing[ent] = nil
			continue
		end
		if !self.bEnemyMemory[ent] then
			self.bEnemyMemory[ent] = {}
		end
		self.bEnemyMemory[ent].LastPos = ent:GetPos()
		self.bEnemyMemory[ent].LastSeenTime = CurTime()

		if ent.BennyNPC then
			if !self.Team and !ent.Team and self.Rank >= ent.Rank then
				self:DebugChat( "Duoing with " .. ent:Nick() )
				self.Team = "ALPHA_Duo_1"
				ent.Team = "ALPHA_Duo_1"
			end
		end
	end

	net.Start("Benny_DebugNextbot")
		net.WriteEntity(self)

		net.WriteString( self.State )
		net.WriteString( self.Team or "TEAMLESS" )
		net.WriteString( self.Faction )
		net.WriteUInt( self.Rank, 8 )

		net.WriteUInt( table.Count( self.bSeeing ), 8 )
		for ent, _ in pairs( self.bSeeing ) do
			net.WriteEntity( ent )
		end

		net.WriteUInt( table.Count( self.bEnemyMemory ), 8 )
		for ent, data in pairs( self.bEnemyMemory ) do
			net.WriteEntity( ent )
			net.WriteUInt( table.Count(data), 8 )
			for key, value in pairs( data ) do
				net.WriteString( key )
				net.WriteType( value )
			end
		end
	net.SendPVS(self:GetPos())
end