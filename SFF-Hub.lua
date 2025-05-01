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
            Text = "Version 0.2.6",
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
    local Section = CombatTab:CreateSection("Combat")

    local toggle = CombatTab:CreateToggle({
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

            -- Calcolo dinamico della soglia in base alla velocità
            local function GetDynamicParryThreshold(speed)
                -- Se la palla è molto veloce, anticipa leggermente
                if speed >= 200 then
                    return 0.40 -- anticipa un po' per sicurezza
                elseif speed >= 150 then
                    return 0.45
                elseif speed >= 100 then
                    return 0.50
                else
                    return 0.55 -- più precisa, ma rischiosa
                end
            end

            -- Funzione per calcolare il tempo stimato all'impatto
            local function CalculateTimeToHit(Ball, HRP)
                local Speed = Ball.zoomies.VectorVelocity.Magnitude
                local Distance = (HRP.Position - Ball.Position).Magnitude
                local TimeToHit = Distance / Speed
                return TimeToHit, Speed
            end

            -- Gestione della logica del parry durante la simulazione
            RunService.PreSimulation:Connect(function()
                local Ball = GetBall()
                local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if not Ball or not HRP then return end

                local TimeToHit, Speed = CalculateTimeToHit(Ball, HRP)
                local DynamicThreshold = GetDynamicParryThreshold(Speed)

                -- Verifica se la palla è destinata al giocatore
                if Ball:GetAttribute("target") == Player.Name and not IsParried then
                    -- Esegue il parry solo se il tempo all’impatto è inferiore alla soglia calcolata
                    if TimeToHit <= DynamicThreshold then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        IsParried = true
                        Cooldown = tick()
                    end
                end

                -- Reset della possibilità di parare dopo 1 secondo
                if (tick() - Cooldown) >= 1 then
                    IsParried = false
                end
            end)
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
            local Cooldown = tick()
            local IsParried = false
            local Connection = nil
            
            -- Anti-spam setup
            local recentHits = {}
            local spamActive = false
            local SPAM_THRESHOLD = 3        -- colpi ravvicinati richiesti
            local TIME_WINDOW = 1.5         -- secondi entro cui devono avvenire i colpi
            local spamConnection = nil
            
            -- Ottieni la palla
            local function GetBall()
                for _, Ball in ipairs(workspace.Balls:GetChildren()) do
                    if Ball:GetAttribute("realBall") then
                        return Ball
                    end
                end
            end
            
            -- Reset connessione
            local function ResetConnection()
                if Connection then
                    Connection:Disconnect()
                    Connection = nil
                end
            end
            
            -- Calcolo finestra parry
            local function CalculateParryWindow(Ball, HRP)
                local Speed = Ball.zoomies.VectorVelocity.Magnitude
                local Distance = (HRP.Position - Ball.Position).Magnitude
                return Distance / Speed
            end
            
            -- Funzione spam click
            local function StartSpamClick()
                if spamConnection then return end -- già attivo
                spamActive = true
                spamConnection = RunService.RenderStepped:Connect(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.01) -- intervallo velocissimo
                end)
            end
            
            local function StopSpamClick()
                if spamConnection then
                    spamConnection:Disconnect()
                    spamConnection = nil
                end
                spamActive = false
            end
            
            -- Gestione auto parry
            RunService.PreSimulation:Connect(function()
                local Ball = GetBall()
                local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if not Ball or not HRP then return end
            
                local TimeToHit = CalculateParryWindow(Ball, HRP)
            
                -- Se destinata al giocatore
                if Ball:GetAttribute("target") == Player.Name then
                    -- Registra l’evento
                    table.insert(recentHits, tick())
                    -- Pulisce eventi vecchi
                    for i = #recentHits, 1, -1 do
                        if tick() - recentHits[i] > TIME_WINDOW then
                            table.remove(recentHits, i)
                        end
                    end
            
                    -- Attiva spam mode se troppe hit ravvicinate
                    if #recentHits >= SPAM_THRESHOLD and not spamActive then
                        StartSpamClick()
                    end
            
                    -- Parry normale
                    if not IsParried and TimeToHit <= 0.65 then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        IsParried = true
                        Cooldown = tick()
                    end
                end
            
                -- Cooldown reset
                if (tick() - Cooldown) >= 1 then
                    IsParried = false
                end
            
                -- Spegni spam se non riceve colpi per un po’
                if #recentHits > 0 and (tick() - recentHits[#recentHits]) > TIME_WINDOW then
                    recentHits = {}
                    StopSpamClick()
                end
            end)
            
            -- Monitoraggio nuove palle
            workspace.Balls.ChildAdded:Connect(function()
                local Ball = GetBall()
                if Ball then
                    ResetConnection()
                    Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
                        IsParried = false
                    end)
                end
            end)
            
        end,
    })

    -- Others
    local OthersTab = Window:CreateTab("Others", nil)
    local Section = OthersTab:CreateSection("Others")

    local Label = OthersTabTab:CreateLabel("Credits", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
    local Paragraph = Tab:CreateParagraph({Title = "COMESTATE993", Content = "Owner of this good script."})

else
    -- Codice per la notifica di errore se PlaceId non corrisponde
    print("SFF Hub not loaded correctly")  -- Aggiungi questa per debug
    
    -- Mostra la notifica di errore
    showAchievementNotification("SFF Hub not loaded correctly", "Discord")
end



