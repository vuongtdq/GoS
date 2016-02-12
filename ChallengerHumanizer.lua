require('Inspired')

Callback.Add("Load", function()
  ChallengerHumanizer()
end)

class "ChallengerHumanizer"

function ChallengerHumanizer:__init()
  self.HumanizerTick = 0
  self.LastMove = 0
  self.PassedMovements = 0
  self.BlockedMovements = 0
  self.TotalMovements = 0
  self.BanChance = 0
  self:Load()
  Callback.Add("IssueOrder", function(order) self:IssueOrder(order) end)
  Callback.Add("Draw", function() self:Draw() end)
end

function ChallengerHumanizer:Load()
  self.ChallengerHumanizerMenu = MenuConfig("ChallengerHumanizer","Challenger Humanizer")
  self.ChallengerHumanizerMenu:Boolean("Enabled", "Enable Movement Humanizer", true)
  self.ChallengerHumanizerMenu:Boolean("Draw", "Draw Stats", true)
  self.ChallengerHumanizerMenu:Slider("Max", "Max Movements Per Second", 7, 4, 30, 1, function(max) self.HumanizerTick = (1000 / (max + math.random(-1, 2))) end)
  self.HumanizerTick = (1000 / (self.ChallengerHumanizerMenu.Max:Value() + math.random(-1, 2)))
end

function ChallengerHumanizer:IssueOrder(order)
  if order.flag == 2 and self:Orbwalking() and self.ChallengerHumanizerMenu.Enabled:Value() and not _G.evade then
    if self.HumanizerTick >= (GetTickCount() - self.LastMove) then
      BlockOrder()
      self.BlockedMovements = self.BlockedMovements + 1
    else
      self.LastMove = GetTickCount()
      self.PassedMovements = self.PassedMovements + 1
    end
    self.TotalMovements = self.TotalMovements + 1
    self.BanChance = ((self.BlockedMovements*100)/self.TotalMovements)
  end
end

function ChallengerHumanizer:Draw()
  if not self.ChallengerHumanizerMenu.Draw:Value() then return end
  DrawText("Reduced Ban Chance : " .. tostring(math.ceil(self.BanChance)) .. "%",20,40,260,ARGB(255,0,255,255))
  DrawText("Passed Movements : "..tostring(self.PassedMovements),20,40,280,ARGB(255,0,255,255))
  DrawText("Blocked Movements : "..tostring(self.BlockedMovements),20,40,300,ARGB(255,0,255,255))
  DrawText("Total Movements : "..tostring(self.TotalMovements),20,40,320,ARGB(255,0,255,255))
end

function ChallengerHumanizer:Orbwalking()
  return IOW:Mode() == "Combo" or IOW:Mode() == "Harass" or IOW:Mode() == "LaneClear" or IOW:Mode() == "LastHit"
end
