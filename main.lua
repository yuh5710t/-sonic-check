-- ==========================================
-- 影月系统 | 终极索尼克白名单验证
-- ==========================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ⚠️【把这里换成你 keys.txt 的 Raw 链接】
local keysUrl = "你的keys链接"
local sonicUrl = "https://i.ibb.co/1DgvgqX/image.png"

-- 1. 核心验证逻辑
local function checkAuth(inputText)
    local success, data = pcall(function() return game:HttpGet(keysUrl) end)
    if success and data then
        if inputText ~= "" and string.find(data, HttpService:Base64Encode(inputText)) then return true end
        if string.find(data, HttpService:Base64Encode(player.Name)) then return true end
    end
    return false
end

-- 2. 验证界面
local authGui = Instance.new("ScreenGui", playerGui)
authGui.IgnoreGuiInset = true

local authFrame = Instance.new("Frame", authGui)
authFrame.Size = UDim2.fromOffset(320, 220)
authFrame.Position = UDim2.fromScale(0.5, 0.5)
authFrame.AnchorPoint = Vector2.new(0.5, 0.5)
authFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Instance.new("UICorner", authFrame).CornerRadius = UDim.new(0, 12)

local authBg = Instance.new("ImageLabel", authFrame)
authBg.Size = UDim2.fromScale(1, 1)
authBg.BackgroundTransparency = 1
authBg.Image = sonicUrl
authBg.ScaleType = Enum.ScaleType.Crop
authBg.ZIndex = 0
Instance.new("UICorner", authBg).CornerRadius = UDim.new(0, 12)

local overlay = Instance.new("Frame", authFrame)
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
overlay.BackgroundTransparency = 0.55
overlay.ZIndex = 0
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", authFrame)
stroke.Color = Color3.fromRGB(160, 50, 255)
stroke.Thickness = 2
stroke.ZIndex = 2

local title = Instance.new("TextLabel", authFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.fromOffset(0, 10)
title.Text = "👑 影月系统 | 云端授权"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.ZIndex = 3

local input = Instance.new("TextBox", authFrame)
input.Size = UDim2.new(1, -40, 0, 40)
input.Position = UDim2.fromOffset(20, 55)
input.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
input.TextColor3 = Color3.new(1, 1, 1)
input.PlaceholderText = "输入卡密 (或直接点按钮)"
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.Text = ""
input.ZIndex = 3
input.Parent = authFrame
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

local btn = Instance.new("TextButton", authFrame)
btn.Size = UDim2.new(1, -40, 0, 40)
btn.Position = UDim2.fromOffset(20, 110)
btn.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
btn.Text = "验证并注入"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 15
btn.ZIndex = 3
btn.Parent = authFrame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel", authFrame)
statusLabel.Size = UDim2.new(1, -40, 0, 20)
statusLabel.Position = UDim2.fromOffset(20, 160)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 12
statusLabel.BackgroundTransparency = 1
statusLabel.ZIndex = 3

-- 3. 按钮触发
btn.MouseButton1Click:Connect(function()
    statusLabel.Text = "⏳ 正在连接云端..."
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = "验证中..."
    task.wait(0.8)
    
    if checkAuth(input.Text) then
        statusLabel.Text = "✅ 授权通过"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
        btn.Text = "注入成功"
        task.wait(1)
        authGui:Destroy()
        
        -- =====================================
        -- 验证成功！这里放你要加载的主界面代码
        -- =====================================
        print("验证通过，可以加载你那个几百行的主界面了！")
        
    else
        statusLabel.Text = "❌ 授权失败：卡密错误！"
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btn.Text = "重新验证"
        task.wait(1.5)
        btn.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
        btn.Text = "验证并注入"
    end
end)
