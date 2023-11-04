if SERVER then
   AddCSLuaFile()
end

SWEP.PrintName = "Night Vision Goggles"
SWEP.Author = "[nuhm] Mikey"
SWEP.Category = "[nuhm] Mikey's Collection"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ViewModel = "models/weapons/c_arms_animations.mdl"
SWEP.WorldModel = ""
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 0, "NightVision")
end

function SWEP:Initialize()
   self:SetHoldType("normal")
end

function SWEP:Deploy()
   return true
end

function SWEP:Equip()
end

function SWEP:PrimaryAttack()
   local owner = self:GetOwner()
   if SERVER and owner:IsPlayer() then
       local nightVisionEnabled = not self:GetNightVision()
       self:SetNightVision(nightVisionEnabled)
       if nightVisionEnabled then
           owner:SetNWBool("WearingNVG", true)
           net.Send(owner)
           owner:ScreenFade(1, color_white, 0.5, 0.2)
           owner:EmitSound("items/nvg_on.wav")
       else
           owner:SetNWBool("WearingNVG", false)
           net.Send(owner)
           owner:ScreenFade(1, color_black, 0.5, 0.2)
           owner:EmitSound("items/nvg_off.wav")
       end
   end
end

function SWEP:SecondaryAttack()
end

local function DrawNightVisionOverlay()
   if nightVisionEnabled then
       local ply = LocalPlayer()
       if ply and ply:IsValid() then
           local tr = ply:GetEyeTraceNoCursor()
           render.SetMaterial(Material("models/props_lab/securitycam"))
           render.DrawScreenQuad()
       end
   end
end

hook.Add("HUDPaint", "DrawNightVisionOverlay", DrawNightVisionOverlay)
