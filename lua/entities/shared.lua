ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Night Vision Entity"
ENT.Author = "Your Name"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
   self:NetworkVar("Entity", 0, "Owner")
end

-- Add this line on the server side to create the network message
util.AddNetworkString("ToggleNVG")