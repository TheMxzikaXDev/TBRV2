local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GROUP_ID = 1069446470
local KEY = "TBR"

local authorized = false

local authGui = Instance.new("ScreenGui")
authGui.Name = "HubSkriptyAuth"
authGui.ResetOnSpawn = false
authGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
authGui.Parent = playerGui

local authFrame = Instance.new("Frame")
authFrame.Size = UDim2.new(0, 340, 0, 205)
authFrame.Position = UDim2.new(0.5, -170, 0.5, -102)
authFrame.BackgroundColor3 = Color3.fromRGB(14, 16, 23)
authFrame.BorderSizePixel = 0
authFrame.Parent = authGui

local authCorner = Instance.new("UICorner")
authCorner.CornerRadius = UDim.new(0, 16)
authCorner.Parent = authFrame

local authStroke = Instance.new("UIStroke")
authStroke.Color = Color3.fromRGB(65, 70, 90)
authStroke.Thickness = 1.5
authStroke.Parent = authFrame

local authTitle = Instance.new("TextLabel")
authTitle.Size = UDim2.new(1, -30, 0, 40)
authTitle.Position = UDim2.new(0, 15, 0, 12)
authTitle.BackgroundTransparency = 1
authTitle.Text = "🦊 HUB Skripty X FoX Studios"
authTitle.TextColor3 = Color3.new(1, 1, 1)
authTitle.TextSize = 17
authTitle.Font = Enum.Font.GothamBold
authTitle.Parent = authFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 44)
keyInput.Position = UDim2.new(0, 15, 0, 62)
keyInput.BackgroundColor3 = Color3.fromRGB(24, 27, 37)
keyInput.PlaceholderText = "Digite a Key"
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

local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(1, -30, 0, 44)
verifyButton.Position = UDim2.new(0, 15, 0, 114)
verifyButton.BackgroundColor3 = Color3.fromRGB(45, 155, 85)
verifyButton.Text = "VERIFICAR"
verifyButton.TextColor3 = Color3.new(1, 1, 1)
verifyButton.TextSize = 15
verifyButton.Font = Enum.Font.GothamBold
verifyButton.AutoButtonColor = false
verifyButton.Parent = authFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 10)
verifyCorner.Parent = verifyButton

local authStatus = Instance.new("TextLabel")
authStatus.Size = UDim2.new(1, -30, 0, 24)
authStatus.Position = UDim2.new(0, 15, 1, -30)
authStatus.BackgroundTransparency = 1
authStatus.Text = ""
authStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
authStatus.TextSize = 12
authStatus.Font = Enum.Font.GothamBold
authStatus.Parent = authFrame

local function denyAccess(message)
    authStatus.Text = message
    authStatus.TextColor3 = Color3.fromRGB(255, 80, 80)

    task.wait(0.5)

    player:Kick(
        "ACESSO NEGADO\n\n" ..
        "Você tentou executar o HUB Skripty X FoX Studios sem autorização.\n\n" ..
        "TENTOU EXECUTAR O HUB SKRIPTY X FOX STUDIOS"
    )
end

local function verifyAccess()
    if keyInput.Text ~= KEY then
        denyAccess("KEY INCORRETA")
        return
    end

    local success, inGroup = pcall(function()
        return player:IsInGroup(GROUP_ID)
    end)

    if not success or not inGroup then
        denyAccess("VOCÊ NÃO ESTÁ NO GRUPO")
        return
    end

    authorized = true
    authStatus.Text = "AUTORIZADO"
    authStatus.TextColor3 = Color3.fromRGB(80, 220, 110)

    task.wait(0.4)
    authGui:Destroy()
end

verifyButton.MouseButton1Click:Connect(verifyAccess)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyAccess()
    end
end)

repeat
    task.wait()
until authorized

local function antiAFK()
    VirtualUser:Button2Down(
        Vector2.new(0, 0),
        workspace.CurrentCamera.CFrame
    )

    task.wait(0.15)

    VirtualUser:Button2Up(
        Vector2.new(0, 0),
        workspace.CurrentCamera.CFrame
    )

    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:Move(Vector3.zero, true)
    end
end

player.Idled:Connect(function()
    antiAFK()
end)

task.spawn(function()
    while player.Parent do
        task.wait(60)
        antiAFK()
    end
end)

task.spawn(function()
    while player.Parent do
        task.wait(1200)
        antiAFK()
        task.wait(1)
        antiAFK()
    end
end)

local TOTAL_LAP_TIME = 150
local STOP_TIME = 2
local TOTAL_STOPS = 13
local TRAVEL_TIME = TOTAL_LAP_TIME - (TOTAL_STOPS * STOP_TIME)

local busStops = {
    CFrame.new(1502.82935, 5.91479492, 352.914917, -0.173624277, 0, -0.984811902, 0, 1, 0, 0.984811902, 0, -0.173624277),
    CFrame.new(-195.336502, 6.63656616, 736.518311, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07),
    CFrame.new(-422.161804, 6.38656616, 633.011475, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    CFrame.new(62.9754791, 6.34698486, 2097.11206, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    CFrame.new(2101.93213, 5.9447937, 3633.99829, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07),
    CFrame.new(4123.021, 5.93710327, 3634.86743, 0, 0, 1, 0, 1, 0, -1, 0, 0),
    CFrame.new(5579.9668, 5.93722534, 3634.61841, 0, 0, 1, 0, 1, 0, -1, 0, 0),
    CFrame.new(6411.79102, 14.3038025, 1891.05737, -1, 0, 0, 0, 0.99995327, -0.00966795254, -0, -0.00966795254, -0.99995327),
    CFrame.new(17031.2637, 73.9154663, 475.421143, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07),
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

if oldGui then
    oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BusFarmGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 280)
main.Position = UDim2.new(0.5, -190, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 65, 85)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(1, 0, 0, 3)
topGlow.BackgroundColor3 = Color3.fromRGB(100, 70, 255)
topGlow.BorderSizePixel = 0
topGlow.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = Color3.fromRGB(16, 18, 27)
header.BorderSizePixel = 0
header.Parent = main

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -100, 1, 0)
headerTitle.Position = UDim2.new(0, 15, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "🦊 HUB Skripty X FoX Studios"
headerTitle.TextColor3 = Color3.new(1, 1, 1)
headerTitle.TextSize = 15
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.TextScaled = false
headerTitle.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 31, 0, 28)
minimize.Position = UDim2.new(1, -69, 0, 12)
minimize.BackgroundColor3 = Color3.fromRGB(32, 35, 47)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 17
minimize.Font = Enum.Font.GothamBold
minimize.AutoButtonColor = false
minimize.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimize

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 31, 0, 28)
close.Position = UDim2.new(1, -35, 0, 12)
close.BackgroundColor3 = Color3.fromRGB(150, 45, 55)
close.Text = "×"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = false
close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

local side = Instance.new("Frame")
side.Size = UDim2.new(0, 102, 1, -52)
side.Position = UDim2.new(0, 0, 0, 52)
side.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
side.BorderSizePixel = 0
side.Parent = main

local farmTab = Instance.new("TextButton")
farmTab.Size = UDim2.new(1, -14, 0, 44)
farmTab.Position = UDim2.new(0, 7, 0, 15)
farmTab.BackgroundColor3 = Color3.fromRGB(70, 55, 170)
farmTab.Text = "🚍  FARM"
farmTab.TextColor3 = Color3.new(1, 1, 1)
farmTab.TextSize = 12
farmTab.Font = Enum.Font.GothamBold
farmTab.AutoButtonColor = false
farmTab.Parent = side

local farmTabCorner = Instance.new("UICorner")
farmTabCorner.CornerRadius = UDim.new(0, 10)
farmTabCorner.Parent = farmTab

local infoTab = Instance.new("TextButton")
infoTab.Size = UDim2.new(1, -14, 0, 44)
infoTab.Position = UDim2.new(0, 7, 0, 67)
infoTab.BackgroundColor3 = Color3.fromRGB(25, 28, 39)
infoTab.Text = "ℹ  INFO"
infoTab.TextColor3 = Color3.fromRGB(170, 175, 190)
infoTab.TextSize = 12
infoTab.Font = Enum.Font.GothamBold
infoTab.AutoButtonColor = false
infoTab.Parent = side

local infoTabCorner = Instance.new("UICorner")
infoTabCorner.CornerRadius = UDim.new(0, 10)
infoTabCorner.Parent = infoTab

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, -10, 0, 20)
versionLabel.Position = UDim2.new(0, 5, 1, -30)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v4.0"
versionLabel.TextColor3 = Color3.fromRGB(90, 95, 110)
versionLabel.TextSize = 10
versionLabel.Font = Enum.Font.Gotham
versionLabel.Parent = side

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -102, 1, -52)
content.Position = UDim2.new(0, 102, 0, 52)
content.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
content.BorderSizePixel = 0
content.Parent = main

local farmPage = Instance.new("Frame")
farmPage.Size = UDim2.new(1, -20, 1, -16)
farmPage.Position = UDim2.new(0, 10, 0, 8)
farmPage.BackgroundTransparency = 1
farmPage.Parent = content

local farmTitle = Instance.new("TextLabel")
farmTitle.Size = UDim2.new(1, 0, 0, 27)
farmTitle.BackgroundTransparency = 1
farmTitle.Text = "PAINEL DE FARM"
farmTitle.TextColor3 = Color3.new(1, 1, 1)
farmTitle.TextSize = 15
farmTitle.Font = Enum.Font.GothamBold
farmTitle.TextXAlignment = Enum.TextXAlignment.Left
farmTitle.Parent = farmPage

local statusCard = Instance.new("Frame")
statusCard.Size = UDim2.new(1, 0, 0, 47)
statusCard.Position = UDim2.new(0, 0, 0, 32)
statusCard.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
statusCard.BorderSizePixel = 0
statusCard.Parent = farmPage

local statusCardCorner = Instance.new("UICorner")
statusCardCorner.CornerRadius = UDim.new(0, 10)
statusCardCorner.Parent = statusCard

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -18, 1, 0)
status.Position = UDim2.new(0, 9, 0, 0)
status.BackgroundTransparency = 1
status.Text = "●  FARM PARADO"
status.TextColor3 = Color3.fromRGB(255, 80, 90)
status.TextSize = 13
status.Font = Enum.Font.GothamBold
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = statusCard

local raceCard = Instance.new("Frame")
raceCard.Size = UDim2.new(0.48, -3, 0, 61)
raceCard.Position = UDim2.new(0, 0, 0, 87)
raceCard.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
raceCard.BorderSizePixel = 0
raceCard.Parent = farmPage

local raceCardCorner = Instance.new("UICorner")
raceCardCorner.CornerRadius = UDim.new(0, 10)
raceCardCorner.Parent = raceCard

local raceName = Instance.new("TextLabel")
raceName.Size = UDim2.new(1, -14, 0, 19)
raceName.Position = UDim2.new(0, 7, 0, 6)
raceName.BackgroundTransparency = 1
raceName.Text = "CORRIDAS"
raceName.TextColor3 = Color3.fromRGB(135, 140, 155)
raceName.TextSize = 10
raceName.Font = Enum.Font.GothamBold
raceName.TextXAlignment = Enum.TextXAlignment.Left
raceName.Parent = raceCard

local counter = Instance.new("TextLabel")
counter.Size = UDim2.new(1, -14, 0, 28)
counter.Position = UDim2.new(0, 7, 0, 25)
counter.BackgroundTransparency = 1
counter.Text = "0"
counter.TextColor3 = Color3.new(1, 1, 1)
counter.TextSize = 20
counter.Font = Enum.Font.GothamBold
counter.TextXAlignment = Enum.TextXAlignment.Left
counter.Parent = raceCard

local stopCard = Instance.new("Frame")
stopCard.Size = UDim2.new(0.48, -3, 0, 61)
stopCard.Position = UDim2.new(0.52, 3, 0, 87)
stopCard.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
stopCard.BorderSizePixel = 0
stopCard.Parent = farmPage

local stopCardCorner = Instance.new("UICorner")
stopCardCorner.CornerRadius = UDim.new(0, 10)
stopCardCorner.Parent = stopCard

local stopName = Instance.new("TextLabel")
stopName.Size = UDim2.new(1, -14, 0, 19)
stopName.Position = UDim2.new(0, 7, 0, 6)
stopName.BackgroundTransparency = 1
stopName.Text = "PARADA"
stopName.TextColor3 = Color3.fromRGB(135, 140, 155)
stopName.TextSize = 10
stopName.Font = Enum.Font.GothamBold
stopName.TextXAlignment = Enum.TextXAlignment.Left
stopName.Parent = stopCard

local stopCounter = Instance.new("TextLabel")
stopCounter.Size = UDim2.new(1, -14, 0, 28)
stopCounter.Position = UDim2.new(0, 7, 0, 25)
stopCounter.BackgroundTransparency = 1
stopCounter.Text = "0 / 13"
stopCounter.TextColor3 = Color3.new(1, 1, 1)
stopCounter.TextSize = 20
stopCounter.Font = Enum.Font.GothamBold
stopCounter.TextXAlignment = Enum.TextXAlignment.Left
stopCounter.Parent = stopCard

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, 0, 0, 48)
toggle.Position = UDim2.new(0, 0, 0, 155)
toggle.BackgroundColor3 = Color3.fromRGB(55, 170, 90)
toggle.Text = "▶  INICIAR FARM"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 13
toggle.Font = Enum.Font.GothamBold
toggle.AutoButtonColor = false
toggle.Parent = farmPage

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggle

local infoPage = Instance.new("Frame")
infoPage.Size = UDim2.new(1, -20, 1, -16)
infoPage.Position = UDim2.new(0, 10, 0, 8)
infoPage.BackgroundTransparency = 1
infoPage.Visible = false
infoPage.Parent = content

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, 0, 0, 27)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "INFORMAÇÕES"
infoTitle.TextColor3 = Color3.new(1, 1, 1)
infoTitle.TextSize = 15
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.Parent = infoPage

local function createInfoCard(parent, position, label, value)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 41)
    card.Position = position
    card.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    card.BorderSizePixel = 0
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = card

    local labelObject = Instance.new("TextLabel")
    labelObject.Size = UDim2.new(0.44, 0, 1, 0)
    labelObject.Position = UDim2.new(0, 10, 0, 0)
    labelObject.BackgroundTransparency = 1
    labelObject.Text = label
    labelObject.TextColor3 = Color3.fromRGB(135, 140, 155)
    labelObject.TextSize = 10
    labelObject.Font = Enum.Font.GothamBold
    labelObject.TextXAlignment = Enum.TextXAlignment.Left
    labelObject.Parent = card

    local valueObject = Instance.new("TextLabel")
    valueObject.Size = UDim2.new(0.56, -12, 1, 0)
    valueObject.Position = UDim2.new(0.44, 2, 0, 0)
    valueObject.BackgroundTransparency = 1
    valueObject.Text = value
    valueObject.TextColor3 = Color3.new(1, 1, 1)
    valueObject.TextSize = 10
    valueObject.Font = Enum.Font.GothamBold
    valueObject.TextXAlignment = Enum.TextXAlignment.Right
    valueObject.TextTruncate = Enum.TextTruncate.AtEnd
    valueObject.Parent = card

    return valueObject
end

local usernameValue = createInfoCard(
    infoPage,
    UDim2.new(0, 0, 0, 35),
    "👤  USUÁRIO",
    player.Name
)

local roleValue = createInfoCard(
    infoPage,
    UDim2.new(0, 0, 0, 82),
    "🛡️  CARGO",
    "Carregando..."
)

local fpsValue = createInfoCard(
    infoPage,
    UDim2.new(0, 0, 0, 129),
    "⚡  FPS",
    "0 FPS"
)

local creatorCard = Instance.new("Frame")
creatorCard.Size = UDim2.new(1, 0, 0, 48)
creatorCard.Position = UDim2.new(0, 0, 0, 176)
creatorCard.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
creatorCard.BorderSizePixel = 0
creatorCard.Parent = infoPage

local creatorCorner = Instance.new("UICorner")
creatorCorner.CornerRadius = UDim.new(0, 10)
creatorCorner.Parent = creatorCard

local creatorLabel = Instance.new("TextLabel")
creatorLabel.Size = UDim2.new(0.38, 0, 1, 0)
creatorLabel.Position = UDim2.new(0, 10, 0, 0)
creatorLabel.BackgroundTransparency = 1
creatorLabel.Text = "👑  CRIADOR"
creatorLabel.TextColor3 = Color3.fromRGB(135, 140, 155)
creatorLabel.TextSize = 10
creatorLabel.Font = Enum.Font.GothamBold
creatorLabel.TextXAlignment = Enum.TextXAlignment.Left
creatorLabel.Parent = creatorCard

local creatorName = Instance.new("TextLabel")
creatorName.Size = UDim2.new(0.62, -12, 1, 0)
creatorName.Position = UDim2.new(0.38, 2, 0, 0)
creatorName.BackgroundTransparency = 1
creatorName.Text = "The MxzikaX Dev"
creatorName.TextSize = 11
creatorName.Font = Enum.Font.GothamBold
creatorName.TextXAlignment = Enum.TextXAlignment.Right
creatorName.TextScaled = false
creatorName.Parent = creatorCard

local function updateCreatorRainbow()
    local hue = (tick() % 5) / 5
    creatorName.TextColor3 = Color3.fromHSV(hue, 0.85, 1)
end

local function setStatus(running)
    if running then
        toggle.Text = "■  PARAR FARM"
        toggle.BackgroundColor3 = Color3.fromRGB(170, 50, 60)
        status.Text = "●  FARM ATIVO"
        status.TextColor3 = Color3.fromRGB(80, 230, 120)
    else
        toggle.Text = "▶  INICIAR FARM"
        toggle.BackgroundColor3 = Color3.fromRGB(55, 170, 90)
        status.Text = "●  FARM PARADO"
        status.TextColor3 = Color3.fromRGB(255, 80, 90)
        currentStop = 0
        stopCounter.Text = "0 / 13"
    end
end

local function updateCounter()
    counter.Text = tostring(raceCount)
end

local function updateStop(value)
    currentStop = value
    stopCounter.Text = tostring(currentStop) .. " / 13"
end

local dragging = false
local dragStart
local startPosition

local function beginDrag(input)
    dragging = true
    dragStart = input.Position
    startPosition = main.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

header.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

local restore = Instance.new("TextButton")
restore.Size = UDim2.new(0, 145, 0, 42)
restore.Position = main.Position
restore.BackgroundColor3 = Color3.fromRGB(12, 14, 21)
restore.Text = "🦊  HUB Skripty"
restore.TextColor3 = Color3.new(1, 1, 1)
restore.TextSize = 12
restore.Font = Enum.Font.GothamBold
restore.AutoButtonColor = false
restore.Visible = false
restore.Parent = screenGui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 11)
restoreCorner.Parent = restore

local restoreStroke = Instance.new("UIStroke")
restoreStroke.Color = Color3.fromRGB(65, 70, 90)
restoreStroke.Thickness = 1.5
restoreStroke.Parent = restore

minimize.MouseButton1Click:Connect(function()
    restore.Position = main.Position
    main.Visible = false
    restore.Visible = true
end)

restore.MouseButton1Click:Connect(function()
    main.Visible = true
    restore.Visible = false
end)

close.MouseButton1Click:Connect(function()
    isRunning = false
    screenGui:Destroy()
end)

farmTab.MouseButton1Click:Connect(function()
    farmPage.Visible = true
    infoPage.Visible = false

    farmTab.BackgroundColor3 = Color3.fromRGB(70, 55, 170)
    farmTab.TextColor3 = Color3.new(1, 1, 1)

    infoTab.BackgroundColor3 = Color3.fromRGB(25, 28, 39)
    infoTab.TextColor3 = Color3.fromRGB(170, 175, 190)
end)

infoTab.MouseButton1Click:Connect(function()
    farmPage.Visible = false
    infoPage.Visible = true

    infoTab.BackgroundColor3 = Color3.fromRGB(70, 55, 170)
    infoTab.TextColor3 = Color3.new(1, 1, 1)

    farmTab.BackgroundColor3 = Color3.fromRGB(25, 28, 39)
    farmTab.TextColor3 = Color3.fromRGB(170, 175, 190)
end)

local function buttonEffect(button, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = normalColor:Lerp(Color3.new(1, 1, 1), 0.08)}
        ):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = normalColor}
        ):Play()
    end)
end

buttonEffect(toggle, Color3.fromRGB(55, 170, 90))
buttonEffect(close, Color3.fromRGB(150, 45, 55))
buttonEffect(minimize, Color3.fromRGB(32, 35, 47))

local function freezePhysics(vehicleModel)
    for _, obj in ipairs(vehicleModel:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.AssemblyLinearVelocity = Vector3.zero
            obj.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function glideExactTime(vehicleModel, targetCF, duration)
    local startCF = vehicleModel:GetPivot()
    local startTime = tick()

    while isRunning do
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)
        local currentCF = startCF:Lerp(targetCF, alpha)

        vehicleModel:PivotTo(currentCF + Vector3.new(0, 3, 0))
        freezePhysics(vehicleModel)

        if alpha >= 1 then
            break
        end

        RunService.Heartbeat:Wait()
    end

    if isRunning then
        vehicleModel:PivotTo(targetCF + Vector3.new(0, 3, 0))
        freezePhysics(vehicleModel)
    end
end

local function guaranteeCheckpoint(vehicleModel, targetCF)
    local startCF = targetCF * CFrame.new(0, 1, 8)
    local endCF = targetCF * CFrame.new(0, 1, -2)
    local startTime = tick()

    vehicleModel:PivotTo(startCF + Vector3.new(0, 3, 0))
    freezePhysics(vehicleModel)

    while isRunning do
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / STOP_TIME, 0, 1)
        local currentCF = startCF:Lerp(endCF, alpha)

        vehicleModel:PivotTo(currentCF + Vector3.new(0, 3, 0))
        freezePhysics(vehicleModel)

        if alpha >= 1 then
            break
        end

        RunService.Heartbeat:Wait()
    end

    if isRunning then
        vehicleModel:PivotTo(targetCF + Vector3.new(0, 3, 0))
        freezePhysics(vehicleModel)
    end
end

local function selectRoute1Automatically()
    local rota1
    local timeout = tick() + 20

    while tick() < timeout and isRunning do
        local screenGuiNew = playerGui:FindFirstChild("ScreenGuiNew")

        if screenGuiNew then
            local frameBusJob = screenGuiNew:FindFirstChild("Frame_BusJob")

            if frameBusJob then
                local canvas = frameBusJob:FindFirstChild("Canvas")

                if canvas then
                    local terminal = canvas:FindFirstChild("TerminalChoose")

                    if terminal then
                        local background = terminal:FindFirstChild("Background")

                        if background then
                            local background2 = background:FindFirstChild("Background")

                            if background2 then
                                rota1 = background2:FindFirstChild("ROTA1")

                                if rota1 then
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.1)
    end

    if not rota1 then
        warn("[BusFarm] ROTA1 não encontrada")
        return false
    end

    local position = rota1.AbsolutePosition
    local size = rota1.AbsoluteSize
    local x = position.X + size.X / 2
    local y = position.Y + size.Y / 2 + 25

    VirtualInputManager:SendMouseMoveEvent(x, y, game)

    task.wait(0.25)

    VirtualInputManager:SendMouseButtonEvent(
        x,
        y,
        0,
        true,
        game,
        0
    )

    task.wait(0.15)

    VirtualInputManager:SendMouseButtonEvent(
        x,
        y,
        0,
        false,
        game,
        0
    )

    task.wait(1)

    return true
end

local function startFarm()
    task.spawn(function()
        if not selectRoute1Automatically() then
            isRunning = false
            setStatus(false)
            return
        end

        while isRunning do
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if not humanoid then
                task.wait(1)
                continue
            end

            local seat = humanoid.SeatPart

            if not seat then
                task.wait(1)
                continue
            end

            local vehicleModel = seat:FindFirstAncestorOfClass("Model")

            if not vehicleModel then
                task.wait(1)
                continue
            end

            for i = 1, #busStops do
                if not isRunning then
                    return
                end

                updateStop(i)

                local previousIndex = i == 1 and #busStops or i - 1
                local startPosition = busStops[previousIndex].Position
                local targetPosition = busStops[i].Position
                local distance = (startPosition - targetPosition).Magnitude
                local duration = distance / EXACT_SPEED

                glideExactTime(vehicleModel, busStops[i], duration)

                if not isRunning then
                    return
                end

                guaranteeCheckpoint(vehicleModel, busStops[i])

                if not isRunning then
                    return
                end

                if i == TOTAL_STOPS then
                    raceCount += 1
                    updateCounter()
                    updateStop(13)

                    task.wait(1)

                    if isRunning then
                        selectRoute1Automatically()
                        task.wait(1)
                    end
                end
            end
        end
    end)
end

toggle.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    setStatus(isRunning)

    if isRunning then
        startFarm()
    end
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

        fpsValue.Text = tostring(currentFPS) .. " FPS"
    end

    updateCreatorRainbow()
end)

task.spawn(function()
    local success, role = pcall(function()
        return player:GetRoleInGroup(GROUP_ID)
    end)

    if success then
        roleValue.Text = role
    else
        roleValue.Text = "Desconhecido"
    end
end)

updateCounter()
setStatus(false)