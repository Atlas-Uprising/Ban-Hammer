AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")  
include("shared.lua")

util.AddNetworkString("BanHammer_Activated")
util.AddNetworkString("BanHammer_ChatPrint")

function ENT:Initialize()

	self:SetModel("models/legoj15/ssb3ds/items/barrel0.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetColor(Color(255, 255, 255, 0))
	self:SetUseType(SIMPLE_USE)
	timer.Simple(3.5, function()
	    if IsValid(self) then
	        self:SetCollisionGroup(COLLISION_GROUP_NONE)
	        local banhammer = self:GetPhysicsObject()
	        banhammer:EnableMotion(false)
	        banhammer:Sleep()
		end
	end)

	self.lid = ents.Create("prop_dynamic")
	if not IsValid(self.lid) then return end
	self.lid:SetModel("models/legoj15/ssbb/items/dolgoldenhammer.mdl")
	self.lid:PhysicsInit(SOLID_VPHYSICS)
	self.lid:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.lid:SetParent(self)
	self.lid:SetPos(Vector(-0.25, 0.55, 55))
	self.lid:SetAngles(self:GetAngles())
	self.lid:Spawn()
	timer.Simple(3.5, function()
	    if IsValid(self.lid) then
	        self.lid:SetCollisionGroup(COLLISION_GROUP_NONE)
		end
	end)

	local phys = self:GetPhysicsObject()
	local phys2 = self.lid:GetPhysicsObject()

	if phys:IsValid() then phys:Wake() end
	if phys2:IsValid() then phys2:Wake() end
end

function ENT:Use(activator, ply)
	if self.spinning then return end
	if not ply:IsAdmin() then return end
	
	ply:Give("banhammer")
	ply:SelectWeapon("banhammer")
	
	net.Start("BanHammer_ChatPrint")
	    net.WriteEntity(ply)
	net.Broadcast()
    
	self.spinning = true
	self.lid:SetSolid(SOLID_NONE)
	
	net.Start("BanHammer_Activated")
	    net.WriteEntity(self)
	net.Broadcast()

	local light = ents.Create("prop_dynamic")
	if not IsValid(light) then return end
	light:SetModel("models/effects/vol_light64x256.mdl")
	light:PhysicsInit(SOLID_VPHYSICS)
	light:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z + 250))
	light:SetColor(Color(233, 233, 0))
	light:Spawn()
	
	self:EmitSound("timetosaygoodbye.ogg", 375, 100, 1, CHAN_AUTO)

	timer.Create("BanHammerRespawnTimer", 30, 1, function()
		BanHammer_Ents[self.Index] = nil
		self:Remove()
		light:Remove()
		ply:StripWeapon("banhammer")
		
		BanHammer_RespawnAll()
	end)
end
