if GetObjectName(GetMyHero()) ~= "Lucian" then return end

require('Inspired')
require('DeftLib')
require('DamageLib')

AutoUpdate("/D3ftsu/GoS/master/Lucian.lua","/D3ftsu/GoS/master/Lucian.version","Lucian.lua",3)

local LucianMenu = MenuConfig("Lucian", "Lucian")
LucianMenu:Menu("Combo", "Combo")
LucianMenu.Combo:Boolean("Q", "Use Q", true)
LucianMenu.Combo:Boolean("Q2", "Use Extended Q", true)
LucianMenu.Combo:Boolean("W", "Use W", true)
LucianMenu.Combo:Boolean("E", "Use E", true)
LucianMenu.Combo:Boolean("E2", "Use Assistive E", true)
LucianMenu.Combo:Boolean("Items", "Use Items", true)
LucianMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
LucianMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
LucianMenu.Combo:Boolean("QSS", "Use QSS", true)
LucianMenu.Combo:Slider("QSSHP", "if HP % <", 75, 0, 100, 1)

LucianMenu:Menu("Harass", "Harass")
LucianMenu.Harass:Boolean("Q", "Use Q", true)
LucianMenu.Harass:Boolean("W", "Use W", true)
LucianMenu.Harass:Slider("Mana", "if Mana % >", 50, 0, 80, 1)

LucianMenu:Menu("Killsteal", "Killsteal")
LucianMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
LucianMenu.Killsteal:Boolean("W", "Killsteal with W", true)

LucianMenu:Menu("Misc", "Misc")
if Ignite ~= nil then LucianMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
LucianMenu.Misc:Boolean("Autolvl", "Auto level", true)
LucianMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-E-W", "Q-W-E", "E-Q-W"})

--[[LucianMenu:Menu("JungleClear", "JungleClear")
LucianMenu.JungleClear:Boolean("Q", "Use Q", true)
LucianMenu.JungleClear:Boolean("W", "Use W", true)
LucianMenu.JungleClear:Boolean("E", "Use E", true)
LucianMenu.JungleClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)]]

LucianMenu:Menu("Drawings", "Drawings")
LucianMenu.Drawings:Boolean("Q", "Draw Q Range", true)
LucianMenu.Drawings:Boolean("Q2", "Draw Extended Q Range", true)
LucianMenu.Drawings:Boolean("W", "Draw W Range", true)
LucianMenu.Drawings:Boolean("R", "Draw R Range", true)

local CastingQ = false
local CastingW = false
local CastingE = false
local CastingR = false
local HasPassive = false
local lastlevel = GetLevel(myHero)-1

OnDraw(function(myHero)
local pos = GetOrigin(myHero)
if LucianMenu.Drawings.Q:Value() then DrawCircle(pos,550,1,25,GoS.Pink) end
if LucianMenu.Drawings.Q2:Value() then DrawCircle(pos,1100,1,25,GoS.Cyan) end
if LucianMenu.Drawings.W:Value() then DrawCircle(pos,1000,1,25,GoS.Yellow) end
if LucianMenu.Drawings.R:Value() then DrawCircle(pos,1400,1,25,GoS.Green) end
end)

IOW:AddCallback(AFTER_ATTACK, function(target, mode)
  if mode == "Combo" and target ~= nil then
    if IsReady(_Q) and LucianMenu.Combo.Q:Value() then
    CastQ(target)
    end
    
    if IsReady(_W) and LucianMenu.Combo.W:Value() then
    Cast(_W, target)
    end
 
    if IsReady(_E) and ValidTarget(target, 1000) and LucianMenu.Combo.E:Value() then
        local AfterDash = Vector(myHero) - (Vector(myHero) - Vector(mousePos)):normalized() * 425
	if LucianMenu.Combo.E2:Value() then
          local Range = (GetRange(myHero) + 65 + GetHitBox(myHero))
          if Range <= GetDistance(target) and Range > GetDistance(AfterDash, target) then 
            local Noddy = (Vector(myHero) - Vector(mousePos)):normalized()
            for i = 420, 10, -10 do
              local CastPos = Vector(myHero) - Noddy * i
              if Range < GetDistance(CastPos, target) then
              CastSkillShot(_E, CastPos)
              end
            end
          elseif GetDistance(target) <= 700 and GetDistance(target,AfterDash) < Range-65 then
          CastSkillShot(_E, AfterDash)
	  end
        elseif GetDistance(target) <= 700 and GetDistance(target,AfterDash) < Range-65 then
        CastSkillShot(_E, AfterDash)
        end
      end 
  end
  
  if mode == "Harass" and target ~= nil and GetPercentMP(myHero) >= LucianMenu.Harass.Mana:Value() then
    if IsReady(_Q) and LucianMenu.Harass.Q:Value() then
    CastQ(target)
    end
	  
    if IsReady(_W) and LucianMenu.Harass.W:Value() then
    Cast(_W, target)
    end
  end
  
end)

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local mousePos = GetMousePos()
    
    if IOW:Mode() == "Combo" and not IOW.isWindingUp then

      if IsReady(_Q) and LucianMenu.Combo.Q:Value() and not CastingW and not CastingE and not CastingR and not HasPassive then
      CastQ(target)
      end
	  
      if IsReady(_W) and LucianMenu.Combo.W:Value() and not CastingQ and not CastingE and not CastingR and not HasPassive then
      Cast(_W, target)
      end
	  
      if IsReady(_E) and ValidTarget(target, 1000) and LucianMenu.Combo.E:Value() and not CastingQ and not CastingW and not CastingR and not HasPassive then
        local AfterDash = Vector(myHero) - (Vector(myHero) - Vector(mousePos)):normalized() * 425
	if LucianMenu.Combo.E2:Value() then
          local Range = (GetRange(myHero) + 65 + GetHitBox(myHero))
          if Range <= GetDistance(target) and Range > GetDistance(AfterDash, target) then 
            local Noddy = (Vector(myHero) - Vector(mousePos)):normalized()
            for i = 420, 10, -10 do
              local CastPos = Vector(myHero) - Noddy * i
              if Range < GetDistance(CastPos, target) then
              CastSkillShot(_E, CastPos)
              end
            end
          elseif GetDistance(target) <= 700 and GetDistance(target,AfterDash) < Range-65 then
          CastSkillShot(_E, AfterDash)
	  end
        elseif GetDistance(target) <= 700 and GetDistance(target,AfterDash) < Range-65 then
        CastSkillShot(_E, AfterDash)
        end
      end
    end
	
    if IOW:Mode() == "Harass" and not IOW.isWindingUp and GetPercentMP(myHero) >= LucianMenu.Harass.Mana:Value() then

      if IsReady(_Q) and LucianMenu.Harass.Q:Value() and not CastingW and not CastingE and not CastingR and not HasPassive then
      CastQ(target)
      end
	  
      if IsReady(_W) and LucianMenu.Harass.W:Value() and not CastingQ and not CastingE and not CastingR and not HasPassive then
      Cast(_W, target)
      end
	
    end
  	
    for i,enemy in pairs(GetEnemyHeroes()) do
    	
        if Ignite and LucianMenu.Misc.Autoignite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
          
        if IsReady(_Q) and ValidTarget(enemy, 550) and LucianMenu.Killsteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then 
    	CastTargetSpell(enemy,_Q)      
	elseif IsReady(_W) and ValidTarget(enemy, 1000) and LucianMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("W",enemy) then
	Cast(_W,enemy)
        end

    end

if LucianMenu.Misc.Autolvl:Value() then  
  if GetLevel(myHero) > lastlevel then
    if LucianMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _E, _W, _Q, _Q , _R, _Q , _E, _Q , _E, _R, _E, _E, _W, _W, _R, _W, _W}
    elseif LucianMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif LucianMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)  
	  

OnProcessSpell(function(unit,spell)
  if unit == myHero then
  
    if spell.name == "LucianQ" then
    CastingQ = true
    HasPassive = true
    DelayAction(function() CastingQ = false end, spell.windUpTime*1000 + 0.28 + GetLatency() / 2)
    end
    
    if spell.name == "LucianW" then
    CastingW = true
    HasPassive = true
    DelayAction(function() CastingW = false end, spell.windUpTime*1000 + GetLatency() / 2)
    end
    
    if spell.name == "LucianE" then
    CastingE = true
    HasPassive = true
    DelayAction(function() CastingE = false end, spell.windUpTime*1000 + GetLatency() / 2)
    IOW:ResetAA()
    end
    
    if spell.name == "LucianR" then
    CastingR = true
    HasPassive = true
    DelayAction(function() CastingR = false end, 3000)
    end
    
  end
end)

OnRemoveBuff(function(unit, buff)
  if unit == myHero and buff.Name == "lucianpassivebuff" then
  HasPassive = false
  end
end)

OnDeleteObj(function(Object)
  if GetObjectBaseName(Object):lower():find("lucian_p_buf") and GetDistance(Object) < 100 then
  HasPassive = false
  end
end)

function CastQ(unit)
  if ValidTarget(unit, 1100) then
    if GetDistance(unit) <= 500 then
    CastTargetSpell(unit,_Q)
    elseif LucianMenu.Combo.Q2:Value() then
      local PredictedPos = GetPredictedPos(unit, (GetDistance(unit)/2000+0.32)*1000)
      for _,mob in pairs(minionManager.objects) do 
        local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), PredictedPos, GetOrigin(mob))
        if isOnSegment and GetDistance(mob) <= 500 and GetDistance(pointSegment, PredictedPos) <= 65 and not UnderTurret(GetOrigin(myHero), true) then
        CastTargetSpell(mob,_Q)
        end	  
      end
    end
  end
end

PrintChat(string.format("<font color='#1244EA'>Lucian:</font> <font color='#FFFFFF'> By Deftsu Loaded, Have A Good Game ! </font>"))
