ChallengerBaseultVersion     = 0.03
ChallengerBaseultAutoUpdate  = true  -- Change this to false if you wish to disable auto updater

require('Inspired')

Callback.Add("Load", function()
  ChallengerBaseultUpdate()
  ChallengerBaseult()
end)

function ChallengerBaseultUpdate()
  if not ChallengerBaseultAutoUpdate then return end
  local ToUpdate = {}
  ToUpdate.UseHttps = true
  ToUpdate.Host = "raw.githubusercontent.com"
  ToUpdate.VersionPath = "/D3ftsu/GoS/master/ChallengerBaseult.version"
  ToUpdate.ScriptPath =  "/D3ftsu/GoS/master/ChallengerBaseult.lua"
  ToUpdate.SavePath = SCRIPT_PATH.."/ChallengerBaseult.lua"
  ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) PrintChat("<font color='#FFFF00'>Challenger Baseult - </font> <font color='#adec00'>Updated from v"..OldVersion.." to v"..NewVersion..". Please press F6 twice to reload.</font>") end
  ToUpdate.CallbackNoUpdate = function() end
  ToUpdate.CallbackNewVersion = function(NewVersion) PrintChat("<font color='#FFFF00'>Challenger Baseult - </font> <font color='#adec00'>New version found v"..NewVersion..". Please wait until it's downloaded.</font>") end
  ToUpdate.CallbackError = function(NewVersion) PrintChat("<font color='#FFFF00'>Challenger Baseult - </font> <font color='#adec00'>There was an error while updating, Try Again!.</font>") end
  ScriptUpdate(ChallengerBaseultVersion,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
end

class "ChallengerBaseult"

function ChallengerBaseult:__init()
  self.BasePositions = {
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

  self.enemySpawnPos = self.BasePositions[GetMapID()][GetTeam(myHero)]

  self.SpellData = {
    ["Ashe"] = {
      Delay = 0.25,
      MissileSpeed = 1600,
      Damage = function(target) return CalcDamage(myHero, target, 0, 75 + 175*GetCastLevel(myHero,_R) + GetBonusAP(myHero)) end
    },

    ["Draven"] = {
      Delay = 0.4,
      MissileSpeed = 2000,
      Damage = function(target) return CalcDamage(myHero, target, 75 + 100*GetCastLevel(myHero,_R) + 1.1*GetBonusDmg(myHero)) end
    },

    ["Ezreal"] = {
      Delay = 1,
      MissileSpeed = 2000,
      Damage = function(target) return CalcDamage(myHero, target, 0, 200 + 150*GetCastLevel(myHero,_R) + .9*GetBonusAP(myHero)+GetBonusDmg(myHero))*0.9 end
    },

    ["Jinx"] = {
      Delay = 0.6,
      MissileSpeed = 1700,
      Damage = function(target) return CalcDamage(myHero, target, math.max(50*GetCastLevel(myHero, _R)+75+GetBonusDmg(myHero)+(0.05*GetCastLevel(myHero, _R)+0.2)*(GetMaxHP(target)-GetCurrentHP(target)))) end
    }
  }

  if not self.SpellData[GetObjectName(myHero)] then return end
  PrintChat(string.format("<font color='#AAAAAA'>Challenger Baseult</font> <font color='#77FF77'> For "..GetObjectName(myHero).." Loaded, Have Fun ! </font>"))
  self.Recalling = {}
  self.BaseultMenu = MenuConfig("ChallengerBaseult", "Challenger Baseult")
  self.BaseultMenu:KeyBinding("Baseult", "Baseult", string.byte("H"), true, function() end, true)
  self.BaseultMenu:KeyBinding("PanicKey", "Do Not Use Ultimate in Fight", 32, false)
  PermaShow(self.BaseultMenu.Baseult)
  if GetObjectName(myHero) == "Jinx" or GetObjectName(myHero) == "Ashe" then
    self.BaseultMenu:Boolean("Collision", "Check for collision", true)
  elseif GetObjectName(myHero) == "Ezreal" or GetObjectName(myHero) == "Draven" then
    self.BaseultMenu:Boolean("Collision", "Check for collision", false)
  end
  self.Delay = self.SpellData[GetObjectName(myHero)].Delay
  self.MissileSpeed = self.SpellData[GetObjectName(myHero)].MissileSpeed
  self.Damage = self.SpellData[GetObjectName(myHero)].Damage
  Callback.Add("Tick", function() self:Tick() end)
  Callback.Add("ProcessRecall", function(unit,recall) self:ProcessRecall(unit,recall) end)
end

function ChallengerBaseult:Tick()
  if GetObjectName(myHero) == "Draven" then
    SpellReady = CanUseSpell(myHero, _R) == READY and GetCastName(myHero,_R) == "DravenRCast"
  else
    SpellReady = CanUseSpell(myHero, _R) == READY
  end
  if SpellReady then
    for i = 1, #self.Recalling do
      local dmg = self.Damage(self.Recalling[i].champ)
      if dmg >= GetCurrentHP(self.Recalling[i].champ) then
        local RemainingTime = self.Recalling[i].duration - (GetGameTimer() - self.Recalling[i].start) + GetLatency() / 2000
        local BaseDistance = GetDistance(self.enemySpawnPos)
        if GetObjectName(myHero) == "Jinx" then
          self.MissileSpeed = BaseDistance > 1350 and (2295000 + (BaseDistance - 1350) * 2200) / BaseDistance or 1700
        end
        local TimeToHit = self.Delay + BaseDistance / self.MissileSpeed + GetLatency() / 2000
        if RemainingTime < TimeToHit and TimeToHit < 7.8 and TimeToHit - RemainingTime < 1.5 and dmg >= GetCurrentHP(self.Recalling[i].champ) and self.BaseultMenu.Baseult:Value() and not self.BaseultMenu.PanicKey:Value() then
          if self.BaseultMenu.Collision:Value() then
            if self:Collision(self.Recalling[i].champ) == 0 then
              CastSkillShot(_R, self.enemySpawnPos)
            end
          else
            CastSkillShot(_R, self.enemySpawnPos)
          end
        end
      end
    end
  end
end

function ChallengerBaseult:ProcessRecall(unit,recall)
  if GetTeam(unit) ~= GetTeam(myHero) then 
    if recall.isStart == true then
      table.insert(self.Recalling, {champ = unit, start = GetGameTimer(), duration = (recall.totalTime/1000)})
    else
      for i = 1, #self.Recalling do
        if self.Recalling[i].champ == unit then
          table.remove(self.Recalling, i)
          return
        end
      end
    end
  end
end

function ChallengerBaseult:Collision(unit)
  local count = 0
  for i, enemy in pairs(GetEnemyHeroes()) do
    if enemy ~= nil and IsObjectAlive(enemy) and GetNetworkID(unit) ~= GetNetworkID(enemy) then
      local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), self.enemySpawnPos, GetOrigin(enemy))
      if isOnSegment and GetDistanceSqr(pointSegment, GetOrigin(enemy)) < (60+enemy.boundingRadius)^2 and GetDistanceSqr(GetOrigin(myHero), self.enemySpawnPos) > GetDistanceSqr(GetOrigin(myHero), GetOrigin(enemy)) then
        count = count + 1
      end
    end
  end
  return count
end

class "ScriptUpdate"
function ScriptUpdate:__init(LocalVersion,UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion,CallbackError)
  self.LocalVersion = LocalVersion
  self.Host = Host
  self.VersionPath = '/GOS/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
  self.ScriptPath = '/GOS/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
  self.SavePath = SavePath
  self.CallbackUpdate = CallbackUpdate
  self.CallbackNoUpdate = CallbackNoUpdate
  self.CallbackNewVersion = CallbackNewVersion
  self.CallbackError = CallbackError
  self:CreateSocket(self.VersionPath)
  self.DownloadStatus = 'Connecting to Server for VersionInfo'
  Callback.Add("Tick", function() self:GetOnlineVersion() end)
end

function ScriptUpdate:print(str)
  print('<font color="#FFFFFF">'..os.clock()..': '..str)
end

function DrawLines2(t,w,c)
  for i=1, #t-1 do
    DrawLine(t[i].x, t[i].y, t[i+1].x, t[i+1].y, w, c)
  end
end

function ScriptUpdate:CreateSocket(url)
  if not self.LuaSocket then
    self.LuaSocket = require("socket")
  else
    self.Socket:close()
    self.Socket = nil
    self.Size = nil
    self.RecvStarted = false
  end
  self.LuaSocket = require("socket")
  self.Socket = self.LuaSocket.tcp()
  self.Socket:settimeout(0, 'b')
  self.Socket:settimeout(99999999, 't')
  self.Socket:connect('gamingonsteroids.com', 80)
  self.Url = url
  self.Started = false
  self.LastPrint = ""
  self.File = ""
end

function ScriptUpdate:Base64Encode(data)
  local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  return ((data:gsub('.', function(x)
  local r,b='',x:byte()
  for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
  return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
  if (#x < 6) then return '' end
  local c=0
  for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
  return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end

function ScriptUpdate:Base64Decode(data)
  local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
  if (x == '=') then return '' end
  local r,f='',(b:find(x)-1)
  for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
  return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
  if (#x ~= 8) then return '' end
  local c=0
  for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
  return string.char(c)
  end))
end

function ScriptUpdate:GetOnlineVersion()
  if self.GotScriptVersion then return end

  self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
  if self.Status == 'timeout' and not self.Started then
    self.Started = true
    self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: plebleaks.com\r\n\r\n")
  end
  if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
    self.RecvStarted = true
    self.DownloadStatus = 'Downloading VersionInfo (0%)'
  end

  self.File = self.File .. (self.Receive or self.Snipped)
  if self.File:find('</s'..'ize>') then
    if not self.Size then
      self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
    end
    if self.File:find('<scr'..'ipt>') then
      local _,ScriptFind = self.File:find('<scr'..'ipt>')
      local ScriptEnd = self.File:find('</scr'..'ipt>')
      if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
      local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
      self.DownloadStatus = 'Downloading VersionInfo ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
    end
  end
  if self.File:find('</scr'..'ipt>') then
    self.DownloadStatus = 'Downloading VersionInfo (100%)'
    local a,b = self.File:find('\r\n\r\n')
    self.File = self.File:sub(a,-1)
    self.NewFile = ''
    for line,content in pairs(self.File:split('\n')) do
      if content:len() > 5 then
        self.NewFile = self.NewFile .. content
      end
    end
    local HeaderEnd, ContentStart = self.File:find('<scr'..'ipt>')
    local ContentEnd, _ = self.File:find('</sc'..'ript>')
    if not ContentStart or not ContentEnd then
      if self.CallbackError and type(self.CallbackError) == 'function' then
        self.CallbackError()
      end
    else
      self.OnlineVersion = (self:Base64Decode(self.File:sub(ContentStart + 1,ContentEnd-1)))
      self.OnlineVersion = tonumber(self.OnlineVersion)
      if self.OnlineVersion > self.LocalVersion then
        if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
          self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
        end
        self:CreateSocket(self.ScriptPath)
        self.DownloadStatus = 'Connect to Server for ScriptDownload'
        Callback.Add("Tick",function() self:DownloadUpdate() end)
      else
        if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
          self.CallbackNoUpdate(self.LocalVersion)
        end
      end
    end
    self.GotScriptVersion = true
  end
end

function ScriptUpdate:DownloadUpdate()
  if self.GotScriptUpdate then return end
  self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
  if self.Status == 'timeout' and not self.Started then
    self.Started = true
    self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: plebleaks.com\r\n\r\n")
  end
  if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
    self.RecvStarted = true
    self.DownloadStatus = 'Downloading Script (0%)'
  end

  self.File = self.File .. (self.Receive or self.Snipped)
  if self.File:find('</si'..'ze>') then
    if not self.Size then
      self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
    end
    if self.File:find('<scr'..'ipt>') then
      local _,ScriptFind = self.File:find('<scr'..'ipt>')
      local ScriptEnd = self.File:find('</scr'..'ipt>')
      if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
      local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
      self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
    end
  end
  if self.File:find('</scr'..'ipt>') then
    self.DownloadStatus = 'Downloading Script (100%)'
    local a,b = self.File:find('\r\n\r\n')
    self.File = self.File:sub(a,-1)
    self.NewFile = ''
    for line,content in pairs(self.File:split('\n')) do
      if content:len() > 5 then
        self.NewFile = self.NewFile .. content
      end
    end
    local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
    local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
    if not ContentStart or not ContentEnd then
      if self.CallbackError and type(self.CallbackError) == 'function' then
        self.CallbackError()
      end
    else
      local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
      local newf = newf:gsub('\r','')
      if newf:len() ~= self.Size then
        if self.CallbackError and type(self.CallbackError) == 'function' then
          self.CallbackError()
        end
        return
      end
      local newf = self:Base64Decode(newf)
      local f = io.open(self.SavePath,"w+b")
      f:write(newf)
      f:close()
      if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
        self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
      end
    end
    self.GotScriptUpdate = true
  end
end
