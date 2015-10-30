if GetObjectName(GetMyHero()) ~= "Ekko" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

local EkkoMenu = MenuConfig("Ekko", "Ekko")
EkkoMenu:Menu("Combo", "Combo")
EkkoMenu.Combo:Boolean("Q", "Use Q", true)
EkkoMenu.Combo:Boolean("W", "Use W", true)
EkkoMenu.Combo:Boolean("E", "Use E", true)
EkkoMenu.Combo:Boolean("R", "Use R", true)

EkkoMenu:Menu("Harass", "Harass")
EkkoMenu.Harass:Boolean("Q", "Use Q", true)
EkkoMenu.Harass:Boolean("W", "Use W", true)
EkkoMenu.Harass:Boolean("E", "Use E", true)
EkkoMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

EkkoMenu:Menu("Killsteal", "Killsteal")
EkkoMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
EkkoMenu.Killsteal:Boolean("R", "Killsteal with R", true)

EkkoMenu:Menu("Misc", "Misc")
if Ignite ~= nil then EkkoMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
EkkoMenu.Misc:Boolean("Autolvl", "Auto level", true)
EkkoMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-E-W", "Q-W-E", "E-Q-W"})

EkkoMenu:Menu("Drawings", "Drawings")
EkkoMenu.Drawings:Boolean("Q", "Draw Q Range", true)
EkkoMenu.Drawings:Boolean("W", "Draw W Range", true)
EkkoMenu.Drawings:Boolean("E", "Draw E Range", true)
EkkoMenu.Drawings:Boolean("R", "Draw R Radius", true)
EkkoMenu.Drawings:Boolean("OP", "OP Drawings", true)
EkkoMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

local twin,EkkoQ,QDuration,EkkoW,WDuration = nil,nil,nil,nil,nil
 
OnDraw(function(myHero)
local col = EkkoMenu.Drawings.color:Value()
if EkkoMenu.Drawings.Q:Value() then DrawCircle(GetOrigin(myHero),925,1,0,col) end
if EkkoMenu.Drawings.W:Value() then DrawCircle(GetOrigin(myHero),1600,1,0,col) end
if EkkoMenu.Drawings.E:Value() then DrawCircle(GetOrigin(myHero),350,1,0,col) end
if EkkoMenu.Drawings.R:Value() and twin then DrawCircle(GetOrigin(twin),400,1,0,col) end
if EkkoMenu.Drawings.OP:Value() then
  if EkkoQ then
  DrawCircle(GetOrigin(EkkoQ),140,1,100,ARGB(255, 255, 0, 0))
  DrawLine3D(GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z, GetOrigin(EkkoQ).x,GetOrigin(EkkoQ).y,GetOrigin(EkkoQ).z, 2, ARGB(255, 255, 0, 0))
  local pos = WorldToScreen(0,GetOrigin(EkkoQ))
  DrawText((math.floor((QDuration-GetTickCount()))/1000).."s", 25, pos.x-35, pos.y-50, ARGB(255, 255, 0, 0)) 
  end
  if EkkoW then
  DrawCircle(GetOrigin(EkkoW),400,2,100,ARGB(255, 155, 150, 250))
  local pos = WorldToScreen(0,GetOrigin(EkkoW))
  DrawText((math.floor((WDuration-GetTickCount()))/1000).."s", 25, pos.x-35, pos.y-50, ARGB(255, 255, 0, 0)) 
  end
end
end)

function DrawLine3D(x,y,z,a,b,c,width,col)
	local p1 = WorldToScreen(0, Vector(x,y,z))
	local p2 = WorldToScreen(0, Vector(a,b,c))
	DrawLine(p1.x, p1.y, p2.x, p2.y, width, col)
end

OnTick(function(myHero)
end)

OnCreateObj(function(Object) 

if GetObjectBaseName(Object) == "Ekko" then
twin = Object
end

if GetObjectBaseName(Object) == "Ekko_Base_Q_Aoe_Dilation.troy" then
EkkoQ = Object
QDuration = GetTickCount()+1600
end
 
if GetObjectBaseName(Object) == "Ekko_Base_W_Indicator.troy" then
EkkoW = Object 
WDuration = GetTickCount()+3000
end

end)

OnDeleteObj(function(Object) 
if GetObjectBaseName(Object) == "Ekko" then
twin = nil
end

if GetObjectBaseName(Object) == "Ekko_Base_Q_Aoe_Dilation.troy" then
EkkoQ = nil
end

if GetObjectBaseName(Object) == "Ekko_Base_W_Cas.troy" then
EkkoW = nil
end  

end)
