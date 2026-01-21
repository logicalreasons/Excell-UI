--[[
    Excell Internal Library | v2.0 (Top Tabs)
    - Layout: Horizontal Tabs (Top Bar)
    - Style: Juju / Gamesense / Internal
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local Library = {}

function Library:CreateWindow(Config)
    local Title = Config.Name or "Excell.win"
    local Accent = Config.Accent or Color3.fromRGB(138, 43, 226)
    
    -- 1. SCREEN GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExcellInternal_v2"
    ScreenGui.ResetOnSpawn = false
    
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. MAIN FRAME
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

    -- Top Accent Line
    local TopLine = Instance.new("Frame")
    TopLine.Parent = MainFrame
    TopLine.BackgroundColor3 = Accent
    TopLine.BorderSizePixel = 0
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    
    -- Title Label (Left)
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = MainFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Size = UDim2.new(0, 150, 0, 20)
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 3. TAB BAR (Horizontal)
    local TabBar = Instance.new("Frame")
    TabBar.Parent = MainFrame
    TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 0, 0, 30)
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 0)

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Parent = MainFrame
    Content.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Content.BorderSizePixel = 0
    Content.Position = UDim2.new(0, 10, 0, 70)
    Content.Size = UDim2.new(1, -20, 1, -80)

    local Tabs = {}
    local FirstTab = true

    local WindowFunctions = {}

    -- 4. CREATE TAB FUNCTION
    function WindowFunctions:CreateTab(TabName)
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabBar
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(0, 100, 1, 0) -- Fixed width per tab
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
        TabBtn.TextSize = 12
        
        -- Active Indicator Line
        local Indicator = Instance.new("Frame")
        Indicator.Parent = TabBtn
        Indicator.BackgroundColor3 = Accent
        Indicator.BorderSizePixel = 0
        Indicator.Position = UDim2.new(0, 0, 1, -2)
        Indicator.Size = UDim2.new(1, 0, 0, 2)
        Indicator.Visible = false

        -- Tab Container
        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Name = TabName
        TabContainer.Parent = Content
        TabContainer.BackgroundTransparency = 1
        TabContainer.Size = UDim2.new(1, 0, 1, 0)
        TabContainer.ScrollBarThickness = 2
        TabContainer.Visible = false
        
        local ContainerLayout = Instance.new("UIListLayout")
        ContainerLayout.Parent = TabContainer
        ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContainerLayout.Padding = UDim.new(0, 5)
        
        if FirstTab then
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
            TabContainer.Visible = true
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            -- Reset all
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabBar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(100, 100, 100) 
                    v.Frame.Visible = false
                end 
            end
            
            -- Activate this
            TabContainer.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
        end)

        local TabFunctions = {}

        -- 5. ELEMENTS (Toggle, Slider, etc.)
        function TabFunctions:CreateToggle(Config)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabContainer
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Parent = ToggleFrame
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.Font = Enum.Font.Gotham
            ToggleBtn.Text = "   " .. Config.Name
            ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleBtn.TextSize = 12
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("Frame")
            Box.Parent = ToggleFrame
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Box.Position = UDim2.new(1, -25, 0.5, -6)
            Box.Size = UDim2.new(0, 12, 0, 12)
            
            local Enabled = Config.CurrentValue or false
            if Enabled then Box.BackgroundColor3 = Accent end

            ToggleBtn.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                if Enabled then
                    TweenService:Create(Box, TweenInfo.new(0.15), {BackgroundColor3 = Accent}):Play()
                else
                    TweenService:Create(Box, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                end
                Config.Callback(Enabled)
            end)
        end

        function TabFunctions:CreateSlider(Config)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = TabContainer
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = Config.Name
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Font = Enum.Font.Code
            ValueLabel.Text = tostring(Config.CurrentValue)
            ValueLabel.TextColor3 = Accent
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local SliderBG = Instance.new("TextButton")
            SliderBG.Parent = SliderFrame
            SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderBG.BorderSizePixel = 0
            SliderBG.Position = UDim2.new(0, 10, 0, 30)
            SliderBG.Size = UDim2.new(1, -20, 0, 4)
            SliderBG.Text = ""

            local Fill = Instance.new("Frame")
            Fill.Parent = SliderBG
            Fill.BackgroundColor3 = Accent
            Fill.BorderSizePixel = 0
            
            local Min, Max = Config.Range[1], Config.Range[2]
            local startP = (Config.CurrentValue - Min)/(Max - Min)
            Fill.Size = UDim2.new(startP, 0, 1, 0)

            local Dragging = false
            SliderBG.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end 
            end)

            UserInputService.InputChanged:Connect(function(i)
                if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local MP = UserInputService:GetMouseLocation().X
                    local FP = SliderBG.AbsolutePosition.X
                    local FS = SliderBG.AbsoluteSize.X
                    local Scale = math.clamp((MP - FP) / FS, 0, 1)
                    local NewVal = math.floor(Min + ((Max - Min) * Scale))
                    
                    ValueLabel.Text = tostring(NewVal)
                    Fill.Size = UDim2.new(Scale, 0, 1, 0)
                    Config.Callback(NewVal)
                end
            end)
        end

        return TabFunctions
    end
    
    -- 6. WATERMARK
    function Library:Watermark(text)
        local WGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        local Lbl = Instance.new("TextLabel", WGui)
        Lbl.Font = Enum.Font.Code
        Lbl.Text = text
        Lbl.TextColor3 = Color3.new(1,1,1)
        Lbl.TextSize = 14
        Lbl.Position = UDim2.new(0, 20, 0, 20)
        Lbl.BackgroundTransparency = 1
        Lbl.TextStrokeTransparency = 0.5
        
        RunService.RenderStepped:Connect(function()
            local fps = math.floor(1/RunService.RenderStepped:Wait())
            Lbl.Text = text .. " | FPS: " .. fps
        end)
    end

    return WindowFunctions, Library
end

return Library
