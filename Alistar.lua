if GetObjectName(GetMyHero()) ~= "Alistar" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing DeftLib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

AutoUpdate("/D3ftsu/GoS/master/Alistar.lua","/D3ftsu/GoS/master/Alistar.version","Alistar.lua",1)

local AlistarMenu = MenuConfig("Alistar", "Alistar")
AlistarMenu:Menu("Combo", "Combo")
AlistarMenu.Combo:Boolean("Q", "Use Q", true)
AlistarMenu.Combo:Boolean("WQ", "Use W+Q Combo", true)
 
AlistarMenu:Menu("Harass", "Harass")
AlistarMenu.Harass:Boolean("Q", "Use Q", true)
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
AlistarMenu.Misc:Boolean("Eme", "Self-Heal", true)
AlistarMenu.Misc:Slider("mpEme", "Minimum Mana %", 25, 0, 100, 0)
AlistarMenu.Misc:Slider("hpEme", "Minimum HP%", 70, 0, 100, 0)
AlistarMenu.Misc:Boolean("Eally", "Heal Allies", true)
AlistarMenu.Misc:Slider("mpEally", "Minimum Mana %", 50, 0, 100, 0)
AlistarMenu.Misc:Slider("hpEally", "Minimum HP %", 35, 0, 100, 0)

AlistarMenu:Menu("Drawings", "Drawings")
AlistarMenu.Drawings:Boolean("Q", "Draw Q Range", true)
AlistarMenu.Drawings:Boolean("W", "Draw W Range", true)
AlistarMenu.Drawings:Boolean("E", "Draw E Range", true)
AlistarMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

AlistarMenu:Menu("Interrupt", "Interrupt")
AlistarMenu.Interrupt:Menu("SupportedSpells", "Supported Spells")
AlistarMenu.Interrupt.SupportedSpells:Boolean("Q", "Use Q", true)
AlistarMenu.Interrupt.SupportedSpells:Boolean("W", "Use W", true)

DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        AlistarMenu.Interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
        end
    end
  end
end, 1)

OnProcessSpell(function(unit, spell)
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 650) and IsReady(_W) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() and InterruptMenu.SupportedSpells.W:Value() then
        CastTargetSpell(unit, _W)
        elseif ValidTarget(unit, 365) and IsReady(_Q) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() and InterruptMenu.SupportedSpells.Q:Value() then
        CastSpell(_Q)
        end
      end
    end
end)
  
OnDraw(function(myHero)
local col = AlistarMenu.Drawings.color:Value()
local pos = GetOrigin(myHero)
if AlistarMenu.Drawings.Q:Value() then DrawCircle(pos,365,1,0,col) end
if AlistarMenu.Drawings.W:Value() then DrawCircle(pos,650,1,0,col) end
if AlistarMenu.Drawings.E:Value() then DrawCircle(pos,575,1,0,col) end
end)

local target1 = TargetSelector(650,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local lastlevel = GetLevel(myHero)-1

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local Wtarget = target1:GetTarget()
	
    if IOW:Mode() == "Combo" then

	if IsReady(_Q) and AlistarMenu.Combo.Q:Value() and ValidTarget(target,365) then
        CastSpell(_Q)
        end
		
        if IsReady(_W) and IsReady(_Q) and AlistarMenu.Combo.WQ:Value() and ValidTarget(Wtarget,650) and GetCurrentMana(myHero) >= GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_W,GetCastLevel(myHero,_W)) then
        CastTargetSpell(Wtarget, _W)
	DelayAction(function() CastSpell(_Q) end, math.max(0 , GetDistance(Wtarget) - 500 ) * 0.4 + 25)
        end

    end
    
    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= AlistarMenu.Harass.Mana:Value() then

	if IsReady(_Q) and AlistarMenu.Harass.Q:Value() and ValidTarget(target,365) then
        CastSpell(_Q)
        end
		
        if IsReady(_W) and IsReady(_Q) and AlistarMenu.Harass.WQ:Value() and ValidTarget(Wtarget,650) and GetCurrentMana(myHero) >= GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_W,GetCastLevel(myHero,_W)) then
        CastTargetSpell(Wtarget, _W)
	DelayAction(function() CastSpell(_Q) end, math.max(0 , GetDistance(Wtarget) - 500 ) * 0.4 + 25)
        end

    end
    
    if not IsRecalling(myHero) and AlistarMenu.Misc.Eme:Value() and AlistarMenu.Misc.mpEme:Value() <= GetPercentMP(myHero) and GetMaxHP(myHero)-GetCurrentHP(myHero) > 30+30*GetCastLevel(myHero,_E)+0.2*GetBonusAP(myHero) and GetPercentHP(myHero) <= AlistarMenu.Misc.hpEme:Value() then
    CastSpell(_E)
    end
	
    if not IsRecalling(myHero) and AlistarMenu.Misc.Eally:Value() and AlistarMenu.Misc.mpEally:Value() <= GetPercentMP(myHero) then
      for k,v in pairs(GetAllyHeroes()) do
        if ValidTarget(v,575) and GetMaxHP(v)- GetHP(v) < 15+15*GetCastLevel(myHero,_E)+0.1*GetBonusAP(myHero) and GetPercentHP(v) <= AlistarMenu.Misc.hpEally:Value() then
        CastSpell(_E)
        end
      end
    end
    
    for i,enemy in pairs(GetEnemyHeroes()) do
		
      if Ignite and AlistarMenu.Misc.Autoignite:Value() then
        if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
        CastTargetSpell(enemy, Ignite)
        end
      end
		
      if IsReady(_Q) and ValidTarget(enemy, 365) and AlistarMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q",enemy) then 
      CastSpell(_Q)
      elseif IsReady(_W) and ValidTarget(enemy, 650) and AlistarMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("W",enemy) then
      CastTargetSpell(enemy, _W)
      elseif IsReady(_W) and IsReady(_Q) and GetCurrentMana(myHero) >= GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_W,GetCastLevel(myHero,_W)) and ValidTarget(enemy, 650) and AlistarMenu.Killsteal.WQ:Value() and GetHP2(enemy) < getdmg("Q",enemy)+getdmg("W",enemy) then
      CastTargetSpell(enemy, _W)
      DelayAction(function() CastSpell(_Q) end, math.max(0 , GetDistance(enemy) - 500 ) * 0.4 + 25)
      end
		
    end
  
if AlistarMenu.Misc.Autolvl:Value() then  
  if GetLevel(myHero) > lastlevel then
    if AlistarMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _E, _W, _Q, _Q , _R, _Q , _W, _Q , _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif AlistarMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _E, _W, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    elseif AlistarMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end
	
end)

AddGapcloseEvent(_Q, 365, false, AlistarMenu)
AddGapcloseEvent(_W, 650, true, AlistarMenu)
