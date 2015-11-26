if GetObjectName(GetMyHero()) ~= "Azir" then return end

require('Inspired')
require('DeftLib')
require('DamageLib')

AutoUpdate("/D3ftsu/GoS/master/Azir.lua","/D3ftsu/GoS/master/Azir.version","Azir.lua",9)

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
AzirMenu.Killsteal:Boolean("W", "Killsteal with W/AA", false)
AzirMenu.Killsteal:Boolean("E", "Killsteal with E", true)

AzirMenu:Menu("Misc", "Misc")
if Ignite ~= nil then AzirMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
AzirMenu.Misc:Boolean("Autolvl", "Auto level", true)
AzirMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E"})
--AzirMenu.Misc:Menu("AutoUlt", "Auto Ult")
--AzirMenu.Misc.AutoUlt:Boolean("Enabled", "Enabled", true)
--AzirMenu.Misc.AutoUlt:Slider("Push", "if Can Push X Enemies", 3, 0, 5, 1)

AzirMenu:Menu("LaneClear", "LaneClear")
AzirMenu.LaneClear:Boolean("Q", "Use Q", true)
AzirMenu.LaneClear:Boolean("W", "Use W", true)
AzirMenu.LaneClear:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

AzirMenu:Menu("Drawings", "Drawings")
AzirMenu.Drawings:Boolean("Q", "Draw Q Range", true)
AzirMenu.Drawings:Boolean("W", "Draw W Range", true)
AzirMenu.Drawings:Boolean("E", "Draw E Range", true)
AzirMenu.Drawings:Boolean("R", "Draw R Range", true)
 
AzirMenu:Menu("Interrupt", "Interrupt (R)")

DelayAction(function()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
      if spell["Name"] == GetObjectName(k) then
      AzirMenu.Interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
      end
    end
  end
end, 1)

OnProcessSpell(function(unit, spell)
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_R) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 450) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and AzirMenu.Interrupt[GetObjectName(unit).."Inter"]:Value() then 
        CastSkillShot(_R,GetOrigin(unit))
        end
      end
    end
    
    if unit == myHero and spell.name == "AzirQ" then
      for _,soldier in pairs(AzirSoldiers) do
        if AzirSoldiersTimeHolder[GetNetworkID(soldier)] and AzirSoldiersTimeHolder[GetNetworkID(soldier)] < math.huge and AzirSoldiersTimeHolder[GetNetworkID(soldier)] > GetTickCount() then 
        AzirSoldiersTimeHolder[GetNetworkID(soldier)] = AzirSoldiersTimeHolder[GetNetworkID(soldier)] + 1000
        end
      end
    end
end)

local AzirSoldiers = {}
local AzirSoldiersTimeHolder = {}

OnCreateObj(function(Object) 
  if GetObjectBaseName(Object) == "AzirSoldier" then
  AzirSoldiers[GetNetworkID(Object)] = Object
  AzirSoldiersTimeHolder[GetNetworkID(Object)] = GetTickCount()+9000
  end
end)

function CountSoldiers(unit)
  soldiers = 0
  for _,soldier in pairs(AzirSoldiers) do
    if AzirSoldiersTimeHolder[GetNetworkID(soldier)] and AzirSoldiersTimeHolder[GetNetworkID(soldier)] > GetTickCount() and (not unit or GetDistance(soldier, unit) < 400) then 
    soldiers = soldiers + 1
    end
  end
  return soldiers
end

function GetSoldiers()
  soldiers = {}
  for _,soldier in pairs(AzirSoldiers) do
    if AzirSoldiersTimeHolder[GetNetworkID(soldier)] and AzirSoldiersTimeHolder[GetNetworkID(soldier)] > GetTickCount() then 
    table.insert(soldiers, soldier)
    end
  end
  return soldiers
end

OnDraw(function(myHero)
local pos = GetOrigin(myHero)
if AzirMenu.Drawings.Q:Value() then DrawCircle(pos,950,1,25,GoS.Pink) end
if AzirMenu.Drawings.W:Value() then DrawCircle(pos,450,1,25,GoS.Yellow) end
if AzirMenu.Drawings.E:Value() then DrawCircle(pos,1300,1,25,GoS.Blue) end
if AzirMenu.Drawings.R:Value() then DrawCircle(pos,950,1,25,GoS.Green) end
end)

local target1 = TargetSelector(990,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local target2 = TargetSelector(650,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local target3 = TargetSelector(500,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local lastlevel = GetLevel(myHero)-1
  
OnTick(function(myHero)
   local mousePos = GetMousePos()
   local target = GetCurrentTarget()
   local Qtarget = target1:GetTarget()
   local Wtarget = target2:GetTarget()
   local Rtarget = target3:GetTarget()
   
   if IOW:Mode() == "Combo" then
	
     if IsReady(_Q) and IsReady(_W) and AzirMenu.Combo.Q:Value() and AzirMenu.Combo.W:Value() and ValidTarget(Qtarget, 990) and GetCurrentMana(myHero) >= (GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_W,GetCastLevel(myHero,_W))) then
       for _,Soldier in pairs(GetSoldiers()) do
       CastSkillShot(_W, GetOrigin(Qtarget))
       DelayAction(function() Cast(_Q,Qtarget,Soldier) end, 250)
       end
     end
	 
     if AzirMenu.Combo.Q:Value() and CountSoldiers() > 0 then
       for _,Soldier in pairs(GetSoldiers()) do
       Cast(_Q, Qtarget, Soldier)
       end
     end
	
     if IsReady(_W) and AzirMenu.Combo.W:Value() then
     Cast(_W,Wtarget)
     end
	 
     if IsReady(_E) and AzirMenu.Combo.E:Value() and ValidTarget(target, 1300) and EnemiesAround(GetOrigin(target), 666) < 2 and GetHP2(target) < getdmg("Q", target) + getdmg("W",target)*CountSoldiers(target) then 
       for _,Soldier in pairs(GetSoldiers()) do
         local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(Soldier), GetOrigin(target))
         if isOnSegment and GetDistanceSqr(target, pointSegment) < 10000 then
	 CastTargetSpell(Soldier, _E)
	 end
       end
     end
		 
     if CountSoldiers() > 0 then
       for _,Soldier in pairs(GetSoldiers()) do  
         if AzirMenu.Combo.AA:Value() and ValidTarget(target, 1500) and GetDistance(target) >= 550 and GetDistance(Soldier, target) <= 400 then
         AttackUnit(target)
         end
       end	   
     end
         
     if IsReady(_R) and AzirMenu.Combo.R:Value() and ValidTarget(Rtarget, 520) and GetHP2(Rtarget) < (GetCastMana(myHero) >= (GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_R,GetCastLevel(myHero,_R))) and getdmg("R", Rtarget)+getdmg("Q", Rtarget)+getdmg("W", Rtarget)*CountSoldiers()) or 0  then
     Cast(_R,Rtarget)
     end
	
   end
	
   if IOW:Mode() == "Harass"  then
    	
     if IsReady(_Q) and IsReady(_W) and AzirMenu.Harass.Q:Value() and AzirMenu.Harass.W:Value() and ValidTarget(Qtarget, 990) and GetCurrentMana(myHero) >= (GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_W,GetCastLevel(myHero,_W))) then
       for _,Soldier in pairs(GetSoldiers()) do
       CastSkillShot(_W, GetOrigin(Qtarget))
       DelayAction(function() Cast(_Q,Qtarget,Soldier) end, 250)
       end
     end
	 
     if AzirMenu.Harass.Q:Value() and CountSoldiers() > 0 then
       for _,Soldier in pairs(GetSoldiers()) do
       Cast(_Q, Qtarget, Soldier)
       end
     end
	
     if IsReady(_W) and AzirMenu.Harass.W:Value() then
     Cast(_W,Wtarget)
     end
		 
     if CountSoldiers() > 0 then
       for _,Soldier in pairs(GetSoldiers()) do  
         if AzirMenu.Harass.AA:Value() and ValidTarget(target, 1500) and GetDistance(target) >= 550 and GetDistance(Soldier, target) <= 400 then
         AttackUnit(target)
         end
       end	   
     end
	
   end
	
   for i,enemy in pairs(GetEnemyHeroes()) do
   	
        if Ignite and AzirMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
		
	--[[if ValidTarget(enemy, 520) then
	  local RThrowPos = GetMEC(600,GetEnemyHeroes())
	  if IsReady(_R) and AzirMenu.Misc.AutoUlt.Enabled:Value() and RThrowPos.count >= AzirMenu.Misc.AutoUlt.Push:Value() then
	  CastSkillShot(_R, RThrowPos)
	  end
        end]]

	if ValidTarget(enemy, 800) and GetHP2(enemy) < CountSoldiers(enemy)*getdmg("W",enemy) and AzirMenu.Killsteal.W:Value() then 
        AttackUnit(enemy)
        elseif IsReady(_W) and ValidTarget(enemy, 800) and GetHP2(enemy) < (CountSoldiers(enemy)+1)*getdmg("W",enemy) and AzirMenu.Killsteal.W:Value() then 
        Cast(_W, enemy)
        DelayAction(function() AttackUnit(enemy) end, 250)
        elseif IsReady(_R) and ValidTarget(enemy, 520) and GetHP2(enemy) < getdmg("R",enemy) and AzirMenu.Killsteal.R:Value() then
        Cast(_R, enemy)
        end
		
        for _,Soldier in pairs(GetSoldiers()) do
	  if IsReady(_Q) and ValidTarget(enemy, 990) and AzirMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q",enemy) then 
          Cast(_Q,enemy,Soldier)
          elseif IsReady(_E) and ValidTarget(enemy, 1300) and EnemiesAround(GetOrigin(enemy), 666) < 2 and AzirMenu.Killsteal.E:Value() and GetHP2(enemy) < getdmg("E",enemy) then 
	    local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(Soldier), GetOrigin(enemy))
            if isOnSegment and GetDistanceSqr(enemy, pointSegment) < 10000 then
	    CastTargetSpell(Soldier, _E)
	    end
	  end
        end

   end
   
   if IOW:Mode() == "LaneClear" then
      
     if IsReady(_W) and AzirMenu.LaneClear.W:Value() and CountSoldiers() < 2 then
       local BestPos, BestHit = GetLineFarmPosition(450, 400, MINION_ENEMY)
       if BestPos and BestHit > 1 then 
       CastSkillShot(_W, BestPos)
       end
     end
      
     if IsReady(_Q) and AzirMenu.LaneClear.Q:Value() then
       local BestPos, BestHit = GetLineFarmPosition(950, 80, MINION_ENEMY)
       if BestPos and BestHit > 1 then 
       CastSkillShot(_Q, BestPos)
       end
     end
	  
   end

   if AzirMenu.Combo.Flee:Value() then
	
     MoveToXYZ(mousePos)
	 
     if SoldierToDash then
       local movePos = GetOrigin(myHero) + (Vector(mousePos) - GetOrigin(myHero)):normalized()*950
       if movePos then
         if IsReady(_E) and IsReady(_Q) and GetCurrentMana(myHero) >= (GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_E,GetCastLevel(myHero,_E))) then
	 CastTargetSpell(SoldierToDash, _E)
         DelayAction(function() CastSkillShot(_Q,movePos) end, 150)
	 elseif IsReady(_E) then
	 CastTargetSpell(SoldierToDash, _E)
         end
       end
     elseif CountSoldiers() > 0 then
       for _,Soldier in pairs(GetSoldiers()) do
         if not SoldierToDash then
         SoldierToDash = Soldier
         elseif SoldierToDash and GetDistanceSqr(Soldier,mousePos) < GetDistanceSqr(SoldierToDash,mousePos) then
         SoldierToDash = Soldier
         end
       end
     elseif IsReady(_W) and GetCurrentMana(myHero) >= (GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + (GetCastMana(myHero,_W,GetCastLevel(myHero,_W)) + GetCastMana(myHero,_E,GetCastLevel(myHero,_E)))) then 
       local movePos = GetOrigin(myHero) + (Vector(mousePos) - GetOrigin(myHero)):normalized()*450
       if movePos then
       CastSkillShot(_W, movePos) 
       end
     end
	
   end
	
   if AzirMenu.Combo.Insec:Value() then

     local enemy = ClosestEnemy(mousePos)
     if not enemy or GetDistance(enemy) > 750 then
     MoveToXYZ(mousePos)
     end
     
     if IsReady(_R) then
	 
       if CountSoldiers() > 0 then
         for _,Soldier in pairs(GetSoldiers()) do
           if not SoldierToDash then
           SoldierToDash = Soldier
           elseif SoldierToDash and GetDistanceSqr(Soldier,enemy) < GetDistanceSqr(SoldierToDash,enemy) then
           SoldierToDash = Soldier
           end
         end
       end
	   
       if not SoldierToDash and IsReady(_W) then
       CastSkillShot(_W, GetOrigin(enemy))
       end
	   
       if CountSoldiers() > 0 and SoldierToDash then
         local movePos = GetOrigin(myHero) + (Vector(enemy) - GetOrigin(myHero)):normalized() * 950
         if movePos then
         CastSkillShot(_Q, movePos)
         DelayAction(function() CastTargetSpell(SoldierToDash, _E) end, 250)
         Insec(Vector(myHero), enemy)
         DelayAction(function() SoldierToDash = nil end, 2000)
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

function Insec(pos, unit)
  if ValidTarget(unit) and GetDistance(unit) < 250 then
  CastSkillShot(_R, pos)
  else
  DelayAction(function() Insec(pos, unit) end, 30)
  end
end

AddGapcloseEvent(_R, 69, false, AzirMenu)

PrintChat(string.format("<font color='#1244EA'>Azir:</font> <font color='#FFFFFF'> By Deftsu Loaded, Have A Good Game ! </font>"))
