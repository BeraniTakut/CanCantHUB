--[[ CanCantHUB | Made By Gi
Libary | https://xheptcofficial.gitbook.io/kavo-library ]]

-- Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("CanCantHub | Universal (TESTING)", "DarkTheme")
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "CanCantHub | Universal (TESTING)", Text = "HUB by Gi"})

-- Player Section
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("PLAYER")

-- WalkSpeed Slider
PlayerSection:NewSlider("WalkSpeed", "Change WalkSpeed Value", 500, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

-- JumpPower Slider
PlayerSection:NewSlider("JumpPower", "Change JumpPower Value", 500, 50, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end)

-- ESP
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP_ENABLED = false
local MAX_DISTANCE = 100000
local NAME_POSITION = "Head"

local function GetTeamColor(Player)
    if Player.Team then
        return Player.Team.TeamColor.Color
    else
        return Color3.new(1, 1, 1) -- Putih jika tidak ada tim
    end
end

local function CreateESP(Player)
    local Highlight = Instance.new("Highlight")
    Highlight.Adornee = Player.Character
    Highlight.FillColor = GetTeamColor(Player)
    Highlight.Parent = Player.Character

    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Size = UDim2.new(0, 200, 0, 40)
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
    HealthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.TextStrokeTransparency = 0
    HealthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    HealthLabel.TextScaled = false
    HealthLabel.TextSize = 10
    HealthLabel.Position = UDim2.new(0, 0, 0, 0)
    HealthLabel.TextYAlignment = Enum.TextYAlignment.Bottom

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = BillboardGui
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = GetTeamColor(Player)
    NameLabel.TextStrokeTransparency = 0
    NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    NameLabel.TextScaled = false
    NameLabel.TextSize = 10
    NameLabel.Position = UDim2.new(0, 0, 0.5, 0)
    NameLabel.TextYAlignment = Enum.TextYAlignment.Top
    NameLabel.Text = Player.Name

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
        end
    end)

    BillboardGui.Adornee = Player.Character:FindFirstChild(NAME_POSITION) or Player.Character.PrimaryPart
    BillboardGui.StudsOffset = PositionOffset
    BillboardGui.Parent = Player.Character
end

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

RunService.RenderStepped:Connect(function()
    if ESP_ENABLED then
        UpdateESP()
    end
end)

local function ToggleESP(state)
    ESP_ENABLED = state
    if ESP_ENABLED then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ESP Enabled", Text = "ESP has been enabled."})
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ESP Disabled", Text = "ESP has been disabled."})
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

PlayerSection:NewToggle("ESP", "Toggle ESP On/Off", ToggleESP)

-- No-Clip
local NOCLIP_ENABLED = false

local function ToggleNoClip(state)
    NOCLIP_ENABLED = state
    if NOCLIP_ENABLED then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "No-Clip Enabled", Text = "No-Clip has been enabled."})
        local player = game.Players.LocalPlayer
        local event

        function noclipLoop()
            if NOCLIP_ENABLED then
                for _,v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            else
                event:Disconnect()
                for _,v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end

        event = game:GetService("RunService").Stepped:Connect(noclipLoop)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "No-Clip Disabled", Text = "No-Clip has been disabled."})
        NOCLIP_ENABLED = false
    end
end

PlayerSection:NewToggle("No-Clip", "Toggle No-Clip On/Off", ToggleNoClip)

-- Credits
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("CanCantHub Made By Gi")
