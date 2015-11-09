if GetObjectName(GetMyHero()) ~= "Nidalee" then return end

if not pcall( require, "MapPositionGOS" ) then PrintChat("You are missing Walls Library - Go download it and save it Common!") return end
if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end


local NidaleeMenu = MenuConfig("Nidalee", "Nidalee")
NidaleeMenu:Menu("Combo", "Combo")
NidaleeMenu.Combo:Boolean("Q", "Use Q", true)
NidaleeMenu.Combo:Boolean("W", "Use W", true)
NidaleeMenu.Combo:Boolean("E", "Use E", true)
NidaleeMenu.Combo:Boolean("R", "Use R", true)

NidaleeMenu:Menu("Harass", "Harass")
NidaleeMenu.Harass:Boolean("Q", "Use Q", true)
NidaleeMenu.Harass:Boolean("E", "Use E", true)
NidaleeMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

NidaleeMenu:Menu("Killsteal", "Killsteal")
NidaleeMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
NidaleeMenu.Killsteal:Boolean("W", "Killsteal with W", true)
NidaleeMenu.Killsteal:Boolean("E", "Killsteal with E", true)
NidaleeMenu.Killsteal:Boolean("R", "Killsteal with R", true)

NidaleeMenu:Menu("Misc", "Misc")
if Ignite ~= nil then NidaleeMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
NidaleeMenu.Misc:Boolean("Autolvl", "Auto level", true)
NidaleeMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-E-W", "Q-W-E", "E-Q-W"})
NidaleeMenu.Misc:Boolean("Eme", "Self-Heal", true)
NidaleeMenu.Misc:Slider("mpEme", "Minimum Mana %", 25, 0, 100, 0)
NidaleeMenu.Misc:Slider("hpEme", "Minimum HP%", 70, 0, 100, 0)
NidaleeMenu.Misc:Boolean("Eally", "Heal Allies", true)
NidaleeMenu.Misc:Slider("mpEally", "Minimum Mana %", 50, 0, 100, 0)
NidaleeMenu.Misc:Slider("hpEally", "Minimum HP %", 35, 0, 100, 0)
NidaleeMenu.Misc:KeyBinding("Flee", "Flee", string.byte("T"))
NidaleeMenu.Misc:KeyBinding("WallJump", "WallJump", string.byte("G"))

NidaleeMenu:Menu("Drawings", "Drawings")
NidaleeMenu.Drawings:Boolean("Q", "Draw Q Range", true)
NidaleeMenu.Drawings:Boolean("W", "Draw W Range", true)
NidaleeMenu.Drawings:Boolean("E", "Draw E Range", true)
NidaleeMenu.Drawings:Boolean("R", "Draw R Range", true)
NidaleeMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

OnDraw(function(myHero)
local col = NidaleeMenu.Drawings.color:Value()
local pos = GetOrigin(myHero)
  if IsHuman() then
    if NidaleeMenu.Drawings.Q:Value() then DrawCircle(pos,1450,2,100,col) end
    if NidaleeMenu.Drawings.W:Value() then DrawCircle(pos,900,2,100,col) end
    if NidaleeMenu.Drawings.E:Value() then DrawCircle(pos,650,2,100,col) end
  else
    if NidaleeMenu.Drawings.Q:Value() then DrawCircle(pos,GetRange(myHero)+GetHitBox(myHero),2,100,col) end
    if NidaleeMenu.Drawings.W:Value() then
    DrawCircle(mousePos,400,2,100,MapPosition:inWall(mousePos) and ARGB(255,255,0,0) or ARGB(255, 255, 255, 255))
    DrawCircle(mousePos,133,2,100,MapPosition:inWall(mousePos) and ARGB(255,255,0,0) or ARGB(255, 255, 255, 255))
    end
    if NidaleeMenu.Drawings.E:Value() then DrawCircle(pos,375,2,100,col) end
  end
end)

local QCD = 0
local lastlevel = GetLevel(myHero)-1
  
OnTick(function(myHero)
    local target = GetCurrentTarget()
    mousePos = GetMousePos()
	
    if IOW:Mode() == "Combo" then
	  
      if IsHuman() then
	    
	if IsReady(_Q) and IsHuman() and NidaleeMenu.Combo.Q:Value() and ValidTarget(target,1450) then
        Cast(_Q,target)
        end
		
        if IsReady(_R) and IsHunted(target) and ValidTarget(target,800) and NidaleeMenu.Combo.R:Value() then
        CastSpell(_R)
        end 
		
	if IsReady(_W) and not IsHunted(target) and NidaleeMenu.Combo.W:Value() and ValidTarget(target,900) then
        Cast(_W,target)
        end
		
      else
	  
        if IsReady(_W) and IsHunted(target) and ValidTarget(target,765) and NidaleeMenu.Combo.W:Value() then
        CastTargetSpell(target,_W)
	elseif IsReady(_W) and not IsHunted(target) and ValidTarget(target,765) and NidaleeMenu.Combo.W:Value() then
	CastSkillShot(_W,GetOrigin(target))
        end
	
        if ValidTarget(target,375) then
          if IsReady(_E) and NidaleeMenu.Combo.E:Value() then
          CastSkillShot(_E,GetOrigin(target))
          elseif IsReady(_Q) and NidaleeMenu.Combo.Q:Value() then
          CastSpell(_Q)
          end
        end

        if ValidTarget(target,1500) then
          if GetDistance(target) > 425 or QCD < GetTickCount() then
         CastSpell(_R)
         end
       end	

      end
	  
    end
	
    if IOW:Mode() == "Harass" then
	
      if IsHuman() and GetPercentHP(myHero) >= NidaleeMenu.Harass.Mana:Value() and NidaleeMenu.Harass.Q:Value() and ValidTarget(target,1450) then
      Cast(_Q,target)
      else
        if not IsHuman() and ValidTarget(target,375) then
          if IsReady(_E) and NidaleeMenu.Harass.E:Value() then
          CastSkillShot(_E,GetOrigin(target))
          elseif IsReady(_Q) and NidaleeMenu.Harass.Q:Value() then
          CastSpell(_Q)
          end
        end
      end
      
    end

    if NidaleeMenu.Misc.WallJump:Value() then
      if IsHuman() then CastSpell(_R) end
      local movePos1 = GetOrigin(myHero) + (Vector(mousePos) - GetOrigin(myHero)):normalized() * 150
      local movePos2 = GetOrigin(myHero) + (Vector(mousePos) - GetOrigin(myHero)):normalized() * 400
      if MapPosition:inWall(movePos1) and not MapPosition:inWall(movePos2) then
      CastSkillShot(_W, movePos2)
      else
      MoveToXYZ(mousePos)
      end
    end
    
    if NidaleeMenu.Misc.Flee:Value() then
      if IsHuman() then
      CastSpell(_R)
      else
      CastSkillShot(_W, mousePos)
      MoveToXYZ(mousePos)
      end
    end
	
    if not IsRecalling(myHero) and IsHuman() and NidaleeMenu.Misc.Eme:Value() and NidaleeMenu.Misc.mpEme:Value() <= GetPercentMP(myHero) and GetMaxHP(myHero)-GetCurrentHP(myHero) > 5+40*GetCastLevel(myHero,_E)+0.5*GetBonusAP(myHero) and GetPercentHP(myHero) <= NidaleeMenu.Misc.hpEme:Value() then
    CastSpell(_E)
    end
	
    if not IsRecalling(myHero) and IsHuman() and NidaleeMenu.Misc.Eally:Value() and NidaleeMenu.Misc.mpEally:Value() <= GetPercentMP(myHero) then
      for k,v in pairs(GetAllyHeroes()) do
        if ValidTarget(v,650) and GetMaxHP(v)- GetHP(v) < 5+40*GetCastLevel(myHero,_E)+0.5*GetBonusAP(myHero) and GetPercentHP(v) <= NidaleeMenu.Misc.hpEally:Value() then
        CastTargetSpell(v,_E)
        end
      end
    end
	
    for i,enemy in pairs(GetEnemyHeroes()) do
    	
        if Ignite and NidaleeMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
	  
        if IsReady(_Q) and ValidTarget(enemy, 1450) and NidaleeMenu.Killsteal.Q:Value() and IsHuman() and GetHP2(enemy) < getdmg("QM",enemy) then
        Cast(_Q, enemy)
        end
		
        if IsReady(_Q) and ValidTarget(enemy, 1450) and NidaleeMenu.Killsteal.Q:Value() and not IsHuman() and GetHP2(enemy) < getdmg("QM",enemy) then
        CastSpell(_R)
        DelayAction(function() Cast(_Q, enemy) end, 0.125)
        end
		
        if not IsHuman() and EnemiesAround(enemy, 500) < 3 then
          if IsReady(_Q) and ValidTarget(enemy, 375) and NidaleeMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q",enemy) then
          CastSpell(_Q)
          end
          if IsReady(_W) and ValidTarget(enemy,525) and NidaleeMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("W",enemy) and GetDistance(enemy) >= 175 then
          Cast(_W,GetOrigin(enemy))
          end
          if IsReady(_E) and ValidTarget(enemy,375) and NidaleeMenu.Killsteal.E:Value() and GetHP2(enemy) < getdmg("E",enemy) then
          Cast(_E,GetOrigin(enemy))
          end
        end
        
        if IsReady(_Q) and ValidTarget(enemy,450) and NidaleeMenu.Killsteal.Q:Value() and NidaleeMenu.Killsteal.W:Value() and NidaleeMenu.Killsteal.E:Value() and EnemiesAround(enemy, 500) < 3 and IsHuman() and GetHP2(enemy) < getdmg("QM",enemy)+getdmg("Q",enemy)+getdmg("W",enemy)+getdmg("E",enemy) then
          distancerino = GetDistance(enemy)
          Cast(_Q, enemy)
          DelayAction(function() 
          	
	  if IsReady(_R) and IsHunted(enemy) and IsHuman() and ValidTarget(enemy,800) then
          CastSpell(_R)
          end
	
          if IsReady(_W) and IsHunted(enemy) and not IsHuman() and ValidTarget(enemy,800) then
          Cast(_W,enemy)
          end
	
          if not IsHuman() and ValidTarget(enemy,375) then
            if IsReady(_E) then
            CastSkillShot(_E,GetOrigin(enemy))
            elseif IsReady(_Q) then
            CastSpell(_Q)
            end
          end
	
          if IsReady(_W) and ValidTarget(enemy,575) then
            if GetDistance(enemy) >= 225 then
            Cast(_W,enemy)
            end
          end
          
	  end, 300+distancerino/1300)
	  
        end
		
    end

if NidaleeMenu.Misc.Autolvl:Value() then  
  if GetLevel(myHero) > lastlevel then
    if NidaleeMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _E, _W, _Q, _Q , _R, _Q , _E, _Q , _E, _R, _E, _E, _W, _W, _R, _W, _W}
    elseif NidaleeMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif NidaleeMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end
	
end)

OnProcessSpell(function(unit, spell)
  if unit == myHero and spell.name == "JavelinToss" then 
  QCD = GetTickCount()+6000
  end
end)

local hunted = {}

OnUpdateBuff(function(unit,buff)
  if GetTeam(unit) ~= GetTeam(myHero) and buff.Name == "nidaleepassivehunted" then
  hunted[GetNetworkID(unit)] = buff.Count
  end
end)

OnRemoveBuff(function(unit,buff)
  if GetTeam(unit) ~= GetTeam(myHero) and buff.Name == "nidaleepassivehunted" then
  hunted[GetNetworkID(unit)] = 0
  end
end)

function IsHuman()
    return GetCastName(myHero,_Q) == "JavelinToss"
end

function IsHunted(unit)
   return (hunted[GetNetworkID(unit)] or 0) > 0
end
