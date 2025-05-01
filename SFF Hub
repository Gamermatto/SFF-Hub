--if game.PlaceId == 13772394625 then

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Blade Ball",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "SFF Hub",
    LoadingSubtitle = "by Gamermatto562",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "SFF Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "SFF HUb | Key",
       Subtitle = "Link In Discord Server",
       Note = "You can find our server from Misc Tab", -- Use this to tell the user how to get a key
       FileName = "SFF Hub | Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"https://pastebin.com/raw/0hCfHjs8"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

local MainTab = Window:CreateTab("Home", 4483362458) -- Title, Image
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
    Title = "Script executed successfully",
    Content = "Script up to date",
    Duration = 4.5,
    Image = 4483362458,
 })

 local Button = MainTab:CreateButton({
    Name = "Inf Jump",
    Callback = function()
        --- Configs
local flybutton = "e"
local flyspeed = 100
local controls = {
	front = "w",
	back = "s",
	right = "d",
	left = "a",
	up = " ",
	down = "q"
}
-- Configs

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local runservice = game:GetService("RunService")

local flycontrol = {F = 0, R = 0, B = 0, L = 0, U = 0, D = 0}
local flying = false

local function fly()
	local character = player.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then return end
	
	flying = true
	
	local bv = Instance.new("BodyVelocity")
	local bg = Instance.new("BodyGyro")
	bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
	bg.CFrame = hrp.CFrame
	bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
	bg.P = 9e4
	bv.Parent = hrp
	bg.Parent = hrp
	
	for i, child in pairs(character:GetDescendants()) do
		if child:IsA("BasePart") then
			coroutine.wrap(function()
				local con = nil
				con = runservice.Stepped:Connect(function()
					if not flying then
						con:Disconnect()
						child.CanCollide = true
					end
					child.CanCollide = false
				end)
			end)()
		end
	end
	
	local con = nil
	con = runservice.Stepped:Connect(function()
		if not flying then
			con:Disconnect()
			bv:Destroy()
			bg:Destroy()
		end
		
		humanoid.PlatformStand = true
		bv.Velocity = (workspace.Camera.CoordinateFrame.LookVector * ((flycontrol.F - flycontrol.B) * flyspeed)) + (workspace.CurrentCamera.CoordinateFrame.RightVector * ((flycontrol.R - flycontrol.L) * flyspeed)) + (workspace.CurrentCamera.CoordinateFrame.UpVector * ((flycontrol.U - flycontrol.D) * flyspeed))
		bg.CFrame = workspace.Camera.CoordinateFrame
	end)
	
	repeat wait() until not flying
	
	while humanoid.PlatformStand == true do
		humanoid.PlatformStand = false
		task.wait()
	end
end

mouse.KeyDown:Connect(function(key)
	
	if key:lower() == flybutton then
		if flying then
			flying = false
		else
			fly()
		end
	elseif key:lower() == controls.front then
		flycontrol.F = 1
	elseif key:lower() == controls.back then
		flycontrol.B = 1
	elseif key:lower() == controls.right then
		flycontrol.R = 1
	elseif key:lower() == controls.left then
		flycontrol.L = 1
	elseif key:lower() == controls.up then
		flycontrol.U = 1
	elseif key:lower() == controls.down then
		flycontrol.D = 1
	end
end)

mouse.KeyUp:Connect(function(key)
	if key:lower() == controls.front then
		flycontrol.F = 0
	elseif key:lower() == controls.back then
		flycontrol.B = 0
	elseif key:lower() == controls.right then
		flycontrol.R = 0
	elseif key:lower() == controls.left then
		flycontrol.L = 0
	elseif key:lower() == controls.up then
		flycontrol.U = 0
	elseif key:lower() == controls.down then
		flycontrol.D = 0
	end
end)

player.CharacterAdded:Connect(function()
	flying = false
end)
    
    end,
 })
