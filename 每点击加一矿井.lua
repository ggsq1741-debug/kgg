local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- ==================== 自定义风格主题（精确覆盖所有文字） ====================
local techGreen = Color3.fromRGB(0, 255, 65)   -- 科技绿
local white = Color3.fromRGB(255, 255, 255)
local lightGray = Color3.fromRGB(200, 200, 210)

-- 创建新主题，明确指定每个文字属性
WindUI:AddTheme({
    Name = "DeltaForce",
    -- 大标题（窗口标题、作者、标签页标题）
    WindowTopbarTitle = techGreen,
    WindowTopbarAuthor = techGreen,
    TabTitle = techGreen,
    -- 小标题（控件标题、按钮文字、弹窗标题）
    ElementTitle = White,
    ButtonText = white,
    PopupTitle = white,
    DialogTitle = white,
    -- 描述文字（灰色）
    ElementDesc = DarkGreen,
    PopupContent = DarkGreen,
    DialogContent = DarkGreen,
    -- 占位符（科技绿，保持风格）
    PlaceholderText = techGreen,
    -- 图标（科技绿）
    Icon = techGreen,
    -- 其他（可选）
    TooltipText = white,
    TooltipSecondaryText = white,
})
WindUI:SetTheme("DeltaForce")

-- 获取服务
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 创建主窗口
local Window = WindUI:CreateWindow({
    Title = "HB网络",
    Author = "作者香港的猫😞😞😞",
    Folder = "MyHub",
    Transparent = true,
    Theme = "DeltaForce",
    SideBarWidth = 130,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    Background = "https://i.postimg.cc/Y2TWzMfg/IMG-20250905-005015.jpg",
    BackgroundImageTransparency = 0.3,
    User = { Enabled = false },
    ToggleKey = Enum.KeyCode.F,
})

-- 输出确认
print("✅ 窗口已创建，主题 DeltaForce 已应用")
print("窗口标题应为绿色，控件标题应为白色")

-- 定义统一的图标链接
local sjzIcon = "https://i.postimg.cc/d1sH5qJN/1781878127576.png"

-- 创建所有标签页（所有标签页使用同一个图标）
local Tabs = {
    kg = Window:Tab({ Title = "每点击加一个矿井", Icon = sjzIcon }),
}

local kgSection = Tabs.kg:Section({ Title = "每点击加一个矿井" })
kgSection:Toggle({
    Title = "自动售卖",
    Callback = function(state) -- 必须带state判断开关状态
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = replicatedStorage:WaitForChild("Remotes")
        local server = remotes:WaitForChild("Server")
        local sellAllLoot = server:WaitForChild("SellAllLoot")

        if state then
            -- 开启自动售卖
            game.StarterGui:SetCore("SendNotification", {
                Title = "功能开启",
                Text = "自动售卖已启动，每1秒出售",
                Duration = 2
            })
            sellLoop = task.spawn(function()
                while task.wait(1) do
                    sellAllLoot:FireServer()
                end
            end)
        else
            -- 关闭自动售卖，终止循环
            if sellLoop then
                task.cancel(sellLoop)
                sellLoop = nil
            end
            game.StarterGui:SetCore("SendNotification", {
                Title = "功能关闭",
                Text = "自动售卖已停止",
                Duration = 2
            })
        end
    end
})
kgSection:Toggle({
    Title = "自动点击",
    Callback = function(state) -- 必须加上state参数
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Click")

        if state then
            -- 打开开关：启动循环，弹出开启通知
            game.StarterGui:SetCore("SendNotification", {
                Title = "功能开启",
                Text = "自动点击已启动",
                Duration = 2
            })
            -- 新开独立线程运行发包循环
            autoClickThread = task.spawn(function()
                while task.wait(0) do
                    remote:FireServer()
                end
            end)
        else
            -- 关闭开关：终止循环，弹出关闭通知
            if autoClickThread then
                task.cancel(autoClickThread)
                autoClickThread = nil
            end
            game.StarterGui:SetCore("SendNotification", {
                Title = "功能关闭",
                Text = "自动点击已停止",
                Duration = 2
            })
        end
    end
})
Tabs.kg:Button({
    Title = "快速互动",
    Callback = function()
        game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
            prompt.HoldDuration = 0
        end)
    end
})