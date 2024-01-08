
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_benny" )
	ply:SetViewOffset( Vector( 0, 0, 64 ) )
	ply:SetViewOffsetDucked( Vector( 0, 0, 50 ) )
	ply:Give( "benny" )

	ply:SetStamina( 1 )

	ply:SetCrouchedWalkSpeed( 0.3 )
	ply:SetDuckSpeed( 0.1 )
	ply:SetUnDuckSpeed( 0.1 )
	ply:SetSlowWalkSpeed( 100 )
	ply:SetWalkSpeed( 200 )
	ply:SetRunSpeed( 200 )
	ply:SetStepSize( 16 )
	ply:SetCanZoom( false )

	ply:MakeCharacter()
end

local PT = FindMetaTable( "Player" )

local bgl = {
	["benny"] = {
		[0] = Vector( 0.275, 0.7, 0.7 ),
		[1] = 17,
		[2] = 7,
		[3] = 2,
		[4] = 11,
		[5] = 3,
		[6] = 0,
		[7] = 0,
		[8] = 3,
		[9] = 0,
		[10] = 0,
		[11] = 0,
		[12] = 3,
		[13] = 0,
	},
	["nikki"] = {
		[0] = Vector( 0.9, 0.3, 0.9 ),
		[1] = 17,
		[2] = 7,
		[3] = 2,
		[4] = 11,
		[5] = 3,
		[6] = 0,
		[7] = 0,
		[8] = 2,
		[9] = 1,
		[10] = 5,
		[11] = 0,
		[12] = 3,
		[13] = 0,
	},
	["igor"] = {
		[0] = Vector( 0.776, 0.929, 0.89 ),
		[1] = 4,
		[2] = 6,
		[3] = 2,
		[4] = 3,
		[5] = 1,
		[6] = 0,
		[7] = 2,
		[8] = 3,
		[9] = 3,
		[10] = 6,
		[11] = 2,
		[12] = 1,
		[13] = 0,
	},
	["yanghao"] = {
		[0] = Vector( 0.627, 0.21, 0.186 ),
		[1] = 13,
		[2] = 2,
		[3] = 0,
		[4] = 3,
		[5] = 0,
		[6] = 1,
		[7] = 3,
		[8] = 0,
		[9] = 3,
		[10] = 4,
		[11] = 0,
		[12] = 0,
		[13] = 0,
	},
	["mp_cia"] = {
		[0] = Vector( 1, 1, 1 )
	},
	["mp_plasof"] = {
		[0] = Vector( 1, 1, 1 )
	},
	["mp_militia"] = {
		[0] = Vector( 1, 1, 1 )
	},
	["mp_natguard"] = {
		[0] = Vector( 1, 1, 1 )
	},
	["mp_viper"] = {
		[0] = Vector( 1, 1, 1 )
	},
	["mp_halo"] = {
		[0] = Vector( 1, 1, 1 )
	},
}

function PT:MakeCharacter()
	local char = ConVarSV_String("tempchar")
	self:SetModel( "models/player/infoplayerrealism.mdl" )
	self:SetPlayerColor( bgl[char][0] )
	self:SetBodygroup( 0, 0 )
	self:SetSkin( 3 )
	for i, v in ipairs( bgl[char] ) do
		self:SetBodygroup( i, v )
	end
end

function PT:BennyCheck()
	local wep = self:GetActiveWeapon()
	return ( wep:IsValid() and wep:GetClass() == "benny" and wep.GetUserAim ) and wep or false
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
		print( "Inventory created for " .. tostring(self) )
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

function PT:INV_Find( class, exclude )
	local inv = self:INV_Get()
	local results = {}
	for i, v in pairs( inv ) do
		if v.Class == class and i != (exclude or "") then
			table.insert( results, i )
		end
	end
	-- PROTO: HOLY SHIT THIS SUCKS, MAKES A FUNCTION AND MIGHT RUN EVERY FRAME!!!
	table.sort( results, function( a, b ) return inv[b]["Acquisition"] > inv[a]["Acquisition"] end )
	-- table.sort( results, SORTS["Acquisition"] )
	return results
end

local T_WEIGHT = {
	["sniper"]			= 45,
	["machinegun"]		= 40,
	["rifle"]			= 35,
	["shotgun"]			= 30,
	["smg"]				= 25,
	["pistol"]			= 20,
	["melee"]			= 15,
	["special"]			= 10,
	["utility"]			= 05,
	["equipment"]		= 00,
	["grenade"]			= -10,
	["magazine"]		= -100,
	["base"]			= -1000,
}

function PT:INV_Weight()
	local inv = self:INV_Get()
	local results = {}
	for i, v in pairs( inv ) do
		if WeaponGet(v.Class).Features != "magazine" then
			table.insert( results, { inv[i], WeaponGet(v.Class) } )
		end
	end
	-- PROTO: HOLY SHIT THIS SUCKS, MAKES A FUNCTION AND MIGHT RUN EVERY FRAME!!!
	table.sort( results, function( a, b )
		return	(T_WEIGHT[b[2]["Category"]] - b[1]["Acquisition"]*(1e-5))
		< 		(T_WEIGHT[a[2]["Category"]] - a[1]["Acquisition"]*(1e-5))
	end )
	local finale = {}
	for i, v in ipairs( results ) do
		table.insert( finale, v[1] )
	end
	return finale
end

function PT:INV_FindMag( class, exclude )
	local inv = self:INV_Get()
	local results = {}
	for i, v in pairs( inv ) do
		-- PROTO: STANAG mags and such should share, and this'll need to be changed.
		if v.Class == ("mag_" .. class) and (exclude and !exclude[i] or !exclude and true) then
			table.insert( results, i )
		end
	end
	-- PROTO: HOLY SHIT THIS SUCKS, MAKES A FUNCTION AND MIGHT RUN EVERY FRAME!!!
	table.sort( results, function( a, b ) return (inv[b]["Ammo"] - (inv[b]["Acquisition"]*(1e-5))) < (inv[a]["Ammo"] - (inv[a]["Acquisition"]*(1e-5))) end )
	return results
end

function PT:INV_FindMagSmart( class, loader )
	local inv = self:INV_Get()
	local loadm = inv[loader]

	local addexc = {}
	for i, v in pairs( inv ) do
		if v.Loaded and v.Loaded != "" then
			addexc[v.Loaded] = true
		end
	end
	local findmag = self:INV_FindMag( class, addexc )

	local f_maginv = {}
	if addexc[loadm.Loaded] or loadm.Loaded != "" then table.insert( f_maginv, loadm.Loaded ) end
	for i, v in ipairs( findmag ) do
		table.insert( f_maginv, v )
	end

	return f_maginv
end

do
	local translat = {
		["melee"]			= { 1, 1 },
		["special"]			= { 1, 2 },
		["pistol"]			= { 2, 1 },
		["smg"]				= { 3, 1 },
		["shotgun"]			= { 4, 1 },
		["sniper"]			= { 5, 1 },
		["rifle"]			= { 5, 2 },
		["machinegun"]		= { 5, 3 },
		["grenade"]			= { 6, 1 },
		["utility"]			= { 6, 2 },
		["equipment"]		= { 7, 1 },
		["magazine"]		= { 8, 1 },
		["base"]			= { 8, 2 },
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
			[8] = {},
		}
		-- PROTO: HOLY SHIT THIS SUCKS, MAKES A FUNCTION EVERY FRAME, AND RUNS EVERY FRAME!!!
		local inv = self:INV_Get()
		local function BucketSorter(a, b)
			return (inv[b[1]]["Acquisition"] + (b[2]*10000)) > (inv[a[1]]["Acquisition"] + (a[2]*10000))
		end
		for i, bucket in ipairs( inventorylist ) do
			local temp = {}
			for id, data in pairs( inv ) do
				local idata = WeaponGet(data.Class)
				local translated = translat[idata.Category]

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
	function PT:INV_ListFromBuckets()
		local buckets = self:INV_Buckets()

		local complete = {}
		for n, bucket in ipairs( buckets ) do
			for i, v in ipairs( bucket ) do
				table.insert( complete, v )
			end 
		end

		return complete
	end
end

-- weapon select

hook.Add("StartCommand", "Benny_INV_StartCommand", function( ply, cmd )
	-- local wep = ply:BennyCheck()
	-- if wep then
	-- 	local hand = wep:GetTempHandedness()
	-- 	local inv = ply:INV_Get()
	-- 	local inv_bucketlist = ply:INV_ListFromBuckets()
	-- 	local inv_bucketlist_flipped = table.Flip( inv_bucketlist )
	-- 	if CLIENT and ply.CLIENTDESIRE and inv[ply.CLIENTDESIRE ] and inv_bucketlist_flipped[ ply.CLIENTDESIRE ] then
	-- 		cmd:SetUpMove( inv_bucketlist_flipped[ ply.CLIENTDESIRE ] )
	-- 	end
	-- 	if CLIENT and (wep:bGetInvID( hand ) == ply.CLIENTDESIRE) then
	-- 		ply.CLIENTDESIRE = 0
	-- 		print("Fixed")
	-- 	end
	-- 	local id = cmd:GetUpMove()
	-- 	if id > 0 and inv_bucketlist[id] and inv[inv_bucketlist[id]] then
	-- 		wep:BDeploy( hand, inv_bucketlist[ id ] )
	-- 	end
	-- end
end)


-- cmd:KeyDown( IN_WEAPON1 )
-- cmd:KeyDown( IN_WEAPON2 )
-- cmd:KeyDown( IN_BULLRUSH )
-- cmd:KeyDown( IN_GRENADE1 )
-- cmd:KeyDown( IN_GRENADE2 )