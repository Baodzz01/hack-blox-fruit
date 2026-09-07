--[[
    Project: BaodzHub (Blox Fruits Edition with UI)
    Author: MrDon
]]

repeat task.wait() until game:IsLoaded()

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

-- Create Simple ScreenGui Menu
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BaodzHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "BaodzHub - Blox Fruits"
TitleLabel.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollingFrame

local function createToggle(name, configKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name .. ": OFF"
    btn.Parent = ScrollingFrame
    
    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.Text = name .. ": OFF"
        end
        if callback then callback(Config[configKey]) end
    end)
end

createToggle("Fix Lag", "FixLag", function(v)
    Config.FixLag = v
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

-- Movement and Render loops
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if Config.Speed > 16 then hum.WalkSpeed = Config.Speed end
    end
    if Config.FullBrightness then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end
end)