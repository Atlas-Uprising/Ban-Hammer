
surface.CreateFont("BanHammer_Font", {
	font = "Roboto", 
	size = 70,
	weight = 1000,
	antialias = true
})

local adminVision
local propTable = {}

concommand.Add("BanHammer_AddSpawn", function()
	net.Start("BanHammer_AddSpawn")
	    net.WriteVector(LocalPlayer():GetPos())
	net.SendToServer()

	net.Start("BanHammer_Update")
	net.SendToServer()
end)

concommand.Add("BanHammer_RemoveSpawn", function(ply, cmd, args)
	net.Start("BanHammer_RemoveSpawn")
	    net.WriteInt(tonumber(args[1]), 32)
	net.SendToServer()
	
	net.Start("BanHammer_Update")
	net.SendToServer()
end)

concommand.Add("BanHammer_ViewSpawns", function()
	if adminVision then return end
	
	net.Start("BanHammer_SendSpawns")
	net.SendToServer()
end)

concommand.Add("BanHammer_QuitViewSpawns", function()
	if not adminVision then return end
	
	adminVision = false
	
	hook.Remove("PostDrawOpaqueRenderables", "BanHammers_ViewSpawns")
	for k, v in pairs(propTable) do
		v:Remove()
	end
	
	propTable = {}
end)

net.Receive("BanHammer_SendSpawns",function()
	local spawns = net.ReadTable()
	adminVision = true

	hook.Add("PostDrawOpaqueRenderables", "BanHammers_ViewSpawns", function()
		for k, v in pairs(spawns) do
			local ang = Angle(0, 0, 90)
			ang:RotateAroundAxis(Vector(0, 0, 1),LocalPlayer():GetAngles().y - 90)
			cam.Start3D2D(v + Vector(0,0,75) , ang, 0.1)
				draw.RoundedBox(0, -350, 0, 760, 150, Color(23, 23, 23, 200))
				draw.DrawText("This is Ban Hammer "..k, "BanHammer_Font" , -350, 0, Color(255, 255, 255))
				draw.DrawText("BanHammer_RemoveSpawn "..k , "BanHammer_Font" , -350, 75, Color(255, 255, 255))
			cam.End3D2D()  
		end
	end)

	for k,v in pairs(spawns) do
		local box = ents.CreateClientProp("")
		box:SetPos(Vector(v.x, v.y, v.z + 6))
		box:SetColor(Color(255, 255, 255))
		box:Spawn()
		table.insert(propTable, box)
	end

end)
