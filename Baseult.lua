if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

AutoUpdate("/D3ftsu/GoS/master/Baseult.lua","/D3ftsu/GoS/master/Baseult.version","Baseult.lua",1)

local BasePositions = {
     [SUMMONERS_RIFT] = {
	[100] = Vector(14340, 171, 14390),
	[200] = Vector(400, 200, 400)
     },

     [CRYSTAL_SCAR] = {
	[100] = Vector(13321, -37, 4163),
	[200] = Vector(527, -35, 4163)
     },
     
     [TWISTED_TREELINE] = {
	[100] = Vector(14320, 151, 7235),
	[200] = Vector(1060, 150, 7297)
     }
}

local Base = BasePositions[GetMapID()][GetTeam(myHero)]

local SpellData = {
        ["Ashe"] = {
	Delay = 250,
	MissileSpeed = 1600,
	Damage = function(target) return CalcDamage(myHero, target, 0, 75 + 175*GetCastLevel(myHero,_R) + GetBonusAP(myHero)) end
        },
        
        ["Draven"] = {
	Delay = 400,
	MissileSpeed = 2000,
	Damage = function(target) return CalcDamage(myHero, target, 75 + 100*GetCastLevel(myHero,_R) + 1.1*GetBonusDmg(myHero)) end
        },
        
        ["Ezreal"] = {
	Delay = 1000,
	MissileSpeed = 2000,
	Damage = function(target) return CalcDamage(myHero, target, 0, 200 + 150*GetCastLevel(myHero,_R) + .9*GetBonusAP(myHero)+GetBonusDmg(myHero)) end
        },
        
        ["Jinx"] = {
	Delay = 600,
        MissileSpeed = 1700
	Damage = function(target) return CalcDamage(myHero, target, math.max(50*GetCastLevel(myHero, _R)+75+GetBonusDmg(myHero)+(0.05*GetCastLevel(myHero, _R)+0.2)*(GetMaxHP(target)-GetCurrentHP(target)))) end
        } 
}

local BaseultMenu = MenuConfig("Baseult", "Baseult")
BaseultMenu:Boolean("RT", "RecallTracker", true)

if SpellData[GetObjectName(myHero)] then 
BaseultMenu:Boolean("Enabled", "Enabled", true)
PrintChat("Baseult for "..GetObjectName(myHero).." loaded") 
Delay = SpellData[GetObjectName(myHero)].Delay
MissileSpeed = SpellData[GetObjectName(myHero)].MissileSpeed
Damage = SpellData[GetObjectName(myHero)].Damage
end
	
local Isrecalling = {}

OnDraw(function()

if BaseultMenu.RT:Value() then
	local i = 0
	for Champ, recall in pairs(Isrecalling) do
	  local percent=math.floor(GetCurrentHP(recall.Champ)/GetMaxHP(recall.Champ)*100)
	  local leftTime = recall.starttime - GetTickCount() + recall.info.totalTime
	  if leftTime<0 then leftTime = 0 end
	  FillRect(400,500+18*i-2,168,18,0x50000000)
	  if i>0 then FillRect(400,500+18*i-2,168,1,0xC0000000) end
  	  DrawText(string.format("%s (%d%%)", Champ, percent), 14, 402, 500+18*i, percentToRGB(percent))
	    if recall.info.isStart then
	    DrawText(string.format("%.1fs", leftTime/1000), 14, 515, 500+18*i, percentToRGB(percent))
	    FillRect(569,500+18*i, 300*leftTime/recall.info.totalTime,14,0x80000000)
	    else
 	      if recall.killtime == nil then
	        if recall.info.isFinish and not recall.info.isStart then
		recall.result = "finished"
		recall.killtime =  GetTickCount()+2000
		elseif not recall.info.isFinish then
	 	recall.result = "cancelled"
	        recall.killtime =  GetTickCount()+2000
		end
              end
	      DrawText(recall.result, 14, 515, 500+18*i, percentToRGB(percent))
	    end
	    if recall.killtime~=nil and GetTickCount() > recall.killtime then
	    Isrecalling[Champ] = nil
	    end
	    i=i+1
	  end
        end

end)

OnProcessRecall(function(unit,recall)
	if GetTeam(myHero) ~= GetTeam(unit) then
	rec = {}
	rec.Champ = unit
	rec.info = recall
	rec.starttime = GetTickCount()
	rec.killtime = nil
	rec.result = nil
	Isrecalling[GetObjectName(unit)] = rec
		
	  if SpellData[GetObjectName(myHero)] then
	    if GetObjectName(myHero) == "Jinx" then
	    MissileSpeed = GetDistance(Base) > 1350 and (2295000 + (GetDistance(Base) - 1350) * 2200) / GetDistance(Base) or 1700
	    end
	    if IsReady(_R) and BaseultMenu.Enabled:Value() and Damage(unit) > GetCurrentHP(unit)+GetDmgShield(unit)+GetHPRegen(unit)*8 then
	      if (recall.totalTime-recall.passedTime) > Delay + (GetDistance(Base) * 1000 / MissileSpeed) then
	      DelayAction(function() CastSkillShot(_R,Base) end, (recall.totalTime-recall.passedTime)- (Delay + (GetDistance(Base) * 1000 / MissileSpeed)))
    	      end
	    end
          end
        end
end)

function percentToRGB(percent) 
	local r, g
    if percent == 100 then
        percent = 99 end
		
    if percent < 50 then
        r = math.floor(255 * (percent / 50))
        g = 255
    else
        r = 255
        g = math.floor(255 * ((50 - percent % 50) / 50))
    end
	
    return 0xFF000000+g*0xFFFF+r*0xFF
end
