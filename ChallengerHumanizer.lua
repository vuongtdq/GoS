ChallengerHumanizerVersion     = "0.07"

require('Inspired')

Callback.Add("Load", function()
  GetWebResultAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerHumanizer.version", ChallengerHumanizerUpdaterino)
  ChallengerHumanizer()
end)

function ChallengerHumanizerUpdaterino(data)
  if tonumber(data) > tonumber(ChallengerHumanizerVersion) then
    PrintChat("New version found! " ..data "Downloading update, please wait...")
    DownloadFileAsync("https://raw.githubusercontent.com/D3ftsu/GoS/master/ChallengerHumanizer.lua", SCRIPT_PATH .. "ChallengerHumanizer.lua", function() PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> Updated from v"..tonumber(ChallengerHumanizerVersion).." to v"..tonumber(data)..". Please press F6 twice to reload.") return end)
  else
    PrintChat("<font color='#FFFF00'>Challenger Humanizer - </font> Loaded v" ..ChallengerHumanizerVersion)
  end
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
