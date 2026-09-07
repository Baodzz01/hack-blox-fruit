--[[
    Project: BaodzHub (Blox Fruits Edition - Toggle Menu & Attack Fix)
    Author: MrDon
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().BaodzHub = getgenv().BaodzHub or {
    FixLag = false,
    FullBrightness = false,
    Fly = false,
    FlySpeed = 50,
    Speed = 32,
    EspMob = false,
    EspPlayer = false,
    Aimbot = false,
    AimbotFOV = 180,
    AutoFarm = false,
    SelectedMob = "Monkey",
    HitboxSize = 25
}
local Config = getgenv().BaodzHub

-- Clean up existing UI
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("BaodzHubUI") then
        LocalPlayer.PlayerGui.BaodzHubUI:Destroy()
    end
    if LocalPlayer.PlayerGui:FindFirstChild("BaodzHubFOV") then
        LocalPlayer.PlayerGui.BaodzHubFOV:Destroy()
    end
    if LocalPlayer.PlayerGui:FindFirstChild("BaodzHubToggle") then
        LocalPlayer.PlayerGui.BaodzHubToggle:Destroy()
    end
end)

-- FOV Circle UI (Players Only)
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "BaodzHubFOV"
FOVGui.ResetOnSpawn = false
FOVGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FOVCircle = Instance.new("Frame")
FOVCircle.Size = UDim2.new(0, Config.AimbotFOV * 2, 0, Config.AimbotFOV * 2)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = FOVGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVCircle

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Parent = FOVCircle

-- Main Control UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BaodzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Floating Toggle Open/Close Button
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "BaodzHubToggle"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = LocalPlayer.PlayerGui

local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Size = UDim2.new(0, 50, 0, 50)
OpenCloseBtn.Position = UDim2.new(0, 20, 0.4, 0)
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
OpenCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenCloseBtn.TextSize = 12
OpenCloseBtn.Font = Enum.Font.SourceSansBold
OpenCloseBtn.Text = "MENU"
OpenCloseBtn.Parent = ToggleGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = OpenCloseBtn

OpenCloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BaodzHub - Ultimate Blox Fruits"
Title.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 650)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollingFrame

local function createToggle(name, configKey, onToggle)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name .. (Config[configKey] and ": ON" or ": OFF")
    btn.Parent = ScrollingFrame
    
    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        btn.Text = name .. (Config[configKey] and ": ON" or ": OFF")
        if onToggle then onToggle(Config[configKey]) end
    end)
end

-- Mob Selection Button
local mobSelectBtn = Instance.new("TextButton")
mobSelectBtn.Size = UDim2.new(0, 280, 0, 40)
mobSelectBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
mobSelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mobSelectBtn.TextSize = 13
mobSelectBtn.Font = Enum.Font.SourceSansBold
mobSelectBtn.Text = "Target Mob: " .. Config.SelectedMob
mobSelectBtn.Parent = ScrollingFrame

local mobList = {"Monkey", "Gorilla", "Bandit", "Pirate", "Brute", "Swan Pirate", "Factory Staff"}
local mobIndex = 1
mobSelectBtn.MouseButton1Click:Connect(function()
    mobIndex = mobIndex % #mobList + 1
    Config.SelectedMob = mobList[mobIndex]
    mobSelectBtn.Text = "Target Mob: " .. Config.SelectedMob
end)

createToggle("Fix Lag (Boost)", "FixLag", function(v)
    if v then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") then obj.Enabled = false end
        end
    else
        Lighting.GlobalShadows = true
    end
end)

createToggle("Full Brightness", "FullBrightness")
createToggle("Fly", "Fly")
createToggle("Speed Boost", "Speed")
createToggle("ESP Players", "EspPlayer")
createToggle("ESP Mobs", "EspMob")
createToggle("Player Aimbot (FOV)", "Aimbot", function(v) FOVCircle.Visible = v end)
createToggle("Auto Farm (Selected Mob)", "AutoFarm")

-- Engine Loops
local BV, BG
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- Full Brightness
        if Config.FullBrightness then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        end
        
        -- Speed
        if hum and Config.Speed then hum.WalkSpeed = Config.Speed end
        
        -- Fly
        if Config.Fly and hrp and hum then
            hum.PlatformStand = true
            if not BV then
                BV = Instance.new("BodyVelocity", hrp)
                BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            end
            if not BG then
                BG = Instance.new("BodyGyro", hrp)
                BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            end
            BV.Velocity = Camera.CFrame.LookVector * Config.FlySpeed
            BG.CFrame = Camera.CFrame
        else
            if hum then hum.PlatformStand = false end
            if BV then BV:Destroy(); BV = nil end
            if BG then BG:Destroy(); BG = nil end
        end
        
        -- Expanded Hitboxes for Long-Range Melee Attacks
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local pPart = p.Character:FindFirstChild("HumanoidRootPart")
                if pPart then
                    pPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    pPart.Transparency = 0.5
                    pPart.CanCollide = false
                end
            end
        end
        
        local enemiesFolder = Workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            for _, mob in ipairs(enemiesFolder:GetChildren()) do
                local mPart = mob:FindFirstChild("HumanoidRootPart")
                if mPart then
                    mPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    mPart.Transparency = 0.5
                    mPart.CanCollide = false
                end
            end
        end
        
        -- Player-Only Aimbot inside FOV Circle
        if Config.Aimbot and hrp then
            local closestTarget, shortestDist = nil, Config.AimbotFOV
            local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                    if tHrp and tHum and tHum.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(tHrp.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestTarget = tHrp
                            end
                        end
                    end
                end
            end
            
            if closestTarget then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            end
        end
        
        -- Auto Farm (Target Specific Mob, Teleport slightly above, Equip Tool, Attack)
        if Config.AutoFarm and hrp and enemiesFolder then
            for _, mob in ipairs(enemiesFolder:GetChildren()) do
                local mHrp = mob:FindFirstChild("HumanoidRootPart")
                local mHum = mob:FindFirstChildOfClass("Humanoid")
                if mHrp and mHum and mHum.Health > 0 and mob.Name == Config.SelectedMob then
                    hrp.CFrame = mHrp.CFrame * CFrame.new(0, 5, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    
                    -- Equip weapon/tool
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        local backpackTool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                        if backpackTool then
                            hum:EquipTool(backpackTool)
                        end
                    end
                    
                    -- Fire attack simulation continuously
                    pcall(function()
                        VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                        task.wait(0.05)
                        VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
                    end)
                    break
                end
            end
        end
    end)
end)

-- ESP System
local espContainer = {}
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, obj in pairs(espContainer) do if obj then obj:Destroy() end end
            espContainer = {}
            
            if Config.EspPlayer then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local bill = Instance.new("BillboardGui", p.Character.HumanoidRootPart)
                        bill.Size, bill.AlwaysOnTop, bill.StudsOffset = UDim2.new(0, 100, 0, 30), true, Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", bill)
                        txt.Size, txt.BackgroundTransparency, txt.TextColor3, txt.TextScaled, txt.Text = UDim2.new(1,0,1,0), true, Color3.fromRGB(255, 0, 0), true, p.Name
                        table.insert(espContainer, bill)
                    end
                end
            end
            
            local enemiesFolder = Workspace:FindFirstChild("Enemies")
            if Config.EspMob and enemiesFolder then
                for _, mob in ipairs(enemiesFolder:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                        local bill = Instance.new("BillboardGui", mob.HumanoidRootPart)
                        bill.Size, bill.AlwaysOnTop, bill.StudsOffset = UDim2.new(0, 100, 0, 30), true, Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", bill)
                        txt.Size, txt.BackgroundTransparency, txt.TextColor3, txt.TextScaled, txt.Text = UDim2.new(1,0,1,0), true, Color3.fromRGB(255, 165, 0), true, mob.Name
                        table.insert(espContainer, bill)
                    end
                end
            end
        end)
    end
end)