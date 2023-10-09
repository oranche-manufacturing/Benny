
local PT = FindMetaTable( "Player" )

function PT:INV_Get()
	if !self.INV then
		print( "Inventory created")
		self.INV = {}
	end
	return self.INV
end

do
	local translat = {
		["melee"]		= { 1, 1 },
		["special"]		= { 1, 2 },
		["pistol"]		= { 2, 1 },
		["smg"]			= { 3, 1 },
		["shotgun"]		= { 3, 2 },
		["rifle"]		= { 4, 1 },
		["machinegun"]		= { 4, 2 },
	}

	-- PROTO: Cache this!
	function PT:INV_Buckets()
		local inventorylist = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
		}
		for i, bucket in ipairs( inventorylist ) do
			local temp = {}
			for id, data in pairs( self:INV_Get() ) do
				local idata = WEAPONS[data.Class]
				local translated = translat[idata.Type]

				if i == translated[1] then
					table.insert( temp, { id, translated[2] } )
				end
			end
			table.sort( temp, function(a, b) return b[2] > a[2] end )
			for i, v in ipairs( temp ) do
				table.insert( bucket, v[1] )
			end
		end
		return inventorylist
	end
end