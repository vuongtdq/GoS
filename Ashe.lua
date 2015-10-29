if GetObjectName(GetMyHero()) ~= "Ashe" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end
if not pcall( require, "DamageLib" ) then PrintChat("You are missing DamageLib.lua - Go download it and save it in Common!") return end

local AsheMenu = MenuConfig("Ashe", "Ashe")
AsheMenu:Menu("Combo", "Combo")
AsheMenu.Combo:Boolean("Q", "Use Q", true)
AsheMenu.Combo:Boolean("W", "Use W", true)
AsheMenu.Combo:Boolean("R", "Use R", true)
AsheMenu.Combo:KeyBinding("FireKey", "Ult Fire Key", string.byte("T"))
AsheMenu.Combo:Boolean("Items", "Use Items", true)
AsheMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
AsheMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
AsheMenu.Combo:Boolean("QSS", "Use QSS", true)
AsheMenu.Combo:Slider("QSSHP", "if HP % <", 75, 0, 100, 1)

AsheMenu:Menu("Harass", "Harass")
AsheMenu.Harass:Boolean("Q", "Use Q", true)
AsheMenu.Harass:Boolean("W", "Use W", true)
AsheMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)
AsheMenu.Harass:Boolean("AutoW", "Auto W", true)
AsheMenu.Harass:Slider("WMana", "if Mana % >", 50, 0, 80, 1)

AsheMenu:Menu("Killsteal", "Killsteal")
AsheMenu.Killsteal:Boolean("W", "Killsteal with W", true)
AsheMenu.Killsteal:Boolean("R", "Killsteal with R", false)

AsheMenu:Menu("Misc", "Misc")
if Ignite ~= nil then AsheMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
AsheMenu.Misc:Boolean("Autolvl", "Auto level", true) 
AsheMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"W-Q-E", "Q-W-E"})

AsheMenu:Menu("LaneClear", "LaneClear")
AsheMenu.LaneClear:Boolean("Q", "Use Q", false)
AsheMenu.LaneClear:Boolean("W", "Use W", false)
AsheMenu.LaneClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

AsheMenu:Menu("JungleClear", "JungleClear")
AsheMenu.JungleClear:Boolean("Q", "Use Q", true)
AsheMenu.JungleClear:Boolean("W", "Use W", true)
AsheMenu.JungleClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

AsheMenu:Menu("Drawings", "Drawings")
AsheMenu.Drawings:Boolean("W", "Draw W Range", true)
AsheMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

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

OnProcessSpell(function(unit, spell)
    if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_R) then
      if CHANELLING_SPELLS[spell.name] then
        if ValidTarget(unit, 1000) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then 
        Cast(_R,unit)
        end
      end
    end
end)

OnDraw(function(myHero)
if AsheMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),1200,1,0,AsheMenu.Drawings.color:Value()) end
end)

local QReady = false
local lastlevel = 0

OnTick(function(myHero)
    local target = GetCurrentTarget()
    
    if IOW:Mode() == "Combo" then
	
	if IsReady(_Q) and QReady and ValidTarget(target, 600) and AsheMenu.Combo.Q:Value() then
        CastSpell(_Q)
        end
						
        if IsReady(_W) and ValidTarget(target, 1200) and AsheMenu.Combo.W:Value() then
        Cast(_W,target)
        end
						
        if IsReady(_R) and ValidTarget(target, 2000) and GetPercentHP(target) <= 50 and AsheMenu.Combo.R:Value() then
        Cast(_R,target)
	end
		
	if GetItemSlot(myHero,3140) > 0 and IsReady(GetItemSlot(myHero,3140)) and AsheMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and GetPercentHP(myHero) < AsheMenu.Combo.QSSHP:Value() then
        CastSpell(GetItemSlot(myHero,3140))
        end

        if GetItemSlot(myHero,3139) > 0 and IsReady(GetItemSlot(myHero,3139)) and AsheMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and GetPercentHP(myHero) < AsheMenu.Combo.QSSHP:Value() then
        CastSpell(GetItemSlot(myHero,3139))
        end
    end

    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= AsheMenu.Harass.Mana:Value() then 

	if IsReady(_Q) and QReady and ValidTarget(target, 600) and AsheMenu.Harass.Q:Value() then
        CastSpell(_Q)
        end
						
        if IsReady(_W) and ValidTarget(target, 1200) and AsheMenu.Harass.W:Value() then
        Cast(_W,target)
	end
		
    end

    if AsheMenu.Combo.FireKey:Value() then
      if IsReady(_R) and ValidTarget(target, 3000) then 
      Cast(_R,target)
      end  
    end

      if AsheMenu.Harass.AutoW:Value() and GetPercentMP(myHero) >= AsheMenu.Harass.WMana:Value() then
        if IsReady(_W) and ValidTarget(target, 1200) and not IsRecalling(myHero) then
        Cast(_W,target)
	end
      end

    for i,enemy in pairs(GetEnemyHeroes()) do
	
      if IOW:Mode() == "Combo" then	
	if GetItemSlot(myHero,3153) > 0 and IsReady(GetItemSlot(myHero,3153)) and AsheMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and GetPercentHP(myHero) < AsheMenu.Combo.myHP:Value() and GetPercentHP(enemy) > AsheMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, GetItemSlot(myHero,3153))
        end

        if GetItemSlot(myHero,3144) > 0 and IsReady(GetItemSlot(myHero,3144)) and AsheMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and GetPercentHP(myHero) < AsheMenu.Combo.myHP:Value() and GetPercentHP(enemy) > AsheMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, GetItemSlot(myHero,3144))
        end

        if GetItemSlot(myHero,3142) > 0 and IsReady(GetItemSlot(myHero,3142)) and AsheMenu.Combo.Items:Value() and ValidTarget(enemy, 600) then
        CastSpell(GetItemSlot(myHero,3142))
        end	
      end
      
	if Ignite and AsheMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
	end
	
	if IsReady(_W) and ValidTarget(enemy, 1200) and AsheMenu.Killsteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then 
	Cast(_W,enemy)
	end
		  
	if IsReady(_R) and ValidTarget(enemy, 3000) and AsheMenu.Killsteal.R:Value() and GetHP2(enemy) < getdmg("R",enemy) then
        Cast(_R,enemy)
	end
		
    end
       
    if IOW:Mode() == "LaneClear" then
    	
      local closeminion = ClosestMinion(GetOrigin(myHero), MINION_ENEMY)
      if GetPercentMP(myHero) >= AsheMenu.LaneClear.Mana:Value() then
      
        if IsReady(_W) and AsheMenu.LaneClear.W:Value() then
          local BestPos, BestHit = GetFarmPosition(1200, 300)
          if BestPos and BestHit > 0 then
	  CastSkillShot(_W, BestPos)
  	  end
        end  
        
        if IsReady(_Q) and AsheMenu.LaneClear.Q:Value() and QReady and ValidTarget(closeminion, 600) then
        CastSpell(_Q)
        end
	        
      end

      for i,mobs in pairs(minionManager.objects) do
		
        if GetTeam(mobs) == 300 and GetPercentMP(myHero) >= AsheMenu.JungleClear.Mana:Value() then
          if IsReady(_Q) and AsheMenu.JungleClear.Q:Value() and QReady and ValidTarget(mobs, 600) then
          CastSpell(_Q)
          end		

	  if IsReady(_W) and AsheMenu.JungleClear.W:Value() and ValidTarget(mobs, 1200) then
	  CastSkillShot(_W,GetOrigin(mobs))
	  end
        end
      end
      
    end

if AsheMenu.Misc.Autolvl:Value() then  
  if GetLevel(myHero) > lastlevel then
    if AsheMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_W, _Q, _E, _W, _W, _R, _W, _Q, _W , _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    elseif AsheMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_W, _Q, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)

OnUpdateBuff(function(unit,buff)
  if unit == myHero and buff.Name == "asheqcastready" then 
  QReady = true
  end
end)

OnRemoveBuff(function(unit,buff)
  if unit == myHero and buff.Name == "asheqcastready" then 
  QReady = false
  end
end)

OnCreateObj(function(Object) 
  if GetObjectBaseName(Object) == "Ashe_Base_Q_ready.troy" and GetDistance(Object) < 100 then
  QReady = true
  end
end)

OnDeleteObj(function(Object) 
  if GetObjectBaseName(Object) == "Ashe_Base_Q_ready.troy" and GetDistance(Object) < 100 then
  QReady = false
  end
end)

AddGapcloseEvent(_R, 69, false)
