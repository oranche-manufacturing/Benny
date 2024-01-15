
--[[
	Your Name Is Benny
	Item definition
]]

-- Not 100% sure how metastuff works yet.

-- Global weapons table
WEAPONS = {}

function WeaponGet(class)
	return ItemDef(class)
end

-- ItemDef metatable
ItemDef = {}

ItemDefHelpers = {
	Get = function( self, key )
		return self.key
	end,
	GetRaw = function( self, key )
		return rawget( self, key )
	end,
}

function ItemDef.__index( self, key )
	if ItemDefHelpers[key] then return ItemDefHelpers[key] end
	if rawget(self, "BaseClass") then
		return rawget(self, "BaseClass")[key]
	end
end

function ItemDef:new( classname, classtable )
	if classtable then
		local newdef = classtable
		newdef.ClassName = classname
		newdef.BaseClass = WEAPONS[newdef.Base]

		setmetatable( newdef, ItemDef )
		WEAPONS[classname] = newdef
		return newdef
	else
		return WEAPONS[classname]
	end
end

function ItemDef:__tostring()
	return "ItemDef [" .. self.ClassName .. "]"
end

setmetatable( ItemDef, { __call = ItemDef.new } )