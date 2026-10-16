local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local GUI_NAME = "ZeroHUB_UpdateGUI"

-- ============================================================
-- รายการอัปเดต (ใหม่สุดอยู่บนสุด)
-- ป้ายที่ใช้ได้: NEW, FIX, CHANGE, REMOVED
-- ============================================================
local UPDATES = {
    {
        version = "V 3.1.1 Fix",
        date = "16 ต.ค. 2026",
        title = "Update",
        items = {
            {"มีปันหา", "ย่อตัวอัตโนมัติ มีปันหา"},
            {"NEW", "เพิ่มระบบเรดาร์"},
            {"NEW", "เพิ่มระบบ แพรีปลอม(เห็นแค่ฟังเรา)"},
            {"NEW", "เพิ่มระบบ ดูสถาน ถูกแขน"},
            {"FIX", "แก้ระบบ บูท FPS กับ ภาพดินน้ำมัน ให้ดีขึ้น"},
            {"FIX", "ปรับปรุงระบบแพรี ให้ดีขึ้น"},
            {"FIX", "แก้ระบบ ไมเคิล ปุ่มหาย"},
        },
    },
    {
        version = "V 3.1.0",
        date = "ก่อนหน้า",
        title = "",
        items = {
            {"REMOVED", "ลบระบบข้ามคูลดาวน์ Veil"},
            {"REMOVED", "ลบระบบไล่ล่าไม่จำกัดของ Jason"},
        },
    },
}

-- ============================================================
-- ธีมสี
-- ============================================================
local C = {
    bg     = Color3.fromRGB(22, 22, 30),
    bar    = Color3.fromRGB(30, 30, 42),
    card   = Color3.fromRGB(32, 32, 46),
    accent = Color3.fromRGB(120, 90, 255),
    text   = Color3.fromRGB(235, 235, 245),
    sub    = Color3.fromRGB(170, 170, 190),
    close  = Color3.fromRGB(220, 70, 80),
}

local TAGS = {
    NEW     = {"#4CD07D", "ใหม่"},
    FIX     = {"#4DA3FF", "แก้ไข"},
    CHANGE  = {"#FFC24D", "ปรับปรุง"},
    REMOVED = {"#FF6B6B", "ลบออก"},
}

local FONT = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold

-- ============================================================
-- ตัวช่วย
-- ============================================================
local function getParent()
    local ok, ui = pcall(function()
        return gethui and gethui()
    end)
    if ok and ui then return ui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

local function pad(obj, p)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0, p)
    u.PaddingBottom = UDim.new(0, p)
    u.PaddingLeft = UDim.new(0, p)
    u.PaddingRight = UDim.new(0, p)
    u.Parent = obj
end

local parent = getParent()
local old = parent:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

-- ============================================================
-- สร้าง GUI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 998
gui.Parent = parent

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromScale(0.92, 0.78)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
corner(main, 12)

local limit = Instance.new("UISizeConstraint")
limit.MaxSize = Vector2.new(520, 420)
limit.MinSize = Vector2.new(260, 220)
limit.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = C.accent
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = main

-- แถบหัว
local top = Instance.new("Frame")
top.Name = "TopBar"
top.Size = UDim2.new(1, 0, 0, 42)
top.BackgroundColor3 = C.bar
top.BorderSizePixel = 0
top.Parent = main
corner(top, 12)

-- ตัวเติมครึ่งล่างของแถบหัว ให้มุมล่างเป็นเหลี่ยม มีแต่มุมบนที่โค้ง
local topFill = Instance.new("Frame")
topFill.Name = "TopFill"
topFill.AnchorPoint = Vector2.new(0, 1)
topFill.Position = UDim2.fromScale(0, 1)
topFill.Size = UDim2.new(1, 0, 0, 12)
topFill.BackgroundColor3 = C.bar
topFill.BorderSizePixel = 0
topFill.Parent = top

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(14, 0)
title.Size = UDim2.new(1, -64, 1, 0)
title.Font = FONT_BOLD
title.Text = "Zero HUB  |  บันทึกการอัปเดต"
title.TextColor3 = C.text
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = top

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -8, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(32, 32)
closeBtn.BackgroundColor3 = C.close
closeBtn.Font = FONT_BOLD
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.Parent = top
corner(closeBtn, 8)

-- พื้นที่เลื่อน
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "List"
scroll.Position = UDim2.fromOffset(0, 42)
scroll.Size = UDim2.new(1, 0, 1, -42)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = C.accent
scroll.CanvasSize = UDim2.new()
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = main
pad(scroll, 10)

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scroll

-- ============================================================
-- สร้างการ์ดอัปเดตแต่ละเวอร์ชัน
-- ============================================================
local function makeLabel(parentObj, order, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.LayoutOrder = order
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.TextWrapped = true
    l.RichText = true
    l.Font = font or FONT
    l.TextSize = size or 14
    l.TextColor3 = color or C.text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.Text = text
    l.Parent = parentObj
    return l
end

for index, u in ipairs(UPDATES) do
    local card = Instance.new("Frame")
    card.LayoutOrder = index
    card.Size = UDim2.new(1, -8, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0
    card.Parent = scroll
    corner(card, 10)
    pad(card, 10)

    local cl = Instance.new("UIListLayout")
    cl.Padding = UDim.new(0, 5)
    cl.SortOrder = Enum.SortOrder.LayoutOrder
    cl.Parent = card

    local head = string.format(
        '<font color="#A58BFF"><b>%s</b></font>  <font color="#AAAABE">%s</font>',
        u.version, u.date
    )
    if index == 1 then
        head = head .. '  <font color="#4CD07D"><b>[ล่าสุด]</b></font>'
    end
    makeLabel(card, 1, head, 16, C.text, FONT_BOLD)

    if u.title and u.title ~= "" then
        makeLabel(card, 2, u.title, 13, C.sub)
    end

    for i, item in ipairs(u.items) do
        local tag = TAGS[item[1]] or {"#FFFFFF", item[1]}
        makeLabel(card, 2 + i, string.format(
            '<font color="%s"><b>[%s]</b></font> %s', tag[1], tag[2], item[2]
        ), 14)
    end
end

-- ============================================================
-- ลากหน้าต่าง (จับที่แถบหัว)
-- ============================================================
local dragging, dragStart, startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ============================================================
-- ปุ่มปิด
-- ============================================================
closeBtn.MouseButton1Click:Connect(function()
    local t = TweenService:Create(main, TweenInfo.new(0.18), {
        Size = UDim2.fromScale(0, 0),
    })
    t:Play()
    t.Completed:Wait()
    gui:Destroy()
end)
