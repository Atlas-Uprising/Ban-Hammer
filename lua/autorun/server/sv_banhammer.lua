
BanHammer_SpawnData = {} 
BanHammer_Ents = {} 

util.AddNetworkString("BanHammer_AddSpawn")
util.AddNetworkString("BanHammer_RemoveSpawn")
util.AddNetworkString("BanHammer_SendSpawns")
util.AddNetworkString("BanHammer_Update")

function BanHammer_RespawnAll()
    for k,v in pairs(ents.FindByClass("banhammer_entity")) do
	    v:Remove()
    end

	local gathered = {}

	for k, v in pairs(BanHammer_SpawnData) do
		table.insert(gathered, v)
	end
 
    for i=1, table.Count(gathered) do
	    local index = gathered[i]
		
	    BanHammer_Ents[index] = nil
		
		if not BanHammer_Ents[index] then
		    BanHammer_Ents[index] = ents.Create("banhammer_entity")
		    BanHammer_Ents[index]:SetModel("")
		    BanHammer_Ents[index]:SetPos(index)
		    BanHammer_Ents[index]:Spawn()
		    BanHammer_Ents[index].Index = index
	    end
	end
end

hook.Add("InitPostEntity", "BanHammer_RespawnTimer", function()
    timer.Create("BanHammerSpawnDelay", 5, 1, function()
	    BanHammer_RespawnAll()
	end)
end)

hook.Add("PostCleanupMap", "RespawnBanHammerOnCleanup", function()
    BanHammer_RespawnAll()
end)

if file.Exists("banhammer/" .. game.GetMap() .. ".txt", "DATA") then
	local data = util.JSONToTable(file.Read("banhammer/"..game.GetMap()..".txt", "DATA")) 
	if data != nil then BanHammer_SpawnData = data end
else
	file.CreateDir("banhammer")
end

local function PlayerHasAccess(ply) 
	if table.HasValue(BanHammer_Config.Ranks, ply:GetUserGroup()) then return true end 
end 

local function BanHammers_Save() 
	if not file.IsDir("banhammer", "DATA") then file.CreateDir("banhammer") end
	file.Write("banhammer/"..game.GetMap()..".txt", util.TableToJSON(BanHammer_SpawnData))
end

net.Receive("BanHammer_AddSpawn", function(len, ply)
	if not PlayerHasAccess(ply) then return end
	
	table.insert(BanHammer_SpawnData, net.ReadVector())
	BanHammers_Save()
	BanHammer_RespawnAll()
end)

net.Receive("BanHammer_SendSpawns", function(len, ply)
	if not PlayerHasAccess(ply) then return end
	
	net.Start("BanHammer_SendSpawns")
	    net.WriteTable(BanHammer_SpawnData)
	net.Send(ply)
end)

net.Receive("BanHammer_RemoveSpawn", function(len, ply)
	if not PlayerHasAccess(ply) then return end
	
	local id = net.ReadInt(32)
	if not BanHammer_SpawnData[id] then return end
	
	BanHammer_SpawnData[id] = nil
	BanHammers_Save()
end)

net.Receive("BanHammer_Update", function(len, ply)
	if not PlayerHasAccess(ply) then return end
	
	ply:ConCommand("BanHammer_QuitViewSpawns")
	ply:ConCommand("BanHammer_ViewSpawns")
end)
