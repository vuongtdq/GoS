local Supported = {["Cassiopeia"] = true, ["Tryndamere"] = true}

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

DelayAction(function()
  for _,k in pairs(GetEnemyHeroes()) do
  if not Supported[GetObjectName(k)] then return end
  end
end, 1)

LastMove = 0
Move = false
lastRightClick = {x = nil, y = nil, z = nil}
lastPos = {x = nil, y = nil, z = nil}

PrintChat(" >> TurnAround Script loaded! <<")

OnTick(function(myHero)
  if Move = true and GetTickCount() - LastMove > 850 then
  IOW.movementEnabled == true
  MoveToXYZ(lastRightClick)
  Move = false
  end
  
  if lastRightClick.x ~= nil then
    if math.abs(GetOrigin(myHero).x-lastRightClick.x) <= 75 and math.abs(GetOrigin(myHero).y-lastRightClick.y) <= 75 and math.abs(GetOrigin(myHero).z-lastRightClick.z) <= 75 then
    lastRightClick.x = nil
    lastRightClick.y = nil
    lastRightClick.z = nil
    end
    if lastPos.x ~= nil and lastPos.x == GetOrigin(myHero).x and lastPos.y == GetOrigin(myHero).y and lastPos.z == GetOrigin(myHero).z then
    lastRightClick.x = nil
    lastRightClick.y = nil
    lastRightClick.z = nil
    end
	
    lastPos.x = GetOrigin(myHero).x
    lastPos.y = GetOrigin(myHero).y
    lastPos.y = GetOrigin(myHero).z
  end
end)
  
OnProcessSpell(function(unit,spell)
  if GetTeam(unit) ~= GetTeam(myHero) then 
  
    if spell.name == "CassiopeiaPetrifyingGaze" and GetDistance(spell) <= 750 then 
      IOW.movementEnabled = false
      local DodgeThat = Vector(myHero)+(Vector(myHero)-Vector(spell)):normalize()*100
      MoveToXYZ(DodgeThat)
      if lastRightClick.x ~= nil then
      Move = true
      LastMove = GetTickCount()
      end
    end
	
    if spell.name == "MockingShout" and GetDistance(spell) <= 850 then
      IOW.movementEnabled = false
      local DodgeThat = Vector(myHero)+(Vector(myHero)-Vector(spell)):normalize()*(-100)
      MoveToXYZ(DodgeThat)
      if lastRightClick.x ~= nil then
      Move = true
      LastMove = GetTickCount()
      end
    end
	
   end
end)    

OnWndMsg(function(msg,wParam)
  if msg == WM_RBUTTONDOWN then
  local mousePos = GetMousePos()
  lastRightClick = {x = mousePos.x, y = mousePos.y, z = mousePos.z}
  end
end)
