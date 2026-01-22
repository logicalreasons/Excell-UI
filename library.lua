--[[
    Excell Internal Library | v4.16 (Aggressive Cleanup Fix)
    - Fix: Deletes ALL previous UI instances (fixes "Old UI not deleting").
    - Fix: "CreateLabel" and "Overwrite" support included.
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}
Library.ActiveMenu = nil 

function Library:CreateWindow(Config)
    local Title = Config.Name or "Excell.win"
    local Accent = Config.Accent or Color3.fromRGB(170, 100, 255)
    
    -- [[ AGGRESSIVE CLEANUP ]] --
    -- This loops through everything and deletes ANY old version of the UI
    for _, GUI in pairs(game:GetService("CoreGui"):GetChildren()) do
        if GUI.Name == "ExcellInternal_v3" then GUI:Destroy() end
    end
    for _, GUI in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if GUI.Name == "ExcellInternal_v3" then GUI:Destroy() end
    end

    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ExcellInternal_v3"
    ScreenGui.ResetOnSpawn = false
    
    -- Parent Fallback (CoreGui -> PlayerGui)
    local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not success or not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "Main"
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderColor3 = Accent
    MainFrame.BorderSizePixel = 1
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Active = true

    local UIScale = Instance.new("UIScale", MainFrame)
    UIScale.Scale = 1

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 25)

    -- Drag Logic
    local function MakeDraggable(Frame, Handle)
        local Dragging, DragInput, DragStart, StartPos
        Handle.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true; DragStart = Input.Position; StartPos = Frame.Position
            end
        end)
        Handle.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
        end)
        UserInputService.InputChanged:Connect(function(Input)
            if Input == DragInput and Dragging then
                local Delta = Input.Position - DragStart
                local CurrentScale = UIScale.Scale
                Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + (Delta.X / CurrentScale), StartPos.Y.Scale, StartPos.Y.Offset + (Delta.Y / CurrentScale))
            end
        end)
        UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
        end)
    end
    MakeDraggable(MainFrame, TopBar)

    local TitleLbl = Instance.new("TextLabel", TopBar)
    TitleLbl.Text = Title; TitleLbl.Font = Enum.Font.Code; TitleLbl.TextColor3 = Color3.new(1,1,1)
    TitleLbl.BackgroundTransparency = 1; TitleLbl.Size = UDim2.new(1, -10, 1, 0); TitleLbl.Position = UDim2.new(0, 10, 0, 0)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left; TitleLbl.TextSize = 14

    local Line = Instance.new("Frame", TopBar)
    Line.BackgroundColor3 = Accent; Line.BorderSizePixel = 0; Line.Position = UDim2.new(0, 0, 1, 0); Line.Size = UDim2.new(1, 0, 0, 1)

    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12); TabBar.BorderColor3 = Color3.fromRGB(30, 30, 30); TabBar.BorderSizePixel = 1
    TabBar.Position = UDim2.new(0, 10, 0, 35); TabBar.Size = UDim2.new(1, -20, 0, 30)
    
    local TabLayout = Instance.new("UIListLayout", TabBar); TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Content = Instance.new("Frame", MainFrame)
    Content.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Content.BorderColor3 = Color3.fromRGB(30, 30, 30); Content.BorderSizePixel = 1
    Content.Position = UDim2.new(0, 10, 0, 75); Content.Size = UDim2.new(1, -20, 1, -85)

    local FirstTab = true
    local WindowFunctions = {}

    function WindowFunctions:SetScale(Val) UIScale.Scale = Val end
    function WindowFunctions:Unload() ScreenGui:Destroy() end

    function WindowFunctions:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); TabBtn.BorderColor3 = Color3.fromRGB(30, 30, 30); TabBtn.BorderSizePixel = 1
        TabBtn.Size = UDim2.new(0, 120, 1, 0); TabBtn.Font = Enum.Font.Code; TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(100, 100, 100); TabBtn.TextSize = 12

        local TabPage = Instance.new("Frame", Content)
        TabPage.BackgroundTransparency = 1; TabPage.Size = UDim2.new(1, 0, 1, 0); TabPage.Visible = false

        local Sidebar = Instance.new("Frame", TabPage)
        Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Sidebar.BorderColor3 = Color3.fromRGB(30, 30, 30); Sidebar.BorderSizePixel = 1
        Sidebar.Size = UDim2.new(0, 140, 1, 0)
        local SidebarList = Instance.new("UIListLayout", Sidebar); SidebarList.SortOrder = Enum.SortOrder.LayoutOrder

        local Items = Instance.new("Frame", TabPage)
        Items.BackgroundTransparency = 1; Items.Position = UDim2.new(0, 150, 0, 10); Items.Size = UDim2.new(1, -160, 1, -20)

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
            SubBtn.BackgroundTransparency = 1; SubBtn.Size = UDim2.new(1, 0, 0, 25); SubBtn.Font = Enum.Font.Code
            SubBtn.Text = " " .. Name; SubBtn.TextColor3 = Color3.fromRGB(100, 100, 100); SubBtn.TextSize = 12; SubBtn.TextXAlignment = Enum.TextXAlignment.Left

            local Container = Instance.new("ScrollingFrame", Items)
            Container.BackgroundTransparency = 1; Container.Size = UDim2.new(1, 0, 1, 0); Container.Visible = false
            Container.ScrollBarThickness = 2
            local List = Instance.new("UIListLayout", Container); List.Padding = UDim.new(0, 5)

            if FirstSub then SubBtn.TextColor3=Color3.new(1,1,1); Container.Visible=true; FirstSub=false end

            SubBtn.MouseButton1Click:Connect(function()
                for _,v in pairs(Items:GetChildren()) do v.Visible=false end
                for _,v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3=Color3.fromRGB(100,100,100) end end
                Container.Visible=true; SubBtn.TextColor3=Color3.new(1,1,1)
            end)

            local PageFuncs = {}

            -- LABEL
            function PageFuncs:CreateLabel(Text)
                local Obj = {}
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,26)
                local L = Instance.new("TextLabel", F); L.BackgroundTransparency=1; L.Size=UDim2.new(1,-10,1,0); L.Position=UDim2.new(0,0,0,0)
                L.Font=Enum.Font.Code; L.Text=Text; L.TextColor3=Color3.fromRGB(200, 200, 200); L.TextSize=11; L.TextXAlignment=Enum.TextXAlignment.Left
                function Obj:Set(NewText, Color) L.Text = NewText; if Color then L.TextColor3 = Color end end
                return Obj
            end

            -- TOGGLE
            function PageFuncs:CreateToggle(Config)
                local Obj = {}
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,22)
                local B = Instance.new("TextButton", F); B.BackgroundTransparency=1; B.Size=UDim2.new(1,0,1,0); B.Font=Enum.Font.Code; B.Text=Config.Name; B.TextColor3=Color3.fromRGB(200,200,200); B.TextSize=12; B.TextXAlignment=Enum.TextXAlignment.Left
                local Box = Instance.new("Frame", F); Box.BackgroundColor3=Color3.fromRGB(25,25,25); Box.BorderColor3=Color3.fromRGB(50,50,50); Box.Position=UDim2.new(1,-18,0.5,-6); Box.Size=UDim2.new(0,12,0,12)
                local Fill = Instance.new("Frame", Box); Fill.BackgroundColor3=Accent; Fill.BorderSizePixel=0; Fill.Size=UDim2.new(1,0,1,0); Fill.Visible=Config.CurrentValue or false
                local function Update(Val) Fill.Visible = Val; if Config.Callback then Config.Callback(Val) end end
                B.MouseButton1Click:Connect(function() Update(not Fill.Visible) end)
                function Obj:Set(Val) Fill.Visible = Val; if Config.Callback then Config.Callback(Val) end end
                return Obj
            end

            -- BUTTON
            function PageFuncs:CreateButton(Config)
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,26)
                local B = Instance.new("TextButton", F); B.BackgroundColor3=Color3.fromRGB(25,25,25); B.BorderColor3=Color3.fromRGB(50,50,50); B.Size=UDim2.new(1,-10,0,22); B.Position=UDim2.new(0,0,0,2)
                B.Font=Enum.Font.Code; B.Text=Config.Name; B.TextColor3=Color3.new(1,1,1); B.TextSize=11
                B.MouseButton1Click:Connect(function() if Config.Callback then Config.Callback() end end)
            end

            -- SLIDER
            function PageFuncs:CreateSlider(Config)
                local Obj = {}
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,35)
                local L = Instance.new("TextLabel", F); L.Text=Config.Name; L.TextColor3=Color3.fromRGB(200,200,200); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,15); L.Font=Enum.Font.Code; L.TextSize=12; L.TextXAlignment=Enum.TextXAlignment.Left
                local V = Instance.new("TextLabel", F); V.Text=tostring(Config.CurrentValue); V.TextColor3=Accent; V.BackgroundTransparency=1; V.Position=UDim2.new(1,-40,0,0); V.Size=UDim2.new(0,30,0,15); V.Font=Enum.Font.Code; V.TextSize=12
                local BG = Instance.new("TextButton", F); BG.BackgroundColor3=Color3.fromRGB(25,25,25); BG.BorderColor3=Color3.fromRGB(50,50,50); BG.Position=UDim2.new(0,0,0,18); BG.Size=UDim2.new(1,-10,0,6); BG.Text=""
                local Fill = Instance.new("Frame", BG); Fill.BackgroundColor3=Accent; Fill.BorderSizePixel=0; Fill.Size=UDim2.new((Config.CurrentValue-Config.Range[1])/(Config.Range[2]-Config.Range[1]),0,1,0)
                local function Update(Val)
                    local P = (Val - Config.Range[1]) / (Config.Range[2] - Config.Range[1])
                    Fill.Size = UDim2.new(P, 0, 1, 0); V.Text = tostring(Val); if Config.Callback then Config.Callback(Val) end
                end
                local Drag=false
                BG.MouseButton1Down:Connect(function() Drag=true end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Drag=false end end)
                UserInputService.InputChanged:Connect(function(i) if Drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    local S = math.clamp((UserInputService:GetMouseLocation().X - BG.AbsolutePosition.X)/BG.AbsoluteSize.X,0,1)
                    local New = math.floor(Config.Range[1] + ((Config.Range[2]-Config.Range[1])*S))
                    Update(New)
                end end)
                function Obj:Set(Val) Update(Val) end
                return Obj
            end

            -- DROPDOWN (Bigger List + Refresh)
            function PageFuncs:CreateDropdown(Config)
                local Obj = {}
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,50); F.ClipsDescendants = true
                local L = Instance.new("TextLabel", F); L.Text=Config.Name; L.TextColor3=Color3.fromRGB(200,200,200); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,20); L.Font=Enum.Font.Code; L.TextSize=12; L.TextXAlignment=Enum.TextXAlignment.Left
                local MainBtn = Instance.new("TextButton", F); MainBtn.BackgroundColor3=Color3.fromRGB(25,25,25); MainBtn.BorderColor3=Color3.fromRGB(50,50,50); MainBtn.Position=UDim2.new(0,0,0,25); MainBtn.Size=UDim2.new(1,-10,0,20); MainBtn.Text=Config.CurrentOption or Config.Options[1]; MainBtn.TextColor3=Accent; MainBtn.Font=Enum.Font.Code; MainBtn.TextSize=11
                local Open = false; local ListSize = 0
                local Scroll = Instance.new("ScrollingFrame", F); Scroll.BackgroundColor3=Color3.fromRGB(20,20,20); Scroll.BorderColor3=Color3.fromRGB(50,50,50); Scroll.Position=UDim2.new(0,0,0,48); Scroll.Size=UDim2.new(1,-10,0,0); Scroll.ScrollBarThickness=2; Scroll.Visible=false
                local SList = Instance.new("UIListLayout", Scroll); SList.SortOrder=Enum.SortOrder.LayoutOrder
                
                MainBtn.MouseButton1Click:Connect(function() 
                    Open = not Open; Scroll.Visible = Open
                    if Open then F.Size = UDim2.new(1, 0, 0, 50 + math.min(ListSize, 150)) else F.Size = UDim2.new(1, 0, 0, 50) end 
                end)
                function Obj:Set(Val) MainBtn.Text = Val; if Config.Callback then Config.Callback(Val) end end
                
                function Obj:Refresh(NewOptions)
                    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, Option in pairs(NewOptions) do
                        local OptBtn = Instance.new("TextButton", Scroll); OptBtn.Size = UDim2.new(1, 0, 0, 20); OptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); OptBtn.Text = Option; OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200); OptBtn.Font = Enum.Font.Code; OptBtn.TextSize = 11; OptBtn.BorderSizePixel = 0
                        OptBtn.MouseButton1Click:Connect(function() Open = false; Scroll.Visible = false; F.Size = UDim2.new(1, 0, 0, 50); Obj:Set(Option) end)
                    end
                    ListSize = #NewOptions * 20
                    Scroll.Size = UDim2.new(1, -10, 0, math.min(ListSize, 150))
                    if Open then F.Size = UDim2.new(1, 0, 0, 50 + math.min(ListSize, 150)) end
                end
                Obj:Refresh(Config.Options)
                return Obj
            end

            -- TEXTBOX
            function PageFuncs:CreateTextBox(Config)
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,40)
                local L = Instance.new("TextLabel", F); L.Text=Config.Name; L.TextColor3=Color3.fromRGB(200,200,200); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,15); L.Font=Enum.Font.Code; L.TextSize=12; L.TextXAlignment=Enum.TextXAlignment.Left
                local Box = Instance.new("TextBox", F); Box.BackgroundColor3=Color3.fromRGB(25,25,25); Box.BorderColor3=Color3.fromRGB(50,50,50); Box.Position=UDim2.new(0,0,0,18); Box.Size=UDim2.new(1,-10,0,20)
                Box.Font=Enum.Font.Code; Box.TextSize=12; Box.TextColor3=Color3.new(1,1,1); Box.Text = ""; Box.PlaceholderText = Config.Placeholder or "..."
                Box:GetPropertyChangedSignal("Text"):Connect(function() if Config.Callback then Config.Callback(Box.Text) end end)
            end

            -- KEYBIND
            function PageFuncs:CreateKeybind(Config)
                local F = Instance.new("Frame", Container); F.BackgroundTransparency=1; F.Size=UDim2.new(1,0,0,22)
                local L = Instance.new("TextLabel", F); L.Text=Config.Name; L.TextColor3=Color3.fromRGB(200,200,200); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,1,0); L.Font=Enum.Font.Code; L.TextSize=12; L.TextXAlignment=Enum.TextXAlignment.Left
                local B = Instance.new("TextButton", F); B.BackgroundColor3=Color3.fromRGB(25,25,25); B.BorderColor3=Color3.fromRGB(50,50,50); B.Position=UDim2.new(1,-70,0.5,-9); B.Size=UDim2.new(0,60,0,18)
                B.TextColor3=Color3.fromRGB(150,150,150); B.Font=Enum.Font.Code; B.TextSize=11
                local Mode = "Toggle"; local Key = Config.Default; local Binding = false
                local function UpdateText() B.Text = Key and Key.Name or "None" end; UpdateText()
                B.MouseButton1Click:Connect(function() Binding=true; B.Text="..."; B.TextColor3=Accent; local i = UserInputService.InputBegan:Wait(); if i.UserInputType==Enum.UserInputType.Keyboard then Key=i.KeyCode; B.TextColor3=Color3.fromRGB(150,150,150); Binding=false; UpdateText() elseif i.UserInputType==Enum.UserInputType.MouseButton1 then Binding=false; B.TextColor3=Color3.fromRGB(150,150,150); UpdateText() end end)
                B.MouseButton2Click:Connect(function()
                    if Library.ActiveMenu then Library.ActiveMenu:Destroy() Library.ActiveMenu = nil end
                    local Menu = Instance.new("Frame", ScreenGui); Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Menu.BorderColor3 = Accent; Menu.BorderSizePixel = 1; Menu.Size = UDim2.new(0, 100, 0, 95); Menu.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y); Menu.ZIndex = 100; Library.ActiveMenu = Menu
                    local Header = Instance.new("Frame", Menu); Header.BackgroundColor3=Color3.fromRGB(30,30,30); Header.BorderSizePixel=0; Header.Size=UDim2.new(1,0,0,20); Header.ZIndex=101
                    local CloseBtn = Instance.new("TextButton", Header); CloseBtn.BackgroundTransparency=1; CloseBtn.Text="X"; CloseBtn.TextColor3=Color3.fromRGB(255,100,100); CloseBtn.Size=UDim2.new(0,20,1,0); CloseBtn.Position=UDim2.new(1,-20,0,0); CloseBtn.Font=Enum.Font.Code; CloseBtn.TextSize=12; CloseBtn.ZIndex=103; CloseBtn.MouseButton1Click:Connect(function() Menu:Destroy() Library.ActiveMenu=nil end)
                    local OptionHolder = Instance.new("Frame", Menu); OptionHolder.BackgroundTransparency=1; OptionHolder.Position=UDim2.new(0,0,0,22); OptionHolder.Size=UDim2.new(1,0,1,-22); OptionHolder.ZIndex=101
                    local Layout = Instance.new("UIListLayout", OptionHolder); Layout.SortOrder=Enum.SortOrder.LayoutOrder
                    local function AddOpt(Name) local Opt = Instance.new("TextButton", OptionHolder); Opt.Size = UDim2.new(1, 0, 0, 22); Opt.BackgroundTransparency = 1; Opt.Text = Name; Opt.Font = Enum.Font.Code; Opt.TextSize = 12; Opt.TextColor3 = (Mode == Name) and Accent or Color3.fromRGB(200, 200, 200); Opt.ZIndex = 102; Opt.MouseButton1Click:Connect(function() if Config.Callback then Config.Callback(false) end; Mode = Name; UpdateText(); Menu:Destroy(); Library.ActiveMenu = nil end) end
                    AddOpt("Toggle"); AddOpt("Hold"); AddOpt("Always")
                end)
                local Toggled = false
                UserInputService.InputBegan:Connect(function(i, p) if p then return end; if i.KeyCode == Key and Mode == "Toggle" then Toggled = not Toggled; if Config.Callback then Config.Callback(Toggled) end end end)
                RunService.RenderStepped:Connect(function() if Mode == "Hold" and Config.Callback then Config.Callback(UserInputService:IsKeyDown(Key or Enum.KeyCode.Unknown)) elseif Mode == "Always" and Config.Callback then Config.Callback(true) end end)
            end
            return PageFuncs
        end
        return TabFuncs
    end
    return WindowFunctions
end
return Library
