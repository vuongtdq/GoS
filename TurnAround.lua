local Supported = {["Cassiopeia"], ["Tryndamere"]}

if not Supported[GetObjectName(enemy)] then return end

LastMove = 0
Move = false
lastRightClick = {x = nil, y = nil, z = nil}
lastPos = {x = nil, y = nil, z = nil}

PrintChat(" >> TurnAround Script loaded! <<")

OnTick(function(myHero)
  if Move = true and GetTickCount() - LastMove > 850 then
  MoveToXYZ(lastRightClick)
  Move = false
  end
  
  if lastRightClick.x ~= nil then
    if math.abs(player.x-lastRightClick.x) <= 75 and math.abs(player.z-lastRightClick.z) <= 75 then
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
      local DodgeThat = Vector(myHero)+(Vector(myHero)-Vector(spell)):normalize()*100
      MoveToXYZ(DodgeThat)
      if lastRightClick.x ~= nil then
      Move = true
      LastMove = GetTickCount()
      end
    end
	
    if spellName == "MockingShout" and GetDistance(spell) <= 850 then
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
