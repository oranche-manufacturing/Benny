
if SERVER then
	util.AddNetworkString( "Benny_StatRegen" )
	function SWEP:BSend( ... )
		net.Start( "Benny_StatRegen" )
			net.WriteUInt( #{ ... }, 4 )
			for i, v in ipairs( { ... } ) do
				net.WriteString( v[1] )
				net.WriteBool( v[2] )
				if v[2] then
					net.WriteString( v[3] )
				else
					net.WriteDouble( v[3] )
				end
			end
		net.Send( self:GetOwner() )
	end
else
	net.Receive( "Benny_StatRegen", function( len, ply )
		local count = net.ReadUInt( 4 )

		for i=1, count do
			local stat = net.ReadString()
			local str = net.ReadBool()
			local data
			if str then
				data = net.ReadString()
			else
				data = net.ReadDouble()
			end
			LocalPlayer():GetActiveWeapon():BTable()[stat] = data
		end
	end)
end