local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local GUI = Mercury:Create{
    Name = "CanCantHUB",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "Universal"
}
local MainTab = GUI:Tab{
	Name = "MAIN",
	Icon = "rbxassetid://8569322835"
}

-- WalkSpeed Slider
MainTab:Slider{
    Name = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 500,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
}
-- JumpPower Slider
MainTab:Slider{
    Name = "JumpPower",
    Default = 50,
    Min = 50,
    Max = 500,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
}

-- Terbang
MainTab:Button{
    Name = "Fly",
    Description = "Toggle E FLY On/Off",
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
    end
}

-- ESP
-- Local player
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Konfigurasi
local ESP_ENABLED = false
local MAX_DISTANCE = 100000 -- jarak maksimal untuk menampilkn ESP
local NAME_POSITION = "Feet" -- Posisi deffault untuk nama ("Head", "Center", "Feet")

-- untuk menentukan warna berdasarkan tim atau putih jika tidak ada tim
local function GetTeamColor(Player)
    if Player.Team then
        return Player.Team.TeamColor.Color
    else
        return Color3.new(1, 1, 1) -- White color if no team
    end
end

-- Buat ESP
local function CreateESP(Player)
    if Player.Character then
        -- Buat hightlight buat outline
        local Highlight = Instance.new("Highlight")
        Highlight.Adornee = Player.Character
        Highlight.FillColor = Color3.new(0, 0, 0)
        Highlight.OutlineColor = GetTeamColor(Player) -- Outline warna tergantung team
        Highlight.OutlineTransparency = 0
        Highlight.FillTransparency = 1
        Highlight.Parent = Player.Character

        -- buat BillboardGui untuk nama dan health
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Size = UDim2.new(0, 200, 0, 40) -- Fix size untuk text, adjust untuk size nama
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Name = "PlayerInfo"

        local PositionOffset
        if NAME_POSITION == "Center" then
            PositionOffset = Vector3.new(0, -2, 0) -- Center Torso
        elseif NAME_POSITION == "Feet" then
            PositionOffset = Vector3.new(0, -5, 0) -- Below feet
        else -- Default ke "Head"
            PositionOffset = Vector3.new(0, 2, 0) -- Above head
        end

        -- Buat TextLabel untuk health number
        local HealthLabel = Instance.new("TextLabel")
        HealthLabel.Parent = BillboardGui
        HealthLabel.Size = UDim2.new(1, 0, 0.5, 0)
        HealthLabel.BackgroundTransparency = 1
        HealthLabel.TextStrokeTransparency = 0 -- Outline terlihat sepenuhnya
        HealthLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Warna outline hitam
        HealthLabel.TextScaled = false -- Ukuran teks tidak disesuaikan
        HealthLabel.TextSize = 10 -- Unkuran Text
        HealthLabel.Position = UDim2.new(0, 0, 0, 0) -- Atas kepala player
        HealthLabel.TextYAlignment = Enum.TextYAlignment.Bottom -- Sejajarkan teks ke bawah

        -- Buat TextLabel untuk nama player
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Parent = BillboardGui
        NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.TextColor3 = GetTeamColor(Player) -- Outline warna tergantung team
        NameLabel.TextStrokeTransparency = 0 -- Outline terlihat sepenuhnya
        NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Warna outline hitam
        NameLabel.TextScaled = false -- Ukuran teks tidak disesuaikan
        NameLabel.TextSize = 10 -- Unkuran Text
        NameLabel.Position = UDim2.new(0, 0, 0.5, 0) -- Bawah health number
        NameLabel.TextYAlignment = Enum.TextYAlignment.Top -- Sejajarkan teks ke atas
        NameLabel.Text = Player.Name

        local targetHealth = 100
        local displayedHealth = 100

        local function UpdateHealth()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                targetHealth = Player.Character.Humanoid.Health
            end
        end

        -- Perbarui Health dan HealthChanged
        UpdateHealth()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.HealthChanged:Connect(UpdateHealth)
        end

        -- Untuk memperbarui teks dan warna dengan lancar
        RunService.RenderStepped:Connect(function()
            if ESP_ENABLED and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                displayedHealth = displayedHealth + (targetHealth - displayedHealth) * 0.1 -- Lerp

                -- Interpolate color from green to red
                local healthRatio = displayedHealth / Player.Character.Humanoid.MaxHealth
                local color = Color3.new(1 - healthRatio, healthRatio, 0) -- Red to green

                HealthLabel.Text = "(" .. math.floor(displayedHealth) .. ")"
                HealthLabel.TextColor3 = color
            end
        end)

        BillboardGui.Adornee = Player.Character:FindFirstChild(NAME_POSITION) or Player.Character.PrimaryPart
        BillboardGui.StudsOffset = PositionOffset
        BillboardGui.Parent = Player.Character
    end
end

-- Untuk memperbarui ESP
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

-- Untuk Enable dan Disable ESP
local function ToggleESP(state)
    ESP_ENABLED = state
    if ESP_ENABLED then
        StarterGui:SetCore("SendNotification", {Title = "ESP", Text = "ESP has been Enabled"})
    else
        StarterGui:SetCore("SendNotification", {Title = "ESP", Text = "ESP has been Disabled"})
        -- Remove all existing ESP
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

-- Update ESP setiap frame
RunService.RenderStepped:Connect(function()
    if ESP_ENABLED then
        UpdateESP()
    end
end)

MainTab:Toggle{
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
        Notify("No-Clip", "No-Clip has been Enabled.")
        noclipConnection = RunService.Stepped:Connect(NoClipLoop)
    else
        Notify("No-Clip", "No-Clip has been Disabled.")
        NoClipLoop()
    end
end

MainTab:Toggle{
    Name = "No-Clip",
    StartingState = false,
    Description = "Toggle No-Clip On/Off",
    Callback = function(state)
        ToggleNoClip(state)
        if state then
            print("No-Clip On")
        else
            print("No-Clip Off")
        end
    end
}

-- Aimbot
-- Ambil kamera dan pemain lokal
local camera = game.Workspace.CurrentCamera
local player = game.Players.LocalPlayer

-- Variable untuk menyimpan status locking
local isLocking = false
local targetPlayer = nil
local targetPart = nil

-- Radius maksimum dari cursor mouse untuk mengunci pemain
local maxLockDistance = 100  -- Sesuaikan dengan jangkauan maksimum yang diinginkan
local lockRadius = 50  -- Sesuaikan dengan radius lingkaran yang diinginkan

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
        camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.1)  -- 0.1 adalah kecepatan interpolasi, bisa disesuaikan
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
MainTab:Toggle{
    Name = "Aimbot",
    StartingState = false,
    Description = "Toggle No-Clip On/Off",
    Callback = onToggleStateChanged
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
	Title = "CanCantHUB | Universal",
	Text = "Successfully Loaded CanCantHUB | Universal",
	Duration = 3,
	Callback = function() end
}
GUI:Credit{
	Name = "Gi",
	Description = "CanCantHUB | Universal (Testing)",
	Discord = "https://discord.gg/DButHVVX9Y"
}

--[[ -- Unnamed Shooter
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
        Icon = "rbxassetid://8569322835"
    }
    local ESPTab = GUI:Tab{
        Name = "ESP",
        Icon = "rbxassetid://8569322835"
    }
    local AimbotTab = GUI:Tab{
        Name = "AIMBOT",
        Icon = "rbxassetid://8569322835"
    }
    
    -- WalkSpeed Slider
    PlayerTab:Slider{
        Name = "WalkSpeed",
        Default = 16,
        Min = 16,
        Max = 500,
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
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    }
    
    -- Terbang
    PlayerTab:Button{
        Name = "Fly",
        Description = "Toggle E FLY On/Off",
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
        end
    }
    
    -- ESP
    -- Local player
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local StarterGui = game:GetService("StarterGui")
    
    -- Konfigurasi
    local ESP_ENABLED = false
    local MAX_DISTANCE = 100000 -- jarak maksimal untuk menampilkn ESP
    local NAME_POSITION = "Feet" -- Posisi deffault untuk nama ("Head", "Center", "Feet")
    
    -- untuk menentukan warna berdasarkan tim atau putih jika tidak ada tim
    local function GetTeamColor(Player)
        if Player.Team then
            return Player.Team.TeamColor.Color
        else
            return Color3.new(1, 1, 1) -- White color if no team
        end
    end
    
    -- Buat ESP
    local function CreateESP(Player)
        if Player.Character then
            -- Buat hightlight buat outline
            local Highlight = Instance.new("Highlight")
            Highlight.Adornee = Player.Character
            Highlight.FillColor = Color3.new(0, 0, 0)
            Highlight.OutlineColor = GetTeamColor(Player) -- Outline warna tergantung team
            Highlight.OutlineTransparency = 0
            Highlight.FillTransparency = 1
            Highlight.Parent = Player.Character
    
            -- buat BillboardGui untuk nama dan health
            local BillboardGui = Instance.new("BillboardGui")
            BillboardGui.Size = UDim2.new(0, 200, 0, 40) -- Fix size untuk text, adjust untuk size nama
            BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Name = "PlayerInfo"
    
            local PositionOffset
            if NAME_POSITION == "Center" then
                PositionOffset = Vector3.new(0, -2, 0) -- Center Torso
            elseif NAME_POSITION == "Feet" then
                PositionOffset = Vector3.new(0, -5, 0) -- Below feet
            else -- Default ke "Head"
                PositionOffset = Vector3.new(0, 2, 0) -- Above head
            end
    
            -- Buat TextLabel untuk health number
            local HealthLabel = Instance.new("TextLabel")
            HealthLabel.Parent = BillboardGui
            HealthLabel.Size = UDim2.new(1, 0, 0.5, 0)
            HealthLabel.BackgroundTransparency = 1
            HealthLabel.TextStrokeTransparency = 0 -- Outline terlihat sepenuhnya
            HealthLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Warna outline hitam
            HealthLabel.TextScaled = false -- Ukuran teks tidak disesuaikan
            HealthLabel.TextSize = 10 -- Unkuran Text
            HealthLabel.Position = UDim2.new(0, 0, 0, 0) -- Atas kepala player
            HealthLabel.TextYAlignment = Enum.TextYAlignment.Bottom -- Sejajarkan teks ke bawah
    
            -- Buat TextLabel untuk nama player
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Parent = BillboardGui
            NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.TextColor3 = GetTeamColor(Player) -- Outline warna tergantung team
            NameLabel.TextStrokeTransparency = 0 -- Outline terlihat sepenuhnya
            NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Warna outline hitam
            NameLabel.TextScaled = false -- Ukuran teks tidak disesuaikan
            NameLabel.TextSize = 10 -- Unkuran Text
            NameLabel.Position = UDim2.new(0, 0, 0.5, 0) -- Bawah health number
            NameLabel.TextYAlignment = Enum.TextYAlignment.Top -- Sejajarkan teks ke atas
            NameLabel.Text = Player.Name
    
            local targetHealth = 100
            local displayedHealth = 100
    
            local function UpdateHealth()
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    targetHealth = Player.Character.Humanoid.Health
                end
            end
    
            -- Perbarui Health dan HealthChanged
            UpdateHealth()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.HealthChanged:Connect(UpdateHealth)
            end
    
            -- Untuk memperbarui teks dan warna dengan lancar
            RunService.RenderStepped:Connect(function()
                if ESP_ENABLED and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    displayedHealth = displayedHealth + (targetHealth - displayedHealth) * 0.1 -- Lerp
    
                    -- Interpolate color from green to red
                    local healthRatio = displayedHealth / Player.Character.Humanoid.MaxHealth
                    local color = Color3.new(1 - healthRatio, healthRatio, 0) -- Red to green
    
                    HealthLabel.Text = "(" .. math.floor(displayedHealth) .. ")"
                    HealthLabel.TextColor3 = color
                end
            end)
    
            BillboardGui.Adornee = Player.Character:FindFirstChild(NAME_POSITION) or Player.Character.PrimaryPart
            BillboardGui.StudsOffset = PositionOffset
            BillboardGui.Parent = Player.Character
        end
    end
    
    -- Untuk memperbarui ESP
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
    
    -- Untuk Enable dan Disable ESP
    local function ToggleESP(state)
        ESP_ENABLED = state
        if ESP_ENABLED then
            StarterGui:SetCore("SendNotification", {Title = "ESP", Text = "ESP has been Enabled"})
        else
            StarterGui:SetCore("SendNotification", {Title = "ESP", Text = "ESP has been Disabled"})
            -- Remove all existing ESP
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
    
    -- Update ESP setiap frame
    RunService.RenderStepped:Connect(function()
        if ESP_ENABLED then
            UpdateESP()
        end
    end)
    
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
            Notify("No-Clip", "No-Clip has been Enabled.")
            noclipConnection = RunService.Stepped:Connect(NoClipLoop)
        else
            Notify("No-Clip", "No-Clip has been Disabled.")
            NoClipLoop()
        end
    end
    
    PlayerTab:Toggle{
        Name = "No-Clip",
        StartingState = false,
        Description = "Toggle No-Clip On/Off",
        Callback = function(state)
            ToggleNoClip(state)
            if state then
                print("No-Clip On")
            else
                print("No-Clip Off")
            end
        end
    }
    
    -- Aimbot
    -- Ambil kamera dan pemain lokal
    local camera = game.Workspace.CurrentCamera
    local player = game.Players.LocalPlayer

    -- Variable untuk menyimpan status locking
    local isLocking = false
    local targetPlayer = nil
    local targetPart = nil

    -- Radius maksimum dari cursor mouse untuk mengunci pemain
    local maxLockDistance = 100  -- Sesuaikan dengan jangkauan maksimum yang diinginkan
    local lockRadius = 50  -- Sesuaikan dengan radius lingkaran yang diinginkan

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
            camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.1)  -- 0.1 adalah kecepatan interpolasi, bisa disesuaikan
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
        Description = "Toggle No-Clip On/Off",
        Callback = onToggleStateChanged
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
        Title = "CanCantHUB | Unnamed Shooter",
        Text = "Successfully Loaded CanCantHUB | Unnamed Shooter",
        Duration = 3,
        Callback = function() end
    }
    GUI:Credit{
        Name = "Gi",
        Description = "CanCantHUB | Unnamed Shooter (Testing)",
        Discord = "https://discord.gg/DButHVVX9Y"
    }
end ]]
