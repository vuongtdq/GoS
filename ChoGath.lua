if GetObjectName(GetMyHero()) ~= "Chogath" then return end

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
if Ignite ~= nil then ChoGathMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
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

local target1 = TargetSelector(1075,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
local target2 = TargetSelector(650,TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC,true,false)
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
    local Qtarget = target1:GetTarget()
    local Wtarget = target2:GetTarget()
    
    if IOW:Mode() == "Combo" then

        if IsReady(_Q) and ValidTarget(Qtarget,1075) and ChoGathMenu.Combo.Q:Value() then
        Cast(_Q,Qtarget)
        end
	       
	if IsReady(_W) and ValidTarget(Wtarget,650) and ChoGathMenu.Combo.W:Value() then
        Cast(_W,Wtarget)
        end
        
        if IsReady(_R) and ValidTarget(target,235) and ChoGathMenu.Combo.R:Value() and GetHP2(target) < getdmg("R", target) then
        CastTargetSpell(target, _R)
        end
        
    end
	
    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= ChoGathMenu.Harass.Mana:Value() then

        if IsReady(_Q) and ValidTarget(Qtarget,950) and ChoGathMenu.Harass.Q:Value() then
        Cast(_Q,Qtarget)
        end
	       
	if IsReady(_W) and ValidTarget(Wtarget,650) and ChoGathMenu.Harass.W:Value() then
        Cast(_W,Wtarget)
        end
        
    end
	
  for i,enemy in pairs(GetEnemyHeroes()) do
    	
	if Ignite and ChoGathMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
                
	if IsReady(_W) and ValidTarget(enemy, 235) and ChoGathMenu.Killsteal.R:Value() and GetHP2(enemy) < getdmg("R",enemy) then
	CastSpell(_W)
	elseif IsReady(_W) and ValidTarget(enemy, 650) and ChoGathMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("W",enemy) then 
	Cast(_W,enemy)
	elseif IsReady(_Q) and ValidTarget(enemy, 950) and ChoGathMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q",enemy) then
	Cast(_Q,enemy)
        end

    end
     
    if IOW:Mode() == "LaneClear" then
        if GetPercentMP(myHero) >= ChoGathMenu.LaneClear.Mana:Value() then
       	
         if IsReady(_Q) and ChoGathMenu.LaneClear.Q:Value() then
           local BestPos, BestHit = GetFarmPosition(950, 250)
           if BestPos and BestHit > 0 then 
           CastSkillShot(_Q, BestPos)
           end
	 end

         if IsReady(_W) and ChoGathMenu.LaneClear.W:Value() then
           local BestPos, BestHit = GetLineFarmPosition(650, 210)
           if BestPos and BestHit > 0 then 
           CastSkillShot(_W, BestPos)
           end
	 end
        
        end
    end
         
    for i,mobs in pairs(minionManager.objects) do
        if IOW:Mode() == "LaneClear" and GetTeam(mobs) == 300 and GetPercentMP(myHero) >= ChoGathMenu.JungleClear.Mana:Value() then
          if IsReady(_Q) and ChoGathMenu.JungleClear.Q:Value() and ValidTarget(mobs, 950) then
          CastSkillShot(_Q,GetOrigin(mobs))
	  end
		
	  if IsReady(_W) and ChoGathMenu.JungleClear.W:Value() and ValidTarget(mobs, 650) then
	  CastSpell(_W)
	  end
		
	  if IsReady(_R) and ChoGathMenu.JungleClear.R:Value() and ValidTarget(mobs, 235) and GetCurrentHP(mobs) < getdmg("R",mobs) then
	  CastTargetSpell(mobs, _R)
          end
        end
    end       
	
if ChoGathMenu.Misc.Autolvl:Value() then  
  if GetLevel(myHero) > lastlevel then
    if ChoGathMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q , _R, _Q , _W, _Q , _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif ChoGathMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)
 
AddGapcloseEvent(_Q, 200, false)
