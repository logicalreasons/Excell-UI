--[[
    Excell Internal Library | Juju Style
    - Aesthetic: Sharp, Dark, Sidebar Layout
    - Features: Toggles, Sliders, Watermark, Keybind Menu
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

function Library:CreateWindow(Config)
    local Title = Config.Name or "Excell.win"
    local Accent = Config.Accent or Color3.fromRGB(120, 100, 255) -- Juju Purple
    
    -- 1. MAIN SCREEN GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExcellInternal"
    ScreenGui.ResetOnSpawn = false
    
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. MAIN FRAME (The Window)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Accent
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 30)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Accent Line
    local Line = Instance.new("Frame")
    Line.Parent = TopBar
    Line.BackgroundColor3 = Accent
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.Size = UDim2.new(1, 0, 0, 1)

    -- Sidebar (Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.Size = UDim2.new(0, 120, 1, -30)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 2)

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Parent = MainFrame
    Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Content.BorderSizePixel = 0
    Content.Position = UDim2.new(0, 130, 0, 40)
    Content.Size = UDim2.new(0, 360, 0, 300)

    local Tabs = {}
    local FirstTab = true

    local WindowFunctions = {}

    -- 3. TAB SYSTEM
    function WindowFunctions:CreateTab(TabName)
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 12

        -- Tab Container
        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Name = TabName
        TabContainer.Parent = Content
        TabContainer.BackgroundTransparency = 1
        TabContainer.Size = UDim2.new(1, 0, 1, 0)
        TabContainer.ScrollBarThickness = 2
        TabContainer.ScrollBarImageColor3 = Accent
        TabContainer.Visible = FirstTab
        
        local ContainerLayout = Instance.new("UIListLayout")
        ContainerLayout.Parent = TabContainer
        ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContainerLayout.Padding = UDim.new(0, 5)
        
        if FirstTab then
            TabBtn.TextColor3 = Accent
            FirstTab = false
        end

        -- Switch Logic
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            
            TabContainer.Visible = true
            TabBtn.TextColor3 = Accent
        end)

        local TabFunctions = {}

        -- 4. ELEMENT: TOGGLE
        function TabFunctions:CreateToggle(Config)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabContainer
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, -5, 0, 30)

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Parent = ToggleFrame
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.Font = Enum.Font.GothamSemibold
            ToggleBtn.Text = "  " .. Config.Name
            ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleBtn.TextSize = 12
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

            local Status = Instance.new("Frame")
            Status.Parent = ToggleFrame
            Status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Status.BorderSizePixel = 0
            Status.Position = UDim2.new(1, -25, 0.5, -5)
            Status.Size = UDim2.new(0, 10, 0, 10)

            local Enabled = Config.CurrentValue or false
            
            -- Set Initial State
            if Enabled then Status.BackgroundColor3 = Accent end

            ToggleBtn.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                if Enabled then
                    TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = Accent}):Play()
                else
                    TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                end
                Config.Callback(Enabled)
            end)
        end

        -- 5. ELEMENT: SLIDER
        function TabFunctions:CreateSlider(Config)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = TabContainer
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, -5, 0, 45)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 5, 0, 0)
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = Config.Name
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -55, 0, 0)
            ValueLabel.Size = UDim2.new(0, 50, 0, 25)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = tostring(Config.CurrentValue)
            ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local SliderBG = Instance.new("TextButton") -- Using button for input
            SliderBG.Parent = SliderFrame
            SliderBG.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            SliderBG.BorderSizePixel = 0
            SliderBG.Position = UDim2.new(0, 5, 0, 30)
            SliderBG.Size = UDim2.new(1, -10, 0, 6)
            SliderBG.Text = ""

            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBG
            SliderFill.BackgroundColor3 = Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new(0, 0, 1, 0)

            local Min = Config.Range[1]
            local Max = Config.Range[2]
            
            -- Set Initial
            local startPercent = (Config.CurrentValue - Min) / (Max - Min)
            SliderFill.Size = UDim2.new(startPercent, 0, 1, 0)

            local Dragging = false
            SliderBG.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local MousePos = UserInputService:GetMouseLocation().X
                    local FramePos = SliderBG.AbsolutePosition.X
                    local FrameSize = SliderBG.AbsoluteSize.X
                    local Relative = math.clamp((MousePos - FramePos) / FrameSize, 0, 1)
                    
                    local Value = math.floor(Min + ((Max - Min) * Relative))
                    ValueLabel.Text = tostring(Value)
                    SliderFill.Size = UDim2.new(Relative, 0, 1, 0)
                    Config.Callback(Value)
                end
            end)
        end

        return TabFunctions
    end

    return WindowFunctions
end

-- 6. WATERMARK (Juju Style)
function Library:Watermark(text)
    local ScGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScGui.Name = "ExcellWatermark"
    local Text = Instance.new("TextLabel", ScGui)
    Text.Font = Enum.Font.Code
    Text.Text = text
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextSize = 14
    Text.Position = UDim2.new(0, 20, 0, 20)
    Text.BackgroundTransparency = 1
    Text.TextStrokeTransparency = 0.5
    
    -- FPS/Ping updater
    RunService.RenderStepped:Connect(function()
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        Text.Text = text .. " | FPS: " .. fps
    end)
end

return Library
