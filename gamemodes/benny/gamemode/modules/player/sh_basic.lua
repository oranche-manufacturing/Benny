
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_benny" )
	ply:SetModel( "models/player/combine_super_soldier.mdl" )
	ply:SetPlayerColor( Vector( 0.275, 0.2, 0.145 ) )
	ply:Give( "benny" )
end