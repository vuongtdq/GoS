if GetObjectName(GetMyHero()) ~= "Ryze" then return end
	
if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

local RyzeMenu = MenuConfig("Ryze", "Ryze")
RyzeMenu:Menu("Combo", "Combo")
RyzeMenu.Combo:Boolean("Q", "Use Q", true)
RyzeMenu.Combo:Boolean("W", "Use W", true)
RyzeMenu.Combo:Boolean("E", "Use E", true)
RyzeMenu.Combo:Boolean("R", "Use R", true)

RyzeMenu:Menu("Harass", "Harass")
RyzeMenu.Harass:Boolean("Q", "Use Q", true)
RyzeMenu.Harass:Boolean("W", "Use W", true)
RyzeMenu.Harass:Boolean("E", "Use E", true)
RyzeMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

RyzeMenu:Menu("Killsteal", "Killsteal")
RyzeMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
RyzeMenu.Killsteal:Boolean("W", "Killsteal with W", true)
RyzeMenu.Killsteal:Boolean("E", "Killsteal with E", true)

RyzeMenu:Menu("Misc", "Misc")
RyzeMenu.Misc:Boolean("Autoignite", "Auto Ignite", true)
RyzeMenu.Misc:Boolean("Autolvl", "Auto level", true)
RyzeMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E", "Q-E-W"})

RyzeMenu:Menu("LaneClear", "LaneClear")
RyzeMenu.LaneClear:Boolean("Q", "Use Q", true)
RyzeMenu.LaneClear:Boolean("W", "Use W", true)
RyzeMenu.LaneClear:Boolean("E", "Use E", true)
RyzeMenu.LaneClear:Boolean("R", "Use R", false)

RyzeMenu:Menu("JungleClear", "JungleClear")
RyzeMenu.JungleClear:Boolean("Q", "Use Q", true)
RyzeMenu.JungleClear:Boolean("W", "Use W", true)
RyzeMenu.JungleClear:Boolean("E", "Use E", true)
RyzeMenu.JungleClear:Boolean("R", "Use R", false)

RyzeMenu:Menu("Drawings", "Drawings")
RyzeMenu.Drawings:Boolean("Q", "Draw Q Range", true)
RyzeMenu.Drawings:Boolean("W", "Draw W Range", true)
RyzeMenu.Drawings:Boolean("E", "Draw E Range", true)
RyzeMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

OnDraw(function(myHero)
local col = RyzeMenu.Drawings.color:Value()
if RyzeMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),900,1,0,col) end
if RyzeMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),600,1,0,col) end
if RyzeMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),600,1,0,col) end
end)

local PStacks = 0
local IsEmpowered = false
local lastlevel = GetLevel(myHero)-1
	
OnTick(function(myHero)
  local target = GetCurrentTarget()
  
  if IOW:Mode() == "Combo" then
	    
	local Q2Pred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,900,55,false,true)

	if IsReady(_R) and ValidTarget(target, 700) and RyzeMenu.Combo.R:Value() and PStacks == 4 then
        CastSpell(_R)
	end  
	  
	if IsReady(_W) and ValidTarget(target, 600) and RyzeMenu.Combo.W:Value() then
        CastTargetSpell(target, _W)
	end
		
        if IsReady(_E) and ValidTarget(target, 600) and RyzeMenu.Combo.E:Value() then
        CastTargetSpell(target, _E)
	end
	
	if IsReady(_Q) and Q2Pred.HitChance == 1 and PStacks > 3 or IsEmpowered and RyzeMenu.Combo.Q:Value() and ValidTarget(target, 900) then
	CastSkillShot(_Q,Q2Pred.PredPos.x,Q2Pred.PredPos.y,Q2Pred.PredPos.z)
        elseif IsReady(_Q) and RyzeMenu.Combo.Q:Value() and ValidTarget(target, 900) then
        Cast(_Q,target)
	end				
		
  end

  if IOW:Mode() == "Harass" then

	local Q2Pred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,900,55,false,true)
	 	  
	if IsReady(_W) and ValidTarget(target, 600) and RyzeMenu.Harass.W:Value() then
        CastTargetSpell(target, _W)
	end
      
	if IsReady(_E) and ValidTarget(target, 600) and RyzeMenu.Harass.E:Value() then
        CastTargetSpell(target, _E)
	end
	
	if IsReady(_Q) and Q2Pred.Hitchance == 1 and RyzeMenu.Harass.Q:Value() and ValidTarget(target, 900) then
	CastSkillShot(_Q,Q2Pred.PredPos.x,Q2Pred.PredPos.y,Q2Pred.PredPos.z)
        elseif IsReady(_Q) and RyzeMenu.Harass.Q:Value() and ValidTarget(target, 900) then
	Cast(_Q,target)
	end
	
  end 

	for i,enemy in pairs(GetEnemyHeroes()) do
		
		if Ignite and RyzeMenu.Misc.Autoignite:Value() then
                  if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
                  CastTargetSpell(enemy, Ignite)
                  end
                end
		
		if IsReady(_Q) and ValidTarget(enemy, 900) and RyzeMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q",enemy) then 
		Cast(_Q,enemy)
		elseif IsReady(_W) and ValidTarget(enemy, 600) and RyzeMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("W",enemy) then
		CastTargetSpell(enemy, _W)
		elseif IsReady(_E) and ValidTarget(enemy, 600) and RyzeMenu.Killsteal.E:Value() and GetHP2(enemy) < getdmg("E",enemy) then
		CastTargetSpell(enemy, _E)
		end
		
	end
	
    if IOW:Mode() == "LaneClear" then

      for _,mobs in pairs(minionManager.objects) do
        if GetTeam(mob) == 300 then
		
		  if IsReady(_R) and RyzeMenu.JungleClear.R:Value() and PStacks == 4 and ValidTarget(mob, 900) then
		  CastSpell(_R)
		  end
		
		  if IsReady(_W) and RyzeMenu.JungleClear.W:Value() and ValidTarget(mob, 600) then
		  CastTargetSpell(mob, _W)
		  end
		
		  if IsReady(_Q) and RyzeMenu.JungleClear.Q:Value() and ValidTarget(mob, 900) then
		  CastSkillShot(_Q,GetOrigin(mob))
		  end
		
	          if IsReady(_E) and RyzeMenu.JungleClear.E:Value() and ValidTarget(mob, 600) then
		  CastTargetSpell(mob, _E)
		  end
		
        end
      end
      
    end

if RyzeMenu.Misc.Autolvl:Value() then
  if GetLevel(myHero) > lastlevel then
    if RyzeMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif RyzeMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    elseif RyzeMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)	

OnUpdateBuff(function(unit,buff)
  if unit == myHero then
    if buff.Name == "ryzepassivestack" then 
    PStacks = buff.Count
    end

    if buff.Name == "ryzepassivecharged" then 
    IsEmpowered = true
    end
  end
end)

OnUpdateBuff(function(unit,buff)
  if unit == myHero then
    if buff.Name == "ryzepassivestack" then 
    PStacks = 0
    end

    if buff.Name == "ryzepassivecharged" then 
    IsEmpowered = false
    end
  end
end)

AddGapcloseEvent(_W, 600, true)
