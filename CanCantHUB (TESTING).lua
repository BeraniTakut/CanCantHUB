-- Unnamed Shooter
if game.PlaceId == 17887390746 then
    local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
    local GUI = Mercury:Create{
        Name = "CanCantHUB",
        Size = UDim2.fromOffset(600, 400),
        Theme = Mercury.Themes.Dark,
        Link = "Unnamed Shooter"
    }
    local PlayerTab = GUI:Tab{
        Name = "PLAYER",
        Icon = "rbxassetid://"
    }
    local ESPTab = GUI:Tab{
        Name = "ESP",
        Icon = "rbxassetid://"
    }
    local AimbotTab = GUI:Tab{
        Name = "AIMBOT",
        Icon = "rbxassetid://"
    }    
    
    -- WalkSpeed Slider
    PlayerTab:Slider{
        Name = "WalkSpeed",
        Default = 16,
        Min = 16,
        Max = 500,
        Description = "Changes the player's WalkSpeed.",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    }
    -- JumpPower Slider
    PlayerTab:Slider{
        Name = "JumpPower",
        Default = 50,
        Min = 50,
        Max = 500,
        Description = "Changes the player's JumpPower.",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    }   

    -- Terbang
    PlayerTab:Button{
        Name = "Fly",
        Description = "Make the player Fly | Toggle E to Fly On/Off.",
        Callback = function()
            local UIS = game:GetService("UserInputService")
            local StarterGui = game:GetService("StarterGui")
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:WaitForChild("Humanoid")
            
            local flying = false
            local maxSpeed = 100
            local control = {f = 0, b = 0, l = 0, r = 0}
            local bg, bv
            
            local function createBodyGyro()
                local bg = Instance.new("BodyGyro")
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = humanoidRootPart.CFrame
                bg.Parent = humanoidRootPart
                return bg
            end
            
            local function createBodyVelocity()
                local bv = Instance.new("BodyVelocity")
                bv.velocity = Vector3.new(0, 0.1, 0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Parent = humanoidRootPart
                return bv
            end
            
            local function startFlying()
                humanoid.PlatformStand = true
                bg = createBodyGyro()
                bv = createBodyVelocity()
            end
            
            local function stopFlying()
                humanoid.PlatformStand = false
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
            end
            
            local function flyLoop()
                while flying do
                    local speed = maxSpeed
                    local moveVector = (game.Workspace.CurrentCamera.CFrame.lookVector * (control.f + control.b)) +
                                       ((game.Workspace.CurrentCamera.CFrame * CFrame.new(control.l + control.r, (control.f + control.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CFrame.p)
                    bv.velocity = moveVector * speed
                    bg.cframe = game.Workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((control.f + control.b) * 50 * speed / maxSpeed), 0, 0)
                    wait()
                end
            end
            
            local function onCharacterAdded(char)
                character = char
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                humanoid = character:WaitForChild("Humanoid")
                
                if flying then
                    startFlying()
                    coroutine.wrap(flyLoop)()
                end
            end
            
            player.CharacterAdded:Connect(onCharacterAdded)
            
            local mouse = player:GetMouse()
            
            mouse.KeyDown:Connect(function(key)
                if key:lower() == "e" then
                    flying = not flying
                    if flying then
                        startFlying()
                        coroutine.wrap(flyLoop)()
                    else
                        stopFlying()
                    end
                elseif key:lower() == "w" then
                    control.f = 1
                elseif key:lower() == "s" then
                    control.b = -1
                elseif key:lower() == "a" then
                    control.l = -1
                elseif key:lower() == "d" then
                    control.r = 1
                end
            end)
            
            mouse.KeyUp:Connect(function(key)
                if key:lower() == "w" then
                    control.f = 0
                elseif key:lower() == "s" then
                    control.b = 0
                elseif key:lower() == "a" then
                    control.l = 0
                elseif key:lower() == "d" then
                    control.r = 0
                end
            end)
            
            if flying then
                startFlying()
                coroutine.wrap(flyLoop)()
            end
        end
    }

        -- No-Clip
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
    
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
    
        local noClipEnabled = false
    
        local function toggleNoClip(state)
            noClipEnabled = state
            if noClipEnabled then
                RunService.Stepped:Connect(function()
                    if noClipEnabled and character and humanoid then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if character and humanoid then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    
        PlayerTab:Toggle{
            Name = "No-Clip",
            StartingState = false,
            Description = "allows you to penetrate objects",
            Callback = function(state)
                toggleNoClip(state)
            end
        }
    
        -- Ensure No-Clip is disabled on respawn
        player.CharacterAdded:Connect(function(char)
            character = char
            humanoid = character:WaitForChild("Humanoid")
            if not noClipEnabled then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)

    -- Hitbox
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Teams = game:GetService("Teams")

    -- Variabel untuk menyimpan status toggle dan ukuran hitbox
    local hitboxEnabled = false
    local hitboxSize = Vector3.new(15, 15, 15) -- Ukuran hitbox default

    local function modifyHitbox(player)
        if player and player.Character and hitboxEnabled then
            local rootPart = player.Character:WaitForChild("HumanoidRootPart")
            if rootPart then
                rootPart.Size = hitboxSize -- Ukuran hitbox berdasarkan slider
                rootPart.Transparency = 0.5 -- Membuat hitbox setengah transparan
            end
        end
    end

    local function resetHitbox(player)
        if player and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Size = Vector3.new(2, 2, 1) -- Ukuran hitbox default
                rootPart.Transparency = 1 -- Membuat hitbox tidak transparan
            end
        end
    end

    local function onCharacterAdded(character)
        local player = Players:GetPlayerFromCharacter(character)
        if player and player ~= LocalPlayer then
            -- Periksa apakah player berada di tim yang sama atau tidak
            if not Teams or not LocalPlayer.Team or player.Team ~= LocalPlayer.Team then
                modifyHitbox(player)
            end
        end
    end

    local function onPlayerAdded(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(onCharacterAdded)
            -- Modifikasi hitbox jika karakter sudah ada
            if player.Character then
                onCharacterAdded(player.Character)
            end
        end
    end

    -- Modifikasi hitbox semua pemain yang sudah ada dalam game
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    -- Hubungkan fungsi onPlayerAdded ke event PlayerAdded
    Players.PlayerAdded:Connect(onPlayerAdded)

    -- Toggle untuk mengaktifkan/menonaktifkan modifikasi hitbox
    PlayerTab:Toggle{
        Name = "Hitbox",
        StartingState = false,
        Description = "Enlarges the player's hitbox",
        Callback = function(state)
            hitboxEnabled = state
            if not state then
                -- Reset semua hitbox jika dinonaktifkan
                for _, player in ipairs(Players:GetPlayers()) do
                    resetHitbox(player)
                end
            else
                -- Modifikasi hitbox semua pemain jika diaktifkan
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character then
                        onCharacterAdded(player.Character)
                    end
                end
            end
        end
    }
    
    -- ESP
    -- Local player
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    -- Konfigurasi
    local ESP_ENABLED = false
    local SHOW_PLAYER_NAMES = true
    local SHOW_HEALTH_INDICATOR = true
    local SHOW_DISTANCE = true
    local MAX_DISTANCE = 1000
    local NAME_POSITION = "Head"
    local NAME_TEXT_SIZE = 10
    local HEALTH_TEXT_SIZE = 10
    local DISTANCE_TEXT_SIZE = 10
    local DISTANCE_COLOR = Color3.fromRGB(255, 255, 0)
    local ESP_METHOD = nil

    -- Fungsi untuk mendapatkan warna tim dengan pengecekan tim kosong
    local function GetTeamColor(Player)
        if Player.Team then
            local teamPlayers = Players:GetPlayers()
            local teamHasPlayers = false
            for _, teamPlayer in ipairs(teamPlayers) do
                if teamPlayer.Team == Player.Team then
                    teamHasPlayers = true
                    break
                end
            end
            if teamHasPlayers then
                return Player.Team.TeamColor.Color
            end
        end
        return Color3.new(1, 1, 1)
    end

    -- Fungsi untuk membuat ESP dengan metode Highlight
    local function CreateHighlightESP(Player)
        if Player.Character then
            local Highlight = Instance.new("Highlight")
            Highlight.Adornee = Player.Character
            Highlight.FillColor = Color3.new(0, 0, 0)
            Highlight.OutlineColor = GetTeamColor(Player)
            Highlight.OutlineTransparency = 0
            Highlight.FillTransparency = 1
            Highlight.Parent = Player.Character

            local BillboardGui = Instance.new("BillboardGui")
            BillboardGui.Size = UDim2.new(0, 200, 0, 60)
            BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Name = "PlayerInfo"

            local PositionOffset
            if NAME_POSITION == "Center" then
                PositionOffset = Vector3.new(0, -2, 0)
            elseif NAME_POSITION == "Feet" then
                PositionOffset = Vector3.new(0, -5, 0)
            else
                PositionOffset = Vector3.new(0, 2, 0)
            end

            local HealthLabel = Instance.new("TextLabel")
            HealthLabel.Parent = BillboardGui
            HealthLabel.Name = "HealthLabel"
            HealthLabel.Size = UDim2.new(1, 0, 0.33, 0)
            HealthLabel.BackgroundTransparency = 1
            HealthLabel.TextStrokeTransparency = 0
            HealthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            HealthLabel.TextScaled = false
            HealthLabel.TextSize = HEALTH_TEXT_SIZE
            HealthLabel.Position = UDim2.new(0, 0, 0, 0)
            HealthLabel.TextYAlignment = Enum.TextYAlignment.Bottom

            local NameLabel = Instance.new("TextLabel")
            NameLabel.Parent = BillboardGui
            NameLabel.Name = "NameLabel"
            NameLabel.Size = UDim2.new(1, 0, 0.33, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.TextColor3 = GetTeamColor(Player)
            NameLabel.TextStrokeTransparency = 0
            NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            NameLabel.TextScaled = false
            NameLabel.TextSize = NAME_TEXT_SIZE
            NameLabel.Position = UDim2.new(0, 0, 0.33, 0)
            NameLabel.TextYAlignment = Enum.TextYAlignment.Center
            NameLabel.Text = Player.Name

            local DistanceLabel = Instance.new("TextLabel")
            DistanceLabel.Parent = BillboardGui
            DistanceLabel.Name = "DistanceLabel"
            DistanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
            DistanceLabel.BackgroundTransparency = 1
            DistanceLabel.TextColor3 = DISTANCE_COLOR
            DistanceLabel.TextStrokeTransparency = 0
            DistanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            DistanceLabel.TextScaled = false
            DistanceLabel.TextSize = DISTANCE_TEXT_SIZE
            DistanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
            DistanceLabel.TextYAlignment = Enum.TextYAlignment.Top

            local targetHealth = 100
            local displayedHealth = 100

            local function UpdateHealth()
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    targetHealth = Player.Character.Humanoid.Health
                end
            end

            UpdateHealth()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.HealthChanged:Connect(UpdateHealth)
            end

            RunService.RenderStepped:Connect(function()
                if ESP_ENABLED and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    displayedHealth = displayedHealth + (targetHealth - displayedHealth) * 0.1

                    local healthRatio = displayedHealth / Player.Character.Humanoid.MaxHealth
                    local color = Color3.new(1 - healthRatio, healthRatio, 0)

                    HealthLabel.Text = "(" .. math.floor(displayedHealth) .. ")"
                    HealthLabel.TextColor3 = color

                    local distance = (Player.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                    DistanceLabel.Text = string.format("%.1f studs", distance)

                    NameLabel.Visible = SHOW_PLAYER_NAMES
                    HealthLabel.Visible = SHOW_HEALTH_INDICATOR
                    DistanceLabel.Visible = SHOW_DISTANCE
                end
            end)

            BillboardGui.Adornee = Player.Character:FindFirstChild(NAME_POSITION) or Player.Character.PrimaryPart
            BillboardGui.StudsOffset = PositionOffset
            BillboardGui.Parent = Player.Character
        end
    end

    -- Fungsi untuk membuat ESP dengan metode Drawing Box
    local function CreateDrawingBoxESP(Player)
        if Player.Character then
            local BillboardGui = Instance.new("BillboardGui")
            BillboardGui.Size = UDim2.new(0, 200, 0, 60)
            BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Name = "PlayerInfo"

            local PositionOffset
            if NAME_POSITION == "Center" then
                PositionOffset = Vector3.new(0, -2, 0)
            elseif NAME_POSITION == "Feet" then
                PositionOffset = Vector3.new(0, -5, 0)
            else
                PositionOffset = Vector3.new(0, 2, 0)
            end

            local HealthLabel = Instance.new("TextLabel")
            HealthLabel.Parent = BillboardGui
            HealthLabel.Name = "HealthLabel"
            HealthLabel.Size = UDim2.new(1, 0, 0.33, 0)
            HealthLabel.BackgroundTransparency = 1
            HealthLabel.TextStrokeTransparency = 0
            HealthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            HealthLabel.TextScaled = false
            HealthLabel.TextSize = HEALTH_TEXT_SIZE
            HealthLabel.Position = UDim2.new(0, 0, 0, 0)
            HealthLabel.TextYAlignment = Enum.TextYAlignment.Bottom

            local NameLabel = Instance.new("TextLabel")
            NameLabel.Parent = BillboardGui
            NameLabel.Name = "NameLabel"
            NameLabel.Size = UDim2.new(1, 0, 0.33, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.TextColor3 = GetTeamColor(Player)
            NameLabel.TextStrokeTransparency = 0
            NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            NameLabel.TextScaled = false
            NameLabel.TextSize = NAME_TEXT_SIZE
            NameLabel.Position = UDim2.new(0, 0, 0.33, 0)
            NameLabel.TextYAlignment = Enum.TextYAlignment.Center
            NameLabel.Text = Player.Name

            local DistanceLabel = Instance.new("TextLabel")
            DistanceLabel.Parent = BillboardGui
            DistanceLabel.Name = "DistanceLabel"
            DistanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
            DistanceLabel.BackgroundTransparency = 1
            DistanceLabel.TextColor3 = DISTANCE_COLOR
            DistanceLabel.TextStrokeTransparency = 0
            DistanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            DistanceLabel.TextScaled = false
            DistanceLabel.TextSize = DISTANCE_TEXT_SIZE
            DistanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
            DistanceLabel.TextYAlignment = Enum.TextYAlignment.Top

            local targetHealth = 100
            local displayedHealth = 100

            local function UpdateHealth()
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    targetHealth = Player.Character.Humanoid.Health
                end
            end

            UpdateHealth()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.HealthChanged:Connect(UpdateHealth)
            end

            -- Create Drawing Box
            local Box = Drawing.new("Square")
            Box.Visible = true
            Box.Thickness = 2
            Box.Transparency = 1
            Box.Color = GetTeamColor(Player)

            RunService.RenderStepped:Connect(function()
                if ESP_ENABLED and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    displayedHealth = displayedHealth + (targetHealth - displayedHealth) * 0.1

                    local healthRatio = displayedHealth / Player.Character.Humanoid.MaxHealth
                    local color = Color3.new(1 - healthRatio, healthRatio, 0)

                    HealthLabel.Text = "(" .. math.floor(displayedHealth) .. ")"
                    HealthLabel.TextColor3 = color

                    local distance = (Player.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                    DistanceLabel.Text = string.format("%.1f studs", distance)

                    NameLabel.Visible = SHOW_PLAYER_NAMES
                    HealthLabel.Visible = SHOW_HEALTH_INDICATOR
                    DistanceLabel.Visible = SHOW_DISTANCE

                    -- Update Drawing Box
                    local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
                    if RootPart then
                        local RootPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
                        if onScreen then
                            local HeadPos = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.Head.Position)
                            local LegPos = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))

                            Box.Size = Vector2.new(2000 / distance, HeadPos.Y - LegPos.Y)
                            Box.Position = Vector2.new(RootPos.X - Box.Size.X / 2, RootPos.Y - Box.Size.Y / 2)
                            Box.Visible = true
                        else
                            Box.Visible = false
                        end
                    end
                else
                    Box.Visible = false
                end
            end)

            BillboardGui.Adornee = Player.Character:FindFirstChild(NAME_POSITION) or Player.Character.PrimaryPart
            BillboardGui.StudsOffset = PositionOffset
            BillboardGui.Parent = Player.Character
        end
    end

    -- Fungsi untuk memperbarui warna indikator jarak pada semua pemain
    local function UpdateDistanceIndicatorColor()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                Player.Character.PlayerInfo.DistanceLabel.TextColor3 = DISTANCE_INDICATOR_COLOR
            end
        end
    end

    -- Fungsi untuk membersihkan ESP
    local function ClearESP()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                Player.Character.PlayerInfo:Destroy()
            end
            if Player.Character and Player.Character:FindFirstChild("Highlight") then
                Player.Character.Highlight:Destroy()
            end
        end
    end

    -- Fungsi untuk mengaktifkan ESP
    local function ToggleESP(state)
        ESP_ENABLED = state
        if ESP_ENABLED then
            for _, Player in pairs(Players:GetPlayers()) do
                if ESP_METHOD == "Highlight" then
                    CreateHighlightESP(Player)
                elseif ESP_METHOD == "DrawingBox" then
                    CreateDrawingBoxESP(Player)
                end
            end
        else
            ClearESP()
        end
    end

    -- Menambah event listener untuk player baru
    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function()
            if ESP_ENABLED then
                wait(1) -- Tunggu sebentar agar karakter terload
                if ESP_METHOD == "Highlight" then
                    CreateHighlightESP(Player)
                elseif ESP_METHOD == "DrawingBox" then
                    CreateDrawingBoxESP(Player)
                end
            end
        end)
    end)

    -- Event listener untuk player yang ada
    for _, Player in pairs(Players:GetPlayers()) do
        Player.CharacterAdded:Connect(function()
            if ESP_ENABLED then
                wait(1) -- Tunggu sebentar agar karakter terload
                if ESP_METHOD == "Highlight" then
                    CreateHighlightESP(Player)
                elseif ESP_METHOD == "DrawingBox" then
                    CreateDrawingBoxESP(Player)
                end
            end
        end)
    end

    -- Dropdown untuk memilih metode ESP
    local MyDropdown = ESPTab:Dropdown{
        Name = "ESP Method",
        StartingText = "Select...",
        Description = "Select ESP Method",
        Items = {
            {"Highlight", "Highlight"},
            {"Box", "DrawingBox"}
        },
        Callback = function(item)
            ESP_METHOD = item
            if ESP_ENABLED then
                ClearESP()
                for _, Player in pairs(Players:GetPlayers()) do
                    if ESP_METHOD == "Highlight" then
                        CreateHighlightESP(Player)
                    elseif ESP_METHOD == "DrawingBox" then
                        CreateDrawingBoxESP(Player)
                    end
                end
            end
        end
    }

    -- Implementasi toggle untuk ESP
    ESPTab:Toggle{
        Name = "ESP",
        StartingState = false,
        Description = "Toggle ESP On/Off",
        Callback = function(state)
            ToggleESP(state)
            if state then
                print("ESP On")
            else
                print("ESP Off")
            end
        end
    }

    -- Slider untuk mengatur ukuran teks nama pemain
    ESPTab:Slider{
        Name = "Name Text Size",
        Default = 10,
        Min = 0,
        Max = 20,
        Description = "Changes text size name",
        Callback = function(value)
            NAME_TEXT_SIZE = value
            for _, Player in pairs(Players:GetPlayers()) do
                if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                    Player.Character.PlayerInfo.NameLabel.TextSize = NAME_TEXT_SIZE
                end
            end
        end
    }

    -- Slider untuk mengatur ukuran teks indikator darah
    ESPTab:Slider{
        Name = "Health Text Size",
        Default = 10,
        Min = 0,
        Max = 20,
        Description = "Changes text size health",
        Callback = function(value)
            HEALTH_TEXT_SIZE = value
            for _, Player in pairs(Players:GetPlayers()) do
                if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                    Player.Character.PlayerInfo.HealthLabel.TextSize = HEALTH_TEXT_SIZE
                end
            end
        end
    }

    -- Slider untuk mengatur ukuran teks jarak pemain
    ESPTab:Slider{
        Name = "Distance Text Size",
        Default = 10,
        Min = 0,
        Max = 20,
        Description = "Changes text size distance",
        Callback = function(value)
            DISTANCE_TEXT_SIZE = value
            for _, Player in pairs(Players:GetPlayers()) do
                if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                    Player.Character.PlayerInfo.DistanceLabel.TextSize = DISTANCE_TEXT_SIZE
                end
            end
        end
    }

    -- Implementasi toggle untuk menampilkan nama pemain
    ESPTab:Toggle{
        Name = "Show Player Names",
        StartingState = true,
        Description = "Toggle showing player names",
        Callback = function(state)
            SHOW_PLAYER_NAMES = state
            for _, Player in pairs(Players:GetPlayers()) do
                if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                    Player.Character.PlayerInfo.NameLabel.Visible = SHOW_PLAYER_NAMES
                end
            end
        end
    }

    -- Implementasi toggle untuk menampilkan indikator darah
    ESPTab:Toggle{
        Name = "Show Health Indicator",
        StartingState = true,
        Description = "Toggle showing health indicator",
        Callback = function(state)
            SHOW_HEALTH_INDICATOR = state
            for _, Player in pairs(Players:GetPlayers()) do
                if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                    Player.Character.PlayerInfo.HealthLabel.Visible = SHOW_HEALTH_INDICATOR
                end
            end
        end
    }

    -- Implementasi toggle untuk menampilkan jarak pemain
    ESPTab:Toggle{
        Name = "Show Distance Indicator",
        StartingState = true,
        Description = "Toggle showing player distance",
        Callback = function(state)
            SHOW_DISTANCE = state
            for _, Player in pairs(Players:GetPlayers()) do
                if Player.Character and Player.Character:FindFirstChild("PlayerInfo") then
                    Player.Character.PlayerInfo.DistanceLabel.Visible = SHOW_DISTANCE
                end
            end
        end
    }

    -- Color picker untuk pemilihan warna indikator distance
    ESPTab:ColorPicker{
        Name = "Distance Indicator Color",
        Style = Mercury.ColorPickerStyles.Legacy,
        Default = DISTANCE_INDICATOR_COLOR,
        Description = "Choose color for distance indicator",
        Callback = function(color)
            DISTANCE_INDICATOR_COLOR = color
            UpdateDistanceIndicatorColor()
        end
    }

    -- Implementasi slider untuk jarak ESP
    ESPTab:Slider{
        Name = "ESP Distance",
        Default = 1000,
        Min = 0,
        Max = 5000,
        Description = "Changes how far the ESP distance",
        Callback = function(value)
            MAX_DISTANCE = value
        end
    }

    -- Event listener untuk PlayerAdded dan CharacterAdded untuk memperbarui warna indikator jarak
    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(Character)
            -- Tunggu hingga PlayerInfo dan DistanceLabel tersedia
            local PlayerInfo = Character:WaitForChild("PlayerInfo", 10)
            if PlayerInfo then
                local DistanceLabel = PlayerInfo:WaitForChild("DistanceLabel", 10)
                if DistanceLabel then
                    DistanceLabel.TextColor3 = DISTANCE_INDICATOR_COLOR
                end
            end
        end)
    end)

    -- Untuk pemain yang sudah ada saat skrip dimulai
    for _, Player in pairs(Players:GetPlayers()) do
        Player.CharacterAdded:Connect(function(Character)
            -- Tunggu hingga PlayerInfo dan DistanceLabel tersedia
            local PlayerInfo = Character:WaitForChild("PlayerInfo", 10)
            if PlayerInfo then
                local DistanceLabel = PlayerInfo:WaitForChild("DistanceLabel", 10)
                if DistanceLabel then
                    DistanceLabel.TextColor3 = DISTANCE_INDICATOR_COLOR
                end
            end
        end)
        -- Jika karakter sudah ada saat skrip dimulai
        if Player.Character then
            local PlayerInfo = Player.Character:FindFirstChild("PlayerInfo")
            if PlayerInfo then
                local DistanceLabel = PlayerInfo:FindFirstChild("DistanceLabel")
                if DistanceLabel then
                    DistanceLabel.TextColor3 = DISTANCE_INDICATOR_COLOR
                end
            end
        end
    end
    
    -- Aimbot
    -- Ambil kamera dan pemain lokal
    local camera = game.Workspace.CurrentCamera
    local player = game.Players.LocalPlayer

    -- Variable untuk menyimpan status locking
    local isLocking = false
    local targetPlayer = nil
    local targetPart = nil

    -- Radius maksimum dari cursor mouse untuk mengunci pemain
    local maxLockDistance = 100  -- Default value, bisa disesuaikan melalui slider
    local lockRadius = 50  -- Default value, bisa disesuaikan melalui slider
    local interpolationSpeed = 0.1  -- Default value, bisa disesuaikan melalui textbox

    -- Buat GUI lingkaran radius
    local circleGui = Drawing.new("Circle")
    circleGui.Visible = false  -- Mulai dengan tidak terlihat
    circleGui.Radius = lockRadius
    circleGui.Thickness = 2
    circleGui.Transparency = 1
    circleGui.Color = Color3.fromRGB(255, 255, 255)  -- Warna putih saat tidak terkunci

    -- Fungsi untuk memperbarui posisi GUI lingkaran radius
    local function updateCircleGui()
        local mousePosition = game:GetService("UserInputService"):GetMouseLocation()
        circleGui.Position = Vector2.new(mousePosition.X, mousePosition.Y)
    end

    -- Fungsi untuk mencari bagian terdekat dari pemain yang masih hidup dalam radius maksimum dari cursor mouse dan kamera
    local function findNearestLivingPartInRadius(mousePosition)
        local nearestPlayer = nil
        local nearestPart = nil
        local nearestDistance = math.huge

        -- Ambil posisi kursor mouse di dunia game
        local ray = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
        local mouseWorldPosition = ray.Origin + ray.Direction * maxLockDistance

        -- Hitung jarak dari bagian pemain ke posisi kursor mouse dan kamera
        local function calculateDistanceToPart(part)
            local partPosition = part.Position
            -- Jarak dari bagian pemain ke posisi kursor mouse dan kamera
            local distance = (partPosition - mouseWorldPosition).Magnitude
            return distance
        end

        -- Mengecek apakah bagian pemain terlihat dari sudut pandang kamera
        local function isPartVisible(part)
            -- Raycast dari kamera ke bagian pemain
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {part.Parent}
            raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
            local raycastResult = workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position, raycastParams)
            if raycastResult and raycastResult.Instance == part then
                return true
            end
            return false
        end

        -- Loop semua pemain
        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player then
                local character = otherPlayer.Character
                if character then
                    -- Cari berbagai jenis humanoid
                    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        -- Periksa apakah pemain berada di tim yang sama (hanya jika ada tim)
                        if not otherPlayer.Team or otherPlayer.Team ~= player.Team then
                            -- Prioritaskan kepala terlebih dahulu
                            local head = character:FindFirstChild("Head")
                            if head and isPartVisible(head) then
                                local distance = calculateDistanceToPart(head)
                                if distance <= maxLockDistance then
                                    local screenPosition, onScreen = camera:WorldToViewportPoint(head.Position)
                                    local cursorDistance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(mousePosition.X, mousePosition.Y)).Magnitude
                                    if cursorDistance <= lockRadius then
                                        if not nearestPlayer or distance < nearestDistance then
                                            nearestDistance = distance
                                            nearestPlayer = otherPlayer
                                            nearestPart = head
                                            continue -- Langsung lanjut ke pemain berikutnya, tidak perlu cek bagian lain
                                        end
                                    end
                                end
                            end

                            -- Jika tidak ada kepala yang cocok, periksa bagian lainnya
                            for _, part in ipairs(character:GetChildren()) do
                                if part:IsA("BasePart") and part ~= head then
                                    local distance = calculateDistanceToPart(part)
                                    if distance <= maxLockDistance and isPartVisible(part) then
                                        local screenPosition, onScreen = camera:WorldToViewportPoint(part.Position)
                                        local cursorDistance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(mousePosition.X, mousePosition.Y)).Magnitude
                                        if cursorDistance <= lockRadius then
                                            if not nearestPlayer or distance < nearestDistance then
                                                nearestDistance = distance
                                                nearestPlayer = otherPlayer
                                                nearestPart = part
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        return nearestPlayer, nearestPart, nearestDistance
    end

    -- Fungsi untuk mengunci bagian terdekat dari pemain yang masih hidup dalam radius maksimum dari cursor mouse dan kamera
    local function lockNearestLivingPart()
        -- Ambil posisi kursor mouse saat ini
        local mousePosition = game:GetService("UserInputService"):GetMouseLocation()

        local nearestPlayer, nearestPart, nearestDistance = findNearestLivingPartInRadius(mousePosition)
        
        if nearestPlayer and nearestDistance <= maxLockDistance then
            targetPlayer = nearestPlayer
            targetPart = nearestPart
            circleGui.Color = Color3.fromRGB(255, 0, 0)  -- Ubah warna lingkaran menjadi merah saat mengunci
        else
            targetPlayer = nil
            targetPart = nil
            circleGui.Color = Color3.fromRGB(255, 255, 255)  -- Ubah warna lingkaran menjadi putih jika tidak ada yang dikunci
        end
    end

    -- Fungsi untuk memperbarui posisi kamera secara bertahap
    local function updateCamera()
        if targetPlayer and targetPart then
            -- Menginterpolasi posisi kamera ke bagian terdekat dari pemain terdekat
            local targetCFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
            camera.CFrame = camera.CFrame:Lerp(targetCFrame, interpolationSpeed)  -- kecepatan interpolasi dari textbox
        end
    end

    -- Mendeteksi perubahan state dari toggle
    local function onToggleStateChanged(state)
        if state then
            -- Mulai locking
            isLocking = true
            circleGui.Visible = true  -- Tampilkan GUI lingkaran radius
            lockNearestLivingPart()
        else
            -- Berhenti locking
            isLocking = false
            targetPlayer = nil
            targetPart = nil
            circleGui.Visible = false  -- Sembunyikan GUI lingkaran radius
            circleGui.Color = Color3.fromRGB(255, 255, 255)  -- Ubah warna lingkaran menjadi putih saat tidak terkunci
        end
    end

    -- Ambil toggle dari GUI
    AimbotTab:Toggle{
        Name = "Aimbot",
        StartingState = false,
        Description = "Allows you to lock out all players except players on the same team as you.",
        Callback = onToggleStateChanged
    }

    -- Fungsi callback untuk slider maxLockDistance
    local function onMaxLockDistanceChanged(value)
        maxLockDistance = value
    end

    -- Fungsi callback untuk slider lockRadius
    local function onLockRadiusChanged(value)
        lockRadius = value
        circleGui.Radius = value  -- Perbarui radius lingkaran GUI
    end

    -- Fungsi callback untuk textbox interpolationSpeed
    local function onInterpolationSpeedChanged(text)
        local value = tonumber(text)
        if value then
            interpolationSpeed = value
        else
            print("Invalid interpolation speed value.")
        end
    end

    -- Ambil slider untuk lockRadius dari GUI
    AimbotTab:Slider{
        Name = "Lock Radius",
        Default = lockRadius,
        Min = 0,
        Max = 100,  -- Sesuaikan nilai maksimum sesuai kebutuhan
        Description = "Change how big the radius can lock players.",
        Callback = onLockRadiusChanged
    }

    -- Ambil slider untuk maxLockDistance dari GUI
    AimbotTab:Slider{
        Name = "Lock Distance",
        Default = maxLockDistance,
        Min = 0,
        Max = 300,  -- Sesuaikan nilai maksimum sesuai kebutuhan
        Description = "Change how far you can lock the player.",
        Callback = onMaxLockDistanceChanged
    }

    -- Ambil textbox untuk interpolationSpeed dari GUI
    AimbotTab:Textbox{
        Name = "Interpolation Speed",
        Default = tostring(interpolationSpeed),
        Description = "How accurate it is when locking the player | Min: 0.1 Max: 1 Recommend: 0.1 | 0.2 | 0.3.",
        Callback = onInterpolationSpeedChanged
    }

    -- Mendeteksi perubahan posisi kursor mouse
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        -- Pastikan input adalah dari pergerakan mouse dan locking sedang aktif
        if input.UserInputType == Enum.UserInputType.MouseMovement and isLocking then
            -- Panggil fungsi untuk mengunci bagian terdekat dari pemain yang masih hidup dalam radius maksimum dari cursor mouse dan kamera selama locking aktif
            lockNearestLivingPart()
        end
    end)

    -- Loop untuk memperbarui posisi kamera secara bertahap
    game:GetService("RunService").RenderStepped:Connect(function()
        if isLocking then
            updateCamera()
        end
        -- Perbarui posisi GUI lingkaran radius
        updateCircleGui()
    end)

    GUI:Notification{
        Title = "CanCantHUB | Unnamed Shooter (Testing)",
        Text = "Successfully Loaded CanCantHUB | Unnamed Shooter (Testing)",
        Duration = 3,
        Callback = function() end
    }
    GUI:Credit{
        Name = "Gi",
        Description = "CanCantHUB | Unnamed Shooter (Testing)",
        Discord = "https://discord.gg/DButHVVX9Y"
    }
end
