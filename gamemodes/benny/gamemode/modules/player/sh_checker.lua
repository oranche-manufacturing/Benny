
local easywaycvar = CreateConVar( "benny_net_easyway", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Use a disgusting way of networking inventories for maximum duplication." )
local easyway = easywaycvar:GetBool()
local UINTBITS = 8

if easyway then
	if SERVER then
		gameevent.Listen( "player_activate" )
		hook.Add( "player_activate", "Benny_Activate", function( data )
			Player(data.userid).CheckerReady = true
		end )

		local checkerinterval = 1
		util.AddNetworkString( "Benny_Checker" )

		hook.Add( "PlayerTick", "Benny_Checker", function( ply )
			if ply.CheckerReady then
				if (ply.CheckerLast or 0) + checkerinterval <= CurTime() then
					local inv = ply:INV_Get()
					net.Start( "Benny_Checker" )
						net.WriteUInt( table.Count(inv), UINTBITS )
						for i, v in pairs( inv ) do
							net.WriteString( i )
							net.WriteTable( v )
						end
					print( net.BytesWritten() )
					net.Send( ply )
					ply.CheckerLast = CurTime()
				end
			end
		end)
	else -- client begin
		net.Receive( "Benny_Checker", function( len, ply )
			local ply = LocalPlayer()
		
			local inv = ply:INV_Get()
			local amt = net.ReadUInt( UINTBITS )
			for i=1, amt do
				local id = net.ReadString()
				inv[id] = net.ReadTable()
			end
		end)
	end -- client end

else -- hardway

if SERVER then
	gameevent.Listen( "player_activate" )
	hook.Add( "player_activate", "Benny_Activate", function( data )
		Player(data.userid).CheckerReady = true
	end )

	local checkerinterval = 1
	util.AddNetworkString( "Benny_Checker" )
	util.AddNetworkString( "Benny_Checker_CL_Request" )

	hook.Add( "PlayerTick", "Benny_Checker", function( ply )
		if ply.CheckerReady then
			if (ply.CheckerLast or 0) + checkerinterval <= CurTime() then
				local inv = ply:INV_Get()
				net.Start( "Benny_Checker" )
					net.WriteUInt( table.Count(inv), UINTBITS )
					for i, v in pairs( inv ) do
						net.WriteString( i )
					end
				net.Send( ply )
				ply.CheckerLast = CurTime()
			end
		end
	end)

	net.Receive("Benny_Checker_CL_Request", function( len, ply )
		if (ply.CheckerRequestBan or 0) <= CurTime() then
			local amt = net.ReadUInt( UINTBITS )

			local inv = ply:INV_Get()
			local regenlist = {}

			-- Make sure they all exist first
			for i=1, amt do
				local id = net.ReadString()
				if inv[id] then
					table.insert( regenlist, id )
				else
					-- Punish
					print( "The item the client requested didn't exist. Malicious? Not supporting for 30 seconds." )
					ply.CheckerRequestBan = CurTime() + 30
					return
				end
			end

			net.Start("Benny_Checker_CL_Request")
				net.WriteUInt( #regenlist, UINTBITS )
				for i, id in ipairs( regenlist ) do
					if inv[id] then
						print( "Doing " .. id )
						net.WriteString( id )
						net.WriteTable( inv[id] )
					end
				end
			net.Send( ply )
		end
	end)
else
	net.Receive( "Benny_Checker", function( len, ply )
		local ply = LocalPlayer()
		-- Get started
		local amt = net.ReadUInt( UINTBITS )
		local evallist = {}
		for i=1, amt do
			evallist[net.ReadString()] = true
		end

		local inv = ply:INV_Get()

		-- Check which items DO NOT exist
		local missinglist = {}
		for i, v in pairs( evallist ) do
			if inv[i] then
				-- Success
			else
				missinglist[i] = true
			end
		end

		-- Check any ghost items we have
		local ghostlist = {}
		for i, v in pairs( inv ) do
			if evallist[i] then
				-- Success
			else
				ghostlist[i] = true
			end
		end

		-- Regenerate missing items
		if table.Count(missinglist) > 0 then
			local concat = ""
			for i, v in pairs( missinglist ) do
				concat = concat .. "'" .. i .. "' "
			end
			print( "[".. string.FormattedTime( CurTime(), "%02i:%02i") .. "] [Checker]: You are missing items " .. concat )
			net.Start( "Benny_Checker_CL_Request" )
				net.WriteUInt( table.Count( missinglist ), UINTBITS )
				for i, v in pairs( missinglist ) do
					net.WriteString( i )
				end
			net.SendToServer()
		end

		-- Remove ghost items
		for i, v in pairs( ghostlist ) do
			inv[i] = nil
			print( "[".. string.FormattedTime( CurTime(), "%02i:%02i") .. "] [Checker]: Removed a ghost item with ID '" .. i .. "'" )
		end
	end )
	net.Receive( "Benny_Checker_CL_Request", function( len, ply )
		local ply = LocalPlayer()

		local inv = ply:INV_Get()
		local amt = net.ReadUInt( UINTBITS )
		for i=1, amt do
			local id = net.ReadString()
			print( "[".. string.FormattedTime( CurTime(), "%02i:%02i") .. "] [Checker]: Restoring " .. id )
			inv[id] = net.ReadTable()
		end
	end)
end

end -- hardway