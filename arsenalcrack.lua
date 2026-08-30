local ESP_UPDATE_INTERVAL = 0.08
local AIMBOT_UPDATE_INTERVAL = 0.03

local espTick = 0
local aimTick = 0

local cachedTargets = {}

-- рофыврлвофрлтфылрвльофрыьовфрплыворпфртыавтфывтфывортфпртыв
if not game:IsLoaded() then game.Loaded:Wait() end

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Teams = game:GetService("Teams")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace

-- ================= STATE =================
local State = {
    AimbotEnabled = false,
    LockTeammates = true,
    DisableWallLock = true,
    AimbotFOV = 50,
    AimbotTargetPart = "Head",
    ShowFOV = true,
    ESP = {
        BoxESP = false,
        OutlineESP = false,
        NameESP = false,
        DistanceESP = false,
        ESPTeammates = false
    }
}

-- ================= FOV CIRCLE =================
local FOVCircle
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Color = Color3.fromRGB(0,255,0)
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Filled = false
    FOVCircle.Visible = true
end)

-- ================= UTILS =================
local function isTeammate(p)
    return LocalPlayer.Team and p.Team == LocalPlayer.Team
end

local function isVisible(part)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local r = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), rayParams)
    return r and r.Instance:IsDescendantOf(part.Parent)
end

local function getESPColor(p)
    if #Teams:GetChildren() > 0 and p.TeamColor then
        return p.TeamColor.Color
    end
    return Color3.fromRGB(0,255,0)
end

-- ================= GUI =================
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "SARpastes_GUI"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,350,0,260)
Main.Position = UDim2.new(0.5,-175,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,-40,0,25)
Title.Position = UDim2.new(0,10,0,5)
Title.Text = "cracked by shpaklevka  t.me/debug_teams t.me/debug_teams t.me/debug_teams t.me/debug_teams t.me/debug_teams t.me/debug_teams t.me/debug_teams "
Title.TextColor3 = Color3.fromRGB(0,255,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0,24,0,20)
CloseBtn.Position = UDim2.new(1,-30,0,6)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn)

-- FLOAT OPEN BUTTON (TOP RIGHT)
local FloatGui = Instance.new("ScreenGui", CoreGui)
FloatGui.Enabled = false
FloatGui.ResetOnSpawn = false

local FloatBtn = Instance.new("TextButton", FloatGui)
FloatBtn.Size = UDim2.new(0,120,0,32)
FloatBtn.Position = UDim2.new(1,-130,0,10)
FloatBtn.Text = "OPEN UI"
FloatBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
FloatBtn.TextColor3 = Color3.new(1,1,1)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 14
Instance.new("UICorner", FloatBtn)

CloseBtn.MouseButton1Click:Connect(function()
    Gui.Enabled = false
    FloatGui.Enabled = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    Gui.Enabled = true
    FloatGui.Enabled = false
end)

-- ================= TABS =================
local btnA = Instance.new("TextButton", Main)
btnA.Size = UDim2.new(0,165,0,25)
btnA.Position = UDim2.new(0,5,0,35)
btnA.Text = "Aimbot"
btnA.BackgroundColor3 = Color3.fromRGB(35,35,35)
btnA.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnA)

local btnE = Instance.new("TextButton", Main)
btnE.Size = UDim2.new(0,165,0,25)
btnE.Position = UDim2.new(0,175,0,35)
btnE.Text = "Visuals"
btnE.BackgroundColor3 = Color3.fromRGB(35,35,35)
btnE.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnE)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-20,1,-70)
Content.Position = UDim2.new(0,10,0,70)
Content.BackgroundTransparency = 1

local AimbotFrame = Instance.new("Frame", Content)
AimbotFrame.Size = UDim2.new(1,0,1,0)
AimbotFrame.BackgroundTransparency = 1

local ESPFrame = Instance.new("Frame", Content)
ESPFrame.Size = UDim2.new(1,0,1,0)
ESPFrame.BackgroundTransparency = 1
ESPFrame.Visible = false

btnA.MouseButton1Click:Connect(function()
    AimbotFrame.Visible = true
    ESPFrame.Visible = false
end)

btnE.MouseButton1Click:Connect(function()
    AimbotFrame.Visible = false
    ESPFrame.Visible = true
end)

-- ================= TOGGLES =================
local function toggle(parent,text,y,default,cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,0,0,24)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = text..": "..(default and "ON" or "OFF")
    b.BackgroundColor3 = default and Color3.fromRGB(0,100,0) or Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    Instance.new("UICorner", b)
    local s = default
    b.MouseButton1Click:Connect(function()
        s = not s
        b.Text = text..": "..(s and "ON" or "OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0,100,0) or Color3.fromRGB(40,40,40)
        cb(s)
    end)
end

-- AIMBOT
toggle(AimbotFrame,"Enable Aimbot",0,false,function(v) State.AimbotEnabled=v end)
toggle(AimbotFrame,"Lock Teammates",30,true,function(v) State.LockTeammates=v end)
toggle(AimbotFrame,"Disable Wall Lock",60,true,function(v) State.DisableWallLock=v end)
toggle(AimbotFrame,"Show FOV",90,true,function(v) State.ShowFOV=v end)

-- FOV SIZE
local FOVLabel = Instance.new("TextLabel", AimbotFrame)
FOVLabel.Position = UDim2.new(0,0,0,125)
FOVLabel.Size = UDim2.new(0,100,0,20)
FOVLabel.Text = "FOV: 50"
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.TextSize = 12

local function fovBtn(x,text,delta)
    local b = Instance.new("TextButton", AimbotFrame)
    b.Size = UDim2.new(0,30,0,20)
    b.Position = UDim2.new(0,x,0,125)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        State.AimbotFOV = math.clamp(State.AimbotFOV + delta,10,500)
        FOVLabel.Text = "FOV: "..State.AimbotFOV
    end)
end

fovBtn(110,"+",10)
fovBtn(145,"-", -10)

-- BODYPART
local PartBtn = Instance.new("TextButton", AimbotFrame)
PartBtn.Size = UDim2.new(1,0,0,24)
PartBtn.Position = UDim2.new(0,0,0,155)
PartBtn.Text = "Target: Head"
PartBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
PartBtn.TextColor3 = Color3.new(1,1,1)
PartBtn.Font = Enum.Font.Gotham
PartBtn.TextSize = 12
Instance.new("UICorner", PartBtn)

PartBtn.MouseButton1Click:Connect(function()
    State.AimbotTargetPart = State.AimbotTargetPart == "Head" and "Torso" or "Head"
    PartBtn.Text = "Target: "..State.AimbotTargetPart
end)

-- ESP MENU
toggle(ESPFrame,"Box ESP",0,false,function(v) State.ESP.BoxESP=v end)
toggle(ESPFrame,"Outline ESP",30,false,function(v) State.ESP.OutlineESP=v end)
toggle(ESPFrame,"Name ESP",60,false,function(v) State.ESP.NameESP=v end)
toggle(ESPFrame,"Distance ESP",90,false,function(v) State.ESP.DistanceESP=v end)
toggle(ESPFrame,"Team ESP",120,false,function(v) State.ESP.ESPTeammates=v end)

-- ================= ESP SYSTEM =================
local ESPTable = {}

local function createESP(player)
    if player == LocalPlayer then return end
    local function onChar(char)
        local root = char:WaitForChild("HumanoidRootPart",5)
        if not root then return end
        local box = Instance.new("BoxHandleAdornment", Workspace)
        box.Adornee = char
        box.Size = Vector3.new(4,6,2)
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Transparency = 0.6

        local outline = Instance.new("Highlight", Workspace)
        outline.Adornee = char
        outline.FillTransparency = 1
        outline.OutlineTransparency = 0
        outline.OutlineColor = Color3.fromRGB(0,255,0)
        outline.Enabled = false

        local bb = Instance.new("BillboardGui", Workspace)
        bb.Adornee = root
        bb.Size = UDim2.new(0,120,0,40)
        bb.StudsOffset = Vector3.new(0,3,0)
        bb.AlwaysOnTop = true
        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 12

        ESPTable[player] = {Box=box,Outline=outline,BB=bb,TXT=txt,Root=root,Char=char}
    end
    if player.Character then onChar(player.Character) end
    player.CharacterAdded:Connect(onChar)
end

local PlayerCache = {}
local visibilityCache = {}

local rayTick = 0
local RAY_INTERVAL = 0.12

local function addPlayer(p)
    if p ~= LocalPlayer then
        PlayerCache[p] = true
        createESP(p)
    end
end

local function removePlayer(p)
    PlayerCache[p] = nil
    visibilityCache[p] = nil

    if ESPTable[p] then
        for _,v in pairs(ESPTable[p]) do
            if typeof(v) == "Instance" then
                v:Destroy()
            end
        end
        ESPTable[p] = nil
    end
end

-- INITIAL LOAD
for _,p in ipairs(Players:GetPlayers()) do
    addPlayer(p)
end

Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(removePlayer)

RunService.RenderStepped:Connect(function(dt)

    rayTick += dt
    espTick += dt
    aimTick += dt

    local doRay = false
    if rayTick >= RAY_INTERVAL then
        rayTick = 0
        doRay = true
    end

    local doESP = false
    if espTick >= ESP_UPDATE_INTERVAL then
        espTick = 0
        doESP = true
    end

    local doAimUpdate = false
    if aimTick >= AIMBOT_UPDATE_INTERVAL then
        aimTick = 0
        doAimUpdate = true
    end

    local camPos = Camera.CFrame.Position
    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    -- ================= ESP (THROTTLED) =================
    if doESP then
        for p,_ in pairs(PlayerCache) do
            local e = ESPTable[p]
            if e and e.Char and e.Root then
                local hum = e.Char:FindFirstChild("Humanoid")

                if hum and hum.Health > 0 then
                    local teamOK = not isTeammate(p) or State.ESP.ESPTeammates
                    local color = getESPColor(p)

                    e.Box.Visible = State.ESP.BoxESP and teamOK
                    e.Box.Color3 = color

                    e.Outline.Enabled = State.ESP.OutlineESP and teamOK
                    e.Outline.OutlineColor = color

                    local bbEnabled = teamOK and (State.ESP.NameESP or State.ESP.DistanceESP)
                    e.BB.Enabled = bbEnabled

                    if bbEnabled then
                        local text = ""

                        if State.ESP.NameESP then
                            text = p.Name
                        end

                        if State.ESP.DistanceESP then
                            local d = math.floor((camPos - e.Root.Position).Magnitude)
                            text = text ~= "" and text.." ["..d.."]" or d.." studs"
                        end

                        e.TXT.Text = text
                        e.TXT.TextColor3 = color
                    end
                else
                    e.Box.Visible = false
                    e.Outline.Enabled = false
                    e.BB.Enabled = false
                end
            end
        end
    end

    -- ================= FOV =================
    if FOVCircle then
        FOVCircle.Visible = State.ShowFOV
        FOVCircle.Radius = State.AimbotFOV
        FOVCircle.Position = screenCenter
    end

    -- ================= AIMBOT CACHE =================
    if doAimUpdate then
        cachedTargets = {}

        for p,_ in pairs(PlayerCache) do
            local char = p.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                local part = char:FindFirstChild(
                    State.AimbotTargetPart == "Head" and "Head" or "HumanoidRootPart"
                )

                if hum and hum.Health > 0 and part then
                    if not (State.LockTeammates and isTeammate(p)) then
                        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X,pos.Y) - screenCenter).Magnitude
                            if dist <= State.AimbotFOV then
                                table.insert(cachedTargets, {part = part, dist = dist, player = p})
                            end
                        end
                    end
                end
            end
        end

        table.sort(cachedTargets, function(a,b)
            return a.dist < b.dist
        end)
    end

    -- ================= AIMBOT EXEC =================
    if State.AimbotEnabled and #cachedTargets > 0 then
        for i = 1, math.min(3, #cachedTargets) do -- only top 3 targets
            local data = cachedTargets[i]

            if State.DisableWallLock then
                if doRay then
                    visibilityCache[data.player] = isVisible(data.part)
                end
                if not visibilityCache[data.player] then
                    continue
                end
            end

            Camera.CFrame = CFrame.lookAt(camPos, data.part.Position)
            break
        end
    end

end)

--// Discord Popup GUI by SAR (With Background Overlay)

local ScreenGui = Instance.new("ScreenGui")

--// Background Overlay (THIS WAS MISSING)
local Background = Instance.new("Frame")

local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")

local TitleText = Instance.new("TextLabel")
local InfoText = Instance.new("TextLabel")
local ExtraText = Instance.new("TextLabel")

local JoinButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

local JoinCorner = Instance.new("UICorner")
local CloseCorner = Instance.new("UICorner")

--// Parent
ScreenGui.Parent = game.CoreGui

--// Background Overlay
Background.Parent = ScreenGui
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.4 -- adjust darkness here
Background.BorderSizePixel = 0

--// Main Frame
Frame.Parent = Background
Frame.Size = UDim2.new(0, 420, 0, 280)
Frame.Position = UDim2.new(0.5, -210, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 12)

--// Title
TitleText.Parent = Frame
TitleText.Size = UDim2.new(1, -20, 0, 80)
TitleText.Position = UDim2.new(0, 10, 0, 10)
TitleText.BackgroundTransparency = 1
TitleText.Text = "зайди в тгк там весело а то хули ты "
TitleText.TextColor3 = Color3.fromRGB(255,255,255)
TitleText.TextWrapped = true
TitleText.Font = Enum.Font.GothamBold
TitleText.TextScaled = true

--// Info Text
InfoText.Parent = Frame
InfoText.Size = UDim2.new(1, -20, 0, 30)
InfoText.Position = UDim2.new(0, 10, 0, 90)
InfoText.BackgroundTransparency = 1
InfoText.Text = "скопировать ссылку по кнопке ниже если шо"
InfoText.TextColor3 = Color3.fromRGB(185, 187, 190)
InfoText.Font = Enum.Font.Gotham
InfoText.TextScaled = true

--// Extra Text (hidden first)
ExtraText.Parent = Frame
ExtraText.Size = UDim2.new(1, -20, 0, 30)
ExtraText.Position = UDim2.new(0, 10, 0, 115)
ExtraText.BackgroundTransparency = 1
ExtraText.Text = "скопировал маладес теперь сабайся так хотя бы пропускать нихуя не будешь"
ExtraText.TextColor3 = Color3.fromRGB(160, 163, 168)
ExtraText.Font = Enum.Font.Gotham
ExtraText.TextScaled = true
ExtraText.Visible = false

--// Join Button
JoinButton.Parent = Frame
JoinButton.Size = UDim2.new(0.8, 0, 0, 45)
JoinButton.Position = UDim2.new(0.1, 0, 0, 155)
JoinButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
JoinButton.Text = "присоеденится в тгк"
JoinButton.TextColor3 = Color3.fromRGB(255,255,255)
JoinButton.Font = Enum.Font.GothamBold
JoinButton.TextScaled = true
JoinButton.BorderSizePixel = 0

JoinCorner.Parent = JoinButton
JoinCorner.CornerRadius = UDim.new(0, 10)

--// Close Button
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0.8, 0, 0, 40)
CloseButton.Position = UDim2.new(0.1, 0, 0, 210)
CloseButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
CloseButton.Text = "нет меня раис звать"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextScaled = true
CloseButton.BorderSizePixel = 0

CloseCorner.Parent = CloseButton
CloseCorner.CornerRadius = UDim.new(0, 10)

--// Clipboard
local invite = "t.me/debug_teams"

JoinButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(invite)
    end
    
    ExtraText.Visible = true
    InfoText.Text = "13212312313213212313213212313123123123123123123123123123123123132123123123123123123131 бля че я несу"
end)

--// Close
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ================= GUI TOGGLE (Q) =================
local UserInputService = game:GetService("UserInputService")

local GUIVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.Q then
        GUIVisible = not GUIVisible

        if Gui then
            Gui.Enabled = GUIVisible
        end
    end
end)
