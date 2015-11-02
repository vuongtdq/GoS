if GetObjectName(GetMyHero()) ~= "Vayne" then return end

if not pcall( require, "MapPositionGOS" ) then PrintChat("You are missing Walls Library - Go download it and save it Common!") return end
if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end

local VayneMenu = MenuConfig("Vayne", "Vayne")
VayneMenu:Menu("Combo", "Combo")
VayneMenu.Combo:Menu("Q", "Tumble (Q)")
VayneMenu.Combo.Q:DropDown("Mode", "Mode", 1, {"Reset", "Normal"})
VayneMenu.Combo.Q:Boolean("Enabled", "Enabled", true)
VayneMenu.Combo.Q:Boolean("KeepInvis", "Don't AA While Stealthed", true)
VayneMenu.Combo.Q:Slider("KeepInvisdis", "Only if Distance <", 230, 0, 550, 1)

VayneMenu.Combo:Menu("E", "Condemn (E)")
VayneMenu.Combo.E:Menu("EMenu", "AutoStun")
VayneMenu.Combo.E.EMenu:Boolean("Enabled", "Enabled", true)
VayneMenu.Combo.E:Slider("pushdistance", "E Push Distance", 400, 350, 490, 1)
VayneMenu.Combo.E:Boolean("stuntarget", "Stun Current Target Only", false)
VayneMenu.Combo.E:Boolean("lowhp", "Peel with E when low health", true)
VayneMenu.Combo.E:Boolean("AutoE", "Auto Wall Condemn", true)

VayneMenu.Combo:Menu("R", "Final Hour (R)")
VayneMenu.Combo.R:Boolean("Enabled", "Enabled", true)
VayneMenu.Combo.R:Slider("Rifthp", "if Target Health % <", 70, 1, 100, 1)
VayneMenu.Combo.R:Slider("Rifhp", "if Health % <", 55, 1, 100, 1)
VayneMenu.Combo.R:Slider("Rminally", "Minimum Allies in Range", 2, 0, 4, 1)
VayneMenu.Combo.R:Slider("Rallyrange", "Range", 1000, 1, 2000, 10)
VayneMenu.Combo.R:Slider("Rminenemy", "Minimum Enemies in Range", 2, 1, 5, 1)
VayneMenu.Combo.R:Slider("Renemyrange", "Range", 1000, 1, 2000, 10)
VayneMenu.Combo:Boolean("Items", "Use Items", true)
VayneMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
VayneMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
VayneMenu.Combo:Boolean("QSS", "Use QSS", true)
VayneMenu.Combo:Slider("QSSHP", "if My Health % <", 75, 0, 100, 1)


VayneMenu:Menu("Misc", "Misc")
if Ignite ~= nil then VayneMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
VayneMenu.Misc:Boolean("Autolvl", "Auto level", true)
VayneMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"W-Q-E", "Q-W-E"})
VayneMenu.Misc:KeyBinding("WallTumble1", "WallTumble Mid", string.byte("T"))
VayneMenu.Misc:KeyBinding("WallTumble2", "WallTumble Drake", string.byte("U"))

VayneMenu:Menu("Drawings", "Drawings")
VayneMenu.Drawings:Boolean("Q", "Draw Q Range", true)
VayneMenu.Drawings:Boolean("E", "Draw E Range", true)
VayneMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

if mapID == SUMMONERS_RIFT then
VayneMenu.Drawings:Boolean("WT", "Draw WallTumble Pos", true)
end

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
  
  for _,k in pairs(GetEnemyHeroes()) do
  VayneMenu.Combo.E.EMenu:Boolean(GetObjectName(k).."Pleb", "..GetObjectName(k)..", true)
  end
		
end, 1)
  
OnDraw(function(myHero)
local col = VayneMenu.Drawings.color:Value()
if VayneMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_Q),1,0,col) end
if VayneMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_E),1,0,col) end
if mapID == SUMMONERS_RIFT and VayneMenu.Drawings.WT:Value() then
DrawCircle(6962, 51, 8952,80,0,0,0xffffffff)
DrawCircle(12060, 51, 4806,80,0,0,0xffffffff)
end
end)

local IsStealthed = false

OnTick(function(myHero)
    HeroPos = GetOrigin(myHero)
    mousePos = GetMousePos()
    if IOW:Mode() == "Combo" then
	
	local target = GetCurrentTarget()
	
	if VayneMenu.Combo.Q.Mode:Value() == 2 and ValidTarget(target, 900) and VayneMenu.Combo.Q.Enabled:Value() then
          local AfterTumblePos = HeroPos + (Vector(mousePos) - HeroPos):normalized() * 300
          local DistanceAfterTumble = GetDistance(AfterTumblePos, target)
  
          if GetDistance(myHero, target) > 630 and DistanceAfterTumble < 630 then
          CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
          end
        end

	if GetItemSlot(myHero,3140) > 0 and VayneMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3140))
        end

        if GetItemSlot(myHero,3139) > 0 and VayneMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3139))
        end
		
	if IsReady(_E) and VayneMenu.Combo.E.stuntarget:Value() and VayneMenu.Combo.E.Enabled:Value() and ValidTarget(target, 710) then
        StunThisPleb(target)
        end

        if IsReady(_R) and ValidTarget(target, VayneMenu.Combo.R.Renemyrange:Value()) and 100*GetCurrentHP(target)/GetMaxHP(target) <= VayneMenu.Combo.R.Rifthp:Value() and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) <= VayneMenu.Combo.R.Rifhp:Value() and EnemiesAround(myHeroPos(), VayneMenu.Combo.R.Renemyrange:Value()) >= VayneMenu.Combo.R.Rminenemy:Value() and AlliesAround(myHeroPos(), VayneMenu.Combo.R.Rallyrange:Value()) >= VayneMenu.Combo.R.Rminally:Value() then
        CastSpell(_R)
	end
		
        if IsStealthed and ValidTarget(target, 550) and GetDistance(target) > VayneMenu.Combo.Q.KeepInvisdis:Value() then
	IOW.attacksEnabled = true
	elseif not IsStealthed then
	IOW.attacksEnabled = true
	elseif IsStealthed and VayneMenu.Combo.Q.KeepInvis:Value() and ValidTarget(target, VayneMenu.Combo.Q.KeepInvisdis:Value()) and GetDistance(myHero, target) < VayneMenu.Combo.Q.KeepInvisdis:Value() then 
	IOW.attacksEnabled = false
	end
	
   end

   for i,enemy in pairs(GetEnemyHeroes()) do
        
        if IOW:Mode() == "Combo" then  
          if GetItemSlot(myHero,3153) > 0 and VayneMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > VayneMenu.Combo.targetHP:Value() then
          CastTargetSpell(enemy, GetItemSlot(myHero,3153))
          end

          if GetItemSlot(myHero,3144) > 0 and VayneMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < VayneMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > VayneMenu.Combo.targetHP:Value() then
          CastTargetSpell(enemy, GetItemSlot(myHero,3144))
          end

          if GetItemSlot(myHero,3142) > 0 and VayneMenu.Combo.Items:Value() and ValidTarget(enemy, 600) then
          CastTargetSpell(myHero, GetItemSlot(myHero,3142))
          end
        end
        
          if Ignite and VayneMenu.Misc.AutoIgnite:Value() then
            if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 900) then
            CastTargetSpell(enemy, Ignite)
            end
	  end
        
	if IsReady(_E) and VayneMenu.Combo.E.EMenu[GetObjectName(enemy).."Pleb"]:Value() and ValidTarget(enemy, 710) then
        StunThisPleb(enemy)
        end

        if IsReady(_E) and VayneMenu.Combo.E.lowhp:Value() and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) <= 15 and EnemiesAround(myHeroPos(), 375) >= 1 then
        CastTargetSpell(enemy, _E)
        end

        if IsReady(_E) and ValidTarget(enemy, 710) and VayneMenu.Combo.E.Enabled:Value() and IOW:Mode() == "Combo" and VayneMenu.Combo.E.stuntarget:Value() == false then
        StunThisPleb(enemy)
        end
   end

        if VayneMenu.Misc.WallTumble1:Value() and myHeroPos().x == 6962 and myHeroPos().z == 8952 then
        CastSkillShot(_Q,6667.3271484375, 51, 8794.64453125)
        elseif VayneMenu.Misc.WallTumble1:Value() then
        MoveToXYZ(6962, 51, 8952)
        end
    
        if VayneMenu.Misc.WallTumble2:Value() and myHeroPos().x == 12060 and myHeroPos().z == 4806 then
        CastSkillShot(_Q,11745.198242188, 51, 4625.4379882813)
        elseif VayneMenu.Misc.WallTumble2:Value() then
        MoveToXYZ(12060, 51, 4806)
        end

if VayneMenu.Misc.Autolvl:Value() then  
   if VayneMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
   elseif VayneMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
   end
DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
end

end)

OnProcessSpell(function(unit, spell)
        if unit == myHero and spell.name:lower():find("attack") and IOW:Mode() == "Combo" and IsReady(_Q) then 
	        DelayAction(function() 
	        	for i,enemy in pairs(GetEnemyHeroes()) do
                           if enemy and VayneMenu.Combo.Q.Mode:Value() == 1 and VayneMenu.Combo.Q.Enabled:Value()then
                                local AfterTumblePos = HeroPos + (Vector(mousePos) - HeroPos):normalized() * 300
                                local DistanceAfterTumble = GetDistance(AfterTumblePos, enemy)
						  
                                if DistanceAfterTumble < 800 and DistanceAfterTumble > 200 then
                                CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
                                end
  
                                if GetDistance(myHero, enemy) > 630 and DistanceAfterTumble < 630 then
                                CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
                                end
                            end
                           
                            if enemy and VayneMenu.Combo.Q.Mode:Value() == 2 and VayneMenu.Combo.Q.Enabled:Value() then
                                local AfterTumblePos = HeroPos + (Vector(mousePos) - HeroPos):normalized() * 300
                                local DistanceAfterTumble = GetDistance(AfterTumblePos, enemy)
  
                                if DistanceAfterTumble < 800 and DistanceAfterTumble > 200 then
                                CastSkillShot(_Q, mousePos.x, mousePos.y, mousePos.z)
                                end
                            end
                        end
                end, GetWindUp(myHero)*1000)	
      end
  
      if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_E) then
        if CHANELLING_SPELLS[spell.name] then
          if IsInDistance(unit, 615) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then 
          CastTargetSpell(unit, _E)
          end
        end
      end

end)

OnUpdateBuff(function(unit,buff)
  if unit == myHero then
    if buff.Name == "vaynetumblefade" then 
    IsStealthed = true
    end
  end
end)

OnRemoveBuff(function(unit,buff)
  if unit == myHero then
    if buff.Name == "vaynetumblefade" then 
    IsStealthed = false
    end
  end
end)

function StunThisPleb(unit)
        local EPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),2200,250,750,1,false,true)
        local PredPos = Vector(EPred.PredPos)
        local HeroPos = Vector(myHero)
        local maxERange = PredPos - (PredPos - HeroPos) * ( - VayneMenu.Combo.E.pushdistance:Value() / GetDistance(EPred.PredPos))
        local shootLine = Line(Point(PredPos.x, PredPos.y, PredPos.z), Point(maxERange.x, maxERange.y, maxERange.z))
       	for i, Pos in pairs(shootLine:__getPoints()) do
          if MapPosition:inWall(Pos) then
          CastTargetSpell(unit, _E) 
          end
        end
end

function StunThisPlebV2(unit)
        local EPred = GetPredictionForPlayer(GetMousePos(),unit,GetMoveSpeed(unit),2200,250,750,1,false,true)
        local PredPos = Vector(EPred.PredPos)
        local maxERange = PredPos - (PredPos - GetMousePos()) * ( - VayneMenu.Combo.E.pushdistance:Value() / GetDistance(EPred.PredPos))
        local shootLine = Line(Point(PredPos.x, PredPos.y, PredPos.z), Point(maxERange.x, maxERange.y, maxERange.z))
       	for i, Pos in pairs(shootLine:__getPoints()) do
          if MapPosition:inWall(Pos) then
          CastTargetSpell(unit, _E) 
          DelayAction(function() CastSkillShot(Flash,GetMousePos() end, 1)
          end
        end
end

AddGapcloseEvent(_E, 550, true)
