require('Inspired')

local unittraveled = 0
local MissTimer = {}
local MissSec = {}
local ticks = {}
 
OnTick(function(myHero)
        for i,enemy in pairs(GetEnemyHeroes()) do
                if IsVisible(enemy) == false and IsDead(enemy) == false then
                        if ticks[i] == nil then
                        ticks[i] = GetTickCount()
                        end
                        MissTimer[i] = GetTickCount() - ticks[i]                  
                        MissSec[i] =  MissTimer[i]/1000
                else
                        ticks[i] = nil
                        MissTimer[i] = nil
                        MissSec[i] = 0
                end
        end
end)

OnDrawMinimap(function() 
    for i,enemy in pairs(GetEnemyHeroes()) do
        if enemy ~= nil and not IsDead(enemy) and IsVisible(enemy) == false then
          if MissSec[i] == nil then
          MissSec[i] = 0
          end
          unittraveled = GetMoveSpeed(enemy)*MissSec[i]
          if unittraveled > 50 and unittraveled < 7000 then
          DrawCircleMinimap(GetOrigin(enemy), unittraveled,1,100,ARGB(50,255,0,255))
          end
        end
    end
end)
