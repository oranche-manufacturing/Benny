
AddCSLuaFile()

local PLAYER = {}

PLAYER.DisplayName			= "Benny Player Class"

PLAYER.SlowWalkSpeed		= 200
PLAYER.WalkSpeed			= 250
PLAYER.RunSpeed				= 280
PLAYER.CrouchedWalkSpeed	= 0.3
PLAYER.DuckSpeed			= 0.3
PLAYER.UnDuckSpeed			= 0.3
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight		= false
PLAYER.MaxHealth			= 100
PLAYER.MaxArmor				= 100
PLAYER.StartHealth			= 100
PLAYER.StartArmor			= 0
PLAYER.DropWeaponOnDie		= false
PLAYER.TeammateNoCollide	= true
PLAYER.AvoidPlayers			= true
PLAYER.UseVMHands			= true

function PLAYER:SetupDataTables()
	self.Player:NetworkVar( "Bool", 0, "Shoulder" )
	self.Player:NetworkVar( "Float", 0, "VaultDebuff" )
	
	self.Player:NetworkVar( "Float", 1, "VaultTransition" )
	self.Player:NetworkVar( "Vector", 0, "VaultPos1")
	self.Player:NetworkVar( "Vector", 1, "VaultPos2")
	
	self.Player:NetworkVar( "Float", 2, "Stamina" )

	self.Player:NetworkVar( "String", 0, "ReqID1")
	self.Player:NetworkVar( "String", 1, "ReqID2")
end

player_manager.RegisterClass( "player_benny", PLAYER, "player_default" )
