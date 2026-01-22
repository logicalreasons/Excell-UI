--[[
    maddy.win | Da Hood (Workspace Folder Update)
    - Feature: Configs are now saved inside a "maddy" folder in Workspace.
    - Fix: Cleaner file management.
]]

local LibraryUrl = "https://raw.githubusercontent.com/logicalreasons/Excell-UI/refs/heads/main/library.lua?v="..tostring(math.random(1, 10000))
local Library = loadstring(game:HttpGet(LibraryUrl))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- [[ CONFIG FOLDER SETUP ]]
local ConfigFolder = "maddy"
if not isfolder(ConfigFolder) then
    makefolder(ConfigFolder)
end

local Global = {
    Aimbot = false,
    AimPart = "HumanoidRootPart",
    SilentAim = false,
    SilentPart = "Closest Part",
    Prediction = 0.135,
    Smoothness = 0.1,
    TriggerBot = false,
    TriggerDelay = 0,
    DrawFOV = false,
    FOVRadius = 100,
    BoxEsp = false
}

local UI = {} 
local CurrentTarget = nil
local FOVCircle = Drawing.new("Circle")

-- Create Window
local Window = Library:CreateWindow({ Name = "maddy.win", Accent = Color3.fromRGB(170, 100, 255) })

local Combat = Window:CreateTab("Combat")
local Visuals = Window:CreateTab("Visuals")
local Configs = Window:CreateTab("Configs")
local Settings = Window:CreateTab("Settings")

-- [[ COMBAT ]]
local AimTab = Combat:CreateSubTab("Aimbot")
AimTab:CreateKeybind({ Name = "Lock Key", Default = Enum.KeyCode.Q, Callback = function(v) Global.Aimbot = v; if not v then CurrentTarget=nil end end })
UI.AimPart = AimTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"}, CurrentOption = Global.AimPart, Callback = function(v) Global.AimPart = v end })
UI.Prediction = AimTab:CreateSlider({ Name = "Prediction", Range = {100, 200}, CurrentValue = Global.Prediction*1000, Callback = function(v) Global.Prediction = v/1000 end })
UI.Smoothness = AimTab:CreateSlider({ Name = "Smoothness", Range = {1, 20}, CurrentValue = 5, Callback = function(v) Global.Smoothness = 0.5/v end })
UI.DrawFOV = AimTab:CreateToggle({ Name = "Draw FOV", CurrentValue = Global.DrawFOV, Callback = function(v) Global.DrawFOV = v end })
UI.FOVRadius = AimTab:CreateSlider({ Name = "FOV Size", Range = {50, 600}, CurrentValue = Global.FOVRadius, Callback = function(v) Global.FOVRadius = v end })

local SilentTab = Combat:CreateSubTab("Silent Aim")
UI.SilentAim = SilentTab:CreateToggle({ Name = "Enabled", CurrentValue = Global.SilentAim, Callback = function(v) Global.SilentAim = v end })
UI.SilentPart = SilentTab:CreateDropdown({ Name = "Target Part", Options = {"Closest Part", "Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"}, CurrentOption = Global.SilentPart, Callback = function(v) Global.SilentPart = v end })

local TriggerTab = Combat:CreateSubTab("Trigger Bot")
UI.TriggerBot = TriggerTab:CreateToggle({ Name = "Enabled", CurrentValue = Global.TriggerBot, Callback = function(v) Global.TriggerBot = v end })
UI.TriggerDelay = TriggerTab:CreateSlider({ Name = "Delay (ms)", Range = {0, 200}, CurrentValue = Global.TriggerDelay, Callback = function(v) Global.TriggerDelay = v end })

-- [[ VISUALS ]]
local EspTab = Visuals:CreateSubTab("ESP Settings")
UI.BoxEsp = EspTab:CreateToggle({ Name = "Box ESP", CurrentValue = Global.BoxEsp, Callback = function(v) Global.BoxEsp = v end })

-- [[ CONFIGS ]]
local ConfigTab = Configs:CreateSubTab("Manager")
local CurrentConfigName = ""
local SelectedConfig = ""

local function GetConfigFiles()
    local Files = {}
    if listfiles then
        for _, File in pairs(listfiles(ConfigFolder)) do
            if File:sub(-5) == ".json" then
                -- Strip folder path and extension to get clean name
                local Name = File:match("([^/]+)%.json$") or File:match("([^\\]+)%.json$")
                if Name then table.insert(Files, Name) end
            end
        end
    end
    if #Files == 0 then return {"None"} end
    return Files
end

ConfigTab:CreateTextBox({ Name = "New Config Name", Placeholder = "Type name...", Callback = function(val) CurrentConfigName = val end })

ConfigTab:CreateButton({ Name = "Save Config", Callback = function()
    if CurrentConfigName == "" then return end
    local Json = HttpService:JSONEncode(Global)
    writefile(ConfigFolder .. "/" .. CurrentConfigName .. ".json", Json)
    UI.ConfigList:Refresh(GetConfigFiles())
end })

UI.ConfigList = ConfigTab:CreateDropdown({ 
    Name = "Select Config", 
    Options = GetConfigFiles(), 
    CurrentOption = "None",
    Callback = function(v) SelectedConfig = v end 
})

ConfigTab:CreateButton({ Name = "Load Selected", Callback = function()
    if SelectedConfig == "" or SelectedConfig == "None" then return end
    local Path = ConfigFolder .. "/" .. SelectedConfig .. ".json"
    if isfile(Path) then
        local Data = HttpService:JSONDecode(readfile(Path))
        for k,v in pairs(Data) do Global[k] = v end
        
        -- Update UI
        if UI.AimPart then UI.AimPart:Set(Global.AimPart) end
        if UI.Prediction then UI.Prediction:Set(Global.Prediction*1000) end
        if UI.Smoothness then UI.Smoothness:Set(0.5/Global.Smoothness) end
        if UI.DrawFOV then UI.DrawFOV:Set(Global.DrawFOV) end
        if UI.FOVRadius then UI.FOVRadius:Set(Global.FOVRadius) end
        if UI.SilentAim then UI.SilentAim:Set(Global.SilentAim) end
        if UI.SilentPart then UI.SilentPart:Set(Global.SilentPart) end
        if UI.TriggerBot then UI.TriggerBot:Set(Global.TriggerBot) end
        if UI.TriggerDelay then UI.TriggerDelay:Set(Global.TriggerDelay) end
        if UI.BoxEsp then UI.BoxEsp:Set(Global.BoxEsp) end
    end
end })

ConfigTab:CreateButton({ Name = "Refresh List", Callback = function()
    UI.ConfigList:Refresh(GetConfigFiles())
end })

-- [[ SETTINGS ]]
local MainSettings = Settings:CreateSubTab("Main")
MainSettings:CreateSlider({ Name = "Menu Scale", Range = {50, 150}, CurrentValue = 100, Callback = function(v) Window:SetScale(v/100) end })
MainSettings:CreateButton({ Name = "Unload Script", Callback = function() Window:Unload() end })

-- [[ LOGIC ENGINE ]]
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

local function GetClosestBodyPart(Char)
    local Dist = 9999
    local Closest = nil
    local Parts = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot"}
    for _, Name in pairs(Parts) do
        local Part = Char:FindFirstChild(Name)
        if Part then
            local Screen, OnScreen = Camera:WorldToViewportPoint(Part.Position)
            if OnScreen then
                local Mag = (Vector2.new(Screen.X, Screen.Y) - UserInputService:GetMouseLocation()).Magnitude
                if Mag < Dist then
                    Dist = Mag
                    Closest = Part
                end
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

    if Global.Aimbot or Global.SilentAim then
        if not CurrentTarget then CurrentTarget = GetClosest() end
        if CurrentTarget and CurrentTarget.Character then
            local Part = nil
            if Global.SilentAim then
                if Global.SilentPart == "Closest Part" then Part = GetClosestBodyPart(CurrentTarget.Character) else Part = CurrentTarget.Character:FindFirstChild(Global.SilentPart) end
            elseif Global.Aimbot then
                Part = CurrentTarget.Character:FindFirstChild(Global.AimPart)
            end

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
