if GetObjectName(GetMyHero()) ~= "Xerath" then return end

local XerathMenu = MenuConfig("Xerath", "Xerath")
XerathMenu:Menu("Combo", "Combo")
XerathMenu.Combo:Boolean("Q", "Use Q", true)
XerathMenu.Combo:Boolean("W", "Use W", true)
XerathMenu.Combo:Boolean("E", "Use E", true)

XerathMenu:Menu("Harass", "Harass")
XerathMenu.Harass:Boolean("Q", "Use Q", true)
XerathMenu.Harass:Boolean("W", "Use W", true)
XerathMenu.Harass:Boolean("E", "Use E", true)
XerathMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

XerathMenu:Menu("Killsteal", "Killsteal")
XerathMenu.Killsteal:Boolean("W", "Killsteal with W", true)
XerathMenu.Killsteal:Boolean("E", "Killsteal with E", true)

XerathMenu:Menu("Misc", "Misc")
XerathMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true)
XerathMenu.Misc:Boolean("Autolvl", "Auto level", true)
XerathMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "Q-E-W"})
XerathMenu.Misc:Boolean("Interrupt", "Interrupt Spells (E)", true)
--XerathMenu.Misc:Boolean("AutoR", "Auto R Killable", true)
--XerathMenu.Misc:Key("AutoRKey", "R Killable(hold)", string.byte("T"))

XerathMenu:Menu("Drawings", "Drawings")
XerathMenu.Drawings:Boolean("Qmin", "Draw Q Min Range", true)
XerathMenu.Drawings:Boolean("Qmax", "Draw Q Max Range", true)
XerathMenu.Drawings:Boolean("W", "Draw W Range", true)
XerathMenu.Drawings:Boolean("E", "Draw E Range", true)
XerathMenu.Drawings:Boolean("R", "Draw R Range", true)

local InterruptMenu = MenuConfig("Interrupt (E)", "Interrupt")

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
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_E) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 650) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then
        Cast(_E,unit)
        end
      end
    end
end)

OnDraw(function(myHero)
local col = XerathMenu.Drawings.color:Value()
local pos = GetOrigin(myHero)
if XerathMenu.Drawings.Qmin:Value() then DrawCircle(pos,750,1,0,col) end
if XerathMenu.Drawings.Qmax:Value() then DrawCircle(pos,1500,1,0,col) end
if XerathMenu.Drawings.W:Value() then DrawCircle(pos,GetCastRange(myHero,_W),1,0,col) end
if XerathMenu.Drawings.E:Value() then DrawCircle(pos,975,1,0,col) end
if XerathMenu.Drawings.R:Value() then DrawCircle(pos,GetCastRange(myHero,_R),1,0,col) end
end)

local lastlevel = GetLevel(myHero)-1

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local mousePos = GetMousePos()
    
    if IOW:Mode() == "Combo" then

    local WPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),math.huge,700,GetCastRange(myHero,_W),125,false,true)
    local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,975,60,true,true)
	
    if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and XerathMenu.Combo.E:Value() and ValidTarget(target, 975) then
    CastSkillShot(_E,EPred.PredPos)
    end
	
	
    if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and XerathMenu.Combo.W:Value() and ValidTarget(target, GetCastRange(myHero,_W)) then
    CastSkillShot(_W,WPred.PredPos)
    end		

    if CanUseSpell(myHero, _Q) == READY and ValidTarget(target, 1500) and XerathMenu.Combo.Q:Value() then
      CastSkillShot(_Q, mousePos)
      for i=250, 1500, 250 do
        DelayAction(function()
              local Qrange = 750 + math.min(700, i/2)
              local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),math.huge,600,Qrange,100,false,true)
              if QPred.HitChance == 1 then
                CastSkillShot2(_Q, QPred.PredPos)
              end
          end, i)
      end	
    end        
    end

    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= XerathMenu.Harass.Mana:Value() then
    
	local WPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),math.huge,700,GetCastRange(myHero,_W),125,false,true)
	local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,975,60,true,true)
	
    if CanUseSpell(myHero, _Q) == READY and ValidTarget(target, 1500) and XerathMenu.Harass.Q:Value() then
      CastSkillShot(_Q, mousePos)
      for i=250, 1500, 250 do
        DelayAction(function()
              local Qrange = 700 + math.min(700, i/2)
              local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),math.huge,600,Qrange,100,false,true)
              if QPred.HitChance == 1 then
                CastSkillShot2(_Q, QPred.PredPos)
              end
          end, i)
      end
    end

    
    if CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and XerathMenu.Harass.E:Value() and ValidTarget(target, 975) then
    CastSkillShot(_E,EPred.PredPos)
    end
	
    if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and XerathMenu.Harass.W:Value() and ValidTarget(target, GetCastRange(myHero,_W)) then
    CastSkillShot(_W,WPred.PredPos)
    end	
	
    end

    for i,enemy in pairs(GetEnemyHeroes()) do
       local WPred = GetPredictionForPlayer(myHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,700,GetCastRange(myHero,_W),125,false,true)
       local EPred = GetPredictionForPlayer(myHeroPos(),enemy,GetMoveSpeed(enemy),1400,250,975,60,true,true)
	   
        if Ignite and XerathMenu.Misc.AutoIgnite:Value() then
          if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
                
       if CanUseSpell(myHero, _W) == READY and ValidTarget(enemy,GetCastRange(myHero,_W)) and XerathMenu.Killsteal.W:Value() and WPred.HitChance == 1 and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 30*GetCastLevel(myHero,_Q)+ 30 + 0.6*GetBonusAP(myHero)) then
       CastSkillShot(_W,WPred.PredPos)
       elseif CanUseSpell(myHero, _E) == READY and ValidTarget(enemy, 975) and XerathMenu.Killsteal.E:Value() and EPred.HitChance == 1 and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 30*GetCastLevel(myHero,_E)+ 50 + 0.45*GetBonusAP(myHero)) then  
       CastSkillShot(_E,EPred.PredPos)
       end
    end
    
if XerathMenu.Misc.Autolvl:Value() then
  if GetLevel(myHero) > lastlevel then
    if XerathMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif XerathMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)

--[[addInterrupterCallback(function(target, spellType)
  local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,975,60,true,true)
  if IsInDistance(target, 975) and CanUseSpell(myHero, _E) == READY and EPred.HitChance == 1 and XerathMenu.Misc.Interrupt:Value() and spellType == CHANELLING_SPELLS then
  CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
  end
end)]]

AddGapcloseEvent(_E, 975, false)
