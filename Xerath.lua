if GetObjectName(GetMyHero()) ~= "Xerath" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

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
XerathMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

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

local QCharged = false
local minrange = 750
local chargedrange = 750
local chargedTime = GetTickCount()
local lastlevel = GetLevel(myHero)-1

OnCreateObj(function(Object)
	if GetObjectBaseName(Object) == "Xerath_Base_Q_cas_charge.troy" and GetDistance(Object) <= 50 then
		QCharged = true
	end
end)

OnDeleteObj(function(Object)
	if GetObjectBaseName(Object) == "Xerath_Base_Q_cas_charge.troy" and GetDistance(Object) <= 50 then
		QCharged = false
	end
end)

OnDraw(function(myHero)
local col = XerathMenu.Drawings.color:Value()
local pos = GetOrigin(myHero)
print(chargedTime)
if XerathMenu.Drawings.Qmin:Value() then DrawCircle(pos,chargedrange,1,0,col) end
if XerathMenu.Drawings.Qmax:Value() then DrawCircle(pos,1500,1,0,col) end
if XerathMenu.Drawings.W:Value() then DrawCircle(pos,GetCastRange(myHero,_W),1,0,col) end
if XerathMenu.Drawings.E:Value() then DrawCircle(pos,975,1,0,col) end
if XerathMenu.Drawings.R:Value() then DrawCircle(pos,GetCastRange(myHero,_R),1,0,col) end
end)

OnRemoveBuff(function(unit,buff)
  if unit == myHero then
  
    if buff.name == "XerathArcanopulseChargeUp"  then
    QCharged = false
	end
	if buff.name == "xerathqlaunchsound" then
	QCharged = false
	end
	
  end
end)

OnProcessSpell(function(unit,spell)
  if unit == myHero then
  
    if spell.name:lower():find("xeratharcanopulse2") and QCharged then
	QCharged = false
	end

	if spell.name == "XerathArcanopulseChargeUp" then
	QCharged = true
	chargedTime = GetTickCount()
	end
	
  end
end)

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local mousePos = GetMousePos()
	
	if not QCharged and chargedrange ~= minrange then
		chargedrange = minrange
	end
	
	if QCharged and chargedTime + ((1500 + 3000) + 1000) < GetTickCount() then
		QCharged = false
		chargedrange = minrange
	end
	
	if QCharged then
		chargedrange = math.floor((math.min(minrange + (1500 - minrange) * ((GetTickCount() - chargedTime) / 1500), 1500)))
	end
	
    if IOW:Mode() == "Combo" then
    
	local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),math.huge,600,chargedrange,100,false,true)
	
    if IsReady(_E) and XerathMenu.Combo.E:Value() and ValidTarget(target, 975) then
    Cast(_E,target)
    end
	
    if IsReady(_W) and XerathMenu.Combo.W:Value() and ValidTarget(target, GetCastRange(myHero,_W)) then
    Cast(_W,target)
    end		

    if IsReady(_Q) and ValidTarget(target, 1500) and XerathMenu.Combo.Q:Value() then
    CastSkillShot(_Q, mousePos)
	end
	
	if QCharged and QPred.HitChance == 1 and XerathMenu.Combo.Q:Value() then
	  DelayAction(function()
      CastSkillShot2(_Q, QPred.PredPos)
	  end, 1)
    end	        
	
    end

    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= XerathMenu.Harass.Mana:Value() then
	
    if IsReady(_Q) and ValidTarget(target, 1500) and XerathMenu.Harass.Q:Value() then
    CastSkillShot(_Q, mousePos)
	end
	
	if QCharged and QPred.HitChance == 1 and XerathMenu.Harass.Q:Value() then
	  DelayAction(function()
      CastSkillShot2(_Q, QPred.PredPos)
	  end, 1)
    end	 

    if IsReady(_E) and XerathMenu.Harass.E:Value() and ValidTarget(target, 975) then
    Cast(_E,target)
    end
	
    if IsReady(_W) and XerathMenu.Harass.W:Value() and ValidTarget(target, GetCastRange(myHero,_W)) then
    Cast(_W,target)
    end	
	
    end

    for i,enemy in pairs(GetEnemyHeroes()) do

        if Ignite and XerathMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
                
       if IsReady(_W) and ValidTarget(enemy,GetCastRange(myHero,_W)) and XerathMenu.Killsteal.W:Value() and WPred.HitChance == 1 and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 30*GetCastLevel(myHero,_Q)+ 30 + 0.6*GetBonusAP(myHero)) then
       Cast(_W,target)
       elseif IsReady(_E) and ValidTarget(enemy, 975) and XerathMenu.Killsteal.E:Value() and EPred.HitChance == 1 and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 30*GetCastLevel(myHero,_E)+ 50 + 0.45*GetBonusAP(myHero)) then  
       Cast(_E,target)
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

AddGapcloseEvent(_E, 666, false)
