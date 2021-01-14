BanHammer_Config = {}
BanHammer_Config.Ranks = {}
-----------------------------------------------------------------
-- [ Ban Hammer - General Configuration ]
-----------------------------------------------------------------
BanHammer_Config.ShowBanHammerPickUpText = true -- Show all players in chat who picked up the Golden BanHammer
BanHammer_Config.ActivatedText = " activated the "    
BanHammer_Config.GoldenBanHammer = "Golden Ban-Hammer"

--[[---------------------------------------------------------------
 [ Ban Hammer - Rank Configuration ]
 Setting the ranks below can do the following commands:
 BanHammer_AddSpawn 
 BanHammer_RemoveSpawn <number>                
 BanHammer_ViewSpawns
 BanHammer_QuitViewSpawns
-----------------------------------------------------------------]]
BanHammer_Config.Ranks = {
	"superadmin",           
}

BanHammer_Config.BanTime = 180 -- Ban time in minutes (180 minutes = 3h) ; set it to 0 if the ban shall be permanent
BanHammer_Config.BanReason = "Rule Violation" -- Ban reason
