-- Verifica l'ID del gioco
print(game.PlaceId)  -- Controlla quale è effettivamente l'ID della mappa


--if game.PlaceId == 13772394625 then
    -- Codice per la notifica di successo
    print("SFF Hub loaded correctly")  -- Aggiungi questa per debug

   local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
   
   local Players = game:GetService("Players")
   local player = Players.LocalPlayer

   -- Funzione per mostrare la notifica
   function showAchievementNotification()
       game:GetService("StarterGui"):SetCore("SendNotification", {
           Title = "SFF Hub loaded correctly",
           Text = "Discord",
           Icon = "rbxassetid://1234567890", -- Opzionale: sostituisci con un'icona personalizzata
           Duration = 5  -- La durata della notifica in secondi
       })
   end

   -- Mostra la notifica
   showAchievementNotification()

   -- Aspetta 7 secondi prima di creare la finestra
   task.wait(6)

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
           Note = "c", -- Use this to tell the user how to get a key
           FileName = "SFF Hub | Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
           SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
           GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
           Key = {"https://pastebin.com/raw/0hCfHjs8"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
       }
   })

   -- MainTab
   local MainTab = Window:CreateTab("Home", nil) -- Title, Image
   local MainSection = MainTab:CreateSection("Main")

   local Toggle = MainTab:CreateToggle({
       Name = "Fly",
       CurrentValue = false,
       Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
       Callback = function(Value)
        local Debug = true -- Set this to true if you want my debug output.
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")

        local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
        local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9) -- A second argument in waitforchild what could it mean?
        local Balls = workspace:WaitForChild("Balls", 9e9)

        -- Functions

        local function print(...) -- Debug print.
            if Debug then
                warn(...)
            end
        end

        local function VerifyBall(Ball) -- Returns nil if the ball isn't a valid projectile; true if it's the right ball.
            if typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true then
                return true
            end
        end

        local function IsTarget() -- Returns true if we are the current target.
            return (Player.Character and Player.Character:FindFirstChild("Highlight"))
        end

        local function Parry() -- Parries.
            Remotes:WaitForChild("ParryButtonPress"):Fire()
        end

        -- The actual code

        Balls.ChildAdded:Connect(function(Ball)
            if not VerifyBall(Ball) then
                return
            end
            
            print(`Ball Spawned: {Ball}`)
            
            local OldPosition = Ball.Position
            local OldTick = tick()
            
            Ball:GetPropertyChangedSignal("Position"):Connect(function()
                if IsTarget() then -- No need to do the math if we're not being attacked.
                    local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
                    local Velocity = (OldPosition - Ball.Position).Magnitude -- Fix for .Velocity not working. Yes I got the lowest possible grade in accuplacer math.
                    
                    print(`Distance: {Distance}\nVelocity: {Velocity}\nTime: {Distance / Velocity}`)
                
                    if (Distance / Velocity) <= 10 then -- Sorry for the magic number. This just works. No, you don't get a slider for this because it's 2am.
                        Parry()
                    end
                end
                
                if (tick() - OldTick >= 1/60) then -- Don't want it to update too quickly because my velocity implementation is aids. Yes, I tried Ball.Velocity. No, it didn't work.
                    OldTick = tick()
                    OldPosition = Ball.Position
                end
            end)
        end)
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
       Options = {"Option 1", "Option 2"},
       CurrentOption = {"Option 1"},
       MultipleOptions = false,
       Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
       Callback = function(Options)
           print(Options)
       end,
   })

   -- CombatTab
    local Combat = Window:CreateTab("Combat", nil)
    local CombatSection = Combat:CreateSection("Combat", {Visible = true})  -- Forza la visibilità della sezione


   local Toggle = CombatSection:CreateToggle({
       Name = "Auto Parry",
       CurrentValue = false,
       Flag = "AutoParry", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
       Callback = function(Value)
           
       end,
   })
else
    -- Codice per la notifica di errore se PlaceId non corrisponde
    print("SFF Hub not loaded correctly")  -- Aggiungi questa per debug
    
    -- Funzione per mostrare la notifica di errore
    function showAchievementNotification()
        print("Mostra la notifica di errore")  -- Aggiungi per debug
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SFF Hub not loaded correctly",
            Text = "Discord",
            Icon = "rbxassetid://1234567890",  -- Opzionale: sostituisci con un'icona personalizzata
            Duration = 5  -- La durata della notifica in secondi
        })
    end

    -- Mostra la notifica di errore
    showAchievementNotification()
end
