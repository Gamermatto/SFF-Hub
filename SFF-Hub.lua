local plrs = game:GetService("Players")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local httpService = game:GetService("HttpService")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local camera = game:GetService("Workspace").CurrentCamera
local MainLoop
local TracerGui
local CurrentTarget = nil
local ScriptEnabled = true

-- > CONFIGURAZIONE < --
local Config = {
    SilentAim = false,
    Aimbot = false,
    AimSpeed = 20, -- Valore di default per la velocità dell'Aimbot
    ESP = false,
    Lines = false,
    TeamCheck = false,
    VisualTeamCheck = false,
    WallCheck = true,
    FOV = 100,
    ShowFOV = false,
    Accuracy = 100,
    TargetPart = "Closest",
    Prediction = false,
    PredictionAmount = 0.165,
    AimOffset = 0,
    MenuKey = Enum.KeyCode.Insert
}

-- > GUI MENU < --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenu"
-- Tenta di mettere la GUI in CoreGui per sicurezza, altrimenti PlayerGui
if pcall(function() ScreenGui.Parent = coreGui end) then
    ScreenGui.Parent = coreGui
else
    ScreenGui.Parent = plr:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Rende il menu trascinabile
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 90)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top Bar (Navigazione)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local TopBarGradient = Instance.new("UIGradient")
TopBarGradient.Rotation = 90
TopBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 55)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 20, 30))
}
TopBarGradient.Parent = TopBar

-- Fix per gli angoli inferiori della TopBar (per non arrotondarli)
local TopBarCover = Instance.new("Frame")
TopBarCover.Size = UDim2.new(1, 0, 0, 10)
TopBarCover.Position = UDim2.new(0, 0, 1, -10)
TopBarCover.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBarCover.BorderSizePixel = 0
TopBarCover.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "Unknow <font color=\"rgb(80, 120, 250)\">HUB</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local NavContainer = Instance.new("Frame")
NavContainer.Size = UDim2.new(0, 300, 1, 0)
NavContainer.Position = UDim2.new(1, -310, 0, 0)
NavContainer.BackgroundTransparency = 1
NavContainer.Parent = TopBar

local NavLayout = Instance.new("UIListLayout")
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
NavLayout.Padding = UDim.new(0, 5)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Parent = NavContainer

local NavInfo = Instance.new("TextButton")
NavInfo.Size = UDim2.new(0, 70, 0, 30)
NavInfo.Text = "Info"
NavInfo.Font = Enum.Font.GothamSemibold
NavInfo.TextColor3 = Color3.new(1, 1, 1)
NavInfo.BackgroundColor3 = Color3.fromRGB(80, 120, 250) -- Active by default
NavInfo.BorderSizePixel = 0
NavInfo.LayoutOrder = 0
NavInfo.Parent = NavContainer

local NavInfoCorner = Instance.new("UICorner")
NavInfoCorner.CornerRadius = UDim.new(1, 0)
NavInfoCorner.Parent = NavInfo

local NavAim = Instance.new("TextButton")
NavAim.Size = UDim2.new(0, 70, 0, 30)
NavAim.Text = "Aim"
NavAim.Font = Enum.Font.GothamSemibold
NavAim.TextColor3 = Color3.new(0.7, 0.7, 0.7)
NavAim.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NavAim.BorderSizePixel = 0
NavAim.LayoutOrder = 1
NavAim.Parent = NavContainer

local NavAimCorner = Instance.new("UICorner")
NavAimCorner.CornerRadius = UDim.new(1, 0)
NavAimCorner.Parent = NavAim

local NavVisual = Instance.new("TextButton")
NavVisual.Size = UDim2.new(0, 70, 0, 30)
NavVisual.Text = "Visual"
NavVisual.Font = Enum.Font.GothamSemibold
NavVisual.TextColor3 = Color3.new(0.7, 0.7, 0.7)
NavVisual.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NavVisual.BorderSizePixel = 0
NavVisual.LayoutOrder = 2
NavVisual.Parent = NavContainer

local NavVisualCorner = Instance.new("UICorner")
NavVisualCorner.CornerRadius = UDim.new(1, 0)
NavVisualCorner.Parent = NavVisual

local NavSettings = Instance.new("TextButton")
NavSettings.Size = UDim2.new(0, 70, 0, 30)
NavSettings.Text = "Settings"
NavSettings.Font = Enum.Font.GothamSemibold
NavSettings.TextColor3 = Color3.new(0.7, 0.7, 0.7)
NavSettings.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NavSettings.BorderSizePixel = 0
NavSettings.LayoutOrder = 3
NavSettings.Parent = NavContainer

local NavSettingsCorner = Instance.new("UICorner")
NavSettingsCorner.CornerRadius = UDim.new(1, 0)
NavSettingsCorner.Parent = NavSettings

-- Content Area (Destra)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -65)
Content.Position = UDim2.new(0, 15, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Pagine
local PageInfo = Instance.new("Frame")
PageInfo.Size = UDim2.new(1, 0, 1, 0)
PageInfo.BackgroundTransparency = 1
PageInfo.Visible = true -- Default
PageInfo.Parent = Content

local InfoLayout = Instance.new("UIListLayout")
InfoLayout.Padding = UDim.new(0, 8)
InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
InfoLayout.Parent = PageInfo

-- > USER CARD < --
local UserCard = Instance.new("Frame")
UserCard.Size = UDim2.new(1, 0, 0, 90)
UserCard.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
UserCard.BorderSizePixel = 0
UserCard.Parent = PageInfo

local UserCardCorner = Instance.new("UICorner")
UserCardCorner.CornerRadius = UDim.new(0, 8)
UserCardCorner.Parent = UserCard

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 70, 0, 70)
Avatar.Position = UDim2.new(0, 10, 0, 10)
Avatar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Avatar.BorderSizePixel = 0
task.spawn(function()
    Avatar.Image = plrs:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
Avatar.Parent = UserCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = Avatar

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, -100, 0, 25)
WelcomeLabel.Position = UDim2.new(0, 90, 0, 15)
WelcomeLabel.RichText = true
WelcomeLabel.Text = "Welcome, <font color=\"rgb(80, 120, 250)\">" .. plr.Name .. "</font>"
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.TextSize = 20
WelcomeLabel.TextColor3 = Color3.new(1, 1, 1)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.TextScaled = true
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
WelcomeLabel.Parent = UserCard

local WelcomeSizeConstraint = Instance.new("UITextSizeConstraint")
WelcomeSizeConstraint.MaxTextSize = 20
WelcomeSizeConstraint.Parent = WelcomeLabel

local ExecutorLabel = Instance.new("TextLabel")
ExecutorLabel.Size = UDim2.new(1, -100, 0, 20)
ExecutorLabel.Position = UDim2.new(0, 90, 0, 45)
ExecutorLabel.BackgroundTransparency = 1
ExecutorLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
ExecutorLabel.TextXAlignment = Enum.TextXAlignment.Left
ExecutorLabel.Font = Enum.Font.Gotham
ExecutorLabel.TextSize = 14
ExecutorLabel.RichText = true
ExecutorLabel.Text = "<font color=\"rgb(80, 120, 250)\">Executor:</font> " .. (identifyexecutor and identifyexecutor() or "Unknown")
ExecutorLabel.Parent = UserCard

-- > GAME CARD < --
local GameCard = Instance.new("Frame")
GameCard.Size = UDim2.new(1, 0, 0, 100)
GameCard.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
GameCard.BorderSizePixel = 0
GameCard.Parent = PageInfo

local GameCardCorner = Instance.new("UICorner")
GameCardCorner.CornerRadius = UDim.new(0, 8)
GameCardCorner.Parent = GameCard

local GameCardPadding = Instance.new("UIPadding")
GameCardPadding.PaddingLeft = UDim.new(0, 15)
GameCardPadding.PaddingTop = UDim.new(0, 10)
GameCardPadding.Parent = GameCard

local GameLabel = Instance.new("TextLabel")
GameLabel.Size = UDim2.new(1, 0, 0, 20)
GameLabel.RichText = true
GameLabel.Text = "<font color=\"rgb(80, 120, 250)\">Game ID:</font> " .. game.PlaceId
GameLabel.Font = Enum.Font.Gotham
GameLabel.TextSize = 14
GameLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
GameLabel.BackgroundTransparency = 1
GameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameLabel.Parent = GameCard

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, 0, 0, 40)
StatsLabel.Position = UDim2.new(0, 0, 0, 25)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextSize = 14
StatsLabel.RichText = true
StatsLabel.Text = "<font color=\"rgb(80, 120, 250)\">FPS:</font> ...\n<font color=\"rgb(80, 120, 250)\">Ping:</font> ..."
StatsLabel.Parent = GameCard

local ServerLabel = Instance.new("TextLabel")
ServerLabel.Size = UDim2.new(1, 0, 0, 20)
ServerLabel.Position = UDim2.new(0, 0, 0, 65)
ServerLabel.BackgroundTransparency = 1
ServerLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
ServerLabel.TextXAlignment = Enum.TextXAlignment.Left
ServerLabel.TextYAlignment = Enum.TextYAlignment.Top
ServerLabel.Font = Enum.Font.Gotham
ServerLabel.TextSize = 14
ServerLabel.RichText = true
ServerLabel.Text = "<font color=\"rgb(80, 120, 250)\">Players:</font> ..."
ServerLabel.Parent = GameCard

local PageAim = Instance.new("Frame")
PageAim.Size = UDim2.new(1, 0, 1, 0)
PageAim.BackgroundTransparency = 1
PageAim.Visible = false
PageAim.Parent = Content

local AimScroll = Instance.new("ScrollingFrame")
AimScroll.Size = UDim2.new(1, 0, 1, 0)
AimScroll.BackgroundTransparency = 1
AimScroll.BorderSizePixel = 0
AimScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
AimScroll.ScrollBarThickness = 6
AimScroll.Parent = PageAim

local AimLayout = Instance.new("UIListLayout")
AimLayout.Padding = UDim.new(0, 8)
AimLayout.SortOrder = Enum.SortOrder.LayoutOrder
AimLayout.Parent = AimScroll

local PageVisual = Instance.new("Frame")
PageVisual.Size = UDim2.new(1, 0, 1, 0)
PageVisual.BackgroundTransparency = 1
PageVisual.Visible = false
PageVisual.Parent = Content

local VisualScroll = Instance.new("ScrollingFrame")
VisualScroll.Size = UDim2.new(1, 0, 1, 0)
VisualScroll.BackgroundTransparency = 1
VisualScroll.BorderSizePixel = 0
VisualScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
VisualScroll.ScrollBarThickness = 6
VisualScroll.Parent = PageVisual

local VisualLayout = Instance.new("UIListLayout")
VisualLayout.Padding = UDim.new(0, 8)
VisualLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisualLayout.Parent = VisualScroll

local PageSettings = Instance.new("Frame")
PageSettings.Size = UDim2.new(1, 0, 1, 0)
PageSettings.BackgroundTransparency = 1
PageSettings.Visible = false
PageSettings.Parent = Content

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1, 0, 1, 0)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.BorderSizePixel = 0
SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScroll.ScrollBarThickness = 6
SettingsScroll.Parent = PageSettings

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 8)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Parent = SettingsScroll

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1, 0, 0, 35)
SaveBtn.RichText = true
SaveBtn.Text = "<font color=\"rgb(80, 120, 250)\">Save</font> Config"
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SaveBtn.TextColor3 = Color3.new(1, 1, 1)
SaveBtn.Parent = SettingsScroll

local SaveCorner = Instance.new("UICorner")
SaveCorner.CornerRadius = UDim.new(0, 6)
SaveCorner.Parent = SaveBtn

local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(1, 0, 0, 35)
LoadBtn.RichText = true
LoadBtn.Text = "<font color=\"rgb(80, 120, 250)\">Load</font> Config"
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LoadBtn.TextColor3 = Color3.new(1, 1, 1)
LoadBtn.Parent = SettingsScroll

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 6)
LoadCorner.Parent = LoadBtn

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, 0, 0, 35)
RejoinBtn.RichText = true
RejoinBtn.Text = "<font color=\"rgb(80, 120, 250)\">Rejoin</font> Server"
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
RejoinBtn.TextColor3 = Color3.new(1, 1, 1)
RejoinBtn.Parent = SettingsScroll

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 6)
RejoinCorner.Parent = RejoinBtn

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Size = UDim2.new(1, 0, 0, 35)
KeybindBtn.RichText = true
KeybindBtn.Text = "<font color=\"rgb(80, 120, 250)\">Menu Key:</font> Insert"
KeybindBtn.Font = Enum.Font.GothamBold
KeybindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
KeybindBtn.TextColor3 = Color3.new(1, 1, 1)
KeybindBtn.Parent = SettingsScroll

local KeybindCorner = Instance.new("UICorner")
KeybindCorner.CornerRadius = UDim.new(0, 6)
KeybindCorner.Parent = KeybindBtn

local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Size = UDim2.new(1, 0, 0, 35)
UnloadBtn.RichText = true
UnloadBtn.Text = "<font color=\"rgb(80, 120, 250)\">Unload</font> Cheat"
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.BackgroundColor3 = Color3.fromRGB(250, 80, 80)
UnloadBtn.TextColor3 = Color3.new(1, 1, 1)
UnloadBtn.Parent = SettingsScroll

local UnloadCorner = Instance.new("UICorner")
UnloadCorner.CornerRadius = UDim.new(0, 6)
UnloadCorner.Parent = UnloadBtn

local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Size = UDim2.new(1, 0, 0, 30)
CreditsLabel.Text = "Dev: Unknow | v2.0"
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Parent = SettingsScroll

-- Pulsanti Funzioni (Spostati nelle rispettive pagine)
local AimBtn = Instance.new("TextButton")
AimBtn.Size = UDim2.new(1, 0, 0, 35)
AimBtn.RichText = true
AimBtn.Text = "<font color=\"rgb(80, 120, 250)\">Silent Aim:</font> OFF"
AimBtn.Font = Enum.Font.GothamBold
AimBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AimBtn.TextColor3 = Color3.new(1, 1, 1)
AimBtn.Parent = AimScroll

local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(0, 6)
AimCorner.Parent = AimBtn

local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(1, 0, 0, 35)
AimbotBtn.RichText = true
AimbotBtn.Text = "<font color=\"rgb(80, 120, 250)\">Aimbot:</font> OFF"
AimbotBtn.Font = Enum.Font.GothamBold
AimbotBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AimbotBtn.TextColor3 = Color3.new(1, 1, 1)
AimbotBtn.Parent = AimScroll

local AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 6)
AimbotCorner.Parent = AimbotBtn

local AimSpeedFrame = Instance.new("Frame")
AimSpeedFrame.Size = UDim2.new(1, 0, 0, 35)
AimSpeedFrame.BackgroundTransparency = 1
AimSpeedFrame.Parent = AimScroll

local AimSpeedLabel = Instance.new("TextLabel")
AimSpeedLabel.Size = UDim2.new(0.5, 0, 1, 0)
AimSpeedLabel.RichText = true
AimSpeedLabel.Text = "<font color=\"rgb(80, 120, 250)\">Aim Speed %:</font>"
AimSpeedLabel.Font = Enum.Font.Gotham
AimSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
AimSpeedLabel.BackgroundTransparency = 1
AimSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
AimSpeedLabel.Parent = AimSpeedFrame

local AimSpeedBox = Instance.new("TextBox")
AimSpeedBox.Size = UDim2.new(0.4, 0, 1, 0)
AimSpeedBox.Position = UDim2.new(0.6, 0, 0, 0)
AimSpeedBox.Text = tostring(Config.AimSpeed)
AimSpeedBox.Font = Enum.Font.Gotham
AimSpeedBox.TextColor3 = Color3.new(1, 1, 1)
AimSpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
AimSpeedBox.BorderSizePixel = 0
AimSpeedBox.Parent = AimSpeedFrame

local AimSpeedCorner = Instance.new("UICorner")
AimSpeedCorner.CornerRadius = UDim.new(0, 6)
AimSpeedCorner.Parent = AimSpeedBox

local FOVBtn = Instance.new("TextButton")
FOVBtn.Size = UDim2.new(1, 0, 0, 35)
FOVBtn.RichText = true
FOVBtn.Text = "<font color=\"rgb(80, 120, 250)\">Show FOV:</font> OFF"
FOVBtn.Font = Enum.Font.GothamBold
FOVBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FOVBtn.TextColor3 = Color3.new(1, 1, 1)
FOVBtn.Parent = AimScroll

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(0, 6)
FOVCorner.Parent = FOVBtn

local TeamCheckBtn = Instance.new("TextButton")
TeamCheckBtn.Size = UDim2.new(1, 0, 0, 35)
TeamCheckBtn.RichText = true
TeamCheckBtn.Text = "<font color=\"rgb(80, 120, 250)\">Team Check:</font> OFF"
TeamCheckBtn.Font = Enum.Font.GothamBold
TeamCheckBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TeamCheckBtn.TextColor3 = Color3.new(1, 1, 1)
TeamCheckBtn.Parent = AimScroll

local TeamCheckCorner = Instance.new("UICorner")
TeamCheckCorner.CornerRadius = UDim.new(0, 6)
TeamCheckCorner.Parent = TeamCheckBtn

local TargetPartBtn = Instance.new("TextButton")
TargetPartBtn.Size = UDim2.new(1, 0, 0, 35)
TargetPartBtn.RichText = true
TargetPartBtn.Text = "<font color=\"rgb(80, 120, 250)\">Target:</font> Closest"
TargetPartBtn.Font = Enum.Font.GothamBold
TargetPartBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TargetPartBtn.TextColor3 = Color3.new(1, 1, 1)
TargetPartBtn.Parent = AimScroll

local TargetPartCorner = Instance.new("UICorner")
TargetPartCorner.CornerRadius = UDim.new(0, 6)
TargetPartCorner.Parent = TargetPartBtn

local PredictionBtn = Instance.new("TextButton")
PredictionBtn.Size = UDim2.new(1, 0, 0, 35)
PredictionBtn.RichText = true
PredictionBtn.Text = "<font color=\"rgb(80, 120, 250)\">Prediction:</font> OFF"
PredictionBtn.Font = Enum.Font.GothamBold
PredictionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
PredictionBtn.TextColor3 = Color3.new(1, 1, 1)
PredictionBtn.Parent = AimScroll

local PredictionCorner = Instance.new("UICorner")
PredictionCorner.CornerRadius = UDim.new(0, 6)
PredictionCorner.Parent = PredictionBtn

local PredAmountFrame = Instance.new("Frame")
PredAmountFrame.Size = UDim2.new(1, 0, 0, 35)
PredAmountFrame.BackgroundTransparency = 1
PredAmountFrame.Parent = AimScroll

local PredAmountLabel = Instance.new("TextLabel")
PredAmountLabel.Size = UDim2.new(0.5, 0, 1, 0)
PredAmountLabel.RichText = true
PredAmountLabel.Text = "<font color=\"rgb(80, 120, 250)\">Pred Amount:</font>"
PredAmountLabel.Font = Enum.Font.Gotham
PredAmountLabel.TextColor3 = Color3.new(1, 1, 1)
PredAmountLabel.BackgroundTransparency = 1
PredAmountLabel.TextXAlignment = Enum.TextXAlignment.Left
PredAmountLabel.Parent = PredAmountFrame

local PredAmountBox = Instance.new("TextBox")
PredAmountBox.Size = UDim2.new(0.4, 0, 1, 0)
PredAmountBox.Position = UDim2.new(0.6, 0, 0, 0)
PredAmountBox.Text = tostring(Config.PredictionAmount)
PredAmountBox.Font = Enum.Font.Gotham
PredAmountBox.TextColor3 = Color3.new(1, 1, 1)
PredAmountBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PredAmountBox.BorderSizePixel = 0
PredAmountBox.Parent = PredAmountFrame

local PredAmountCorner = Instance.new("UICorner")
PredAmountCorner.CornerRadius = UDim.new(0, 6)
PredAmountCorner.Parent = PredAmountBox

local OffsetFrame = Instance.new("Frame")
OffsetFrame.Size = UDim2.new(1, 0, 0, 35)
OffsetFrame.BackgroundTransparency = 1
OffsetFrame.Parent = AimScroll

local OffsetLabel = Instance.new("TextLabel")
OffsetLabel.Size = UDim2.new(0.5, 0, 1, 0)
OffsetLabel.RichText = true
OffsetLabel.Text = "<font color=\"rgb(80, 120, 250)\">Aim Offset Y:</font>"
OffsetLabel.Font = Enum.Font.Gotham
OffsetLabel.TextColor3 = Color3.new(1, 1, 1)
OffsetLabel.BackgroundTransparency = 1
OffsetLabel.TextXAlignment = Enum.TextXAlignment.Left
OffsetLabel.Parent = OffsetFrame

local OffsetBox = Instance.new("TextBox")
OffsetBox.Size = UDim2.new(0.4, 0, 1, 0)
OffsetBox.Position = UDim2.new(0.6, 0, 0, 0)
OffsetBox.Text = tostring(Config.AimOffset)
OffsetBox.Font = Enum.Font.Gotham
OffsetBox.TextColor3 = Color3.new(1, 1, 1)
OffsetBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
OffsetBox.BorderSizePixel = 0
OffsetBox.Parent = OffsetFrame

local OffsetCorner = Instance.new("UICorner")
OffsetCorner.CornerRadius = UDim.new(0, 6)
OffsetCorner.Parent = OffsetBox

local AccuracyFrame = Instance.new("Frame")
AccuracyFrame.Size = UDim2.new(1, 0, 0, 35)
AccuracyFrame.BackgroundTransparency = 1
AccuracyFrame.Parent = AimScroll

local AccuracyLabel = Instance.new("TextLabel")
AccuracyLabel.Size = UDim2.new(0.5, 0, 1, 0)
AccuracyLabel.RichText = true
AccuracyLabel.Text = "<font color=\"rgb(80, 120, 250)\">Accuracy %:</font>"
AccuracyLabel.Font = Enum.Font.Gotham
AccuracyLabel.TextColor3 = Color3.new(1, 1, 1)
AccuracyLabel.BackgroundTransparency = 1
AccuracyLabel.TextXAlignment = Enum.TextXAlignment.Left
AccuracyLabel.Parent = AccuracyFrame

local AccuracyBox = Instance.new("TextBox")
AccuracyBox.Size = UDim2.new(0.4, 0, 1, 0)
AccuracyBox.Position = UDim2.new(0.6, 0, 0, 0)
AccuracyBox.Text = "100"
AccuracyBox.Font = Enum.Font.Gotham
AccuracyBox.TextColor3 = Color3.new(1, 1, 1)
AccuracyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
AccuracyBox.BorderSizePixel = 0
AccuracyBox.Parent = AccuracyFrame

local AccCorner = Instance.new("UICorner")
AccCorner.CornerRadius = UDim.new(0, 6)
AccCorner.Parent = AccuracyBox

local FOVSizeFrame = Instance.new("Frame")
FOVSizeFrame.Size = UDim2.new(1, 0, 0, 35)
FOVSizeFrame.BackgroundTransparency = 1
FOVSizeFrame.Parent = AimScroll

local FOVSizeLabel = Instance.new("TextLabel")
FOVSizeLabel.Size = UDim2.new(0.5, 0, 1, 0)
FOVSizeLabel.RichText = true
FOVSizeLabel.Text = "<font color=\"rgb(80, 120, 250)\">FOV Size:</font>"
FOVSizeLabel.Font = Enum.Font.Gotham
FOVSizeLabel.TextColor3 = Color3.new(1, 1, 1)
FOVSizeLabel.BackgroundTransparency = 1
FOVSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVSizeLabel.Parent = FOVSizeFrame

local FOVSizeBox = Instance.new("TextBox")
FOVSizeBox.Size = UDim2.new(0.4, 0, 1, 0)
FOVSizeBox.Position = UDim2.new(0.6, 0, 0, 0)
FOVSizeBox.Text = tostring(Config.FOV)
FOVSizeBox.Font = Enum.Font.Gotham
FOVSizeBox.TextColor3 = Color3.new(1, 1, 1)
FOVSizeBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
FOVSizeBox.BorderSizePixel = 0
FOVSizeBox.Parent = FOVSizeFrame

local FOVSizeCorner = Instance.new("UICorner")
FOVSizeCorner.CornerRadius = UDim.new(0, 6)
FOVSizeCorner.Parent = FOVSizeBox

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(1, 0, 0, 35)
ESPBtn.RichText = true
ESPBtn.Text = "<font color=\"rgb(80, 120, 250)\">ESP:</font> OFF"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Parent = VisualScroll

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 6)
ESPCorner.Parent = ESPBtn

local LinesBtn = Instance.new("TextButton")
LinesBtn.Size = UDim2.new(1, 0, 0, 35)
LinesBtn.RichText = true
LinesBtn.Text = "<font color=\"rgb(80, 120, 250)\">Lines:</font> OFF"
LinesBtn.Font = Enum.Font.GothamBold
LinesBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LinesBtn.TextColor3 = Color3.new(1, 1, 1)
LinesBtn.Parent = VisualScroll

local LinesCorner = Instance.new("UICorner")
LinesCorner.CornerRadius = UDim.new(0, 6)
LinesCorner.Parent = LinesBtn

local VisualTeamCheckBtn = Instance.new("TextButton")
VisualTeamCheckBtn.Size = UDim2.new(1, 0, 0, 35)
VisualTeamCheckBtn.RichText = true
VisualTeamCheckBtn.Text = "<font color=\"rgb(80, 120, 250)\">Team Check:</font> OFF"
VisualTeamCheckBtn.Font = Enum.Font.GothamBold
VisualTeamCheckBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
VisualTeamCheckBtn.TextColor3 = Color3.new(1, 1, 1)
VisualTeamCheckBtn.Parent = VisualScroll

local VTeamCheckCorner = Instance.new("UICorner")
VTeamCheckCorner.CornerRadius = UDim.new(0, 6)
VTeamCheckCorner.Parent = VisualTeamCheckBtn

-- Logica Cambio Tab (Aggiornata per il nuovo stile)
local function SwitchTab(targetPage, activeBtn)
    PageInfo.Visible = false
    PageAim.Visible = false
    PageVisual.Visible = false
    PageSettings.Visible = false
    targetPage.Visible = true
    
    -- Reset colori bottoni
    NavInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    NavInfo.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    NavAim.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    NavAim.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    NavVisual.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    NavVisual.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    NavSettings.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    NavSettings.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    
    -- Evidenzia attivo
    if activeBtn then
        activeBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 250)
        activeBtn.TextColor3 = Color3.new(1, 1, 1)
    end
end

NavInfo.MouseButton1Click:Connect(function() SwitchTab(PageInfo, NavInfo) end)
NavAim.MouseButton1Click:Connect(function() SwitchTab(PageAim, NavAim) end)
NavVisual.MouseButton1Click:Connect(function() SwitchTab(PageVisual, NavVisual) end)
NavSettings.MouseButton1Click:Connect(function() SwitchTab(PageSettings, NavSettings) end)

-- Logica Pulsanti
AimBtn.MouseButton1Click:Connect(function()
    Config.SilentAim = not Config.SilentAim
    AimBtn.Text = Config.SilentAim and "Silent Aim: ON" or "<font color=\"rgb(80, 120, 250)\">Silent Aim:</font> OFF"
    AimBtn.BackgroundColor3 = Config.SilentAim and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
end)

AimbotBtn.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    AimbotBtn.Text = Config.Aimbot and "Aimbot: ON" or "<font color=\"rgb(80, 120, 250)\">Aimbot:</font> OFF"
    AimbotBtn.BackgroundColor3 = Config.Aimbot and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
end)

FOVBtn.MouseButton1Click:Connect(function()
    Config.ShowFOV = not Config.ShowFOV
    FOVBtn.Text = Config.ShowFOV and "Show FOV: ON" or "<font color=\"rgb(80, 120, 250)\">Show FOV:</font> OFF"
    FOVBtn.BackgroundColor3 = Config.ShowFOV and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
end)

TeamCheckBtn.MouseButton1Click:Connect(function()
    Config.TeamCheck = not Config.TeamCheck
    TeamCheckBtn.Text = Config.TeamCheck and "Team Check: ON" or "<font color=\"rgb(80, 120, 250)\">Team Check:</font> OFF"
    TeamCheckBtn.BackgroundColor3 = Config.TeamCheck and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
end)

TargetPartBtn.MouseButton1Click:Connect(function()
    if Config.TargetPart == "Closest" then
        Config.TargetPart = "Head"
    elseif Config.TargetPart == "Head" then
        Config.TargetPart = "Torso"
    else
        Config.TargetPart = "Closest"
    end
    TargetPartBtn.Text = "<font color=\"rgb(80, 120, 250)\">Target:</font> " .. Config.TargetPart
end)

PredictionBtn.MouseButton1Click:Connect(function()
    Config.Prediction = not Config.Prediction
    PredictionBtn.Text = Config.Prediction and "Prediction: ON" or "<font color=\"rgb(80, 120, 250)\">Prediction:</font> OFF"
    PredictionBtn.BackgroundColor3 = Config.Prediction and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
end)

PredAmountBox.FocusLost:Connect(function()
    local num = tonumber(PredAmountBox.Text)
    if num then
        Config.PredictionAmount = num
    end
    PredAmountBox.Text = tostring(Config.PredictionAmount)
end)

OffsetBox.FocusLost:Connect(function()
    local num = tonumber(OffsetBox.Text)
    if num then
        Config.AimOffset = num
    end
    OffsetBox.Text = tostring(Config.AimOffset)
end)

AccuracyBox.FocusLost:Connect(function()
    local num = tonumber(AccuracyBox.Text)
    if num then
        Config.Accuracy = math.clamp(num, 1, 100)
    end
    AccuracyBox.Text = tostring(Config.Accuracy)
end)

AimSpeedBox.FocusLost:Connect(function()
    local num = tonumber(AimSpeedBox.Text)
    if num then
        Config.AimSpeed = math.clamp(num, 1, 100)
    end
    AimSpeedBox.Text = tostring(Config.AimSpeed)
end)

FOVSizeBox.FocusLost:Connect(function()
    local num = tonumber(FOVSizeBox.Text)
    if num then
        Config.FOV = num
    end
    FOVSizeBox.Text = tostring(Config.FOV)
end)

ESPBtn.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    ESPBtn.Text = Config.ESP and "ESP: ON" or "<font color=\"rgb(80, 120, 250)\">ESP:</font> OFF"
    ESPBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
    
    -- Pulisci ESP se disattivato
    if not Config.ESP then
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:FindFirstChild("ESP_Highlight") then
                v.ESP_Highlight:Destroy()
            end
        end
    end
end)

LinesBtn.MouseButton1Click:Connect(function()
    Config.Lines = not Config.Lines
    LinesBtn.Text = Config.Lines and "Lines: ON" or "<font color=\"rgb(80, 120, 250)\">Lines:</font> OFF"
    LinesBtn.BackgroundColor3 = Config.Lines and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
    
    if not Config.Lines then
        -- Pulisci le linee se disattivato
        if TracerGui then 
            for _, v in pairs(TracerGui:GetChildren()) do
                if v.Name ~= "FOVRing" then v:Destroy() end
            end
        end
    end
end)

VisualTeamCheckBtn.MouseButton1Click:Connect(function()
    Config.VisualTeamCheck = not Config.VisualTeamCheck
    VisualTeamCheckBtn.Text = Config.VisualTeamCheck and "Team Check: ON" or "<font color=\"rgb(80, 120, 250)\">Team Check:</font> OFF"
    VisualTeamCheckBtn.BackgroundColor3 = Config.VisualTeamCheck and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
end)

local listening = false
KeybindBtn.MouseButton1Click:Connect(function()
    listening = true
    KeybindBtn.Text = "Press any key..."
end)

uis.InputBegan:Connect(function(input, gp)
    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
        Config.MenuKey = input.KeyCode
        KeybindBtn.Text = "<font color=\"rgb(80, 120, 250)\">Menu Key:</font> " .. input.KeyCode.Name
        listening = false
    elseif not gp and input.KeyCode == Config.MenuKey and ScriptEnabled then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

local ConfigName = "MEP_Cheat_Config.json"

SaveBtn.MouseButton1Click:Connect(function()
    if writefile then
        local json = httpService:JSONEncode(Config)
        writefile(ConfigName, json)
        SaveBtn.Text = "<font color=\"rgb(80, 250, 120)\">Saved!</font>"
        task.wait(1)
        SaveBtn.Text = "<font color=\"rgb(80, 120, 250)\">Save</font> Config"
    end
end)

LoadBtn.MouseButton1Click:Connect(function()
    if readfile and isfile and isfile(ConfigName) then
        local json = readfile(ConfigName)
        local loaded = httpService:JSONDecode(json)
        for k, v in pairs(loaded) do
            if Config[k] ~= nil then Config[k] = v end
        end
        
        -- Update UI
        AimBtn.Text = Config.SilentAim and "Silent Aim: ON" or "<font color=\"rgb(80, 120, 250)\">Silent Aim:</font> OFF"
        AimBtn.BackgroundColor3 = Config.SilentAim and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        AimbotBtn.Text = Config.Aimbot and "Aimbot: ON" or "<font color=\"rgb(80, 120, 250)\">Aimbot:</font> OFF"
        AimbotBtn.BackgroundColor3 = Config.Aimbot and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        FOVBtn.Text = Config.ShowFOV and "Show FOV: ON" or "<font color=\"rgb(80, 120, 250)\">Show FOV:</font> OFF"
        FOVBtn.BackgroundColor3 = Config.ShowFOV and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        TeamCheckBtn.Text = Config.TeamCheck and "Team Check: ON" or "<font color=\"rgb(80, 120, 250)\">Team Check:</font> OFF"
        TeamCheckBtn.BackgroundColor3 = Config.TeamCheck and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        TargetPartBtn.Text = "<font color=\"rgb(80, 120, 250)\">Target:</font> " .. Config.TargetPart
        PredictionBtn.Text = Config.Prediction and "Prediction: ON" or "<font color=\"rgb(80, 120, 250)\">Prediction:</font> OFF"
        PredictionBtn.BackgroundColor3 = Config.Prediction and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        PredAmountBox.Text = tostring(Config.PredictionAmount)
        OffsetBox.Text = tostring(Config.AimOffset)
        AccuracyBox.Text = tostring(Config.Accuracy)
        AimSpeedBox.Text = tostring(Config.AimSpeed)
        FOVSizeBox.Text = tostring(Config.FOV)
        ESPBtn.Text = Config.ESP and "ESP: ON" or "<font color=\"rgb(80, 120, 250)\">ESP:</font> OFF"
        ESPBtn.BackgroundColor3 = Config.ESP and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        LinesBtn.Text = Config.Lines and "Lines: ON" or "<font color=\"rgb(80, 120, 250)\">Lines:</font> OFF"
        LinesBtn.BackgroundColor3 = Config.Lines and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        VisualTeamCheckBtn.Text = Config.VisualTeamCheck and "Team Check: ON" or "<font color=\"rgb(80, 120, 250)\">Team Check:</font> OFF"
        VisualTeamCheckBtn.BackgroundColor3 = Config.VisualTeamCheck and Color3.fromRGB(80, 120, 250) or Color3.fromRGB(40, 40, 50)
        
        LoadBtn.Text = "<font color=\"rgb(80, 250, 120)\">Loaded!</font>"
        task.wait(1)
        LoadBtn.Text = "<font color=\"rgb(80, 120, 250)\">Load</font> Config"
    end
end)

UnloadBtn.MouseButton1Click:Connect(function()
    if MainLoop then MainLoop:Disconnect() end
    ScriptEnabled = false
    ScreenGui:Destroy()
    if TracerGui then TracerGui:Destroy() end
    
    -- Cleanup ESP Highlights
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("ESP_Highlight") then
            v.ESP_Highlight:Destroy()
        end
    end
end)

-- > TRACER GUI < --
TracerGui = Instance.new("ScreenGui")
TracerGui.Name = "TracerGui"
TracerGui.IgnoreGuiInset = true
if pcall(function() TracerGui.Parent = coreGui end) then
    TracerGui.Parent = coreGui
else
    TracerGui.Parent = plr:WaitForChild("PlayerGui")
end

-- > FOV CIRCLE < --
local FOVRing = Instance.new("Frame")
FOVRing.Name = "FOVRing"
FOVRing.Size = UDim2.new(0, Config.FOV * 2, 0, Config.FOV * 2)
FOVRing.AnchorPoint = Vector2.new(0.5, 0.5)
FOVRing.BackgroundTransparency = 1
FOVRing.Visible = false
FOVRing.Parent = TracerGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1
FOVStroke.Color = Color3.new(1, 1, 1)
FOVStroke.Parent = FOVRing

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVRing

-- > FUNZIONI SILENT AIM < --
function notBehindWall(target)
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {plr.Character, camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true

    local direction = target.Position - plr.Character.Head.Position
    local result = workspace:Raycast(plr.Character.Head.Position, direction, params)

    if result then
        if result.Instance:IsDescendantOf(target.Parent) then
            return true
        end
        return false
    end
    return true
end

function getPlayerClosestToMouse()
    local target = nil
    local maxDist = Config.FOV
    local mouseLoc = uis:GetMouseLocation()
    
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Model") and v ~= plr.Character then
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                local player = plrs:GetPlayerFromCharacter(v)
                if Config.TeamCheck and player and player.TeamColor == plr.TeamColor then continue end
                    
                -- Check multiple parts for better precision
                local partsToCheck = {}
                if Config.TargetPart == "Head" then
                    partsToCheck = {v:FindFirstChild("Head")}
                elseif Config.TargetPart == "Torso" then
                    partsToCheck = {v:FindFirstChild("HumanoidRootPart"), v:FindFirstChild("UpperTorso"), v:FindFirstChild("LowerTorso"), v:FindFirstChild("Torso")}
                else
                    partsToCheck = {v:FindFirstChild("Head"), v:FindFirstChild("HumanoidRootPart"), v:FindFirstChild("UpperTorso"), v:FindFirstChild("LowerTorso"), v:FindFirstChild("Torso")}
                end
                    
                for _, part in pairs(partsToCheck) do
                    if part then
                        local pos, vis = camera:WorldToViewportPoint(part.Position)
                        local dist = (mouseLoc - Vector2.new(pos.X, pos.Y)).Magnitude
                        
                        if vis and dist < maxDist then
                            if not Config.WallCheck or notBehindWall(part) then
                                target = part
                                maxDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- > HOOKING < --
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall
local oldIndex = gmt.__index

gmt.__namecall = newcclosure(function(self, ... )
    local Args = { ... }
    local method = getnamecallmethod()
    
    if ScriptEnabled and Config.SilentAim and CurrentTarget and not checkcaller() then
        if math.random(1, 100) <= Config.Accuracy then
            if method == "Raycast" then
                local Origin = Args[1]
                local targetPos = CurrentTarget.Position
                if Config.Prediction and CurrentTarget.Parent and CurrentTarget.Parent:FindFirstChild("HumanoidRootPart") then
                    targetPos = targetPos + (CurrentTarget.Parent.HumanoidRootPart.Velocity * Config.PredictionAmount)
                end
                targetPos = targetPos + Vector3.new(0, Config.AimOffset, 0)
                local Direction = (targetPos - Origin).Unit * 1000
                Args[2] = Direction
                return oldNamecall(self, unpack(Args))
            elseif method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" then
                local RayVal = Args[1]
                if typeof(RayVal) == "Ray" then
                    local Origin = RayVal.Origin
                    local targetPos = CurrentTarget.Position
                    if Config.Prediction and CurrentTarget.Parent and CurrentTarget.Parent:FindFirstChild("HumanoidRootPart") then
                        targetPos = targetPos + (CurrentTarget.Parent.HumanoidRootPart.Velocity * Config.PredictionAmount)
                    end
                    targetPos = targetPos + Vector3.new(0, Config.AimOffset, 0)
                    local Direction = (targetPos - Origin).Unit * 1000
                    Args[1] = Ray.new(Origin, Direction)
                    return oldNamecall(self, unpack(Args))
                end
            end
        end
    end

    if ScriptEnabled and Config.SilentAim and tostring(self) == "HitPart" and tostring(method) == "FireServer" then
        if CurrentTarget then
            local target = CurrentTarget
            local targetPos = target.Position
            if Config.Prediction and target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") then
                targetPos = targetPos + (target.Parent.HumanoidRootPart.Velocity * Config.PredictionAmount)
            end
            targetPos = targetPos + Vector3.new(0, Config.AimOffset, 0)
            if math.random(1, 100) <= Config.Accuracy then
                Args[1] = target
                Args[2] = targetPos
                return oldNamecall(self, unpack(Args))
            end
        end
    end
    return oldNamecall(self, ... )
end)

gmt.__index = newcclosure(function(self, k)
    if ScriptEnabled and Config.SilentAim and not checkcaller() and self == mouse then
        if CurrentTarget and math.random(1, 100) <= Config.Accuracy then
            local targetPos = CurrentTarget.Position
            if Config.Prediction and CurrentTarget.Parent and CurrentTarget.Parent:FindFirstChild("HumanoidRootPart") then
                targetPos = targetPos + (CurrentTarget.Parent.HumanoidRootPart.Velocity * Config.PredictionAmount)
            end
            targetPos = targetPos + Vector3.new(0, Config.AimOffset, 0)
            local LoweredK = string.lower(tostring(k))
            if LoweredK == "hit" then
                return CFrame.new(targetPos)
            elseif LoweredK == "target" then
                return CurrentTarget
            elseif LoweredK == "unitray" then
                local origin = self.Origin.p
                local direction = (targetPos - origin).Unit
                return Ray.new(origin, direction)
            elseif LoweredK == "x" then
                local pos = camera:WorldToViewportPoint(targetPos)
                return pos.X
            elseif LoweredK == "y" then
                local pos = camera:WorldToViewportPoint(targetPos)
                return pos.Y
            end
        end
    end
    return oldIndex(self, k)
end)

-- > ESP LOOP < --
MainLoop = runService.RenderStepped:Connect(function(deltaTime)
    -- Update Stats
    local fps = math.floor(1 / deltaTime)
    local ping = 0
    if game:GetService("Stats"):FindFirstChild("Network") then
        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end
    StatsLabel.Text = "<font color=\"rgb(80, 120, 250)\">FPS:</font> " .. fps .. "\n<font color=\"rgb(80, 120, 250)\">Ping:</font> " .. ping .. " ms"

    -- Update Server Info
    ServerLabel.Text = "<font color=\"rgb(80, 120, 250)\">Players:</font> " .. #plrs:GetPlayers() .. "/" .. plrs.MaxPlayers

    -- Update Silent Aim Target
    if Config.SilentAim or Config.Aimbot then
        CurrentTarget = getPlayerClosestToMouse()
    else
        CurrentTarget = nil
    end

    -- Aimbot Logic (Camera Lock)
    if Config.Aimbot and CurrentTarget then
        local targetPos = CurrentTarget.Position
        if Config.Prediction and CurrentTarget.Parent and CurrentTarget.Parent:FindFirstChild("HumanoidRootPart") then
            targetPos = targetPos + (CurrentTarget.Parent.HumanoidRootPart.Velocity * Config.PredictionAmount)
        end
        targetPos = targetPos + Vector3.new(0, Config.AimOffset, 0)
        local smoothFactor = math.clamp(Config.AimSpeed / 100, 0.01, 1)
        camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPos), smoothFactor)
    end

    -- Update FOV Circle
    if Config.ShowFOV then
        FOVRing.Visible = true
        FOVRing.Size = UDim2.new(0, Config.FOV * 2, 0, Config.FOV * 2)
        local mouseLoc = uis:GetMouseLocation()
        FOVRing.Position = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y)
    else
        FOVRing.Visible = false
    end

    -- Cleanup orphaned lines (Fix per linee rimaste quando un player esce)
    for _, line in pairs(TracerGui:GetChildren()) do
        if line.Name ~= "FOVRing" then
            local char = game.Workspace:FindFirstChild(line.Name)
            if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                line:Destroy()
            end
        end
    end

    if Config.ESP or Config.Lines then
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Model") and v ~= plr.Character and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local player = plrs:GetPlayerFromCharacter(v)
                if Config.VisualTeamCheck and player and player.TeamColor == plr.TeamColor then 
                    if v:FindFirstChild("ESP_Highlight") then v.ESP_Highlight:Destroy() end
                    if TracerGui:FindFirstChild(v.Name) then TracerGui[v.Name]:Destroy() end
                    continue 
                end
                
                -- ESP Highlight Logic
                if Config.ESP and not v:FindFirstChild("ESP_Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.Adornee = v
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = v
                    
                    if player then
                        highlight.FillColor = player.TeamColor.Color
                        highlight.OutlineColor = player.TeamColor.Color
                    else
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    end
                end
                if not Config.ESP and v:FindFirstChild("ESP_Highlight") then
                    v.ESP_Highlight:Destroy()
                end

                -- Lines Logic
                local line = TracerGui:FindFirstChild(v.Name)
                if Config.Lines then
                    local pos, visible = camera:WorldToViewportPoint(v.HumanoidRootPart.Position)
                    if visible then
                        if not line then
                            line = Instance.new("Frame")
                            line.Name = v.Name
                            line.AnchorPoint = Vector2.new(0.5, 0.5)
                            line.BorderSizePixel = 0
                            line.Parent = TracerGui
                        end
                        
                        local startPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        local endPos = Vector2.new(pos.X, pos.Y)
                        local distance = (endPos - startPos).Magnitude
                        local center = (startPos + endPos) / 2
                        local angle = math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)
                        
                        line.Size = UDim2.new(0, distance, 0, 2)
                        line.Position = UDim2.new(0, center.X, 0, center.Y)
                        line.Rotation = math.deg(angle)
                        
                        if player then
                            line.BackgroundColor3 = player.TeamColor.Color
                        else
                            line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                        line.Visible = true
                    else
                        if line then line.Visible = false end
                    end
                elseif line then
                    line:Destroy()
                end
            else
                if v:FindFirstChild("ESP_Highlight") then
                    v.ESP_Highlight:Destroy()
                end
                if TracerGui:FindFirstChild(v.Name) then
                    TracerGui[v.Name]:Destroy()
                end
            end
        end
    end
end)
end)

-- > ESP LOOP < --
MainLoop = runService.RenderStepped:Connect(function(deltaTime)
    -- Update Stats
    local fps = math.floor(1 / deltaTime)
    local ping = 0
    if game:GetService("Stats"):FindFirstChild("Network") then
        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end
    StatsLabel.Text = "<font color=\"rgb(80, 120, 250)\">FPS:</font> " .. fps .. "\n<font color=\"rgb(80, 120, 250)\">Ping:</font> " .. ping .. " ms"

    -- Update Server Info
    ServerLabel.Text = "<font color=\"rgb(80, 120, 250)\">Players:</font> " .. #plrs:GetPlayers() .. "/" .. plrs.MaxPlayers

    -- Update Silent Aim Target
    if Config.SilentAim or Config.Aimbot then
        CurrentTarget = getPlayerClosestToMouse()
    else
        CurrentTarget = nil
    end

    -- Aimbot Logic (Camera Lock)
    if Config.Aimbot and CurrentTarget then
        local targetPos = CurrentTarget.Position
        if Config.Prediction and CurrentTarget.Parent and CurrentTarget.Parent:FindFirstChild("HumanoidRootPart") then
            targetPos = targetPos + (CurrentTarget.Parent.HumanoidRootPart.Velocity * Config.PredictionAmount)
        end
        targetPos = targetPos + Vector3.new(0, Config.AimOffset, 0)
        local smoothFactor = math.clamp(Config.AimSpeed / 100, 0.01, 1)
        camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPos), smoothFactor)
    end

    -- Update FOV Circle
    if Config.ShowFOV then
        FOVRing.Visible = true
        FOVRing.Size = UDim2.new(0, Config.FOV * 2, 0, Config.FOV * 2)
        local mouseLoc = uis:GetMouseLocation()
        FOVRing.Position = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y)
    else
        FOVRing.Visible = false
    end

    -- Cleanup orphaned lines (Fix per linee rimaste quando un player esce)
    for _, line in pairs(TracerGui:GetChildren()) do
        if line.Name ~= "FOVRing" then
            local char = game.Workspace:FindFirstChild(line.Name)
            if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                line:Destroy()
            end
        end
    end

    if Config.ESP or Config.Lines then
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Model") and v ~= plr.Character and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local player = plrs:GetPlayerFromCharacter(v)
                if Config.VisualTeamCheck and player and player.TeamColor == plr.TeamColor then 
                    if v:FindFirstChild("ESP_Highlight") then v.ESP_Highlight:Destroy() end
                    if TracerGui:FindFirstChild(v.Name) then TracerGui[v.Name]:Destroy() end
                    continue 
                end
                
                -- ESP Highlight Logic
                if Config.ESP and not v:FindFirstChild("ESP_Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.Adornee = v
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = v
                    
                    if player then
                        highlight.FillColor = player.TeamColor.Color
                        highlight.OutlineColor = player.TeamColor.Color
                    else
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    end
                end
                if not Config.ESP and v:FindFirstChild("ESP_Highlight") then
                    v.ESP_Highlight:Destroy()
                end

                -- Lines Logic
                local line = TracerGui:FindFirstChild(v.Name)
                if Config.Lines then
                    local pos, visible = camera:WorldToViewportPoint(v.HumanoidRootPart.Position)
                    if visible then
                        if not line then
                            line = Instance.new("Frame")
                            line.Name = v.Name
                            line.AnchorPoint = Vector2.new(0.5, 0.5)
                            line.BorderSizePixel = 0
                            line.Parent = TracerGui
                        end
                        
                        local startPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        local endPos = Vector2.new(pos.X, pos.Y)
                        local distance = (endPos - startPos).Magnitude
                        local center = (startPos + endPos) / 2
                        local angle = math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)
                        
                        line.Size = UDim2.new(0, distance, 0, 2)
                        line.Position = UDim2.new(0, center.X, 0, center.Y)
                        line.Rotation = math.deg(angle)
                        
                        if player then
                            line.BackgroundColor3 = player.TeamColor.Color
                        else
                            line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                        line.Visible = true
                    else
                        if line then line.Visible = false end
                    end
                elseif line then
                    line:Destroy()
                end
            else
                if v:FindFirstChild("ESP_Highlight") then
                    v.ESP_Highlight:Destroy()
                end
                if TracerGui:FindFirstChild(v.Name) then
                    TracerGui[v.Name]:Destroy()
                end
            end
        end
    end
end)
