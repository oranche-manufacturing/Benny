
function GM:PlayerSetModel( ply )
	ply:SetModel( "models/player/group01/male_07.mdl" )
end

function GM:PlayerLoadout( ply )
	ply:Give( "benny" )
end