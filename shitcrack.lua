--[[
    CRACKED EZZ
    Cracked by: vertoletikk1
    
    Version: v1337
]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local KeyPassed = false

local function CreateKeySystem()
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "SheiltKeySystem"
    Screen.Parent = CoreGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 150)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = Screen
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 140, 0)
    Stroke.Thickness = 2
    Stroke.Parent = Frame
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Title = Instance.new("TextLabel")
    Title.Text = "key: t.me/debug_teams"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 140, 0)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.Parent = Frame
    
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.8, 0, 0, 35)
    Box.Position = UDim2.new(0.1, 0, 0.4, 0)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Box.TextColor3 = Color3.new(1,1,1)
    Box.Text = ""
    Box.PlaceholderText = "Key"
    Box.Font = Enum.Font.GothamBold
    Box.TextSize = 14
    Box.Parent = Frame
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.5, 0, 0, 30)
    Btn.Position = UDim2.new(0.25, 0, 0.75, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    Btn.Text = "LOGIN"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBlack
    Btn.TextSize = 14
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        if Box.Text == "t.me/debug_teams" or Box.Text == "t.me/debug_teams" then
            Screen:Destroy()
            KeyPassed = true
        else
            Box.Text = "WRONG KEY!"
            task.wait(1)
            Box.Text = ""
        end
    end)
    
    return Screen
end

if not game:IsLoaded() then game.Loaded:Wait() end
local KeyUI = CreateKeySystem()

repeat task.wait(0.1) until KeyPassed

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight
local ESP_Cache = {} 
local SafetyActive = false 
local MapColorApplied = false

-- default settings
local Settings = {
    -- combat
    AimbotEnabled = false,
    AimbotActive = false,
    AimbotKey = Enum.KeyCode.LeftAlt,
    AimbotPart = "Head",
    AimbotFOV = 100,
    MaxDistance = 1000,
    ShowFOV = false,
    TeamCheck = true,
    WallCheck = true,
    AutoFire = false,
    HitboxExpander = false,
    HitboxSize = 2,
    -- antiaim
    AntiAim = "None",
    AntiAimToggled = true,
    -- visuals
    ESPEnabled = false,
    ESPChams = false,
    ShowName = false,
    ShowDist = false,
    -- world
    SkyColor = {R=135, G=206, B=235},
    EnableSkyColor = false,
    
    MapColor = {R=255, G=255, B=255},
    EnableMapColor = false,
    
    CamFOV = 70,
    
    -- local
    LocalGhost = false,
    LocalColor = {R=0, G=255, B=127},
    LocalTrans = 0.5,
    
    -- safety
    AntiTase = true,
    AntiLowHP = false,
    LowHPThreshold = 25,
    SafetyDuration = 5,
    AntiKick = true,
    BypassAC = false,
    -- others
    AutoShift = false,
    LogsEnabled = true,
    -- fling
    FlingActive = false,
    SelectedTargets = {}
}

local Colors = {
    Bg = Color3.fromRGB(20, 20, 25),
    Side = Color3.fromRGB(30, 30, 35),
    Elem = Color3.fromRGB(45, 45, 50),
    Main = Color3.fromRGB(255, 140, 0),
    Sec = Color3.fromRGB(0, 120, 255),
    Text = Color3.fromRGB(240, 240, 240),
    Red = Color3.fromRGB(255, 60, 60),
    Guard = Color3.fromRGB(0, 100, 255),
    Inmate = Color3.fromRGB(255, 140, 0),
    Criminal = Color3.fromRGB(200, 0, 0),
}

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "SheiltLogs"
NotifyGui.ResetOnSpawn = false
if game:GetService("CoreGui"):FindFirstChild("SheiltLogs") then
    game:GetService("CoreGui").SheiltLogs:Destroy()
end
NotifyGui.Parent = game:GetService("CoreGui")

local LogContainer = Instance.new("Frame")
LogContainer.Size = UDim2.new(0, 350, 0, 600)
LogContainer.Position = UDim2.new(1, -360, 0, 10)
LogContainer.BackgroundTransparency = 1
LogContainer.Parent = NotifyGui

local LogList = Instance.new("UIListLayout")
LogList.Parent = LogContainer
LogList.SortOrder = Enum.SortOrder.LayoutOrder
LogList.Padding = UDim.new(0, 5)
LogList.VerticalAlignment = Enum.VerticalAlignment.Top
LogList.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function SendLog(text, type)
    if not Settings.LogsEnabled then return end
    
    local accent = Colors.Main
    if type == "Warn" then accent = Color3.fromRGB(255, 200, 0) end
    if type == "Error" then accent = Colors.Red end
    if type == "Kill" then accent = Color3.fromRGB(50, 255, 50) end
    if type == "MyKill" then accent = Color3.fromRGB(255, 215, 0) end
    if type == "Info" then accent = Colors.Sec end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Frame.Parent = LogContainer
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = accent
    Stroke.Thickness = 1
    Stroke.Parent = Frame
    
    local Grad = Instance.new("UIGradient")
    Grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,30)),
        ColorSequenceKeypoint.new(1, accent)
    }
    Grad.Transparency = NumberSequence.new(0.3)
    Grad.Rotation = 180
    Grad.Parent = Frame

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -10, 1, 0)
    Lbl.Position = UDim2.new(0, 5, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Colors.Text
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Frame
    
    game:GetService("Debris"):AddItem(Frame, 6)
end

task.spawn(function()
    local PGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not PGui then return end
    
    local function HookFeed()
        local MainGui = PGui:WaitForChild("MainGui", 5) or PGui:WaitForChild("TestGui", 5)
        if MainGui then
             local Feed = MainGui:FindFirstChild("KillFeed") or MainGui:FindFirstChild("Killlogs")
             if not Feed then
                 for _, v in pairs(MainGui:GetDescendants()) do
                     if v.Name == "KillFeed" then Feed = v break end
                 end
             end
             
             if Feed then
                 Feed.ChildAdded:Connect(function(child)
                     if child:IsA("TextLabel") or child:IsA("Frame") then
                         task.wait(0.1)
                         local txt = ""
                         if child:IsA("TextLabel") then txt = child.Text 
                         elseif child:FindFirstChildOfClass("TextLabel") then txt = child:FindFirstChildOfClass("TextLabel").Text end
                         
                         if txt ~= "" then
                             if string.find(txt, LocalPlayer.Name) then
                                 if string.sub(txt, 1, #LocalPlayer.Name) == LocalPlayer.Name then
                                     SendLog("YOU ELIMINATED: " .. txt, "MyKill")
                                 else
                                     SendLog("YOU DIED: " .. txt, "Error")
                                 end
                             else
                                 SendLog(txt, "Kill")
                             end
                         end
                     end
                 end)
             end
        end
    end
    HookFeed()
    LocalPlayer.CharacterAdded:Connect(function() task.wait(1); HookFeed() end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SheiltPL_GUI"
ScreenGui.ResetOnSpawn = false
if game:GetService("CoreGui"):FindFirstChild("SheiltPL_GUI") then
    game:GetService("CoreGui").SheiltPL_GUI:Destroy()
end
ScreenGui.Parent = game:GetService("CoreGui")

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Colors.Main
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Visible = false

local MobBtn = Instance.new("TextButton")
MobBtn.Name = "MobToggle"
MobBtn.Size = UDim2.new(0, 50, 0, 50)
MobBtn.Position = UDim2.new(0, 20, 0.8, 0)
MobBtn.BackgroundColor3 = Colors.Main
MobBtn.Text = "S"
MobBtn.TextColor3 = Colors.Text
MobBtn.Font = Enum.Font.GothamBlack
MobBtn.TextSize = 20
MobBtn.Parent = ScreenGui
Instance.new("UICorner", MobBtn).CornerRadius = UDim.new(0, 8)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 450)
Main.Position = UDim2.new(0.5, -300, 0.5, -225)
Main.BackgroundColor3 = Colors.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Stroke = Instance.new("UIStroke")
Stroke.Color = Colors.Main
Stroke.Thickness = 2
Stroke.Parent = Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Side = Instance.new("Frame")
Side.Size = UDim2.new(0, 150, 1, 0)
Side.BackgroundColor3 = Colors.Side
Side.BorderSizePixel = 0
Side.Parent = Main
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = "SHEILT\nPRISON LIFE\nGUI"
Title.TextColor3 = Colors.Main
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Parent = Side

local PageHold = Instance.new("Frame")
PageHold.Position = UDim2.new(0, 150, 0, 0)
PageHold.Size = UDim2.new(1, -150, 1, 0)
PageHold.BackgroundTransparency = 1
PageHold.Parent = Main

local Tabs = {}
local function CreateTab(name, parent)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -20, 1, -20)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ScrollBarThickness = 6
    frame.BorderSizePixel = 0
    frame.Parent = parent
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Tabs[name] = frame
    return frame
end

local Tab_Fling = CreateTab("Fling", PageHold)
local Tab_Combat = CreateTab("Combat", PageHold)
local Tab_Visuals = CreateTab("Visuals", PageHold)
local Tab_Safety = CreateTab("Safety", PageHold)
local Tab_Others = CreateTab("Others", PageHold)

Tab_Fling.Visible = true

local function MakeTabBtn(name, txt, y, tabToOpen)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 40)
    Btn.Position = UDim2.new(0, 10, 0, y)
    Btn.BackgroundColor3 = (name == "Fling") and Colors.Main or Colors.Elem
    Btn.Text = txt
    Btn.TextColor3 = (name == "Fling") and Colors.Text or Colors.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Parent = Side
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        tabToOpen.Visible = true
        for _, c in pairs(Side:GetChildren()) do
            if c:IsA("TextButton") then
                c.BackgroundColor3 = Colors.Elem
                c.TextColor3 = Colors.Text
            end
        end
        Btn.BackgroundColor3 = Colors.Main
    end)
end

MakeTabBtn("Fling", "Fling / TP", 70, Tab_Fling)
MakeTabBtn("Combat", "Combat", 115, Tab_Combat)
MakeTabBtn("Visuals", "Visuals", 160, Tab_Visuals)
MakeTabBtn("Safety", "Safety", 205, Tab_Safety)
MakeTabBtn("Others", "Others", 250, Tab_Others)

local function AddToggle(parent, text, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundColor3 = Colors.Elem
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0.05, 0, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Colors.Text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 24, 0, 24)
    b.Position = UDim2.new(0.9, -24, 0.5, -12)
    b.BackgroundColor3 = default and Colors.Main or Color3.fromRGB(80, 80, 80)
    b.Text = ""
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    local on = default
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Colors.Main or Color3.fromRGB(80, 80, 80)
        callback(on)
    end)
    
    if parent:IsA("ScrollingFrame") then
        if not parent:FindFirstChild("UIListLayout") then
            local ll = Instance.new("UIListLayout")
            ll.Padding = UDim.new(0, 8)
            ll.SortOrder = Enum.SortOrder.LayoutOrder
            ll.Parent = parent
        end
        parent.CanvasSize = UDim2.new(0, 0, 0, (#parent:GetChildren() * 60))
    end
end

local function AddSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundColor3 = Colors.Elem
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 20)
    l.Position = UDim2.new(0, 10, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. default
    l.TextColor3 = Colors.Text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.9, 0, 0, 6)
    bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    bar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bar.BorderSizePixel = 0
    bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Main
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = bar

    local dragging = false
    btn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local pos = UserInputService:GetMouseLocation().X
            local rel = math.clamp((pos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max-min)*rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            l.Text = text .. ": " .. val
            callback(val)
        end
    end)
    if parent:IsA("ScrollingFrame") then
        parent.CanvasSize = UDim2.new(0, 0, 0, (#parent:GetChildren() * 70))
    end
end

local function AddColorPicker(parent, text, defaultRGB, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 110)
    f.BackgroundColor3 = Colors.Elem
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 0, 20)
    l.Position = UDim2.new(0, 10, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Colors.Text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 40, 0, 20)
    preview.Position = UDim2.new(1, -50, 0, 5)
    preview.BackgroundColor3 = Color3.fromRGB(defaultRGB.R, defaultRGB.G, defaultRGB.B)
    preview.Parent = f
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
    
    local rgb = {R=defaultRGB.R, G=defaultRGB.G, B=defaultRGB.B}
    
    local function makeSubSlider(name, y, col, key)
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0.9, 0, 0, 6)
        bar.Position = UDim2.new(0.05, 0, 0, y)
        bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        bar.Parent = f
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(rgb[key]/255, 0, 1, 0)
        fill.BackgroundColor3 = col
        fill.Parent = bar
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = bar
        
        local drag = false
        btn.MouseButton1Down:Connect(function() drag = true end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
        
        RunService.RenderStepped:Connect(function()
            if drag then
                local pos = UserInputService:GetMouseLocation().X
                local rel = math.clamp((pos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                rgb[key] = math.floor(rel * 255)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                preview.BackgroundColor3 = Color3.fromRGB(rgb.R, rgb.G, rgb.B)
                callback(Color3.fromRGB(rgb.R, rgb.G, rgb.B))
            end
        end)
    end
    
    makeSubSlider("R", 35, Color3.new(1,0,0), "R")
    makeSubSlider("G", 60, Color3.new(0,1,0), "G")
    makeSubSlider("B", 85, Color3.new(0,0,1), "B")
    
    if parent:IsA("ScrollingFrame") then
        parent.CanvasSize = UDim2.new(0, 0, 0, (#parent:GetChildren() * 130))
    end
end

local function AddDropdown(parent, text, options, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundColor3 = Colors.Elem
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text .. ": " .. options[1]
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = f
    
    local idx = 1
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = text .. ": " .. options[idx]
        callback(options[idx])
    end)
    if parent:IsA("ScrollingFrame") then
        parent.CanvasSize = UDim2.new(0, 0, 0, (#parent:GetChildren() * 60))
    end
end

AddToggle(Tab_Combat, "Aimbot Enabled", false, function(v) 
    Settings.AimbotEnabled = v 
    SendLog("Aimbot "..(v and "Enabled" or "Disabled"), "Info")
end)
AddToggle(Tab_Combat, "Show FOV Circle", false, function(v) Settings.ShowFOV = v end)
AddSlider(Tab_Combat, "Aimbot Range (Dist)", 50, 3000, 1000, function(v) 
    Settings.MaxDistance = v 
end)
AddSlider(Tab_Combat, "FOV Radius", 10, 500, 100, function(v) 
    Settings.AimbotFOV = v 
    FOVCircle.Radius = v
end)
AddToggle(Tab_Combat, "Auto Fire", false, function(v) Settings.AutoFire = v end)
AddToggle(Tab_Combat, "Wall Check", true, function(v) Settings.WallCheck = v end)
AddDropdown(Tab_Combat, "Aim Part", {"Head", "Torso"}, function(v) Settings.AimbotPart = v end)

AddToggle(Tab_Combat, "Hitbox Expander", false, function(v) 
    Settings.HitboxExpander = v 
end)
AddSlider(Tab_Combat, "Hitbox Size", 2, 10, 2, function(v) Settings.HitboxSize = v end)

AddDropdown(Tab_Combat, "Anti-Aim", {"None", "Spin", "Jitter"}, function(v) 
    Settings.AntiAim = v 
end)

AddToggle(Tab_Visuals, "ESP Enabled", false, function(v) Settings.ESPEnabled = v end)
AddToggle(Tab_Visuals, "Chams (Fill)", false, function(v) Settings.ESPChams = v end)
AddToggle(Tab_Visuals, "Show Names", false, function(v) Settings.ShowName = v end)
AddToggle(Tab_Visuals, "Show Distance", false, function(v) Settings.ShowDist = v end)

AddToggle(Tab_Visuals, "Apply Sky Color", false, function(v) Settings.EnableSkyColor = v end)
AddColorPicker(Tab_Visuals, "Sky Color", {R=135,G=206,B=235}, function(c)
    Settings.SkyColor = c
end)

AddToggle(Tab_Visuals, "Apply Map Color", false, function(v) 
    Settings.EnableMapColor = v 
end)
AddColorPicker(Tab_Visuals, "Map Texture Color", {R=255,G=255,B=255}, function(c)
    Settings.MapColor = c
    if Settings.EnableMapColor then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v:IsDescendantOf(LocalPlayer.Character) then
                 v.Color = Settings.MapColor
            end
        end
    end
end)

AddToggle(Tab_Visuals, "Ghost Mode (Self)", false, function(v) Settings.LocalGhost = v end)
AddColorPicker(Tab_Visuals, "Ghost Color", {R=0,G=255,B=127}, function(c) Settings.LocalColor = c end)
AddSlider(Tab_Visuals, "Ghost Transparency", 0, 10, 5, function(v) Settings.LocalTrans = v/10 end)

AddSlider(Tab_Visuals, "Camera FOV", 70, 120, 70, function(v) Settings.CamFOV = v end)

AddToggle(Tab_Safety, "Anti-Tase (Teleport)", true, function(v) Settings.AntiTase = v end)
AddToggle(Tab_Safety, "Anti-LowHP (Teleport)", false, function(v) Settings.AntiLowHP = v end)
AddSlider(Tab_Safety, "Low HP Threshold", 5, 80, 25, function(v) Settings.LowHPThreshold = v end)
AddSlider(Tab_Safety, "Safety Duration (Sec)", 1, 10, 3, function(v) Settings.SafetyDuration = v end)
AddToggle(Tab_Safety, "Anti-Kick", true, function(v) Settings.AntiKick = v end)
AddToggle(Tab_Safety, "Bypass Anti-Cheat", false, function(v) 
    Settings.BypassAC = v 
    if v then SendLog("Bypass Enabled: Removing Client Scripts", "Warn") end
end)

AddToggle(Tab_Others, "Auto Sprint (Shift)", false, function(v) Settings.AutoShift = v end)
AddToggle(Tab_Others, "Show Logs", true, function(v) Settings.LogsEnabled = v end)

-- no use fling in prison life
local FlingStatus = Instance.new("TextLabel")
FlingStatus.Size = UDim2.new(1, 0, 0, 25)
FlingStatus.BackgroundTransparency = 1
FlingStatus.Text = "STATUS: IDLE"
FlingStatus.TextColor3 = Colors.Text
FlingStatus.Font = Enum.Font.GothamBold
FlingStatus.TextSize = 14
FlingStatus.Parent = Tab_Fling

local FlingList = Instance.new("ScrollingFrame")
FlingList.Size = UDim2.new(1, 0, 1, -85)
FlingList.Position = UDim2.new(0, 0, 0, 25)
FlingList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
FlingList.BorderSizePixel = 0
FlingList.ScrollBarThickness = 4
FlingList.Parent = Tab_Fling
Instance.new("UICorner", FlingList).CornerRadius = UDim.new(0, 6)

local ActionContainer = Instance.new("Frame")
ActionContainer.Size = UDim2.new(1, 0, 0, 55)
ActionContainer.Position = UDim2.new(0, 0, 1, -55)
ActionContainer.BackgroundTransparency = 1
ActionContainer.Parent = Tab_Fling

local function CreateActionBtn(txt, col, pos, sz, func)
    local b = Instance.new("TextButton")
    b.Size = sz
    b.Position = pos
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Colors.Text
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 12
    b.Parent = ActionContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(func)
    return b
end

local Checks = {}
local function RefreshPlayerList()
    for _, v in pairs(FlingList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    Checks = {}
    local all = Players:GetPlayers()
    table.sort(all, function(a,b) return a.Name < b.Name end)
    local y = 0
    for _, p in ipairs(all) do
        if p ~= LocalPlayer then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -10, 0, 40)
            row.Position = UDim2.new(0, 0, 0, y)
            row.BackgroundColor3 = Colors.Elem
            row.Parent = FlingList
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            
            local nm = Instance.new("TextLabel")
            nm.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            nm.Size = UDim2.new(0.5, 0, 1, 0)
            nm.Position = UDim2.new(0.05, 0, 0, 0)
            nm.BackgroundTransparency = 1
            nm.TextColor3 = Colors.Text
            nm.Font = Enum.Font.GothamBold
            nm.TextSize = 12
            nm.TextXAlignment = Enum.TextXAlignment.Left
            nm.Parent = row
            
            local tp = Instance.new("TextButton")
            tp.Text = "TP"
            tp.Size = UDim2.new(0, 30, 0, 24)
            tp.Position = UDim2.new(0.7, 0, 0.5, -12)
            tp.BackgroundColor3 = Colors.Main
            tp.TextColor3 = Colors.Text
            tp.Font = Enum.Font.GothamBold
            tp.TextSize = 12
            tp.Parent = row
            Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 4)
            
            tp.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end)
            
            local sel = Instance.new("TextButton")
            sel.Text = ""
            sel.Size = UDim2.new(0, 24, 0, 24)
            sel.Position = UDim2.new(0.88, 0, 0.5, -12)
            sel.BackgroundColor3 = Settings.SelectedTargets[p.Name] and Colors.Main or Color3.fromRGB(80, 80, 80)
            sel.Parent = row
            Instance.new("UICorner", sel).CornerRadius = UDim.new(0, 4)
            
            sel.MouseButton1Click:Connect(function()
                if Settings.SelectedTargets[p.Name] then
                    Settings.SelectedTargets[p.Name] = nil
                    sel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                else
                    Settings.SelectedTargets[p.Name] = p
                    sel.BackgroundColor3 = Colors.Main
                end
            end)
            
            Checks[p.Name] = sel
            y = y + 45
        end
    end
    FlingList.CanvasSize = UDim2.new(0, 0, 0, y)
end

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)

CreateActionBtn("START", Colors.Main, UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 0, 30), function()
    if Settings.FlingActive then return end
    Settings.FlingActive = true
    FlingStatus.Text = "FLING ACTIVE!"
    FlingStatus.TextColor3 = Colors.Main
end)

CreateActionBtn("STOP", Colors.Red, UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 0, 30), function()
    Settings.FlingActive = false
    FlingStatus.Text = "STOPPED"
    FlingStatus.TextColor3 = Colors.Red
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.zero
    end
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
end)

CreateActionBtn("ALL", Colors.Elem, UDim2.new(0, 0, 0, 35), UDim2.new(0.23, 0, 0, 20), function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            Settings.SelectedTargets[p.Name] = p
            if Checks[p.Name] then Checks[p.Name].BackgroundColor3 = Colors.Main end
        end
    end
end)

CreateActionBtn("CLEAR", Colors.Elem, UDim2.new(0.25, 0, 0, 35), UDim2.new(0.23, 0, 0, 20), function()
    Settings.SelectedTargets = {}
    for _, b in pairs(Checks) do b.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end
end)

-- no use fling in prison life
spawn(function()
    while true do
        if Settings.FlingActive then
            local targets = {}
            for _, p in pairs(Settings.SelectedTargets) do table.insert(targets, p) end
            
            if #targets > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local MyRoot = LocalPlayer.Character.HumanoidRootPart
                if not getgenv().OldPos then getgenv().OldPos = MyRoot.CFrame end
                workspace.FallenPartsDestroyHeight = 0/0
                
                local BV = Instance.new("BodyVelocity")
                BV.Parent = MyRoot
                BV.Velocity = Vector3.zero
                BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                
                for _, target in ipairs(targets) do
                    if not Settings.FlingActive then break end
                    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local TPos = target.Character.HumanoidRootPart.Position
                        local Start = tick()
                        while Settings.FlingActive and (tick() - Start < 1.0) and target.Character do
                             MyRoot.CFrame = CFrame.new(TPos) * CFrame.Angles(math.rad(90),0,0)
                             MyRoot.Velocity = Vector3.new(9e7, 9e7*10, 9e7)
                             MyRoot.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                             task.wait()
                             MyRoot.CFrame = CFrame.new(TPos + Vector3.new(0, -5, 0))
                             task.wait()
                        end
                    end
                end
                BV:Destroy()
            else
                task.wait(0.1)
            end
        else
            if getgenv().OldPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().OldPos
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
                getgenv().OldPos = nil
                workspace.FallenPartsDestroyHeight = getgenv().FPDH
            end
            task.wait(0.5)
        end
        task.wait()
    end
end)

local function IsVisible(targetPart, ignoreList)
    if not Settings.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreList
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local result = Workspace:Raycast(origin, direction, params)
    return result == nil or result.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetClosestTarget()
    local closest = nil
    local shortestDist = Settings.AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    
    local MyTeam = LocalPlayer.Team
    local AmICrim = (MyTeam and MyTeam.Name == "Criminals")
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            
            local IsGuard = (plr.Team and plr.Team.Name == "Guards")
            local AllowTarget = true
            
            if Settings.TeamCheck then
                if AmICrim and IsGuard then
                    AllowTarget = true
                elseif plr.Team == MyTeam then
                    AllowTarget = false
                elseif (MyTeam and MyTeam.Name == "Guards") and IsGuard then
                    AllowTarget = false
                end
            end

            if not AllowTarget then continue end

            local part = plr.Character:FindFirstChild(Settings.AimbotPart)
            if part then
                local distToPlayer = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude
                if distToPlayer > Settings.MaxDistance then continue end

                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if dist < shortestDist then
                        if IsVisible(part, {LocalPlayer.Character, plr.Character}) then
                            closest = plr
                            shortestDist = dist
                        end
                    end
                end
            end
        end
    end
    return closest
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Settings.AimbotKey then
            Settings.AimbotActive = not Settings.AimbotActive
            SendLog("Aimbot Active: " .. tostring(Settings.AimbotActive), Settings.AimbotActive and "Info" or "Warn")
        end
        if input.KeyCode == Enum.KeyCode.Z then
            Settings.AntiAimToggled = not Settings.AntiAimToggled
            SendLog("Anti-Aim: " .. (Settings.AntiAimToggled and "ON" or "OFF"), "Info")
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.ShowFOV then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = Settings.AimbotFOV
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    if Settings.AimbotEnabled and Settings.AimbotActive then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(Settings.AimbotPart) then
            local part = target.Character[Settings.AimbotPart]
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            if Settings.AutoFire then 
                mouse1click() 
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.HitboxExpander then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                if Settings.TeamCheck and plr.Team == LocalPlayer.Team then continue end
                
                local head = plr.Character.Head
                if head:IsA("BasePart") then
                    head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    head.CanCollide = false
                    head.Transparency = 0.6
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Settings.AntiAim ~= "None" and Settings.AntiAimToggled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.AutoRotate = false end
        
        local currentPos = hrp.Position
        local newRot = hrp.CFrame.Rotation
        
        if Settings.AntiAim == "Spin" then
            newRot = CFrame.Angles(0, math.rad(tick() * 500 % 360), 0)
        elseif Settings.AntiAim == "Jitter" then
            newRot = CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
        end
        hrp.CFrame = CFrame.new(currentPos) * newRot
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
    end
end)

local GuardSafe = CFrame.new(1100, 100, 2500) 

local function PerformSafeTeleport()
    if SafetyActive then return end
    SafetyActive = true
    SendLog("Teleporting to Safety Zone!", "Warn")
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local oldCF = char.HumanoidRootPart.CFrame
        local targetCF = GuardSafe
        
        char.HumanoidRootPart.CFrame = targetCF
        
        task.wait(Settings.SafetyDuration)
        
        if char.Humanoid.Health > 0 then
             char.HumanoidRootPart.CFrame = oldCF
             SendLog("Returned to battle", "Info")
        end
    end
    SafetyActive = false
end

-- bypass anticheat logic
local function DoBypass(char)
    if not Settings.BypassAC then return end
    if not char then return end
    
    local targets = {"Client", "LocalHandler", "Flashlight"} 
    
    for _, t in pairs(targets) do
        local s = char:FindFirstChild(t)
        if s and s:IsA("LocalScript") then
            s:Destroy()
            SendLog("Bypassed AC: Removed "..t, "Warn")
        end
    end
end

local function HookChar(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    
    DoBypass(char)
    
    hum.HealthChanged:Connect(function(newHp)
        if Settings.AntiLowHP and newHp < Settings.LowHPThreshold and newHp > 0 then
            PerformSafeTeleport()
        end
    end)
    
    hum.StateChanged:Connect(function(oldState, newState)
        if Settings.AntiTase then
            if newState == Enum.HumanoidStateType.PlatformStand then
                PerformSafeTeleport()
            end
        end
    end)
    
    task.spawn(function()
        while char.Parent do
            task.wait()
            if Settings.AutoShift and hum.WalkSpeed > 0 then
                hum.WalkSpeed = 24
            end
            
            if Settings.LocalGhost then
                 for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                         part.Color = Settings.LocalColor
                         part.Transparency = Settings.LocalTrans
                         part.Material = Enum.Material.Neon
                    end
                 end
            end
            
            if Settings.BypassAC then
                if char:FindFirstChild("Client") then char.Client:Destroy() end
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(HookChar)
if LocalPlayer.Character then HookChar(LocalPlayer.Character) end

local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "ESP_Folder"

local function ClearESP(plr)
    if ESP_Cache[plr] then
        if ESP_Cache[plr].Highlight then ESP_Cache[plr].Highlight:Destroy() end
        if ESP_Cache[plr].BillBoard then ESP_Cache[plr].BillBoard:Destroy() end
        ESP_Cache[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = Settings.CamFOV
    
    if Settings.EnableSkyColor then
        Lighting.Ambient = Settings.SkyColor
        Lighting.OutdoorAmbient = Settings.SkyColor
    else
        Lighting.Ambient = Color3.fromRGB(127, 127, 127) 
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
    
    if Settings.EnableMapColor then
    end

    if not Settings.ESPEnabled then 
        for plr, _ in pairs(ESP_Cache) do ClearESP(plr) end
        return 
    end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            if Settings.TeamCheck and plr.Team == LocalPlayer.Team then 
                ClearESP(plr)
                continue 
            end

            if not ESP_Cache[plr] then
                local hl = Instance.new("Highlight")
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.Parent = ESPFolder
                
                local bg = Instance.new("BillboardGui")
                bg.Size = UDim2.new(0, 200, 0, 50)
                bg.StudsOffset = Vector3.new(0, 3, 0)
                bg.AlwaysOnTop = true
                bg.Parent = ESPFolder
                
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 14
                txt.TextStrokeTransparency = 0
                txt.Parent = bg
                
                ESP_Cache[plr] = { Highlight = hl, BillBoard = bg, TextLabel = txt }
            end
            
            local cache = ESP_Cache[plr]
            local col = Colors.Text
            if plr.Team then
                if plr.Team.Name == "Guards" then col = Colors.Guard
                elseif plr.Team.Name == "Inmates" then col = Colors.Inmate
                elseif plr.Team.Name == "Criminals" then col = Colors.Criminal
                end
            end
            
            cache.Highlight.Adornee = plr.Character
            cache.Highlight.FillColor = col
            cache.Highlight.Enabled = Settings.ESPChams
            
            if Settings.ShowName then
                local dist = ""
                if Settings.ShowDist and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local mag = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.Head.Position).Magnitude
                    dist = string.format(" [%.0f]", mag)
                end
                
                cache.BillBoard.Adornee = plr.Character.Head
                cache.TextLabel.Text = plr.Name .. dist .. "\nHP: " .. math.floor(plr.Character.Humanoid.Health)
                cache.TextLabel.TextColor3 = col
                cache.BillBoard.Enabled = true
            else
                cache.BillBoard.Enabled = false
            end
        else
            ClearESP(plr)
        end
    end
end)

Players.PlayerRemoving:Connect(ClearESP)

LocalPlayer.Idled:Connect(function()
    if Settings.AntiKick then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

task.spawn(function()
    local s, e = pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if Settings.AntiKick and method == "Kick" then
                if self == LocalPlayer then
                    SendLog("Blocked a Kick Attempt!", "Warn")
                    return nil
                end
            end
            
            return old(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
end)

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)
MobBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

RefreshPlayerList()
SendLog("можешь не чистить пк, ратка уже в материнке)", "Info")
