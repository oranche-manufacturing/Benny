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
				local x, y = Ox, Oy + s(36*3)
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
	if self.State != state then
		self:RunCurrentState( "Disable", state )
		local oldstate = self.State
		self.State = state
		self:RunCurrentState( "Enable", oldstate )
	end
end

function ENT:GetState()
	return self.State
end

function ENT:RunCurrentState( func, ... )
	if self:GetState() then
		self.States[self:GetState()][func]( self, ... )
	end
end

ENT.States = {
	["idle"] = {
		RunBehavior = function( self )
			self:StartActivity( ACT_HL2MP_IDLE_PASSIVE )
			coroutine.yield()
		end,
		Enable = function( self, from )
			-- Holster
			self:AddGestureSequence( self:SelectWeightedSequence(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND) )
			if from then
				self:DebugChat( "Entering idle from " .. from, Color( 100, 255, 100 ) )
			end
		end,
		Disable = function( self, to )
			-- Draw
			self:AddGestureSequence( self:SelectWeightedSequence(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND) )
			self:DebugChat( "Entering " .. to .. " from idle", Color( 100, 255, 100 ) )
		end,
	},
	["combat"] = {
		RunBehavior = function( self )
			local re = self:RecentEnemy()
			if re then
				if self.bSeeing[re] then
					self.loco:FaceTowards( re:GetPos() )
					self:StartActivity( ACT_HL2MP_IDLE_AR2 )

					if (self.NextFire or 0) <= CurTime() then
						local rp = RecipientFilter()
						rp:AddAllPlayers()
						self:EmitSound("benny/weapons/usp/01.ogg", 100, 100, 0.2, nil, nil, nil, rp )
						--self:FireBullets( {
						--	Attacker = self,
						--	Inflictor = self,
						--	Damage = 0,
						--	Dir = self:EyeAngles():Forward(),
						--	Src = self:EyePos()
						--} )
						self.NextFire = CurTime() + 0.5
					end
				else
					self.loco:SetDesiredSpeed( 200 )
					self:StartActivity( ACT_HL2MP_WALK_RPG )
					
					local em = self.bEnemyMemory[re]
					if em and em.GoToLastKnown and em.GoToLastKnown != true then
						local result = self:MoveToPos( em.GoToLastKnown, { lookahead = 100, tolerance = 32, draw = true, repath = 0.5 } )
						if result == "ok" then
							em.GoToLastKnown = true
							self:DebugChat("Went to last known position of " .. re:Nick())
						elseif result == "stuck" then
							em.GoToLastKnown = true
							self:DebugChat("Failed to go to last known position of " .. re:Nick() .. " at " .. tostring(self:GetPos()))
						else
							em.GoToLastKnown = true
							self:DebugChat("Unknown state " .. result .. " while going to " .. re:Nick() .. " at " .. tostring(self:GetPos()))
						end
					elseif em and em.GoToLastKnown == true then
						self:DebugChat("Investigated " .. re:Nick() .. "'s last known position, it's clear." )
						self:SetState("idle")
						self:EmitSound( "benny/dev/lostem.ogg", 90, 100, 1 )
					end
				end
			end

			coroutine.yield()
		end,
		Enable = function( self, from )
		end,
		Disable = function( self, to )
		end,
	},
}

function ENT:BodyUpdate()
	local target = self:RecentEnemy()
	if target then
		-- Without this +64z, they stare straight up. It's eye level now, I guess.
		local a = self:EyePos() - (self.bSeeing[target] and target:EyePos() or self.bEnemyMemory[target].LastPos + Vector(0,0,64))
		a:Normalize()
		a = a:Angle()
		self:SetPoseParameter( "aim_yaw", 0 or a.y )
		local r1, r2 = self:GetPoseParameterRange( self:LookupPoseParameter( "aim_pitch" ) )
		self:SetPoseParameter( "aim_pitch", math.Clamp( -a.p, r1, r2 ) )
	end
	--self:SetPoseParameter( "move_x", 1 )
	--self:SetPoseParameter( "move_y", 1 )
	--self:SetPlaybackRate(1)
	--self:FrameAdvance()
	self:BodyMoveXY()
	return
end

function ENT:OnEntitySight( ent )
	if !self.bSeeing[ent] then
		if ent.BennyNPC and ent.Faction == self.Faction then
			if self.bEnemyMemory[ent] then
			else
				self:DebugChat( "Hello " .. ent:Nick() .. ".", Color( 200, 255, 200 ) )
			end
		else
			if self.bEnemyMemory[ent] then
				local em = self.bEnemyMemory[ent]
				if CurTime()-em.LastSeenTime > 3 then
					self:DebugChat( "Been a while " .. ent:Nick() .. "!! " .. string.NiceTime(CurTime()-em.LastSeenTime), Color( 255, 200, 100 ) )
					self.NextFire = CurTime() + 0.5
					self:EmitSound( "benny/dev/therehis.ogg", 90, 100, 1 )
				else
					self:DebugChat( "Resighted " .. ent:Nick() .. "! " .. string.NiceTime(CurTime()-em.LastSeenTime), Color( 255, 200, 100 ) )
					self.NextFire = CurTime() + 0.25
				end
			else
				self:DebugChat( "New target " .. ent:Nick() .. "!!", Color( 255, 200, 100 ) )
				self:EmitSound( "benny/dev/target.ogg", 90, 100, 1 )
			end
			self:SetState("combat")
		end
	end
	self.bSeeing[ent] = true
end

function ENT:OnEntitySightLost( ent )
	self.bSeeing[ent] = nil
end

local wide, tall = 12/2, 64
local b1 = Vector( wide, wide, tall )
local b2 = Vector( -wide, -wide, 0 )

local wide, tall = 48/2, 96
local s1 = Vector( wide, wide, tall )
local s2 = Vector( -wide, -wide, 0 )

function ENT:Initialize()
	self:SetModel( "models/player/infoplayerrealism.mdl" )
	self:SetCollisionBounds( b1, b2 )
	self:SetSurroundingBounds( s1, s2 )
	self.loco:SetDesiredSpeed( 100 )		-- Walk speed
	self.loco:SetStepHeight( 22 )
	self:SetShouldServerRagdoll( false )
	self:SetFOV( 90 )
	
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

function ENT:TopEnemy()
	for ent, _ in pairs( self.bSeeing ) do
		if ent.BennyNPC and ent.Faction != self.Faction or !ent.BennyNPC then
			return ent
		end
	end
end

function ENT:RecentEnemy()
	for ent, data in SortedPairsByMemberValue( self.bEnemyMemory, "LastSeenTime" ) do
		if ent.BennyNPC and ent.Faction != self.Faction or !ent.BennyNPC then
			return ent
		end
	end
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
		local t = self.bEnemyMemory[ent]
		t.LastPos = ent:GetPos()
		t.LastSeenTime = CurTime()
		t.GoToLastKnown = false

		if ent.BennyNPC then
			if !self.Team and !ent.Team and self.Rank >= ent.Rank then
				self:DebugChat( "Duoing with " .. ent:Nick() )
				self:EmitSound( "benny/dev/yourewithme.ogg", 90, 100, 1 )
				self.Team = "ALPHA_Duo_1"
				ent.Team = "ALPHA_Duo_1"
			end
		end
	end

	if self:GetState() == "combat" then
		for ent, data in pairs( self.bEnemyMemory ) do
			if !IsValid(ent) then
				print("wtf")
				self.bEnemyMemory[ent] = nil
				continue
			end
			if self.Faction != ent.Faction and !data.GoToLastKnown and data.LastSeenTime+5 < CurTime() then
				data.GoToLastKnown = Vector(data.LastPos)
				self:DebugChat( "Investigating " .. ent:Nick() .. "'s last known position" )
				self:EmitSound( "benny/dev/immoving.ogg", 90, 100, 1 )
				--self:SetState("idle")
			end
		end
	end

	net.Start( "Benny_DebugNextbot", true )
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