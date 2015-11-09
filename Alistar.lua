if GetObjectName(GetMyHero()) ~= "Alistar" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

local AlistarMenu = MenuConfig("Alistar", "Alistar")
AlistarMenu:Menu("Combo", "Combo")
AlistarMenu.Combo:Boolean("Q", "Use Q", true)
--AlistarMenu.Combo:Boolean("W", "Use W", true)
AlistarMenu.Combo:Boolean("WQ", "Use W+Q Combo", true)
 
AlistarMenu:Menu("Harass", "Harass")
AlistarMenu.Harass:Boolean("Q", "Use Q", true)
--AlistarMenu.Harass:Boolean("W", "Use W", true)
AlistarMenu.Harass:Boolean("E", "Use W+Q Combo", true)
AlistarMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

AlistarMenu:Menu("Killsteal", "Killsteal")
AlistarMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
AlistarMenu.Killsteal:Boolean("W", "Killsteal with W", true)
AlistarMenu.Killsteal:Boolean("WQ", "Killsteal with W+Q", true)

AlistarMenu:Menu("Misc", "Misc")
if Ignite ~= nil then AlistarMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
AlistarMenu.Misc:Boolean("Autolvl", "Auto level", true)
AlistarMenu.Misc:DropDown("Autolvltable", "Priority", 3, {"Q-W-E", "W-Q-E", "E-Q-W"})

AlistarMenu:Menu("Drawings", "Drawings")
AlistarMenu.Drawings:Boolean("Q", "Draw Q Range", true)
AlistarMenu.Drawings:Boolean("W", "Draw W Range", true)
AlistarMenu.Drawings:Boolean("E", "Draw E Range", true)
AlistarMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

local InterruptMenu = MenuConfig("Interrupt (Q/W)", "Interrupt")

DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        InterruptMenu:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 1)

OnProcessSpell(function(unit, spell)
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_W) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 650) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then 
        CastTargetSpell(unit, _W)
        end
      end
    end
end)
 
local lastlevel = GetLevel(myHero)-1
  
OnDraw(function(myHero)
local col = AlistarMenu.Drawings.color:Value()
local pos = GetOrigin(myHero)
if AlistarMenu.Drawings.Q:Value() then DrawCircle(pos,250,1,0,col) end
if AlistarMenu.Drawings.W:Value() then DrawCircle(pos,650,1,0,col) end
if AlistarMenu.Drawings.E:Value() then DrawCircle(pos,575,1,0,col) end
end)
