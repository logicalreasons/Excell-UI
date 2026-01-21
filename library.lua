--[[
    Excell Internal Library | v2.6 (Visual Overhaul)
    - Style: "Neon" Internal (Glow + Rounded Corners)
    - Colors: Deep Dark Theme
    - Fixes: Smooth sizing and layout
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
    
    -- 1. CLEANUP
    if game:GetService("CoreGui"):FindFirstChild("ExcellInternal_v2") then
        game:GetService("CoreGui").ExcellInternal_v2:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExcellInternal_v2"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

    -- 2. MAIN FRAME (Visual Upgrade)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12) -- Deep Dark
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -300)
    MainFrame.Size = UDim2.new(0, 650, 0, 600)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Rounded Corners
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 6)
    
    -- Neon Stroke (Glow Effect)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Thickness = 2
    MainStroke.Color = Accent
    MainStroke.Transparency = 0.2

    -- Title Area
    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Accent
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 3. TOP TAB BAR
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 10, 0, 40)
    TabBar.Size = UDim2.new(1, -20, 0, 35)
    
    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 10)

    -- 4. CONTENT AREA
    local Content = Instance.new("Frame", MainFrame)
    Content.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- Slightly lighter
    Content.Position = UDim2.new(0, 10, 0, 85)
    Content.Size = UDim2.new(1, -20, 1, -95)
    
    local ContentCorner = Instance.new("UICorner", Content)
    ContentCorner.CornerRadius = UDim.new(0, 4)

    local FirstTab = true
    local WindowFunctions = {}

    -- CREATE TAB
    function WindowFunctions:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.Size = UDim2.new(0, 120, 1, 0)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 13
        
        local BtnCorner = Instance.new("UICorner", TabBtn)
        BtnCorner.CornerRadius = UDim.new(0, 4)
        
        -- TAB PAGE
        local TabPage = Instance.new("Frame", Content)
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = false

        -- SIDEBAR (Mini Tabs)
        local Sidebar = Instance.new("Frame", TabPage)
        Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Sidebar.Size = UDim2.new(0, 160, 1, 0)
        
        local SidebarCorner = Instance.new("UICorner", Sidebar)
        SidebarCorner.CornerRadius = UDim.new(0, 4)
        
        local SidebarPadding = Instance.new("UIPadding", Sidebar)
        SidebarPadding.PaddingTop = UDim.new(0, 10)
        SidebarPadding.PaddingLeft = UDim.new(0, 5)

        local SidebarList = Instance.new("UIListLayout", Sidebar)
        SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
        SidebarList.Padding = UDim.new(0, 5)

        -- ELEMENT AREA
        local ElementArea = Instance.new("Frame", TabPage)
        ElementArea.BackgroundTransparency = 1
        ElementArea.Position = UDim2.new(0, 170, 0, 10)
        ElementArea.Size = UDim2.new(1, -180, 1, -20)

        if FirstTab then
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Accent
            TabBtn.BackgroundTransparency = 0.8
            TabPage.Visible = true
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("Frame") then v.Visible = false end end
            for _, v in pairs(TabBar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                    v.BackgroundTransparency = 0 
                    v.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                end 
            end
            TabPage.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Accent
            TabBtn.BackgroundTransparency = 0.8
        end)

        local TabFunctions = {}
        local FirstSub = true

        -- CREATE SUB-TAB
        function TabFunctions:CreateSubTab(SubName)
            local SubBtn = Instance.new("TextButton", Sidebar)
            SubBtn.BackgroundTransparency = 1
            SubBtn.Size = UDim2.new(1, -10, 0, 35)
            SubBtn.Font = Enum.Font.Gotham
            SubBtn.Text = "  " .. SubName
            SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            SubBtn.TextSize = 12
            SubBtn.TextXAlignment = Enum.TextXAlignment.Left
            
            local SubCorner = Instance.new("UICorner", SubBtn)
            SubCorner.CornerRadius = UDim.new(0, 4)

            -- Container
            local Container = Instance.new("ScrollingFrame", ElementArea)
            Container.BackgroundTransparency = 1
            Container.Size = UDim2.new(1, 0, 1, 0)
            Container.Visible = false
            Container.ScrollBarThickness = 2
            
            local List = Instance.new("UIListLayout", Container)
            List.SortOrder = Enum.SortOrder.LayoutOrder
            List.Padding = UDim.new(0, 5)

            if FirstSub then
                SubBtn.TextColor3 = Accent
                SubBtn.BackgroundTransparency = 0.9
                SubBtn.BackgroundColor3 = Accent
                Container.Visible = true
                FirstSub = false
            end

            SubBtn.MouseButton1Click:Connect(function()
                for _, v in pairs(ElementArea:GetChildren()) do v.Visible = false end
                for _, v in pairs(Sidebar:GetChildren()) do 
                    if v:IsA("TextButton") then 
                        v.TextColor3 = Color3.fromRGB(150, 150, 150)
                        v.BackgroundTransparency = 1
                    end 
                end
                
                Container.Visible = true
                SubBtn.TextColor3 = Accent
                SubBtn.BackgroundColor3 = Accent
                SubBtn.BackgroundTransparency = 0.9
            end)

            local PageFunctions = {}

            -- TOGGLE
            function PageFunctions:CreateToggle(Config)
                local Frame = Instance.new("Frame", Container)
                Frame.BackgroundTransparency = 1
                Frame.Size = UDim2.new(1, 0, 0, 35)
                
                local Btn = Instance.new("TextButton", Frame)
                Btn.BackgroundTransparency = 1
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.Font = Enum.Font.Gotham
                Btn.Text = Config.Name
                Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                Btn.TextSize = 12
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                
                -- Custom Checkbox
                local BoxOuter = Instance.new("Frame", Frame)
                BoxOuter.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BoxOuter.Position = UDim2.new(1, -25, 0.5, -7)
                BoxOuter.Size = UDim2.new(0, 14, 0, 14)
                Instance.new("UICorner", BoxOuter).CornerRadius = UDim.new(0, 3)
                Instance.new("UIStroke", BoxOuter).Color = Color3.fromRGB(60, 60, 60)
                
                local BoxInner = Instance.new("Frame", BoxOuter)
                BoxInner.BackgroundColor3 = Accent
                BoxInner.Size = UDim2.new(1, 0, 1, 0)
                BoxInner.BackgroundTransparency = 1
                Instance.new("UICorner", BoxInner).CornerRadius = UDim.new(0, 3)

                local Enabled = Config.CurrentValue or false
                if Enabled then BoxInner.BackgroundTransparency = 0 end

                Btn.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    TweenService:Create(BoxInner, TweenInfo.new(0.15), {BackgroundTransparency = Enabled and 0 or 1}):Play()
                    if Config.Callback then Config.Callback(Enabled) end
                end)
            end
            
            -- SLIDER
            function PageFunctions:CreateSlider(Config)
                local Frame = Instance.new("Frame", Container)
                Frame.BackgroundTransparency = 1
                Frame.Size = UDim2.new(1, 0, 0, 50)
                
                local Lbl = Instance.new("TextLabel", Frame)
                Lbl.Text=Config.Name; Lbl.TextColor3=Color3.fromRGB(200,200,200); Lbl.BackgroundTransparency=1; Lbl.Size=UDim2.new(1,0,0,20); Lbl.Font=Enum.Font.Gotham; Lbl.TextSize=12; Lbl.TextXAlignment=Enum.TextXAlignment.Left
                
                local Val = Instance.new("TextLabel", Frame)
                Val.Text=tostring(Config.CurrentValue); Val.TextColor3=Accent; Val.BackgroundTransparency=1; Val.Position=UDim2.new(1,-40,0,0); Val.Size=UDim2.new(0,30,0,20); Val.Font=Enum.Font.Code; Val.TextSize=12
                
                local BG = Instance.new("TextButton", Frame)
                BG.BackgroundColor3=Color3.fromRGB(30,30,30)
                BG.Position=UDim2.new(0,0,0,25)
                BG.Size=UDim2.new(1,-10,0,6)
                BG.Text=""
                Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 3)
                
                local Fill = Instance.new("Frame", BG)
                Fill.BackgroundColor3=Accent
                Fill.Size=UDim2.new((Config.CurrentValue-Config.Range[1])/(Config.Range[2]-Config.Range[1]),0,1,0)
                Fill.BorderSizePixel=0
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)
                
                local Drag=false
                BG.MouseButton1Down:Connect(function() Drag=true end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Drag=false end end)
                UserInputService.InputChanged:Connect(function(i)
                    if Drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                        local S = math.clamp((UserInputService:GetMouseLocation().X - BG.AbsolutePosition.X)/BG.AbsoluteSize.X,0,1)
                        local New = math.floor(Config.Range[1] + ((Config.Range[2]-Config.Range[1])*S))
                        Val.Text = tostring(New); Fill.Size=UDim2.new(S,0,1,0); Config.Callback(New)
                    end
                end)
            end
            
            -- KEYBIND
            function PageFunctions:CreateKeybind(Config)
                local Frame = Instance.new("Frame", Container)
                Frame.BackgroundTransparency = 1
                Frame.Size = UDim2.new(1, 0, 0, 35)
                
                local Lbl = Instance.new("TextLabel", Frame)
                Lbl.Text=Config.Name; Lbl.TextColor3=Color3.fromRGB(200,200,200); Lbl.BackgroundTransparency=1; Lbl.Size=UDim2.new(1,0,1,0); Lbl.Font=Enum.Font.Gotham; Lbl.TextSize=12; Lbl.TextXAlignment=Enum.TextXAlignment.Left
                
                local Btn = Instance.new("TextButton", Frame)
                Btn.BackgroundColor3=Color3.fromRGB(30,30,30)
                Btn.Position=UDim2.new(1,-80,0.5,-10)
                Btn.Size=UDim2.new(0,75,0,20)
                Btn.Text=Config.Default and Config.Default.Name or "None"
                Btn.TextColor3=Color3.fromRGB(150,150,150)
                Btn.Font=Enum.Font.Code
                Btn.TextSize=11
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                
                local Binding, Key = false, Config.Default
                Btn.MouseButton1Click:Connect(function() Binding=true; Btn.Text="..."; Btn.TextColor3=Accent; local i=UserInputService.InputBegan:Wait(); if i.UserInputType==Enum.UserInputType.Keyboard then Key=i.KeyCode; Btn.Text=Key.Name; Btn.TextColor3=Color3.fromRGB(150,150,150); Binding=false end end)
                
                RunService.RenderStepped:Connect(function()
                    if Config.Callback then Config.Callback(UserInputService:IsKeyDown(Key or Enum.KeyCode.Unknown)) end
                end)
            end

            return PageFunctions
        end

        return TabFunctions
    end
    
    function Library:Watermark(text) end

    return WindowFunctions
end

return Library
