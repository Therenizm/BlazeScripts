-- 🔥 BLAZE HUB v3.5
local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local CONFIG = {
    KeysURL          = "https://api.jsonbin.io/v3/b/69ad3c7143b1c97be9c070a6",
    GamesURL         = "https://api.jsonbin.io/v3/b/69ad4de4d0ea881f40fc0818",
    ScriptsBaseURL   = "https://raw.githubusercontent.com/Therenizm/BlazeScripts/main/scripts/",
    LootlabsURL      = "https://loot-link.com/s?Wvw1wEfn",
    LinkvertiseURL   = "https://link-target.net/3148707/whwaXGWoXtTr",
    KeyDurationHours = 24,
    Owner            = "Therenizm",
}

-- scripts.json'dan oyun verisini çek
local CGAME = nil
task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet(CONFIG.GamesURL) end)
    if not ok then return end
local ok2, data = pcall(HttpService.JSONDecode, HttpService, res)
if not ok2 or type(data) ~= "table" then return end
local placeId = tostring(game.PlaceId)
local games = (data.record and data.record.games) or data.games
if not games then return end
local gameData = games[placeId]
if not gameData then return end
CGAME = gameData
end)

-- KEY SYSTEM
local function readKey()
    if readfile then
        local ok,d=pcall(readfile,"BlazeHub_Key.txt")
        if ok and d and d~="" then
            local k,ts=d:match("^(.+)|(%d+)$")
            if k and ts and (os.time()-tonumber(ts))<(CONFIG.KeyDurationHours*3600) then return k,true end
        end
    end
    return nil,false
end
local function saveKey(k) if writefile then pcall(writefile,"BlazeHub_Key.txt",k.."|"..os.time()) end end
local function checkKey(input)
    local ok,res=pcall(function() return game:HttpGet(CONFIG.KeysURL) end)
    if not ok then return false,"Cannot reach server!" end
    local ok2,data=pcall(HttpService.JSONDecode,HttpService,res)
    if not ok2 or type(data)~="table" then return false,"Key list unreadable!" end
    local list=(data.record and data.record.keys) or data.keys
    if list then for _,k in ipairs(list) do if k==input then return true end end end
    return false,"Invalid key!"
end
local function runScript(f)
    pcall(function() loadstring(game:HttpGet(CONFIG.ScriptsBaseURL..f))() end)
end

-- COLORS
local BG   = Color3.fromRGB(8,6,16)
local WIN  = Color3.fromRGB(13,9,26)
local TOP1 = Color3.fromRGB(55,12,140)
local TOP2 = Color3.fromRGB(132,54,240)
local TAB  = Color3.fromRGB(16,11,32)
local TACT = Color3.fromRGB(30,20,58)
local CARD = Color3.fromRGB(18,13,35)
local CRDH = Color3.fromRGB(28,20,52)
local INP  = Color3.fromRGB(14,10,28)
local PRP  = Color3.fromRGB(135,55,242)
local PRPL = Color3.fromRGB(182,108,255)
local PRPD = Color3.fromRGB(68,16,152)
local BORD = Color3.fromRGB(128,48,238)
local BRDM = Color3.fromRGB(62,20,132)
local NEON = Color3.fromRGB(218,152,255)
local WHT  = Color3.fromRGB(255,255,255)
local GRY  = Color3.fromRGB(145,122,172)
local DIM  = Color3.fromRGB(115,92,150)
local SUC  = Color3.fromRGB(58,242,122)
local ERR  = Color3.fromRGB(255,62,85)
local WRN  = Color3.fromRGB(255,188,48)
local GRN  = Color3.fromRGB(26,150,65)
local BLU  = Color3.fromRGB(30,85,205)

-- HELPERS
local function TW(o,t,p) return TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p) end
local function RND(p,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p return c end
local function BRD(p,c,t) local s=Instance.new("UIStroke") s.Color=c s.Thickness=t or 1.5 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=p return s end
local function GRD(p,c0,c1,rot) local g=Instance.new("UIGradient") g.Color=ColorSequence.new(c0,c1) g.Rotation=rot or 0 g.Parent=p end
local function PDG(p,a,b,c,d) local u=Instance.new("UIPadding") u.PaddingTop=UDim.new(0,a) u.PaddingBottom=UDim.new(0,b or a) u.PaddingLeft=UDim.new(0,c or a) u.PaddingRight=UDim.new(0,d or a) u.Parent=p end
local function LBL(par,txt,sz,col,bold,xa)
    local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Text=txt l.TextColor3=col
    l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham l.TextSize=sz l.TextWrapped=true
    l.TextXAlignment=xa or Enum.TextXAlignment.Left l.ZIndex=25 l.Size=UDim2.new(1,0,1,0) l.Parent=par return l
end
local function VLT(p,pad,gap)
    PDG(p,pad,pad,pad,pad)
    local l=Instance.new("UIListLayout") l.Padding=UDim.new(0,gap or 9) l.SortOrder=Enum.SortOrder.LayoutOrder l.Parent=p
end

-- SCREEN GUI
local SG=Instance.new("ScreenGui")
SG.Name="BlazeHub35" SG.ResetOnSpawn=false SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG.IgnoreGuiInset=true SG.Parent=game:GetService("CoreGui")

local BGF=Instance.new("Frame") BGF.Size=UDim2.new(1,0,1,0) BGF.BackgroundColor3=BG BGF.BorderSizePixel=0 BGF.ZIndex=1 BGF.Parent=SG
local pts={}
local function spawnPt()
    local f=Instance.new("Frame") local s=math.random(2,4)
    f.Size=UDim2.new(0,s,0,s) f.BackgroundColor3=Color3.fromRGB(math.random(95,182),math.random(28,72),math.random(208,255))
    f.BorderSizePixel=0 f.ZIndex=2 f.Position=UDim2.new(math.random(),0,math.random(),0)
    f.BackgroundTransparency=math.random(50,78)/100 RND(f,s) f.Parent=BGF
    table.insert(pts,{f=f,vx=(math.random()-.5)*.00022,vy=-math.random(1,3)*.00015,a=math.random(50,78)/100,pulse=math.random()*math.pi*2,age=0,life=math.random(130,250)})
end
for _=1,26 do spawnPt() end

-- WINDOW
local W,H=620,500
local Win=Instance.new("Frame")
Win.Size=UDim2.new(0,0,0,0) Win.Position=UDim2.new(0.5,0,0.5,0)
Win.BackgroundColor3=WIN Win.BorderSizePixel=0 Win.ZIndex=10 Win.ClipsDescendants=true Win.Parent=SG
RND(Win,16) local WB=BRD(Win,BORD,2) GRD(Win,Color3.fromRGB(15,9,30),Color3.fromRGB(7,4,16),130)
local Shd=Instance.new("ImageLabel") Shd.BackgroundTransparency=1 Shd.Image="rbxassetid://5554236805"
Shd.ImageColor3=PRP Shd.ImageTransparency=0.42 Shd.ScaleType=Enum.ScaleType.Slice Shd.SliceCenter=Rect.new(23,23,277,277)
Shd.Size=UDim2.new(1,90,1,90) Shd.Position=UDim2.new(0,-45,0,-45) Shd.ZIndex=9 Shd.Parent=Win

-- TOP BAR
local TB=Instance.new("Frame")
TB.Size=UDim2.new(1,0,0,50) TB.Position=UDim2.new(0,0,0,0)
TB.BackgroundColor3=Color3.fromRGB(55,12,140) TB.BorderSizePixel=0 TB.ZIndex=30 TB.Parent=Win
GRD(TB,TOP1,TOP2,0)

local LF=Instance.new("Frame") LF.Size=UDim2.new(0,195,1,0) LF.Position=UDim2.new(0,14,0,0) LF.BackgroundTransparency=1 LF.ZIndex=31 LF.Parent=TB
local ll=LBL(LF,"🔥",21,WHT,true,Enum.TextXAlignment.Left) ll.Size=UDim2.new(0,24,1,0) ll.ZIndex=32
local ln=LBL(LF,"Blaze Hub",19,WHT,true,Enum.TextXAlignment.Left) ln.Size=UDim2.new(1,-28,1,0) ln.Position=UDim2.new(0,28,0,0) ln.ZIndex=32

local GP=Instance.new("Frame") GP.Size=UDim2.new(0,180,0,28) GP.Position=UDim2.new(0.5,-90,0.5,-14)
GP.BackgroundColor3=Color3.fromRGB(16,8,38) GP.ZIndex=31 GP.Parent=TB GP.Visible=false RND(GP,9) BRD(GP,BRDM,1)
local gt=LBL(GP,"",12,PRPL,true,Enum.TextXAlignment.Center) gt.ZIndex=32

local VP=Instance.new("TextLabel") VP.Size=UDim2.new(0,46,0,22) VP.Position=UDim2.new(1,-126,0.5,-11)
VP.BackgroundColor3=Color3.fromRGB(38,12,95) VP.Text="v3.5" VP.TextColor3=PRPL VP.Font=Enum.Font.GothamBold VP.TextSize=11 VP.ZIndex=31 VP.Parent=TB RND(VP,7) BRD(VP,BRDM,1)

local MinB=Instance.new("TextButton") MinB.Size=UDim2.new(0,26,0,26) MinB.Position=UDim2.new(1,-68,0.5,-13)
MinB.BackgroundColor3=Color3.fromRGB(46,34,70) MinB.Text="─" MinB.TextColor3=GRY MinB.Font=Enum.Font.GothamBold MinB.TextSize=12 MinB.ZIndex=32 MinB.Parent=TB RND(MinB,7)
local ClsB=Instance.new("TextButton") ClsB.Size=UDim2.new(0,26,0,26) ClsB.Position=UDim2.new(1,-34,0.5,-13)
ClsB.BackgroundColor3=Color3.fromRGB(192,42,62) ClsB.Text="✕" ClsB.TextColor3=WHT ClsB.Font=Enum.Font.GothamBold ClsB.TextSize=13 ClsB.ZIndex=32 ClsB.Parent=TB RND(ClsB,7)
ClsB.MouseButton1Click:Connect(function() TW(Win,.28,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play() task.wait(.31) SG:Destroy() end)
local minimized=false MinB.MouseButton1Click:Connect(function() minimized=not minimized TW(Win,.28,{Size=minimized and UDim2.new(0,W,0,50) or UDim2.new(0,W,0,H)}):Play() MinB.Text=minimized and "□" or "─" end)

local dg,dS,dP=false,nil,nil
TB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=true dS=i.Position dP=Win.Position end end)
UserInputService.InputChanged:Connect(function(i) if dg and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-dS Win.Position=UDim2.new(dP.X.Scale,dP.X.Offset+d.X,dP.Y.Scale,dP.Y.Offset+d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=false end end)

-- TAB BAR
local TABH=44
local TabBar=Instance.new("Frame")
TabBar.Size=UDim2.new(1,0,0,TABH) TabBar.Position=UDim2.new(0,0,0,50)
TabBar.BackgroundColor3=TAB TabBar.BorderSizePixel=0 TabBar.ZIndex=30 TabBar.Parent=Win

local sep1=Instance.new("Frame") sep1.Size=UDim2.new(1,0,0,1) sep1.BackgroundColor3=BORD sep1.BorderSizePixel=0 sep1.ZIndex=31 sep1.Parent=TabBar
local sep2=Instance.new("Frame") sep2.Size=UDim2.new(1,0,0,1) sep2.Position=UDim2.new(0,0,1,-1) sep2.BackgroundColor3=BRDM sep2.BorderSizePixel=0 sep2.ZIndex=31 sep2.Parent=TabBar

local PSTART=50+TABH
local PageArea=Instance.new("Frame")
PageArea.Size=UDim2.new(1,0,0,H-PSTART) PageArea.Position=UDim2.new(0,0,0,PSTART)
PageArea.BackgroundTransparency=1 PageArea.ZIndex=11 PageArea.ClipsDescendants=true PageArea.Parent=Win

local TABNAMES={"Scripts","Key","Misc"}
local TABICONS={Scripts="🎮",Key="🔑",Misc="⚙️"}
local TW3=math.floor(W/#TABNAMES)

local keyValidated=false
local activeTab=nil
local tabBtns={}
local tabPages={}

for i,name in ipairs(TABNAMES) do
    local xoff=(i-1)*TW3
    local btn=Instance.new("TextButton")
    btn.Name="Tab"..name btn.Size=UDim2.new(0,TW3,1,0) btn.Position=UDim2.new(0,xoff,0,0)
    btn.BackgroundColor3=TAB btn.Text=TABICONS[name].."  "..name btn.TextColor3=DIM
    btn.Font=Enum.Font.GothamBold btn.TextSize=14 btn.ZIndex=32 btn.BorderSizePixel=0
    btn.AutoButtonColor=false btn.Parent=TabBar

    local ind=Instance.new("Frame")
    ind.Size=UDim2.new(0,0,0,3) ind.Position=UDim2.new(0.5,0,1,-3) ind.AnchorPoint=Vector2.new(0.5,0)
    ind.BackgroundColor3=PRP ind.BorderSizePixel=0 ind.ZIndex=33 ind.Parent=btn RND(ind,2)

    local page=Instance.new("ScrollingFrame")
    page.Size=UDim2.new(1,0,1,0) page.BackgroundColor3=Color3.fromRGB(8,6,16)
    page.BorderSizePixel=0 page.ScrollBarThickness=3 page.ScrollBarImageColor3=PRP
    page.CanvasSize=UDim2.new(0,0,0,0) page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    page.ZIndex=12 page.Visible=false page.Parent=PageArea

    tabBtns[name]={btn=btn,ind=ind}
    tabPages[name]=page

    btn.MouseButton1Click:Connect(function()
        if name=="Scripts" and not keyValidated then
            local origPos=btn.Position
            TW(btn,.06,{Position=UDim2.new(0,xoff+4,0,0)}):Play() task.wait(.07)
            TW(btn,.06,{Position=UDim2.new(0,xoff-4,0,0)}):Play() task.wait(.07)
            TW(btn,.06,{Position=origPos}):Play()
            return
        end
        if activeTab==name then return end
        if activeTab then
            tabBtns[activeTab].btn.TextColor3=DIM tabBtns[activeTab].btn.BackgroundColor3=TAB
            TW(tabBtns[activeTab].ind,.16,{Size=UDim2.new(0,0,0,3)}):Play()
            tabPages[activeTab].Visible=false
        end
        activeTab=name btn.TextColor3=WHT btn.BackgroundColor3=TACT
        TW(ind,.20,{Size=UDim2.new(0.7,0,0,3)}):Play() page.Visible=true
    end)
end

local function gotoTab(name)
    if activeTab then
        tabBtns[activeTab].btn.TextColor3=DIM tabBtns[activeTab].btn.BackgroundColor3=TAB
        tabBtns[activeTab].ind.Size=UDim2.new(0,0,0,3) tabPages[activeTab].Visible=false
    end
    activeTab=name tabBtns[name].btn.TextColor3=WHT tabBtns[name].btn.BackgroundColor3=TACT
    tabBtns[name].ind.Size=UDim2.new(0.7,0,0,3) tabPages[name].Visible=true
end
gotoTab("Key")

-- LOAD BAR
local function mkBar(parent,lo)
    local w=Instance.new("Frame") w.Size=UDim2.new(1,0,0,36) w.BackgroundColor3=Color3.fromRGB(13,8,26)
    w.BorderSizePixel=0 w.ZIndex=14 w.Visible=false if lo then w.LayoutOrder=lo end w.Parent=parent RND(w,10) BRD(w,BRDM,1)
    local lb=LBL(w,"Loading...",11,GRY,false,Enum.TextXAlignment.Left) lb.Size=UDim2.new(0.54,0,1,0) lb.Position=UDim2.new(0,10,0,0) lb.ZIndex=15
    local track=Instance.new("Frame") track.Size=UDim2.new(0.38,0,0,6) track.Position=UDim2.new(0.6,0,0.5,-3)
    track.BackgroundColor3=Color3.fromRGB(24,14,46) track.BorderSizePixel=0 track.ZIndex=16 track.Parent=w RND(track,3)
    local fill=Instance.new("Frame") fill.Size=UDim2.new(0,0,1,0) fill.BackgroundColor3=PRP fill.BorderSizePixel=0 fill.ZIndex=17 fill.Parent=track RND(fill,3) GRD(fill,PRP,PRPL,0)
    return w,lb,fill
end
local function runBar(lb,fill,steps,cb)
    task.spawn(function()
        for _,s in ipairs(steps) do TW(fill,s[3],{Size=UDim2.new(s[1],0,1,0)}):Play() lb.Text=s[2] task.wait(s[3]+.04) end
        task.wait(.12) if cb then cb() end
    end)
end

-- SCRIPTS PAGE
VLT(tabPages["Scripts"],12,9)

local LoadingLabel=Instance.new("Frame") LoadingLabel.Size=UDim2.new(1,0,0,40) LoadingLabel.BackgroundTransparency=1 LoadingLabel.ZIndex=13 LoadingLabel.LayoutOrder=1 LoadingLabel.Parent=tabPages["Scripts"]
local LL=LBL(LoadingLabel,"⏳  Loading scripts...",13,GRY,false,Enum.TextXAlignment.Center) LL.Size=UDim2.new(1,0,1,0)

local function buildScriptsPage()
    LoadingLabel:Destroy()

    if not CGAME then
        local NB=Instance.new("Frame") NB.Size=UDim2.new(1,0,0,88) NB.BackgroundColor3=Color3.fromRGB(26,16,8) NB.BorderSizePixel=0 NB.ZIndex=13 NB.LayoutOrder=1 NB.Parent=tabPages["Scripts"] RND(NB,12) BRD(NB,Color3.fromRGB(130,78,16),1.5)
        LBL(NB,"⚠️",28,WHT,true,Enum.TextXAlignment.Center).Size=UDim2.new(0,54,1,0)
        local NT=LBL(NB,"Game Not Supported",15,WRN,true) NT.Size=UDim2.new(1,-64,0,22) NT.Position=UDim2.new(0,60,0,13)
        local NS=LBL(NB,"No scripts for this game yet.",12,GRY) NS.Size=UDim2.new(1,-64,0,17) NS.Position=UDim2.new(0,60,0,40)
        return
    end

    gt.Text = CGAME.icon.."  "..CGAME.name
    GP.Visible = true

    local Ban=Instance.new("Frame") Ban.Size=UDim2.new(1,0,0,58) Ban.BackgroundColor3=Color3.fromRGB(18,10,40) Ban.BorderSizePixel=0 Ban.ZIndex=13 Ban.LayoutOrder=1 Ban.Parent=tabPages["Scripts"] RND(Ban,13) BRD(Ban,BORD,1.5) GRD(Ban,Color3.fromRGB(52,12,122),Color3.fromRGB(15,8,32),0)
    LBL(Ban,CGAME.icon,26,WHT,true,Enum.TextXAlignment.Center).Size=UDim2.new(0,50,1,0)
    local bt=LBL(Ban,CGAME.name,17,WHT,true) bt.Size=UDim2.new(1,-58,0,23) bt.Position=UDim2.new(0,54,0,8)
    local bs=LBL(Ban,#CGAME.scripts.." scripts — select one to load",12,GRY) bs.Size=UDim2.new(1,-58,0,17) bs.Position=UDim2.new(0,54,0,34)

    local SF=Instance.new("Frame") SF.Size=UDim2.new(1,0,0,16) SF.BackgroundTransparency=1 SF.ZIndex=13 SF.LayoutOrder=2 SF.Parent=tabPages["Scripts"]
    local SS=LBL(SF,"",12,GRY,false,Enum.TextXAlignment.Center) SS.Size=UDim2.new(1,0,1,0)

    local LBW,LBL2,LBF=mkBar(tabPages["Scripts"],3)

    local COLS,GAP,CARDH=2,9,108
    local cW=math.floor((W-24-GAP)/COLS)
    local nR=math.ceil(#CGAME.scripts/COLS)
    local Grid=Instance.new("Frame") Grid.Size=UDim2.new(1,0,0,nR*CARDH+(nR-1)*GAP) Grid.BackgroundTransparency=1 Grid.ZIndex=13 Grid.LayoutOrder=4 Grid.Parent=tabPages["Scripts"]
    local GL=Instance.new("UIGridLayout") GL.CellSize=UDim2.new(0,cW,0,CARDH) GL.CellPadding=UDim2.new(0,GAP,0,GAP) GL.SortOrder=Enum.SortOrder.LayoutOrder GL.Parent=Grid

    local busy=false
    for i,sc in ipairs(CGAME.scripts) do
        local tc=Color3.fromRGB(sc.tR,sc.tG,sc.tB)
        local Card=Instance.new("TextButton") Card.Size=UDim2.new(0,cW,0,CARDH) Card.BackgroundColor3=CARD Card.AutoButtonColor=false Card.Text="" Card.ZIndex=14 Card.LayoutOrder=i Card.Parent=Grid RND(Card,12)
        local cB=BRD(Card,BRDM,1.5) GRD(Card,Color3.fromRGB(21,14,40),Color3.fromRGB(13,9,26),135)
        local Tag=Instance.new("Frame") Tag.Size=UDim2.new(0,54,0,20) Tag.Position=UDim2.new(1,-60,0,8)
        Tag.BackgroundColor3=Color3.fromRGB(math.floor(sc.tR*.15),math.floor(sc.tG*.15),math.floor(sc.tB*.15)) Tag.ZIndex=16 Tag.Parent=Card RND(Tag,6)
        local ts=Instance.new("UIStroke") ts.Color=tc ts.Thickness=1 ts.Transparency=0.36 ts.ApplyStrokeMode=Enum.ApplyStrokeMode.Border ts.Parent=Tag
        LBL(Tag,sc.tag,10,tc,true,Enum.TextXAlignment.Center).ZIndex=17
        local CN=Instance.new("TextLabel") CN.Size=UDim2.new(1,-14,0,21) CN.Position=UDim2.new(0,9,0,34) CN.BackgroundTransparency=1 CN.Text=sc.name CN.TextColor3=WHT CN.Font=Enum.Font.GothamBold CN.TextSize=15 CN.TextXAlignment=Enum.TextXAlignment.Left CN.ZIndex=16 CN.Parent=Card
        local CD=Instance.new("TextLabel") CD.Size=UDim2.new(1,-14,0,28) CD.Position=UDim2.new(0,9,0,56) CD.BackgroundTransparency=1 CD.Text=sc.desc CD.TextColor3=GRY CD.Font=Enum.Font.Gotham CD.TextSize=11 CD.TextXAlignment=Enum.TextXAlignment.Left CD.TextWrapped=true CD.ZIndex=16 CD.Parent=Card
        local LB=Instance.new("TextButton") LB.Size=UDim2.new(1,-18,0,22) LB.Position=UDim2.new(0,9,1,-30) LB.BackgroundColor3=PRP LB.Text="▶  Load" LB.TextColor3=WHT LB.Font=Enum.Font.GothamBold LB.TextSize=12 LB.ZIndex=17 LB.Parent=Card RND(LB,7) GRD(LB,PRP,PRPD,0)
        Card.MouseEnter:Connect(function() if busy then return end TW(Card,.15,{BackgroundColor3=CRDH}):Play() cB.Color=BORD TW(LB,.12,{BackgroundColor3=PRPL}):Play() end)
        Card.MouseLeave:Connect(function() TW(Card,.15,{BackgroundColor3=CARD}):Play() cB.Color=BRDM TW(LB,.12,{BackgroundColor3=PRP}):Play() end)
        local function doLoad()
            if busy then return end busy=true
            for _,ch in ipairs(Grid:GetChildren()) do if ch:IsA("TextButton") then ch.Active=false end end
            LB.Text="⏳" SS.Text="Loading "..sc.name.."..." SS.TextColor3=GRY
            LBW.Visible=true LBL2.Text="Fetching "..sc.name.."..."
            TW(Card,.18,{BackgroundColor3=Color3.fromRGB(25,17,48)}):Play() cB.Color=BORD
            runBar(LBL2,LBF,{{.22,"Preparing...",.26},{.52,"Fetching...",.30},{.78,"Injecting...",.24},{1,"Done!",.14}},function()
                SS.Text="✔  "..sc.name.." loaded!" SS.TextColor3=SUC
                task.wait(.28) TW(Win,.32,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
                task.wait(.35) SG:Destroy() runScript(sc.file)
            end)
        end
        Card.MouseButton1Click:Connect(doLoad) LB.MouseButton1Click:Connect(doLoad)
    end
end

-- KEY PAGE
VLT(tabPages["Key"],12,9)
local function KC(p,h,lo) local c=Instance.new("Frame") c.Size=UDim2.new(1,0,0,h) c.BackgroundColor3=CARD c.BorderSizePixel=0 c.ZIndex=13 c.LayoutOrder=lo c.Parent=p RND(c,12) BRD(c,BRDM,1) return c end

local IC=KC(tabPages["Key"],55,1)
LBL(IC,"💜",20,WHT,true,Enum.TextXAlignment.Center).Size=UDim2.new(0,42,1,0)
local it=LBL(IC,"Enter your key to unlock all scripts.\nGet a key every 24h using the buttons below.",13,GRY) it.Size=UDim2.new(1,-50,1,0) it.Position=UDim2.new(0,46,0,0)

local InpC=KC(tabPages["Key"],48,2) InpC.BackgroundColor3=INP
local InpS=BRD(InpC,BRDM,1.5)
LBL(InpC,"🔑",15,WHT,true,Enum.TextXAlignment.Center).Size=UDim2.new(0,32,1,0)
local KBox=Instance.new("TextBox") KBox.Size=UDim2.new(1,-88,1,0) KBox.Position=UDim2.new(0,34,0,0) KBox.BackgroundTransparency=1 KBox.PlaceholderText="BLAZE-XXXX-XXXX-XXXX" KBox.PlaceholderColor3=Color3.fromRGB(72,52,100) KBox.Text="" KBox.TextColor3=NEON KBox.Font=Enum.Font.GothamBold KBox.TextSize=14 KBox.TextXAlignment=Enum.TextXAlignment.Left KBox.ClearTextOnFocus=false KBox.ZIndex=15 KBox.Parent=InpC
local CpB=Instance.new("TextButton") CpB.Size=UDim2.new(0,44,0,28) CpB.Position=UDim2.new(1,-48,0.5,-14) CpB.BackgroundColor3=PRPD CpB.Text="📋" CpB.TextColor3=WHT CpB.Font=Enum.Font.GothamBold CpB.TextSize=14 CpB.ZIndex=16 CpB.Parent=InpC RND(CpB,8)
CpB.MouseButton1Click:Connect(function() if setclipboard and KBox.Text~="" then setclipboard(KBox.Text) CpB.Text="✔" TW(CpB,.15,{BackgroundColor3=SUC}):Play() task.wait(1.2) CpB.Text="📋" TW(CpB,.15,{BackgroundColor3=PRPD}):Play() end end)
KBox.Focused:Connect(function() TW(InpC,.15,{BackgroundColor3=Color3.fromRGB(24,13,48)}):Play() InpS.Color=BORD InpS.Thickness=2 end)
KBox.FocusLost:Connect(function() TW(InpC,.15,{BackgroundColor3=INP}):Play() InpS.Color=BRDM InpS.Thickness=1.5 end)

local KSF=Instance.new("Frame") KSF.Size=UDim2.new(1,0,0,17) KSF.BackgroundTransparency=1 KSF.ZIndex=13 KSF.LayoutOrder=3 KSF.Parent=tabPages["Key"]
local KSL=LBL(KSF,"",12,GRY,false,Enum.TextXAlignment.Center) KSL.Size=UDim2.new(1,0,1,0)
local function setKS(m,c) KSL.Text=m KSL.TextColor3=c or GRY end

local VBtn=Instance.new("TextButton") VBtn.Size=UDim2.new(1,0,0,42) VBtn.BackgroundColor3=PRP VBtn.Text="✅   Validate Key" VBtn.TextColor3=WHT VBtn.Font=Enum.Font.GothamBold VBtn.TextSize=15 VBtn.ZIndex=14 VBtn.LayoutOrder=4 VBtn.Parent=tabPages["Key"] RND(VBtn,11) BRD(VBtn,PRPL,1) GRD(VBtn,PRP,PRPD,0)
VBtn.MouseEnter:Connect(function() TW(VBtn,.12,{BackgroundColor3=PRPL}):Play() end)
VBtn.MouseLeave:Connect(function() TW(VBtn,.12,{BackgroundColor3=PRP}):Play() end)

local KLW,KLL,KLF=mkBar(tabPages["Key"],5)

local GRow=Instance.new("Frame") GRow.Size=UDim2.new(1,0,0,36) GRow.BackgroundTransparency=1 GRow.ZIndex=14 GRow.LayoutOrder=6 GRow.Parent=tabPages["Key"]
do local ul=Instance.new("UIListLayout") ul.FillDirection=Enum.FillDirection.Horizontal ul.Padding=UDim.new(0,9) ul.Parent=GRow end
local function mkGB(txt2,bg,url)
    local b=Instance.new("TextButton") b.Size=UDim2.new(0.5,-4.5,1,0) b.BackgroundColor3=bg b.Text=txt2 b.TextColor3=WHT b.Font=Enum.Font.GothamBold b.TextSize=13 b.ZIndex=15 b.Parent=GRow RND(b,10) BRD(b,bg,1)
    b.MouseEnter:Connect(function() TW(b,.12,{BackgroundColor3=bg:Lerp(WHT,.15)}):Play() end)
    b.MouseLeave:Connect(function() TW(b,.12,{BackgroundColor3=bg}):Play() end)
    b.MouseButton1Click:Connect(function() if setclipboard then setclipboard(url) local o=b.Text b.Text="✔ Copied!" TW(b,.14,{BackgroundColor3=SUC}):Play() task.wait(1.4) b.Text=o TW(b,.14,{BackgroundColor3=bg}):Play() setKS("✔ Link copied — open in browser",SUC) end end)
end
mkGB("🟢  Lootlabs",   GRN,CONFIG.LootlabsURL)
mkGB("🔵  Linkvertise",BLU,CONFIG.LinkvertiseURL)

local HF=Instance.new("Frame") HF.Size=UDim2.new(1,0,0,16) HF.BackgroundTransparency=1 HF.ZIndex=13 HF.LayoutOrder=7 HF.Parent=tabPages["Key"]
LBL(HF,"🔥 Keys expire every 24 hours",11,DIM,false,Enum.TextXAlignment.Center).Size=UDim2.new(1,0,1,0)

local busy2=false
VBtn.MouseButton1Click:Connect(function()
    if busy2 then return end
    local key=KBox.Text
    if key=="" then setKS("⚠  Please enter a key first.",ERR) TW(InpC,.07,{BackgroundColor3=Color3.fromRGB(60,10,18)}):Play() task.wait(.22) TW(InpC,.15,{BackgroundColor3=INP}):Play() return end
    busy2=true VBtn.Text="⏳  Checking..." VBtn.Active=false setKS("Contacting key server...",GRY)
    task.spawn(function()
        local ok,msg=checkKey(key)
        if ok then
            saveKey(key) keyValidated=true
            setKS("✔  Key accepted!",SUC) VBtn.Text="✅  Validated!" TW(VBtn,.22,{BackgroundColor3=SUC}):Play()
            KLW.Visible=true runBar(KLL,KLF,{{.18,"Verifying...",.30},{.48,"Connecting...",.36},{.72,"Fetching scripts...",.32},{.92,"Almost done...",.24},{1,"Done!",.14}},function()
                buildScriptsPage() gotoTab("Scripts") VBtn.Text="✅   Validate Key" VBtn.Active=true busy2=false
            end)
        else
            setKS("✖  "..msg,ERR) VBtn.Text="✅   Validate Key" VBtn.Active=true TW(VBtn,.18,{BackgroundColor3=PRP}):Play()
            TW(InpC,.07,{BackgroundColor3=Color3.fromRGB(60,10,18)}):Play() task.wait(.22) TW(InpC,.15,{BackgroundColor3=INP}):Play() busy2=false
        end
    end)
end)

-- MISC PAGE
VLT(tabPages["Misc"],12,9)
local MH=Instance.new("Frame") MH.Size=UDim2.new(1,0,0,24) MH.BackgroundTransparency=1 MH.ZIndex=13 MH.LayoutOrder=1 MH.Parent=tabPages["Misc"]
LBL(MH,"⚙️  Misc",16,WHT,true).Size=UDim2.new(1,0,1,0)

local OC=Instance.new("Frame") OC.Size=UDim2.new(1,0,0,64) OC.BackgroundColor3=CARD OC.BorderSizePixel=0 OC.ZIndex=13 OC.LayoutOrder=2 OC.Parent=tabPages["Misc"] RND(OC,12) BRD(OC,BRDM,1) GRD(OC,Color3.fromRGB(36,16,78),Color3.fromRGB(14,9,30),0)
local Crown=Instance.new("TextLabel") Crown.Size=UDim2.new(0,48,1,0) Crown.BackgroundTransparency=1 Crown.Text="👑" Crown.TextSize=26 Crown.Font=Enum.Font.GothamBold Crown.TextColor3=WRN Crown.TextXAlignment=Enum.TextXAlignment.Center Crown.ZIndex=15 Crown.Parent=OC
local OL=Instance.new("TextLabel") OL.Size=UDim2.new(1,-58,0,20) OL.Position=UDim2.new(0,52,0,10) OL.BackgroundTransparency=1 OL.Text="Owner" OL.TextColor3=DIM OL.Font=Enum.Font.Gotham OL.TextSize=11 OL.TextXAlignment=Enum.TextXAlignment.Left OL.ZIndex=15 OL.Parent=OC
local ON=Instance.new("TextLabel") ON.Size=UDim2.new(1,-58,0,24) ON.Position=UDim2.new(0,52,0,30) ON.BackgroundTransparency=1 ON.Text=CONFIG.Owner ON.TextColor3=WHT ON.Font=Enum.Font.GothamBold ON.TextSize=18 ON.TextXAlignment=Enum.TextXAlignment.Left ON.ZIndex=15 ON.Parent=OC
local OB=Instance.new("TextLabel") OB.Size=UDim2.new(0,68,0,22) OB.Position=UDim2.new(1,-76,0.5,-11) OB.BackgroundColor3=Color3.fromRGB(60,30,120) OB.Text="Developer" OB.TextColor3=PRPL OB.Font=Enum.Font.GothamBold OB.TextSize=10 OB.ZIndex=16 OB.Parent=OC RND(OB,6) BRD(OB,BRDM,1)

local VC=Instance.new("Frame") VC.Size=UDim2.new(1,0,0,38) VC.BackgroundColor3=CARD VC.BorderSizePixel=0 VC.ZIndex=13 VC.LayoutOrder=3 VC.Parent=tabPages["Misc"] RND(VC,10) BRD(VC,BRDM,1)
local VL=Instance.new("TextLabel") VL.Size=UDim2.new(1,0,1,0) VL.BackgroundTransparency=1 VL.Text="🔥  Blaze Hub  v3.5" VL.TextColor3=GRY VL.Font=Enum.Font.Gotham VL.TextSize=12 VL.TextXAlignment=Enum.TextXAlignment.Center VL.ZIndex=15 VL.Parent=VC

-- AUTO LOGIN
task.spawn(function()
    task.wait(.7)
    local sk,sv=readKey()
    if sv and sk then
        setKS("🔄  Found saved key, verifying...",GRY)
        local ok=checkKey(sk)
        if ok then
            KBox.Text=sk keyValidated=true
            setKS("✔  Auto-login!",SUC) VBtn.Text="✅  Auto Login..." TW(VBtn,.22,{BackgroundColor3=SUC}):Play()
            KLW.Visible=true runBar(KLL,KLF,{{.20,"Verifying...",.26},{.55,"Connecting...",.30},{.85,"Loading...",.26},{1,"Done!",.14}},function()
                buildScriptsPage() gotoTab("Scripts") VBtn.Text="✅   Validate Key" VBtn.Active=true busy2=false
            end)
        else setKS("⚠  Saved key expired. Get a new one.",WRN) end
    end
end)

-- RUNTIME
local pt=0
RunService.RenderStepped:Connect(function(dt)
    if not SG.Parent then return end
    pt=pt+dt*1.9
    local a=(math.sin(pt)+1)/2
    WB.Color=Color3.fromRGB(math.floor(90+a*95),math.floor(20+a*22),math.floor(208+a*47))
    for i=#pts,1,-1 do
        local p=pts[i] p.age=p.age+1 p.pulse=p.pulse+dt*1.7
        local px=p.f.Position.X.Scale+p.vx local py=p.f.Position.Y.Scale+p.vy
        if px<-.02 then px=1.02 end if px>1.02 then px=-.02 end
        p.f.Position=UDim2.new(px,0,py,0) p.f.BackgroundTransparency=p.a+math.sin(p.pulse)*.13
        if py<-.05 or p.age>=p.life then p.f:Destroy() table.remove(pts,i) spawnPt() end
    end
end)

TW(Win,.48,{Size=UDim2.new(0,W,0,H),Position=UDim2.new(0.5,-W/2,0.5,-H/2)},Enum.EasingStyle.Back):Play()
