if GetObjectName(GetMyHero()) ~= "Ryze" then return end
	
if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "DeftLib" ) then PrintChat("You are missing DeftLib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

AutoUpdate("/D3ftsu/GoS/master/Ryze.lua","/D3ftsu/GoS/master/Ryze.version","Ryze.lua",4)

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
if Ignite ~= nil then RyzeMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
RyzeMenu.Misc:Boolean("Seraph", "Use Seraph", true)
RyzeMenu.Misc:KeyBinding("Passive", "Auto Stack Passive (toggle)", string.byte("N"), true)
RyzeMenu.Misc:Slider("PStacks", "=> Max Stacks To Maintain", 2, 0, 4, 1)
RyzeMenu.Misc:Boolean("Autolvl", "Auto level", true)
RyzeMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E", "Q-E-W"})

RyzeMenu:Menu("Lasthit", "Lasthit")
RyzeMenu.Lasthit:Boolean("Q", "Use Q", true)

RyzeMenu:Menu("LaneClear", "LaneClear")
RyzeMenu.LaneClear:Boolean("Q", "Use Q", true)
RyzeMenu.LaneClear:Boolean("W", "Use W", true)
RyzeMenu.LaneClear:Boolean("E", "Use E", true)
RyzeMenu.LaneClear:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

RyzeMenu:Menu("JungleClear", "JungleClear")
RyzeMenu.JungleClear:Boolean("Q", "Use Q", true)
RyzeMenu.JungleClear:Boolean("W", "Use W", true)
RyzeMenu.JungleClear:Boolean("E", "Use E", true)

RyzeMenu:Menu("Drawings", "Drawings")
RyzeMenu.Drawings:Boolean("Q", "Draw Q Range", true)
RyzeMenu.Drawings:Boolean("WE", "Draw W+E Range", true)

OnDraw(function(myHero)
local pos = GetOrigin(myHero)
if RyzeMenu.Drawings.Q:Value() then DrawCircle(pos,900,1,25,GoS.Pink) end
if RyzeMenu.Drawings.WE:Value() then DrawCircle(pos,600,1,25,GoS.Yellow) end
end)

local PassiveEndTime = 0
local PStacks = 0
local IsEmpowered = false
local target1 = TargetSelector(900,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local target2 = TargetSelector(600,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)

local lastlevel = GetLevel(myHero)-1
	
OnTick(function(myHero)
  local slot = GetItemSlot(myHero,3040)
  local Qtarget = target1:GetTarget()
  local Wtarget = target2:GetTarget()
  
  if IOW:Mode() == "" and RyzeMenu.Misc.Passive:Value() and PStacks < RyzeMenu.Misc.PStacks:Value() then
    local timeRemaining = PassiveEndTime - GetGameTimer()
    if timeRemaining < 0.5 then
    CastSkillShot(_Q,GetMousePos())
    end
  end
  
  if IsReady(slot) and RyzeMenu.Misc.Seraph:Value() then
  local threshold = math.huge
    do
      local totalHP = 0
      local totalDamage = 0
      for _, enemy in pairs(GetEnemyHeroes()) do
        if ValidTarget(enemy,600) then
        totalHP = totalHP + GetHP(enemy)
        totalDamage = totalDamage + GetBonusAP(enemy) + (GetBaseDamage(enemy)+GetBonusDmg(enemy)) * GetAttackSpeed(enemy)
        end
      end
      threshold = totalHP / totalDamage
    end
    local shield = 150 + GetCurrentMana(myHero) * 0.2
    local HP = GetHP(myHero)
    local damage = GetBonusAP(myHero) * (1 + (GetBonusAP(myHero)/100)) + (GetBaseDamage(myHero)+GetBonusDmg(myHero)) * GetAttackSpeed(myHero)
    if threshold > HP / damage and (threshold < (HP + shield) / damage) then
    CastSpell(slot)
    end
  end
        
  if IOW:Mode() == "Combo" then
	
        local qcost, wcost, ecost = 40, GetCastLevel(myHero,_W) * 10 + 50, GetCastLevel(myHero,_E) * 10 + 50
        if RyzeMenu.Combo.R:Value() and ValidTarget(Wtarget, 600) and GetCurrentMana(myHero) > qcost + wcost + ecost then
          if GetHP(Wtarget) > getdmg("Q",Wtarget)+getdmg("W",Wtarget)+getdmg("E",Wtarget) then
          CastSpell(_R)
          else
            for _, enemy in pairs(GetEnemyHeroes()) do
              if GetNetworkID(enemy) ~= GetNetworkID(Wtarget) and ValidTarget(enemy,950) then
              CastSpell(_R)
              end
            end
          end
        end
	  
	if IsReady(_W) and ValidTarget(Wtarget, 600) and RyzeMenu.Combo.W:Value() then
        CastTargetSpell(Wtarget, _W)
	end
		
        if IsReady(_E) and ValidTarget(Wtarget, 600) and RyzeMenu.Combo.E:Value() then
        CastTargetSpell(Wtarget, _E)
	end
	
	if IsReady(_Q) and RyzeMenu.Combo.Q:Value() then
	Cast(_Q,Qtarget)
        end
        
        if IsReady(_Q) and RyzeMenu.Combo.Q:Value() and IsEmpowered or PStacks > 3  then
  	Cast(_Q,Qtarget,myHero,1700,0.25,900,55,3,false)
	end				
		
  end

  if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= RyzeMenu.Harass.Mana:Value() then

	if IsReady(_W) and ValidTarget(Wtarget, 600) and RyzeMenu.Harass.W:Value() then
        CastTargetSpell(Wtarget, _W)
	end
      
	if IsReady(_E) and ValidTarget(Wtarget, 600) and RyzeMenu.Harass.E:Value() then
        CastTargetSpell(Wtarget, _E)
	end

        if IsReady(_Q) and RyzeMenu.Harass.Q:Value() then
	Cast(_Q,Qtarget)
        end

        if IsReady(_Q) and RyzeMenu.Harass.Q:Value() and IsEmpowered or PStacks > 3  then
  	Cast(_Q,Qtarget,myHero,1700,0.25,900,55,3,false)
	end
	
  end 

	for i,enemy in pairs(GetEnemyHeroes()) do
		
		if Ignite and RyzeMenu.Misc.Autoignite:Value() then
                  if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
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
	
    if IOW:Mode() == "Lasthit" then
      local OPIEOP = ClosestMinion(GetOrigin(myHero), MINION_ENEMY)
      if IsReady(_Q) and RyzeMenu.Lasthit.Q:Value() and ValidTarget(OPIEOP, 900) and GetCurrentHP(OPIEOP)-GetDamagePrediction(OPIEOP, 250+GetDistance(OPIEOP)/1700) < getdmg("Q",OPIEOP) and GetCurrentHP(OPIEOP)-GetDamagePrediction(OPIEOP, 250+GetDistance(OPIEOP)/1700) > 0 then
      CastSkillShot(_Q,GetOrigin(mobs))
      end
    end
    
    if IOW:Mode() == "LaneClear" then

      for _,mobs in pairs(minionManager.objects) do
        if GetTeam(mobs) == 300 then
		
		  if IsReady(_W) and RyzeMenu.JungleClear.W:Value() and ValidTarget(mobs, 600) then
		  CastTargetSpell(mobs, _W)
		  end
		
		  if IsReady(_Q) and RyzeMenu.JungleClear.Q:Value() and ValidTarget(mobs, 900) then
		  CastSkillShot(_Q,GetOrigin(mobs))
		  end
		
	          if IsReady(_E) and RyzeMenu.JungleClear.E:Value() and ValidTarget(mobs, 600) then
		  CastTargetSpell(mobs, _E)
		  end
		
        end

        if GetTeam(mobs) == MINION_ENEMY and GetPercentMP(myHero) >= RyzeMenu.Harass.Mana:Value() then

		  if IsReady(_W) and RyzeMenu.LaneClear.W:Value() and ValidTarget(mobs, 600) then
		  CastTargetSpell(mobs, _W)
		  end
		
		  if IsReady(_Q) and RyzeMenu.LaneClear.Q:Value() and ValidTarget(mobs, 900) then
		  CastSkillShot(_Q,GetOrigin(mobs))
		  end
		
	          if IsReady(_E) and RyzeMenu.LaneClear.E:Value() and ValidTarget(mobs, 600) then
		  CastTargetSpell(mobs, _E)
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
    PassiveEndTime = buff.ExpireTime
    end

    if buff.Name == "ryzepassivecharged" then 
    IsEmpowered = true
    end
  end
end)

OnRemoveBuff(function(unit,buff)
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
