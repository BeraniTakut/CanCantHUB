-- CanCantHUB | Made By Gi
-- Libary | https://xheptcofficial.gitbook.io/kavo-library

-- UNIVERSAL
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("CanCantHub | Universal (TESTING)", "DarkTheme")
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "CanCantHub | Universal (TESTING)", Text = "HUB by Gi"})

-- PEMAIN
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("PLAYER")

-- WalkSpeed
PlayerSection:NewSlider("WalkSpeed", "Change WalkSpeed Value", 500, 16, function(Value) -- 500 (Nilai Maks) | 0 (Nilai Min)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

-- JumpPower
PlayerSection:NewSlider("JumpPower", "Change JumpPower Value", 500, 50, function(Value) -- 500 (Nilai Maks) | 0 (Nilai Min)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end)

-- ESP
-- Local player
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Konfigurasi
local ESP_ENABLED = false
local MAX_DISTANCE = 10000 -- Jarak maksimum untuk menampilkan ESP
local NAME_POSITION = "Head" -- Posisi default untuk nama ("Head", "Center", "Feet")

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
    -- Buat Highlight untuk outline
    local Highlight = Instance.new("Highlight")
    Highlight.Adornee = Player.Character
    Highlight.FillColor = GetTeamColor(Player) -- Warna outline berdasarkan tim atau putih
    Highlight.Parent = Player.Character

    -- Buat BillboardGui untuk nama
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Size = UDim2.new(2, 0, 1, 0) -- Ukuran lebih besar untuk teks yang lebih besar
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Name = "PlayerName"

    local PositionOffset
    if NAME_POSITION == "Center" then
        PositionOffset = Vector3.new(0, -2, 0) -- Tengah pada karakter
    elseif NAME_POSITION == "Feet" then
        PositionOffset = Vector3.new(0, -5, 0) -- Di bawah kaki
    else -- Default ke "Head"
        PositionOffset = Vector3.new(0, 2, 0) -- Di atas kepala
    end

    -- Buat TextLabel untuk nama pemain
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = BillboardGui
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = Player.Name
    TextLabel.TextColor3 = GetTeamColor(Player) -- Warna teks berdasarkan tim atau putih
    TextLabel.TextStrokeTransparency = 0 -- Outline yang sepenuhnya terlihat
    TextLabel.TextStrokeColor3 = GetTeamColor(Player) -- Warna outline teks berdasarkan tim atau putih
    TextLabel.TextScaled = true
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top -- Menyusun teks ke atas

    BillboardGui.Adornee = Player.Character:FindFirstChild(NAME_POSITION) or Player.Character.PrimaryPart
    BillboardGui.StudsOffset = PositionOffset
    BillboardGui.Parent = Player.Character
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
                    if Character:FindFirstChild("PlayerName") then
                        Character.PlayerName:Destroy()
                    end
                end
            end
        end
    end
end

-- Fungsi untuk mengaktifkan atau menonaktifkan ESP
local function ToggleESP(state)
    ESP_ENABLED = state
    if not ESP_ENABLED then
        -- Hapus semua ESP yang ada
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Character = Player.Character
                if Character:FindFirstChild("Highlight") then
                    Character.Highlight:Destroy()
                    if Character:FindFirstChild("PlayerName") then
                        Character.PlayerName:Destroy()
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

-- Implementasi toggle
PlayerSection:NewToggle("ESP", "Makes Players Can See Through | Press To Toggle", function(state)
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "INFORMATION", Text = "This ESP will automatically filter the player's color depending on the team color, if the player doesn't have a team the color will be white (default)"})
    ToggleESP(state)
    if state then
        print("ESP ON")
    else
        print("ESP OFF")
    end
end)

-- NO-CLIP
PlayerSection:NewButton("No-Clip", "Makes the character able to pass through all objects | Press N To Toggle", function()
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "INFORMATION", Text = "Press N to toggle NoClip"})
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local noclip = false
    local event = game:GetService("RunService").Stepped
    
    function noclipLoop()
        if noclip then
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end
    
    mouse.KeyDown:Connect(function(key)
        if key == "n" then
            noclip = not noclip
            if noclip then
                event:Connect(noclipLoop)
            else
                event:Disconnect(noclipLoop)
            end
        end
    end)    
end)

-- FLY
PlayerSection:NewButton("Fly", "Makes You Fly Around | Press E To Toggle", function()
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "INFORMATION", Text = "Press E to toggle Fly | There's a little problem"})
    repeat wait() 
    until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid") 
    
    local mouse = game.Players.LocalPlayer:GetMouse() 
    local plr = game.Players.LocalPlayer 
    local torso = plr.Character.HumanoidRootPart 
    local flying = true
    local deb = true 
    local ctrl = {f = 0, b = 0, l = 0, r = 0} 
    local lastctrl = {f = 0, b = 0, l = 0, r = 0} 
    local maxspeed = 50 
    local speed = 0 
    
    function Fly() 
        local bg = Instance.new("BodyGyro", torso) 
        bg.P = 9e4 
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) 
        bg.cframe = torso.CFrame 
        local bv = Instance.new("BodyVelocity", torso) 
        bv.velocity = Vector3.new(0,0.1,0) 
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9) 
    
        repeat wait() 
            plr.Character.Humanoid.PlatformStand = true 
            
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then 
                speed = speed + 0.5 + (speed / maxspeed) 
                if speed > maxspeed then 
                    speed = maxspeed 
                end 
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then 
                speed = speed - 1 
                if speed < 0 then 
                    speed = 0 
                end 
            end 
            
            local moving = (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 
            
            if moving then 
                bv.velocity = ((game.Workspace.CurrentCamera.CFrame.lookVector * (ctrl.f + ctrl.b)) + 
                               ((game.Workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CFrame.p)) * speed 
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r} 
            elseif speed ~= 0 then 
                bv.velocity = ((game.Workspace.CurrentCamera.CFrame.lookVector * (lastctrl.f + lastctrl.b)) + 
                               ((game.Workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CFrame.p)) * speed 
            else 
                bv.velocity = Vector3.new(0, 0.1, 0) 
            end 
            
            bg.cframe = game.Workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0) 
        until not flying 
    
        ctrl = {f = 0, b = 0, l = 0, r = 0} 
        lastctrl = {f = 0, b = 0, l = 0, r = 0} 
        speed = 0 
        bg:Destroy() 
        bv:Destroy() 
        plr.Character.Humanoid.PlatformStand = false 
    end 
    
    mouse.KeyDown:Connect(function(key) 
        if key:lower() == "e" then 
            flying = not flying 
            if flying then 
                Fly() 
            end 
        elseif key:lower() == "w" then 
            ctrl.f = 1 
        elseif key:lower() == "s" then 
            ctrl.b = -1 
        elseif key:lower() == "a" then 
            ctrl.l = -1 
        elseif key:lower() == "d" then 
            ctrl.r = 1 
        end 
    end)
    
    mouse.KeyUp:Connect(function(key) 
        if key:lower() == "w" then 
            ctrl.f = 0 
        elseif key:lower() == "s" then 
            ctrl.b = 0 
        elseif key:lower() == "a" then 
            ctrl.l = 0 
        elseif key:lower() == "d" then 
            ctrl.r = 0 
        end 
    end)
    Fly()    
end)

-- MISC
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("MISC")

-- Kredits
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("CanCantHub Made By Gi")