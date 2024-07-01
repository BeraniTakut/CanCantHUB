--[[ CanCantHUB | Made By Gi
Libary | https://xheptcofficial.gitbook.io/kavo-library ]]

-- Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("CanCantHub | Universal (TESTING)", "DarkTheme")
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "CanCantHub | Universal (TESTING)", Text = "HUB by Gi"})

-- Player Section
local MainTab = Window:NewTab("MAIN")
local PlayerSection = MainTab:NewSection("PLAYER")
local MovementSection = MainTab:NewSection("MOVEMENT")
local OtherSection = MainTab:NewSection("OTHER")

-- WalkSpeed Slider
MovementSection:NewSlider("WalkSpeed", "Change WalkSpeed Value", 500, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

-- JumpPower Slider
MovementSection:NewSlider("JumpPower", "Change JumpPower Value", 500, 50, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end)

-- FLY
OtherSection:NewButton("Fly", "Toggle FLY On/Off", function()
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
                StarterGui:SetCore("SendNotification", {Title = "FLY", Text = "FLY has been Enabled"})
            else
                stopFlying()
                StarterGui:SetCore("SendNotification", {Title = "FLY", Text = "FLY has been Disabled"})
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
end)

-- ESP
-- Local player
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Konfigurasi
local ESP_ENABLED = false
local MAX_DISTANCE = 100000 -- Jarak maksimum untuk menampilkan ESP
local NAME_POSITION = "Feet" -- Posisi default untuk nama ("Head", "Center", "Feet")

-- Fungsi untuk menentukan warna berdasarkan tim atau putih jika tidak ada tim
local function GetTeamColor(Player)
    if Player.Team then
        return Player.Team.TeamColor.Color
    else
        return Color3.new(1, 1, 1) -- Warna putih jika tidak ada tim
    end
end

-- Fungsi untuk membuat ESP
local function CreateESP(Player)
    if Player.Character then
        -- Buat Highlight untuk outline
        local Highlight = Instance.new("Highlight")
        Highlight.Adornee = Player.Character
        Highlight.FillColor = Color3.new(0, 0, 0)
        Highlight.OutlineColor = GetTeamColor(Player) -- Warna outline berdasarkan tim atau putih
        Highlight.OutlineTransparency = 0
        Highlight.FillTransparency = 1
        Highlight.Parent = Player.Character

        -- Buat BillboardGui untuk nama dan darah
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Size = UDim2.new(0, 200, 0, 40) -- Ukuran tetap untuk teks, menyesuaikan dengan tambahan darah
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Name = "PlayerInfo"

        local PositionOffset
        if NAME_POSITION == "Center" then
            PositionOffset = Vector3.new(0, -2, 0) -- Tengah pada karakter
        elseif NAME_POSITION == "Feet" then
            PositionOffset = Vector3.new(0, -5, 0) -- Di bawah kaki
        else -- Default ke "Head"
            PositionOffset = Vector3.new(0, 2, 0) -- Di atas kepala
        end

        -- Buat TextLabel untuk angka darah
        local HealthLabel = Instance.new("TextLabel")
        HealthLabel.Parent = BillboardGui
        HealthLabel.Size = UDim2.new(1, 0, 0.5, 0)
        HealthLabel.BackgroundTransparency = 1
        HealthLabel.TextStrokeTransparency = 0 -- Outline yang sepenuhnya terlihat
        HealthLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Warna outline hitam
        HealthLabel.TextScaled = false -- Ukuran teks tidak disesuaikan
        HealthLabel.TextSize = 10 -- Ukuran teks lebih kecil dari sebelumnya
        HealthLabel.Position = UDim2.new(0, 0, 0, 0) -- Di atas nama pemain
        HealthLabel.TextYAlignment = Enum.TextYAlignment.Bottom -- Menyusun teks ke bawah

        -- Buat TextLabel untuk nama pemain
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Parent = BillboardGui
        NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.TextColor3 = GetTeamColor(Player) -- Warna teks berdasarkan tim atau putih
        NameLabel.TextStrokeTransparency = 0 -- Outline yang sepenuhnya terlihat
        NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Warna outline hitam
        NameLabel.TextScaled = false -- Ukuran teks tidak disesuaikan
        NameLabel.TextSize = 10 -- Ukuran teks lebih kecil dari sebelumnya
        NameLabel.Position = UDim2.new(0, 0, 0.5, 0) -- Di bawah angka darah
        NameLabel.TextYAlignment = Enum.TextYAlignment.Top -- Menyusun teks ke atas
        NameLabel.Text = Player.Name

        local targetHealth = 100
        local displayedHealth = 100

        local function UpdateHealth()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                targetHealth = Player.Character.Humanoid.Health
            end
        end

        -- Update health saat script dibuat dan saat HealthChanged
        UpdateHealth()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.HealthChanged:Connect(UpdateHealth)
        end

        -- Fungsi untuk memperbarui teks dan warnanya secara halus
        RunService.RenderStepped:Connect(function()
            if ESP_ENABLED and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                displayedHealth = displayedHealth + (targetHealth - displayedHealth) * 0.1 -- Lerp

                -- Interpolasi warna dari hijau ke merah
                local healthRatio = displayedHealth / Player.Character.Humanoid.MaxHealth
                local color = Color3.new(1 - healthRatio, healthRatio, 0) -- Merah ke hijau

                HealthLabel.Text = "(" .. math.floor(displayedHealth) .. ")"
                HealthLabel.TextColor3 = color
            end
        end)

        BillboardGui.Adornee = Player.Character:FindFirstChild(NAME_POSITION) or Player.Character.PrimaryPart
        BillboardGui.StudsOffset = PositionOffset
        BillboardGui.Parent = Player.Character
    end
end

-- Fungsi untuk memperbarui ESP
local function UpdateESP()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character then
            local Character = Player.Character
            local Distance = (Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude

            if Distance <= MAX_DISTANCE then
                if not Character:FindFirstChild("Highlight") then
                    CreateESP(Player)
                end
            else
                if Character:FindFirstChild("Highlight") then
                    Character.Highlight:Destroy()
                    if Character:FindFirstChild("PlayerInfo") then
                        Character.PlayerInfo:Destroy()
                    end
                end
            end
        end
    end
end

-- Fungsi untuk mengaktifkan atau menonaktifkan ESP
local function ToggleESP(state)
    ESP_ENABLED = state
    if ESP_ENABLED then
        StarterGui:SetCore("SendNotification", {Title = "ESP", Text = "ESP has been Enabled"})
    else
        StarterGui:SetCore("SendNotification", {Title = "ESP", Text = "ESP has been Disabled"})
        -- Hapus semua ESP yang ada
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Character = Player.Character
                if Character:FindFirstChild("Highlight") then
                    Character.Highlight:Destroy()
                    if Character:FindFirstChild("PlayerInfo") then
                        Character.PlayerInfo:Destroy()
                    end
                end
            end
        end
    end
end

-- Memperbarui ESP setiap frame
RunService.RenderStepped:Connect(function()
    if ESP_ENABLED then
        UpdateESP()
    end
end)

-- Implementasi toggle dengan Section:NewToggle
OtherSection:NewToggle("ESP", "Toggle ESP On/Off", function(state)
    ToggleESP(state)
    if state then
        print("ESP On")
    else
        print("ESP Off")
    end
end)

-- No-Clip
local NOCLIP_ENABLED = false
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local noclipConnection

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

local function SetNoClip(state)
    if not LocalPlayer.Character or not LocalPlayer.Character.Parent then return end
    
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

local function NoClipLoop()
    if NOCLIP_ENABLED then
        SetNoClip(true)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            SetNoClip(false)
        end
    end
end

local function ToggleNoClip(state)
    NOCLIP_ENABLED = state
    if NOCLIP_ENABLED then
        Notify("No-Clip Enabled", "No-Clip has been Enabled.")
        noclipConnection = RunService.Stepped:Connect(NoClipLoop)
    else
        Notify("No-Clip Disabled", "No-Clip has been Disabled.")
        NoClipLoop()
    end
end

OtherSection:NewToggle("No-Clip", "Toggle NO-CLIP On/Off", ToggleNoClip)

-- MISC
local MiscTab = Window:NewTab("MISC")
local MiscSection = MiscTab:NewSection("MISC")

-- Credits
local CreditsTab = Window:NewTab("CREDITS")
local CreditsSection = CreditsTab:NewSection("CanCantHub Made By Gi")
