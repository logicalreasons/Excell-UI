--[[
    Excell Internal Library | v3.6 (Anti-Stack Fix)
    - Fix: Forces deletion of OLD menu before creating NEW one.
    - Features: Juju Style, Sub-Tabs, FOV, Scale.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

function Library:CreateWindow(Config)
    local Title = Config.Name or "Excell.win"
    local Accent = Config.Accent or Color3.fromRGB(170, 100, 255)
    
    -- 1. DESTROY OLD UI
    if game:GetService("CoreGui"):FindFirstChild("ExcellInternal_v3") then
        game:GetService("CoreGui").ExcellInternal_v3:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExcellInternal_v3"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

    -- 2. SCALE LAYER
    local ScaleFrame = Instance.new("Frame", ScreenGui)
    ScaleFrame.Name = "Scale"
    ScaleFrame.BackgroundTransparency = 1
    ScaleFrame.Size = UDim2.new(1, 0, 1, 0)
    local UIScale = Instance.new("UIScale", ScaleFrame)
    UIScale.Scale = 1

    -- 3. MAIN WINDOW
    local MainFrame = Instance.new("Frame", ScaleFrame)
    MainFrame.Name = "Main"
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderColor3 = Accent
    MainFrame.BorderSizePixel = 1
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -300)
    MainFrame.Size = UDim2.new(0, 600, 0, 600)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- DECORATION
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 25)

    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Text = Title
    TitleLbl.Font = Enum.Font.Code
    TitleLbl.TextColor3 = Color3.new(1,1,1)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Size = UDim2.new(1, -10, 1, 0)
    TitleLbl.Position = UDim2.new(0, 10, 0, 0)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local Line = Instance.new("Frame", TopBar)
    Line.BackgroundColor3 = Accent
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 0, 1, 0)
    Line.Size = UDim2.new(1, 0, 0, 1)

    -- TAB BAR
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    TabBar.BorderColor3 = Color3.fromRGB(30, 30, 30)
    TabBar.BorderSizePixel = 1
    TabBar.Position = UDim2.new(0, 10, 0, 35)
    TabBar.Size = UDim2.new(1, -20, 0, 30)
    
    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- CONTENT
    local Content = Instance.new("Frame", MainFrame)
    Content.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Content.BorderColor3 = Color3.fromRGB(30, 30, 30)
    Content.BorderSizePixel = 1
    Content.Position = UDim2.new(0, 10, 0, 75)
    Content.Size = UDim2.new(1, -20, 1, -85)

    local FirstTab = true
    local WindowFunctions = {}

    function WindowFunctions:SetScale(Val) UIScale.Scale = Val end

    function WindowFunctions:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        TabBtn.BorderColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BorderSizePixel = 1
        TabBtn.Size = UDim2.new(0, 120, 1, 0)
        TabBtn.Font = Enum.Font.Code
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
        TabBtn.TextSize = 12

        local TabPage = Instance.new("Frame", Content)
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = false

        -- SIDEBAR
        local Sidebar = Instance.new("Frame", TabPage)
        Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Sidebar.BorderColor3 = Color3.fromRGB(30, 30, 30)
        Sidebar.BorderSizePixel = 1
        Sidebar.Size = UDim2.new(0, 140, 1, 0)
        local SidebarList = Instance.new("UIListLayout", Sidebar)
        SidebarList.SortOrder = Enum.SortOrder.LayoutOrder

        -- ITEMS
        local Items = Instance.new("Frame", TabPage)
        Items.BackgroundTransparency = 1
        Items.Position = UDim2.new(0, 150, 0, 10)
        Items.Size = UDim2.new(1, -160, 1, -20)

        if FirstTab then TabBtn.TextColor3=Accent; TabPage.Visible=true; FirstTab=false end

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Content:GetChildren()) do v.Visible=false end
            for _,v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3=Color3.fromRGB(100,100,100) end end
            TabPage.Visible=true; TabBtn.TextColor3=Accent
        end)

        local TabFuncs = {}
        local FirstSub = true

        function TabFuncs:CreateSubTab(Name)
            local SubBtn = Instance.new("TextButton", Sidebar)
            SubBtn.BackgroundTransparency = 1
            SubBtn.Size = UDim2.new(1, 0, 0, 25)
            SubBtn.Font = Enum.Font.Code
            SubBtn.Text = " " .. Name
            SubBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
            SubBtn.TextSize = 12
            SubBtn.TextXAlignment = Enum.TextXAlignment.Left

            local Container = Instance.new("ScrollingFrame", Items)
            Container.BackgroundTransparency = 1
            Container.Size = UDim2.new(1, 0, 1, 0)
            Container.Visible = false
            Container.ScrollBarThickness = 2
            local List = Instance.new("UIListLayout", Container)
            List.Padding = UDim.new(0, 5)

            if FirstSub then SubBtn.TextColor3=Color3.new(1,1,1); Container.Visible=true; FirstSub=false end

            SubBtn.MouseButton1Click:Connect(function()
                for _,v in pairs(Items:GetChildren()) do v.Visible=false end
                for _,v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3=Color3.fromRGB(100,100,100) end end
                Container.Visible=true; SubBtn.TextColor3=Color3.new(1,1,1)
            end)

            local PageFuncs = {}

            -- TOGGLE
            function PageFuncs:CreateToggle(Config)
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,22)
                local B = Instance.new("TextButton", F); B.BackgroundTransparency=1; B.Size=UDim2.new(1,0,1,0); B.Font=Enum.Font.Code; B.Text=Config.Name; B.TextColor3=Color3.fromRGB(200,200,200); B.TextSize=12; B.TextXAlignment=Enum.TextXAlignment.Left
                local Box = Instance.new("Frame", F); Box.BackgroundColor3=Color3.fromRGB(25,25,25); Box.BorderColor3=Color3.fromRGB(50,50,50); Box.Position=UDim2.new(1,-18,0.5,-6); Box.Size=UDim2.new(0,12,0,12)
                local Fill = Instance.new("Frame", Box); Fill.BackgroundColor3=Accent; Fill.BorderSizePixel=0; Fill.Size=UDim2.new(1,0,1,0); Fill.Visible=Config.CurrentValue or false
                B.MouseButton1Click:Connect(function() Fill.Visible=not Fill.Visible; if Config.Callback then Config.Callback(Fill.Visible) end end)
            end

            -- SLIDER
            function PageFuncs:CreateSlider(Config)
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,35)
                local L = Instance.new("TextLabel", F); L.Text=Config.Name; L.TextColor3=Color3.fromRGB(200,200,200); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,15); L.Font=Enum.Font.Code; L.TextSize=12; L.TextXAlignment=Enum.TextXAlignment.Left
                local V = Instance.new("TextLabel", F); V.Text=tostring(Config.CurrentValue); V.TextColor3=Accent; V.BackgroundTransparency=1; V.Position=UDim2.new(1,-40,0,0); V.Size=UDim2.new(0,30,0,15); V.Font=Enum.Font.Code; V.TextSize=12
                local BG = Instance.new("TextButton", F); BG.BackgroundColor3=Color3.fromRGB(25,25,25); BG.BorderColor3=Color3.fromRGB(50,50,50); BG.Position=UDim2.new(0,0,0,18); BG.Size=UDim2.new(1,-10,0,6); BG.Text=""
                local Fill = Instance.new("Frame", BG); Fill.BackgroundColor3=Accent; Fill.BorderSizePixel=0; Fill.Size=UDim2.new((Config.CurrentValue-Config.Range[1])/(Config.Range[2]-Config.Range[1]),0,1,0)
                
                local Drag=false
                BG.MouseButton1Down:Connect(function() Drag=true end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Drag=false end end)
                UserInputService.InputChanged:Connect(function(i) if Drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    local S = math.clamp((UserInputService:GetMouseLocation().X - BG.AbsolutePosition.X)/BG.AbsoluteSize.X,0,1)
                    local New = math.floor(Config.Range[1] + ((Config.Range[2]-Config.Range[1])*S))
                    V.Text = tostring(New); Fill.Size=UDim2.new(S,0,1,0); Config.Callback(New)
                end end)
            end

            -- KEYBIND (FIXED CONTEXT MENU)
            function PageFuncs:CreateKeybind(Config)
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,22)
                local L = Instance.new("TextLabel", F); L.Text=Config.Name; L.TextColor3=Color3.fromRGB(200,200,200); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,1,0); L.Font=Enum.Font.Code; L.TextSize=12; L.TextXAlignment=Enum.TextXAlignment.Left
                local B = Instance.new("TextButton", F); B.BackgroundColor3=Color3.fromRGB(25,25,25); B.BorderColor3=Color3.fromRGB(50,50,50); B.Position=UDim2.new(1,-60,0.5,-9); B.Size=UDim2.new(0,50,0,18); B.Text=Config.Default and Config.Default.Name or "None"; B.TextColor3=Color3.fromRGB(150,150,150); B.Font=Enum.Font.Code; B.TextSize=11
                
                local Mode = "Toggle"
                local Key = Config.Default
                local Binding = false

                B.MouseButton1Click:Connect(function() 
                    Binding=true; B.Text="..."; B.TextColor3=Accent 
                    local i = UserInputService.InputBegan:Wait()
                    if i.UserInputType==Enum.UserInputType.Keyboard then 
                        Key=i.KeyCode; B.Text=Key.Name; B.TextColor3=Color3.fromRGB(150,150,150); Binding=false 
                    end 
                end)

                -- RIGHT CLICK FIX
                B.MouseButton2Click:Connect(function()
                    -- DELETE OLD MENU (Loop through all children to be safe)
                    for _, child in pairs(ScreenGui:GetChildren()) do
                        if child.Name == "ContextMenu" then child:Destroy() end
                    end

                    -- CREATE NEW MENU
                    local Menu = Instance.new("Frame", ScreenGui)
                    Menu.Name = "ContextMenu" -- ID for cleanup
                    Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    Menu.BorderColor3 = Accent
                    Menu.BorderSizePixel = 1
                    Menu.Size = UDim2.new(0, 80, 0, 70)
                    Menu.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
                    Menu.ZIndex = 100
                    
                    local Layout = Instance.new("UIListLayout", Menu); Layout.SortOrder=Enum.SortOrder.LayoutOrder
                    
                    local function AddOpt(Name)
                        local Opt = Instance.new("TextButton", Menu)
                        Opt.Size = UDim2.new(1, 0, 0, 22)
                        Opt.BackgroundTransparency = 1
                        Opt.Text = Name
                        Opt.TextColor3 = (Mode == Name) and Accent or Color3.fromRGB(200, 200, 200)
                        Opt.Font = Enum.Font.Code
                        Opt.TextSize = 12
                        Opt.ZIndex = 101
                        
                        Opt.MouseButton1Click:Connect(function()
                            Mode = Name
                            Menu:Destroy()
                        end)
                    end
                    AddOpt("Toggle"); AddOpt("Hold"); AddOpt("Always")

                    -- CLOSE ON CLICK AWAY
                    spawn(function()
                        local input = UserInputService.InputBegan:Wait()
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if Menu then Menu:Destroy() end
                        end
                    end)
                end)
                
                -- LOGIC
                local Toggled = false
                UserInputService.InputBegan:Connect(function(i, p)
                    if p then return end
                    if i.KeyCode == Key and Mode == "Toggle" then
                        Toggled = not Toggled
                        if Config.Callback then Config.Callback(Toggled) end
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if Mode == "Hold" and Config.Callback then
                        Config.Callback(UserInputService:IsKeyDown(Key or Enum.KeyCode.Unknown))
                    elseif Mode == "Always" and Config.Callback then
                        Config.Callback(true)
                    end
                end)
            end

            return PageFuncs
        end
        return TabFuncs
    end
    function Library:Watermark(t) end
    return WindowFunctions, Library
end
return Library
