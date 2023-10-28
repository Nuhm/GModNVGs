-- Night Vision effect shader
local nightVisionShader = Material("vignette/vignette")

-- This is the default value when night vision is off
local nightVisionEnabled = false

local nightVisionLight = nil

-- Create a dynamic light for the player's view
local function CreateNightVisionLight()
    local player = LocalPlayer()
    if not IsValid(player) then return end

    local lightModel = ents.CreateClientProp("models/props_c17/light_bulkhead.mdl")
    lightModel:SetPos(player:GetPos() + Vector(0, 0, 10))  -- Adjust the position as needed
    lightModel:SetParent(player)
    lightModel:SetNoDraw(true)
    lightModel:Spawn()
    lightModel:SetRenderMode(RENDERMODE_TRANSALPHA)

    nightVisionLight = lightModel

    return nightVisionLight
end

local function CreateDynamicLight()
   if nightVisionEnabled then
       local ply = LocalPlayer()
       if ply and ply:IsValid() then
           local plyPos = ply:GetPos() + Vector(0, 0, 10) -- Adjust the Vector values as needed to position the light correctly
           local dlight = DynamicLight(1)
           if dlight then
               dlight.Pos = plyPos
               dlight.r = 19
               dlight.g = 194
               dlight.b = 107
               dlight.Brightness = 7
               dlight.Size = 700
               dlight.Decay = 6000
               dlight.DieTime = CurTime() + 1
               dlight.Style = 0
           end
       end
   end
end


hook.Add("Think", "CreateDynamicLight", CreateDynamicLight)


-- Define your night vision toggle function
local function ToggleNightVision(ply)
    if nightVisionEnabled then
        nightVisionEnabled = false
        if IsValid(nightVisionLight) then
            nightVisionLight:Remove()
        end
    else
        nightVisionEnabled = true
        nightVisionLight = CreateNightVisionLight()
    end
end

-- Add the left-click functionality to your SWEP (weapon)

function ToggleNightVisionSWEP(ply)
   if CLIENT then
       local weapon = ply:GetActiveWeapon()
       if IsValid(weapon) and weapon:GetClass() == "weapon_nightvision" then
           ToggleNightVision(ply)
       end
   end
end

hook.Add("KeyPress", "ToggleNightVisionSWEP", function(ply, key)
   if key == IN_ATTACK and CLIENT then
       local weapon = ply:GetActiveWeapon()
       if IsValid(weapon) and weapon:GetClass() == "weapon_nightvision" then
           ToggleNightVisionSWEP(ply)
       end
   end
end)

-- Modify the DrawHUD function to apply the night vision shader and light effect
hook.Add("HUDPaint", "DrawNightVision", function()
   if nightVisionEnabled then
       cam.Start2D()
       cam.IgnoreZ(true)
       surface.SetMaterial(nightVisionShader)  -- Your NVG shader material
       surface.SetDrawColor(255, 255, 255, 255)
       surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
       cam.IgnoreZ(false)
       cam.End2D()
   end
end)