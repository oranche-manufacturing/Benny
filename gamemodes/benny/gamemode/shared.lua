
-- Thing

GM.Name = "Your Name Is Benny"
GM.Author = "Fesiug, Oranche"
GM.Email = "N/A"
GM.Website = "N/A"

-- Load modules
local path = GM.FolderName .. "/gamemode/modules/"
local modules, folders = file.Find(path .. "*", "LUA")

for _, folder in SortedPairs(folders, false) do
	if folder == "." or folder == ".." then continue end

	-- Shared modules
	for _, f in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), false) do
		AddCSLuaFile(path .. folder .. "/" .. f)
		include(path .. folder .. "/" .. f)
	end

	-- Server modules
	if SERVER then
		for _, f in SortedPairs(file.Find(path .. folder .. "/sv_*.lua", "LUA"), false) do
			include(path .. folder .. "/" .. f)
		end
	end

	-- Client modules
	for _, f in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), false) do
		AddCSLuaFile(path .. folder .. "/" .. f)

		if CLIENT then
			include(path .. folder .. "/" .. f)
		end
	end
end