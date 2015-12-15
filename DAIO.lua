DAIOVersion     = 1.01
DAIOLoaded      = true
DAIOAutoUpdate  = true  -- Change this to false if you wish to disable auto updater
_Q, _W, _E, _R  = 0, 1, 2, 3

function OnLoad()
  PrintChat(tostring("<font color='#D859CD'> D3CarryAIO - </font><font color='#adec00'> Please wait... </font>"))
  Update()
  LoadSpellData()
  LoadIOW()
  LoadChampion()
  PrintChat("<font color='#D859CD'> D3CarryAIO - </font> <font color='#adec00'> Successfully loaded V " .. DAIOVersion .. ", good luck!</font>")
  Init()
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
end
