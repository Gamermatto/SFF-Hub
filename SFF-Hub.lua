-- Verifica l'ID del gioco
print(game.PlaceId)  -- Controlla quale è effettivamente l'ID della mappa

if game.PlaceId == 13772394625 then
    -- Codice per la notifica di successo
    print("SFF Hub loaded correctly")  -- Aggiungi questa per debug

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- Funzione per mostrare la notifica
    function showAchievementNotification(title, text)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SFF Hub loaded",
            Text = "Version 0.2.4",
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

    local AutoParryToggle = MainTab:CreateToggle({
        Name = "Auto Parry",
        CurrentValue = false,
        Flag = "AutoParry", -- A flag is the identifier for the configuration file
        Callback = function(Value)
            local RunService = game:GetService("RunService")
            local Players = game:GetService("Players")
            local VirtualInputManager = game:GetService("VirtualInputManager")

            local Player = Players.LocalPlayer
            local Cooldown = tick()
            local IsParried = false
            local Connection = nil

            -- Funzione per ottenere la palla con l'attributo "realBall"
            local function GetBall()
                for _, Ball in ipairs(workspace.Balls:GetChildren()) do
                    if Ball:GetAttribute("realBall") then
                        return Ball
                    end
                end
            end

            -- Funzione per resettare la connessione
            local function ResetConnection()
                if Connection then
                    Connection:Disconnect()
                    Connection = nil
                end
            end

            -- Resetta la connessione quando viene aggiunta una nuova palla
            workspace.Balls.ChildAdded:Connect(function()
                local Ball = GetBall()
                if Ball then
                    ResetConnection()
                    Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
                        IsParried = false
                    end)
                end
            end)

            -- Funzione per calcolare la finestra di tempo ideale per il parry
            local function CalculateParryWindow(Ball, HRP)
                local Speed = Ball.zoomies.VectorVelocity.Magnitude
                local Distance = (HRP.Position - Ball.Position).Magnitude
                -- Calcola il tempo rimanente prima che la palla colpisca il giocatore
                local TimeToHit = Distance / Speed
                return TimeToHit
            end

            -- Gestione della logica del parry durante la simulazione
            RunService.PreSimulation:Connect(function()
                local Ball, HRP = GetBall(), Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if not Ball or not HRP then return end

                local TimeToHit = CalculateParryWindow(Ball, HRP)

                -- Se la palla è destinata al giocatore e non è già parata, controlla il tempo per il parry
                if Ball:GetAttribute("target") == Player.Name and not IsParried then
                    -- Se la palla è abbastanza vicina e il tempo rimanente è inferiore alla soglia, effettua il parry
                    if TimeToHit <= 0.65 and not IsParried then
                        -- Manda l'input per il click (parry)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        IsParried = true
                        Cooldown = tick()  -- Imposta il cooldown dopo il parry
                    end
                end

                -- Reset della condizione "parried" dopo il cooldown
                if (tick() - Cooldown) >= 1 then
                    IsParried = false
                end
            end)
        end,
    })

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
    local Section = Combat:CreateSection("Combat")  -- Forza la visibilità della sezione

    local Button = CombatTab:CreateButton({
        Name = "Button Example",
        Callback = function()
        -- The function that takes place when the button is pressed
        end,
     })

    local Toggle = CombatTab:CreateToggle({
        Name = "Auto Spam",
        CurrentValue = false,
        Flag = "AutoSpam", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
        -- The function that takes place when the toggle is pressed
        -- The variable (Value) is a boolean on whether the toggle is true or false
        end,
     })
else
    -- Codice per la notifica di errore se PlaceId non corrisponde
    print("SFF Hub not loaded correctly")  -- Aggiungi questa per debug
    
    -- Mostra la notifica di errore
    showAchievementNotification("SFF Hub not loaded correctly", "Discord")
end
