if GetObjectName(GetMyHero()) ~= "Ahri" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

local AhriMenu = MenuConfig("Ahri", "Ahri")
AhriMenu:Menu("Combo", "Combo")
AhriMenu.Combo:Boolean("Q", "Use Q", true)
AhriMenu.Combo:Boolean("W", "Use W", true)
AhriMenu.Combo:Boolean("E", "Use E", true)
AhriMenu.Combo:Boolean("R", "Use R", true)
AhriMenu.Combo:DropDown("RMode", "R Mode", 1, {"Logic", "to mouse"})

AhriMenu:Menu("Harass", "Harass")
AhriMenu.Harass:Boolean("Q", "Use Q", true)
AhriMenu.Harass:Boolean("W", "Use W", true)
AhriMenu.Harass:Boolean("E", "Use E", true)
AhriMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

AhriMenu:Menu("Killsteal", "Killsteal")
AhriMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
AhriMenu.Killsteal:Boolean("W", "Killsteal with W", true)
AhriMenu.Killsteal:Boolean("E", "Killsteal with E", true)

AhriMenu:Menu("Misc", "Misc")
if Ignite ~= nil then AhriMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
AhriMenu.Misc:Boolean("Autolvl", "Auto level", true)
AhriMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-E-W", "Q-W-E", "E-Q-W"})

AhriMenu:Menu("Lasthit", "Lasthit")
AhriMenu.Lasthit:Boolean("Q", "Use Q", true)
AhriMenu.Lasthit:Slider("Mana", "if Mana % >", 50, 0, 80, 1)

AhriMenu:Menu("LaneClear", "LaneClear")
AhriMenu.LaneClear:Boolean("Q", "Use Q", true)
AhriMenu.LaneClear:Boolean("W", "Use W", false)
AhriMenu.LaneClear:Boolean("E", "Use E", false)
AhriMenu.LaneClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

AhriMenu:Menu("JungleClear", "JungleClear")
AhriMenu.JungleClear:Boolean("Q", "Use Q", true)
AhriMenu.JungleClear:Boolean("W", "Use W", true)
AhriMenu.JungleClear:Boolean("E", "Use E", true)
AhriMenu.JungleClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

AhriMenu:Menu("Drawings", "Drawings")
AhriMenu.Drawings:Boolean("Q", "Draw Q Range", true)
AhriMenu.Drawings:Boolean("W", "Draw W Range", true)
AhriMenu.Drawings:Boolean("E", "Draw E Range", true)
AhriMenu.Drawings:Boolean("R", "Draw R Range", true)
AhriMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

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
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then 
        Cast(_E,unit)
        end
      end
    end
end)

local target1 = TargetSelector(930,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local target2 = TargetSelector(1030,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local target3 = TargetSelector(900,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local UltOn = false
local lastlevel = GetLevel(myHero)-1
  
OnDraw(function(myHero)
local col = AhriMenu.Drawings.color:Value()
local pos = GetOrigin(myHero)
if AhriMenu.Drawings.Q:Value() then DrawCircle(pos,880,1,0,col) end
if AhriMenu.Drawings.W:Value() then DrawCircle(pos,700,1,0,col) end
if AhriMenu.Drawings.E:Value() then DrawCircle(pos,975,1,0,col) end
if AhriMenu.Drawings.R:Value() then DrawCircle(pos,550,1,0,col) end
end)

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local Qtarget = target1:GetTarget()
    local Etarget = target2:GetTarget()
    local Rtarget = target3:GetTarget()
    local mousePos = GetMousePos()
    
    if IOW:Mode() == "Combo" then

        if IsReady(_E) and ValidTarget(Etarget,975) and AhriMenu.Combo.E:Value() then
        Cast(_E,Etarget)
        end
	
        if AhriMenu.Combo.RMode:Value() == 1 and AhriMenu.Combo.R:Value() and ValidTarget(Rtarget,900) then
          local BestPos = Vector(Rtarget) - (Vector(Rtarget) - Vector(myHero)):perpendicular():normalized() * 350
	  if UltOn and BestPos then
          CastSkillShot(_R,BestPos)
          elseif IsReady(_R) and BestPos and getdmg("Q",Rtarget)+getdmg("W",Rtarget,myHero,3)+getdmg("E",Rtarget)+getdmg("R",Rtarget) > GetHP2(Rtarget) then
	  CastSkillShot(_R,BestPos)
	  end
	end

        if AhriMenu.Combo.RMode:Value() == 2 and AhriMenu.Combo.R:Value() and ValidTarget(Rtarget,900)then
          local AfterTumblePos = GetOrigin(myHero) + (Vector(mousePos) - GetOrigin(myHero)):normalized() * 550
          local DistanceAfterTumble = GetDistance(AfterTumblePos, Rtarget)
   	  if UltOn and DistanceAfterTumble < 550 then
	  CastSkillShot(_R,mousePos)
          elseif IsReady(_R) and getdmg("Q",Rtarget)+getdmg("W",Rtarget,myHero,3)+getdmg("E",Rtarget)+getdmg("R",Rtarget) > GetHP2(Rtarget) then
	  CastSkillShot(_R,mousePos) 
          end
	end
			
	if IsReady(_W) and ValidTarget(target,700) and AhriMenu.Combo.W:Value() then
	CastSpell(_W)
	end
		
	if IsReady(_Q) and ValidTarget(Qtarget, 880) and AhriMenu.Combo.Q:Value() then
        Cast(_Q,Qtarget)
        end
					
    end
	
    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= AhriMenu.Harass.Mana:Value() then

        if IsReady(_E) and ValidTarget(target, 975) and AhriMenu.Harass.E:Value() then
        Cast(_E,target)
        end
				
        if IsReady(_W) and ValidTarget(target, 700) and AhriMenu.Harass.W:Value() then
	CastSpell(_W)
	end
		
	if IsReady(_Q) and ValidTarget(target, 880) and AhriMenu.Harass.Q:Value() then
        Cast(_Q,target)
        end
		
    end
	
    for i,enemy in pairs(GetEnemyHeroes()) do
    	
	if Ignite and AhriMenu.Misc.Autoignite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
                
	if IsReady(_W) and ValidTarget(enemy, 700) and AhriMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("W",enemy,myHero,3) then
	CastSpell(_W)
	elseif IsReady(_Q) and ValidTarget(enemy, 880) and AhriMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q",enemy) then 
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
    if AhriMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _E, _W, _Q, _Q , _R, _Q , _E, _Q , _E, _R, _E, _E, _W, _W, _R, _W, _W}
    elseif AhriMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif AhriMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)
 
OnUpdateBuff(function(unit,buff)
  if buff.Name == "ahritumble" then 
  UltOn = true
  end
end)

OnRemoveBuff(function(unit,buff)
  if buff.Name == "ahritumble" then 
  UltOn = false
  end
end)

AddGapcloseEvent(_E, 666, false)
