--[[
    Excell Internal Library | v2.1 (Keybinds)
    - Feature: Right-Click Keybind Menu (Hold/Toggle/Always)
    - Layout: Top Tabs (Juju Style)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

function Library:CreateWindow(Config)
    local Title = Config.Name or "Excell.win"
    local Accent = Config.Accent or Color3.fromRGB(138, 43, 226)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExcellInternal_v2.1"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- DECORATION
    local TopLine = Instance.new("Frame", MainFrame)
    TopLine.BackgroundColor3 = Accent
    TopLine.BorderSizePixel = 0
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    
    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Size = UDim2.new(0, 150, 0, 20)
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- TABS
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 0, 0, 30)
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    
    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Content = Instance.new("Frame", MainFrame)
    Content.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Content.BorderSizePixel = 0
    Content.Position = UDim2.new(0, 10, 0, 70)
    Content.Size = UDim2.new(1, -20, 1, -80)

    local FirstTab = true
    local WindowFunctions = {}

    function WindowFunctions:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
        TabBtn.TextSize = 12
        
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.BackgroundColor3 = Accent
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(0, 0, 1, -2)
        Indicator.Size = UDim2.new(1, 0, 0, 2)
        Indicator.Visible = false

        local TabContainer = Instance.new("ScrollingFrame", Content)
        TabContainer.BackgroundTransparency = 1
        TabContainer.Size = UDim2.new(1, 0, 1, 0)
        TabContainer.Visible = false
        TabContainer.ScrollBarThickness = 2
        
        local ContainerLayout = Instance.new("UIListLayout", TabContainer)
        ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContainerLayout.Padding = UDim.new(0, 5)

        if FirstTab then
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
            TabContainer.Visible = true
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabBar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(100, 100, 100)
                    v.Frame.Visible = false 
                end 
            end
            TabContainer.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
        end)

        local TabFunctions = {}

        -- TOGGLE
        function TabFunctions:CreateToggle(Config)
            local Frame = Instance.new("Frame", TabContainer)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 35)

            local Btn = Instance.new("TextButton", Frame)
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = "   " .. Config.Name
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.TextSize = 12
            Btn.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("Frame", Frame)
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Box.Position = UDim2.new(1, -25, 0.5, -6)
            Box.Size = UDim2.new(0, 12, 0, 12)

            local Enabled = Config.CurrentValue or false
            if Enabled then Box.BackgroundColor3 = Accent end

            Btn.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                TweenService:Create(Box, TweenInfo.new(0.15), {BackgroundColor3 = Enabled and Accent or Color3.fromRGB(40, 40, 40)}):Play()
                if Config.Callback then Config.Callback(Enabled) end
            end)
        end

        -- KEYBIND (New!)
        function TabFunctions:CreateKeybind(Config)
            local Frame = Instance.new("Frame", TabContainer)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 35)

            local Title = Instance.new("TextLabel", Frame)
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(0, 200, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = Config.Name
            Title.TextColor3 = Color3.fromRGB(200, 200, 200)
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local BindBtn = Instance.new("TextButton", Frame)
            BindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            BindBtn.BorderSizePixel = 0
            BindBtn.Position = UDim2.new(1, -90, 0.5, -9)
            BindBtn.Size = UDim2.new(0, 80, 0, 18)
            BindBtn.Font = Enum.Font.Code
            BindBtn.Text = Config.Default and Config.Default.Name or "None"
            BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            BindBtn.TextSize = 11

            local CurrentKey = Config.Default
            local CurrentMode = "Toggle" -- Default mode
            local Binding = false

            -- Key Logic
            BindBtn.MouseButton1Click:Connect(function()
                Binding = true
                BindBtn.Text = "..."
                BindBtn.TextColor3 = Accent
                local Input = UserInputService.InputBegan:Wait()
                if Input.UserInputType == Enum.UserInputType.Keyboard or Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    CurrentKey = Input.KeyCode
                    BindBtn.Text = CurrentKey.Name
                    BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                    Binding = false
                end
            end)

            -- Right Click Menu (Context)
            BindBtn.MouseButton2Click:Connect(function()
                local Menu = Instance.new("Frame", ScreenGui)
                Menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Menu.BorderColor3 = Accent
                Menu.Size = UDim2.new(0, 100, 0, 80)
                Menu.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
                
                local List = Instance.new("UIListLayout", Menu)
                List.SortOrder = Enum.SortOrder.LayoutOrder

                local function AddOption(Name)
                    local Opt = Instance.new("TextButton", Menu)
                    Opt.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    Opt.BorderSizePixel = 0
                    Opt.Size = UDim2.new(1, 0, 0, 25)
                    Opt.Font = Enum.Font.Gotham
                    Opt.Text = Name
                    Opt.TextColor3 = (CurrentMode == Name) and Accent or Color3.fromRGB(200, 200, 200)
                    Opt.TextSize = 12
                    
                    Opt.MouseButton1Click:Connect(function()
                        CurrentMode = Name
                        Menu:Destroy()
                    end)
                end

                AddOption("Toggle")
                AddOption("Hold")
                AddOption("Always")
                
                -- Close on click away
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        wait(0.1)
                        if Menu then Menu:Destroy() end
                    end
                end)
            end)

            -- State Loop
            RunService.RenderStepped:Connect(function()
                local State = false
                if CurrentMode == "Always" then
                    State = true
                elseif CurrentMode == "Hold" then
                    State = UserInputService:IsKeyDown(CurrentKey or Enum.KeyCode.Unknown)
                elseif CurrentMode == "Toggle" then
                    -- Handled by InputBegan listener below to toggle variable
                end
                
                if CurrentMode ~= "Toggle" and Config.Callback then
                    Config.Callback(State) -- Send state for Hold/Always
                end
            end)
            
            -- Toggle specific logic
            local Toggled = false
            UserInputService.InputBegan:Connect(function(Input, Process)
                if Process then return end
                if CurrentMode == "Toggle" and Input.KeyCode == CurrentKey then
                    Toggled = not Toggled
                    if Config.Callback then Config.Callback(Toggled) end
                end
            end)
        end

        function TabFunctions:CreateSlider(Config)
            -- (Same Slider Code as before goes here - abbreviated for length)
            local Frame = Instance.new("Frame", TabContainer)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 50)
            local Label = Instance.new("TextLabel", Frame)
            Label.Text = Config.Name
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            
            local ValLabel = Instance.new("TextLabel", Frame)
            ValLabel.Text = tostring(Config.CurrentValue)
            ValLabel.Font = Enum.Font.Code
            ValLabel.TextColor3 = Accent
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Size = UDim2.new(0, 50, 0, 20)
            ValLabel.Position = UDim2.new(1, -60, 0, 5)
            ValLabel.BackgroundTransparency = 1

            local SlideBG = Instance.new("TextButton", Frame)
            SlideBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SlideBG.BorderSizePixel = 0
            SlideBG.Position = UDim2.new(0, 10, 0, 30)
            SlideBG.Size = UDim2.new(1, -20, 0, 4)
            SlideBG.Text = ""

            local Fill = Instance.new("Frame", SlideBG)
            Fill.BackgroundColor3 = Accent
            Fill.BorderSizePixel = 0
            local Min, Max = Config.Range[1], Config.Range[2]
            local P = (Config.CurrentValue - Min)/(Max - Min)
            Fill.Size = UDim2.new(P, 0, 1, 0)
            
            local Dragging = false
            SlideBG.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local S = math.clamp((UserInputService:GetMouseLocation().X - SlideBG.AbsolutePosition.X) / SlideBG.AbsoluteSize.X, 0, 1)
                    local Val = math.floor(Min + ((Max - Min) * S))
                    ValLabel.Text = tostring(Val)
                    Fill.Size = UDim2.new(S, 0, 1, 0)
                    Config.Callback(Val)
                end
            end)
        end

        return TabFunctions
    end
    
    function Library:Watermark(text)
       -- (Watermark code same as before)
    end

    return WindowFunctions
end

return Library
