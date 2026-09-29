local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local BLACKLISTED_IDS = {
    3055355050
}

for _, id in ipairs(BLACKLISTED_IDS) do
    if player.UserId == id then
        player:Kick("ACCESS DENIED\n\nYour account is permanently banned from this HUB.")
        return
    end
end

local WEBHOOK_CORRIDAS = "https://discord.com/api/webhooks/1554321142846591018/hcI0UEdninbn_hVXEDc4igR5IqEX3KL8szp8_xutyoFuuNCeXybiMTwsytNVIVFAV_ZB"
local WEBHOOK_LOGINS = "https://discord.com/api/webhooks/1554321211176001597/tmsHcJAbv-uj3kuOvtMuyqUKuCb9r3NyKGE8ONZCTZZsw1w0RmBowb66NP5PiM_UcFX6"

local function sendDiscord(url, data)
    task.spawn(function()
        pcall(function()
            local requestFunc = syn and syn.request or http_request or request
            if requestFunc then
                requestFunc({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(data)
                })
            end
        end)
    end)
end

local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local LOGO_URL = "https://i.ibb.co/M5y1yCjM/Skripty-X-Fox-Studios.png"
local LOGO_FILE = "SkriptyXFox_logo.png"
local SOUND_OPEN = "rbxasset://sounds/electronicpingshort.wav"
local SOUND_CLOSE = "rbxasset://sounds/switch.wav"
local soundsEnabled = true

local function playSound(id, volume)
    if not soundsEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = volume or 0.6
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 4)
    end)
end

local logoAssetCache = nil
local function loadLogo(imageLabel, fallbackLabel, backingFrame)
    task.spawn(function()
        pcall(function()
            local getAsset = getcustomasset or getsynasset
            if not (getAsset and writefile and isfile) then return end
            if not logoAssetCache then
                if not isfile(LOGO_FILE) then
                    local requestFunc = syn and syn.request or http_request or request
                    if not requestFunc then return end
                    local res = requestFunc({Url = LOGO_URL, Method = "GET"})
                    if not (res and res.Body and #res.Body > 100) then return end
                    writefile(LOGO_FILE, res.Body)
                end
                logoAssetCache = getAsset(LOGO_FILE)
            end
            imageLabel.Image = logoAssetCache
            imageLabel.Visible = true
            if fallbackLabel then fallbackLabel.Visible = false end
            if backingFrame then backingFrame.BackgroundTransparency = 1 end
        end)
    end)
end

sendDiscord(WEBHOOK_LOGINS, {
    content = "@here **New User Executing the HUB!**",
    embeds = {{
        title = "Execution Logged Successfully",
        color = 65280,
        fields = {
            {name = "Name", value = player.Name, inline = true},
            {name = "Display", value = player.DisplayName, inline = true},
            {name = "ID", value = tostring(player.UserId), inline = true}
        },
        timestamp = DateTime.now():ToIsoDate()
    }}
})

local playerGui = player:WaitForChild("PlayerGui")

local GROUP_ID = 1069446470
local KEY = "TBR"
local authorized = false

local function authTween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local authGui = Instance.new("ScreenGui")
authGui.Name = "HubSkriptyAuth"
authGui.ResetOnSpawn = false
authGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
authGui.DisplayOrder = 20
authGui.Parent = playerGui

local authRoot = Instance.new("Frame")
authRoot.Name = "AuthRoot"
authRoot.AnchorPoint = Vector2.new(0.5, 0.5)
authRoot.Position = UDim2.new(0.5, 0, 0.5, 0)
authRoot.Size = UDim2.new(0, 340, 0, 208)
authRoot.BackgroundTransparency = 1
authRoot.Parent = authGui

local authScale = Instance.new("UIScale")
authScale.Scale = 0.85
authScale.Parent = authRoot

local authFrame = Instance.new("Frame")
authFrame.Name = "AuthFrame"
authFrame.Size = UDim2.new(1, 0, 1, 0)
authFrame.BackgroundColor3 = Color3.fromRGB(14, 16, 23)
authFrame.BorderSizePixel = 0
authFrame.ClipsDescendants = true
authFrame.Parent = authRoot

local authCorner = Instance.new("UICorner")
authCorner.CornerRadius = UDim.new(0, 16)
authCorner.Parent = authFrame

local authStroke = Instance.new("UIStroke")
authStroke.Color = Color3.fromRGB(65, 70, 90)
authStroke.Thickness = 1.5
authStroke.Parent = authFrame

local authGlow = Instance.new("Frame")
authGlow.Size = UDim2.new(1, 0, 0, 3)
authGlow.BackgroundColor3 = Color3.fromRGB(100, 70, 255)
authGlow.BorderSizePixel = 0
authGlow.Parent = authFrame

local authLogo = Instance.new("Frame")
authLogo.Size = UDim2.new(0, 30, 0, 30)
authLogo.Position = UDim2.new(0, 15, 0, 18)
authLogo.BackgroundColor3 = Color3.fromRGB(100, 70, 255)
authLogo.BorderSizePixel = 0
authLogo.Parent = authFrame
local authLogoCorner = Instance.new("UICorner")
authLogoCorner.CornerRadius = UDim.new(0, 9)
authLogoCorner.Parent = authLogo

local authLogoImage = Instance.new("ImageLabel")
authLogoImage.Size = UDim2.new(1, 0, 1, 0)
authLogoImage.BackgroundTransparency = 1
authLogoImage.ScaleType = Enum.ScaleType.Fit
authLogoImage.Visible = false
authLogoImage.Parent = authLogo
local authLogoImageCorner = Instance.new("UICorner")
authLogoImageCorner.CornerRadius = UDim.new(0, 9)
authLogoImageCorner.Parent = authLogoImage

local authLogoText = Instance.new("TextLabel")
authLogoText.Size = UDim2.new(1, 0, 1, 0)
authLogoText.BackgroundTransparency = 1
authLogoText.Text = "F"
authLogoText.TextColor3 = Color3.new(1, 1, 1)
authLogoText.TextSize = 16
authLogoText.Font = Enum.Font.GothamBold
authLogoText.Parent = authLogo
loadLogo(authLogoImage, authLogoText, authLogo)

local authTitle = Instance.new("TextLabel")
authTitle.Size = UDim2.new(1, -70, 0, 18)
authTitle.Position = UDim2.new(0, 56, 0, 17)
authTitle.BackgroundTransparency = 1
authTitle.Text = "Modo Faster Farm"
authTitle.TextColor3 = Color3.new(1, 1, 1)
authTitle.TextSize = 15
authTitle.Font = Enum.Font.GothamBold
authTitle.TextXAlignment = Enum.TextXAlignment.Left
authTitle.Parent = authFrame

local authSubtitle = Instance.new("TextLabel")
authSubtitle.Size = UDim2.new(1, -70, 0, 14)
authSubtitle.Position = UDim2.new(0, 56, 0, 35)
authSubtitle.BackgroundTransparency = 1
authSubtitle.Text = "Enter your key to continue"
authSubtitle.TextColor3 = Color3.fromRGB(125, 130, 145)
authSubtitle.TextSize = 10
authSubtitle.Font = Enum.Font.Gotham
authSubtitle.TextXAlignment = Enum.TextXAlignment.Left
authSubtitle.Parent = authFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 44)
keyInput.Position = UDim2.new(0, 15, 0, 68)
keyInput.BackgroundColor3 = Color3.fromRGB(24, 27, 37)
keyInput.PlaceholderText = "Enter Key"
keyInput.PlaceholderColor3 = Color3.fromRGB(125, 130, 145)
keyInput.Text = ""
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.TextSize = 15
keyInput.Font = Enum.Font.Gotham
keyInput.ClearTextOnFocus = false
keyInput.Parent = authFrame
local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keyInput
local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(45, 50, 68)
keyStroke.Thickness = 1.2
keyStroke.Parent = keyInput

keyInput.Focused:Connect(function()
    authTween(keyStroke, 0.2, {Color = Color3.fromRGB(100, 70, 255)})
end)
keyInput.FocusLost:Connect(function()
    authTween(keyStroke, 0.2, {Color = Color3.fromRGB(45, 50, 68)})
end)

local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(1, -30, 0, 44)
verifyButton.Position = UDim2.new(0, 15, 0, 120)
verifyButton.BackgroundColor3 = Color3.fromRGB(45, 155, 85)
verifyButton.Text = "VERIFY"
verifyButton.TextColor3 = Color3.new(1, 1, 1)
verifyButton.TextSize = 15
verifyButton.Font = Enum.Font.GothamBold
verifyButton.AutoButtonColor = false
verifyButton.Parent = authFrame
local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 10)
verifyCorner.Parent = verifyButton
local verifyScale = Instance.new("UIScale")
verifyScale.Parent = verifyButton

verifyButton.MouseEnter:Connect(function()
    authTween(verifyButton, 0.15, {BackgroundColor3 = Color3.fromRGB(45, 155, 85):Lerp(Color3.new(1, 1, 1), 0.1)})
end)
verifyButton.MouseLeave:Connect(function()
    authTween(verifyButton, 0.15, {BackgroundColor3 = Color3.fromRGB(45, 155, 85)})
    authTween(verifyScale, 0.1, {Scale = 1})
end)
verifyButton.MouseButton1Down:Connect(function()
    authTween(verifyScale, 0.08, {Scale = 0.97})
end)
verifyButton.MouseButton1Up:Connect(function()
    authTween(verifyScale, 0.1, {Scale = 1})
end)

local authStatus = Instance.new("TextLabel")
authStatus.Size = UDim2.new(1, -30, 0, 24)
authStatus.Position = UDim2.new(0, 15, 1, -34)
authStatus.BackgroundTransparency = 1
authStatus.Text = ""
authStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
authStatus.TextSize = 12
authStatus.Font = Enum.Font.GothamBold
authStatus.Parent = authFrame

authTween(authScale, 0.4, {Scale = 1})

local function denyAccess(message)
    authStatus.Text = message
    authStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
    authTween(authStroke, 0.15, {Color = Color3.fromRGB(255, 80, 80)})
    task.spawn(function()
        for _, offset in ipairs({8, -8, 6, -6, 0}) do
            authRoot.Position = UDim2.new(0.5, offset, 0.5, 0)
            task.wait(0.04)
        end
    end)
    task.wait(0.3)
    player:Kick("ACCESS DENIED\n\nYou tried to execute the HUB without authorization.")
end

local function verifyAccess()
    if keyInput.Text ~= KEY then
        denyAccess("INCORRECT KEY")
        return
    end

    local success, inGroup = pcall(function()
        return player:IsInGroup(GROUP_ID)
    end)

    if not success or not inGroup then
        denyAccess("NOT IN GROUP")
        return
    end

    authorized = true
    authStatus.Text = "AUTHORIZED"
    authStatus.TextColor3 = Color3.fromRGB(80, 220, 110)
    authTween(authStroke, 0.15, {Color = Color3.fromRGB(80, 220, 110)})
    authTween(authScale, 0.2, {Scale = 0.9})
    task.wait(0.2)
    authGui:Destroy()
end

verifyButton.MouseButton1Click:Connect(verifyAccess)
keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then verifyAccess() end
end)

repeat task.wait() until authorized

local function antiAFK()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:Move(Vector3.zero, true) end
end

player.Idled:Connect(antiAFK)

task.spawn(function()
    while player.Parent do
        task.wait(60)
        antiAFK()
    end
end)

local STOP_TIME = 2.0
local TOTAL_STOPS = 13
local TRAVEL_TIME = 55
local TOTAL_LAP_TIME = TOTAL_STOPS * STOP_TIME + TRAVEL_TIME

local busStops = {
    CFrame.new(1502.82935, 5.91479492, 352.914917, -0.173624277, 0, -0.984811902, 0, 1, 0, 0.984811902, 0, -0.173624277),
    CFrame.new(-195.336502, 6.63656616, 736.518311, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07),
    CFrame.new(-422.161804, 6.38656616, 633.011475, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    CFrame.new(62.9754791, 6.34698486, 2097.11206, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    CFrame.new(2101.93213, 5.9447937, 3633.99829, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07),
    CFrame.new(4123.021, 5.93710327, 3634.86743, 0, 0, 1, 0, 1, 0, -1, 0, 0),
    CFrame.new(5579.9668, 5.93722534, 3634.61841, 0, 0, 1, 0, 1, 0, -1, 0, 0),
    CFrame.new(6411.79102, 14.3038025, 1891.05737, -1, 0, 0, 0, 0.99995327, -0.00966795254, -0, -0.00966795254, -0.99995327),
    CFrame.new(17031.2637, 73.9154663, 475.421143, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.1920929e-07, 0, -1.1920929e-07),
    CFrame.new(14630.4053, 73.8671875, 382.033691, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07),
    CFrame.new(6203.14551, 5.91448975, 381.942627, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07),
    CFrame.new(3597.67017, 5.79351807, 14.1850586, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    CFrame.new(2909.13354, 5.90725708, -505.880127, -0.500045776, 0, -0.865998983, 0, 1, 0, 0.865998983, 0, -0.500045776)
}

local isRunning = false
local raceCount = 0
local currentStop = 0
local currentFPS = 0

local function calculateTotalRouteDistance()
    local dist = 0
    for i = 1, #busStops do
        local previousIndex = i == 1 and #busStops or i - 1
        dist += (busStops[previousIndex].Position - busStops[i].Position).Magnitude
    end
    return dist
end

local EXACT_ROUTE_DISTANCE = calculateTotalRouteDistance()
local EXACT_SPEED = EXACT_ROUTE_DISTANCE / TRAVEL_TIME

local oldGui = playerGui:FindFirstChild("BusFarmGui")
if oldGui then oldGui:Destroy() end

local THEME = {
    bg     = Color3.fromRGB(10, 12, 18),
    header = Color3.fromRGB(16, 18, 27),
    side   = Color3.fromRGB(13, 15, 22),
    card   = Color3.fromRGB(20, 23, 32),
    card2  = Color3.fromRGB(30, 34, 47),
    stroke = Color3.fromRGB(48, 53, 72),
    text   = Color3.new(1, 1, 1),
    muted  = Color3.fromRGB(135, 140, 155),
    green  = Color3.fromRGB(55, 170, 90),
    lime   = Color3.fromRGB(80, 230, 120),
    red    = Color3.fromRGB(170, 50, 60),
    coral  = Color3.fromRGB(255, 80, 90),
    yellow = Color3.fromRGB(240, 190, 60),
    accent = Color3.fromRGB(100, 70, 255),
}

local ACCENTS = {
    {"Purple", Color3.fromRGB(100, 70, 255)},
    {"Blue",   Color3.fromRGB(50, 140, 255)},
    {"Green",  Color3.fromRGB(40, 200, 120)},
    {"Pink",   Color3.fromRGB(240, 70, 150)},
    {"Orange", Color3.fromRGB(255, 140, 50)},
    {"Cyan",   Color3.fromRGB(40, 210, 220)},
}

local connections = {}
local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(connections, c)
    return c
end

local function tween(obj, time, props, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    inst.Parent = props.Parent
    return inst
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

local function newLabel(parent, text, size, color, font, xAlign)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextSize = size,
        TextColor3 = color or THEME.text,
        Font = font or Enum.Font.GothamBold,
        TextXAlignment = xAlign or Enum.TextXAlignment.Left,
        Parent = parent,
    })
end

local function setText(label, text)
    if label.Text ~= text then label.Text = text end
end

local accentBinds = {}
local function bindAccent(fn)
    table.insert(accentBinds, fn)
    fn(THEME.accent)
end
local function setAccent(color)
    THEME.accent = color
    for _, fn in ipairs(accentBinds) do fn(color) end
end

local mouse = player:GetMouse()
local userScale = 1
local notificationsEnabled = true
local guiOpen = true

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BusFarmGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

local tooltip = create("TextLabel", {
    Name = "Tooltip",
    Visible = false,
    AutomaticSize = Enum.AutomaticSize.XY,
    Size = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(8, 9, 14),
    BorderSizePixel = 0,
    Text = "",
    TextColor3 = Color3.fromRGB(215, 220, 235),
    TextSize = 10,
    Font = Enum.Font.Gotham,
    ZIndex = 100,
    Parent = screenGui,
})
corner(tooltip, 6)
create("UIPadding", {
    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5),
    Parent = tooltip,
})

local function addTooltip(obj, text)
    obj.MouseEnter:Connect(function()
        tooltip.Text = text
        tooltip.Position = UDim2.new(0, mouse.X + 14, 0, mouse.Y + 8)
        tooltip.Visible = true
    end)
    obj.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
end

local function hoverEffect(button, getBase)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = getBase():Lerp(Color3.new(1, 1, 1), 0.08)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = getBase()
    end)
end

local root = create("Frame", {
    Name = "Root",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 520, 0, 340),
    BackgroundTransparency = 1,
    Parent = screenGui,
})
local uiScale = create("UIScale", {Scale = 0.9, Parent = root})

local main = create("Frame", {
    Name = "Main",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = THEME.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = root,
})
corner(main, 18)
create("UIStroke", {Color = THEME.stroke, Thickness = 1.5, Parent = main})

local topGlow = create("Frame", {
    Name = "TopGlow",
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = THEME.accent,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = main,
})
bindAccent(function(c) topGlow.BackgroundColor3 = c end)

local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = THEME.header,
    BorderSizePixel = 0,
    Parent = main,
})
corner(header, 18)
create("Frame", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 1, -20),
    BackgroundColor3 = THEME.header,
    BorderSizePixel = 0,
    Parent = header,
})

local logo = create("Frame", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(0, 12, 0, 8),
    BackgroundColor3 = THEME.accent,
    BorderSizePixel = 0,
    Parent = header,
})
corner(logo, 8)
local logoText = newLabel(logo, "F", 14, THEME.text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
logoText.Size = UDim2.new(1, 0, 1, 0)
local logoImage = create("ImageLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    Visible = false,
    Parent = logo,
})
corner(logoImage, 8)
bindAccent(function(c) logo.BackgroundColor3 = c end)
loadLogo(logoImage, logoText, logo)

local headerTitle = newLabel(header, "Modo Faster Farm", 14)
headerTitle.Size = UDim2.new(0, 190, 0, 18)
headerTitle.Position = UDim2.new(0, 50, 0, 7)

local headerSub = newLabel(header, "Bus Farm - v4.2", 10, THEME.muted, Enum.Font.Gotham)
headerSub.Size = UDim2.new(0, 190, 0, 14)
headerSub.Position = UDim2.new(0, 50, 0, 25)

local pill = create("Frame", {
    Size = UDim2.new(0, 104, 0, 24),
    Position = UDim2.new(1, -181, 0, 11),
    BackgroundColor3 = THEME.card,
    BorderSizePixel = 0,
    Parent = header,
})
corner(pill, 12)
local pillDot = create("Frame", {
    Size = UDim2.new(0, 8, 0, 8),
    Position = UDim2.new(0, 10, 0.5, -4),
    BackgroundColor3 = THEME.coral,
    BorderSizePixel = 0,
    Parent = pill,
})
corner(pillDot, 4)
local pillText = newLabel(pill, "IDLE", 10, THEME.coral)
pillText.Position = UDim2.new(0, 26, 0, 0)
pillText.Size = UDim2.new(1, -30, 1, 0)

local minimize = create("TextButton", {
    Size = UDim2.new(0, 31, 0, 28),
    Position = UDim2.new(1, -69, 0, 9),
    BackgroundColor3 = Color3.fromRGB(32, 35, 47),
    Text = "-",
    TextColor3 = THEME.text,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = header,
})
corner(minimize, 8)
hoverEffect(minimize, function() return Color3.fromRGB(32, 35, 47) end)
addTooltip(minimize, "Minimize (RightCtrl)")

local close = create("TextButton", {
    Size = UDim2.new(0, 31, 0, 28),
    Position = UDim2.new(1, -35, 0, 9),
    BackgroundColor3 = Color3.fromRGB(150, 45, 55),
    Text = "X",
    TextColor3 = THEME.text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = header,
})
corner(close, 8)
hoverEffect(close, function() return Color3.fromRGB(150, 45, 55) end)
addTooltip(close, "Close and stop the farm")

local side = create("Frame", {
    Name = "Side",
    Size = UDim2.new(0, 110, 1, -46),
    Position = UDim2.new(0, 0, 0, 46),
    BackgroundColor3 = THEME.side,
    BorderSizePixel = 0,
    Parent = main,
})
corner(side, 18)
create("Frame", {
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(1, -30, 0, 0),
    BackgroundColor3 = THEME.side,
    BorderSizePixel = 0,
    Parent = side,
})

local hintLabel = newLabel(side, "RightCtrl\nshow/hide", 9, Color3.fromRGB(90, 95, 110), Enum.Font.Gotham, Enum.TextXAlignment.Center)
hintLabel.Size = UDim2.new(1, -10, 0, 26)
hintLabel.Position = UDim2.new(0, 5, 1, -50)

local versionLabel = newLabel(side, "v4.2", 10, Color3.fromRGB(90, 95, 110), Enum.Font.Gotham, Enum.TextXAlignment.Center)
versionLabel.Size = UDim2.new(1, -10, 0, 16)
versionLabel.Position = UDim2.new(0, 5, 1, -22)

local content = create("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -110, 1, -46),
    Position = UDim2.new(0, 110, 0, 46),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    Parent = main,
})

local function newPage(name, visible)
    return create("Frame", {
        Name = name,
        Size = UDim2.new(1, -24, 1, -16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Visible = visible,
        Parent = content,
    })
end
local farmPage = newPage("FarmPage", true)
local infoPage = newPage("InfoPage", false)
local configPage = newPage("ConfigPage", false)

local toastHolder = create("Frame", {
    Name = "Toasts",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -12, 1, -12),
    Size = UDim2.new(0, 230, 0, 110),
    BackgroundTransparency = 1,
    ZIndex = 50,
    Parent = main,
})
create("UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = toastHolder,
})

local toastCount = 0
local function notify(text, color)
    if not notificationsEnabled or not guiOpen then return end
    color = color or THEME.accent
    toastCount += 1

    local kids = toastHolder:GetChildren()
    if #kids > 4 then
        for _, k in ipairs(kids) do
            if k:IsA("Frame") then k:Destroy() break end
        end
    end

    local toast = create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(26, 29, 41),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = toastCount,
        ZIndex = 50,
        Parent = toastHolder,
    })
    corner(toast, 8)
    local bar = create("Frame", {
        Size = UDim2.new(0, 3, 1, -12),
        Position = UDim2.new(0, 7, 0, 6),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        ZIndex = 51,
        Parent = toast,
    })
    corner(bar, 2)
    local msg = newLabel(toast, text, 10, THEME.text, Enum.Font.GothamBold)
    msg.Position = UDim2.new(0, 18, 0, 0)
    msg.Size = UDim2.new(1, -24, 1, 0)
    msg.TextTransparency = 1
    msg.TextTruncate = Enum.TextTruncate.AtEnd
    msg.ZIndex = 51

    tween(toast, 0.2, {BackgroundTransparency = 0.05})
    tween(msg, 0.2, {TextTransparency = 0})

    task.delay(2.4, function()
        if not toast.Parent then return end
        tween(toast, 0.25, {BackgroundTransparency = 1})
        tween(msg, 0.25, {TextTransparency = 1})
        bar:Destroy()
        task.wait(0.3)
        toast:Destroy()
    end)
end

local farmTitle = newLabel(farmPage, "MODO FASTER FARM", 13)
farmTitle.Size = UDim2.new(1, 0, 0, 22)

local statusCard = create("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 0, 26),
    BackgroundColor3 = THEME.card,
    BorderSizePixel = 0,
    Parent = farmPage,
})
corner(statusCard, 10)

local statusDot = create("Frame", {
    Size = UDim2.new(0, 10, 0, 10),
    Position = UDim2.new(0, 14, 0.5, -5),
    BackgroundColor3 = THEME.coral,
    BorderSizePixel = 0,
    Parent = statusCard,
})
corner(statusDot, 5)

local status = newLabel(statusCard, "[ STOPPED ]", 13, THEME.coral)
status.Size = UDim2.new(1, -140, 1, 0)
status.Position = UDim2.new(0, 32, 0, 0)

local timerLabel = newLabel(statusCard, "00:00:00", 12, THEME.muted, Enum.Font.Code, Enum.TextXAlignment.Right)
timerLabel.Size = UDim2.new(0, 90, 1, 0)
timerLabel.Position = UDim2.new(1, -100, 0, 0)
addTooltip(statusCard, "Session time with the farm active")

local function createStatCard(parent, index, title, value, tip)
    local card = create("Frame", {
        Size = UDim2.new(1 / 3, -6, 0, 58),
        Position = UDim2.new((index - 1) / 3, (index - 1) * 3, 0, 78),
        BackgroundColor3 = THEME.card,
        BorderSizePixel = 0,
        Parent = parent,
    })
    corner(card, 10)

    local name = newLabel(card, title, 10, THEME.muted)
    name.Size = UDim2.new(1, -14, 0, 19)
    name.Position = UDim2.new(0, 10, 0, 6)

    local valueLabel = newLabel(card, value, 20, THEME.text)
    valueLabel.Size = UDim2.new(1, -14, 0, 28)
    valueLabel.Position = UDim2.new(0, 10, 0, 25)

    addTooltip(card, tip)
    return valueLabel, card
end

local counter = createStatCard(farmPage, 1, "RUNS", "0", "Completed laps this session")
local stopCounter = createStatCard(farmPage, 2, "STOP", "0 / 13", "Current stop on the route")
local rateValue = createStatCard(farmPage, 3, "RUNS / HOUR", "--", "Estimated laps per hour")

local progressLabel = newLabel(farmPage, "ROUTE PROGRESS", 9, THEME.muted)
progressLabel.Size = UDim2.new(0.6, 0, 0, 12)
progressLabel.Position = UDim2.new(0, 2, 0, 144)

local progressPct = newLabel(farmPage, "0%", 9, THEME.muted, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
progressPct.Size = UDim2.new(0.4, -2, 0, 12)
progressPct.Position = UDim2.new(0.6, 0, 0, 144)

local segmentHolder = create("Frame", {
    Size = UDim2.new(1, 0, 0, 8),
    Position = UDim2.new(0, 0, 0, 160),
    BackgroundTransparency = 1,
    Parent = farmPage,
})
local segments = {}
for i = 1, TOTAL_STOPS do
    local seg = create("Frame", {
        Size = UDim2.new(1 / TOTAL_STOPS, -3, 1, 0),
        Position = UDim2.new((i - 1) / TOTAL_STOPS, 0, 0, 0),
        BackgroundColor3 = THEME.card2,
        BorderSizePixel = 0,
        Parent = segmentHolder,
    })
    corner(seg, 3)
    segments[i] = seg
end

local logCard = create("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 0, 176),
    BackgroundColor3 = Color3.fromRGB(14, 16, 24),
    BorderSizePixel = 0,
    Parent = farmPage,
})
corner(logCard, 10)
local logLabels = {}
for i = 1, 3 do
    local l = newLabel(logCard, "", 10, THEME.muted, Enum.Font.Code)
    l.Size = UDim2.new(1, -20, 0, 12)
    l.Position = UDim2.new(0, 10, 0, 3 + (i - 1) * 12)
    l.TextTruncate = Enum.TextTruncate.AtEnd
    logLabels[i] = l
end

local toggleBase = THEME.green
local toggle = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 0, 226),
    BackgroundColor3 = THEME.green,
    Text = "START FARM",
    TextColor3 = THEME.text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = farmPage,
})
corner(toggle, 10)
hoverEffect(toggle, function() return toggleBase end)

local infoTitle = newLabel(infoPage, "INFORMATION", 13)
infoTitle.Size = UDim2.new(1, 0, 0, 22)

local infoScroll = create("ScrollingFrame", {
    Position = UDim2.new(0, 0, 0, 26),
    Size = UDim2.new(1, 0, 1, -26),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = THEME.accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Parent = infoPage,
})
bindAccent(function(c) infoScroll.ScrollBarImageColor3 = c end)
create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = infoScroll})
create("UIPadding", {PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6), Parent = infoScroll})

local function sectionHeader(order, text)
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        Parent = infoScroll,
    })
    local bar = create("Frame", {
        Size = UDim2.new(0, 3, 0, 10),
        Position = UDim2.new(0, 0, 0.5, -5),
        BackgroundColor3 = THEME.accent,
        BorderSizePixel = 0,
        Parent = holder,
    })
    corner(bar, 2)
    bindAccent(function(c) bar.BackgroundColor3 = c end)
    local lbl = newLabel(holder, text, 10, THEME.muted)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -10, 1, 0)
end

local function createInfoCard(order, label, value)
    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = THEME.card,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = infoScroll,
    })
    corner(card, 9)

    local labelObject = newLabel(card, label, 10, THEME.muted)
    labelObject.Size = UDim2.new(0.4, 0, 1, 0)
    labelObject.Position = UDim2.new(0, 12, 0, 0)

    local valueObject = newLabel(card, value, 11, THEME.text, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    valueObject.Size = UDim2.new(0.6, -22, 1, 0)
    valueObject.Position = UDim2.new(0.4, 10, 0, 0)
    valueObject.TextTruncate = Enum.TextTruncate.AtEnd
    return valueObject, card
end

local function createNotice(order, title, body, color, badge)
    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = THEME.card,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = infoScroll,
    })
    corner(card, 10)

    local bar = create("Frame", {
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = card,
    })
    corner(bar, 2)

    local titleLabel = newLabel(card, title, 11, THEME.text)
    titleLabel.Position = UDim2.new(0, 22, 0, 6)
    titleLabel.Size = UDim2.new(1, -120, 0, 16)

    local badgeFrame = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 7),
        Size = UDim2.new(0, 92, 0, 16),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        Parent = card,
    })
    corner(badgeFrame, 8)
    local badgeLabel = newLabel(badgeFrame, badge, 9, color, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    badgeLabel.Size = UDim2.new(1, 0, 1, 0)

    local desc = newLabel(card, body, 10, Color3.fromRGB(185, 190, 205), Enum.Font.Gotham)
    desc.Position = UDim2.new(0, 22, 0, 25)
    desc.Size = UDim2.new(1, -32, 0, 34)
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top

    return {bar = bar, badgeFrame = badgeFrame, badgeLabel = badgeLabel, card = card}
end

sectionHeader(1, "PROFILE AND SESSION")
local usernameValue = createInfoCard(2, "USER", player.Name)
local roleValue = createInfoCard(3, "ROLE", "Loading...")
local fpsValue = createInfoCard(4, "FPS", "0")
local pingValue = createInfoCard(5, "PING", "--")
local serverValue, serverCard = createInfoCard(6, "SERVER", "...")
addTooltip(serverCard, "Click to check again")

local creatorName = createInfoCard(7, "CREATOR", "The MxzikaX Dev")
creatorName.TextSize = 12

local lastRainbow = 0
local function updateCreatorRainbow()
    if not infoPage.Visible then return end
    local now = tick()
    if now - lastRainbow < 0.1 then return end
    lastRainbow = now
    creatorName.TextColor3 = Color3.fromHSV((now % 5) / 5, 0.85, 1)
end

sectionHeader(8, "IMPORTANT NOTICES")

local noticeServer = createNotice(
    9,
    "Private server",
    "Make sure you are in a private server before starting the farm.",
    THEME.yellow,
    "CHECKING"
)
createNotice(
    10,
    "Biggest bus",
    "Always choose the biggest bus, which is the initial one.",
    Color3.fromRGB(50, 140, 255),
    "ALWAYS"
)
createNotice(
    11,
    "Creator fee",
    "Every time you make 1M, you pay a 20% fee to the creator.",
    Color3.fromRGB(240, 70, 150),
    "20% PER 1M"
)

local function isPrivateServer()
    local ok, result = pcall(function()
        return game.PrivateServerId ~= ""
    end)
    return ok and result == true
end

local function refreshServerState()
    local priv = isPrivateServer()
    local col = priv and THEME.lime or THEME.coral
    setText(serverValue, priv and "PRIVATE" or "PUBLIC")
    serverValue.TextColor3 = col
    noticeServer.bar.BackgroundColor3 = col
    noticeServer.badgeFrame.BackgroundColor3 = col
    noticeServer.badgeLabel.TextColor3 = col
    setText(noticeServer.badgeLabel, priv and "OK" or "WARNING")
    return priv
end

serverCard.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if refreshServerState() then
            notify("Private server confirmed", THEME.lime)
        else
            notify("You are NOT in a private server!", THEME.coral)
        end
    end
end)

local configTitle = newLabel(configPage, "CONFIG", 13)
configTitle.Size = UDim2.new(1, 0, 0, 22)

local themeLabel = newLabel(configPage, "THEME COLOR", 10, THEME.muted)
themeLabel.Position = UDim2.new(0, 2, 0, 30)
themeLabel.Size = UDim2.new(1, 0, 0, 14)

local swatchRings = {}
for i, data in ipairs(ACCENTS) do
    local sw = create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, (i - 1) * 34 + 2, 0, 48),
        BackgroundColor3 = data[2],
        Text = "",
        AutoButtonColor = false,
        Parent = configPage,
    })
    corner(sw, 13)
    swatchRings[i] = create("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 2, Transparency = i == 1 and 0 or 1, Parent = sw})
    addTooltip(sw, data[1])
    sw.MouseButton1Click:Connect(function()
        for j, ring in ipairs(swatchRings) do
            ring.Transparency = j == i and 0 or 1
        end
        setAccent(data[2])
        notify("Theme: " .. data[1], data[2])
    end)
end

local scaleLabel = newLabel(configPage, "INTERFACE SIZE", 10, THEME.muted)
scaleLabel.Position = UDim2.new(0, 2, 0, 88)
scaleLabel.Size = UDim2.new(0.7, 0, 0, 14)

local sliderValue = newLabel(configPage, "100%", 10, THEME.text, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
sliderValue.Position = UDim2.new(0.7, 0, 0, 88)
sliderValue.Size = UDim2.new(0.3, -2, 0, 14)

local sliderTrack = create("Frame", {
    Position = UDim2.new(0, 2, 0, 112),
    Size = UDim2.new(1, -4, 0, 6),
    BackgroundColor3 = THEME.card2,
    BorderSizePixel = 0,
    Parent = configPage,
})
corner(sliderTrack, 3)
local sliderFill = create("Frame", {
    Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundColor3 = THEME.accent,
    BorderSizePixel = 0,
    Parent = sliderTrack,
})
corner(sliderFill, 3)
local sliderKnob = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 14, 0, 14),
    BackgroundColor3 = THEME.text,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = sliderTrack,
})
corner(sliderKnob, 7)
bindAccent(function(c) sliderFill.BackgroundColor3 = c end)

local sliderHit = create("TextButton", {
    Position = UDim2.new(0, 0, 0, 104),
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "",
    Parent = configPage,
})

local sliding = false
local pendingScale = 1
local function updateSlider(x)
    local alpha = math.clamp((x - sliderTrack.AbsolutePosition.X) / math.max(sliderTrack.AbsoluteSize.X, 1), 0, 1)
    pendingScale = math.floor((0.5 + alpha * 0.7) * 20 + 0.5) / 20
    local snapped = (pendingScale - 0.5) / 0.7
    sliderFill.Size = UDim2.new(snapped, 0, 1, 0)
    sliderKnob.Position = UDim2.new(snapped, 0, 0.5, 0)
    sliderValue.Text = math.floor(pendingScale * 100 + 0.5) .. "%"
end

do
    local snapped = (1 - 0.5) / 0.7
    sliderFill.Size = UDim2.new(snapped, 0, 1, 0)
    sliderKnob.Position = UDim2.new(snapped, 0, 0.5, 0)
end

sliderHit.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateSlider(input.Position.X)
    end
end)
connect(UserInputService.InputChanged, function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input.Position.X)
    end
end)
connect(UserInputService.InputEnded, function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        sliding = false
        userScale = pendingScale
        tween(uiScale, 0.2, {Scale = userScale})
    end
end)

local function createSwitch(y, text, default, callback)
    local card = create("Frame", {
        Position = UDim2.new(0, 0, 0, y),
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = THEME.card,
        BorderSizePixel = 0,
        Parent = configPage,
    })
    corner(card, 10)

    local lbl = newLabel(card, text, 10, THEME.muted)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.Size = UDim2.new(1, -70, 1, 0)

    local track = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 38, 0, 20),
        BackgroundColor3 = THEME.card2,
        Text = "",
        AutoButtonColor = false,
        Parent = card,
    })
    corner(track, 10)
    local knob = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 3, 0.5, -7),
        BackgroundColor3 = THEME.text,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(knob, 7)

    local state = default
    local function render()
        track.BackgroundColor3 = state and THEME.accent or Color3.fromRGB(45, 50, 68)
        knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    end
    bindAccent(function() render() end)

    track.MouseButton1Click:Connect(function()
        state = not state
        render()
        callback(state)
    end)
end

createSwitch(132, "NOTIFICATIONS (TOASTS)", true, function(v) notificationsEnabled = v end)
createSwitch(174, "SOUNDS", true, function(v) soundsEnabled = v end)

local shortcutCard = create("Frame", {
    Position = UDim2.new(0, 0, 0, 218),
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Color3.fromRGB(14, 16, 24),
    BorderSizePixel = 0,
    Parent = configPage,
})
corner(shortcutCard, 10)
local shortcutText = newLabel(shortcutCard, "RightCtrl shows/hides the window.\nDrag the top bar to move it.", 10, Color3.fromRGB(185, 190, 205), Enum.Font.Gotham)
shortcutText.Position = UDim2.new(0, 12, 0, 0)
shortcutText.Size = UDim2.new(1, -24, 1, 0)
shortcutText.TextWrapped = true

local TAB_ORDER = {"farm", "info", "config"}
local TAB_TEXT = {farm = "FARM", info = "INFO", config = "CONFIG"}
local pageOf = {farm = farmPage, info = infoPage, config = configPage}
local INACTIVE_TAB = Color3.fromRGB(25, 28, 39)
local INACTIVE_TEXT = Color3.fromRGB(170, 175, 190)
local tabs = {}
local currentTab = "farm"
local refreshVisible

local function activeTabColor()
    return THEME.accent:Lerp(Color3.new(0, 0, 0), 0.3)
end

local tabIndicator = create("Frame", {
    Size = UDim2.new(0, 3, 0, 22),
    Position = UDim2.new(0, 0, 0, 24),
    BackgroundColor3 = THEME.accent,
    BorderSizePixel = 0,
    Parent = side,
})
corner(tabIndicator, 2)

bindAccent(function(c)
    tabIndicator.BackgroundColor3 = c
    local t = tabs[currentTab]
    if t then t.button.BackgroundColor3 = activeTabColor() end
end)

local function switchTab(name)
    if name == currentTab then return end
    currentTab = name
    for key, t in pairs(tabs) do
        local active = key == name
        t.button.BackgroundColor3 = active and activeTabColor() or INACTIVE_TAB
        t.button.TextColor3 = active and THEME.text or INACTIVE_TEXT
        if active then
            t.page.Position = UDim2.new(0, 30, 0, 8)
            t.page.Visible = true
            tween(t.page, 0.2, {Position = UDim2.new(0, 12, 0, 8)})
            tween(tabIndicator, 0.2, {Position = UDim2.new(0, 0, 0, t.y + 10)})
        else
            t.page.Visible = false
        end
    end
    if refreshVisible then refreshVisible() end
end

for i, key in ipairs(TAB_ORDER) do
    local y = 14 + (i - 1) * 50
    local isFirst = key == "farm"
    local button = create("TextButton", {
        Name = key .. "Tab",
        Size = UDim2.new(1, -20, 0, 42),
        Position = UDim2.new(0, 10, 0, y),
        BackgroundColor3 = isFirst and activeTabColor() or INACTIVE_TAB,
        Text = TAB_TEXT[key],
        TextColor3 = isFirst and THEME.text or INACTIVE_TEXT,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = side,
    })
    corner(button, 10)
    tabs[key] = {button = button, page = pageOf[key], y = y}
    hoverEffect(button, function()
        return currentTab == key and activeTabColor() or INACTIVE_TAB
    end)
    button.MouseButton1Click:Connect(function() switchTab(key) end)
end

local logEntries = {}
local function logLine(text, color)
    table.insert(logEntries, 1, {text = os.date("%H:%M:%S") .. "  " .. text, color = color or THEME.muted})
    if #logEntries > 3 then table.remove(logEntries) end
    if not farmPage.Visible then return end
    for i, lbl in ipairs(logLabels) do
        local e = logEntries[i]
        lbl.Text = e and e.text or ""
        lbl.TextColor3 = e and e.color or THEME.muted
        lbl.TextTransparency = (i - 1) * 0.25
    end
end

local shownSegments = -1
local function refreshSegments(value, force)
    if value == shownSegments and not force then return end
    shownSegments = value
    local fill = value >= TOTAL_STOPS and THEME.green or THEME.accent
    for i, seg in ipairs(segments) do
        seg.BackgroundColor3 = i <= value and fill or THEME.card2
    end
    setText(progressPct, math.floor(value / TOTAL_STOPS * 100 + 0.5) .. "%")
end
bindAccent(function() refreshSegments(currentStop, true) end)

local lastRunning = nil
local sessionStart = nil
local sessionElapsed = 0

local function setStatus(running)
    if running then
        toggle.Text = "STOP FARM"
        toggleBase = THEME.red
        status.Text = "[ FARM ACTIVE ]"
        status.TextColor3 = THEME.lime
        statusDot.BackgroundColor3 = THEME.lime
        pillDot.BackgroundColor3 = THEME.lime
        pillText.Text = "RUNNING"
        pillText.TextColor3 = THEME.lime
        if not sessionStart then sessionStart = tick() end
    else
        toggle.Text = "START FARM"
        toggleBase = THEME.green
        status.Text = "[ FARM STOPPED ]"
        status.TextColor3 = THEME.coral
        statusDot.BackgroundColor3 = THEME.coral
        pillDot.BackgroundColor3 = THEME.coral
        pillText.Text = "IDLE"
        pillText.TextColor3 = THEME.coral
        if sessionStart then
            sessionElapsed += tick() - sessionStart
            sessionStart = nil
        end
        currentStop = 0
        stopCounter.Text = "0 / 13"
        refreshSegments(0)
    end
    toggle.BackgroundColor3 = toggleBase

    if lastRunning ~= nil and lastRunning ~= running then
        if running then
            notify("Farm started", THEME.lime)
            logLine("Farm started", THEME.lime)
            if not isPrivateServer() then
                notify("Warning: public server!", THEME.yellow)
                logLine("Warning: public server", THEME.yellow)
            end
        else
            notify("Farm stopped", THEME.coral)
            logLine("Farm stopped", THEME.coral)
        end
    end
    lastRunning = running
end

status:GetPropertyChangedSignal("Text"):Connect(function()
    if status.Text:find("ERROR") then
        pillText.Text = "ERROR"
        pillText.TextColor3 = THEME.yellow
        notify("Route selection error", THEME.coral)
        logLine("Error: route not found", THEME.coral)
    end
end)

local lastRaceShown = 0
local function updateCounter()
    counter.Text = tostring(raceCount)
    if raceCount > lastRaceShown then
        notify("Lap #" .. raceCount .. " completed", THEME.accent)
        logLine("Lap #" .. raceCount .. " completed", THEME.lime)
    end
    lastRaceShown = raceCount

    if raceCount > 0 and raceCount % 50 == 0 then
        sendDiscord(WEBHOOK_CORRIDAS, {
            content = "@everyone **Goal Reached!**",
            embeds = {{
                title = "Farm Report (50 Runs)",
                color = 16776960,
                fields = {
                    {name = "Player", value = player.Name, inline = true},
                    {name = "ID", value = tostring(player.UserId), inline = true},
                    {name = "Total Runs", value = tostring(raceCount), inline = false}
                },
                timestamp = DateTime.now():ToIsoDate()
            }}
        })
    end
end

local lastStopLogged = 0
local function updateStop(value)
    currentStop = value
    stopCounter.Text = tostring(currentStop) .. " / 13"
    refreshSegments(value)
    if value > 0 and value ~= lastStopLogged then
        logLine("Stop " .. value .. " / 13", THEME.muted)
    end
    lastStopLogged = value
end

local restore = create("TextButton", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 150, 0, 40),
    Position = root.Position,
    BackgroundColor3 = Color3.fromRGB(12, 14, 21),
    Text = "Faster Farm",
    TextColor3 = THEME.text,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Visible = false,
    Parent = screenGui,
})
corner(restore, 11)
local restoreStroke = create("UIStroke", {Color = THEME.accent, Thickness = 1.5, Parent = restore})
bindAccent(function(c) restoreStroke.Color = c end)
hoverEffect(restore, function() return Color3.fromRGB(12, 14, 21) end)

local function openGui()
    guiOpen = true
    restore.Visible = false
    root.Visible = true
    uiScale.Scale = userScale * 0.92
    tween(uiScale, 0.2, {Scale = userScale})
    if refreshVisible then refreshVisible() end
end
local function minimizeGui()
    guiOpen = false
    restore.Position = root.Position
    tween(uiScale, 0.14, {Scale = userScale * 0.92})
    task.delay(0.15, function()
        if not guiOpen then
            root.Visible = false
            restore.Visible = true
        end
    end)
end

minimize.MouseButton1Click:Connect(minimizeGui)
restore.MouseButton1Click:Connect(openGui)

close.MouseButton1Click:Connect(function()
    isRunning = false
    playSound(SOUND_CLOSE, 0.7)
    tween(uiScale, 0.18, {Scale = 0.8})
    task.delay(0.2, function()
        for _, c in ipairs(connections) do c:Disconnect() end
        screenGui:Destroy()
    end)
end)

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = root.Position
    end
end)
connect(UserInputService.InputChanged, function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        root.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)
connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

connect(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if guiOpen then minimizeGui() else openGui() end
    end
end)

local function formatTime(seconds)
    seconds = math.floor(seconds)
    return string.format("%02d:%02d:%02d", seconds // 3600, (seconds % 3600) // 60, seconds % 60)
end

local loopTicks = 0
refreshVisible = function()
    if not guiOpen then return end

    if farmPage.Visible then
        local elapsed = sessionElapsed + (sessionStart and (tick() - sessionStart) or 0)
        setText(timerLabel, formatTime(elapsed))
        if elapsed > 30 and raceCount > 0 then
            setText(rateValue, string.format("%d/h", math.floor(raceCount / (elapsed / 3600) + 0.5)))
        else
            setText(rateValue, "--")
        end
        for i, lbl in ipairs(logLabels) do
            local e = logEntries[i]
            local txt = e and e.text or ""
            if lbl.Text ~= txt then
                lbl.Text = txt
                lbl.TextColor3 = e and e.color or THEME.muted
                lbl.TextTransparency = (i - 1) * 0.25
            end
        end
    elseif infoPage.Visible then
        fpsValue.TextColor3 = currentFPS >= 50 and THEME.lime or (currentFPS >= 30 and THEME.yellow or THEME.coral)

        if loopTicks % 2 == 0 then
            local okPing, ping = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if not okPing then
                okPing, ping = pcall(function() return player:GetNetworkPing() * 1000 end)
            end
            if okPing and ping then
                setText(pingValue, math.floor(ping) .. " ms")
                pingValue.TextColor3 = ping < 100 and THEME.lime or (ping < 200 and THEME.yellow or THEME.coral)
            else
                setText(pingValue, "N/A")
            end
        end

        if loopTicks % 5 == 0 then
            refreshServerState()
        end
    end
end

task.spawn(function()
    while screenGui.Parent do
        loopTicks += 1
        refreshVisible()
        task.wait(1)
    end
end)

tween(uiScale, 0.3, {Scale = 1})
playSound(SOUND_OPEN, 0.7)
logLine("Interface loaded", THEME.muted)
task.delay(0.8, function()
    if not screenGui.Parent then return end
    if refreshServerState() then
        notify("Private server detected", THEME.lime)
    else
        notify("You are NOT in a private server!", THEME.coral)
        logLine("Warning: public server", THEME.yellow)
    end
end)

local function freezePhysics(seatPart)
    if seatPart and seatPart:IsA("BasePart") then
        seatPart.AssemblyLinearVelocity = Vector3.zero
        seatPart.AssemblyAngularVelocity = Vector3.zero
    end
end

local function glideExactTime(vehicleModel, seatPart, targetCF, duration)
    local startCF = vehicleModel:GetPivot()
    local startTime = tick()

    while isRunning do
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)
        local currentCF = startCF:Lerp(targetCF, alpha)

        vehicleModel:PivotTo(currentCF + Vector3.new(0, 3, 0))
        freezePhysics(seatPart)

        if alpha >= 1 then break end
        RunService.Heartbeat:Wait()
    end

    if isRunning then
        vehicleModel:PivotTo(targetCF + Vector3.new(0, 3, 0))
        freezePhysics(seatPart)
    end
end

local function guaranteeCheckpoint(vehicleModel, seatPart, targetCF, stopDuration)
    local startTime = tick()
    local lastTouch = 0

    while isRunning and (tick() - startTime) < stopDuration do
        vehicleModel:PivotTo(targetCF + Vector3.new(0, 3, 0))
        freezePhysics(seatPart)

        if tick() - lastTouch > 0.25 then
            lastTouch = tick()
            task.spawn(function()
                local radiusParts = workspace:GetPartBoundsInRadius(targetCF.Position, 45)
                for _, part in ipairs(radiusParts) do
                    local n = part.Name:lower()
                    if part:FindFirstChildWhichIsA("TouchTransmitter") or n:find("check") or n:find("point") or n:find("stop") or n:find("parada") then
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(seatPart, part, 0)
                                task.wait(0.05)
                                firetouchinterest(seatPart, part, 1)
                            end
                        end)
                    end
                end
            end)
        end

        RunService.Heartbeat:Wait()
    end

    freezePhysics(seatPart)
end

local function selectRoute1Automatically()
    local rota1
    local timeout = tick() + 15

    while tick() < timeout and isRunning do
        local screenGuiNew = playerGui:FindFirstChild("ScreenGuiNew")
        if screenGuiNew then
            local frameBusJob = screenGuiNew:FindFirstChild("Frame_BusJob")
            if frameBusJob and frameBusJob.Visible then
                local canvas = frameBusJob:FindFirstChild("Canvas")
                if canvas then
                    local terminal = canvas:FindFirstChild("TerminalChoose")
                    if terminal then
                        local background = terminal:FindFirstChild("Background")
                        if background then
                            local background2 = background:FindFirstChild("Background")
                            if background2 then
                                rota1 = background2:FindFirstChild("ROTA1")
                                if rota1 and rota1.Visible then break end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end

    if not rota1 then return false end

    task.wait(0.2)
    local inset = GuiService:GetGuiInset()
    local position = rota1.AbsolutePosition
    local size = rota1.AbsoluteSize
    local x = position.X + (size.X / 2)
    local y = position.Y + (size.Y / 2) + inset.Y

    VirtualInputManager:SendMouseMoveEvent(x, y, game)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    task.wait(0.4)

    return true
end

local function startFarm()
    task.spawn(function()
        if not selectRoute1Automatically() then
            isRunning = false
            setStatus(false)
            status.Text = "[ ROUTE ERROR ]"
            return
        end

        while isRunning do
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid", 3)

            if not humanoid then
                task.wait(0.5)
                continue
            end

            local seat = humanoid.SeatPart
            if not seat then
                task.wait(0.5)
                continue
            end

            local vehicleModel = seat:FindFirstAncestorOfClass("Model")
            if not vehicleModel then
                task.wait(0.5)
                continue
            end

            for i = 1, #busStops do
                if not isRunning then return end

                updateStop(i)

                local previousIndex = i == 1 and #busStops or i - 1
                local startPosition = busStops[previousIndex].Position
                local targetPosition = busStops[i].Position
                local distance = (startPosition - targetPosition).Magnitude
                local duration = distance / EXACT_SPEED

                glideExactTime(vehicleModel, seat, busStops[i], duration)
                if not isRunning then return end

                guaranteeCheckpoint(vehicleModel, seat, busStops[i], STOP_TIME)
                if not isRunning then return end

                if i == TOTAL_STOPS then
                    raceCount += 1
                    updateCounter()
                    updateStop(13)
                    task.wait(0.3)

                    if isRunning then
                        selectRoute1Automatically()
                        task.wait(0.3)
                    end
                end
            end
        end
    end)
end

toggle.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    setStatus(isRunning)
    if isRunning then startFarm() end
end)

local fpsFrames = 0
local fpsTime = tick()

RunService.RenderStepped:Connect(function()
    fpsFrames += 1
    local now = tick()
    if now - fpsTime >= 0.5 then
        currentFPS = math.floor(fpsFrames / (now - fpsTime) + 0.5)
        fpsFrames = 0
        fpsTime = now
        fpsValue.Text = tostring(currentFPS)
    end
    updateCreatorRainbow()
end)

task.spawn(function()
    local success, role = pcall(function() return player:GetRoleInGroup(GROUP_ID) end)
    if success then roleValue.Text = role else roleValue.Text = "Unknown" end
end)

updateCounter()
setStatus(false)