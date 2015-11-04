if GetObjectName(myHero) ~= "Thresh" then return end

local ThreshMenu = MenuConfig("Thresh", "Thresh")
ThreshMenu:Menu("Combo", "Combo")
ThreshMenu.Combo:Boolean("Q", "Use Q", true)
ThreshMenu.Combo:Boolean("Q2", "Jump to Target", true)
ThreshMenu.Combo:Boolean("E", "Use E", true)
ThreshMenu.Combo:Boolean("R", "Use R", true)

ThreshMenu:Menu("Harass", "Harass")
ThreshMenu.Harass:Boolean("Q", "Use Q", true)
ThreshMenu.Harass:Boolean("E", "Use E", true)

ThreshMenu:Menu("Misc", "Misc")
ThreshMenu.Misc:Boolean("Autoignite", "Auto Ignite", true)
ThreshMenu.Misc:Boolean("Autolvl", "Auto level", true)
ThreshMenu.Misc:Key("Lantern", "Throw Lantern", string.byte("G"))
ThreshMenu.Misc:Boolean("AutoR", "Auto R", true)
ThreshMenu.Misc:Slider("AutoRmin", "Minimum Enemies in Range", 3, 1, 5, 1)

ThreshMenu:Menu("Drawings", "Drawings")
ThreshMenu.Drawings:Boolean("Q", "Draw Q Range", true)
ThreshMenu.Drawings:Boolean("W", "Draw W Range", true)
ThreshMenu.Drawings:Boolean("E", "Draw E Range", true)
ThreshMenu.Drawings:Boolean("R", "Draw R Range", true)

OnDraw(function(myHero)
if ThreshMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),1100,1,0,0xff00ff00) end
if ThreshMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),950,1,0,0xff00ff00) end
if ThreshMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),400,1,0,0xff00ff00) end
if ThreshMenu.Drawings.R:Value() then DrawCircle(myHeroPos(),450,1,0,0xff00ff00) end
end)

OnTick(function(myHero)
    local target = GetCurrentTarget()
	
    if IOW:Mode() == "Combo" then

		local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),2000,125,400,200,false,true)
		local EPos = GetOrigin(myHero) + (GetOrigin(myHero) - EPred.PredPos)
				
                if GetCastName(myHero, _Q) ~= "threshqleap" and IsReady(_Q) and ValidTarget(target, 1100) and ThreshMenu.Combo.Q:Value() then
                Cast(_Q,target)
		elseif GetCastName(myHero, _Q) == "threshqleap" and ThreshMenu.Combo.Q2:Value() then
                CastSpell(_Q)
                end
			
		if IsReady(_E) and EPred.HitChance == 1 and ThreshMenu.Combo.E:Value() and ValidTarget(target, 400) and GetPercentHP(myHero) >= 26 then
		CastSkillShot(_E,EPos)
		elseif IsReady(_E) and EPred.HitChance == 1 and ThreshMenu.Combo.E:Value() and ValidTarget(target, 400) and GetPercentHP(myHero) < 26 then
                CastSkillShot(_E,EPred.PredPos)
		end				
           
		if IsReady(_R) and ValidTarget(target, 450) and ThreshMenu.Combo.R:Value() and GetPercentHP(target) < 50 then
		CastSpell(_R)
		end
		
    end
		
	if IOW:Mode() == "Harass" then

		local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),2000,125,400,200,false,true)
		local EPos = GetOrigin(myHero) + (GetOrigin(myHero) - EPred.PredPos)
				
                if GetCastName(myHero, _Q) ~= "threshqleap" and IsReady(_Q) and ValidTarget(target, 1100) and ThreshMenu.Harass.Q:Value() then
                Cast(_Q,target)
		end
			
		if IsReady(_E) and EPred.HitChance == 1 and ThreshMenu.Harass.E:Value() and ValidTarget(target, 400) then
		CastSkillShot(_E,EPos)
		end
	end
	
        if ThreshMenu.Misc.AutoR:Value() and IsReady(_R) and EnemiesAround(myHeroPos(), 450) >= ThreshMenu.Misc.AutoRmin:Value() then
	CastSpell(_R)
	end
	
	for i,enemy in pairs(GetEnemyHeroes()) do
	   
		if Ignite and ThreshMenu.Misc.Autoignite:Value() then
                  if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
                  CastTargetSpell(enemy, Ignite)
                  end
                end
	end
	
	if ThreshMenu.Misc.Lantern:Value() then
	  for _, ally in pairs(GetAllyHeroes()) do
            local WPred = GetPredictionForPlayer(myHeroPos(),ally,GetMoveSpeed(ally),3300,250,950,90,false,true)
            local AllyPos = GetOrigin(ally)
            local mousePos = GetMousePos()
            if IsReady(_W) and IsObjectAlive(ally) and GetDistance(myHero, ally) < 950 then
            CastSkillShot(_W,WPred.PredPos)
	    else
	    MoveToXYZ(mousePos)
	    end
         end
	end

if ThreshMenu.Misc.Autolvl:Value() then  
local leveltable = {_Q, _E, _W, _E, _E, _R, _Q, _Q, _Q, _E, _R, _Q, _E, _W, _W, _R, _W, _W}
LevelSpell(leveltable[GetLevel(myHero)]) 
end

end)

--[[addInterrupterCallback(function(target, spellType)
  local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1900,500,1100,70,true,true)
  local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),2000,125,400,200,false,true)
  if IsInDistance(target, 400) and IsReady(_E) and EPred.HitChance == 1 and ThreshMenu.Misc.Interrupt.E:Value() and spellType == CHANELLING_SPELLS then
  CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
  elseif IsInDistance(target, 1100) and IsReady(_Q) and QPred.HitChance == 1 and ThreshMenu.Misc.Interrupt.Q:Value() and spellType == CHANELLING_SPELLS then
  CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
  end
end)
]]

AddGapcloseEvent(_E, 400, false)
