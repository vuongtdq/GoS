if GetObjectName(GetMyHero()) ~= "ChoGath" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

local ChoGathMenu = MenuConfig("ChoGath", "ChoGath")
ChoGathMenu:Menu("Combo", "Combo")
ChoGathMenu.Combo:Boolean("Q", "Use Q", true)
ChoGathMenu.Combo:Boolean("W", "Use W", true)
ChoGathMenu.Combo:Boolean("R", "Use R", true)

ChoGathMenu:Menu("Harass", "Harass")
ChoGathMenu.Harass:Boolean("Q", "Use Q", true)
ChoGathMenu.Harass:Boolean("W", "Use W", true)
ChoGathMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

ChoGathMenu:Menu("Killsteal", "Killsteal")
ChoGathMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
ChoGathMenu.Killsteal:Boolean("W", "Killsteal with W", true)
ChoGathMenu.Killsteal:Boolean("R", "Killsteal with R", true)

ChoGathMenu:Menu("Misc", "Misc")
if Ignite ~= nil then ChoGathMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
ChoGathMenu.Misc:Boolean("Autolvl", "Auto level", true)
ChoGathMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E"})

ChoGathMenu:Menu("LaneClear", "LaneClear")
ChoGathMenu.LaneClear:Boolean("Q", "Use Q", true)
ChoGathMenu.LaneClear:Boolean("W", "Use W", false)
ChoGathMenu.LaneClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

ChoGathMenu:Menu("JungleClear", "JungleClear")
ChoGathMenu.JungleClear:Boolean("Q", "Use Q", true)
ChoGathMenu.JungleClear:Boolean("W", "Use W", true)
ChoGathMenu.JungleClear:Boolean("R", "Use R", true)
ChoGathMenu.JungleClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

ChoGathMenu:Menu("Drawings", "Drawings")
ChoGathMenu.Drawings:Boolean("Q", "Draw Q Range", true)
ChoGathMenu.Drawings:Boolean("W", "Draw W Range", true)
ChoGathMenu.Drawings:Boolean("R", "Draw R Range", true)
ChoGathMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

local InterruptMenu = MenuConfig("Interrupt", "Interrupt")
InterruptMenu:Menu("SupportedSpells", "Supported Spells")
InterruptMenu.SupportedSpells:Boolean("Q", "Use Q", true)
InterruptMenu.SupportedSpells:Boolean("W", "Use W", true)

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
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 950) and IsReady(_Q) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() and InterruptMenu.SupportedSpells.Q:Value() then
        Cast(_Q,unit)
        elseif ValidTarget(unit, 650) and IsReady(_W) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() and InterruptMenu.SupportedSpells.W:Value() then
        Cast(_W,unit)
        end
      end
    end
end)

local lastlevel = GetLevel(myHero)-1
  
OnDraw(function(myHero)
local col = ChoGathMenu.Drawings.color:Value()
local pos = GetOrigin(myHero)
if ChoGathMenu.Drawings.Q:Value() then DrawCircle(pos,950,1,0,col) end
if ChoGathMenu.Drawings.W:Value() then DrawCircle(pos,650,1,0,col) end
if ChoGathMenu.Drawings.R:Value() then DrawCircle(pos,235,1,0,col) end
end)

OnTick(function(myHero)
    local target = GetCurrentTarget()
    
    if IOW:Mode() == "Combo" then

        if IsReady(_Q) and ValidTarget(target,950) and ChoGathMenu.Combo.Q:Value() then
        Cast(_Q,target)
        end
	       
	      if IsReady(_W) and ValidTarget(target,650) and ChoGathMenu.Combo.W:Value() then
        Cast(_W,target)
        end
        
        if IsReady(_R) and ValidTarget(target,235) and ChoGathMenu.Combo.R:Value() and GetHP2(target) < getdmg("R", target) then
        CastTargetSpell(target, _R)
        end
        
    end
	
    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= ChoGathMenu.Harass.Mana:Value() then

        if IsReady(_Q) and ValidTarget(target,950) and ChoGathMenu.Harass.Q:Value() then
        Cast(_Q,target)
        end
	       
	      if IsReady(_W) and ValidTarget(target,650) and ChoGathMenu.Harass.W:Value() then
        Cast(_W,target)
        end
        
    end
	
  for i,enemy in pairs(GetEnemyHeroes()) do
    	
	      if Ignite and AhriMenu.Misc.Autoignite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
                
	if IsReady(_W) and ValidTarget(enemy, 700) and AhriMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("Q",enemy) then
	CastSpell(_W)
	elseif IsReady(_Q) and ValidTarget(enemy, 880) and AhriMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("W",enemy,myHero,3) then 
	Cast(_Q,enemy)
	elseif IsReady(_E) and ValidTarget(enemy, 975) and AhriMenu.Killsteal.E:Value() and GetHP2(enemy) < getdmg("E",enemy) then
	Cast(_E,enemy)
        end

    end
     
    if IOW:Mode() == "LaneClear" then
     	
        local closeminion = ClosestMinion(GetOrigin(myHero), MINION_ENEMY)
        if GetPercentMP(myHero) >= AhriMenu.LaneClear.Mana:Value() then
       	
         if IsReady(_Q) and AhriMenu.LaneClear.Q:Value() then
           local BestPos, BestHit = GetLineFarmPosition(880, 50)
           if BestPos and BestHit > 0 then 
           CastSkillShot(_Q, BestPos)
           end
	 end

         if IsReady(_W) and AhriMenu.LaneClear.W:Value() then
           if GetCurrentHP(closeminion) < getdmg("W",closeminion,myHero,3) and ValidTarget(closestminion, 700) then
           CastSpell(_W)
           end
         end

         if IsReady(_E) and AhriMenu.LaneClear.E:Value() then
           if GetCurrentHP(closeminion) < getdmg("E",closeminion) and ValidTarget(closestminion, 1000) then
           CastSkillShot(_E, GetOrigin(closeminion))
           end
         end
        
        end

    end
         
    for i,mobs in pairs(minionManager.objects) do
        if IOW:Mode() == "LaneClear" and GetTeam(mobs) == 300 and GetPercentMP(myHero) >= AhriMenu.JungleClear.Mana:Value() then
          if IsReady(_Q) and AhriMenu.JungleClear.Q:Value() and ValidTarget(mobs, 880) then
          CastSkillShot(_Q,GetOrigin(mobs))
	  end
		
	  if IsReady(_W) and AhriMenu.JungleClear.W:Value() and ValidTarget(mobs, 700) then
	  CastSpell(_W)
	  end
		
	  if IsReady(_E) and AhriMenu.JungleClear.E:Value() and ValidTarget(mobs, 1000) then
	  CastSkillShot(_E,GetOrigin(mobs))
          end
        end
     	
	if IOW:Mode() == "LastHit" and GetTeam(mobs) == MINION_ENEMY and GetPercentMP(myHero) >= AhriMenu.Lasthit.Mana:Value() then
	  if IsReady(_Q) and ValidTarget(mobs, 880) and AhriMenu.Lasthit.Q:Value() and GetCurrentHP(mobs) < getdmg("Q",mobs) then
          CastSkillShot(_Q, GetOrigin(mobs))
       	  end
        end
    end       
	
if AhriMenu.Misc.Autolvl:Value() then  
  if GetLevel(myHero) > lastlevel then
    if AhriMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q , _R, _Q , _W, _Q , _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif AhriMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)
 
AddGapcloseEvent(_Q, 200, false)
