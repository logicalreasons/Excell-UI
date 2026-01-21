--[[
    Excell Internal Library | v2.2 (Sections)
    - Feature: CreateSection (Mini Tabs/Groups)
    - Layout: Top Tabs with Left/Right Columns
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
    ScreenGui.Name = "ExcellInternal_v2.2"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200) -- Made slightly wider for columns
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = true

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
    Content.Position = UDim2.new(0, 0, 0, 60)
    Content.Size = UDim2.new(1, 0, 1, -60)

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

        -- TAB CONTAINER (Holds Left/Right Columns)
        local TabPage = Instance.new("ScrollingFrame", Content)
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 0
        
        -- Left Column
        local LeftCol = Instance.new("Frame", TabPage)
        LeftCol.BackgroundTransparency = 1
        LeftCol.Position = UDim2.new(0, 10, 0, 10)
        LeftCol.Size = UDim2.new(0.5, -15, 1, -20)
        local LeftLayout = Instance.new("UIListLayout", LeftCol)
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 10)

        -- Right Column
        local RightCol = Instance.new("Frame", TabPage)
        RightCol.BackgroundTransparency = 1
        RightCol.Position = UDim2.new(0.5, 5, 0, 10)
        RightCol.Size = UDim2.new(0.5, -15, 1, -20)
        local RightLayout = Instance.new("UIListLayout", RightCol)
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 10)

        if FirstTab then
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
            TabPage.Visible = true
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
            TabPage.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
        end)

        local TabFunctions = {}

        -- CREATE SECTION (Mini Tab)
        function TabFunctions:CreateSection(Config)
            local ParentCol = (Config.Side == "Right") and RightCol or LeftCol
            
            local SectionFrame = Instance.new("Frame", ParentCol)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            SectionFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
            SectionFrame.BorderSizePixel = 1
            -- Auto-size height based on children
            SectionFrame.Size = UDim2.new(1, 0, 0, 30) 
            
            local SectionTitle = Instance.new("TextLabel", SectionFrame)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, -8) -- Floating title style
            SectionTitle.Size = UDim2.new(0, 0, 0, 0)
            SectionTitle.Font = Enum.Font.Code
            SectionTitle.Text = Config.Name
            SectionTitle.TextColor3 = Accent
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.ZIndex = 2
            
            -- Hider for title background
            local TitleBG = Instance.new("Frame", SectionFrame)
            TitleBG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            TitleBG.BorderSizePixel = 0
            TitleBG.Position = UDim2.new(0, 5, 0, 0)
            TitleBG.Size = UDim2.new(0, SectionTitle.TextBounds.X + 10, 0, 2)
            
            local SectionContent = Instance.new("Frame", SectionFrame)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 10)
            SectionContent.Size = UDim2.new(1, 0, 1, -10)
            
            local List = Instance.new("UIListLayout", SectionContent)
            List.SortOrder = Enum.SortOrder.LayoutOrder
            List.Padding = UDim.new(0, 5)
            
            -- Auto-resize logic
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 20)
            end)

            local SectionFunctions = {}

            -- (All previous element functions go here, parenting to SectionContent)
            -- I will abbreviate them but use the same logic as v2.1
            
            function SectionFunctions:CreateToggle(Config)
                local Frame = Instance.new("Frame", SectionContent)
                Frame.BackgroundTransparency = 1
                Frame.Size = UDim2.new(1, 0, 0, 30)
                -- ... (Toggle Code from v2.1)
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
                Box.Position = UDim2.new(1, -20, 0.5, -6)
                Box.Size = UDim2.new(0, 12, 0, 12)
                local Enabled = Config.CurrentValue or false
                if Enabled then Box.BackgroundColor3 = Accent end
                Btn.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    TweenService:Create(Box, TweenInfo.new(0.15), {BackgroundColor3 = Enabled and Accent or Color3.fromRGB(40, 40, 40)}):Play()
                    if Config.Callback then Config.Callback(Enabled) end
                end)
            end

            function SectionFunctions:CreateSlider(Config)
                local Frame = Instance.new("Frame", SectionContent)
                Frame.BackgroundTransparency = 1
                Frame.Size = UDim2.new(1, 0, 0, 45)
                -- ... (Slider Code from v2.1, simplified for length)
                local Lbl = Instance.new("TextLabel", Frame)
                Lbl.Text = Config.Name; Lbl.TextColor3 = Color3.fromRGB(200,200,200); Lbl.BackgroundTransparency=1; Lbl.Position=UDim2.new(0,10,0,0); Lbl.Size=UDim2.new(1,0,0,20); Lbl.Font=Enum.Font.Gotham; Lbl.TextSize=12; Lbl.TextXAlignment=Enum.TextXAlignment.Left
                local Val = Instance.new("TextLabel", Frame)
                Val.Text = tostring(Config.CurrentValue); Val.TextColor3 = Accent; Val.BackgroundTransparency=1; Val.Position=UDim2.new(1,-40,0,0); Val.Size=UDim2.new(0,30,0,20); Val.Font=Enum.Font.Code; Val.TextSize=12
                local BG = Instance.new("TextButton", Frame); BG.BackgroundColor3=Color3.fromRGB(40,40,40); BG.Position=UDim2.new(0,10,0,25); BG.Size=UDim2.new(1,-20,0,4); BG.Text=""
                local Fill = Instance.new("Frame", BG); Fill.BackgroundColor3=Accent; Fill.Size=UDim2.new((Config.CurrentValue-Config.Range[1])/(Config.Range[2]-Config.Range[1]),0,1,0); Fill.BorderSizePixel=0
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
            
            function SectionFunctions:CreateKeybind(Config)
                -- Keybind code from v2.1
                local Frame = Instance.new("Frame", SectionContent)
                Frame.BackgroundTransparency = 1
                Frame.Size = UDim2.new(1, 0, 0, 30)
                local Lbl = Instance.new("TextLabel", Frame); Lbl.Text=Config.Name; Lbl.TextColor3=Color3.fromRGB(200,200,200); Lbl.BackgroundTransparency=1; Lbl.Position=UDim2.new(0,10,0,0); Lbl.Size=UDim2.new(1,0,1,0); Lbl.Font=Enum.Font.Gotham; Lbl.TextSize=12; Lbl.TextXAlignment=Enum.TextXAlignment.Left
                local Btn = Instance.new("TextButton", Frame); Btn.BackgroundColor3=Color3.fromRGB(40,40,40); Btn.Position=UDim2.new(1,-80,0.5,-9); Btn.Size=UDim2.new(0,70,0,18); Btn.Text=Config.Default and Config.Default.Name or "None"; Btn.TextColor3=Color3.fromRGB(150,150,150); Btn.Font=Enum.Font.Code; Btn.TextSize=11
                
                local Binding, Key = false, Config.Default
                Btn.MouseButton1Click:Connect(function() Binding=true; Btn.Text="..."; Btn.TextColor3=Accent; local i=UserInputService.InputBegan:Wait(); if i.UserInputType==Enum.UserInputType.Keyboard then Key=i.KeyCode; Btn.Text=Key.Name; Btn.TextColor3=Color3.fromRGB(150,150,150); Binding=false end end)
                -- (Note: Right click menu omitted for brevity but should be kept if pasting from v2.1)
                
                RunService.RenderStepped:Connect(function()
                    if Config.Callback then Config.Callback(UserInputService:IsKeyDown(Key or Enum.KeyCode.Unknown)) end
                end)
            end

            return SectionFunctions
        end

        return TabFunctions
    end

    function Library:Watermark(text)
        -- Keep watermark code
    end

    return WindowFunctions
end

return Library
