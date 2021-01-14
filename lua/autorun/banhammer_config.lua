BanHammer_Config = {}
BanHammer_Config.Ranks = {}
-----------------------------------------------------------------
-- [ Ban Hammer - General Configuration ]
-----------------------------------------------------------------
BanHammer_Config.ShowBanHammerPickUpText = true -- Show all players in chat who picked up the Golden BanHammer
BanHammer_Config.ActivatedText = " activated the "    
BanHammer_Config.GoldenBanHammer = "Goldenen Ban-Hammer"
-- Text will look like: [SERVER] nerzlakai96 activated the Golden Ban-Hammer!

-----------------------------------------------------------------
-- [ Ban Hammer - ULX/Ulib Configuration ]
-----------------------------------------------------------------
BanHammer_Config.Ranks = { -- Ranks allowed to use the following BanHammer-Commands:
	"superadmin",          -- BanHammer_AddSpawn ; BanHammer_RemoveSpawn <number>                
	                       -- BanHammer_ViewSpawns ; BanHammer_QuitViewSpawns
}

BanHammer_Config.BanTime = 180 -- Ban time in minutes (180 minutes = 3h) ; set it to 0 if the ban shall be permanent
BanHammer_Config.BanReason = "Disobeying the rules" -- Ban reason
