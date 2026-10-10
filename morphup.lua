-- ========================================================
-- MORPH UP! SUPREME HUB v6.0 (ANTI-AFK & AUTO-DUCK RESPAWN)
-- ========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- Настройки автоматизации
local Settings = {
    DigGraves = false,
    KillZombies = false,
    CandyZone = false,
    AutoFarm = false,
    WalkSpeed = 18,
    AntiAFK = false,
    AutoRespawnDuck = false
}

-- Палитра тем
local Themes = {
    NeonPurple = { Main = Color3.fromRGB(168, 85, 247), Accent = Color3.fromRGB(147, 51, 234), Dark = Color3.fromRGB(12, 10, 20) },
    CyberBlue  = { Main = Color3.fromRGB(59, 130, 246), Accent = Color3.fromRGB(37, 99, 235),  Dark = Color3.fromRGB(8, 14, 26) },
    Emerald    = { Main = Color3.fromRGB(52, 211, 153), Accent = Color3.fromRGB(16, 185, 129), Dark = Color3.fromRGB(6, 20, 15) },
    Crimson    = { Main = Color3.fromRGB(251, 113, 133), Accent = Color3.fromRGB(225, 29, 72), Dark = Color3.fromRGB(20, 8, 12) }
}

local CurrentTheme = Themes.NeonPurple
local CurrentStatus = "Готов к работе (v6.0)"
local DynamicThemeObjects = {}

-- ========================================================
-- ГЛАВНЫЙ ИНТЕРФЕЙС
-- ========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorphUpSupremeHub"
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно (680 x 480)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 480)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -240)
MainFrame.BackgroundColor3 = CurrentTheme.Dark
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 22)
MainCorner.Parent = MainFrame

-- Анимированный неоновый контур
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2.5
MainStroke.Parent = MainFrame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CurrentTheme.Main),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(236, 72, 153)),
    ColorSequenceKeypoint.new(1, CurrentTheme.Accent)
})
StrokeGradient.Parent = MainStroke

task.spawn(function()
    while task.wait(0.02) do
        StrokeGradient.Rotation = (StrokeGradient.Rotation + 1.5) % 360
    end
end)

-- Вращающийся арт на фоне
local BgArt = Instance.new("ImageLabel")
BgArt.Size = UDim2.new(0, 440, 0, 440)
BgArt.Position = UDim2.new(0.5, -220, 0.5, -220)
BgArt.BackgroundTransparency = 1
BgArt.Image = "rbxassetid://6031094678"
BgArt.ImageTransparency = 0.90
BgArt.ImageColor3 = CurrentTheme.Main
BgArt.ScaleType = Enum.ScaleType.Fit
BgArt.ZIndex = 1
BgArt.Parent = MainFrame

task.spawn(function()
    while task.wait(0.02) do
        BgArt.Rotation = (BgArt.Rotation + 0.25) % 360
    end
end)

table.insert(DynamicThemeObjects, function(theme)
    MainFrame.BackgroundColor3 = theme.Dark
    BgArt.ImageColor3 = theme.Main
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.Main),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(236, 72, 153)),
        ColorSequenceKeypoint.new(1, theme.Accent)
    })
end)

-- Верхняя шапка
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 64)
Header.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.ZIndex = 3
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 22)
HeaderCorner.Parent = Header

local HeaderMask = Instance.new("Frame")
HeaderMask.Size = UDim2.new(1, 0, 0, 15)
HeaderMask.Position = UDim2.new(0, 0, 1, -15)
HeaderMask.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
HeaderMask.BackgroundTransparency = 0.2
HeaderMask.BorderSizePixel = 0
HeaderMask.ZIndex = 3
HeaderMask.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Position = UDim2.new(0, 26, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💎  MORPH UP! SUPREME HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Header

local VersionBadge = Instance.new("TextLabel")
VersionBadge.Size = UDim2.new(0, 60, 0, 24)
VersionBadge.Position = UDim2.new(0, 320, 0.5, -12)
VersionBadge.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
VersionBadge.Text = "v6.0"
VersionBadge.TextColor3 = CurrentTheme.Main
VersionBadge.TextSize = 12
VersionBadge.Font = Enum.Font.GothamBold
VersionBadge.ZIndex = 4
VersionBadge.Parent = Header

local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(0, 8)
BadgeCorner.Parent = VersionBadge

table.insert(DynamicThemeObjects, function(theme) VersionBadge.TextColor3 = theme.Main end)

-- Статус-бар
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -32, 0, 38)
StatusBar.Position = UDim2.new(0, 16, 1, -52)
StatusBar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
StatusBar.BackgroundTransparency = 0.3
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 3
StatusBar.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 12)
StatusCorner.Parent = StatusBar

local LiveDot = Instance.new("Frame")
LiveDot.Size = UDim2.new(0, 9, 0, 9)
LiveDot.Position = UDim2.new(0, 15, 0.5, -4.5)
LiveDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
LiveDot.BorderSizePixel = 0
LiveDot.ZIndex = 4
LiveDot.Parent = StatusBar

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = LiveDot

task.spawn(function()
    while task.wait(0.8) do
        TweenService:Create(LiveDot, TweenInfo.new(0.4), {BackgroundTransparency = 0.6}):Play()
        task.wait(0.4)
        TweenService:Create(LiveDot, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    end
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -45, 1, 0)
StatusLabel.Position = UDim2.new(0, 32, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: Готов к работе"
StatusLabel.TextColor3 = Color3.fromRGB(210, 210, 230)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 4
StatusLabel.Parent = StatusBar

-- Боковое меню
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 175, 1, -132)
Sidebar.Position = UDim2.new(0, 16, 0, 74)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 3
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 16)
SidebarCorner.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 9)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingBottom = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local UserCard = Instance.new("Frame")
UserCard.Name = "UserCard"
UserCard.Size = UDim2.new(1, 0, 0, 52)
UserCard.Position = UDim2.new(0, 0, 1, -54)
UserCard.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
UserCard.BorderSizePixel = 0
UserCard.ZIndex = 4
UserCard.Parent = Sidebar

local UserCardCorner = Instance.new("UICorner")
UserCardCorner.CornerRadius = UDim.new(0, 12)
UserCardCorner.Parent = UserCard

local UserText = Instance.new("TextLabel")
UserText.Size = UDim2.new(1, -10, 1, 0)
UserText.Position = UDim2.new(0, 8, 0, 0)
UserText.BackgroundTransparency = 1
UserText.Text = "👤 antoncd2013\n⭐ Pls Follow!"
UserText.TextColor3 = CurrentTheme.Main
UserText.TextSize = 12
UserText.Font = Enum.Font.GothamBold
UserText.TextYAlignment = Enum.TextYAlignment.Center
UserText.ZIndex = 5
UserText.Parent = UserCard

table.insert(DynamicThemeObjects, function(theme) UserText.TextColor3 = theme.Main end)

-- Контейнер страниц
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -215, 1, -132)
PagesContainer.Position = UDim2.new(0, 201, 0, 74)
PagesContainer.BackgroundTransparency = 1
PagesContainer.ZIndex = 3
PagesContainer.Parent = MainFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.Visible = false
    page.ZIndex = 3
    page.Parent = PagesContainer

    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    return page
end

local PageFarm = createPage()
local PageSettings = createPage()
local PageAbout = createPage()

local ActiveTabBtn = nil

local function createTabButton(name, targetPage)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(160, 160, 185)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        if ActiveTabBtn ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if ActiveTabBtn ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 30)}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        PageFarm.Visible = false
        PageSettings.Visible = false
        PageAbout.Visible = false
        
        for _, child in ipairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
                    TextColor3 = Color3.fromRGB(160, 160, 185)
                }):Play()
            end
        end

        ActiveTabBtn = btn
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = CurrentTheme.Main,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()

        targetPage.Visible = true
    end)
    return btn
end

local tab1 = createTabButton("⛏️ Авто-Фарм", PageFarm)
createTabButton("⚙️ Настройки", PageSettings)
createTabButton("ℹ️ Информация", PageAbout)

ActiveTabBtn = tab1
tab1.BackgroundColor3 = CurrentTheme.Main
tab1.TextColor3 = Color3.fromRGB(255, 255, 255)
PageFarm.Visible = true

table.insert(DynamicThemeObjects, function(theme)
    if ActiveTabBtn then ActiveTabBtn.BackgroundColor3 = theme.Main end
end)

local function applyTheme(newTheme)
    CurrentTheme = newTheme
    for _, updateFunc in ipairs(DynamicThemeObjects) do
        updateFunc(CurrentTheme)
    end
end

-- ========================================================
-- ЭЛЕМЕНТЫ УПРАВЛЕНИЯ
-- ========================================================

local function createToggle(parentPage, text, settingKey)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 56)
    button.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = 4
    button.Parent = parentPage

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 14)
    btnCorner.Parent = button

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(35, 35, 52)
    btnStroke.Thickness = 1.2
    btnStroke.Parent = button

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = button

    local statusIndicator = Instance.new("Frame")
    statusIndicator.Size = UDim2.new(0, 50, 0, 26)
    statusIndicator.Position = UDim2.new(1, -60, 0.5, -13)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    statusIndicator.ZIndex = 5
    statusIndicator.Parent = button

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = statusIndicator

    local switchCircle = Instance.new("Frame")
    switchCircle.Size = UDim2.new(0, 22, 0, 22)
    switchCircle.Position = UDim2.new(0, 2, 0.5, -11)
    switchCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
    switchCircle.ZIndex = 6
    switchCircle.Parent = statusIndicator

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = switchCircle

    button.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        
        local targetColor = Settings[settingKey] and CurrentTheme.Main or Color3.fromRGB(26, 26, 40)
        local circlePos = Settings[settingKey] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        local strokeColor = Settings[settingKey] and CurrentTheme.Main or Color3.fromRGB(35, 35, 52)

        TweenService:Create(statusIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(switchCircle, TweenInfo.new(0.2), {Position = circlePos}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = strokeColor}):Play()
    end)

    table.insert(DynamicThemeObjects, function(theme)
        if Settings[settingKey] then
            statusIndicator.BackgroundColor3 = theme.Main
            btnStroke.Color = theme.Main
        end
    end)
end

-- Вкладка Фарма
createToggle(PageFarm, "⛏️ Авто-Копание Могил", "DigGraves")
createToggle(PageFarm, "🧟 Авто-Убийство Зомби", "KillZombies")
createToggle(PageFarm, "🍬 Авто-Стояние в Candy Zone", "CandyZone")
createToggle(PageFarm, "⚡ ВКЛЮЧИТЬ ВСЕ ФУНКЦИИ", "AutoFarm")

-- ========================================================
-- ВКЛАДКА НАСТРОЕК (ЦВЕТА, СКОРОСТЬ, ANTI-AFK, AUTO-DUCK)
-- ========================================================

local ThemeTitle = Instance.new("TextLabel")
ThemeTitle.Size = UDim2.new(1, 0, 0, 28)
ThemeTitle.BackgroundTransparency = 1
ThemeTitle.Text = "🎨 Неоновая тема интерфейса:"
ThemeTitle.TextColor3 = CurrentTheme.Main
ThemeTitle.TextSize = 14
ThemeTitle.Font = Enum.Font.GothamBold
ThemeTitle.TextXAlignment = Enum.TextXAlignment.Left
ThemeTitle.ZIndex = 4
ThemeTitle.Parent = PageSettings

table.insert(DynamicThemeObjects, function(theme) ThemeTitle.TextColor3 = theme.Main end)

local ThemeButtonsFrame = Instance.new("Frame")
ThemeButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
ThemeButtonsFrame.BackgroundTransparency = 1
ThemeButtonsFrame.ZIndex = 4
ThemeButtonsFrame.Parent = PageSettings

local ThemeLayout = Instance.new("UIListLayout")
ThemeLayout.Parent = ThemeButtonsFrame
ThemeLayout.FillDirection = Enum.FillDirection.Horizontal
ThemeLayout.Padding = UDim.new(0, 10)

local function createThemeBtn(color, themeObj)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = ThemeButtonsFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        applyTheme(themeObj)
    end)
end

createThemeBtn(Themes.NeonPurple.Main, Themes.NeonPurple)
createThemeBtn(Themes.CyberBlue.Main, Themes.CyberBlue)
createThemeBtn(Themes.Emerald.Main, Themes.Emerald)
createThemeBtn(Themes.Crimson.Main, Themes.Crimson)

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(1, 0, 0, 28)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "⚡ Скорость WalkSpeed: 18"
SpeedTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
SpeedTitle.TextSize = 14
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextXAlignment = Enum.TextXAlignment.Left
SpeedTitle.ZIndex = 4
SpeedTitle.Parent = PageSettings

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 26)
SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SliderFrame.ZIndex = 4
SliderFrame.Parent = PageSettings

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 10)
SliderCorner.Parent = SliderFrame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.2, 0, 1, 0)
SliderFill.BackgroundColor3 = CurrentTheme.Main
SliderFill.ZIndex = 5
SliderFill.Parent = SliderFrame

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 10)
FillCorner.Parent = SliderFill

table.insert(DynamicThemeObjects, function(theme) SliderFill.BackgroundColor3 = theme.Main end)

local isDraggingSlider = false

local function updateSlider(input)
    local pos = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    local calculatedSpeed = math.floor(10 + (pos * 40))
    Settings.WalkSpeed = calculatedSpeed
    SpeedTitle.Text = "⚡ Скорость WalkSpeed: " .. tostring(calculatedSpeed)
end

SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSlider = true
        updateSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSlider = false
    end
end)

-- Новые тумблеры в Настройках
createToggle(PageSettings, "🛡️ Защита от AFK (Anti-AFK)", "AntiAFK")
createToggle(PageSettings, "🦆 Авто-спавн уткой (Auto-Duck Respawn)", "AutoRespawnDuck")

local infoAbout = Instance.new("TextLabel")
infoAbout.Size = UDim2.new(1, 0, 0, 80)
infoAbout.BackgroundTransparency = 1
infoAbout.Text = "Morph Up! Supreme Hub v6.0\nCreated for antoncd2013\nDon't forget to follow!"
infoAbout.TextColor3 = Color3.fromRGB(200, 200, 220)
infoAbout.TextSize = 13
infoAbout.Font = Enum.Font.GothamMedium
infoAbout.TextXAlignment = Enum.TextXAlignment.Left
infoAbout.ZIndex = 4
infoAbout.Parent = PageAbout

-- ========================================================
-- ПЛАВАЮЩАЯ КНОПКА ОТКРЫТИЯ МЕНЮ
-- ========================================================

local ToggleGuiBtn = Instance.new("ImageButton")
ToggleGuiBtn.Name = "ToggleGuiBtn"
ToggleGuiBtn.Size = UDim2.new(0, 56, 0, 56)
ToggleGuiBtn.Position = UDim2.new(0, 16, 0.5, -28)
ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
ToggleGuiBtn.Image = "rbxassetid://6031094678"
ToggleGuiBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleGuiBtn.ScaleType = Enum.ScaleType.Fit
ToggleGuiBtn.AutoButtonColor = false
ToggleGuiBtn.Parent = ScreenGui

local BtnPadding = Instance.new("UIPadding")
BtnPadding.PaddingTop = UDim.new(0, 10)
BtnPadding.PaddingBottom = UDim.new(0, 10)
BtnPadding.PaddingLeft = UDim.new(0, 10)
BtnPadding.PaddingRight = UDim.new(0, 10)
BtnPadding.Parent = ToggleGuiBtn

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleGuiBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = CurrentTheme.Main
ToggleStroke.Parent = ToggleGuiBtn

table.insert(DynamicThemeObjects, function(theme) ToggleStroke.Color = theme.Main end)

local NormalSize = UDim2.new(0, 680, 0, 480)
local NormalPos = UDim2.new(0.5, -340, 0.5, -240)
local ClosedSize = UDim2.new(0, 0, 0, 0)
local ClosedPos = UDim2.new(0.5, 0, 0.5, 0)

local isMenuOpen = true
local isAnimating = false

ToggleGuiBtn.MouseButton1Click:Connect(function()
    if isAnimating then return end
    isAnimating = true

    TweenService:Create(ToggleGuiBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 48, 0, 48), Position = UDim2.new(0, 20, 0.5, -24)}):Play()
    task.wait(0.1)
    TweenService:Create(ToggleGuiBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0, 16, 0.5, -28)}):Play()

    if isMenuOpen then
        local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = ClosedSize, Position = ClosedPos})
        
        sizeTween:Play()
        sizeTween.Completed:Wait()
        MainFrame.Visible = false
        isMenuOpen = false
    else
        MainFrame.Size = ClosedSize
        MainFrame.Position = ClosedPos
        MainFrame.Visible = true

        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = NormalSize, Position = NormalPos})
        
        sizeTween:Play()
        sizeTween.Completed:Wait()
        isMenuOpen = true
    end

    isAnimating = false
end)

-- ========================================================
-- ФУНКЦИИ ANTI-AFK И AUTO-RESPAWN DUCK
-- ========================================================

-- 1. Anti-AFK обработчик
player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- 2. Auto-Respawn Duck обработчик
local function setupDuckRespawn(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.Died:Connect(function()
            if Settings.AutoRespawnDuck then
                task.spawn(function()
                    player.CharacterAdded:Wait()
                    task.wait(0.6) -- Ожидание загрузки интерфейса после возрождения
                    
                    for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
                        if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                            local text = string.lower(gui.Name .. " " .. (gui:IsA("TextButton") and gui.Text or ""))
                            if text:find("duck") or text:find("утка") or text:find("уточк") then
                                pcall(function()
                                    local pos = gui.AbsolutePosition + (gui.AbsoluteSize / 2)
                                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                                    task.wait(0.05)
                                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
                                end)
                            end
                        end
                    end
                end)
            end
        end)
    end
end

player.CharacterAdded:Connect(setupDuckRespawn)
if player.Character then
    setupDuckRespawn(player.Character)
end

-- ========================================================
-- ЛОГИКА ФАРМА И МИНИ-ИГР
-- ========================================================

local function getCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    return char, hum, root
end

local function updateStatus(text)
    CurrentStatus = text
    StatusLabel.Text = "Статус: " .. text
end

local function safeMoveTo(targetPosition)
    local char, humanoid, rootPart = getCharacter()
    if not rootPart or not humanoid then return end

    humanoid.WalkSpeed = Settings.WalkSpeed

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4
    })

    local success = pcall(function()
        path:ComputeAsync(rootPart.Position, targetPosition)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, wp in ipairs(waypoints) do
            if not (Settings.DigGraves or Settings.KillZombies or Settings.CandyZone or Settings.AutoFarm) then break end

            if wp.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end

            humanoid:MoveTo(wp.Position)

            local reached = false
            local conn = humanoid.MoveToFinished:Connect(function()
                reached = true
            end)

            local startTime = tick()
            while not reached and (tick() - startTime < 2.5) do
                task.wait(0.05)
            end
            if conn then conn:Disconnect() end
        end
    else
        humanoid:MoveTo(targetPosition)
        task.wait(0.8)
    end
end

local function findDigMinigameFrame()
    for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
        if gui:IsA("GuiObject") and gui.Visible then
            local text = ""
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                text = string.upper(gui.Text or "")
            end
            if text:find("DIG") or text:find("/12") then
                return gui.Parent
            end
        end
    end
    return nil
end

local function solveDigMinigame()
    local startTime = tick()
    
    while tick() - startTime < 8 do
        local minigameFrame = findDigMinigameFrame()
        if not minigameFrame then
            task.wait(0.05)
            minigameFrame = findDigMinigameFrame()
            if not minigameFrame then break end
        end

        local keyPressed = false

        for _, obj in ipairs(minigameFrame:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and #obj.Text == 1 and obj.Text:match("[A-Z]") then
                local letter = obj.Text
                local parent = obj.Parent
                local isHighlighted = false
                
                if parent then
                    for _, child in ipairs(parent:GetChildren()) do
                        if child:IsA("Frame") and child.Visible then
                            if child.Size.Y.Offset <= 8 or child.Position.Y.Scale > 0.7 then
                                isHighlighted = true
                                break
                            end
                        end
                    end
                    if parent:IsA("GuiObject") and parent.BackgroundColor3.R > 0.5 then
                        isHighlighted = true
                    end
                end

                if isHighlighted then
                    local keyCode = Enum.KeyCode[letter]
                    if keyCode then
                        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                        task.wait(0.02)
                        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                        keyPressed = true
                        task.wait(0.06)
                        break
                    end
                end
            end
        end

        if not keyPressed then
            task.wait(0.02)
        end
    end
end

local function farmGraves()
    local _, humanoid, rootPart = getCharacter()
    if not rootPart or not humanoid then return end

    local gravesList = {}

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not (Settings.DigGraves or Settings.AutoFarm) then break end

        local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt and prompt.Enabled then
            local nameLower = string.lower(obj.Name)
            local parentName = obj.Parent and string.lower(obj.Parent.Name) or ""
            local actionText = string.lower(prompt.ActionText or "")
            local objectText = string.lower(prompt.ObjectText or "")

            if nameLower:find("grave") or parentName:find("grave") or actionText:find("dig") or actionText:find("копать") or objectText:find("grave") or objectText:find("могил") then
                local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    local dist = (rootPart.Position - targetPart.Position).Magnitude
                    table.insert(gravesList, {Part = targetPart, Prompt = prompt, Distance = dist})
                end
            end
        end
    end

    table.sort(gravesList, function(a, b) return a.Distance < b.Distance end)

    for _, grave in ipairs(gravesList) do
        if not (Settings.DigGraves or Settings.AutoFarm) then break end
        if grave.Prompt.Parent and grave.Prompt.Enabled then
            updateStatus("Мгновенно летим к могиле...")
            safeMoveTo(grave.Part.Position)

            humanoid:MoveTo(rootPart.Position)
            task.wait(0.05)

            updateStatus("Копаем...")
            pcall(function()
                fireproximityprompt(grave.Prompt)
            end)

            task.wait(0.1)

            updateStatus("Решаем мини-игру...")
            solveDigMinigame()

            task.wait(0.15)
        end
    end
end

local function killZombies()
    local char, humanoid, rootPart = getCharacter()
    local zombiesFolder = Workspace:FindFirstChild("Zombies") or Workspace

    for _, npc in ipairs(zombiesFolder:GetChildren()) do
        if not (Settings.KillZombies or Settings.AutoFarm) then break end

        local zHumanoid = npc:FindFirstChildOfClass("Humanoid")
        local zRoot = npc:FindFirstChild("HumanoidRootPart")

        if zHumanoid and zRoot and zHumanoid.Health > 0 and (npc.Name:find("Zombie") or string.lower(npc.Name):find("zombie")) then
            while zHumanoid.Health > 0 and humanoid.Health > 0 and (Settings.KillZombies or Settings.AutoFarm) do
                updateStatus("Преследуем зомби...")
                safeMoveTo(zRoot.Position)

                local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    humanoid:EquipTool(tool)
                    tool:Activate()
                end

                task.wait(0.15)
                if not zRoot.Parent then break end
            end
        end
    end
end

local function goToCandyZone()
    local _, _, rootPart = getCharacter()
    if not rootPart then return end

    local candyZonePart = nil

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if name == "candyzone" or name == "candy zone" or (name:find("candy") and (name:find("zone") or name:find("area"))) then
                candyZonePart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if candyZonePart then break end
            end
        end
    end

    if candyZonePart then
        local currentPosFlat = Vector3.new(rootPart.Position.X, 0, rootPart.Position.Z)
        local targetPosFlat = Vector3.new(candyZonePart.Position.X, 0, candyZonePart.Position.Z)
        local distance = (currentPosFlat - targetPosFlat).Magnitude

        if distance > 8 then
            updateStatus("Идем в Candy Zone...")
            safeMoveTo(candyZonePart.Position)
        else
            updateStatus("Находимся в Candy Zone 🍬")
        end
    else
        updateStatus("Candy Zone не найдена!")
    end
end

-- Главный цикл
task.spawn(function()
    print("[Supreme Hub v6.0] Запущено для antoncd2013 с Anti-AFK и Auto-Duck!")
    while task.wait(0.1) do
        local _, humanoid, _ = getCharacter()
        if not humanoid or humanoid.Health <= 0 then continue end

        if not (Settings.DigGraves or Settings.KillZombies or Settings.CandyZone or Settings.AutoFarm) then
            updateStatus("Ожидание действий...")
        end

        if Settings.KillZombies or Settings.AutoFarm then killZombies() end
        if Settings.DigGraves or Settings.AutoFarm then farmGraves() end
        if Settings.CandyZone or Settings.AutoFarm then goToCandyZone() end
    end
end)
