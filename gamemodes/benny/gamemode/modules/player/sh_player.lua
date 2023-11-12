
local PT = FindMetaTable( "Player" )

function PT:BennyCheck()
	return ( self:GetActiveWeapon():IsValid() and self:GetActiveWeapon():GetClass() == "benny" and self:GetActiveWeapon().GetUserAim )
end

function PT:CamSpot( ang )
	local w = self:GetActiveWeapon()
	if !IsValid( w ) then w = false end

	local aim = w and w:GetAim() or 0
	if w then aim = w:GetUserAim() and math.ease.OutCubic( aim ) or math.ease.InCubic( aim ) end

	local pos = self:GetPos()

	local perc = math.TimeFraction( self:GetViewOffset().z, self:GetViewOffsetDucked().z, self:GetCurrentViewOffset().z )
	pos.z = pos.z + Lerp( perc, 64, 52 )

	pos:Add( Lerp( aim, 16, 16 ) * ang:Right() )
	pos:Add( Lerp( aim, -64, -32 ) * ang:Forward() )
	pos:Add( 0 * ang:Up() )

	pos:Add( Lerp( aim, 16, 16 ) * ang:Up() * (ang.p/90) )

	local tr = util.TraceHull( {
		start = self:GetPos() + Vector( 0, 0, Lerp( perc, 64, 52 ) ),
		endpos = pos,
		mins = -Vector( 4, 4, 4 ),
		maxs = Vector( 4, 4, 4 ),
		filter = self
	})

	return tr.HitPos, ang, 90
end

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
		["shotgun"]		= { 4, 1 },
		["rifle"]		= { 5, 1 },
		["machinegun"]		= { 5, 2 },
		["grenade"]		= { 6, 1 },
		["utility"]		= { 6, 2 },
		["equipment"]		= { 7, 1 },
	}

	-- PROTO: Cache this!
	function PT:INV_Buckets()
		local inventorylist = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
			[5] = {},
			[6] = {},
			[7] = {},
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