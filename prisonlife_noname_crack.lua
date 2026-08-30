--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= STATE =================
local State = {
    AimbotEnabled = false,
    LockTeammates = false,
    DisableWallLock = false,
    ShowFOV = false,
    AimbotFOV = 50,
    AimbotTargetPart = "Head"
}

-- ================= FOV CIRCLE =================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Visible = false

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrisonLifeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,520,0,400)
mainFrame.Position = UDim2.new(0.5,-260,0.5,-200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(0,0,0)
mainStroke.Thickness = 2

-- Top Bar
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundColor3 = Color3.fromRGB(27,27,27)
topBar.BackgroundTransparency = 0.6
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,12)
Instance.new("UIStroke", topBar).Color = Color3.fromRGB(0,0,0)

-- ================= WINDOW CONTROL BUTTONS =================
local UserInputService = game:GetService("UserInputService")

local minimized = false
local guiVisible = true
local storedSize = mainFrame.Size

-- Control Frame
local controlFrame = Instance.new("Frame", topBar)
controlFrame.Size = UDim2.new(0,80,1,0)
controlFrame.Position = UDim2.new(1,-80,0,0)
controlFrame.BackgroundTransparency = 1

local buttonSize = UDim2.new(0,35,0,25)

-- Close Button
local closeBtn = Instance.new("TextButton", controlFrame)
closeBtn.Size = buttonSize
closeBtn.Position = UDim2.new(0,40,0,0)
closeBtn.Text = "x"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,4)

-- Close Logic
closeBtn.MouseButton1Click:Connect(function()
    guiVisible = false
    ScreenGui.Enabled = false
end)

-- Hotkey K to reopen
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
end)

-- Tabs
local tabHolder = Instance.new("Frame", mainFrame)
tabHolder.Size = UDim2.new(0,110,1,-50)
tabHolder.Position = UDim2.new(0,0,0,50)
tabHolder.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", tabHolder).CornerRadius = UDim.new(0,12)

local tabs = {"Combat","ESP","Teleport","More","Info"}
local pages = {}
local spacing = 10
local btnHeight = 50

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size = UDim2.new(1,0,0,btnHeight)
    btn.Position = UDim2.new(0,0,0,(i-1)*(btnHeight+spacing)+20)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local page = Instance.new("Frame", mainFrame)
    page.Size = UDim2.new(1,-110,1,-50)
    page.Position = UDim2.new(0,110,0,50)
    page.BackgroundTransparency = 1
    page.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(pages) do p.Visible=false end
        page.Visible=true
    end)

    pages[name] = page
end
pages["Combat"].Visible = true

-- ================= TOGGLE FUNCTION =================
local function CreateToggle(parent,text,y,callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,-20,0,30)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = Color3.fromRGB(0,0,0)
    row.BackgroundTransparency = 0.3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(0,0,0)
    stroke.Thickness = 2

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.6,0,1,0)
    label.Position = UDim2.new(0,8,0,0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", row)
    toggle.Size = UDim2.new(0.3,0,0.8,0)
    toggle.Position = UDim2.new(0.65,0,0.1,0)
    toggle.Text = "OFF"
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
    toggle.BackgroundTransparency = 0.3
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,1)
    Instance.new("UIStroke", toggle).Color = Color3.fromRGB(0,0,0)
    Instance.new("UIStroke", toggle).Thickness = 0.5

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- ================= COMBAT TAB =================
local Combat = pages["Combat"]
CreateToggle(Combat,"Aimbot",10,function(v) State.AimbotEnabled=v end)
CreateToggle(Combat,"Teammates",50,function(v) State.LockTeammates=v end)
CreateToggle(Combat,"Wall Check",90,function(v) State.DisableWallLock=v end)
CreateToggle(Combat,"Show FOV",130,function(v) State.ShowFOV=v; FOVCircle.Visible=v end)

-- FOV Adjusters
local function AddFOVAdjust(parent,y)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,-20,0,30)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = Color3.fromRGB(0,0,0)
    row.BackgroundTransparency = 0.3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.3,0,1,0)
    label.Position = UDim2.new(0,8,0,0)
    label.Text = "FOV: "..State.AimbotFOV
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local plus = Instance.new("TextButton", row)
    plus.Size = UDim2.new(0.15,0,0.7,0)
    plus.Position = UDim2.new(0.45,0,0.15,0)
    plus.Text = "+"
    plus.Font = Enum.Font.Gotham
    plus.TextSize = 14
    plus.TextColor3 = Color3.new(1,1,1)
    plus.BackgroundColor3 = Color3.fromRGB(0,0,0)
    plus.BackgroundTransparency = 0.3
    Instance.new("UICorner", plus).CornerRadius = UDim.new(0,4)
    plus.MouseButton1Click:Connect(function()
        State.AimbotFOV = math.clamp(State.AimbotFOV+10,10,500)
        label.Text = "FOV: "..State.AimbotFOV
    end)

    local minus = Instance.new("TextButton", row)
    minus.Size = UDim2.new(0.15,0,0.7,0)
    minus.Position = UDim2.new(0.65,0,0.15,0)
    minus.Text = "-"
    minus.Font = Enum.Font.Gotham
    minus.TextSize = 14
    minus.TextColor3 = Color3.new(1,1,1)
    minus.BackgroundColor3 = Color3.fromRGB(0,0,0)
    minus.BackgroundTransparency = 0.3
    Instance.new("UICorner", minus).CornerRadius = UDim.new(0,4)
    minus.MouseButton1Click:Connect(function()
        State.AimbotFOV = math.clamp(State.AimbotFOV-10,10,500)
        label.Text = "FOV: "..State.AimbotFOV
    end)
end
AddFOVAdjust(Combat,170)

-- Target Part Selector
local function AddTargetSelector(parent,y)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,-20,0,30)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = Color3.fromRGB(0,0,0)
    row.BackgroundTransparency = 0.3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.4,0,1,0)
    label.Position = UDim2.new(0,8,0,0)
    label.Text = "Target Part"
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0.35,0,0.8,0)
    btn.Position = UDim2.new(0.55,0,0.1,0)
    btn.Text = State.AimbotTargetPart
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = 0.3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    btn.MouseButton1Click:Connect(function()
        State.AimbotTargetPart = State.AimbotTargetPart=="Head" and "Torso" or "Head"
        btn.Text = State.AimbotTargetPart
    end)
end
AddTargetSelector(Combat,210)

-- ================= TEAM LOCK =================
local TeamLockOptions = {"All", "Guards", "Inmates", "Criminals"}
local SelectedTeams = {All = true} -- default All selected

local function CreateTeamLock(parent,y)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,-20,0,40)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = Color3.fromRGB(0,0,0)
    row.BackgroundTransparency = 0.3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(0,0,0)
    stroke.Thickness = 2

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.3,0,1,0)
    label.Position = UDim2.new(0,8,0,0)
    label.Text = "Choose Team"
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local buttons = {}

    local buttonX = 0.35
    local buttonWidth = 0.15

    for i,team in ipairs(TeamLockOptions) do
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(buttonWidth,0,0.8,0)
        btn.Position = UDim2.new(buttonX + (i-1)*(buttonWidth+0.02),0,0.1,0)
        btn.Text = team
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

        local outline = Instance.new("UIStroke", btn)
        outline.Color = Color3.fromRGB(0,0,0)
        outline.Thickness = 2

        buttons[team] = outline

        btn.MouseButton1Click:Connect(function()

            if team == "All" then
                -- Selecting All clears others
                SelectedTeams = {All = true}
                for t,o in pairs(buttons) do
                    o.Color = (t == "All") and Color3.fromRGB(0,150,255) or Color3.fromRGB(0,0,0)
                end
            else
                -- Deselect All
                SelectedTeams["All"] = nil
                buttons["All"].Color = Color3.fromRGB(0,0,0)

                -- Toggle individual team
                SelectedTeams[team] = not SelectedTeams[team]

                outline.Color = SelectedTeams[team] and Color3.fromRGB(0,150,255) or Color3.fromRGB(0,0,0)
            end
        end)
    end

    -- 🔥 FORCE DEFAULT VISUAL HIGHLIGHT
    buttons["All"].Color = Color3.fromRGB(0,150,255)
end

CreateTeamLock(Combat,250)

-- ================= OPTIMIZED AIMBOT CORE =================

-- Visibility Check
local function IsVisible(part)
    if State.DisableWallLock then
        return true
    end

    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = Workspace:Raycast(origin, direction, rayParams)
    return result and result.Instance and result.Instance:IsDescendantOf(part.Parent)
end

-- Target Finder
local function GetClosestTarget()
    local bestPart = nil
    local shortestDistance = State.AimbotFOV

    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end

        local character = player.Character
        if not character then
            continue
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            continue
        end
		
        local teamName = player.Team and player.Team.Name or "Criminals"
        if not SelectedTeams["All"] and not SelectedTeams[teamName] then
            continue
        end

        local targetPart = character:FindFirstChild(State.AimbotTargetPart)
        if not targetPart then
            continue
        end

        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then
            continue
        end

        if not IsVisible(targetPart) then
            continue
        end

        local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if magnitude < shortestDistance then
            shortestDistance = magnitude
            bestPart = targetPart
        end
    end

    return bestPart
end

-- Main Loop (Optimized)
RunService.Heartbeat:Connect(function()
    -- Update FOV Circle
    if FOVCircle then
        FOVCircle.Position = Vector2.new(
            Camera.ViewportSize.X * 0.5,
            Camera.ViewportSize.Y * 0.5
        )
        FOVCircle.Radius = State.AimbotFOV
        FOVCircle.Visible = State.ShowFOV
    end

    if not State.AimbotEnabled then
        return
    end

    local target = GetClosestTarget()
    if target then
        Camera.CFrame = CFrame.lookAt(
            Camera.CFrame.Position,
            target.Position
        )
    end
end)

-- ================= ESP TAB =================
local ESPPage = pages["ESP"]
local NO_TEAM_COLOR = Color3.fromRGB(0,255,0)
local ESPSettings = {BoxESP=false,OutlineESP=false,ShowName=false,ShowDistance=false,ESPTeammates=false}
local ESPObjects = {}

-- ESP Buttons
local function AddESPButton(text,y,key)
    local row = Instance.new("Frame", ESPPage)
    row.Size = UDim2.new(1,-20,0,30)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = Color3.fromRGB(0,0,0)
    row.BackgroundTransparency = 0.3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.6,0,1,0)
    label.Position = UDim2.new(0,8,0,0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", row)
    toggle.Size = UDim2.new(0.3,0,0.8,0)
    toggle.Position = UDim2.new(0.65,0,0.1,0)
    toggle.Text = "OFF"
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
    toggle.BackgroundTransparency = 0.3
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,1)

    toggle.MouseButton1Click:Connect(function()
        ESPSettings[key] = not ESPSettings[key]
        toggle.Text = ESPSettings[key] and "ON" or "OFF"
    end)
end

AddESPButton("Box ESP",10,"BoxESP")
AddESPButton("Outline ESP",50,"OutlineESP")
AddESPButton("Show Name",90,"ShowName")
AddESPButton("Show Distance",130,"ShowDistance")
AddESPButton("ESP Teammates",170,"ESPTeammates")

-- ================= ESP LOGIC =================
local function shouldESP(p)
    if p == LocalPlayer then return false end
    if not ESPSettings.ESPTeammates and LocalPlayer.Team and p.Team == LocalPlayer.Team then
        return false
    end
    return true
end

local function getColor(p)
    return (p.Team and p.Team.TeamColor.Color) or NO_TEAM_COLOR
end

local function setupESP(p)
    if ESPObjects[p] then return end
    local char = p.Character or p.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local box = Instance.new("SelectionBox")
    box.Adornee = hrp
    box.LineThickness = 0.05
    box.SurfaceTransparency = 1
    box.Color3 = getColor(p)
    box.Visible = false
    box.Parent = Workspace

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillTransparency = 1
    hl.OutlineColor = getColor(p)
    hl.Enabled = false
    hl.Parent = Workspace

    local bb = Instance.new("BillboardGui")
    bb.Adornee = hrp
    bb.Size = UDim2.new(0,200,0,40)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.Enabled = false
    bb.Parent = Workspace

    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Gotham
    txt.TextStrokeTransparency = 0
    txt.TextSize = 13
    txt.TextColor3 = getColor(p)

    ESPObjects[p] = {Box = box, HL = hl, BB = bb, TXT = txt}

    p.CharacterAdded:Connect(function()
        if ESPObjects[p] then
            ESPObjects[p].Box:Destroy()
            ESPObjects[p].HL:Destroy()
            ESPObjects[p].BB:Destroy()
            ESPObjects[p] = nil
            setupESP(p)
        end
    end)
end

for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then setupESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then setupESP(p) end end)
Players.PlayerRemoving:Connect(function(p)
    if ESPObjects[p] then
        for _,v in pairs(ESPObjects[p]) do v:Destroy() end
        ESPObjects[p] = nil
    end
end)
local lastUpdate = 0
local UPDATE_RATE = 1/30
RunService.Heartbeat:Connect(function(dt)
    lastUpdate += dt
    if lastUpdate < UPDATE_RATE then return end
    lastUpdate = 0

    local localChar = LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then
        return
    end

    local localHRP = localChar.HumanoidRootPart

    for p, data in pairs(ESPObjects) do
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") and shouldESP(p) then
            local hrp = char.HumanoidRootPart
            local col = getColor(p)

            data.Box.Adornee = hrp
            data.Box.Color3 = col
            data.Box.Visible = ESPSettings.BoxESP

            data.HL.Adornee = char
            data.HL.OutlineColor = col
            data.HL.Enabled = ESPSettings.OutlineESP

            data.BB.Adornee = hrp

            local text = ""

            if ESPSettings.ShowName then
                text ..= p.Name .. " "
            end

            if ESPSettings.ShowDistance then
                local dist = math.floor((hrp.Position - localHRP.Position).Magnitude)
                text ..= dist .. "m"
            end

            data.TXT.Text = text
            data.TXT.TextColor3 = col
            data.BB.Enabled = ESPSettings.ShowName or ESPSettings.ShowDistance
        else
            data.Box.Visible = false
            data.HL.Enabled = false
            data.BB.Enabled = false
        end
    end
end)

local TeleportPage = pages["Teleport"]

-- Clear previous content
for _,v in pairs(TeleportPage:GetChildren()) do
    if v:IsA("Frame") or v:IsA("TextButton") then
        v:Destroy()
    end
end

-- ScrollingFrame
local scroll = Instance.new("ScrollingFrame", TeleportPage)
scroll.Size = UDim2.new(1,-20,1,-20)
scroll.Position = UDim2.new(0,10,0,10)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Teleport Locations
local locations = {
    {"Locker Room", Vector3.new(829.50,99.98,2242.46)},
    {"Cafeteria Outside", Vector3.new(918.71,99.99,2311.34)},
    {"Cafeteria Inside", Vector3.new(913.57,99.99,2226.93)},
    {"Sewer", Vector3.new(915.59,78.70,2154.49)},
    {"Rooftop", Vector3.new(819.45,118.99,2304.56)},
    {"Prison", Vector3.new(916.41,102.50,2460.09)},
    {"Yard", Vector3.new(778.49,98.00,2461.92)},
    {"Tower (Right)", Vector3.new(822.96,123.84,2588.11)},
    {"Tower Left", Vector3.new(823.60,125.84,2073.68)},
    {"Inside Gate", Vector3.new(621.38,98.04,2278.76)},
    {"Outside Gate", Vector3.new(457.70,98.04,2216.17)},
    {"Waiting Area", Vector3.new(693.24,100.00,2303.64)},
    {"Container", Vector3.new(251.92,72.52,2368.09)},
    {"Criminal Base", Vector3.new(-932.96,94.13,2052.68)},
}

-- Create buttons
for i,loc in ipairs(locations) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,35)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = loc[1]
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(loc[2])
        end
    end)
end

-- Update CanvasSize automatically
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

--// MORE TAB (SCROLLABLE)
local MorePage = pages["More"]

-- clear
for _,v in ipairs(MorePage:GetChildren()) do
    v:Destroy()
end

-- scrolling container
local moreScroll = Instance.new("ScrollingFrame", MorePage)
moreScroll.Size = UDim2.new(1,-20,1,-20)
moreScroll.Position = UDim2.new(0,10,0,10)
moreScroll.CanvasSize = UDim2.new(0,0,0,0)
moreScroll.ScrollBarThickness = 6
moreScroll.BackgroundTransparency = 1

local moreLayout = Instance.new("UIListLayout", moreScroll)
moreLayout.Padding = UDim.new(0,10)
moreLayout.SortOrder = Enum.SortOrder.LayoutOrder

moreLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    moreScroll.CanvasSize = UDim2.new(0,0,0, moreLayout.AbsoluteContentSize.Y + 10)
end)

-- button factory
local function MoreButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,35)
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Parent = moreScroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)

    b.MouseButton1Click:Connect(callback)
end

-- Fly GUI popup (stays outside scroll so it doesn't clip)
local flyGuiFrame = Instance.new("Frame")
flyGuiFrame.Size = UDim2.new(0,220,0,70)
flyGuiFrame.Position = UDim2.new(0.5,-110,0.5,-35)
flyGuiFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
flyGuiFrame.BorderSizePixel = 0
flyGuiFrame.Visible = false
flyGuiFrame.Active = true
flyGuiFrame.Draggable = true
flyGuiFrame.Parent = ScreenGui
Instance.new("UICorner", flyGuiFrame).CornerRadius = UDim.new(0,10)

local flyLabel = Instance.new("TextLabel", flyGuiFrame)
flyLabel.Size = UDim2.new(1,0,0,35)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly GUI"
flyLabel.Font = Enum.Font.GothamBold
flyLabel.TextSize = 16
flyLabel.TextColor3 = Color3.new(1,1,1)

local flyButton = Instance.new("TextButton", flyGuiFrame)
flyButton.Size = UDim2.new(0.9,0,0,30)
flyButton.Position = UDim2.new(0.05,0,0,35)
flyButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Text = "Load Fly GUI"
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 14
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0,6)

flyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/RealBatu20/AI-Scripts-2025/refs/heads/main/FlyGUI_v7.lua",
        true
    ))()
    flyGuiFrame.Visible = false
end)

-- buttons
MoreButton("Fly Gui (эта хуйня не работает даже не пытайся)", function()
    flyGuiFrame.Visible = not flyGuiFrame.Visible
end)

MoreButton("Anti Taze (Press Once)", function()
    loadstring(game:HttpGet(
        "https://pastebin.com/raw/ynHUaxuH",
        true
    ))()
end)

MoreButton("Delete Doors (Unreversable)", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/Kku9MNM1", true))()
end)

-- ================= NO JUMP COOLDOWN TOGGLE (Dark Blue) =================
local function CreateNoJumpCooldownToggle(scrollFrame)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,35)
    row.BackgroundColor3 = Color3.fromRGB(0,0,0)
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.Parent = scrollFrame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
    Instance.new("UIStroke", row).Color = Color3.fromRGB(0,0,0)
    Instance.new("UIStroke", row).Thickness = 1

    -- Label
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.65,0,1,0)
    label.Position = UDim2.new(0,8,0,0)
    label.Text = "No Jump Cooldown (Reset to turn off)"
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggle button
    local toggle = Instance.new("TextButton", row)
    toggle.Size = UDim2.new(0.3,0,0.7,0)
    toggle.Position = UDim2.new(0.65,0,0.15,0)
    toggle.Text = "OFF"
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.BackgroundColor3 = Color3.fromRGB(20,40,80)  -- dark blue for both states
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,4)

    local active = false
    toggle.MouseButton1Click:Connect(function()
        active = not active
        toggle.Text = active and "ON" or "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(20,40,80)  -- always dark blue
    end)

    -- Persistent AntiJump deletion loop
    task.spawn(function()
        while true do
            if active then
                local char = LocalPlayer.Character
                if char then
                    local antiJump = char:FindFirstChild("AntiJump")
                    if antiJump then
                        antiJump:Destroy()
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- Add toggle to the More tab scroll
CreateNoJumpCooldownToggle(moreScroll)

-- Divider factory (works inside ScrollingFrame)
local function MoreDivider(text)
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1,0,0,25)
    d.BackgroundTransparency = 1
    d.Text = "---------- "..text.." ----------"
    d.TextColor3 = Color3.fromRGB(200,200,200) -- light grey
    d.Font = Enum.Font.Gotham
    d.TextSize = 14
    d.TextScaled = false
    d.TextXAlignment = Enum.TextXAlignment.Center
    d.TextYAlignment = Enum.TextYAlignment.Center
    d.Parent = moreScroll
end

-- Example usage:
MoreDivider("Get-Guns")

--// GET GUN BUTTONS (MORE TAB)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GunLocations = {
    {"Get FAL (BUGGY)", CFrame.new(-915.800842, 91.2587814, 2047.55347)},
    {"Get AK (BUGGY)", CFrame.new(-931.90, 94.37, 2039.12)},
    {"Get Remington (BUGGY)", CFrame.new(-938.992737, 91.2782822, 2039.25537)},
    {"Get MP5 (BUGGY)", CFrame.new(813.698669, 97.8500061, 2229.39624)},
    {"Get M4A1 (BUGGY)", CFrame.new(847.498596, 97.8500061, 2229.39624)},
    {"Get M700 (BUGGY)", CFrame.new(835.798645, 97.8500061, 2229.396)}
}

for _, data in ipairs(GunLocations) do
    local name = data[1]
    local cf = data[2]

    MoreButton(name, function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        local old = root.CFrame
        root.CFrame = cf
        task.wait(2)
        root.CFrame = old
    end)
end

-- ================= INFO TAB =================
local InfoPage = pages["Info"]

local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = InfoPage
infoLabel.Size = UDim2.new(1, -40, 1, -40)
infoLabel.Position = UDim2.new(0, 20, 0, 20)
infoLabel.BackgroundColor3 = Color3.fromRGB(28,28,28)  -- Dark grey background
infoLabel.BackgroundTransparency = 0.2                  -- Semi-transparent
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0,8)  -- Rounded corners

infoLabel.Text = [[
Hi, I'm gay — known as SARpastes on YouTube.

My script has benn cracked and leaked by shpaklevka DM me on Discord: ramsamam.

cracker links: t.me/debug_teams
discord shpaklevka: shpaklevka1
lotusgram username: @exploit
telegram username: @bozgd

lolololololllolololololololololololololololololololo

иди нахуй блялялялялляляля
ключ системы нет как и обфы если нада сами чета как та там сделаете
]]

-- ================= TOP BAR TITLE =================
local topBarTitle = Instance.new("TextLabel", topBar)
topBarTitle.Size = UDim2.new(0,200,1,0)
topBarTitle.Position = UDim2.new(0.5,-100,0,0) -- centered
topBarTitle.BackgroundTransparency = 1
topBarTitle.TextColor3 = Color3.fromRGB(255,255,255)
topBarTitle.Font = Enum.Font.GothamBold
topBarTitle.TextSize = 18
topBarTitle.Text = "Combat"

-- Animate function for text change
local function AnimateTopBarText(newText)
    for i = 0,1,0.1 do
        topBarTitle.TextTransparency = i
        RunService.RenderStepped:Wait()
    end
    topBarTitle.Text = newText
    for i = 1,0,-0.1 do
        topBarTitle.TextTransparency = i
        RunService.RenderStepped:Wait()
    end
end

-- Hook into tab buttons (inside the original tab creation loop)
for i, name in ipairs(tabs) do
    local page = pages[name]
    -- get button reference from tabHolder children
    local btn = tabHolder:FindFirstChildOfClass("TextButton")
    -- instead, let's use the button reference from your original loop
    for _, child in ipairs(tabHolder:GetChildren()) do
        if child:IsA("TextButton") and child.Text == name then
            child.MouseButton1Click:Connect(function()
                for _,p in pairs(pages) do p.Visible=false end
                page.Visible = true
                AnimateTopBarText(name)
            end)
        end
    end
end

-- ================= TOP LEFT INFO =================
local topLeftInfo = Instance.new("TextLabel", topBar)
topLeftInfo.Size = UDim2.new(0,200,1,0) -- width 200, full height
topLeftInfo.Position = UDim2.new(0,10,0,0) -- top-left corner with small padding
topLeftInfo.BackgroundTransparency = 1
topLeftInfo.TextColor3 = Color3.fromRGB(255,255,255)
topLeftInfo.Font = Enum.Font.Gotham
topLeftInfo.TextSize = 12
topLeftInfo.TextXAlignment = Enum.TextXAlignment.Left
topLeftInfo.TextYAlignment = Enum.TextYAlignment.Top
topLeftInfo.Text = "Prison Life without key system\nCracked by shpaklevka\nScript Version 1337\nt.me/debug_teams t.me/debug_teams t.me/debug_teams t.me/debug_teams t.me/debug_teams "

-- CONFIG
local OWNER_NAME = "vertoletikk1"
local OWNER_USERNAME = "vertoletikk1"

-- SERVICES
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

-- CHAT FUNCTION
local function sendMessage(msg)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    else
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

-- MESSAGE BUILDERS
local function ownerJoined()
    sendMessage("бялялялля иди нахуй я не ебу че писать ну кароч да владелец скрипта зашел, дарова "..OWNER_NAME.." ("..OWNER_USERNAME..")")
end

local function altJoinedOwner()
    sendMessage("сука иди нахуй блять 108301923890182301 "..OWNER_NAME.." ("..OWNER_USERNAME..")")
end

-- DO NOTHING IF OWNER IS RUNNING SCRIPT
if LocalPlayer.Name == OWNER_USERNAME then
    return
end

-- CHECK IF OWNER ALREADY IN GAME
for _,plr in ipairs(Players:GetPlayers()) do
    if plr.Name == OWNER_USERNAME then
        altJoinedOwner()
        break
    end
end

-- WATCH FOR OWNER JOINING LATER
Players.PlayerAdded:Connect(function(plr)
    if plr.Name == OWNER_USERNAME then
        ownerJoined()
    end
end)