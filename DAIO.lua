require("Inspired_new")

DAIOVersion     = 1.02
DAIOLoaded      = true
DAIOAutoUpdate  = true  -- Change this to false if you wish to disable auto updater

DAIOMenu = MenuConfig("D3CarryAIO","DAIO")

function OnLoad()
  PrintChat(tostring("<font color='#D859CD'> D3CarryAIO - </font><font color='#adec00'> Please wait... </font>"))
  Update()
  LoadSpellData()
  LoadDamageLib()
  LoadIOW()
  LoadChampion()
  LoadActivator()
  Init()
end

function Update()
  if not DAIOAutoUpdate then return end
  local ToUpdate = {}
  ToUpdate.UseHttps = true
  ToUpdate.Host = "raw.githubusercontent.com"
  ToUpdate.VersionPath = "/D3ftsu/GoS/master/DAIO.version"
  ToUpdate.ScriptPath =  "/D3ftsu/GoS/master/DAIO.lua"
  ToUpdate.SavePath = SCRIPT_PATH.."/DAIO.lua"
  ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) PrintChat("<font color='#D859CD'> D3CarryAIO - </font> <font color='#adec00'>Updated from v"..OldVersion.." to v"..NewVersion..". Please press F6 twice to reload.</font>") end
  ToUpdate.CallbackNoUpdate = function(OldVersion) PrintChat("<font color='#D859CD'> D3CarryAIO - </font> <font color='#adec00'>Successfully Loaded v"..OldVersion..", Good Luck!</font>") end
  ToUpdate.CallbackNewVersion = function(NewVersion) PrintChat("<font color='#D859CD'> D3CarryAIO - </font> <font color='#adec00'>New version found v"..NewVersion..". Please wait until it's downloaded.</font>") end
  ToUpdate.CallbackError = function(NewVersion) PrintChat("<font color='#D859CD'> D3CarryAIO - </font> <font color='#adec00'>There was an error while updating, Try Again!.</font>") end
  ScriptUpdate(DAIOVersion,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
end

function LoadSpellData()
  if FileExist(COMMON_PATH  .. "SpellData.lua") then
	if pcall(function() spellData = loadfile(COMMON_PATH  .. "SpellData.lua")() end) then
	mySpellData = spellData[myHero.charName]
    end
  else
	ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/DAIO.version", "/D3ftsu/GoS/master/Common/SpellData.lua", COMMON_PATH .."SpellData.lua", function() end, function() end, function() end, LoadSpellData)
  end
end

function LoadDamageLib()
  if FileExist(COMMON_PATH  .. "DamageLib.lua") then
	require('DamageLib')
  else
	ScriptUpdate(0, true, "raw.githubusercontent.com", "/D3ftsu/GoS/master/Common/DamageLib.version", "/D3ftsu/GoS/master/Common/DamageLib.lua", COMMON_PATH .."DamageLib.lua", function() end, function() end, function() end, LoadDamageLib)
  end
end

function LoadChampion()
  if _G[myHero.charName] then
  SupportedChamp = _G[myHero.charName]()
  end
end

function LoadActivator()
  DAIOMenu:Menu("Activator", "Activator")
  Activerino = Activator()
end

function Init()
  if not SupportedChamp then return end
  SetupPrediction()
  SetupTargetSelector()
  SetupMenu()
  SetupPlugin()
end

function SetupPrediction()
  DAIOMenu:Menu("Prediction", "Prediction")
  DAIOMenu.Prediction:Section("Choose", "Choose Prediction :")
  DAIOMenu.Prediction.Choose:DropDown("Pred", 1, {"GoS", "IPrediction", "Open Prediction"})
end

function SetupTargetSelector()
  DAIOMenu:Menu("TSMenu","Target Selector")
  DAIOMenu.TSMenu:Section("TargetSelect","Target Selector")
  DAIOMenu.TSMenu.TargetSelect:TargetSelector("ts", "", TargetSelector(CustomTS(), TARGET_LESS_CAST, ad[myHero.charName] and DAMAGE_PHYSICAL or DAMAGE_MAGIC,true))
end

function CustomTS()
  local r = 0
	for i = 0,3 do
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

function SetupMenu()
  DAIOMenu:Menu(myHero.charName,myHero.charName)
  MainMenu = DAIOMenu[myHero.charName]
  MainMenu:Section("Combo","Combo")
  MainMenu:Section("Harass","Harass")
  MainMenu:Section("LastHit","LastHit")
  MainMenu:Section("LaneClear","LaneClear")
  MainMenu.LaneClear:Boolean("J", "Attack Jungle", true)
  MainMenu:Section("Killsteal","Killsteal")
  MainMenu:Section("Misc","Misc")
  MainMenu:Section("Drawings","Drawings")
  MainMenu.Drawings:Boolean("Q", "Draw Q", true)
  MainMenu.Drawings:Boolean("W", "Draw W", true)
  MainMenu.Drawings:Boolean("E", "Draw E", true)
  MainMenu.Drawings:Boolean("R", "Draw R", true)
  MainMenu.Drawings:Boolean("DMG", "Draw DMG", true)
  MainMenu:Section("KeySettings","Key Settings")
end

function SetupPlugin()
  tickTable = { Target = TargetSelector(CustomTS(), TARGET_LESS_CAST, ad[myHero.charName] and DAMAGE_PHYSICAL or DAMAGE_MAGIC,true):GetTarget() }

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
	  if cTick > #tickTable then cTick = 1 end
	  tickTable[cTick]()
	end
   end)
	
	if SupportedChamp.UpdateBuff then
	  Callback.Add("UpdateBuff",function(unit, buff)
		SupportedChamp:UpdateBuff(unit, buff)
	  end)
	end
	
	if SupportedChamp.RemoveBuff then
	  Callback.Add("RemoveBuff",function(unit, buff)
		SupportedChamp:RemoveBuff(unit, buff)
	  end)
	end
	
	if SupportedChamp.ProcessAttack then
	  Callback.Add("ProcessSpellAttack",function(unit, spell)
		SupportedChamp:ProcessAttack(unit, spell)
	  end)
	end
	
	if SupportedChamp.ProcessSpell then 
	  Callback.Add("ProcessSpell",function(unit, spell)
		SupportedChamp:ProcessSpell(unit, spell)
	  end)
	end
	
	if SupportedChamp.Animation then
	  Callback.Add("Animation",function(unit, ani)
		SupportedChamp:Animation(unit, ani)
	  end)
	end
	
	if SupportedChamp.CreateObj then
	  Callback.Add("CreateObj",function(Object)
		SupportedChamp:CreateObj(Object)
	  end)
	end
	  
	if SupportedChamp.DeleteObj then
	  Callback.Add("DeleteObj",function(Object)
		SupportedChamp:DeleteObj(Object)
	  end)
	end
	  
	if SupportedChamp.Draw then
	  Callback.Add("Draw",function()
		SupportedChamp:Draw()
	  end)
	end
	  
	Callback.Add("Draw",function()
	  Draw()
	end)
	  
	if SupportedChamp.Load then
	  SupportedChamp:Load()
	end
	  
end

function Draw()
  DrawRange()
end

function DrawRange()
  if myHero.charName == "Jayce" or myHero.charName == "Nidalee" or not mySpellData then return end
  if MainMenu.Drawings.Q:Value() and IsReady(_Q) and mySpellData[_Q] then
	DrawCircle(myHero.pos, myHero.charName == "Rengar" and myHero.range+myHero.boundingRadius*2 or mySpellData[_Q].range > 0 and mySpellData[_Q].range or mySpellData[_Q].width, 2,20, ARGB(255, 155, 255, 155))
  end
  if myHero.charName ~= "Orianna" then
	if MainMenu.Drawings.W:Value() and IsReady(_W) and mySpellData[_W] then
	  DrawCircle(myHero.pos, type(mySpellData[_W].range) == "function" and mySpellData[_W].range() or mySpellData[_W].range > 0 and mySpellData[_W].range or mySpellData[_W].width, 2, 20, ARGB(255, 55, 155, 255))
	end
	if MainMenu.Drawings.E:Value() and IsReady(_E) and mySpellData[_E] then
	  DrawCircle(myHero.pos, mySpellData[_E].range > 0 and mySpellData[_E].range or mySpellData[_E].width, 2, 20, ARGB(255, 255, 155, 155))
	end
	if MainMenu.Drawings.R:Value() and (IsReady(_R) or myHero.charName == "Katarina") and mySpellData[_R] then
	  DrawCircle(myHero.pos, type(mySpellData[_R].range) == "function" and mySpellData[_R].range() or mySpellData[_R].range > 0 and mySpellData[_R].range or mySpellData[_R].width, 2, 20, ARGB(255, 155, 55, 55))
	end
  end
end

local function DrawLine3D(x,y,z,a,b,c,width,col)
	local p1 = WorldToScreen(0, Vector(x,y,z))
	local p2 = WorldToScreen(0, Vector(a,b,c))
	DrawLine(p1.x, p1.y, p2.x, p2.y, width, col)
end

function DrawCustomRectangle(startPos, endPos, width)
	local c1 = startPos+Vector(Vector(endPos)-startPos):perpendicular():normalized()*width/2
	local c2 = startPos+Vector(Vector(endPos)-startPos):perpendicular2():normalized()*width/2
	local c3 = endPos+Vector(Vector(startPos)-endPos):perpendicular():normalized()*width/2
	local c4 = endPos+Vector(Vector(startPos)-endPos):perpendicular2():normalized()*width/2
	DrawLine3D(c1.x,c1.y,c1.z,c2.x,c2.y,c2.z,math.ceil(width/100),ARGB(255, 255, 255, 255))
	DrawLine3D(c3.x,c3.y,c3.z,c4.x,c4.y,c4.z,math.ceil(width/100),ARGB(255, 255, 255, 255))
	local c1 = startPos+Vector(Vector(endPos)-startPos):perpendicular():normalized()*width
	local c2 = startPos+Vector(Vector(endPos)-startPos):perpendicular2():normalized()*width
	local c3 = endPos+Vector(Vector(startPos)-endPos):perpendicular():normalized()*width
	local c4 = endPos+Vector(Vector(startPos)-endPos):perpendicular2():normalized()*width
	DrawLine3D(c1.x,c1.y,c1.z,c2.x,c2.y,c2.z,math.ceil(width/100),ARGB(255, 255, 255, 255))
	DrawLine3D(c2.x,c2.y,c2.z,c3.x,c3.y,c3.z,math.ceil(width/100),ARGB(255, 255, 255, 255))
	DrawLine3D(c3.x,c3.y,c3.z,c4.x,c4.y,c4.z,math.ceil(width/100),ARGB(255, 255, 255, 255))
	DrawLine3D(c1.x,c1.y,c1.z,c4.x,c4.y,c4.z,math.ceil(width/100),ARGB(255, 255, 255, 255))
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

function Cast(spell, unit, source)
  if not spell or spell < 0 then return end
  local source = source or myHero
  local ActivePred = DAIOMenu.Prediction.Choose.Pred:Value() == 1 and "GoS" or "IPrediction"
  
  if not unit then
	CastSpell(spell)
	return true
	
  elseif unit then
	if mySpellData[spell] and mySpellData[spell].type then
	  local spelldata = mySpellData[spell]
	  if ActivePred == "GoS" then
		local PredictedPos = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),spelldata.speed,spelldata.delay*1000,spelldata.range,spelldata.width,spelldata.collision,true)
		if PredictedPos.HitChance >= 1 then
		CastSkillShot(spell,PredictedPos.PredPos)
		end
	  end
	  --else
		--local HitChance, PredictedPos = IPrediction.Prediction({name=spell.name, range=spell.range, speed=spell.speed, delay=spell.delay, width=spell.width, type=spell.type, collision=spell.collision}):Predict(target,source)
		--if HitChance >= 3 then 
		--CastSkillShot(spell,PredictedPos)
		--end
		return true
	else
	  CastTargetSpell(unit,spell)
	  return true
	  end
	end
	return false
end

class "Activator"

function Activator:__init()
  self.startAttackTime = 0
  self.windUpTime = 0
  self.muramanaActive = false
  enemies = GetEnemyHeroes()
  allies = GetAllyHeroes()
  table.insert(allies, myHero)

  self.items = {
	[3222] = { name = "ItemMorellosBane", range = 600 },
	[3140] = { name = "QuicksilverSash", range = 0 },
	[3139] = { name = "ItemMercurial", range = 0 },
	[3137] = { name = "ItemDervishBlade", range = 0 },
	[3153] = { name = "ItemSwordOfFeastAndFamine", range = 550 },
	[3144] = { name = "BilgewaterCutlass", range = 550 },
	[3142] = { name = "YoumusBlade", range = 650 },
	[3074] = { name = "ItemTiamatCleave", range = 440 },
	[3077] = { name = "ItemTiamatCleave", range = 440 },
	[3748] = { name = "TitanicHydra", range = 150 },
	[3146] = { name = "HextechGunblade", range = 700 },
	[3092] = { name = "ItemGlacialSpikeCast", range = 850 },
	[3042] = { name = "Muramana", range = 0 },
	[3004] = { name = "Manamune", range = 0 },
	[3401] = { name = "HealthBomb", range = 600 },
	[3157] = { name = "ZhonyasHourglass", range = 0 },
	[3040] = { name = "ItemSeraphsEmbrace", range = 0 },
	[3190] = { name = "IronStylus", range = 600 },
	[3143] = { name = "RanduinsOmen", range = 500 },
	[2003] = { name = "RegenerationPotion", range = 0 },
	[2004] = { name = "FlaskOfCrystalWater", range = 0 },
	[2041] = { name = "ItemCrystalFlask", range = 0 },
	[2010] = { name = "ItemMiniRegenPotion", range = 0 }
  }

  self.summonerSpells = {
	flash   = nil,
	heal    = nil,
	barrier = nil,
	ignite  = nil,
	exhaust = nil,
	smite   = nil
  }

  self.smiteDamage = {390, 410, 430, 450, 480, 510, 540, 570, 600, 640, 680, 720, 760, 800, 850, 900, 950, 1000}

  self:Load()
  Callback.Add("Tick",function() self:Tick() end)
  Callback.Add("ProcessSpellAttack",function(unit,spell) self:ProcessAttack(unit,spell) end)
  Callback.Add("ProcessSpell",function(unit,spell) self:ProcessSpell(unit,spell) end)
  Callback.Add("UpdateBuff",function(unit,buff) self:UpdateBuff(unit,buff) end)
  Callback.Add("RemoveBuff",function(unit,buff) self:RemoveBuff(unit,buff) end)
end

function Activator:Load()

  for slot = SUMMONER_1, SUMMONER_2 do
	if GetCastName(myHero,slot) == "summonerheal" then
	  self.summonerSpells.heal = slot
	elseif GetCastName(myHero,slot) == "summonerbarrier" then
	  self.summonerSpells.barrier = slot
	elseif GetCastName(myHero,slot) == "summonerdot" then
	  self.summonerSpells.ignite = slot
	elseif GetCastName(myHero,slot) == "summonerexhaust" then
	  self.summonerSpells.exhaust = slot
	elseif GetCastName(myHero,slot) == "summonerflash" then
	  self.summonerSpells.flash = slot
	elseif GetCastName(myHero,slot):find("smite") then
	  self.summonerSpells.smite = slot
	end
  end

  ActivatorMenu = DAIOMenu.Activator
  ActivatorMenu:Section("Consumables","Consumables")
  ActivatorMenu.Consumables:Boolean("pots", "Use potions", true)

  ActivatorMenu:Section("Summoners", "Summoners")
  if self.summonerSpells.exhaust ~= nil then
	ActivatorMenu.Summoners:Info("Exhaust", "--------------Exhaust------------")
	ActivatorMenu.Summoners:Boolean("exhaust", "Use Exhaust", true)
	ActivatorMenu.Summoners:Boolean("exhaustCombo", "Always use Exhaust in combo", true)
  end
  if self.summonerSpells.heal ~= nil then
	ActivatorMenu.Summoners:Info("Heal", "-----------------Heal----------------")
	ActivatorMenu.Summoners:Boolean("heal", "Use Heal", true)
	ActivatorMenu.Summoners:Boolean("healAlly", "Use Heal on Ally", true)
  end
  if self.summonerSpells.barrier ~= nil then
	ActivatorMenu.Summoners:Info("Barrier", "--------------Barrier-----------")
	ActivatorMenu.Summoners:Boolean("barrier", "Use Barrier", true)
  end
  if self.summonerSpells.ignite ~= nil then
	ActivatorMenu.Summoners:Info("Ignite", "---------------Ignite------------")
	ActivatorMenu.Summoners:Boolean("ignite", "Use Ignite", true)
  end
  if self.summonerSpells.smite ~= nil then
	ActivatorMenu.Summoners:Info("Smite", "----------------Smite-------------")
	ActivatorMenu.Summoners:Boolean("smite", "Use auto Smite", true)
	ActivatorMenu.Summoners:Boolean("smiteDrake", "Smite Dragon", true)
	ActivatorMenu.Summoners:Boolean("smiteBaron", "Smite Baron", true)
	ActivatorMenu.Summoners:Boolean("smiteBlue", "Smite Blue", true)
	ActivatorMenu.Summoners:Boolean("smiteRed", "Smite Red", true)
  end
	
  ActivatorMenu:Section("Defensive", "Defensive")
  ActivatorMenu.Defensive:Boolean("randuin", "Use Randuin's Omen", true)
  ActivatorMenu.Defensive:Boolean("fotm", "Use Face Of The Mountain", true)
  ActivatorMenu.Defensive:Boolean("zhonyas", "Use Zhonya's", true)
  ActivatorMenu.Defensive:Boolean("seraphs", "Use Seraph's Embrace", true)
  ActivatorMenu.Defensive:Boolean("solari", "Use Locket of Iron Solari", true)

  ActivatorMenu:Section("Offensive", "Offensive")
  ActivatorMenu.Offensive:Info("Botrk", "--------------Botrk--------------")
  ActivatorMenu.Offensive:Boolean("botrk", "Use Botrk", true)
  ActivatorMenu.Offensive:Boolean("botrkKS", "Use Botrk to KS", true)
  ActivatorMenu.Offensive:Boolean("botrkLS", "Use Botrk to save life", true)
  ActivatorMenu.Offensive:Boolean("botrkCombo", "Always use Botrk in combo", false)
  ActivatorMenu.Offensive:Info("Cutlass", "-------------Cutlass-----------")
  ActivatorMenu.Offensive:Boolean("cutlass", "Use Cutlass", true)
  ActivatorMenu.Offensive:Boolean("cutlassKS", "Use Cutlass to KS", true)
  ActivatorMenu.Offensive:Boolean("cutlassCombo", "Always use Cutlass in combo", true)
  ActivatorMenu.Offensive:Info("Hextech", "-------------Hextech-----------")
  ActivatorMenu.Offensive:Boolean("hextech", "Use Hextech", true)
  ActivatorMenu.Offensive:Boolean("hextechKS", "Use Hextech to KS", true)
  ActivatorMenu.Offensive:Boolean("hextechCombo", "Always use Hextech in combo", true)
  ActivatorMenu.Offensive:Info("Youmu", "--------------Youmu------------")
  ActivatorMenu.Offensive:Boolean("youmus", "Use Youmu", true)
  ActivatorMenu.Offensive:Boolean("youmusR", "Use Youmus with spells", true)
  ActivatorMenu.Offensive:Boolean("youmusKS", "Use Youmus to KS", true)
  ActivatorMenu.Offensive:Boolean("youmusCombo", "Always use Youmuus in combo", false)
  ActivatorMenu.Offensive:Info("Hydra", "---------------Hydra--------------")
  ActivatorMenu.Offensive:Boolean("hydra", "Use Hydra", true)
  ActivatorMenu.Offensive:Boolean("hydraTitanic", "Use Hydra Titanic", true)
  ActivatorMenu.Offensive:Info("Muram", "--------------Muramana------------")
  ActivatorMenu.Offensive:Boolean("muramana", "Use Muramana", true)

  ActivatorMenu:Section("Cleanse", "Cleanse")
  ActivatorMenu.Cleanse:Boolean("Enabled", "Enabled", true)
  ActivatorMenu.Cleanse:Slider("cleanseDelay", "cleanse after X sec", 0.1, 0, 0.5)
  ActivatorMenu.Cleanse:Slider("cleanseHP", "cleanse if under %hp", 80, 0, 100)
  ActivatorMenu.Cleanse:Info("Cleanse debuff types", "----------Debbufs--------")
  ActivatorMenu.Cleanse:Boolean("stun", "Stun", true)
  ActivatorMenu.Cleanse:Boolean("snare", "Snare/Root", true)
  ActivatorMenu.Cleanse:Boolean("charm", "Charm", true)
  ActivatorMenu.Cleanse:Boolean("fear", "Fear", true)
  ActivatorMenu.Cleanse:Boolean("suppression", "Suppression", true)
  ActivatorMenu.Cleanse:Boolean("taunt", "Taunt", true)
  ActivatorMenu.Cleanse:Boolean("blind", "Blind / Polymorph", true)
end

function Activator:Tick()
  self.ts = TargetSelector(1000,TARGET_LOW_HP,DAMAGE_MAGIC,false)
  if ActivatorMenu.Cleanse.Enabled:Value() then self:Cleanse() end
  if not self:isWindingUp() then self:beforeAttack() end
  if ActivatorMenu.Consumables.pots then self:Potions() end	
  if self.summonerSpells.ignite ~= nil and IsReady(self.summonerSpells.ignite) then self:Ignite() end
  if self.summonerSpells.exhaust ~= nil and IsReady(self.summonerSpells.exhaust) then self:Exhaust() end
  if self.summonerSpells.smite ~= nil and IsReady(self.summonerSpells.smite) then self:Smite() end
  self:Offensive()
  self:Randuin()
  self:Zhonya()
end

function Activator:AfterAttack()
  if not self:isWindingUp() and self.windUpTime+0.05 > os.clock()-self.startAttackTime then
  	return true
  end
  return false
end

function Activator:ProcessAttack(unit,spell)
  if unit == myHero then
    self.startAttackTime = os.clock()
    self.windUpTime = spell.windUpTime
  end
  self:Save(unit,spell)
end

function Activator:ProcessSpell(unit,spell)
  if unit.isMe then
  	if GetItemSlot(myHero,3142) > 0 and IsReady(GetItemSlot(myHero,3142)) and ActivatorMenu.Offensive.youmusR:Value() then
	  local spelltype = getSpellType(unit, spell.name)
	    if spelltype == "R" and (myHero.charName == "Twitch" or myHero.charName == "Lucian") then
		  Cast(GetItemSlot(myHero,3142))
		end
		if spelltype == "Q" and myHero.charName == "Ashe" then
		  Cast(GetItemSlot(myHero,3142))
		end
	end
  end
  self:Save(unit,spell)
end

function Activator:isWindingUp()
  if self.windUpTime > os.clock()-self.startAttackTime then
	return true
  end
  return false
end

function Activator:afterAttack()
  if ActivatorMenu.Offensive.hydraTitanic:Value() and self:isCombo() and GetItemSlot(myHero,3748) > 0 and IsReady(GetItemSlot(myHero,3748)) and ValidTarget(GetCurrentTarget(),myHero.range) then
    Cast(GetItemSlot(myHero,3748))
	self.startAttackTime = 0
	self.windUpTime = 0
  end
end

function Activator:UpdateBuff(unit, buff)
  if unit == myHero and buff.Name == "Muramana" then
	self.muramanaActive = true
  end
end

function Activator:RemoveBuff(unit,buff)
  if unit == myHero and buff.Name == "Muramana" then
	self.muramanaActive = false
  end
end

function Activator:beforeAttack()
  if ActivatorMenu.Offensive.muramana:Value() then
    local idMur = 0
    if GetItemSlot(myHero,3042) > 0 then 
	  idMur = GetItemSlot(myHero,3042)
	elseif GetItemSlot(myHero,3043) > 0 then 
	  idMur = GetItemSlot(myHero,3043)
	end
		
	local target = GetCurrentTarget
	if idMur > 0 and ValidTarget(target,myHero.range+myHero.boundingRadius+65) and IsReady(idMur) and myHero.mana > myHero.maxMana * 0.3 then
	  if not muramanaActive then
		Cast(idMur)
	  end
	elseif target == nil or EnemiesAround(myHero.pos,myHero.range+myHero.boundingRadius+65) == 0 and muramanaActive and idMur > 0 and IsReady(idMur) then
		Cast(idMur)
	end
  end
end

function Activator:Save(unit, spell)
  if unit.team == myHero.team then return end
  if GetDistanceSqr(unit) > 2560000 then return end
  local spelltype = getSpellType(unit, spell.name)
  if not (spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" or spelltype == "P" or spelltype == "QM" or spelltype == "WM" or spelltype == "EM" or spelltype == "BAttack" or spelltype == "CAttack") then return end
  for _, ally in ipairs(allies) do
	if not ally.dead and ally.valid and GetDistance(ally) < 700 then
	  incomingDmg = 0
	  if spell.target ~= nil and spell.target.networkID == ally.networkID then
	    if spelltype == "BAttack" then
		  incomingDmg = incomingDmg + unit:CalcDamage(spell.target, unit.totalDamage)
		elseif spelltype == "CAttack" then
		  incomingDmg = incomingDmg + (unit:CalcDamage(spell.target, unit.totalDamage) * 2)
		else
		  incomingDmg = incomingDmg + getDmg(spelltype, spell.target, unit)
		end
	  else
	    local area = GetDistance(spell.endPos, ally) * Vector(spell.endPos - ally.pos):normalized() + ally.pos
	    if GetDistance(ally, area) < (ally.boundingRadius / 2) then
		  incomingDmg = incomingDmg + getDmg(spelltype, ally, unit)
	    else
	      incomingDmg = 0
	    end
	  end

	  if self.summonerSpells.exhaust and incomingDmg > 0 then
	    if IsReady(self.summonerSpells.exhaust) and ActivatorMenu.Sumonners.exhaust:Value() then
          if (ally.health - incomingDmg) < (EnemiesAround(ally.pos, 700) * ally.level * 40) then
		    Cast(self.summonerSpells.exhaust, unit)
		  end
	    end

	    if self.summonerSpells.heal and IsReady(self.summonerSpells.heal) and ActivatorMenu.Sumonners.heal:Value() then
		  if ActivatorMenu.Summoners.healAlly:Value() then
		    if (ally.health - incomingDmg) < (EnemiesAround(ally.pos,700) * ally.level * 40) then
		      Cast(self.summonerSpells.heal)
		    elseif (ally.health - incomingDmg) < (ally.level * 10) then
			  Cast(self.summonerSpells.heal)
		    end
		  end
	    end

	    if ActivatorMenu.Defensive.solari:Value() and GetItemSlot(myHero,3190) > 0 and IsReady(GetItemSlot(myHero,3190)) and GetDistance(ally) < self.items[3190].range then
		  if (ally.health - incomingDmg) < (EnemiesAround(ally.pos,700) * ally.level * 40) then
		    Cast(GetItemSlot(myHero,3190))
		  elseif (ally.health - incomingDmg) < (ally.level * 10) then
		    Cast(GetItemSlot(myHero,3190))
		  end
	    end

	    if ActivatorMenu.Defensive.fotm:Value() and GetItemSlot(myHero,3401) > 0 and IsReady(GetItemSlot(myHero,3401)) and GetDistance(ally) < self.items[3401].range then
		  if (ally.health - incomingDmg) < (EnemiesAround(ally.pos,700) * ally.level * 10) then
		    Cast(GetItemSlot(myHero,3401), ally)
		  elseif (ally.health - incomingDmg) < (ally.level * 10) then
		    Cast(GetItemSlot(myHero,3401), ally)
		  end
	    end

	    if ally.isMe and self.summonerSpells.barrier then
	      if IsReady(self.summonerSpells.barrier) and ActivatorMenu.Summoners.barrier:Value() then
		    local barrierAmount = 95 + myHero.level * 20
		    if incomingDmg > barrierAmount and myHero.health < myHero.maxHealth * 0.5 then
			  Cast(self.summonerSpells.barrier)
		    end
		    if (myHero.health - incomingDmg) < (EnemiesAround(ally.pos,700) * ally.level * 15) then
		      Cast(self.summonerSpells.barrier)
		    end
		  end

		  if ActivatorMenu.Defensive.seraphs:Value() then
		    if GetItemSlot(myHero,3040) > 0 and IsReady(GetItemSlot(myHero,3040)) then
		      local seraphAmount = myHero.level * 20
		      if incomingDmg > seraphAmount and myHero.health < myHero.maxHealth * 0.5 then
			    Cast(GetItemSlot(myHero,3040))
			  elseif (myHero.health - incomingDmg) < (EnemiesAround(ally.pos,700) * ally.level * 10) then
			    Cast(GetItemSlot(myHero,3040))
			  elseif myHero.health - incomingDmg < myHero.level * 10 then
			    Cast(GetItemSlot(myHero,3040))
			  end
		    end
		  end

		  if ActivatorMenu.Defensive.zhonyas:Value() then
		    if GetItemSlot(myHero,3157) > 0 and IsReady(GetItemSlot(myHero,3157)) then
		  	  local zhonyaAmount = 95 + myHero.level * 20
			  if incomingDmg > zhonyaAmount and myHero.health < myHero.maxHealth * 0.5 then
			    Cast(GetItemSlot(myHero,3157))
			  elseif (myHero.health - incomingDmg) < (EnemiesAround(ally.pos,700) * ally.level * 10) then
			    Cast(GetItemSlot(myHero,3157))
			  elseif myHero.health - incomingDmg < myHero.level * 10 then
			    Cast(GetItemSlot(myHero,3157))
			  end
		    end
		  end
	    end
	  end
    end
  end
end

function Activator:BuffTimer(unit, buffName)
	local ExpireTime = 0
	for i,buff in pairs(buffs) do
		if buff.name == buffName then
		  ExpireTime = buff.ExpireTime
		  break
		end
	end

	local timer = os.clock() - ExpireTime
	if timer > 0 then
	  return timer
	else
	  return 0
	end
end

function Activator:Zhonya()
  if GetItemSlot(myHero,3157) > 0 and ActivatorMenu.Defensive.zhonyas:Value() and IsReady(GetItemSlot(myHero,3157)) then
	local timer = 2
	if UnitHaveBuff(myHero,"zedrdeathmark") then
	  timer = self:BuffTimer(myHero, "zedrdeathmark")
	end
	if UnitHaveBuff(myHero,"FizzMarinerDoom") then
	  timer = self:BuffTimer(myHero, "FizzMarinerDoom")
	end
	if UnitHaveBuff(myHero,"MordekaiserChildrenOfTheGrave") then
	  timer = self:BuffTimer(myHero, "MordekaiserChildrenOfTheGrave")
	end
	if UnitHaveBuff(myHero,"VladimirHemoplague") then
      timer = self:BuffTimer(myHero, "VladimirHemoplague")
	end
	if timer < 1 and timer > 0 then
	  Cast(GetItemSlot(myHero,3157))
	end
  end
end

function Activator:Potions()
  if UnitHaveBuff(myHero,"Recall") then return end -- InFountain() or
  if GetItemSlot(myHero,2004) > 0 and IsReady(GetItemSlot(myHero,2004)) and not UnitHaveBuff(myHero,"FlaskOfCrystalWater") then
	if EnemiesAround(myHero.pos,1200) > 0 and myHero.mana < 200 then
	  Cast(GetItemSlot(myHero,2004))
	end
  end

  if UnitHaveBuff(myHero,self.items[2003].name) or UnitHaveBuff(myHero,self.items[2010].name) or UnitHaveBuff(myHero,self.items[2041].name) then return end
  if GetItemSlot(myHero,2041) > 0 and IsReady(GetItemSlot(myHero,2041)) then
	if EnemiesAround(myHero.pos,700) > 0 and (myHero.health + 200) < myHero.maxHealth then
	  Cast(GetItemSlot(myHero,2041))
	elseif myHero.health < (myHero.maxHealth * 0.6) then
	  Cast(GetItemSlot(myHero,2041))
	elseif EnemiesAround(myHero.pos,1200) > 0 and myHero.mana < 200 and not UnitHaveBuff(myHero,self.items[2004].name) then
	  Cast(GetItemSlot(myHero,2041))
	end
	return
  end

  if GetItemSlot(myHero,2003) > 0 and IsReady(GetItemSlot(myHero,2003)) then
    if EnemiesAround(myHero.pos,700) > 0 and (myHero.health + 200) < myHero.maxHealth then
	  Cast(GetItemSlot(myHero,2003))
	elseif myHero.health < (myHero.maxHealth * 0.6) then
	  Cast(GetItemSlot(myHero,2003))
	end
	return
  end

  if GetItemSlot(myHero,2010) > 0 and IsReady(GetItemSlot(myHero,2010)) then
    if EnemiesAround(myHero.pos,700) > 0 and (myHero.health + 200) < myHero.maxHealth then
	  Cast(GetItemSlot(myHero,2010))
	elseif myHero.health < (myHero.maxHealth * 0.6) then
	  Cast(GetItemSlot(myHero,2010))
	end
	return
  end
end

function Activator:Randuin()
  if GetItemSlot(myHero,3143) > 0 and ActivatorMenu.Defensive.randuin:Value() and IsReady(GetItemSlot(myHero,3143)) then
	if EnemiesAround(myHero.pos,self.items[3143].range) > 0 then
	  Cast(GetSlotItem(3143))
	end
  end
end

function Activator:Offensive()
  if GetItemSlot(myHero,3153) > 0 and IsReady(GetItemSlot(myHero,3153)) and ActivatorMenu.Offensive.botrk:Value() then
	local target = TargetSelector(self.items[3153].range, TARGET_LESS_CAST, DAMAGE_PHYSICAL, false)
	if ValidTarget(target) then
	  if ActivatorMenu.Offensive.botrkKS:Value() and target.health < myHero:CalcDamage(target, 0.10 * target.maxHealth) then
		Cast(GetItemSlot(myHero,3153), target)
	  end
	  if ActivatorMenu.Offensive.botrkLS:Value() and myHero.health < (myHero.maxHealth * 0.5) then
		Cast(GetItemSlot(myHero,3153), target)
	  end
	  if ActivatorMenu.Offensive.botrkCombo:Value() and self:isCombo() then
		Cast(GetItemSlot(myHero,3153), target)
	  end
	end
  end

  if GetItemSlot(myHero,3146) > 0 and IsReady(GetItemSlot(myHero,3146)) and ActivatorMenu.Offensive.hextech:Value() then
	local target = TargetSelector(self.items[3146].range, TARGET_LESS_CAST, DAMAGE_MAGICAL, false)
	if ValidTarget(target) then
	  if ActivatorMenu.Offensive.hextechKS:Value() and target.health < myHero:CalcDamage(target, 150 + (myHero.ap * 0.4)) then
		Cast(GetItemSlot(myHero,3146), target)
	  end
	  if ActivatorMenu.Offensive.hextechCombo:Value() and self:isCombo() then
		Cast(GetItemSlot(myHero,3146), target)
	  end
	end
  end

  if GetItemSlot(myHero,3144) > 0 and IsReady(GetItemSlot(myHero,3144)) and ActivatorMenu.Offensive.cutlass:Value() then 
	local target = TargetSelector(self.items[3144].range, TARGET_LESS_CAST, DAMAGE_MAGICAL, false)
	if ValidTarget(target) then
	  if ActivatorMenu.Offensive.cutlassKS:Value() and target.health < myHero:CalcDamage(target, 100) then
		Cast(GetItemSlot(myHero,3144), target)
	  end
	  if ActivatorMenu.Offensive.cutlassCombo:Value() and self:isCombo() then
		Cast(GetItemSlot(myHero,3144), target)
	  end
	end
  end

  if GetItemSlot(myHero,3142) > 0 and IsReady(GetItemSlot(myHero,3142)) and ActivatorMenu.Offensive.youmus:Value() then
	local target = TargetSelector(myHero.range, TARGET_LESS_CAST, DAMAGE_PHYSICAL, false)
	if ValidTarget(target) then
	  if ActivatorMenu.Offensive.youmusKS:Value() and target.health < (myHero.health * 0.6) and isCombo() then
	    Cast(GetItemSlot(myHero,3142))
	  end
	  if ActivatorMenu.Offensive.youmusCombo:Value() and self:isCombo() then
		Cast(GetItemSlot(myHero,3142))
	  end
	end
  end

  if ActivatorMenu.Offensive.hydra:Value() then
	if GetItemSlot(myHero,3074) > 0 and IsReady(GetItemSlot(myHero,3074)) and EnemiesAround(myHero.pos,self.items[3074].range) > 0 then
	  Cast(GetItemSlot(myHero,3074))
	elseif GetItemSlot(myHero,3748) > 0 and IsReady(GetItemSlot(myHero,3748)) and EnemiesAround(myHero.pos,self.items[3748].range) > 0 then
	  Cast(GetItemSlot(myHero,3748))
	end
  end
end

function Activator:Exhaust()
  if IsReady(self.summonerSpells.exhaust) and ActivatorMenu.Summoners.exhaust:Value() then
    if ActivatorMenu.Summoners.exhaustCombo and self:isCombo() then
	  local target = TargetSelector(650, TARGET_LESS_CAST, DAMAGE_PHYSICAL, false)
	  if ValidTarget(target) then
		Cast(self.summonerSpells.exhaust, target)
	  end
	end
  end
end

function Activator:Ignite()
  if IsReady(self.summonerSpells.ignite) and ActivatorMenu.Summoners.ignite:Value() then
    for _, target in ipairs(enemies) do
	  if ValidTarget(target,600) then
		local igniteDmg = 50+(myHero.level*20)
		if target.health <= igniteDmg and GetDistance(target) > 500 and EnemiesAround(target.pos, 500) < 2 then
		  Cast(self.summonerSpells.ignite, target)
		end
		if target.health <= (2 * igniteDmg) then
		  if target.lifeSteal > 10 then
		    Cast(self.summonerSpells.ignite, target)
		  end
		  if UnitHaveBuff(target,"RegenerationPotion") or TargetHaveBuff(target,"ItemMiniRegenPotion") or TargetHaveBuff(target,"ItemCrystalFlask") then
		    Cast(self.summonerSpells.ignite, target)
		  end
	      if target.health > myHero.health then
		    Cast(self.summonerSpells.ignite, target)
		  end
		end
	  end
	end
  end
end

function Activator:Smite()
  if IsReady(self.summonerSpells.smite) and ActivatorMenu.Summoners.smite:Value() then
	local smiteDmg = self.smiteDamage[myHero.level]
	for _, mob in pairs(minionManager.objects) do
	  if mob.team == 300 then
	    if ((mob.charName == "SRU_Dragon" and ActivatorMenu.Summoners.smiteDrake:Value()) or (mob.charName == "SRU_Baron" and ActivatorMenu.Summoners.smiteBaron:Value()) or (mob.charName == "SRU_Red" and ActivatorMenu.Summoners.smiteRed:Value()) or (mob.charName == "SRU_Blue" and ActivatorMenu.Summoners.smiteBlue:Value())) and mob.health < smiteDmg then
		  Cast(self.summonerSpells.smite, mob)
		end
	  end
	end
  end
end

local suppression = { "suppression", "Suppression", "SkarnerImpale", "AlZaharNetherGrasp", "UrgotSwap2", "InfiniteDuress"}
local stun = {  "stun", "Stun", "SonaCrescendo", "CurseoftheSadMummy", "EnchantedCrystalArrow", "CassiopeiaPetrifyingGaze", "JaxCounterStrike", "KennenShurikenStorm", "LeonaSolarFlare", "NamiQ", "OrianaDetonateCommand", "Pantheon_LeapBash", "SejuaniGlacialPrisonStart", "ThreshQ", "VeigarEventHorizon", "Imbue", "GnarR"}
local snare = { "snare", "Snare", "LuxLightBindingMis", "DarkBindingMissile", "LeblancSoulShackle", "SwainShadowGrasp", "VarusR", "ZyraGraspingRoots" }
local blind = { "blind", "Blind", "Wither", "BlindingDart", "LuluWTwo" }
local fear = { "fear", "Fear", "Terrify", "HecarimUlt"}
local charm = { "charm", "Charm", "AhriSeduce" }
local taunt = { "taunt", "Taunt", "PuncturingTaunt", "GalioIdolOfDurand"}
				
function Activator:Cleanse()
  if not IsReady(GetItemSlot(myHero,3140)) and not IsReady(GetItemSlot(myHero,3222)) and not IsReady(GetItemSlot(myHero,3139)) and not IsReady(GetItemSlot(myHero,3137)) then return end
  if 100*myHero.health / myHero.maxHealth >= ActivatorMenu.Cleanse.cleanseHP:Value() then return end

  if UnitHaveBuff(myHero,"zedrdeathmark") or UnitHaveBuff(myHero,"FizzMarinerDoom") or UnitHaveBuff(myHero,"MordekaiserChildrenOfTheGrave") or UnitHaveBuff(myHero,"PoppyDiplomaticImmunity") or UnitHaveBuff(myHero,"VladimirHemoplague") then
	DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay)
  end

  if ActivatorMenu.Cleanse.suppression:Value() then
	for _, suppresions in ipairs(suppression) do
	  if UnitHaveBuff(myHero,suppresions) then
		DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay:Value())
	  end
	end
  end

  if ActivatorMenu.Cleanse.stun:Value() then
	for _, stuns in ipairs(stun) do
      if UnitHaveBuff(myHero,stuns) then
		DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay:Value())
	  end
	end
  end

  if ActivatorMenu.Cleanse.blind:Value() then
    for _, blinds in ipairs(blind) do
	  if UnitHaveBuff(myHero,blinds) then
		DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay:Value())
	  end
	end
  end

  if ActivatorMenu.Cleanse.snare:Value() then
	for _, snares in ipairs(snare) do
	  if UnitHaveBuff(myHero,snares) then
		DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay:Value())
	  end
	end
  end

  if myHero.isCharmed and ActivatorMenu.Cleanse.charm:Value() then
	DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay:Value())
  end

  if myHero.isFeared and ActivatorMenu.Cleanse.fear:Value() then
	DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay:Value())
  end

  if myHero.isTaunted and ActivatorMenu.Cleanse.taunt:Value() then
	DelayAction(function() self:Clean() end, ActivatorMenu.Cleanse.cleanseDelay:Value())
  end

end

function Activator:Clean()
  if IsReady(GetItemSlot(myHero,3140)) then
	Cast(GetItemSlot(myHero,3140))
  elseif IsReady(GetItemSlot(myHero,3222)) then
	Cast(GetItemSlot(myHero,3140))
  elseif IsReady(GetItemSlot(myHero,3139)) then
	Cast(GetItemSlot(myHero,3139))
  elseif IsReady(GetItemSlot(myHero,3137)) then
	Cast(GetItemSlot(myHero,3137))
  end
end

function Activator:isCombo()
  return IOW:Mode() == "Combo"
end

class "Ahri"

function Ahri:__init()
  UltOn = false
  Missiles = {}
end

function Ahri:Load()
  self:Menu()
end

function Ahri:Menu()
  MainMenu.Combo:Boolean("Q", "Use Q", true)
  MainMenu.Combo:Boolean("W", "Use W", true)
  MainMenu.Combo:Boolean("E", "Use E", true)
  MainMenu.Combo:Boolean("R", "Use R", true)
  MainMenu.Combo:Info("bs", "R Mode : ")
  MainMenu.Combo:DropDown("RMode", 1, {"Logic", "to mouse"})
  MainMenu.Harass:Boolean("Q", "Use Q", true)
  MainMenu.Harass:Boolean("W", "Use W", true)
  MainMenu.Harass:Boolean("E", "Use E", true)
  MainMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80)
  MainMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
  MainMenu.Killsteal:Boolean("W", "Killsteal with W", true)
  MainMenu.Killsteal:Boolean("E", "Killsteal with E", true)
  if Ignite ~= nil then MainMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
  MainMenu.LastHit:Boolean("Q", "Use Q", true)
  MainMenu.LastHit:Slider("Mana", "if Mana % >", 50, 0, 80)
  MainMenu.LaneClear:Boolean("Q", "Use Q", true)
  MainMenu.LaneClear:Boolean("W", "Use W", false)
  MainMenu.LaneClear:Boolean("E", "Use E", false)
  MainMenu.LaneClear:Slider("Mana", "if Mana % >", 30, 0, 80)
  AntiGapcloser(MainMenu,self:Gapclose())
  Interrupter(MainMenu,self:Interrupt())
end

function Ahri:CreateObj(Object)
  if GetObjectBaseName(Object) == "missile" then
  table.insert(Missiles,Object) 
  end
end

function Ahri:DeleteObj(Object)
  if GetObjectBaseName(Object) == "missile" then
	for i,rip in pairs(Missiles) do
	  if Object.networkID == GetNetworkID(rip) then
	  table.remove(Missiles,i) 
	  end
	end
  end
end

function Ahri:Draw()
  for _,Orb in pairs(Missiles) do
	if Orb ~= nil and Orb.team == myHero.team and GetObjectSpellName(Orb):find("AhriOrb") then
	DrawCustomRectangle(Orb,myHero,50,ARGB(55,255,255,255))
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

function Ahri:Gapclose(unit, spell)
  if unit and IsReady(_E) and GetDistanceSqr(unit) <= (mySpellData[_E].range)^2 then
  Cast(_E,unit)
  end
end

function Ahri:Interrupt(unit, spell)
  if unit and IsReady(_E) and GetDistanceSqr(unit) <= (mySpellData[_E].range)^2 then
  Cast(_E,unit)
  end
end

function Ahri:Combo()
  if not Target then return end
  
  if IsReady(_E) and MainMenu.Combo.E:Value() and GetDistanceSqr(Target) < (mySpellData[_E].range)^2 then
	Cast(_E,Target)
  end
  
  if MainMenu.Combo.R:Value() and GetDistanceSqr(Target) < (mySpellData[_R].range)^2 then
	if MainMenu.Combo.RMode:Value() == 1 then
	  local BestPos = Vector(Target) - (Vector(Target) - Vector(myHero)):perpendicular():normalized() * 350
	  if UltOn and BestPos then
		CastSkillShot(_R,BestPos)
	  elseif IsReady(_R) and BestPos and getdmg("Q",Target)+getdmg("W",Target,myHero,3)+getdmg("E",Target)+getdmg("R",Target,myHero,3) > Target.health+Target.shieldAD+Target.shieldAP then
		CastSkillShot(_R,BestPos)
	  end
	else
	  local AfterTumblePos = myHero.pos + (Vector(mousePos) - myHero.pos):normalized() * 550
	  local DistanceAfterTumble = GetDistance(AfterTumblePos, Target)
	  if UltOn and DistanceAfterTumble < 550 then
		CastSkillShot(_R,mousePos)
	  elseif IsReady(_R) and getdmg("Q",Target)+getdmg("W",Target,myHero,3)+getdmg("E",Target)+getdmg("R",Target,myHero,3) > Target.health+Target.shieldAD+Target.shieldAP then
		CastSkillShot(_R,mousePos) 
	  end
	end
  end
  
  if IsReady(_W) and MainMenu.Combo.W:Value() and GetDistanceSqr(Target) < (mySpellData[_W].range)^2 then
	Cast(_W)
  end
  
  if IsReady(_Q) and MainMenu.Combo.Q:Value() and GetDistanceSqr(Target) < (mySpellData[_Q].range)^2 then
	Cast(_Q,Target)
  end
  
end

function Ahri:Harass()
  if not Target or GetPercentMP(myHero) < MainMenu.Harass.Mana:Value() then return end
  
  if IsReady(_E) and MainMenu.Harass.E:Value() and GetDistanceSqr(Target) < (mySpellData[_E].range)^2 then
	Cast(_E,Target)
  end
  
  if IsReady(_W) and MainMenu.Harass.W:Value() and GetDistanceSqr(Target) < (mySpellData[_W].range)^2 then
	Cast(_W)
  end
  
  if IsReady(_Q) and MainMenu.Harass.Q:Value() and GetDistanceSqr(Target) < (mySpellData[_Q].range)^2 then
	Cast(_Q,Target)
  end
  
end

function Ahri:Killsteal()
  for _,enemy in pairs(GetEnemyHeroes()) do
	if enemy and not enemy.dead and enemy.visible and enemy.bTargetable then
	
	  if Ignite and MainMenu.Misc.Autoignite:Value() then
		if IsReady(Ignite) and enemy.health+enemy.shieldAD+enemy.hpRegen*3 > getdmg("IGNITE",myHero) and GetDistanceSqr(enemy) <= 600^2 then
		  Cast(Ignite,enemy)
		end
	  end
	
	  if IsReady(_W) and GetDistanceSqr(enemy) < (mySpellData[_W].range)^2 and MainMenu.Killsteal.W:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("W",enemy,myHero,3) then
	  Cast(_W)
	  elseif IsReady(_Q) and GetDistanceSqr(enemy) < (mySpellData[_Q].range)^2 and MainMenu.Killsteal.Q:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("Q",enemy) then 
	  Cast(_Q,enemy)
	  elseif IsReady(_E) and GetDistanceSqr(enemy) < (mySpellData[_E].range)^2 and MainMenu.Killsteal.E:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("E",enemy) then
	  Cast(_E,enemy)
	  end
	
	end
  end
end

function Ahri:LaneClear()
  local minion = ClosestMinion(myHero.pos, MINION_ENEMY)
  if GetPercentMP(myHero) >= MainMenu.LaneClear.Mana:Value() then

	  if IsReady(_Q) and MainMenu.LaneClear.Q:Value() then
		local BestPos, BestHit = GetLineFarmPosition(880, 50, MINION_ENEMY)
		if BestPos and BestHit > 2 then 
		  CastSkillShot(_Q, BestPos)
		end
	  end
	
	if minion and not minion.dead and minion.visible then --and minion.bTargetable then
	
	  if IsReady(_W) and MainMenu.LaneClear.W:Value() and GetDistanceSqr(minion) <= (mySpellData[_W].range)^2 and minion.health < getdmg("W",minion,myHero,3) then
		Cast(_W)
	  end

	  if IsReady(_E) and MainMenu.LaneClear.E:Value() and GetDistanceSqr(minion) <= (mySpellData[_E].range)^2 and minion.health < getdmg("E",minion) then
		CastSkillShot(_E,minion.pos)
	  end
	  
	end
	
	if MainMenu.LaneClear.J:Value() then
	
	  if IsReady(_Q) and MainMenu.LaneClear.Q:Value() then
		local BestPos, BestHit = GetLineFarmPosition(880, 50, 300)
		if BestPos and BestHit > 2 then 
		  CastSkillShot(_Q, BestPos)
		end
	  end
	  
	  for i,mobs in pairs(minionManager.objects) do
	  
		if mobs and not mobs.dead and mobs.visible and mobs.bTargetable and mobs.team == 300 then
		
	  if IsReady(_W) and MainMenu.LaneClear.W:Value() and GetDistanceSqr(mobs) <= (mySpellData[_W].range)^2 then
	  CastSpell(_W)
	  end
		
	  if IsReady(_E) and MainMenu.LaneClear.E:Value() and GetDistanceSqr(mobs) <= (mySpellData[_E].range)^2 then
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
	  if IsReady(_Q) and GetDistanceSqr(minion) <= (mySpellData[_Q].range)^2 and MainMenu.Lasthit.Q:Value() and IOW:PredictHealth(minion, 250+GetDistance(minion)/2500) < getdmg("Q",minion) and IOW:PredictHealth(minion, 250+GetDistance(minion)/2500) > 0 then
	  CastSkillShot(_Q,minion.pos)
	  end
	end
  end
end

class "Alistar"

function Alistar:__init()
end

function Alistar:Load()
  self:Menu()
  local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  for i, spell in pairs(CHANELLING_SPELLS) do
	for _,k in pairs(GetEnemyHeroes()) do
	  if spell["Name"] == k.charName then
	  MainMenu.Misc.Interrupt:Boolean(k.charName.."Inter", "On "..k.charName.." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
	  end
	end
  end
end

function Alistar:Menu()
  MainMenu.Combo:Boolean("Q", "Use Q", true)
  MainMenu.Combo:Boolean("WQ", "Use W+Q Combo", true)
  MainMenu.Harass:Boolean("Q", "Use Q", true)
  MainMenu.Harass:Boolean("E", "Use W+Q Combo", true)
  MainMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80)
  MainMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
  MainMenu.Killsteal:Boolean("W", "Killsteal with W", true)
  MainMenu.Killsteal:Boolean("WQ", "Killsteal with W+Q", true)
  if Ignite ~= nil then MainMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
  MainMenu.Misc:Boolean("Eme", "Self-Heal", true)
  MainMenu.Misc:Slider("mpEme", "Minimum Mana %", 25, 0, 100)
  MainMenu.Misc:Slider("hpEme", "Minimum HP%", 70, 0, 100)
  MainMenu.Misc:Boolean("Eally", "Heal Allies", true)
  MainMenu.Misc:Slider("mpEally", "Minimum Mana %", 50, 0, 100)
  MainMenu.Misc:Slider("hpEally", "Minimum HP %", 35, 0, 100)
  AntiGapcloser(MainMenu,self:Gapclose())
  MainMenu.AntiGapcloser:Boolean("Q", "Use Q", true)
  MainMenu.AntiGapcloser:Boolean("W", "Use W", true)
  Interrupter(MainMenu,self:Interrupt())  
  MainMenu.Interrupter:Boolean("Q", "Use Q", true)
  MainMenu.Interrupter:Boolean("W", "Use W", true)
end

function Alistar:Gapclose(unit, spell)
  if unit then
    if IsReady(_Q) and MainMenu.AntiGapcloser.Q:Value() and GetDistanceSqr(unit) <= (mySpellData[_Q].range)^2 then
      Cast(_Q)
    end
    if IsReady(_W) and MainMenu.AntiGapcloser.W:Value() and GetDistanceSqr(unit) <= (mySpellData[_W].range)^2 then
      Cast(_W,unit)
    end
  end
end

function Alistar:Interrupt(unit, spell)
  if unit then
    if IsReady(_Q) and MainMenu.Interrupt.Q:Value() and GetDistanceSqr(unit) <= (mySpellData[_Q].range)^2 then
      Cast(_Q)
    end
    if IsReady(_W) and MainMenu.Interrupt.W:Value() and GetDistanceSqr(unit) <= (mySpellData[_W].range)^2 then
      Cast(_W,unit)
    end
  end
end

function Alistar:Combo()
  if not Target then return end
  
  if IsReady(_Q) and MainMenu.Combo.Q:Value() and GetDistanceSqr(Target) < (mySpellData[_Q].range)^2 then
	Cast(_Q)
  end
  
  if IsReady(_W) and IsReady(_Q) and MainMenu.Combo.WQ:Value() and GetDistanceSqr(Target) < (mySpellData[_W].range)^2 and myHero.mana >= GetSpellData(myHero,_Q).mana + GetSpellData(myHero,_W).mana then
	Cast(_W,Target)
	DelayAction(function() Cast(_Q) end, (math.max(0 , GetDistance(Target) - 500 ) * 0.4 + 25) / 1000)
  end
end

function Alistar:Harass()
  if not Target or GetPercentMP(myHero) < MainMenu.Harass.Mana:Value() then return end
  
  if IsReady(_Q) and MainMenu.Harass.Q:Value() and GetDistanceSqr(Target) < (mySpellData[_Q].range)^2 then
	Cast(_Q)
  end
  
  if IsReady(_W) and IsReady(_Q) and MainMenu.Harass.WQ:Value() and GetDistanceSqr(Target) < (mySpellData[_W].range)^2 and myHero.mana >= GetSpellData(myHero,_Q).mana + GetSpellData(myHero,_W).mana then
	Cast(_W,Target)
	DelayAction(function() Cast(_Q) end, (math.max(0 , GetDistance(Target) - 500 ) * 0.4 + 25) / 1000)
  end
end

function Alistar:Tick()
  if not myHero.isRecalling and MainMenu.Misc.Eme:Value() and MainMenu.Misc.mpEme:Value() <= GetPercentMP(myHero) and myHero.maxHealth-myHero.health > 30+30*GetSpellData(myHero,_E).level+0.2*myHero.ap and GetPercentHP(myHero) <= MainMenu.Misc.hpEme:Value() then
  Cast(_E)
  end
	
  if not myHero.isRecalling and MainMenu.Misc.Eally:Value() and MainMenu.Misc.mpEally:Value() <= GetPercentMP(myHero) then
	for _,ally in pairs(GetAllyHeroes()) do
	  if ally and not ally.isRecalling and ally.valid and GetDistance(ally) <= 575 and ally.maxHealth-ally.health < 15+15*GetSpellData(myHero,_E).level+0.1*myHero.ap and GetPercentHP(v) <= MainMenu.Misc.hpEally:Value() then
	  Cast(_E)
	  end
	end
  end
end

function Alistar:Killsteal()
  for _,enemy in pairs(GetEnemyHeroes()) do
	if enemy and not enemy.dead and enemy.visible and enemy.bTargetable then
	  if Ignite and MainMenu.Misc.Autoignite:Value() then
		if IsReady(Ignite) and enemy.health+enemy.shieldAD+enemy.hpRegen*3 > getdmg("IGNITE",myHero) and GetDistanceSqr(enemy) <= 600^2 then
		Cast(Ignite,enemy)
		end
	  end
		
	  if IsReady(_Q) and GetDistanceSqr(enemy) < (mySpellData[_Q].range)^2 and MainMenu.Killsteal.Q:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("Q",enemy) then 
	  Cast(_Q)
	  elseif IsReady(_W) and GetDistanceSqr(enemy) < (mySpellData[_W].range)^2 and MainMenu.Killsteal.W:Value() and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("W",enemy) then
	  Cast(_W,enemy)
	  elseif IsReady(_W) and IsReady(_Q) and GetDistanceSqr(enemy) < (mySpellData[_W].range)^2 and MainMenu.Killsteal.WQ:Value() and myHero.mana >= GetSpellData(myHero,_Q).mana + GetSpellData(myHero,_W).mana and enemy.health+enemy.shieldAD+enemy.shieldAP < getdmg("Q",enemy)+getdmg("W",enemy) then
	  Cast(_W,enemy)
	  DelayAction(function() Cast(_Q) end, (math.max(0 , GetDistance(enemy) - 500 ) * 0.4 + 25) / 1000)
	  end
	end
  end
end

class "Interrupter"

local CHANELLING_SPELLS = {
	["CaitlynAceintheHole"]         = {Name = "Caitlyn",      DangerLevel = 5, Spellslot = _R},
	["Crowstorm"]                   = {Name = "FiddleSticks", DangerLevel = 5, Spellslot = _R},
	["Drain"]                       = {Name = "FiddleSticks", DangerLevel = 3, Spellslot = _W},
	["GalioIdolOfDurand"]           = {Name = "Galio",        DangerLevel = 5, Spellslot = _R},
	["ReapTheWhirlwind"]            = {Name = "Janna",        DangerLevel = 1, Spellslot = _R},
	["KarthusFallenOne"]            = {Name = "Karthus",      DangerLevel = 5, Spellslot = _R},
	["KatarinaR"]                   = {Name = "Katarina",     DangerLevel = 5, Spellslot = _R},
	["LucianR"]                     = {Name = "Lucian",       DangerLevel = 5, Spellslot = _R},
	["AlZaharNetherGrasp"]          = {Name = "Malzahar",     DangerLevel = 5, Spellslot = _R},
	["Meditate"]                    = {Name = "MasterYi",     DangerLevel = 1, Spellslot = _W},
	["MissFortuneBulletTime"]       = {Name = "MissFortune",  DangerLevel = 5, Spellslot = _R},
	["AbsoluteZero"]                = {Name = "Nunu",         DangerLevel = 4, Spellslot = _R},                        
	["PantheonRJump"]               = {Name = "Pantheon",     DangerLevel = 5, Spellslot = _R},
	["PantheonRFall"]               = {Name = "Pantheon",     DangerLevel = 5, Spellslot = _R},
	["ShenStandUnited"]             = {Name = "Shen",         DangerLevel = 3, Spellslot = _R},
	["Destiny"]                     = {Name = "TwistedFate",  DangerLevel = 3, Spellslot = _R},
	["UrgotSwap2"]                  = {Name = "Urgot",        DangerLevel = 4, Spellslot = _R},
	["VarusQ"]                      = {Name = "Varus",        DangerLevel = 3, Spellslot = _Q},
	["VelkozR"]                     = {Name = "Velkoz",       DangerLevel = 5, Spellslot = _R},
	["InfiniteDuress"]              = {Name = "Warwick",      DangerLevel = 5, Spellslot = _R},
	["XerathLocusOfPower2"]         = {Name = "Xerath",       DangerLevel = 3, Spellslot = _R}
  }
  
function Interrupter:__init(menu, callback)

	self.callbacks = {}
	self.activespells = {}
	Callback.Add("Tick",(function() self:Tick() end) )
	Callback.Add("ProcessSpell",(function(unit, spell) self:ProcessSpell(unit, spell) end) )
	
	if menu then
	  self:AddToMenu(menu)
	end
	
	if callback then
	  self:AddCallback(callback)
	end

end

function Interrupter:AddToMenu(cfg)

  assert(cfg, "Interrupter: menu can't be nil!")
  local SpellAdded = false
  local ObjectNames = {}
  
  for _, enemy in pairs(GetEnemyHeroes()) do
	table.insert(ObjectNames, enemy.charName)
  end
	
  cfg:Section("Interrupter","Interrupter")
  cfg.Interrupter:Boolean("Enabled", "Enabled", true)
  for i, ObjectName in pairs(CHANELLING_SPELLS) do
	if table.contains(ObjectNames, ObjectName) then
	  cfg.Interrupter:Boolean(string.gsub(i, "_", ""), ObjectName.." - "..i, true)
	  SpellAdded = true
	end
  end
	
  if not SpellAdded then
	cfg.Interrupter:Info("Info", "No spell available to interrupt")
  end
	
  self.Menu = cfg
end

function Interrupter:AddCallback(callback)
  assert(callback and type(callback) == "function", "Interrupter: callback is invalid!")
  table.insert(self.callbacks, callback)
end

function Interrupter:TriggerCallbacks(unit, spell)
  for i, callback in pairs(self.callbacks) do
	callback(unit, spell)
  end
end

function Interrupter:ProcessSpell(unit, spell)
  if not self.Menu.Interrupter.Enabled:Value() then return end
  if unit.type == myHero.type and unit.team ~= myHero.team then
	if CHANELLING_SPELLS[spell.name] then
	  if (self.Menu and self.Menu.Interrupter[string.gsub(spell.name, "_", "")]:Value()) or not self.Menu then
		local data = {unit = unit, DangerLevel = CHANELLING_SPELLS[spell.name].DangerLevel, endT = os.clock() + 2.5}
		table.insert(self.activespells, data)
		self:TriggerCallbacks(data.unit, data)
	  end
	end
  end
end

function Interrupter:Tick()
  for i = #self.activespells, 1, -1 do
	if self.activespells[i].endT - os.clock() > 0 then
	  self:TriggerCallbacks(self.activespells[i].unit, self.activespells[i])
	else
	  table.remove(self.activespells, i)
	end
  end
end

class "AntiGapcloser"

local GAPCLOSER_SPELLS = {
	["AatroxQ"]              = "Aatrox",
	["AhriTumble"]           = "Ahri",
	["AkaliShadowDance"]     = "Akali",
	["BandageToss"]          = "Amumu",
	["Headbutt"]             = "Alistar",
	["Valkyrie"]             = "Corki",
	["FioraQ"]               = "Fiora",
	["DianaTeleport"]        = "Diana",
	["EliseSpiderQCast"]     = "Elise",
	["EliseSpiderEDescent"]  = "Elise",
	["Crowstorm"]            = "FiddleSticks",
	["FioraQ"]               = "Fiora",
	["FizzPiercingStrike"]   = "Fizz",
	["GarenQ"]               = "Garen",
	["GnarE"]                = "Gnar",
	["GnarBigE"]             = "Gnar",
	["GragasE"]              = "Gragas",
	["GravesMove"]           = "Graves",
	["HecarimUlt"]           = "Hecarim",
	["IreliaGatotsu"]        = "Irelia",
	["JarvanIVDragonStrike"] = "JarvanIV",
	["JarvanIVCataclysm"]    = "JarvanIV",
	["JaxLeapStrike"]        = "Jax",
	["JayceToTheSkies"]      = "Jayce",	
	["KatarinaE"]            = "Katarina",
	["RiftWalk"]             = "Kassadin",
	["KennenLightningRush"]  = "Kennen",
	["KhazixE"]              = "Khazix",
	["khazixelong"]          = "Khazix",
	["LeblancSlide"]         = "LeBlanc",
	["LeblancSlideM"]        = "LeBlanc",
	["LissandraE"]           = "Lissandra",
	["LucianE"]              = "Lucian",
	["blindmonkqtwo"]        = "LeeSin",
	["LeonaZenithBlade"]     = "Leona",
	["UFSlash"]              = "Malphite",
	["MaokaiUnstableGrowth"] = "Maokai",
	["AlphaStrike"]          = "MasterYi",
	["NautilusAnchorDrag"]   = "Nautilus",
	["Pantheon_LeapBash"]    = "Pantheon",
	["PoppyHeroicCharge"]    = "Poppy",
	["QuinnE"]               = "Quinn",
	["reksaieburrowed"]      = "RekSai",
	["RenektonSliceAndDice"] = "Renekton",
	["RivenTriCleave"]       = "Riven",	
	["SejuaniArcticAssault"] = "Sejuani",
	["ShenShadowDash"]       = "Shen",
	["ShyvanaTransformCast"] = "Shyvana",
	["TalonCutThroat"]       = "Talon",
	["slashCast"]            = "Tryndamere",
	["RocketJump"]           = "Tristana",
	["UdyrBearStance"]       = "Udyr",
	["ViQ"]                  = "Vi",
	["VolibearQ"]            = "Volibear",
	["MonkeyKingNimbus"]     = "MonkeyKing",
	["XenZhaoSweep"]         = "XinZhao",
	["YasuoDashWrapper"]     = "Yasuo"
}

function AntiGapcloser:__init(menu, cb)

	self.callbacks = {}
	self.activespells = {}
	Callback.Add("Tick",(function() self:Tick() end) )
	Callback.Add("ProcessSpell",(function(unit, spell) self:ProcessSpell(unit, spell) end) )
	
	if menu then
		self:AddToMenu(menu)
	end
	
	if cb then
		self:AddCallback(cb)
	end

end

function AntiGapcloser:AddToMenu(cfg)

	assert(cfg, "AntiGapcloser: menu can't be nil!")
	local SpellAdded = false
	local ObjectNames = {}
	
	for _, enemy in pairs(GetEnemyHeroes()) do
		table.insert(ObjectNames, enemy.charName)
	end
	
	cfg:Section("AntiGapcloser", "AntiGapcloser")
	cfg.AntiGapcloser:Boolean("Enabled", "Enabled", true)
	for i, ObjectName in pairs(GAPCLOSER_SPELLS) do
		if table.contains(ObjectNames, ObjectName) then
			cfg.AntiGapcloser:Boolean(string.gsub(i, "_", ""), ObjectName.." - "..i, true)
			SpellAdded = true
		end
	end
	
	if not SpellAdded then
		cfg.AntiGapcloser:Info("Info", "No spell available to interrupt")
	end
	
	self.Menu = cfg

end

function AntiGapcloser:AddCallback(cb)

	assert(cb and type(cb) == "function", "AntiGapcloser: callback is invalid!")
	table.insert(self.callbacks, cb)

end

function AntiGapcloser:TriggerCallbacks(unit, spell)

	for i, callback in ipairs(self.callbacks) do
		callback(unit, spell)
	end

end

function AntiGapcloser:ProcessSpell(unit, spell)
	if not self.Menu.AntiGapcloser.Enabled:Value() then return end
	if unit.team ~= myHero.team then
		if GAPCLOSER_SPELLS[spell.name] then
			local Gapcloser = GAPCLOSER_SPELLS[spell.name]
			if (self.Menu and self.Menu.AntiGapcloser[string.gsub(spell.name, "_", "")]:Value()) or not self.Menu then
				local add = false
				if spell.target and spell.target.isMe then
					add = true
					startPos = Vector(unit)
					endPos = myHero
				elseif not spell.target then
					local endPos1 = Vector(unit) + 300 * (Vector(spell.endPos) - Vector(unit)):normalized()
					local endPos2 = Vector(unit) + 100 * (Vector(spell.endPos) - Vector(unit)):normalized()
				 
					if (_GetDistanceSqr(unit) > _GetDistanceSqr(endPos1) or _GetDistanceSqr(unit) > _GetDistanceSqr(endPos2))  then
						add = true
					end
				end

				if add then
					local data = {unit = unit, spell = spell.name, startT = os.clock(), endT = os.clock() + 1, startPos = startPos, endPos = endPos}
					table.insert(self.activespells, data)
					self:TriggerCallbacks(data.unit, data)
				end
			end
		end
	end

end

function AntiGapcloser:Tick()

	for i = #self.activespells, 1, -1 do
		if self.activespells[i].endT - os.clock() > 0 then
			self:TriggerCallbacks(self.activespells[i].unit, self.activespells[i])
		else
			table.remove(self.activespells, i)
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

local spellsFile = COMMON_PATH.."missedspells.txt"
local spellslist = {}
local textlist = ""
local spellexists = false
local spelltype = "Unknown"

function writeConfigsspells()
	local file = io.open(spellsFile, "w")
	if file then
		textlist = "return {"
		for i=1,#spellslist do
			textlist = textlist.."'"..spellslist[i].."', "
		end
		textlist = textlist.."}"
		if spellslist[1] ~=nil then
			file:write(textlist)
			file:close()
		end
	end
end

if FileExist(spellsFile) then spellslist = dofile(spellsFile) end

local Others = {"Recall","recall","OdinCaptureChannel","LanternWAlly","varusemissiledummy","khazixqevo","khazixwevo","khazixeevo","khazixrevo","braumedummyvoezreal","braumedummyvonami","braumedummyvocaitlyn","braumedummyvoriven","braumedummyvodraven","braumedummyvoashe"}
local Items = {"RegenerationPotion","FlaskOfCrystalWater","ItemCrystalFlask","ItemMiniRegenPotion","PotionOfBrilliance","PotionOfElusiveness","PotionOfGiantStrength","OracleElixirSight","OracleExtractSight","VisionWard","SightWard","sightward","ItemGhostWard","ItemMiniWard","ElixirOfRage","ElixirOfIllumination","wrigglelantern","DeathfireGrasp","HextechGunblade","shurelyascrest","IronStylus","ZhonyasHourglass","YoumusBlade","randuinsomen","RanduinsOmen","Mourning","OdinEntropicClaymore","BilgewaterCutlass","QuicksilverSash","HextechSweeper","ItemGlacialSpike","ItemMercurial","ItemWraithCollar","ItemSoTD","ItemMorellosBane","ItemPromote","ItemTiamatCleave","Muramana","ItemSeraphsEmbrace","ItemSwordOfFeastAndFamine","ItemFaithShaker","OdynsVeil","ItemHorn","ItemPoroSnack","ItemBlackfireTorch","HealthBomb","ItemDervishBlade","TrinketTotemLvl1","TrinketTotemLvl2","TrinketTotemLvl3","TrinketTotemLvl3B","TrinketSweeperLvl1","TrinketSweeperLvl2","TrinketSweeperLvl3","TrinketOrbLvl1","TrinketOrbLvl2","TrinketOrbLvl3","OdinTrinketRevive","RelicMinorSpotter","RelicSpotter","RelicGreaterLantern","RelicLantern","RelicSmallLantern","ItemFeralFlare","trinketorblvl2","trinketsweeperlvl2","trinkettotemlvl2","SpiritLantern"}
local MSpells = {"JayceStaticField","JayceToTheSkies","JayceThunderingBlow","Takedown","Pounce","Swipe","EliseSpiderQCast","EliseSpiderW","EliseSpiderEInitial","elisespidere","elisespideredescent"}
local PSpells = {"CaitlynHeadshotMissile","RumbleOverheatAttack","JarvanIVMartialCadenceAttack","ShenKiAttack","MasterYiDoubleStrike","sonahymnofvalorattackupgrade","sonaariaofperseveranceupgrade","sonasongofdiscordattackupgrade","NocturneUmbraBladesAttack","NautilusRavageStrikeAttack","ZiggsPassiveAttack","QuinnWEnhanced","LucianPassiveAttack","SkarnerPassiveAttack","KarthusDeathDefiedBuff"}

local QSpells = {"TrundleQ","LeonaShieldOfDaybreakAttack","XenZhaoThrust","NautilusAnchorDragMissile","RocketGrabMissile","VayneTumbleAttack","VayneTumbleUltAttack","NidaleeTakedownAttack","ShyvanaDoubleAttackHit","ShyvanaDoubleAttackHitDragon","frostarrow","FrostArrow","MonkeyKingQAttack","MaokaiTrunkLineMissile","FlashFrostSpell","xeratharcanopulsedamage","xeratharcanopulsedamageextended","xeratharcanopulsedarkiron","xeratharcanopulsediextended","SpiralBladeMissile","EzrealMysticShotMissile","EzrealMysticShotPulseMissile","jayceshockblast","BrandBlazeMissile","UdyrTigerAttack","TalonNoxianDiplomacyAttack","LuluQMissile","GarenSlash2","VolibearQAttack","dravenspinningattack","karmaheavenlywavec","ZiggsQSpell","UrgotHeatseekingHomeMissile","UrgotHeatseekingLineMissile","JavelinToss","RivenTriCleave","namiqmissile","NasusQAttack","BlindMonkQOne","ThreshQInternal","threshqinternal","QuinnQMissile","LissandraQMissile","EliseHumanQ","GarenQAttack","JinxQAttack","JinxQAttack2","yasuoq","xeratharcanopulse2","VelkozQMissile","KogMawQMis","BraumQMissile","KarthusLayWasteA1","KarthusLayWasteA2","KarthusLayWasteA3","MaokaiSapling2Boom"}
local WSpells = {"KogMawBioArcaneBarrageAttack","SivirWAttack","TwitchVenomCaskMissile","gravessmokegrenadeboom","mordekaisercreepingdeath","DrainChannel","jaycehypercharge","redcardpreattack","goldcardpreattack","bluecardpreattack","RenektonExecute","RenektonSuperExecute","EzrealEssenceFluxMissile","DariusNoxianTacticsONHAttack","UdyrTurtleAttack","talonrakemissileone","LuluWTwo","ObduracyAttack","KennenMegaProc","NautilusWideswingAttack","NautilusBackswingAttack","XerathLocusOfPower","yoricksummondecayed","Bushwhack","karmaspiritbondc","SejuaniBasicAttackW","AatroxWONHAttackLife","AatroxWONHAttackPower","JinxWMissile","GragasWAttack","braumwdummyspell","syndrawcast"}
local ESpells = {"KogMawVoidOozeMissile","ToxicShotAttack","LeonaZenithBladeMissile","PowerFistAttack","VayneCondemnMissile","ShyvanaFireballMissile","maokaisapling2boom","VarusEMissile","CaitlynEntrapmentMissile","jayceaccelerationgate","syndrae5","JudicatorRighteousFuryAttack","UdyrBearAttack","RumbleGrenadeMissile","Slash","hecarimrampattack","ziggse2","UrgotPlasmaGrenadeBoom","SkarnerFractureMissile","YorickSummonRavenous","BlindMonkEOne","EliseHumanE","PrimalSurge","Swipe","ViEAttack","LissandraEMissile","yasuodummyspell","XerathMageSpearMissile","RengarEFinal","RengarEFinalMAX","KarthusDefileSoundDummy2"}
local RSpells = {"Pantheon_GrandSkyfall_Fall","LuxMaliceCannonMis","infiniteduresschannel","JarvanIVCataclysmAttack","jarvanivcataclysmattack","VayneUltAttack","RumbleCarpetBombDummy","ShyvanaTransformLeap","jaycepassiverangedattack", "jaycepassivemeleeattack","jaycestancegth","MissileBarrageMissile","SprayandPrayAttack","jaxrelentlessattack","syndrarcasttime","InfernalGuardian","UdyrPhoenixAttack","FioraDanceStrike","xeratharcanebarragedi","NamiRMissile","HallucinateFull","QuinnRFinale","lissandrarenemy","SejuaniGlacialPrisonCast","yasuordummyspell","xerathlocuspulse","tempyasuormissile","PantheonRFall"}

local casttype2 = {"blindmonkqtwo","blindmonkwtwo","blindmonketwo","infernalguardianguide","KennenMegaProc","sonaariaofperseveranceupgrade","redcardpreattack","fizzjumptwo","fizzjumpbuffer","gragasbarrelrolltoggle","LeblancSlideM","luxlightstriketoggle","UrgotHeatseekingHomeMissile","xeratharcanopulseextended","xeratharcanopulsedamageextended","XenZhaoThrust3","ziggswtoggle","khazixwlong","khazixelong","renektondice","SejuaniNorthernWinds","shyvanafireballdragon2","shyvanaimmolatedragon","ShyvanaDoubleAttackHitDragon","talonshadowassaulttoggle","viktorchaosstormguide","ViktorGravitonFieldAugment","zedw2","ZedR2","khazixqlong","AatroxWONHAttackLife"}
local casttype3 = {"sonasongofdiscordattackupgrade","bluecardpreattack","LeblancSoulShackleM","UdyrPhoenixStance","RenektonSuperExecute"}
local casttype4 = {"FrostShot","PowerFist","DariusNoxianTacticsONH","EliseR","EliseRSpider","JaxEmpowerTwo","JaxRelentlessAssault","JayceStanceHtG","jaycestancegth","jaycehypercharge","JudicatorRighteousFury","kennenlrcancel","KogMawBioArcaneBarrage","LissandraE","MordekaiserMaceOfSpades","mordekaisercotgguide","NasusQ","Takedown","NocturneParanoia","QuinnR","RengarQ","Deceive","HallucinateFull","DeathsCaressFull","SivirW","ThreshQInternal","threshqinternal","PickACard","goldcardlock","redcardlock","bluecardlock","FullAutomatic","VayneTumble","MonkeyKingDoubleAttack","YorickSpectral","ViE","VorpalSpikes","FizzSeastonePassive","GarenSlash3","HecarimRamp","leblancslidereturn","leblancslidereturnm","Obduracy","UdyrTigerStance","UdyrTurtleStance","UdyrBearStance","UrgotHeatseekingMissile","XenZhaoComboTarget","dravenspinning","dravenrdoublecast","FioraDance","LeonaShieldOfDaybreak","MaokaiDrain3","NautilusPiercingGaze","RenektonPreExecute","RivenFengShuiEngine","ShyvanaDoubleAttack","shyvanadoubleattackdragon","SyndraW","TalonNoxianDiplomacy","TalonCutthroat","talonrakemissileone","TrundleTrollSmash","VolibearQ","AatroxW","aatroxw2","AatroxWONHAttackLife","JinxQ","GarenQ","yasuoq","XerathArcanopulseChargeUp","XerathLocusOfPower2","xerathlocuspulse","velkozqsplitactivate","NetherBlade","GragasQToggle","GragasW"}
local casttype5 = {"VarusQ","ZacE","ViQ"}
local casttype6 = {"VelkozQMissile","KogMawQMis","RengarEFinal","RengarEFinalMAX","BraumQMissile","KarthusDefileSoundDummy2"}

function getSpellType(unit, spellName)
	spelltype = "Unknown"
	casttype = 1
	if unit ~= nil and GetObjectType(unit) == AIHeroClient then
		if spellName == nil or GetCastName(unit,_Q) == nil or GetCastName(unit,_W) == nil or GetCastName(unit,_E) == nil or GetCastName(unit,_R) == nil then
			return "Error name nil", casttype
		end
		if (spellName:find("BasicAttack") and spellName ~= "SejuaniBasicAttackW") or spellName:find("basicattack") or spellName:find("JayceRangedAttack") or spellName == "SonaHymnofValorAttack" or spellName == "SonaSongofDiscordAttack" or spellName == "SonaAriaofPerseveranceAttack" or spellName == "ObduracyAttack" then
			spelltype = "BAttack"
		elseif spellName:find("CritAttack") or spellName:find("critattack") then
			spelltype = "CAttack"
		elseif GetCastName(unit,_Q):find(spellName) then
			spelltype = "Q"
		elseif GetCastName(unit,_W):find(spellName) then
			spelltype = "W"
		elseif GetCastName(unit,_E):find(spellName) then
			spelltype = "E"
		elseif GetCastName(unit,_R):find(spellName) then
			spelltype = "R"
		elseif spellName:find("Summoner") or spellName:find("summoner") or spellName == "teleportcancel" then
			spelltype = "Summoner"
		else
			if spelltype == "Unknown" then
				for i=1,#Others do
					if spellName:find(Others[i]) then
						spelltype = "Other"
					end
				end
			end
			if spelltype == "Unknown" then
				for i=1,#Items do
					if spellName:find(Items[i]) then
						spelltype = "Item"
					end
				end
			end
			if spelltype == "Unknown" then
				for i=1,#PSpells do
					if spellName:find(PSpells[i]) then
						spelltype = "P"
					end
				end
			end
			if spelltype == "Unknown" then
				for i=1,#QSpells do
					if spellName:find(QSpells[i]) then
						spelltype = "Q"
					end
				end
			end
			if spelltype == "Unknown" then
				for i=1,#WSpells do
					if spellName:find(WSpells[i]) then
						spelltype = "W"
					end
				end
			end
			if spelltype == "Unknown" then
				for i=1,#ESpells do
					if spellName:find(ESpells[i]) then
						spelltype = "E"
					end
				end
			end
			if spelltype == "Unknown" then
				for i=1,#RSpells do
					if spellName:find(RSpells[i]) then
						spelltype = "R"
					end
				end
			end
		end
		for i=1,#MSpells do
			if spellName == MSpells[i] then
				spelltype = spelltype.."M"
			end
		end
		local spellexists = spelltype ~= "Unknown"
		if #spellslist > 0 and not spellexists then
			for i=1,#spellslist do
				if spellName == spellslist[i] then
					spellexists = true
				end
			end
		end
		if not spellexists then
			table.insert(spellslist, spellName)
			writeConfigsspells()
			PrintChat("SpellType - Unknown spell: "..spellName)
		end
	end
	for i=1,#casttype2 do
		if spellName == casttype2[i] then casttype = 2 end
	end
	for i=1,#casttype3 do
		if spellName == casttype3[i] then casttype = 3 end
	end
	for i=1,#casttype4 do
		if spellName == casttype4[i] then casttype = 4 end
	end
	for i=1,#casttype5 do
		if spellName == casttype5[i] then casttype = 5 end
	end
	for i=1,#casttype6 do
		if spellName == casttype6[i] then casttype = 6 end
	end

	return spelltype, casttype
end
