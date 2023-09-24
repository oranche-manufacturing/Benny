
local PT = FindMetaTable( "Player" )

function PT:INV_Get()
	if !self.INV then
		print( "Inventory created")
		self.INV = {}
	end
	return self.INV
end