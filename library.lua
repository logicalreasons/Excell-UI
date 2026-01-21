--[[
    maddy.win | Da Hood
    - Fix: Restored missing sliders (Prediction, Smoothness) and Toggles.
    - Features: Dropdowns for Body Parts (Head, Torso, etc.).
    - Library: GitHub Hosted (v4.4 Compatible)
]]

local LibraryUrl = "https://raw.githubusercontent.com/logicalreasons/Excell-UI/refs/heads/main/library.lua"
local Library = loadstring(game:HttpGet(LibraryUrl))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Global = {
    Aimbot = false,
    AimPart = "HumanoidRootPart", -- Default aim part
    
    SilentAim = false,
    SilentPart = "Closest Part", -- Default silent part
    
    Prediction = 0.135,
    Smoothness = 0.1,
    Shake = false,
    TriggerBot = false,
    TriggerDelay = 0,
    DrawFOV = false,
    FOVRadius = 100,
    BoxEsp = false
}

local CurrentTarget = nil
local FOVCircle = Drawing.new("Circle")

-- Create Window
local Window = Library:CreateWindow({
    Name = "maddy.win", 
    Accent = Color3.fromRGB(170, 100, 255)
})

local Combat = Window:CreateTab("Combat")
local Visuals = Window:CreateTab("Visuals")
local Misc = Window:CreateTab("Misc")

-- FOV Helper Function
local function AddFOVControls(Page)
    Page:CreateToggle({ Name = "Draw FOV", CurrentValue = Global.DrawFOV, Callback = function(v) Global.DrawFOV = v end })
    Page:CreateSlider({ Name = "FOV Size", Range = {50, 600}, CurrentValue = Global.FOVRadius, Callback = function(v) Global.FOVRadius = v end })
end

-- AIMBOT TAB
local AimTab = Combat:CreateSubTab("Aimbot")
AimTab:CreateKeybind({ 
    Name = "Lock Key", 
    Default = Enum.KeyCode.Q, 
    Callback = function(v) 
        Global.Aimbot = v 
        if not v then CurrentTarget=nil end 
    end 
})
-- Dropdown for Aimbot Part
AimTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"},
    CurrentOption = "HumanoidRootPart",
    Callback = function(v) Global.AimPart = v end
})
-- Restored Sliders
AimTab:CreateSlider({ Name = "Prediction", Range = {100, 200}, CurrentValue = 135, Callback = function(v) Global.Prediction = v/1000 end })
AimTab:CreateSlider({ Name = "Smoothness", Range = {1, 20}, CurrentValue = 5, Callback = function(v) Global.Smoothness = 0.5/v end })
AddFOVControls(AimTab)

-- SILENT AIM TAB
local SilentTab = Combat:CreateSubTab("Silent Aim")
SilentTab:CreateToggle({ Name = "Enabled", CurrentValue = false, Callback = function(v) Global.SilentAim = v end })
-- Dropdown for Silent Aim Part (Includes "Closest Part")
SilentTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Closest Part", "Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"},
    CurrentOption = "Closest Part",
    Callback = function(v) Global.SilentPart = v end
})
AddFOVControls(SilentTab)

-- TRIGGER BOT TAB
local TriggerTab = Combat:CreateSubTab("Trigger Bot")
TriggerTab:CreateToggle({ Name = "Enabled", CurrentValue = false, Callback = function(v) Global.TriggerBot = v end })
TriggerTab:CreateSlider({ Name = "Delay (ms)", Range = {0, 200}, CurrentValue = 0, Callback = function(v) Global.TriggerDelay = v end })
AddFOVControls(TriggerTab)

-- ESP TAB
local EspTab = Visuals:CreateSubTab("ESP Settings")
EspTab:CreateToggle({ Name = "Box ESP", CurrentValue = false, Callback = function(v) Global.BoxEsp = v end })

-- MISC TAB
local MenuTab = Misc:CreateSubTab("Menu")
MenuTab:CreateSlider({ Name = "Menu Scale", Range = {50, 150}, CurrentValue = 100, Callback = function(v) Window:SetScale(v/100) end })

-- LOGIC ENGINE
local function GetClosest()
    local MaxDist = Global.DrawFOV and Global.FOVRadius or 9999
    local Target = nil
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local KO = v.Character:FindFirstChild("BodyEffects") and v.Character.BodyEffects["K.O"].Value
            if not KO then
                local Part = v.Character:FindFirstChild("HumanoidRootPart")
                if Part then
                    local Screen, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                    if OnScreen then
                        local MouseDist = (Vector2.new(Screen.X, Screen.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if MouseDist < MaxDist then MaxDist = MouseDist; Target = v end
                    end
                end
            end
        end
    end
    return Target
end

local function GetClosestPart(Char)
    local Dist = 9999
    local Closest = nil
    local Parts = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot"}
    
    for _, Name in pairs(Parts) do
        local Part = Char:FindFirstChild(Name)
        if Part then
            local Screen = Camera:WorldToViewportPoint(Part.Position)
            local Mag = (Vector2.new(Screen.X, Screen.Y) - UserInputService:GetMouseLocation()).Magnitude
            if Mag < Dist then
                Dist = Mag
                Closest = Part
            end
        end
    end
    return Closest
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Global.DrawFOV
    FOVCircle.Radius = Global.FOVRadius
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Color = Color3.fromRGB(170, 100, 255)
    FOVCircle.Thickness = 1

    if Global.TriggerBot then
        local t = Mouse.Target
        if t and t.Parent and t.Parent:FindFirstChild("Humanoid") and t.Parent.Name ~= LocalPlayer.Name then
            task.wait(Global.TriggerDelay/1000)
            mouse1click()
        end
    end

    if Global.Aimbot then
        if not CurrentTarget then CurrentTarget = GetClosest() end
        if CurrentTarget and CurrentTarget.Character then
            -- Determine Part based on Dropdown
            local Part = CurrentTarget.Character:FindFirstChild(Global.AimPart)
            
            if Part then
                local Pred = Part.Position + (Part.Velocity * Global.Prediction)
                local Goal = CFrame.new(Camera.CFrame.Position, Pred)
                Camera.CFrame = Camera.CFrame:Lerp(Goal, Global.Smoothness)
                FOVCircle.Color = Color3.fromRGB(255, 0, 0)
            else CurrentTarget = nil end
        else CurrentTarget = nil; FOVCircle.Color = Color3.fromRGB(170, 100, 255) end
    else CurrentTarget = nil end
end)

local function AddEsp(P)
    local B = Drawing.new("Square")
    local c; c=RunService.RenderStepped:Connect(function()
        if not P.Parent then B:Remove(); c:Disconnect() return end
        if Global.BoxEsp and P.Character and P.Character:FindFirstChild("HumanoidRootPart") and P~=LocalPlayer then
            local Root = P.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            local Dist = (Camera.CFrame.Position - Root.Position).Magnitude
            if OnScreen then
                local Size = 3500 / Dist
                B.Visible=true; B.Size=Vector2.new(Size*0.6, Size); B.Position=Vector2.new(Pos.X-B.Size.X/2, Pos.Y-B.Size.Y/2); B.Color=Color3.new(1,1,1); B.Thickness=1; B.Filled=false
            else B.Visible=false end
        else B.Visible=false end
    end)
end
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then AddEsp(p) end end
Players.PlayerAdded:Connect(function(p) AddEsp(p) end)
