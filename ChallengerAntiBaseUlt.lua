ChallengerAntiBaseUltVersion     = "0.01"

function ChallengerAntiBaseUltUpdaterino(data)
  if tonumber(data) > tonumber(ChallengerAntiBaseUltVersion) then
    PrintChat("<font color='#EE2EC'>Challenger AntiBaseUlt - </font> New version found! " ..tonumber(data).." Downloading update, please wait...")
    DownloadFileAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerAntiBaseUlt.lua", SCRIPT_PATH .. "ChallengerAntiBaseUlt.lua", function() PrintChat("<font color='#EE2EC'>Challenger AntiBaseUlt - </font> Updated from v"..tonumber(ChallengerAntiBaseUltVersion).." to v"..tonumber(data)..". Please press F6 twice to reload.") return end)
  end
end

class "ChallengerAntiBaseUlt"

function ChallengerAntiBaseUlt:__init()
  self.cfg = MenuConfig("AntiBaseUlt", "Anti-BaseUlt")
  self.cfg:Boolean("Enabled", "Enabled", true)
  self.cfg:Boolean("Debug", "Debug", true)
  self.SpellData = {
    ["Ashe"] = {
      MissileName = "EnchantedCrystalArrow",
      MissileSpeed = 1600,
    },

    ["Draven"] = {
      MissileName = "DravenDoubleShotMissile",
      MissileSpeed = 2000,
    },

    ["Ezreal"] = {
      MissileName = "EzrealTrueshotBarrage",
      MissileSpeed = 2000,
    },

    ["Jinx"] = {
      MissileName = "JinxR",
      MissileSpeed = 1700,
    }
  }
  self.missiles = {}
  self.RecallingTime = 0
  self.LastPrint = 0
  self.fountain = nil
  self.fountainRange = mapID == SUMMONERS_RIFT and 1050 or 750
  Callback.Add("ObjectLoad", function(Object) self:ObjectLoad(Object) end)
  Callback.Add("CreateObj", function(Object) self:CreateObj(Object) end)
  Callback.Add("ProcessRecall", function(unit, recall) self:ProcessRecall(unit, recall) end)
  Callback.Add("Tick", function() self:Tick() end)
end

function ChallengerAntiBaseUlt:ObjectLoad(Object)
  if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) == GetTeam(myHero) then
  	self.fountain = Object
  end
  if self.SpellData[GetObjectSpellOwner(Object)] and self.SpellData[GetObjectSpellOwner(Object)].MissileName == GetObjectSpellName(Object) and GetTeam(GetObjectSpellOwner(Object)) == MINION_ENEMY then
  	table.insert(self.missiles, Object)
  end
end

function ChallengerAntiBaseUlt:CreateObj(Object)
  DelayAction(function()
  if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) == GetTeam(myHero) then
  	self.fountain = Object
  end
  if self.SpellData[GetObjectSpellOwner(Object)] and self.SpellData[GetObjectSpellOwner(Object)].MissileName == GetObjectSpellName(Object) and GetTeam(GetObjectSpellOwner(Object)) == MINION_ENEMY then
  	table.insert(self.missiles, Object)
  end
  end, 0)
end

function ChallengerAntiBaseUlt:ProcessRecall(unit, recall)
  if unit == myHero and recall.isStart then
  	self.RecallingTime = GetTickCount() + recall.totalTime
  end
end

function ChallengerAntiBaseUlt:Tick()
  if not IsRecalling(myHero) or IsDead(myHero) then return end
  for i, missile in pairs(self.missiles) do
  	self:Debug("<font color='#EE2EC'>Challenger Anti-BaseUlt - </font> Baseult Missile Detected")
    if getdmg("R", GetObjectSpellOwner(missile), myHero, 3) < GetCurrentHP(myHero) then
      self:Debug("<font color='#EE2EC'>Challenger Anti-BaseUlt - </font> Not Enough Damage From "..GetObjectName(GetObjectSpellOwner(missile))"'s' Baseult")
      return
    end
    if not self:InFountain(GetObjectSpellEndPos(missile)) then
      self:Debug("<font color='#EE2EC'>Challenger Anti-BaseUlt - </font> Missile Detected Is Not A Baseult")
      return
    end
    local TimeToHit = GetDistance(missile, self.fountain) / self.SpellData[GetObjectSpellOwner(missile)].MissileSpeed * 1000
    if self.RecallingTime < TimeToHit then
      self:Debug("<font color='#EE2EC'>Challenger Anti-BaseUlt - </font> Baseult Not Correctly Timed")
      return
    end
    MoveToXYZ(myHero.x+1,myHero.y, myHero.z+1)
    if GetTickCount()-self.LastPrint > 1000 then
      PrintChat("<font color='#EE2EC'>Challenger Anti-BaseUlt - </font> Prevented A Baseult From "..GetObjectName(GetObjectSpellOwner(missile))" ")
      self.LastPrint = GetTickCount()
    end
  end
end

function ChallengerAntiBaseUlt:InFountain(pos)
  return GetDistance(self.fountain, pos) < self.fountainRange
end

function ChallengerAntiBaseUlt:Debug(string)
  return self.cfg.Debug:Value() and print(string) or nil
end

GetWebResultAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerAntiBaseUlt.version", ChallengerAntiBaseUltUpdaterino)
PrintChat("<font color='#EE2EC'>Challenger Anti-BaseUlt - </font> Loaded v" ..ChallengerAntiBaseUltVersion)
ChallengerAntiBaseUlt()
