--[[
    Zero HUB - หน้าอธิบายคู่มือการตั้งค่า (Guide GUI)
    - แสดงเฉพาะข้อมูลอธิบาย ไม่มีฟังก์ชันโกงใด ๆ
    - แบ่งเป็นแท็บ เลื่อนอ่านได้ ลากหน้าต่างได้ มีปุ่มปิด (X)
    - รองรับทั้งมือถือและคอม
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local GUI_NAME = "ZeroHUB_GuideGUI"

-- เลือกที่วาง GUI
local function getParent()
    local ok, ui = pcall(function()
        return gethui and gethui()
    end)
    if ok and ui then return ui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local parent = getParent()
local old = parent:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

-- ============================================================
-- เนื้อหา  {"h", หัวข้อ} | {"i", ชื่อฟังก์ชัน, คำอธิบาย} | {"n", หมายเหตุ}
-- ============================================================
local PAGES = {
    {
        name = "เริ่มต้น",
        blocks = {
            {"n", "⚠ คำเตือน: สคริปต์นี้แก้ไขการทำงานของเกมฝั่งผู้เล่นและเรียก RemoteEvent อาจทำให้ระบบไม่ทำงานหลังเกมอัปเดต เกมค้าง หรือเสี่ยงต่อการถูกตรวจจับ/แบนได้"},
            {"h", "ลำดับการเปิดใช้งานที่แนะนำ"},
            {"i", "1.", "เปิดเฉพาะ UI และตรวจว่าหน้าต่างทำงานปกติ"},
            {"i", "2.", "เปิด ESP ทีละประเภท เพื่อดูว่าชื่อ object ในแมพตรงกับที่โค้ดค้นหาหรือไม่"},
            {"i", "3.", "เปิดระบบ movement เช่น Fly/Follow ทีละระบบ ไม่ควรเปิดพร้อมกัน"},
            {"i", "4.", "ระบบที่เรียก RemoteEvent อาจไม่ทำงานหากเกมอัปเดตชื่อ remote"},
            {"i", "5.", "หากค้าง ให้ปิดเมนู รีเซ็ตตัวละคร หรือเข้าเซิร์ฟเวอร์ใหม่"},
            {"i", "6.", "ถ้ามี error ให้ดู Roblox Console / Delta Console แล้วเก็บข้อความ error พร้อมบรรทัดที่เกิด"},
            {"h", "สรุปสั้น ๆ แต่ละหมวด"},
            {"i", "Main", "เล็งอัตโนมัติ, silent aim, crosshair, FOV"},
            {"i", "Combat", "movement, ช่วยต่อสู้, fake perks, แสง/อากาศ"},
            {"i", "Killer", "โจมตีอัตโนมัติ, hitbox, Abyss, Hidden, Myers, หอก, พลัง Killer"},
            {"i", "Visual", "ESP ผู้เล่น, Generator, Pallet, Hook, Window, Gate"},
            {"i", "Follow", "ติดตาม, วาร์ป, noclip และบิน"},
            {"i", "Music", "เล่นเสียง Roblox"},
            {"i", "UI Settings", "พื้นหลัง, ชื่อปลอม, cursor, รูปลักษณ์ตัวละคร"},
            {"i", "Info", "ข้อมูลสคริปต์และ Discord"},
        },
    },
    {
        name = "Main",
        blocks = {
            {"h", "เล็งเงียบ (ชะตาพลิกผัน)"},
            {"i", "เล็งเงียบ", "เปลี่ยนทิศทางการยิงของไอเทม Twist of Fate ไปยังเป้าหมาย โดยไม่ต้องหันกล้องตรงไปที่เป้า"},
            {"i", "วงมุมมอง", "แสดงวง FOV บอกขอบเขตที่ระบบจะเลือกเป้าหมาย"},
            {"i", "ตัวชี้เป้าหมาย", "แสดงข้อมูล/ตัวชี้ของเป้าหมายที่กำลังติดตาม"},
            {"i", "เส้นชี้", "แสดงเส้นจากตำแหน่งยิงไปยังเป้าหมาย"},
            {"i", "แสดงชื่อ/ระยะ", "แสดงชื่อและระยะของเป้าหมายบนหน้าจอ"},
            {"i", "รัศมีมุมมองของหอก", "กำหนดพื้นที่ค้นหาเป้าหมายของระบบหอก"},
            {"h", "เล็งอัตโนมัติ"},
            {"i", "ล็อกเป้า", "ค้นหาและติดตามเป้าหมายอัตโนมัติ"},
            {"i", "เช็คกำแพง", "ตั้งค่าว่าจะพิจารณาสิ่งกีดขวาง/กำแพงหรือไม่"},
            {"i", "การทำนาย/เคลื่อนที่", "คาดการณ์ตำแหน่งถัดไปของเป้าหมายที่เคลื่อนที่"},
            {"i", "เป้าหมายเล็งอัตโนมัติ", "เลือก ฆาตกร, ผู้รอดชีวิต หรือ SCP"},
            {"i", "ระยะวงมุมมอง", "กำหนดขนาดพื้นที่ค้นหา ประมาณ 50–600"},
            {"i", "ดูดล็อก", "กำหนดความแรงในการปรับทิศเข้าหาเป้าหมาย"},
            {"h", "ล็อกเป้าด้วยไฟฉาย"},
            {"i", "ล็อกเป้าด้วยไฟฉาย", "พยายามปรับทิศของไฟฉายไปยังเป้าหมาย"},
            {"i", "ความนุ่มนวล", "ควบคุมความเร็วการหมุน ค่าน้อยจะนุ่มกว่าแต่ช้ากว่า"},
            {"h", "เป้าเล็ง (Crosshair)"},
            {"i", "เป้าเล็ง", "เปิด/ปิด crosshair ตรงกลางหน้าจอ"},
            {"i", "สี / รูปแบบ", "รูปแบบ: จุด, วงกลม, วงกลม+จุด, บวก, X, T, สี่เหลี่ยม"},
            {"i", "ขนาด / ความโปร่งใส", "ปรับขนาด 1–10 และความชัดของเป้าเล็ง"},
            {"h", "ฟังก์ชันสำคัญ"},
            {"i", "ล็อกมุมมอง", "บังคับค่ามุมมองกล้องตามค่าที่เลือก"},
            {"i", "ค่ามุมมอง", "กำหนด FOV ประมาณ 40–120"},
            {"i", "เคอร์เซอร์กำหนดเอง", "ใช้เคอร์เซอร์ของ UI แทนเคอร์เซอร์ปกติ"},
            {"i", "ปิดสคริปต์", "unload เมนู UI แต่ connection บางชนิดอาจต้องรีเซ็ตตัวละครหรือเข้าเกมใหม่เพื่อหยุดทั้งหมด"},
        },
    },
    {
        name = "Combat",
        blocks = {
            {"h", "ข้ามสิ่งกีดขวางเร็ว"},
            {"i", "ข้ามสิ่งกีดขวางไว", "เปิดระบบปรับความเร็วการ vault"},
            {"i", "บูสต์ Flowstate", "ทำงานร่วมกับ fake perk เมื่อปีนข้าม/ตกจากที่สูง"},
            {"i", "ความเร็วการปีนข้าม", "ประมาณ 1.0–3.0"},
            {"h", "ฟังก์ชันช่วยเหลือ"},
            {"i", "เดินทะลุ", "ปิดการชนของชิ้นส่วนตัวละคร เดินผ่านสิ่งกีดขวางได้"},
            {"i", "กันล้ม/น็อคดาวน์", "พยายามป้องกันสถานะล้ม/น็อคดาวน์ฝั่ง client"},
            {"i", "ป้องกันความเสียหายจากการตก", "พยายามดักหรือปิด fall damage"},
            {"i", "วิ่งเร็ว", "ตั้ง WalkSpeed สูงกว่าปกติ (ปรับได้ประมาณ 16–60)"},
            {"h", "แสงและสภาพอากาศ"},
            {"i", "ธีมอากาศและท้องฟ้า", "ค่าเริ่มต้น, หิมะคริสต์มาส, ฝนพายุ, ซากุระ, Blood Moon, เที่ยงคืน"},
            {"i", "สว่างทั่วแมพ", "เพิ่มความสว่างของฉากฝั่ง client"},
            {"i", "ลบหมอก", "ตั้งระยะหมอกให้ไกลมากเพื่อมองเห็นไกลขึ้น"},
            {"i", "เพิ่ม FPS", "ลด/ปรับวัสดุและเอฟเฟกต์เพื่อให้ภาพลื่นขึ้น"},
            {"i", "โหมดภาพดินน้ำมัน", "ลดรายละเอียดวัสดุเพื่อช่วยประสิทธิภาพหรือเปลี่ยนรูปลักษณ์"},
            {"h", "ล็อก/ช่วยเหลืออื่น"},
            {"i", "เดินถอยหลัง / Moonwalk", "รูปแบบ Classic หรือ Sway"},
            {"i", "ความกว้าง/ความเร็วการแกว่ง", "ปรับความแรงและความเร็วของการแกว่ง"},
            {"i", "ย่อตัวอัตโนมัติ", "พยายามย่อตัวเมื่อเข้าใกล้เป้าหมายในรัศมีที่กำหนด (รัศมี 5–40)"},
            {"h", "ฮีลทันที"},
            {"i", "ฮีลทันที", "ช่วยให้ฮีลเสร็จเร็วขึ้น"},
            {"i", "ล็อกตำแหน่งปุ่มฮีล", "ไม่ให้ปุ่มฮีลถูกลากย้าย"},
            {"h", "ระบบสิทธิพิเศษปลอม"},
            {"n", "ต้องเปิด “สวิตช์หลัก” ก่อน ตัวเลือกด้านล่างจึงจะมีผล"},
            {"i", "ปีนข้าม", "เปิดผล Flowstate เมื่อ vault"},
            {"i", "ถูกรักษาเสร็จ", "เปิดผล QuickRecovery เมื่อการรักษาจบ"},
            {"i", "ตกจากที่สูง", "เปิดผล PerfectLanding หลังตกและลงพื้น"},
            {"i", "ดิ้นออกจากฆาตกร", "พยายามเปิดผล KillerHit"},
            {"i", "อะดรีนาลีนพลุ่งพล่าน", "พยายามเพิ่มความเร็วเมื่อพลังชีวิตลดลงตามเงื่อนไข"},
        },
    },
    {
        name = "Killer",
        blocks = {
            {"h", "ความสามารถฆาตกร"},
            {"i", "โจมตีอัตโนมัติ", "ตรวจ Survivor ในระยะและเรียก BasicAttack อัตโนมัติ (ระยะ 5–20)"},
            {"i", "ขยายขอบเขตการโจมตี", "ขยาย HumanoidRootPart ของ Survivor ที่พบ (ขนาด 5–40)"},
            {"i", "ฆ่าผู้เล่นทั้งหมด", "ชื่ออาจสื่อว่าโจมตีทั้งหมด แต่โค้ดจริงเลือก Survivor ที่ใกล้ที่สุดและโจมตีตามเงื่อนไข"},
            {"i", "สกิล Abyss ไม่จำกัด", "ค้นหา function ภายใน client แล้วแก้สถานะ Immobile/cooldown"},
            {"i", "สกิล Hidden ไม่จำกัด", "พยายามล้าง boolean ที่จำกัดการใช้สกิล"},
            {"i", "จับไม่จำกัด (Myers)", "แสดงปุ่มจับ เลือกผู้เล่นใกล้สุดเพื่อเรียก remote จับ"},
            {"i", "ขนาด/ล็อกปุ่มจับ", "ปรับขนาดปุ่ม 44–110 และล็อกตำแหน่งปุ่ม"},
            {"n", "ระบบข้ามคูลดาวน์ Veil และการไล่ล่าไม่จำกัด Jason ถูกลบออกจากเวอร์ชันนี้แล้ว"},
            {"h", "หอกเงียบ (Veil)"},
            {"n", "Veil ในหัวข้อนี้คือระบบหอก/เส้นชี้ ไม่ใช่ระบบข้ามคูลดาวน์ที่ถูกลบ"},
            {"i", "หอกเงียบ", "ช่วยเลือกเป้าหมายของหอก"},
            {"i", "วง FOV / ตัวบอกเป้าหมาย", "แสดงวงพื้นที่ค้นหาและเป้าหมายที่เลือก"},
            {"i", "เส้นชี้หอก / แสดงข้อความ", "วาดเส้นไปยังเป้าหมายพร้อมชื่อ/ข้อมูล"},
            {"i", "รัศมี FOV / ระยะเส้นชี้สูงสุด", "ปรับพื้นที่ค้นหาและจำกัดระยะเส้น"},
            {"i", "Prediction / Damping", "คาดการณ์ตำแหน่ง และลดการส่ายหรือเปลี่ยนทิศกะทันหัน"},
            {"h", "ควบคุมพลัง (หน้ากาก)"},
            {"i", "หน้ากาก", "งู, หมีม่วง, เป็ด, กระต่าย, เสือ และปิดหน้ากาก (ปกติ)"},
            {"n", "ระบบจะตรวจว่าอยู่ทีม Killer ก่อน หากไม่ใช่จะไม่เรียกใช้"},
            {"h", "ตัวเลือกอื่น"},
            {"i", "พับไม้ทั้งหมดในแมพ", "ค้นหา pallet แล้วเรียก event ที่เกี่ยวข้อง"},
            {"i", "บล็อกหน้าต่างทั้งหมด", "เรียก event ของ vault/window กับจุดต่าง ๆ ในแมพ"},
            {"i", "ป้องกันตาพร่ามัว", "พยายามลดผลจากไฟ/เอฟเฟกต์ตาพร่า"},
        },
    },
    {
        name = "Visual",
        blocks = {
            {"h", "แสดงข้อมูลสิ่งมีชีวิต"},
            {"i", "ชื่อ / เส้นขอบ Killer", "แสดงชื่อและ Highlight รอบ Killer"},
            {"i", "ชื่อ / เส้นขอบ Survivor", "แสดงชื่อและ Highlight รอบ Survivor"},
            {"i", "ข้อมูล / ชื่อ SCP", "แสดงข้อมูลและชื่อ SCP/object ที่ตรวจพบ"},
            {"i", "ระยะสูงสุด", "จำกัดระยะ ESP แยกกันของ Killer, Survivor และ SCP"},
            {"i", "สี", "เลือกสีของ Killer / Survivor / SCP"},
            {"i", "ความโปร่งใสพื้น", "ปรับความโปร่งใสของพื้นที่ Highlight"},
            {"h", "แสดงข้อมูลวัตถุ"},
            {"i", "เครื่องปั่นไฟ", "แสดงตำแหน่ง Generator พร้อมเลือกสีได้"},
            {"i", "ความคืบหน้าเครื่องปั่นไฟ", "แสดงเปอร์เซ็นต์การซ่อม"},
            {"i", "แสดงจำนวนผู้เล่น/ฆาตกร", "แสดงข้อมูลที่อ่านได้จาก Generator"},
            {"i", "หน้าต่าง", "แสดงตำแหน่ง Window/Vault"},
            {"i", "แผงไม้", "แสดงตำแหน่ง Pallet"},
            {"i", "ตะขอ", "แสดงตำแหน่ง Hook"},
            {"i", "ประตูทางออก", "แสดงตำแหน่ง Exit Gate"},
            {"n", "แต่ละประเภทมี color picker ของตัวเอง"},
        },
    },
    {
        name = "Follow",
        blocks = {
            {"h", "ติดตาม / วาร์ป"},
            {"i", "เลือกผู้เล่น", "เลือกผู้เล่นจากรายชื่อ"},
            {"i", "ติดตาม / หยุด", "เคลื่อนตัวละครเข้าหาเป้าหมายทุก Heartbeat และเปิด noclip ระหว่างติดตาม"},
            {"i", "วาร์ปไปหาผู้เล่น", "ย้ายตัวละครไปยังตำแหน่งเป้าหมายทันที"},
            {"i", "รีเฟรชรายชื่อผู้เล่น", "อัปเดตรายชื่อใน dropdown"},
            {"n", "เมื่อหยุดติดตาม ระบบจะพยายามคืนค่า CanCollide ของชิ้นส่วนตัวละครกลับเป็นเดิม"},
            {"h", "ระบบบิน"},
            {"i", "แสดงปุ่มบิน", "แสดงปุ่มควบคุมเท่านั้น ยังไม่เริ่มบินทันที"},
            {"i", "ปุ่ม บิน: เปิด/ปิด", "เริ่มหรือหยุดบิน"},
            {"i", "ความเร็วบิน", "ปรับประมาณ 10–100"},
            {"i", "ปุ่มขึ้น/ลง", "ขยับตัวละครขึ้นหรือลงครั้งละประมาณ 2 studs"},
            {"n", "ถ้าตัวละครตายหรือเกิดใหม่ ระบบจะหยุดบินและซ่อนปุ่มชั่วคราว แล้วสร้างสถานะใหม่เมื่อเปิดเมนูอีกครั้ง"},
        },
    },
    {
        name = "Music",
        blocks = {
            {"h", "เครื่องเล่นเพลง"},
            {"i", "รหัสเสียง Roblox", "ใส่ Asset ID ของเสียง"},
            {"i", "เล่น", "โหลดและเล่นเสียง"},
            {"i", "หยุดชั่วคราว", "pause เสียงที่กำลังเล่น"},
            {"i", "หยุด", "หยุดและรีเซ็ตเวลากลับต้นเพลง"},
            {"i", "วนซ้ำ", "เล่นซ้ำเมื่อจบ"},
            {"i", "ระดับเสียง", "ปรับความดัง 0–1"},
            {"n", "หากเสียงเล่นไม่ได้ อาจเกิดจาก Asset ถูกลบ, ไม่อนุญาตให้ใช้ในเกม หรือ ID ไม่ถูกต้อง"},
        },
    },
    {
        name = "UI / Info",
        blocks = {
            {"h", "เมนู"},
            {"i", "เคอร์เซอร์กำหนดเอง", "เปิด/ปิด cursor ของ UI"},
            {"i", "ปิดสคริปต์", "ปิด/Unload UI หลัก"},
            {"h", "พื้นหลัง UI"},
            {"i", "เลือกรูปจากโฟลเดอร์ themes", "ค้นหารูป PNG/JPG/JPEG/WEBP จากโฟลเดอร์ที่ executor รองรับ"},
            {"i", "รีเฟรชรายการรูป", "สแกนไฟล์ใหม่"},
            {"i", "ใช้รูปที่เลือก", "ใช้รูป local ผ่าน getcustomasset หรือ getsynasset"},
            {"i", "ลิงก์รูป (สำรอง)", "ใส่ URL รูปภาพ แล้วกด “ใช้รูปจากลิงก์”"},
            {"i", "คืนพื้นหลังเดิม", "กลับไปใช้ asset พื้นหลังเดิมของสคริปต์"},
            {"h", "ชื่อปลอม (HUD)"},
            {"i", "ชื่อปลอม", "ใส่ชื่อใหม่"},
            {"i", "Apply ชื่อปลอม", "เปลี่ยน TextLabel ที่ตรงกับชื่อผู้เล่น เฉพาะฝั่ง client"},
            {"i", "Reset ชื่อเดิม", "คืนข้อความเดิมที่สคริปต์บันทึกไว้"},
            {"n", "เปลี่ยนเฉพาะข้อความบนหน้าจอเครื่องตัวเอง ไม่ได้เปลี่ยนชื่อ Roblox จริง และอาจไม่เปลี่ยนทุกจุดของ UI"},
            {"h", "ตกแต่ง"},
            {"i", "ไอเทม ช.ว / Jerk Tool", "สร้าง tool พิเศษในตัวละคร/กระเป๋าตาม logic ของสคริปต์"},
            {"i", "สกินขาหาย / Korblox", "เปลี่ยนรูปลักษณ์ขาเฉพาะฝั่ง client"},
            {"i", "สกินไร้หัว / Headless", "เปลี่ยนรูปลักษณ์หัวเฉพาะฝั่ง client"},
            {"h", "Info"},
            {"i", "ข้อมูลสคริปต์", "แสดงเวอร์ชัน ชื่อสคริปต์ ชื่อเกม และปุ่มคัดลอก Discord ของผู้พัฒนา"},
        },
    },
}

-- ============================================================
-- ธีมสี
-- ============================================================
local C = {
    bg      = Color3.fromRGB(22, 22, 30),
    bar     = Color3.fromRGB(30, 30, 42),
    panel   = Color3.fromRGB(28, 28, 38),
    accent  = Color3.fromRGB(120, 90, 255),
    tabOff  = Color3.fromRGB(44, 44, 60),
    text    = Color3.fromRGB(235, 235, 245),
    sub     = Color3.fromRGB(170, 170, 190),
    warn    = Color3.fromRGB(255, 190, 80),
    close   = Color3.fromRGB(220, 70, 80),
}

local FONT = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

local function pad(obj, p)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0, p)
    u.PaddingBottom = UDim.new(0, p)
    u.PaddingLeft = UDim.new(0, p)
    u.PaddingRight = UDim.new(0, p)
    u.Parent = obj
end

-- ============================================================
-- สร้าง GUI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = parent

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromScale(0.92, 0.8)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
corner(main, 12)

local limit = Instance.new("UISizeConstraint")
limit.MaxSize = Vector2.new(580, 420)
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

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(14, 0)
title.Size = UDim2.new(1, -64, 1, 0)
title.Font = FONT_BOLD
title.Text = "Zero HUB  |  คู่มือการตั้งค่า"
title.TextColor3 = C.text
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = top

-- ปุ่มปิด
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -8, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(32, 32)
closeBtn.BackgroundColor3 = C.close
closeBtn.AutoButtonColor = true
closeBtn.Font = FONT_BOLD
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.Parent = top
corner(closeBtn, 8)

-- แถบแท็บ
local tabBar = Instance.new("ScrollingFrame")
tabBar.Name = "Tabs"
tabBar.Position = UDim2.fromOffset(0, 42)
tabBar.Size = UDim2.new(1, 0, 0, 44)
tabBar.BackgroundColor3 = C.panel
tabBar.BorderSizePixel = 0
tabBar.ScrollBarThickness = 0
tabBar.CanvasSize = UDim2.new()
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Parent = tabBar

local tabPad = Instance.new("UIPadding")
tabPad.PaddingLeft = UDim.new(0, 8)
tabPad.PaddingRight = UDim.new(0, 8)
tabPad.Parent = tabBar

-- พื้นที่เนื้อหา
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Position = UDim2.fromOffset(0, 86)
content.Size = UDim2.new(1, 0, 1, -86)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = C.accent
content.CanvasSize = UDim2.new()
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.Parent = main
pad(content, 10)

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content

-- ============================================================
-- แสดงหน้าเนื้อหา
-- ============================================================
local function makeLabel(order)
    local l = Instance.new("TextLabel")
    l.LayoutOrder = order
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, -8, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.TextWrapped = true
    l.RichText = true
    l.Font = FONT
    l.TextSize = 14
    l.TextColor3 = C.text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.Parent = content
    return l
end

local function renderPage(index)
    for _, ch in ipairs(content:GetChildren()) do
        if ch:IsA("TextLabel") or ch:IsA("Frame") then
            ch:Destroy()
        end
    end

    for order, b in ipairs(PAGES[index].blocks) do
        local kind = b[1]
        if kind == "h" then
            local l = makeLabel(order)
            l.Font = FONT_BOLD
            l.TextSize = 16
            l.TextColor3 = C.accent
            l.Text = b[2]
        elseif kind == "i" then
            local l = makeLabel(order)
            l.Text = string.format(
                '<b>%s</b>  <font color="#AAAABE">— %s</font>', b[2], b[3]
            )
        elseif kind == "n" then
            local box = Instance.new("Frame")
            box.LayoutOrder = order
            box.Size = UDim2.new(1, -8, 0, 0)
            box.AutomaticSize = Enum.AutomaticSize.Y
            box.BackgroundColor3 = Color3.fromRGB(50, 42, 28)
            box.BorderSizePixel = 0
            box.Parent = content
            corner(box, 8)
            pad(box, 8)

            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 0, 0)
            l.AutomaticSize = Enum.AutomaticSize.Y
            l.TextWrapped = true
            l.Font = FONT
            l.TextSize = 13
            l.TextColor3 = C.warn
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Text = b[2]
            l.Parent = box
        end
    end

    content.CanvasPosition = Vector2.new(0, 0)
end

-- ============================================================
-- สร้างปุ่มแท็บ
-- ============================================================
local tabButtons = {}

local function selectTab(index)
    for i, btn in ipairs(tabButtons) do
        local active = (i == index)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = active and C.accent or C.tabOff,
        }):Play()
        btn.TextColor3 = active and Color3.new(1, 1, 1) or C.sub
    end
    renderPage(index)
end

for i, page in ipairs(PAGES) do
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = i
    btn.AutomaticSize = Enum.AutomaticSize.X
    btn.Size = UDim2.fromOffset(0, 30)
    btn.BackgroundColor3 = C.tabOff
    btn.AutoButtonColor = false
    btn.Font = FONT_BOLD
    btn.Text = page.name
    btn.TextColor3 = C.sub
    btn.TextSize = 14
    btn.Parent = tabBar
    corner(btn, 8)

    local bp = Instance.new("UIPadding")
    bp.PaddingLeft = UDim.new(0, 12)
    bp.PaddingRight = UDim.new(0, 12)
    bp.Parent = btn

    btn.MouseButton1Click:Connect(function()
        selectTab(i)
    end)
    tabButtons[i] = btn
end

selectTab(1)

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
