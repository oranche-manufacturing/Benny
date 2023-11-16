
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_benny" )
	ply:SetModel( "models/player/police.mdl" )
	ply:SetViewOffset( Vector( 0, 0, 64 ) )
	ply:SetViewOffsetDucked( Vector( 0, 0, 50 ) )
	ply:SetPlayerColor( Vector( 0.275, 0.2, 0.145 ) )
	ply:Give( "benny" )

	ply:SetCrouchedWalkSpeed( 0.3 )
	ply:SetDuckSpeed( 0.1 )
	ply:SetUnDuckSpeed( 0.1 )
	ply:SetSlowWalkSpeed( 100 )
	ply:SetWalkSpeed( 160 )
	ply:SetRunSpeed( 220 )
	ply:SetStepSize( 16 )
	ply:SetCanZoom( false )
end

local PT = FindMetaTable( "Player" )

function PT:BennyCheck()
	local wep = self:GetActiveWeapon()
	return ( wep:IsValid() and wep:GetClass() == "benny" and wep.GetUserAim )
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

function PT:NoclippingAndNotVaulting()
	return (self:GetMoveType() == MOVETYPE_NOCLIP and self:GetVaultTransition() == 0)
end

function PT:INV_Get()
	if !self.INV then
		print( "Inventory created")
		self.INV = {}
	end
	return self.INV
end

function PT:INV_Discard( id )
	if self:INV_Get()[ id ] then
		self:INV_Get()[ id ] = nil
	end
end

SORTS = {
	["Acquisition"] = function( a, b ) return inv[b]["Acquisition"] > inv[a]["Acquisition"] end,
}

function PT:INV_Find( class )
	local inv = self:INV_Get()
	local results = {}
	for i, v in pairs( inv ) do
		if v.Class == class then
			table.insert( results, i )
		end
	end
	-- PROTO: HOLY SHIT THIS SUCKS, MAKES A FUNCTION EVERY FRAME, AND MIGHT RUN EVERY FRAME!!!
	table.sort( results, function( a, b ) return inv[b]["Acquisition"] > inv[a]["Acquisition"] end )
	-- table.sort( results, SORTS["Acquisition"] )
	return results
end

do
	local translat = {
		["melee"]			= { 1, 1 },
		["special"]			= { 1, 2 },
		["pistol"]			= { 2, 1 },
		["smg"]				= { 3, 1 },
		["shotgun"]			= { 4, 1 },
		["rifle"]			= { 5, 1 },
		["machinegun"]		= { 5, 2 },
		["grenade"]			= { 6, 1 },
		["utility"]			= { 6, 2 },
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
		-- PROTO: HOLY SHIT THIS SUCKS, MAKES A FUNCTION EVERY FRAME, AND RUNS EVERY FRAME!!!
		local inv = self:INV_Get()
		local function BucketSorter(a, b)
			return (inv[b[1]]["Acquisition"] + (b[2]*10000)) > (inv[a[1]]["Acquisition"] + (a[2]*10000))
		end
		for i, bucket in ipairs( inventorylist ) do
			local temp = {}
			for id, data in pairs( inv ) do
				local idata = WEAPONS[data.Class]
				local translated = translat[idata.Type]

				if i == translated[1] then
					table.insert( temp, { id, translated[2] } )
				end
			end
			table.sort( temp, BucketSorter )
			for i, v in ipairs( temp ) do
				table.insert( bucket, v[1] )
			end
		end
		return inventorylist
	end
end