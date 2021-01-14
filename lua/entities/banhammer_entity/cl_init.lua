include("shared.lua")

function ENT:Initialize()
	self.spinning = false
	self.speed = 1
end

function ENT:Draw()
    if LocalPlayer():IsLineOfSightClear(self) then
	    self:DrawModel()
	end
end

function ENT:Think()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 1000 then
	    self.lid = self:GetChildren()[1]
	    if not self.spinning then return end
	    local part = self.particleSys:Add("color", self:GetPos()) 
	    part:SetDieTime(5)
	    part:SetVelocity(Vector(math.random(-100,100),math.random(-100,100),math.random(1,750)))
	    part:SetColor(math.random(50, 255), math.random(50, 255), math.random(50, 255))
	    part:SetStartSize( 3 )
	    part:SetAngleVelocity(Angle(math.random(-500, 500),math.random(-500,500),math.random(-500,500)))
	    part:SetEndSize(10) 
	    part:SetBounce(0.8)
	    part:SetCollide(true)
	    part:SetGravity(Vector(0,0, -500))
	    self.speed = self.speed + (25 * FrameTime()) 
	    if not IsValid(self.lid) then return end
	    self.lid:SetAngles(self.lid:GetAngles() + (Angle(0, self.speed,0) * FrameTime())) 
	    self.lid:SetPos(Vector(self.lid:GetPos().x, self.lid:GetPos().y, self.lid:GetPos().z + 0.03))
	end
end

net.Receive("BanHammer_Activated", function()
	local ent = net.ReadEntity()
	
	if ent:IsValid() then 
	    ent.particleSys = ParticleEmitter(ent:GetPos(), true) 
	    ent.spinning = true 
	
	    timer.Simple(30, function()
		    ent.spinning = false
		    ent.speed = 1
	    end)
	end
end)

net.Receive("BanHammer_ChatPrint",function()
	local ply = net.ReadEntity()
	
	if BanHammer_Config.ShowBanHammerPickUpText then
	    chat.AddText(Color(255, 0, 0), "[SERVER] ", Color(66, 139, 202), ply:Nick(), Color(255, 255, 255), BanHammer_Config.ActivatedText, Color(255, 215, 0), BanHammer_Config.GoldenBanHammer, Color(255, 255, 255), "!")
	end
end)
