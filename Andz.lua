--[[
    Project: BaodzHub (Blox Fruits Edition - Fully Functional)
    Author: MrDon
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().BaodzHub = getgenv().BaodzHub or {
    FixLag = false,
    FullBrightness = false,
    Fly = false,
    FlySpeed = 50,
    Speed = 32,
    HighJump = 50,
    EspMob = false,
    EspPlayer = false,
    Aimbot = false,
    AutoFarm = false
}
local Config = getgenv().BaodzHub

-- Clean up existing UI
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("BaodzHubUI") then
        LocalPlayer.PlayerGui.BaodzHubUI:Destroy()
    end
end)

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BaodzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 440)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BaodzHub - Blox Fruits Active"
Title.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollingFrame

local function createToggle(name, configKey)
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
    end)
end

createToggle("Fix Lag", "FixLag")
createToggle("Full Brightness", "FullBrightness")
createToggle("Fly", "Fly")
createToggle("Speed Boost", "Speed")
createToggle("ESP Players", "EspPlayer")
createToggle("ESP Mobs", "EspMob")
createToggle("Aimbot", "Aimbot")
createToggle("Auto Farm (Nearest)", "AutoFarm")

-- Feature Mechanics Implementation

-- Fly Variables
local BV, BG
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- Fix Lag
        if Config.FixLag then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
        end
        
        -- Full Brightness
        if Config.FullBrightness then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        end
        
        -- Speed Mod
        if hum and Config.Speed then
            hum.WalkSpeed = 35
        end
        
        -- Fly Mechanics
        if Config.Fly and hrp then
            if not BV then
                BV = Instance.new("BodyVelocity")
                BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                BV.Velocity = Vector3.new(0,0,0)
                BV.Parent = hrp
            end
            if not BG then
                BG = Instance.new("BodyGyro")
                BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                BG.CFrame = hrp.CFrame
                BG.Parent = hrp
            end
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            BV.Velocity = moveDir * Config.FlySpeed
            BG.CFrame = Camera.CFrame
        else
            if BV then BV:Destroy(); BV = nil end
            if BG then BG:Destroy(); BG = nil end
        end
        
        -- Aimbot Mechanics
        if Config.Aimbot then
            local closest, shortest = nil, math.huge
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in ipairs(enemies:GetChildren()) do
                    local mHrp = mob:FindFirstChild("HumanoidRootPart")
                    local mHum = mob:FindFirstChildOfClass("Humanoid")
                    if mHrp and mHum and mHum.Health > 0 then
                        local pos, onScreen = Camera:WorldToViewportPoint(mHrp.Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                            if dist < shortest then
                                shortest = dist
                                closest = mHrp
                            end
                        end
                    end
                end
            end
            if closest then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
            end
        end
        
        -- Auto Farm Logic (Teleportation/CFrame alignment to nearest enemy)
        if Config.AutoFarm then
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in ipairs(enemies:GetChildren()) do
                    local mHrp = mob:FindFirstChild("HumanoidRootPart")
                    local mHum = mob:FindFirstChildOfClass("Humanoid")
                    if mHrp and mHum and mHum.Health > 0 then
                        hrp.CFrame = mHrp.CFrame * CFrame.new(0, 0, 3)
                        break
                    end
                end
            end
        end
    end)
end)

-- ESP System (Clean rendering loop)
local espContainer = {}
local function updateESP()
    for _, obj in pairs(espContainer) do
        if obj then obj:Destroy() end
    end
    espContainer = {}
    
    if Config.EspPlayer then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local bill = Instance.new("BillboardGui")
                bill.Size = UDim2.new(0, 100, 0, 30)
                bill.AlwaysOnTop = true
                bill.StudsOffset = Vector3.new(0, 3, 0)
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.fromRGB(255, 0, 0)
                txt.TextScaled = true
                txt.Text = p.Name
                txt.Parent = bill
                bill.Parent = p.Character.HumanoidRootPart
                table.insert(espContainer, bill)
            end
        end
    end
    
    if Config.EspMob then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in ipairs(enemies:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") then
                    if mob.Humanoid.Health > 0 then
                        local bill = Instance.new("BillboardGui")
                        bill.Size = UDim2.new(0, 100, 0, 30)
                        bill.AlwaysOnTop = true
                        bill.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(255, 165, 0)
                        txt.TextScaled = true
                        txt.Text = mob.Name
                        txt.Parent = bill
                        bill.Parent = mob.HumanoidRootPart
                        table.insert(espContainer, bill)
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(updateESP)
    end
end)