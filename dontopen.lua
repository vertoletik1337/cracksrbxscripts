-- ===================================================
--  Nova Hub
--  Discord: https://discord.gg/WmGx944myQ
-- ===================================================

local coreGui = game:GetService("CoreGui")

local scriptAccessSystem = Instance.new("ScreenGui")
scriptAccessSystem.Name = "ScriptAccessSystem"
scriptAccessSystem.Parent = coreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = scriptAccessSystem

local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(0, 400, 0, 320)
frame2.Position = UDim2.new(0.5, -200, 0.5, -160)
frame2.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame2.BorderSizePixel = 0
frame2.Parent = scriptAccessSystem

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame2

local frame3 = Instance.new("Frame")
frame3.Size = UDim2.new(1, 0, 0, 40)
frame3.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame3.BorderSizePixel = 0
frame3.Parent = frame2

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 10)
uiCorner2.Parent = frame3

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -40, 1, 0)
textLabel.Position = UDim2.new(0, 10, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "🔐 key: t.me/debug_teams"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 18
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = frame3

local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(0, 30, 0, 30)
textButton.Position = UDim2.new(1, -35, 0, 5)
textButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
textButton.Text = "✕"
textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton.Font = Enum.Font.GothamBold
textButton.TextSize = 18
textButton.Parent = frame3

local uiCorner3 = Instance.new("UICorner")
uiCorner3.CornerRadius = UDim.new(0, 6)
uiCorner3.Parent = textButton

textButton.MouseEnter:Connect(function()
  textButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

textButton.MouseLeave:Connect(function()
  textButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

textButton.MouseButton1Click:Connect(function() scriptAccessSystem:Destroy() end)

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 45)
textBox.Position = UDim2.new(0.1, 0, 0, 70)
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
textBox.BorderSizePixel = 0
textBox.Text = ""
textBox.PlaceholderText = "Enter access key..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 16
textBox.ClearTextOnFocus = false
textBox.Parent = frame2

local uiCorner4 = Instance.new("UICorner")
uiCorner4.CornerRadius = UDim.new(0, 6)
uiCorner4.Parent = textBox

local textButton2 = Instance.new("TextButton")
textButton2.Size = UDim2.new(0.8, 0, 0, 45)
textButton2.Position = UDim2.new(0.1, 0, 0, 125)
textButton2.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
textButton2.Text = "VERIFY ACCESS"
textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton2.Font = Enum.Font.GothamBold
textButton2.TextSize = 16
textButton2.Parent = frame2

local uiCorner5 = Instance.new("UICorner")
uiCorner5.CornerRadius = UDim.new(0, 6)
uiCorner5.Parent = textButton2

local textButton3 = Instance.new("TextButton")
textButton3.Size = UDim2.new(0.8, 0, 0, 45)
textButton3.Position = UDim2.new(0.1, 0, 0, 180)
textButton3.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
textButton3.Text = "🔗 GET KEY (LINKVERTISE)"
textButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton3.Font = Enum.Font.GothamBold
textButton3.TextSize = 14
textButton3.Parent = frame2

local uiCorner6 = Instance.new("UICorner")
uiCorner6.CornerRadius = UDim.new(0, 6)
uiCorner6.Parent = textButton3

local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, 0, 0, 40)
textLabel2.Position = UDim2.new(0, 0, 1, -45)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = ""
textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel2.Font = Enum.Font.Gotham
textLabel2.TextSize = 12
textLabel2.TextWrapped = true
textLabel2.Parent = frame2

local f1

local function f2()
  local gsub = textBox.Text:gsub("%s+", "")

  if #gsub == 0 then
    textLabel2.Text = "Enter access key"
    textLabel2.TextColor3 = Color3.fromRGB(255, 100, 100)
    return
  else
    textButton2.Text = "CHECKING..."
    textButton2.BackgroundColor3 = Color3.fromRGB(255, 150, 0)

    local v1 = f1()

    if not v1 then
      textLabel2.Text = "Cannot connect to key server"
      textLabel2.TextColor3 = Color3.fromRGB(255, 100, 100)

      textButton2.Text = "VERIFY ACCESS"
      textButton2.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

      return
    end

    if gsub == v1 then
      textLabel2.Text = "Access granted! Loading..."
      textLabel2.TextColor3 = Color3.fromRGB(0, 255, 0)

      textBox.Text = "VERIFIED"
      textBox.TextEditable = false

      textButton2.Text = "LOADING..."
      textButton2.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

      task.wait(1)

      local v2, v3 = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/verund638/ArthurHub/refs/heads/main/xxxdef.lua"))()
      end)

      if v2 then
        textLabel2.Text = "Script loaded successfully"
        task.wait(2)
        scriptAccessSystem:Destroy()
      else
        textLabel2.Text = "Failed to load: " .. tostring(v3)
        textLabel2.TextColor3 = Color3.fromRGB(255, 50, 50)

        textButton2.Text = "VERIFY ACCESS"
        textButton2.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

        textBox.Text = ""
        textBox.TextEditable = true
      end
    else
      textLabel2.Text = "Incorrect key"
      textLabel2.TextColor3 = Color3.fromRGB(255, 100, 100)

      local position = textBox.Position

      for i = 1, 3 do
        textBox.Position = UDim2.new(0.1, 10, 0, 70)
        task.wait(0.05)
        textBox.Position = UDim2.new(0.1, -10, 0, 70)
        task.wait(0.05)
      end

      textBox.Position = position
      textBox.Text = ""
      textBox:CaptureFocus()

      textButton2.Text = "VERIFY ACCESS"
      textButton2.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end

    return
  end
end

function f1()
  local v4, v5 = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/vertoletik1337/cracksrbxscripts/refs/heads/main/pass.txt")
  end)

  if v4 and v5 then
    local gsub2 = v5:gsub("%s+", "")

    if #gsub2 > 0 then
      return gsub2
    end

    return nil
  end

  return nil
end

textButton2.MouseButton1Click:Connect(f2)

textButton3.MouseButton1Click:Connect(function()
  local v6 = false

  pcall(function()
    setclipboard("https://direct-link.net/1449781/96lLgfpW8MV3")
    v6 = true
  end)

  if not v6 then
    pcall(function()
      writeclipboard("https://direct-link.net/1449781/96lLgfpW8MV3")
      v6 = true
    end)
  end

  if v6 then
    textLabel2.Text = "Link copied! Complete steps to get key."
    textLabel2.TextColor3 = Color3.fromRGB(100, 255, 100)

    task.spawn(function()
      local textLabel3 = Instance.new("TextLabel")
      textLabel3.Size = UDim2.new(0, 320, 0, 100)
      textLabel3.Position = UDim2.new(0.5, -160, 0.5, -50)
      textLabel3.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
      textLabel3.Text = "✅ Link Copied\n\n1. Paste into browser\n2. Complete Linkvertise\n3. Copy the key\n4. Return and paste here"
      textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
      textLabel3.Font = Enum.Font.Gotham
      textLabel3.TextSize = 14
      textLabel3.TextWrapped = true
      textLabel3.ZIndex = 100
      textLabel3.Parent = scriptAccessSystem

      local uiCorner7 = Instance.new("UICorner")
      uiCorner7.CornerRadius = UDim.new(0, 10)
      uiCorner7.Parent = textLabel3

      task.wait(5)
      textLabel3:Destroy()
    end)
  else
    textLabel2.Text = "Please visit: https://direct-link.net/1449781/96lLgfpW8MV3"
    textLabel2.TextColor3 = Color3.fromRGB(255, 200, 0)
  end
end)

textBox.FocusLost:Connect(function(p1)
  if p1 then
    f2()
  end
end)

task.wait(0.5)
textBox:CaptureFocus()
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
print("cracked by shpaklevka & t.me/debug_teams")
