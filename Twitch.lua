if GetObjectName(GetMyHero()) ~= "Twitch" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end

AutoUpdate("/D3ftsu/GoS/master/Twitch.lua","/D3ftsu/GoS/master/Twitch.version","Twitch.lua",1)

local TwitchMenu = MenuConfig("Twitch", "Twitch")
TwitchMenu:Menu("Combo", "Combo")
TwitchMenu.Combo:Boolean("Q", "Use Q", true)
TwitchMenu.Combo:Slider("QEnemies", "Use Q if x enemies", 3, 0, 5, 1)
TwitchMenu.Combo:Boolean("Qlow", "Use Q if LowHP", true)
TwitchMenu.Combo:Slider("Qlowhp", "Use Q if My Health % <", 30, 0, 100, 1)
TwitchMenu.Combo:Boolean("W", "Use W", true)
TwitchMenu.Combo:Boolean("E", "Use E", true)
TwitchMenu.Combo:Slider("EStacks", "Use E if x stacks", 6, 0, 6, 0)
TwitchMenu.Combo:Boolean("Erange", "Use E if target is out of range", false)
TwitchMenu.Combo:Boolean("R", "Use R", true)
TwitchMenu.Combo:Slider("REnemies", "Use R if x enemies", 3, 0, 5, 1)
TwitchMenu.Combo:Boolean("Items", "Use Items", true)
TwitchMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
TwitchMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
TwitchMenu.Combo:Boolean("QSS", "Use QSS", true)
TwitchMenu.Combo:Slider("QSSHP", "if My Health % <", 75, 0, 100, 1)

TwitchMenu:Menu("Harass", "Harass")
TwitchMenu.Harass:Boolean("W", "Use W", true)
TwitchMenu.Harass:Boolean("E", "Use E", true)
TwitchMenu.Harass:Slider("EStacks", "Use E if x stacks", 6, 0, 6, 0)
TwitchMenu.Harass:Boolean("Erange", "Use E if target is out of range", false)

TwitchMenu:Menu("Killsteal", "Killsteal")
TwitchMenu.Killsteal:Boolean("E", "Killsteal with E", true)

TwitchMenu:Menu("Misc", "Misc")
if Ignite ~= nil then TwitchMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
TwitchMenu.Misc:Boolean("Autolvl", "Auto level", true)
TwitchMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"E-Q-W", "Q-E-W"})

TwitchMenu:Menu("Drawings", "Drawings")
TwitchMenu.Drawings:Boolean("W", "Draw W Range", true)
TwitchMenu.Drawings:Boolean("E", "Draw E Range", true)
TwitchMenu.Drawings:Boolean("R", "Draw R Range", true)
TwitchMenu.Drawings:Boolean("Stacks", "Draw E Stacks", true)
TwitchMenu.Drawings:Boolean("Vis", "Draw Visibility", true)

local IsInvisible = false

OnDraw(function(myHero)
local pos = GetOrigin(myHero)
if TwitchMenu.Drawings.W:Value() then DrawCircle(pos,950,1,0,GoS.Pink) end
if TwitchMenu.Drawings.E:Value() then DrawCircle(pos,1200,1,0,GoS.Yellow) end
if TwitchMenu.Drawings.R:Value() then DrawCircle(pos,850,1,0,GoS.Green) end
if TwitchMenu.Drawings.Vis:Value() then
local drawPos = WorldToScreen(1,myHero)
  if not IsInvisible then
  DrawText("STEALTH", drawPos.x, drawPos.y, 25, ARGB(255, 0, 255, 0))
  else
  DrawText("VISIBLE", drawPos.x, drawPos.y, 25, ARGB(255, 255, 0, 0))
  end
end
end)

local target1 = TargetSelector(1075,TARGET_LESS_CAST_PRIORITY,DAMAGE_PHYSICAL,true,false)

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local QSS = GetItemSlot(myHero,3140) > 0 and GetItemSlot(myHero,3140) or GetItemSlot(myHero,3139) > 0 and GetItemSlot(myHero,3139) or nil
    local BRK = GetItemSlot(myHero,3153) > 0 and GetItemSlot(myHero,3153) or GetItemSlot(myHero,3144) > 0 and GetItemSlot(myHero,3144) or nil
    local YMG = GetItemSlot(myHero,3142) > 0 and GetItemSlot(myHero,3142) or nil
    local Wtarget = target1:GetTarget()
    
    if IOW:Mode() == "Combo" then

      if IsReady(_Q) and TwitchMenu.Combo.Q:Value() and EnemiesAround(GetOrigin(myHero), 1000) >= TwitchMenu.Combo.QEnemies:Value() then
      CastSpell(_Q)
      end
			
	    if IsReady(_E) and ValidTarget(target,1200) and TwitchMenu.Combo.E:Value() then
	      if Estacks(target) == TwitchMenu.Combo.EStacks:Value() then
	      CastSpell(_E)
	      elseif TwitchMenu.Combo.Erange:Value() and GetDistance(target) >= 1100 then
	      CastSpell(_E)
	      end
	   end
		
	   if IsReady(_W) and TwitchMenu.Combo.W:Value() then
     Cast(_W,Wtarget)
     end
     
     if QSS and IsReady(QSS) and TwitchMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and GetPercentHP(myHero) < TwitchMenu.Combo.QSSHP:Value() then
     CastSpell(QSS)
     end
					
   end
	
   for i,enemy in pairs(GetEnemyHeroes()) do
   
     if IOW:Mode() == "Combo" then	
	     if BRK and IsReady(BRK) and TwitchMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and GetPercentHP(myHero) < TwitchMenu.Combo.myHP:Value() and GetPercentHP(enemy) > TwitchMenu.Combo.targetHP:Value() then
       CastTargetSpell(enemy, BRK)
       end

       if YMG and IsReady(YMG) and TwitchMenu.Combo.Items:Value() and ValidTarget(enemy, 600) then
       CastSpell(YMG)
       end	
     end
      
     if Ignite and TwitchMenu.Misc.Autoignite:Value() then
       if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
       CastTargetSpell(enemy, Ignite)
       end
     end
                
	   if IsReady(_W) and TwitchMenu.Killsteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then
	   Cast(_W,enemy)
	   elseif IsReady(_E) and TwitchMenu.Killsteal.E:Value() and GetHP(enemy) < Edmg(enemy) then
	   CastSpell(_E)
     end

   end

end)

local Estack = {}

OnUpdateBuff(function(unit,buff)
  if GetTeam(unit) ~= GetTeam(myHero) and buff.Name == "twitchdeadlyvenom" then
  Estack[GetNetworkID(unit)] = buff.Count
  end
end)

OnRemoveBuff(function(unit,buff)
  if GetTeam(unit) ~= GetTeam(myHero) and buff.Name == "twitchdeadlyvenom" then
  Estack[GetNetworkID(unit)] = 0
  end
end)

function Estacks(unit)
   return (Estack[GetNetworkID(unit)] or 0)
end

function Edmg(unit)
  return CalcDamage(myHero,unit,(15*GetCastLevel(myHero,_E)+5+(5*GetCastLevel(myHero,_E)+10+(0.2*GetBonusAP(myHero)+0.25*GetBonusDmg(myHero)))*Estacks(unit)))
end
