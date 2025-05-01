-- Verifica l'ID del gioco
print(game.PlaceId)  -- Controlla quale è effettivamente l'ID della mappa


--if game.PlaceId == 13772394625 then
    -- Codice per la notifica di successo
    print("SFF Hub loaded correctly")  -- Aggiungi questa per debug

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- Funzione per mostrare la notifica
    function showAchievementNotification(title, text)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SFF Hub loaded",
            Text = "Version 0.2.9.6",
            Icon = "rbxassetid://1234567890", -- Opzionale: sostituisci con un'icona personalizzata
            Duration = 5  -- La durata della notifica in secondi
        })
    end

    -- Mostra la notifica di successo
    showAchievementNotification("SFF Hub loaded correctly", "Discord")

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

    local Slider = MainTab:CreateSlider({
        Name = "WalkSpeed",
        Range = {3, 200},
        Increment = 1,
        Suffix = "Speed",
        CurrentValue = 16,
        Flag = "Slider1", -- A flag is the identifier for the configuration file
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
        end,
    })

    local Dropdown = MainTab:CreateDropdown({
        Name = "Select Test",
        Options = {"Option 1", "Option 2"},
        CurrentOption = {"Option 1"},
        MultipleOptions = false,
        Flag = "Dropdown1", -- A flag is the identifier for the configuration file
        Callback = function(Options)
            print(Options)
        end,
    })

    -- CombatTab
    local CombatTab = Window:CreateTab("Combat", nil)
    local Section = CombatTab:CreateSection("Combat")

    local toggle = CombatTab:CreateToggle({
        Name = "Auto Parry",
        CurrentValue = false,
        Flag = "AutoParry", -- A flag is the identifier for the configuration file
        Callback = function(Value)
            local workspace = game:GetService("Workspace")

            local players = game:GetService("Players")

            local localPlayer = players.LocalPlayer

            local UserInputService = game:GetService("UserInputService")

            local replicatedStorage = game:GetService("ReplicatedStorage")

            local heartbeatConnection



            local function startAutoParry()

                local player = game.Players.LocalPlayer

                local character = player.Character or player.CharacterAdded:Wait()

                local replicatedStorage = game:GetService("ReplicatedStorage")

                local runService = game:GetService("RunService")

                local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress

                local ballsFolder = workspace:WaitForChild("Balls")



                print("Script successfully ran.")



                local function onCharacterAdded(newCharacter)

                    character = newCharacter

                end



                player.CharacterAdded:Connect(onCharacterAdded)



                local focusedBall = nil  



                local function chooseNewFocusedBall()

                    local balls = ballsFolder:GetChildren()

                    focusedBall = nil

                    for _, ball in ipairs(balls) do

                        if ball:GetAttribute("realBall") == true then

                            focusedBall = ball

                            break

                        end

                    end

                end



                chooseNewFocusedBall()



                local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)

                    local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit

                    local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)

                    

                    if velocityTowardsPlayer <= 0 then

                        return math.huge

                    end

                    

                    local distanceToBeCovered = distanceToPlayer - 40

                    return distanceToBeCovered / velocityTowardsPlayer

                end



                local BASE_THRESHOLD = 0.15

                local VELOCITY_SCALING_FACTOR = 0.002



                local function getDynamicThreshold(ballVelocityMagnitude)

                    local adjustedThreshold = BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR)

                    return math.max(0.12, adjustedThreshold)

                end



                local function checkBallDistance()

                    if not character:FindFirstChild("Highlight") then return end

                    local charPos = character.PrimaryPart.Position

                    local charVel = character.PrimaryPart.Velocity



                    if focusedBall and not focusedBall.Parent then

                        chooseNewFocusedBall()

                    end



                    if not focusedBall then return end



                    local ball = focusedBall

                    local distanceToPlayer = (ball.Position - charPos).Magnitude



                    if distanceToPlayer < 10 then

                        parryButtonPress:Fire()

                        return

                    end



                    local timeToImpact = timeUntilImpact(ball.Velocity, distanceToPlayer, charVel)

                    local dynamicThreshold = getDynamicThreshold(ball.Velocity.Magnitude)



                    if timeToImpact < dynamicThreshold then

                        parryButtonPress:Fire()

                    end

                end

                heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()

                    checkBallDistance()

                end)

            end



            local function stopAutoParry()

                if heartbeatConnection then

                    heartbeatConnection:Disconnect()

                    heartbeatConnection = nil

                end

            end



            -- Gui to Lua

            -- Version: 3.2



            -- Instances:



            local ScreenGui = Instance.new("ScreenGui")

            local Frame = Instance.new("Frame")

            local TextLabel = Instance.new("TextLabel")

            local TextButton = Instance.new("TextButton")

            local TextButton_2 = Instance.new("TextButton")



            --Properties:



            ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling



            Frame.Parent = ScreenGui

            Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

            Frame.Position = UDim2.new(0.0833889097, 0, 0.562569201, 0)

            Frame.Size = UDim2.new(0, 230, 0, 160)



            TextLabel.Parent = Frame

            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

            TextLabel.Position = UDim2.new(-0.00203830888, 0, -0.00307044992, 0)

            TextLabel.Size = UDim2.new(0, 230, 0, 25)

            TextLabel.Font = Enum.Font.SourceSans

            TextLabel.Text = "Auto Parry By c5xk on discord"

            TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)

            TextLabel.TextScaled = true

            TextLabel.TextSize = 14.000

            TextLabel.TextWrapped = true



            TextButton.Parent = Frame

            TextButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

            TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)

            TextButton.Position = UDim2.new(0.0700469762, 0, 0.358639956, 0)

            TextButton.Size = UDim2.new(0.321920365, 0, 0.275855243, 0)

            TextButton.Font = Enum.Font.SourceSans

            TextButton.Text = "Enable"

            TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)

            TextButton.TextScaled = true

            TextButton.TextSize = 14.000

            TextButton.TextStrokeTransparency = 0.000

            TextButton.TextWrapped = true



            TextButton_2.Parent = Frame

            TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

            TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)

            TextButton_2.Position = UDim2.new(0.591082573, 0, 0.358639956, 0)

            TextButton_2.Size = UDim2.new(0.321920365, 0, 0.275855243, 0)

            TextButton_2.Font = Enum.Font.SourceSans

            TextButton_2.Text = "Disable"

            TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)

            TextButton_2.TextScaled = true

            TextButton_2.TextSize = 14.000

            TextButton_2.TextStrokeTransparency = 0.000

            TextButton_2.TextWrapped = true



            -- Scripts:



            local function NHOVBS_fake_script() -- Frame.GuiDrag 

                local script = Instance.new('LocalScript', Frame)



                local 	Frame = script.Parent.Parent.Frame

                

                Frame.Draggable = true

                Frame.Active = true

                

                

                

            end

            coroutine.wrap(NHOVBS_fake_script)()

            local function HTPDFXZ_fake_script() -- TextButton.LocalScript 

                local script = Instance.new('LocalScript', TextButton)



                local startButton = script.Parent

                

                startButton.MouseButton1Click:Connect(function()

                    startAutoParry()

                end)

            end

            coroutine.wrap(HTPDFXZ_fake_script)()

            local function ZDNHQM_fake_script() -- TextButton_2.LocalScript 

                local script = Instance.new('LocalScript', TextButton_2)



                local stopButton = script.Parent

                

                stopButton.MouseButton1Click:Connect(function()

                    stopAutoParry()

                end)

            end

            coroutine.wrap(ZDNHQM_fake_script)()
        end,
    })

    local Toggle = CombatTab:CreateToggle({
        Name = "Auto Spam",
        CurrentValue = false,
        Flag = "AutoSpam", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            local RunService = game:GetService("RunService")
            local Players = game:GetService("Players")
            local VirtualInputManager = game:GetService("VirtualInputManager")

            local Player = Players.LocalPlayer
            local SpamMode = false
            local TargetChangeTimestamps = {}
            local TargetChangeThreshold = 5 -- Numero di cambi di target per attivare la Spam Mode
            local TimeWindow = 1 -- Secondi
            local ClickInterval = 0.05 -- Intervallo tra i clic in modalità spam
            local LastClickTime = tick()

            -- Funzione per ottenere la palla con l'attributo "realBall"
            local function GetBall()
                for _, Ball in ipairs(workspace.Balls:GetChildren()) do
                    if Ball:GetAttribute("realBall") then
                        return Ball
                    end
                end
            end

            -- Monitoraggio dei cambi di target della palla
            local function MonitorTargetChanges(Ball)
                Ball:GetAttributeChangedSignal("target"):Connect(function()
                    table.insert(TargetChangeTimestamps, tick())
                    -- Rimuove i timestamp più vecchi del TimeWindow
                    for i = #TargetChangeTimestamps, 1, -1 do
                        if tick() - TargetChangeTimestamps[i] > TimeWindow then
                            table.remove(TargetChangeTimestamps, i)
                        end
                    end
                    if #TargetChangeTimestamps >= TargetChangeThreshold then
                        SpamMode = true
                    else
                        SpamMode = false
                    end
                end)
            end

            -- Gestione della logica dello spam durante la simulazione
            RunService.PreSimulation:Connect(function()
                local Ball = GetBall()
                local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if not Ball or not HRP then return end

                -- Inizia a monitorare i cambi di target
                if not Ball:GetAttribute("Monitoring") then
                    Ball:SetAttribute("Monitoring", true)
                    MonitorTargetChanges(Ball)
                end

                if Ball:GetAttribute("target") == Player.Name and SpamMode then
                    if tick() - LastClickTime >= ClickInterval then
                        -- In modalità spam, clicca costantemente
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        LastClickTime = tick()
                    end
                end
            end)

        end,
    })

    -- Others
    local OthersTab = Window:CreateTab("Others", nil)
    local Section = OthersTab:CreateSection("Others")

    local Paragraph = OthersTab:CreateParagraph({Title = "COMESTATE993", Content = "Owner of this good script."})
    local Paragraph = OthersTab:CreateParagraph({Title = "Verion 0.2.9.5", Content = "Script up to date"})
-- else
--     -- Codice per la notifica di errore se PlaceId non corrisponde
--     print("SFF Hub not loaded correctly")  -- Aggiungi questa per debug
    
--     -- Mostra la notifica di errore
--     showAchievementNotification("SFF Hub not loaded correctly", "Discord")
-- end



