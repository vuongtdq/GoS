if GetObjectName(GetMyHero()) ~= "Azir" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

local AzirMenu = MenuConfig("Azir", "Azir")
AzirMenu:Menu("Combo", "Combo")
AzirMenu.Combo:Boolean("Q", "Use Q", true)
AzirMenu.Combo:Boolean("W", "Use W", true)
AzirMenu.Combo:Boolean("E", "Use E", true)
AzirMenu.Combo:Boolean("R", "Use R", true)
AzirMenu.Combo:Boolean("AA", "Use AA", true)
AzirMenu.Combo:KeyBinding("Flee", "Flee", string.byte("G"))
AzirMenu.Combo:KeyBinding("Insec", "Insec", string.byte("T"))

AzirMenu:Menu("Harass", "Harass")
AzirMenu.Harass:Boolean("Q", "Use Q", true)
AzirMenu.Harass:Boolean("W", "Use W", true)
AzirMenu.Harass:Boolean("AA", "Use AA", true)

AzirMenu:Menu("Killsteal", "Killsteal")
AzirMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
AzirMenu.Killsteal:Boolean("E", "Killsteal with E", true)

AzirMenu:Menu("Misc", "Misc")
if Ignite ~= nil then AzirMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
AzirMenu.Misc:Boolean("Autolvl", "Auto level", true)
AzirMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E"})
AzirMenu.Misc:Menu("AutoUlt", "Auto Ult")
AzirMenu.Misc.AutoUlt:Boolean("Enabled", "Enabled", true)
AzirMenu.Misc.AutoUlt:Slider("Push", "if Can Push X Enemies", 3, 0, 5, 1)

AzirMenu:Menu("Drawings", "Drawings")
AzirMenu.Drawings:Boolean("Q", "Draw Q Range", true)
AzirMenu.Drawings:Boolean("W", "Draw W Range", true)
AzirMenu.Drawings:Boolean("E", "Draw E Range", true)
AzirMenu.Drawings:Boolean("R", "Draw R Range", true)
AzirMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})
 
local InterruptMenu = MenuConfig("Interrupt (R)", "Interrupt")

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

OnProcessSpellComplete(function(unit, spell)
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_R) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 450) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then 
        CastSkillShot(_R,GetOrigin(unit))
        end
      end
    end
end)

OnDraw(function(myHero)
local col = AzirMenu.Drawings.color:Value()
if AzirMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),950,1,0,col) end
if AzirMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),450,1,0,col) end
if AzirMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),1300,1,0,col) end
if AzirMenu.Drawings.R:Value() then DrawCircle(myHeroPos(),950,1,0,col) end
end)

local AzirSoldiers = {}
local lastlevel = 0
  
OnTick(function(myHero)
   local target = GetCurrentTarget()	
   
   if IOW:Mode() == "Combo" then
	
     if IsReady(_W) and ValidTarget(target,850) and AzirMenu.Combo.W:Value() then
     Cast(_W,target)
     end
		
     for _,Soldier in pairs(AzirSoldiers) do
		   
       if ValidTarget(target, 1500) then
       SoldierRange = GetDistance(Soldier, target)
       end
		
       if IsReady(_E) and ValidTarget(target, 1300) and EnemiesAround(GetOrigin(target), 666) < 2 and AzirMenu.Combo.E:Value() then 
       local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(Soldier), GetOrigin(target))
         if isOnSegment and GetDistance(target, pointSegment) < 100 then
	 CastTargetSpell(Soldier, _E)
	 end
       end
		   
       if IsReady(_Q) and SoldierRange >= 400 and ValidTarget(target, 950) and AzirMenu.Combo.Q:Value() then
       Cast(_Q,target,Soldier)
       end
		   
       if ValidTarget(target, 1500) and GetDistance(myHero, target) >= 550 and SoldierRange <= 400 and AzirMenu.Combo.AA:Value() then
       AttackUnit(target)
       end
	   
     end
         
     if IsReady(_R) and ValidTarget(target, 500) and AzirMenu.Combo.R:Value() and GetPercentHP(target) <= 50 and GetPercentMP(myHero) >= 30 then
     Cast(_R,target)
     end
	
   end
	
   if IOW:Mode() == "Harass"  then
    	
     if IsReady(_W) and ValidTarget(target,850) and AzirMenu.Harass.W:Value() then
     Cast(_W,target)
     end	
		
     for _,Soldier in pairs(AzirSoldiers) do

       if ValidTarget(target, 1500) then
       SoldierRange = GetDistance(Soldier, target)
       end
		   
       if IsReady(_Q) and GetDistance(target) >= 400 and ValidTarget(target, 950) and AzirMenu.Harass.Q:Value() then
       Cast(_Q,target,Soldier)
       end
		   
       if ValidTarget(target, 1500) and GetDistance(myHero, target) >= 550 and SoldierRange <= 400 and AzirMenu.Harass.AA:Value() then
       AttackUnit(target)
       end
	   
     end
	
   end
	
   for i,enemy in pairs(GetEnemyHeroes()) do
   	
        if Ignite and AzirMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
        
        for _,Soldier in pairs(AzirSoldiers) do
	  if IsReady(_Q) and ValidTarget(enemy, 950) and AzirMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q",enemy) then 
	  Cast(_Q,enemy,Soldier)
	  end

          if IsReady(_E) and ValidTarget(enemy, 1300) and EnemiesAround(GetOrigin(enemy), 666) < 2 and AzirMenu.Killsteal.E:Value() and GetHP2(enemy) < getdmg("Q",enemy) then 
	    local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(Soldier), GetOrigin(enemy))
            if isOnSegment and GetDistance(enemy, pointSegment) < 100 then
	    CastTargetSpell(Soldier, _E)
	    end
	  end
        end

   end
	
	local RThrowPos = GetMEC(600,GetEnemyHeroes()) 
	if IsReady(_R) and AzirMenu.Misc.AutoUlt.Enabled:Value() and RThrowPos.count >= AzirMenu.Misc.AutoUlt.Push:Value() then
	CastSkillShot(_R, RThrowPos)
	end
	
   if AzirMenu.Combo.Flee:Value() then
	
	MoveToXYZ(mousePos())
        if IsReady(_W) and table.getn(AzirSoldiers) < 1 then 
        local movePos = myHeroPos() + (Vector(mousePos()) - myHeroPos()):normalized()*450
	CastSkillShot(_W, movePos.x, movePos.y, movePos.z) 
	end
	
	for _,Soldier in pairs(AzirSoldiers) do
	  local movePos = myHeroPos() + (Vector(mousePos()) - myHeroPos()):normalized()*950
	  if movePos then
          CastTargetSpell(Soldier, _E)
          DelayAction(function() CastSkillShot(_Q, movePos.x, movePos.y, movePos.z) end, 150)
          end
        end
			
   end
	
   if AzirMenu.Combo.Insec:Value() then
	
     local enemy = ClosestEnemy(mousePos())
     if not enemy or GetDistance(enemy) > 750 then
     MoveToXYZ(mousePos())
     return 
     end

     if table.getn(AzirSoldiers) < 1 and IsReady(_W) then
     CastSkillShot(_W, myHeroPos().x, myHeroPos().y, myHeroPos().z)
     end
     
     for _,Soldier in pairs(AzirSoldiers) do
       local movePos = myHeroPos() + (Vector(enemy) - myHeroPos()):normalized() * 950
       if movePos then
       CastSkillShot(_Q, movePos.x, movePos.y, movePos.z)
       DelayAction(function() CastTargetSpell(Soldier, _E) end, 250)
         if GetDistance(enemy) < 250 then
         CastSkillShot(_R,GetOrigin(enemy))
         end
       end
     end
   
    end
	
if AzirMenu.Misc.Autolvl:Value() then
  if GetLevel(myHero) > lastlevel then
    if AzirMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_W, _Q, _E, _Q, _Q , _R, _Q , _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif AzirMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)

OnCreateObj(function(Object) 
  if GetObjectBaseName(Object) == "AzirSoldier" then
  table.insert(AzirSoldiers, Object)
  end
end)

OnDeleteObj(function(Object) 
  if GetObjectBaseName(Object) == "Azir_Base_P_Soldier_Ring.troy" then
  table.remove(AzirSoldiers, 1)
  end
end)

AddGapcloseEvent(_R, 69, false) -- yeah 69 right
