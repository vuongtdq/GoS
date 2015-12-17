require('Inspired_New')
DAIOVersion     = 1.01
DAIOLoaded      = true
DAIOAutoUpdate  = true  -- Change this to false if you wish to disable auto updater
_Q, _W, _E, _R  = 0, 1, 2, 3
DAIOMenu = MenuConfig("D3CarryAIO","DAIO")

function OnLoad()
  PrintChat(tostring("<font color='#D859CD'> D3CarryAIO - </font><font color='#adec00'> Please wait... </font>"))
  Update()
  LoadSpellData()
  LoadDamageLib()
  LoadIOW()
  LoadChampion()
  Init()
  PrintChat("<font color='#D859CD'> D3CarryAIO - </font> <font color='#adec00'> Successfully loaded V " .. DAIOVersion .. ", good luck!</font>")
end

function Update()
  if not DAIOAutoUpdate then return end
  local ToUpdate = {}
  ToUpdate.UseHttps = true
  ToUpdate.Host = "raw.githubusercontent.com"
  ToUpdate.ScriptPath =  "/D3ftsu/GoS/master/DAIO.lua"
  ToUpdate.VersionPath = "/D3ftsu/GoS/master/DAIO.version"
  ToUpdate.SavePath = SCRIPT_PATH.."/DAIO.lua"
  ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) Msg("Updated from v "..OldVersion.." to "..NewVersion..". Please press F6 twice to reload.") end
  ToUpdate.CallbackNoUpdate = function(OldVersion) end
  ToUpdate.CallbackNewVersion = function(NewVersion) Msg("New version found v "..NewVersion..". Please wait until it's downloaded.") end
  ToUpdate.CallbackError = function(NewVersion) Msg("There was an error while updating.") end
  ScriptUpdate(ScriptologyVersion,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
end

function LoadSpellData()
  if FileExist(COMMON_PATH  .. "SpellData.lua") then
    if pcall(function() spellData = loadfile(COMMON_PATH  .. "SpellData.lua")() end) then
      mySpellData = spellData[myHero.charName]
      DelayAction(function()
      ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/DAIO.version", "/D3ftsu/GoS/master/Common/SpellData.lua", COMMON_PATH .."SpellData.lua", function() end, function() end, function() end, LoadSpellData)
      end, 5000)
    else
      ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/DAIO.version", "/D3ftsu/GoS/master/Common/SpellData.lua", COMMON_PATH .."SpellData.lua", LoadSpellData, function() end, function() end, LoadSpellData)
    end
  else
      ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/DAIO.version", "/D3ftsu/GoS/master/Common/SpellData.lua", COMMON_PATH .."SpellData.lua", LoadSpellData, function() end, function() end, LoadSpellData)
  end
end

function LoadDamageLib()
  if FileExist(COMMON_PATH  .. "DamageLib.lua") then
    if not pcall( require, "DamageLib" ) then
      DelayAction(function()
      ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/Common/DamageLib.version", "/D3ftsu/GoS/master/Common/DamageLib.lua", COMMON_PATH .."DamageLib.lua", function() end, function() end, function() end, LoadDamageLib)
      end, 5000)
    else
      ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/Common/DamageLib.version", "/D3ftsu/GoS/master/Common/DamageLib.lua", COMMON_PATH .."DamageLib.lua", LoadDamageLib, function() end, function() end, LoadDamageLib)
    end
  else
      ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/Common/DamageLib.version", "/D3ftsu/GoS/master/Common/DamageLib.lua", COMMON_PATH .."DamageLib.lua", LoadDamageLib, function() end, function() end, LoadDamageLib)
  end
end

function LoadChampion()
  if _G[myHero.charName] then
  SupportedChamp = _G[myHero.charName]()
  end
end

function Init()
  if not SupportedChamp then return end
  SetupPrediction()
  SetupTargetSelector()
  SetupMenu()
  SetupVars()
  SetupPlugin()
end

function SetupPrediction()
  DAIOMenu:Menu("Prediction", "Prediction")
  DAIOMenu.Prediction:DropDown("Pred", "Choose Prediction : ", 1, {"GoS", "IPrediction"})
end

function SetupTargetSelector()
  CustomTS = TargetSelector(function()
  local r = 0
    for i=0,3 do
      if mySpellData[i] and (mySpellData[i].dmgAP or mySpellData[i].dmgAD or mySpellData[i].dmgTRUE) then
        if mySpellData[i].range and mySpellData[i].range > 0 then
          if mySpellData[i].range > r and mySpellData[i].range < 2000 then
            r = mySpellData[i].range
          end
        elseif mySpellData[i].width and mySpellData[i].width > 0 then
          if mySpellData[i].width > r then
            r = mySpellData[i].width
          end
        end
      end
    end
  return r
  end
  ,TARGET_LESS_CAST,ad[myHero.charName] or mixed[myHero.charName] and DAMAGE_PHYSICAL or DAMAGE_MAGIC,true)
  DAIOMenu:Menu("ts","Target Selector")
  DAIOMenu.ts:TargetSelector(CustomTS)
  UpdateTS()
end

function SetupMenu()
  DAIOMenu:Menu(myHero.charName,myHero.charName)
  MainMenu = DAIOMenu[myHero.charName]
  MainMenu:Menu("Combo","Combo")
  MainMenu:Menu("Harass","Harass")
  MainMenu:Menu("LastHit","LastHit")
  MainMenu:Menu("LaneClear","LaneClear")
  MainMenu.LaneClear:Boolean("J", "Attack Jungle", true)
  MainMenu:Menu("Killsteal","Killsteal")
  MainMenu:Menu("Misc","Misc")
  MainMenu:Menu("Drawings","Drawings")
  MainMenu.Drawings:Boolean("Q", "Draw Q", true)
  MainMenu.Drawings:Boolean("W", "Draw W", true)
  MainMenu.Drawings:Boolean("E", "Draw E", true)
  MainMenu.Drawings:Boolean("R", "Draw R", true)
  MainMenu.Drawings:Boolean("DMG", "Draw DMG", true)
  MainMenu.Drawings:ColorPick("ColorQ", "Color Q", {255, 155, 255, 155})
  MainMenu.Drawings:ColorPick("ColorW", "Color W", {255, 55, 155, 255})
  MainMenu.Drawings:ColorPick("ColorE", "Color E", {255, 255, 155, 155})
  MainMenu.Drawings:ColorPick("ColorR", "Color R", {255, 155, 55, 55})
  MainMenu:Menu("KeySettings","Key Settings")
end

function SetupVars()

  StacksTable = {}
  StacksTrackList = { ["Darius"] = "dariushemo", ["Kalista"] = "kalistaexpungemarker", ["TahmKench"] = "tahmpassive", ["Tristana"] = "tristanaecharge", ["Twitch"] = "twitchdeadlyvenom", ["Vayne"] = "vaynesilvereddebuff" }
  if StacksTrackList[myHero.charName] then
    TrackableBuffs = StacksTrackList[myHero.charName]
  end
  
  killTable = {}
  for i, enemy in pairs(GetEnemyHeroes()) do
    killTable[enemy.networkID] = {0, 0, 0, 0, 0, 0}
  end
  
  killDrawTable = {}
  for i, enemy in pairs(GetEnemyHeroes()) do
    killDrawTable[enemy.networkID] = {}
  end
  
  colors = { 0xDFFFE258, 0xDF8866F4, 0xDF55F855, 0xDFFF5858 }
	  
  CHANELLING_SPELLS = {
    ["CaitlynAceintheHole"]         = {Name = "Caitlyn",      Spellslot = _R},
    ["Crowstorm"]                   = {Name = "FiddleSticks", Spellslot = _R},
    ["Drain"]                       = {Name = "FiddleSticks", Spellslot = _W},
    ["GalioIdolOfDurand"]           = {Name = "Galio",        Spellslot = _R},
    ["ReapTheWhirlwind"]            = {Name = "Janna",        Spellslot = _R},
    ["KarthusFallenOne"]            = {Name = "Karthus",      Spellslot = _R},
    ["KatarinaR"]                   = {Name = "Katarina",     Spellslot = _R},
    ["LucianR"]                     = {Name = "Lucian",       Spellslot = _R},
    ["AlZaharNetherGrasp"]          = {Name = "Malzahar",     Spellslot = _R},
    ["MissFortuneBulletTime"]       = {Name = "MissFortune",  Spellslot = _R},
    ["AbsoluteZero"]                = {Name = "Nunu",         Spellslot = _R},                        
    ["PantheonRJump"]               = {Name = "Pantheon",     Spellslot = _R},
    ["PantheonRFall"]               = {Name = "Pantheon",     Spellslot = _R},
    ["ShenStandUnited"]             = {Name = "Shen",         Spellslot = _R},
    ["Destiny"]                     = {Name = "TwistedFate",  Spellslot = _R},
    ["UrgotSwap2"]                  = {Name = "Urgot",        Spellslot = _R},
    ["VarusQ"]                      = {Name = "Varus",        Spellslot = _Q},
    ["VelkozR"]                     = {Name = "Velkoz",       Spellslot = _R},
    ["InfiniteDuress"]              = {Name = "Warwick",      Spellslot = _R},
    ["XerathLocusOfPower2"]         = {Name = "Xerath",       Spellslot = _R}
    
  }

  GAPCLOSER_SPELLS = {
    ["AkaliShadowDance"]            = {Name = "Akali",      Spellslot = _R},
    ["Headbutt"]                    = {Name = "Alistar",    Spellslot = _W},
    ["DianaTeleport"]               = {Name = "Diana",      Spellslot = _R},
    ["FizzPiercingStrike"]          = {Name = "Fizz",       Spellslot = _Q},
    ["IreliaGatotsu"]               = {Name = "Irelia",     Spellslot = _Q},
    ["JaxLeapStrike"]               = {Name = "Jax",        Spellslot = _Q},
    ["JayceToTheSkies"]             = {Name = "Jayce",      Spellslot = _Q},
    ["blindmonkqtwo"]               = {Name = "LeeSin",     Spellslot = _Q},
    ["MaokaiUnstableGrowth"]        = {Name = "Maokai",     Spellslot = _W},
    ["MonkeyKingNimbus"]            = {Name = "MonkeyKing", Spellslot = _E},
    ["Pantheon_LeapBash"]           = {Name = "Pantheon",   Spellslot = _W},
    ["PoppyHeroicCharge"]           = {Name = "Poppy",      Spellslot = _E},
    ["QuinnE"]                      = {Name = "Quinn",      Spellslot = _E},
    ["RengarLeap"]                  = {Name = "Rengar",     Spellslot = _R},
    ["XenZhaoSweep"]                = {Name = "XinZhao",    Spellslot = _E}
  }

  GAPCLOSER2_SPELLS = {
    ["AatroxQ"]                     = {Name = "Aatrox",     Range = 1000, ProjectileSpeed = 1200, Spellslot = _Q},
    ["GragasE"]                     = {Name = "Gragas",     Range = 600,  ProjectileSpeed = 2000, Spellslot = _E},
    ["GravesMove"]                  = {Name = "Graves",     Range = 425,  ProjectileSpeed = 2000, Spellslot = _E},
    ["HecarimUlt"]                  = {Name = "Hecarim",    Range = 1000, ProjectileSpeed = 1200, Spellslot = _R},
    ["JarvanIVDragonStrike"]        = {Name = "JarvanIV",   Range = 770,  ProjectileSpeed = 2000, Spellslot = _Q},
    ["JarvanIVCataclysm"]           = {Name = "JarvanIV",   Range = 650,  ProjectileSpeed = 2000, Spellslot = _R},
    ["KhazixE"]                     = {Name = "Khazix",     Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
    ["khazixelong"]                 = {Name = "Khazix",     Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
    ["LeblancSlide"]                = {Name = "Leblanc",    Range = 600,  ProjectileSpeed = 2000, Spellslot = _W},
    ["LeblancSlideM"]               = {Name = "Leblanc",    Range = 600,  ProjectileSpeed = 2000, Spellslot = _R},
    ["LeonaZenithBlade"]            = {Name = "Leona",      Range = 900,  ProjectileSpeed = 2000, Spellslot = _E},
    ["UFSlash"]                     = {Name = "Malphite",   Range = 1000, ProjectileSpeed = 1800, Spellslot = _R},
    ["RenektonSliceAndDice"]        = {Name = "Renekton",   Range = 450,  ProjectileSpeed = 2000, Spellslot = _E},
    ["SejuaniArcticAssault"]        = {Name = "Sejuani",    Range = 650,  ProjectileSpeed = 2000, Spellslot = _Q},
    ["ShenShadowDash"]              = {Name = "Shen",       Range = 575,  ProjectileSpeed = 2000, Spellslot = _E},
    ["RocketJump"]                  = {Name = "Tristana",   Range = 900,  ProjectileSpeed = 2000, Spellslot = _W},
    ["slashCast"]                   = {Name = "Tryndamere", Range = 650,  ProjectileSpeed = 1450, Spellslot = _E}
  }

  DANGEROUS_SPELLS = {
	["Akali"]      = {Spellslot = _R},
	["Alistar"]    = {Spellslot = _W},
	["Amumu"]      = {Spellslot = _R},
	["Annie"]      = {Spellslot = _R},
	["Ashe"]       = {Spellslot = _R},
	["Akali"]      = {Spellslot = _R},
	["Brand"]      = {Spellslot = _R},
	["Braum"]      = {Spellslot = _R},
	["Caitlyn"]    = {Spellslot = _R},
	["Cassiopeia"] = {Spellslot = _R},
	["Chogath"]    = {Spellslot = _R},
	["Darius"]     = {Spellslot = _R},
	["Diana"]      = {Spellslot = _R},
	["Draven"]     = {Spellslot = _R},
	["Ekko"]       = {Spellslot = _R},
	["Evelynn"]    = {Spellslot = _R},
	["Fiora"]      = {Spellslot = _R},
	["Fizz"]       = {Spellslot = _R},
	["Galio"]      = {Spellslot = _R},
	["Garen"]      = {Spellslot = _R},
	["Gnar"]       = {Spellslot = _R},
	["Graves"]     = {Spellslot = _R},
	["Hecarim"]    = {Spellslot = _R},
	["JarvanIV"]   = {Spellslot = _R},
	["Jinx"]       = {Spellslot = _R},
	["Katarina"]   = {Spellslot = _R},
	["Kennen"]     = {Spellslot = _R},
	["LeBlanc"]    = {Spellslot = _R},
	["LeeSin"]     = {Spellslot = _R},
	["Leona"]      = {Spellslot = _R},
	["Lissandra"]  = {Spellslot = _R},
	["Lux"]        = {Spellslot = _R},
	["Malphite"]   = {Spellslot = _R},
	["Malzahar"]   = {Spellslot = _R},
	["Morgana"]    = {Spellslot = _R},
	["Nautilus"]   = {Spellslot = _R},
	["Nocturne"]   = {Spellslot = _R},
	["Orianna"]    = {Spellslot = _R},
	["Rammus"]     = {Spellslot = _E},
	["Riven"]      = {Spellslot = _R},
	["Sejuani"]    = {Spellslot = _R},
	["Shen"]       = {Spellslot = _E},
	["Skarner"]    = {Spellslot = _R},
	["Sona"]       = {Spellslot = _R},
	["Syndra"]     = {Spellslot = _R},
	["Tristana"]   = {Spellslot = _R},
	["Urgot"]      = {Spellslot = _R},
	["Varus"]      = {Spellslot = _R},
	["Veigar"]     = {Spellslot = _R},
	["Vi"]         = {Spellslot = _R},
	["Viktor"]     = {Spellslot = _R},
	["Warwick"]    = {Spellslot = _R},
	["Yasuo"]      = {Spellslot = _R},
	["Zed"]        = {Spellslot = _R},
	["Ziggs"]      = {Spellslot = _R},
	["Zyra"]       = {Spellslot = _R},
  }

  Dashes = {
        ["Vayne"]      = {Spellslot = _Q, Range = 300, Delay = 0.25},
        ["Riven"]      = {Spellslot = _E, Range = 325, Delay = 0.25},
        ["Ezreal"]     = {Spellslot = _E, Range = 450, Delay = 0.25},
        ["Caitlyn"]    = {Spellslot = _E, Range = 400, Delay = 0.25},
        ["Kassadin"]   = {Spellslot = _R, Range = 700, Delay = 0.25},
        ["Graves"]     = {Spellslot = _E, Range = 425, Delay = 0.25},
        ["Renekton"]   = {Spellslot = _E, Range = 450, Delay = 0.25},
        ["Aatrox"]     = {Spellslot = _Q, Range = 650, Delay = 0.25},
        ["Gragas"]     = {Spellslot = _E, Range = 600, delay = 0.25},
        ["Khazix"]     = {Spellslot = _E, Range = 600, Delay = 0.25},
        ["Lucian"]     = {Spellslot = _E, Range = 425, Delay = 0.25},
        ["Sejuani"]    = {Spellslot = _Q, Range = 650, Delay = 0.25},
        ["Shen"]       = {Spellslot = _E, Range = 575, Delay = 0.25},
        ["Tryndamere"] = {Spellslot = _E, Range = 660, Delay = 0.25},
        ["Tristana"]   = {Spellslot = _W, Range = 900, Delay = 0.25},
        ["Corki"]      = {Spellslot = _W, Range = 800, Delay = 0.25},
  }
end

function SetupPlugin()
  tickTable = { function() Target = DAIOMenu.ts:GetTarget() end }
  
  if SupportedChamp.Combo then
    table.insert(tickTable, function()
      if IOW:Mode() == "Combo" and (ValidTarget(Target) or myHero.charName == "Ryze") then
      SupportedChamp:Combo()
      end
    end)
  end
	
  if SupportedChamp.Harass then
    table.insert(tickTable, function()
      if IOW:Mode() == "Harass" and ValidTarget(Target) then
      SupportedChamp:Harass()
      end
    end)
  end
  
  if SupportedChamp.LaneClear then
    table.insert(tickTable, function()
      if IOW:Mode() == "LaneClear" then
      SupportedChamp:LaneClear()
      end
    end)
  end

  if SupportedChamp.LastHit then
    table.insert(tickTable, function() 
	  if IOW:Mode() == "LastHit" or IOW:Mode() == "LaneClear" then
      SupportedChamp:LastHit()
      end
    end)
  end
  
  if SupportedChamp.Tick and SupportedChamp.Killsteal then
    table.insert(tickTable, function()
      if SupportedChamp.Tick then 
      SupportedChamp:Tick() 
      end
      if SupportedChamp.Killsteal then 
      SupportedChamp:Killsteal() 
      end
    end)
  elseif SupportedChamp.Killsteal then
    table.insert(tickTable, function()
      if SupportedChamp.Killsteal then 
      SupportedChamp:Killsteal() 
      end
    end)
  elseif SupportedChamp.Tick then
    table.insert(tickTable, function()
      if SupportedChamp.Tick then 
      SupportedChamp:Tick() 
      end
    end)
  end
  
  gTick = 0
  cTick = 0
  
  Callback.Add("Tick",function() 
    local time = os.clock()
    if gTick < time then
      gTick = time + 0.025
      cTick = cTick + 1
      if cTick > #tickTable then
	  cTick = 1 
	  end
      tickTable[cTick]()
    end
    CalculateDamageOffsets()
   end)
   
   if TrackableBuffs then
     Callback.Add("UpdateBuff",function(unit, buff)
       if unit and unit.team ~= myHero.team and buff.Name:lower() == TrackableBuffs then
         StacksTable[unit.networkID] = buff.Stacks
       end
     end)
	 
     Callback.Add("RemoveBuff",function(unit, buff)
       if unit and unit.team ~= myHero.team and buff.Name:lower() == TrackableBuffs then
         StacksTable[unit.networkID] = 0
       end
      end)
    end
	
    if SupportedChamp.UpdateBuff ~= nil then
      Callback.Add("UpdateBuff",function(unit, buff)
        SupportedChamp:UpdateBuff(unit, buff)
      end)
    end
	
    if SupportedChamp.RemoveBuff ~= nil then
      Callback.Add("RemoveBuff",function(unit, buff)
        SupportedChamp:RemoveBuff(unit, buff)
      end)
    end
	
    if SupportedChamp.ProcessAttack ~= nil then
      Callback.Add("ProcessSpellAttack",function(unit, spell)
        SupportedChamp:ProcessAttack(unit, spell)
      end)
    end
	
    if SupportedChamp.ProcessSpell ~= nil then 
      Callback.Add("ProcessSpell",function(unit, spell)
        SupportedChamp:ProcessSpell(unit, spell)
      end)
    end
	
    if SupportedChamp.Animation ~= nil then
      Callback.Add("Animation",function(unit, ani)
        SupportedChamp:Animation(unit, ani)
      end)
    end
	
    if SupportedChamp.CreateObj ~= nil then
      Callback.Add("CreateObj",function(Object)
        SupportedChamp:CreateObj(Object)
      end)
    end
	  
    if SupportedChamp.DeleteObj ~= nil then
      Callback.Add("DeleteObj",function(Object)
        SupportedChamp:DeleteObj(Object)
      end)
    end
	  
    if SupportedChamp.Draw ~= nil then
      Callback.Add("Draw",function()
        SupportedChamp:Draw()
      end)
    end
	  
    Callback.Add("Draw",function()
      Draw()
    end)
	  
    if SupportedChamp.Load ~= nil then
      SupportedChamp:Load()
    end
	  
end

function Draw()
  DrawRange()
  for i, enemy in pairs(GetEnemyHeroes()) do
    DrawDmgOnHpBar(enemy)
  end
end

function DrawRange()
  if myHero.charName == "Jayce" or myHero.charName == "Nidalee" or not mySpellData then return end
  if MainMenu.Drawings.Q and sReady[_Q] and mySpellData[0] then
    DrawCircle3D(myHero.x, myHero.y, myHero.z, myHero.charName == "Rengar" and myHero.range+myHero.boundingRadius*2 or mySpellData[0].range > 0 and mySpellData[0].range or mySpellData[0].width, ARGB(MainMenu.Drawings.ColorQ[1],MainMenu.Drawings.ColorQ[2],MainMenu.Drawings.ColorQ[3],MainMenu.Drawings.ColorQ[4]))
  end
  if myHero.charName ~= "Orianna" then
    if MainMenu.Drawings.W and sReady[_W] and mySpellData[1] then
      DrawCircle3D(myHero.x, myHero.y, myHero.z, type(mySpellData[1].range) == "function" and mySpellData[1].range() or mySpellData[1].range > 0 and mySpellData[1].range or mySpellData[1].width, ARGB(MainMenu.Drawings.ColorW[1],MainMenu.Drawings.ColorW[2],MainMenu.Drawings.ColorW[3],MainMenu.Drawings.ColorW[4]))
    end
    if MainMenu.Drawings.E and sReady[_E] and mySpellData[2] then
      DrawCircle3D(myHero.x, myHero.y, myHero.z, mySpellData[2].range > 0 and mySpellData[2].range or mySpellData[2].width, ARGB(MainMenu.Drawings.ColorE[1],MainMenu.Drawings.ColorE[2],MainMenu.Drawings.ColorE[3],MainMenu.Drawings.ColorE[4]))
    end
    if MainMenu.Drawings.R and (sReady[_R] or myHero.charName == "Katarina") and mySpellData[3] then
      DrawCircle3D(myHero.x, myHero.y, myHero.z, type(mySpellData[3].range) == "function" and mySpellData[3].range() or mySpellData[3].range > 0 and mySpellData[3].range or mySpellData[3].width, ARGB(MainMenu.Drawings.ColorR[1],MainMenu.Drawings.ColorR[2],MainMenu.Drawings.ColorR[3],MainMenu.Drawings.ColorR[4]))
    end
  end
end
  
function DrawDmgOnHpBar(unit)
    if not MainMenu.Drawings.DMG:Value() then return end
    if unit and unit.valid and not unit.dead and unit.visible and unit.bTargetable then
      local kdt = killDrawTable[unit.networkID]
      for _=1, #kdt do
        local vars = kdt[_]
        if vars and vars[1] then
          DrawRectangle(vars[1], vars[2], vars[3], vars[4], vars[5])
          DrawText(vars[6], vars[7], vars[8], vars[9], vars[10])
        end
      end
      if myHero.charName == "Kalista" then
        local drawpos = WorldToScreen(1,unit.pos)
        local offset = GetUnitHPBarOffset(hero)
        DrawText(math.floor(Edmg(unit)/GetCurrentHP(unit)*100).."%",20,drawPos.x,drawPos.y,0xffffffff)
      end
    end
  end
  
function CalculateDamage()
  if not MainMenu.Drawings.DMG:Value() then return end
  for i, enemy in pairs(GetEnemyHeroes()) do
    if enemy and not enemy.dead and enemy.visible and enemy.bTargetable then
      local Qdmg = myHero:CanUseSpell(_Q) ~= READY and 0 or getdmg("Q",enemy) or 0
      local Wdmg = myHero:CanUseSpell(_W) ~= READY and 0 or getdmg("W",enemy) or 0
      local Edmg = myHero:CanUseSpell(_E) ~= READY and 0 or getdmg("E",enemy) or 0
      local Rdmg = myHero:CanUseSpell(_R) ~= READY and 0 or getdmg("R",enemy) or 0
      killTable[enemy.networkID] = {Qdmg, Wdmg, Edmg, Rdmg}
    end
  end
end

function CalculateDamageOffsets()
  if not MainMenu.Drawings.DMG:Value() then return end
  for i, enemy in pairs(GetEnemyHeroes()) do
    local nextOffset = 0
    local barPos = GetHPBarPos(enemy)
    pos = {x = barPos.x - 67, y = barPos.y - 4}
    local totalDmg = 0
    killDrawTable[enemy.networkID] = {}
    for _, dmg in pairs(killTable[enemy.networkID]) do
      if dmg > 0 then
        local perc1 = dmg / enemy.maxHealth
        local perc2 = totalDmg / enemy.maxHealth
        totalDmg = totalDmg + dmg
        local offs = 1-(enemy.maxHealth - enemy.health) / enemy.maxHealth
        killDrawTable[enemy.networkID][_] = {
        offs*105+pos.x-perc2*105, pos.y, -perc1*105, 9, colors[_],
        str[_-1], 15, offs*105+pos.x-perc1*105-perc2*105, pos.y-20, colors[_]
        }
      else
        killDrawTable[enemy.networkID][_] = {}
      end
    end
  end
end

function DisableOrb()
IOW.movementEnabled = false
IOW.attacksEnabled = false
end

function EnableOrb()
IOW.movementEnabled = true
IOW.attacksEnabled = true
end

function DisableMovement()
IOW.movementEnabled = false
end

function EnableMovement()
IOW.movementEnabled = true
end

function DisableAttack()
IOW.attacksEnabled = false
end

function EnableAttack()
IOW.attacksEnabled = true
end

function Line3D(from,to,width,color)
  return DrawLine3D(from.x,from.y,from.z,to.x,to.y,to.z,width,color)
end

function ResetAA()
  return IOW:ResetAA()
end

function CanMove()
  --return IOW:CanMove()
end

function CanAttack()
  --return IOW:CanAttack()
end

function GetStacks(unit)
  if myHero.charName == "Syndra" or myHero.charName == "Kassadin" then
    return SupportedChamp.stacks
  else
    return (StacksTable and StacksTable[unit.networkID]) and StacksTable[unit.networkID] or 0
  end
end

function Cast(spell, target, source)
  if not spell or spell < 0 then return end
  local source = source or myHero
  local ActivePred = DAIOMenu.Prediction.Pred:Value() == 1 and "GoS" or "IPrediction"
  
  if not target then
    CastSpell(spell)
    return true
	
  elseif target then
    if mySpellData[spell] and mySpellData[spell].type then
      local HitChance, CastPos = Predict(spell, source, target)
      if HitChance >= (ActivePred == "GoS" and 1 or 3) then
      CastSkillShot(spell,CastPos)
      return true
      end
    else
      CastTargetSpell(target,spell)
      return true
      end
    end
    return false
end

function Predict(spell, source, target, pred)
  local pred = pred or DAIOMenu.Prediction.Pred:Value()
  local spell = mySpellData[spell]
  
  if pred == "GoS" then
    local PredictedPos = GetPredictionForPlayer(source.pos,target,target.ms, spell.speed, spell.delay*1000, spell.range, spell.width, spell.collision, true)
    return PredictedPos.HitChance, PredictedPos.PredPos
  else
    return IPrediction.Prediction({name=spell.name, range=spell.range, speed=spell.speed, delay=spell.delay, width=spell.width, type=spell.type, collision=spell.collision}):Predict(target,source)
  end
	
end

class "Ahri"

function Ahri:__init()
  self.UltOn = false
  self.Missiles = {}
end

function Ahri:Load()
  self:Menu()
end

function Ahri:Menu()
  MainMenu.Combo:Boolean("Q", "Use Q", true)
  MainMenu.Combo:Boolean("W", "Use W", true)
  MainMenu.Combo:Boolean("E", "Use E", true)
  MainMenu.Combo:Boolean("R", "Use R", true)
  MainMenu.Combo:DropDown("RMode", "R Mode", 1, {"Logic", "to mouse"})
  MainMenu.Harass:Boolean("Q", "Use Q", true)
  MainMenu.Harass:Boolean("W", "Use W", true)
  MainMenu.Harass:Boolean("E", "Use E", true)
  MainMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)
  MainMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
  MainMenu.Killsteal:Boolean("W", "Killsteal with W", true)
  MainMenu.Killsteal:Boolean("E", "Killsteal with E", true)
  if Ignite ~= nil then MainMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
  MainMenu.Lasthit:Boolean("Q", "Use Q", true)
  MainMenu.Lasthit:Slider("Mana", "if Mana % >", 50, 0, 80, 1)
  MainMenu.LaneClear:Boolean("Q", "Use Q", true)
  MainMenu.LaneClear:Boolean("W", "Use W", false)
  MainMenu.LaneClear:Boolean("E", "Use E", false)
  MainMenu.LaneClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)
  AddGapcloseEvent(_E, 666, false, MainMenu.Misc)
end

function Ahri:CreateObj(Object)
  if GetObjectBaseName(Object) == "missile" then
  table.insert(Missiles,Object) 
  end
end

function Ahri:DeleteObj(Object)
  if GetObjectBaseName(Object) == "missile" then
    for i,rip in pairs(Missiles) do
      if GetNetworkID(Object) == GetNetworkID(rip) then
      table.remove(Missiles,i) 
      end
    end
  end
end

function Ahri:Draw()
  for _,Orb in pairs(Missiles) do
    if Orb ~= nil and GetObjectSpellOwner(Orb) == myHero and GetObjectSpellName(Orb) == "AhriOrbMissile" or GetObjectSpellName(Orb) == "AhriOrbReturn" then
    Line3D(Orb,myHero,50,ARGB(55,255,255,255))
    DrawCircle(Orb.pos,80,1,25,ARGB(255, 255, 0, 0)) 
    end
  end
end

function Ahri:UpdateBuff(unit,buff)
  if unit == myHero and buff.Name == "ahritumble" then 
  UltOn = true
  end
end

function Ahri:RemoveBuff(unit,buff)
  if unit == myHero and buff.Name == "ahritumble" then 
  UltOn = false
  end
end

function Ahri:Combo()
  if not Target then return end
  
  if IsReady(_E) and Config.Combo.E and GetDistanceSqr(Target) < (mySpellData[2].range)^2 then
    Cast(_E, Target)
  end
  
  if MainMenu.Combo.R:Value() and GetDistanceSqr(Target) < (mySpellData[3].range)^2 then
    if MainMenu.Combo.RMode:Value() == 1 then
      local BestPos = Vector(Target) - (Vector(Target) - Vector(myHero)):perpendicular():normalized() * 350
      if UltOn and BestPos then
        CastSkillShot(_R,BestPos)
      elseif IsReady(_R) and BestPos and getdmg("Q",Target)+getdmg("W",Target,myHero,3)+getdmg("E",Target)+getdmg("R",Target) > GetHP2(Target) then
        CastSkillShot(_R,BestPos)
      end
    elseif AhriMenu.Combo.RMode:Value() == 2 then
      local AfterTumblePos = myHero.pos + (Vector(mousePos) - myHero.pos):normalized() * 550
      local DistanceAfterTumble = GetDistance(AfterTumblePos, Target)
      if UltOn and DistanceAfterTumble < 550 then
        CastSkillShot(_R,mousePos)
      elseif IsReady(_R) and getdmg("Q",Target)+getdmg("W",Target,myHero,3)+getdmg("E",Target)+getdmg("R",Target) > GetHP2(Target) then
        CastSkillShot(_R,mousePos) 
      end
    end
  end
  
  if IsReady(_W) and MainMenu.Combo.W:Value() and GetDistanceSqr(Target) < (mySpellData[1].range)^2 then
    Cast(_W)
  end
  
  if IsReady(_Q) and MainMenu.Combo.Q:Value() and GetDistanceSqr(Target) < (mySpellData[0].range)^2 then
    Cast(_Q, Target)
  end
  
end

function Ahri:Harass()
  if not Target or GetPercentMP(myHero) < MainMenu.Harass.Mana:Value() then return end
  
  if IsReady(_E) and Config.Harass.E and GetDistanceSqr(Target) < (mySpellData[2].range)^2 then
    Cast(_E, Target)
  end
  
  if IsReady(_W) and MainMenu.Harass.W:Value() and GetDistanceSqr(Target) < (mySpellData[1].range)^2 then
    Cast(_W)
  end
  
  if IsReady(_Q) and MainMenu.Harass.Q:Value() and GetDistanceSqr(Target) < (mySpellData[0].range)^2 then
    Cast(_Q, Target)
  end
  
end

function Ahri:Killsteal()
  for _,enemy in pairs(GetEnemyHeroes()) do
    if ValidTarget(enemy) then
	
      if Ignite and MainMenu.Misc.Autoignite:Value() then
        if IsReady(Ignite) and 20*GetLevel(myHero)+50 > enemy.health+enemy.shieldAD+enemy.hpRegen*3 and GetDistanceSqr(enemy) <= 600^2 then
          CastTargetSpell(enemy, Ignite)
        end
      end
	
	  if IsReady(_W) and GetDistanceSqr(enemy) < (mySpellData[1].range)^2 and MainMenu.Killsteal.W:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("W",enemy,myHero,3) then
	  CastSpell(_W)
	  elseif IsReady(_Q) and GetDistanceSqr(enemy) < (mySpellData[0].range)^2 and MainMenu.Killsteal.Q:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("Q",enemy) then 
	  Cast(_Q, enemy)
	  elseif IsReady(_E) and GetDistanceSqr(enemy) < (mySpellData[2].range)^2 and MainMenu.Killsteal.E:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("E",enemy) then
	  Cast(_E, enemy)
      end
	
    end
  end
end

function Ahri:LaneClear()
  local minion = ClosestMinion(myHero.pos, MINION_ENEMY)
  if GetPercentMP(myHero) >= MainMenu.LaneClear.Mana:Value() then
  
    if minion and not minion.dead and minion.visible and minion.bTargetable then
	
      if IsReady(_Q) and MainMenu.LaneClear.Q:Value() then
        local BestPos, BestHit = GetLineFarmPosition(880, 50, MINION_ENEMY)
        if BestPos and BestHit > 2 then 
          CastSkillShot(_Q, BestPos)
        end
      end

      if IsReady(_W) and MainMenu.LaneClear.W:Value() and GetDistanceSqr(minion) <= (mySpellData[1].range)^2 and minion.health < getdmg("W",minion,myHero,3) then
        Cast(_W)
      end

      if IsReady(_E) and MainMenu.LaneClear.E:Value() and GetDistanceSqr(minion) <= (mySpellData[2].range)^2 and minion.health < getdmg("E",minion) then
        CastSkillShot(_E,minion.pos)
      end
	  
    end
	
    if MainMenu.LaneClear.J:Value() then
      for i,mobs in pairs(minionManager.objects) do
	  
        if mobs and not mobs.dead and mobs.visible and mobs.bTargetable and mobs.team == 300 then
          if IsReady(_Q) and MainMenu.LaneClear.Q:Value() and GetDistanceSqr(mobs) <= (mySpellData[0].range)^2 then
          CastSkillShot(_Q,mobs.pos)
	  end
		
	  if IsReady(_W) and MainMenu.LaneClear.W:Value() and GetDistanceSqr(mobs) <= (mySpellData[1].range)^2 then
	  CastSpell(_W)
	  end
		
	  if IsReady(_E) and MainMenu.LaneClear.E:Value() and GetDistanceSqr(mobs) <= (mySpellData[2].range)^2 then
	  CastSkillShot(_E,mobs.pos)
          end
        end
      end
	  
    end
  end
  
end

function Ahri:LastHit()
  if GetPercentMP(myHero) < MainMenu.LaneClear.Mana:Value() then return end
  for i,minion in pairs(minionManager.objects) do
    if minion and not minion.dead and minion.visible and minion.bTargetable and minion.team == MINION_ENEMY then
      if IsReady(_Q) and GetDistanceSqr(minion) <= (mySpellData[0].range)^2 and MainMenu.Lasthit.Q:Value() and IOW:PredictHealth(minion, 250+GetDistance(minion)/2500) < getdmg("Q",minion) and IOW:PredictHealth(minion, 250+GetDistance(minion)/2500) > 0 then
      CastSkillShot(_Q,minion.pos)
      end
    end
  end
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
 OnDraw(function() self:OnDraw() end)
 self:CreateSocket(self.VersionPath)
 self.DownloadStatus = 'Connecting to Server for VersionInfo'
 OnTick(function() self:GetOnlineVersion() end)
end

function ScriptUpdate:print(str)
    print('<font color="#FFFFFF">'..os.clock()..': '..str)
end

function ScriptUpdate:OnDraw()
  if self.DownloadStatus ~= 'Downloading Script (100%)' and self.DownloadStatus ~= 'Downloading VersionInfo (100%)'then
    local bP = {['x1'] = res.x - (res.x - 390),['x2'] = res.x - (res.x - 20),['y1'] = res.y / 2,['y2'] = (res.y / 2) + 20,}
    local text = 'Download Status: '..(self.DownloadStatus or 'Unknown')
    DrawLine(bP.x1, bP.y1 + 20, bP.x2,  bP.y1 + 20, 20, ARGB(125, 255, 255, 255))
    local xOff
    if self.File and self.Size then
      local c = math.round(100/self.Size*self.File:len(),2)/100
      xOff = c < 1 and math.ceil(370 * c) or 370
    else
      xOff = 1
    end
    local percent = 1 - xOff / 470
    DrawLine(bP.x2 + xOff, bP.y1 + 20, bP.x2, bP.y1 + 20, 20, ARGB(255, 255 * percent, 255 - (255 * percent), 0))
    DrawLines2({{x=bP.x1, y=bP.y1}, {x=bP.x2, y=bP.y1}, {x=bP.x2, y=bP.y2}, {x=bP.x1, y=bP.y2}, {x=bP.x1, y=bP.y1}, }, 3, ARGB(255, 0x0A, 0x0A, 0x0A))
    DrawText(text, 16, res.x - (res.x - 205) - (GetTextArea(text, 16).x / 2), bP.y1 + 1, ARGB(255,10,10,10))
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
    self.Socket:connect('plebleaks.com', 80) -- OP WebSite, make sure to visit it kappa
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
        for line,content in ipairs(self.File:split('\n')) do
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
                OnTick(function() self:DownloadUpdate() end)
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
        for line,content in ipairs(self.File:split('\n')) do
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
