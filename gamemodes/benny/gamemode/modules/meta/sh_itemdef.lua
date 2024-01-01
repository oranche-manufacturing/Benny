
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

function ItemDef.__index( self, key )
	if rawget(self, "BaseClass") then
		return rawget(self, "BaseClass")[key]
	end
end

function ItemDef:new( classname, classtable )
	if classtable then
		local newdef = classtable
		newdef.ClassName = classname
		newdef.BaseClass = WEAPONS[newdef.Base]

		WEAPONS[classname] = newdef

		setmetatable( newdef, ItemDef )
		return newdef
	else
		return WEAPONS[classname]
	end
end

function ItemDef:__tostring()
	return "ItemDef [" .. self.ClassName .. "]"
end

setmetatable( ItemDef, { __call = ItemDef.new } )