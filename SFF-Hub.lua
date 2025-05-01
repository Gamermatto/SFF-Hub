--if game.PlaceId == 13772394625 then
-- Funzione per mostrare la notifica
function showAchievementNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SFF Hub loaded correctly",
        Text = "You can find a key in our Discord!",
        Icon = "rbxassetid://1234567890", -- Opzionale: sostituisci con un'icona personalizzata
        Duration = 5  -- La durata della notifica in secondi
    })
end

-- Quando vuoi mostrare la notifica, chiama la funzione
showAchievementNotification()

task.wait(7)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

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
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"https://pastebin.com/raw/0hCfHjs8"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

--MainTab
local MainTab = Window:CreateTab("Home", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Main")



local Toggle = MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      loadstring(game:HttpGet("https://pastebin.com/raw/TV83kUPv", true))()
   end,
})

 local Slider = MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {3, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Dropdown = MainTab:CreateDropdown({
   Name = "Select Test",
   Options = {"Option 1","Option 2"},
   CurrentOption = {"Option 1"},
   MultipleOptions = false,
   Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
     print(Options)
   end,
})

-- CombatTab
local Combat = Window:CreateTab("Combat", nil) -- Title, Image
local CombatSection = CombatTab:CreateSection("Combat")
