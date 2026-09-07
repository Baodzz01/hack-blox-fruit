--[[
    Project: BaodzHub (Blox Fruits Edition - Hardened)
    Author: MrDon
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().BaodzHub = getgenv().BaodzHub or {
    AntiCheatBypass = true,
    FixLag = false,
    FullBrightness = false,
    Fly = false,
    FlySpeed = 50,
    Speed = 16,
    HighJump = 50,
    EspMob = false,
    EspPlayer = false,
    Aimbot = false,
    AutoFarm = false
}
local Config = getgenv().BaodzHub

-- Clean up any existing instances to prevent duplicate UIs
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("BaodzHubUI") then
        LocalPlayer.PlayerGui.BaodzHubUI:Destroy()
    end
end)

-- Create ScreenGui Menu Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BaodzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "BaodzHub v1.0 - Blox Fruits"
TitleLabel.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -45)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollingFrame

local function createToggle(name, configKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(55, 55, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name .. (Config[configKey] and ": ON" or ": OFF")
    btn.Parent = ScrollingFrame
    
    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            btn.Text = name .. ": OFF"
        end
        if callback then
            task.spawn(function() callback(Config[configKey]) end)
        end
    end)
end

createToggle("Fix Lag", "FixLag", function(v)
    if v then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
        end
        Lighting.GlobalShadows = false
    else
        Lighting.GlobalShadows = true
    end
end)

createToggle("Full Brightness", "FullBrightness")
createToggle("Fly", "Fly")
createToggle("ESP Players", "EspPlayer")
createToggle("ESP Mobs", "EspMob")
createToggle("Aimbot", "Aimbot")
createToggle("Auto Farm", "AutoFarm")

-- Engine Loops
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and Config.Speed > 16 then
            hum.WalkSpeed = Config.Speed
        end
        
        if Config.FullBrightness then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        end
    end)
end)

print("BaodzHub Loaded Successfully, boss man.")