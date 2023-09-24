
local UUID_chars = "0123456789ABCDEF"

function UUID_generate()
	local str = ""
	for i=1, 8 do
		str = str .. UUID_chars[ math.random( 1, #UUID_chars ) ]
		-- if (i%4==0 and i!=8) then
		-- 	str = str .. "-"
		-- end
	end
	return str
end