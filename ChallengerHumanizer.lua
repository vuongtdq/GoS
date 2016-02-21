ChallengerHumanizerVersion     = 0.04
ChallengerHumanizerAutoUpdate  = true  -- Change this to false if you wish to disable auto updater

require('Inspired')

Callback.Add("Load", function()
  ChallengerHumanizerUpdate()
  ChallengerHumanizer()
end)

function ChallengerHumanizerUpdate()
  if not ChallengerHumanizerAutoUpdate then return end
  local ToUpdate = {}
  ToUpdate.UseHttps = true
  ToUpdate.Host = "raw.githubusercontent.com"
  ToUpdate.VersionPath = "/D3ftsu/GoS/master/ChallengerHumanizer.version"
  ToUpdate.ScriptPath =  "/D3ftsu/GoS/master/ChallengerHumanizer.lua"
  ToUpdate.SavePath = SCRIPT_PATH.."/ChallengerHumanizer.lua"
  ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> <font color='#adec00'>Updated from v"..OldVersion.." to v"..NewVersion..". Please press F6 twice to reload.</font>") end
  ToUpdate.CallbackNoUpdate = function() end
  ToUpdate.CallbackNewVersion = function(NewVersion) PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> <font color='#adec00'>New version found v"..NewVersion..". Please wait until it's downloaded.</font>") end
  ToUpdate.CallbackError = function(NewVersion) PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> <font color='#adec00'>There was an error while updating, Try Again!.</font>") end
  ScriptUpdate(ChallengerHumanizerVersion,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
end

class "ChallengerHumanizer"

function ChallengerHumanizer:__init()
  self.MovementHumanizerTick = 0
  self.LastMove = 0
  self.PassedMovements = 0
  self.BlockedMovements = 0
  self.TotalMovements = 0
  self:Load()
  Callback.Add("IssueOrder", function(order) self:IssueOrder(order) end)
  Callback.Add("Draw", function() self:Draw() end)
end

function ChallengerHumanizer:Load()
  self.ChallengerHumanizerMenu = MenuConfig("ChallengerHumanizer","Challenger Humanizer")
  self.ChallengerHumanizerMenu:Boolean("EnabledMH", "Enable Movement Humanizer", true)
  self.ChallengerHumanizerMenu:Boolean("Draw", "Draw Stats", true)
  self.ChallengerHumanizerMenu:Slider("MaxM", "Max Movements Per Second", 4, 4, 30, 1, function(max) self.MovementHumanizerTick = (1000 / (max + math.random(-1, 2))) end)
  self.MovementHumanizerTick = (1000 / (self.ChallengerHumanizerMenu.MaxM:Value() + math.random(-1, 2)))
end

function ChallengerHumanizer:IssueOrder(order)
  if order.flag == 2 and self:Orbwalking() and self.ChallengerHumanizerMenu.EnabledMH:Value() and not _G.evade then
    if self.MovementHumanizerTick >= (GetTickCount() - self.LastMove) then
      BlockOrder()
      self.BlockedMovements = self.BlockedMovements + 1
    else
      self.LastMove = GetTickCount()
      self.PassedMovements = self.PassedMovements + 1
    end
    self.TotalMovements = self.TotalMovements + 1
  end
end

function ChallengerHumanizer:Draw()
  if not self.ChallengerHumanizerMenu.Draw:Value() then return end
  DrawText("Passed Movements : "..tostring(self.PassedMovements),20,40,280,ARGB(255,0,255,255))
  DrawText("Blocked Movements : "..tostring(self.BlockedMovements),20,40,300,ARGB(255,0,255,255))
  DrawText("Total Movements : "..tostring(self.TotalMovements),20,40,320,ARGB(255,0,255,255))
end

function ChallengerHumanizer:Orbwalking()
  return IOW:Mode() == "Combo" or IOW:Mode() == "Harass" or IOW:Mode() == "LaneClear" or IOW:Mode() == "LastHit"
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
  self.Socket:connect('plebleaks.com', 80)
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
