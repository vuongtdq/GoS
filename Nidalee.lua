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

NidaleeMenu:Menu("Misc", "Misc")
--if Ignite ~= nil then NidaleeMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
--NidaleeMenu.Misc:Boolean("Autolvl", "Auto level", true)
--NidaleeMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-E-W", "Q-W-E", "E-Q-W"})
NidaleeMenu.Misc:KeyBinding("Flee", "Flee", string.byte("T"))
NidaleeMenu.Misc:KeyBinding("WallJump", "WallJump", string.byte("G"))

NidaleeMenu:Menu("Drawings", "Drawings")
NidaleeMenu.Drawings:Boolean("Q", "Draw Q Range", true)
NidaleeMenu.Drawings:Boolean("W", "Draw W Range + Radius", true)
NidaleeMenu.Drawings:Boolean("E", "Draw E Range", true)

OnDraw(function(myHero)
  if IsHuman() then
    if NidaleeMenu.Drawings.Q:Value() then DrawCircle(GetOrigin(myHero),1450,2,100,ARGB(255,255,255,255)) end
    if NidaleeMenu.Drawings.W:Value() then DrawCircle(GetOrigin(myHero),900,2,100,ARGB(255,255,255,255)) end
    if NidaleeMenu.Drawings.E:Value() then DrawCircle(GetOrigin(myHero),650,2,100,ARGB(255,255,255,255)) end
  else
    if NidaleeMenu.Drawings.Q:Value() then DrawCircle(GetOrigin(myHero),GetRange(myHero)+GetHitBox(myHero),2,100,ARGB(255,255,255,255)) end
    if NidaleeMenu.Drawings.W:Value() then
    DrawCircle(mousePos,400,2,100,MapPosition:inWall(mousePos) and ARGB(255,255,0,0) or ARGB(255, 155, 155, 155))
    DrawCircle(mousePos,133,2,100,MapPosition:inWall(mousePos) and ARGB(255,255,0,0) or ARGB(255, 155, 155, 155))
    end
    if NidaleeMenu.Drawings.E:Value() then DrawCircle(GetOrigin(myHero),375,2,100,ARGB(255,255,255,255)) end
  end
end)

local QCD = 0
local lastlevel = GetLevel(myHero)-1
  
OnTick(function(myHero)
    local target = GetCurrentTarget()
    mousePos = GetMousePos()
	
    if IOW:Mode() == "Combo" then
	
      if IsReady(_R) and IsHunted(target) and IsHuman() and ValidTarget(target,800) and NidaleeMenu.Combo.R:Value() then
      CastSpell(_R)
      end
	
      if IsReady(_W) and IsHunted(target) and not IsHuman() and ValidTarget(target,800) and NidaleeMenu.Combo.W:Value() then
      Cast(_W,target)
      end
	
      if not IsHuman() and ValidTarget(target,375) then
        if IsReady(_E) and NidaleeMenu.Combo.E:Value() then
        CastSkillShot(_E,GetOrigin(target))
        elseif IsReady(_Q) and NidaleeMenu.Combo.Q:Value() then
        CastSpell(_Q)
        end
      end
	
      if IsReady(_W) and NidaleeMenu.Combo.W:Value() and ValidTarget(target,575) then
        if GetDistance(target) >= 225 then
        Cast(_W,target)
        end
      end

      if IsReady(_Q) and IsHuman() and NidaleeMenu.Combo.Q:Value() and ValidTarget(target,1450) then
      Cast(_Q,target)
      end
	
      if IsReady(_W) and IsHunted(target) and IsHuman() and NidaleeMenu.Combo.W:Value() and ValidTarget(target,900) then
      Cast(_W,target)
      end

      if not IsHuman() and ValidTarget(target) and GetDistance(target) > 425 then
      CastSpell(_R)
      end
	
      if not IsHuman() and QCD < GetTickCount() then
      CastSpell(_R)
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
	
    if NidaleeMenu.Misc.WallJump:Value() then
      local movePos1 = GetOrigin(myHero) + (Vector(mousePos) - GetOrigin(myHero)):normalized() * 150
      local movePos2 = GetOrigin(myHero) + (Vector(mousePos) - GetOrigin(myHero)):normalized() * 350
      if MapPosition:inWall(movePos1) and MapPosition:inWall(movePos2) == false then
      CastSkillShot(_W, movePos2)
      else
      MoveToXYZ(mousePos)
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

function IsHunted(unit)
   return (hunted[GetNetworkID(unit)] or 0) > 0
end

function IsHuman()
    return GetCastName(myHero,_Q) == "JavelinToss"
end
