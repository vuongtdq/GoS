DeftLibVersion = 29

require('Inspired')
require('IPrediction')

AutoUpdate("/D3ftsu/GoS/master/Common/DeftLib.lua","/D3ftsu/GoS/master/Common/DeftLib.version","Common\\DeftLib.lua",DeftLibVersion)

SpellData = {
  ["Aatrox"] = {
		[_Q]  = { Name = "AatroxQ", Range = 650, Speed = 2000, Delay = 0.6, Width = 250, collision = false, type = "circular", IsDangerous = true},
		[_E]  = { Name = "AatroxE", Range = 1075, Speed = 1250, Delay = 0.25, Width = 35, collision = false, type = "linear", IsDangerous = false},
	},
  ["Ahri"] = {
		[_Q]  = { Name = "AhriOrbofDeception", Range = 880, Speed = 2500, Delay = 0.25, Width = 100, collision = false, aoe = false, type = "linear", IsDangerous = false},
 	        [-1]  = { Name = "AhriOrbReturn", Range = 1000, Speed = 900, Delay = 0.25, Width = 100, collision = false, aoe = false, type = "linear", IsDangerous = false},
		[_E]  = { Name = "AhriSeduce", Range = 1000, Speed = 1550, Delay = 0.25,  Width = 60, collision = true, aoe = false, type = "linear", IsDangerous = true},
	},
  ["Ashe"] = {
		[_Q]  = { Name = "FrostShot", Range = 600},
		[_W]  = { Name = "Volley", Range = 1250, Speed = 1500, Delay = 0.25, Width = 60, collision = true, aoe = false, type = "cone", IsDangerous = false},
		[_E]  = { Name = GetCastName(myHero,_E), Range = 20000, Speed = 1500, Delay = 0.5, Width = 1400, collision = false, aoe = false, type = "linear", IsDangerous = false},
		[_R]  = { Name = "EnchantedCrystalArrow", Range = 20000, Speed = 1600, Delay = 0.5, Width = 100, collision = false, aoe = false, type = "linear", IsDangerous = true}
        },
  ["Azir"] = {
		[_Q] = { Name = "AzirQ", Range = 950, Speed = 1600, Width = 80, collision = false, aoe = false, type = "linear", IsDangerous = false},
		[_W] = { Name = "AzirW", Range = 450, Speed = math.huge, Width = 400, collision = false, aoe = false, type = "circular"},
		[_E] = { Name = "AzirE", Range = 1100, Speed = 1200, Delay = 0.25, Width = 60, collision = true, aoe = false, type = "linear", IsDangerous = false},
		[_R] = { Name = "AzirR", Range = 520, Speed = 1300, Delay = 0.25, Width = 600, collision = false, aoe = true, type = "linear", IsDangerous = true}
	},
  ["Blitzcrank"] = {
		[_Q] = { Name = "RocketGrabMissile", Range = 975, Speed = 1800, Width = 70, Delay = 0.25, collision = true, aoe = false, type = "linear", IsDangerous = true},
		[_R] = { Name = "StaticField", Range = 0, Speed = math.huge, Width = 600, Delay = 0.25, collision = false, aoe = false, type = "circular", IsDangerous = false}
	},
  ["Cassiopeia"] = {
		[_Q] = { Name = "CassiopeiaNoxiousBlast", ProjectileName = "CassNoxiousSnakePlane_green.troy", Range = 850, Speed = math.huge, Delay = 0.75, Width = 100, collision = false, aoe = true, type = "circular", IsDangerous = false},
		[_W] = { Name = "CassiopeiaMiasma", ProjectileName = "", Range = 925, Speed = 2500, Delay = 0.25, Width = 90, collision = false, aoe = true, type = "circular", IsDangerous = false},
		[_R] = { Name = "CassiopeiaPetrifyingGaze",  ProjectileName = "", Range = 825, Speed = math.huge, Delay = 0.6, Width = 80, collision = false, aoe = true, type = "cone", IsDangerous = true}
	},
  ["Chogath"] = {
		[_Q] = { Name = "Rupture", Range = 950, Speed = math.huge, Delay = 0.6, Width = 250, collision = false, aoe = true, type = "circular", IsDangerous = true},
		[_W] = { Name = "FeralScream", Range = 650, Speed = math.huge, Delay = 0.25, Width = 210, collision = false, aoe = false, type = "cone", IsDangerous = false}
	},
  ["Ekko"] = { 
  	        [_Q] = { Name = "EkkoQ", Range = 925, Speed = 1050, Delay = 0.25, Width = 140, collision = false, aoe = false, type = "linear", IsDangerous = false},
  	        [_W] = { Name = "EkkoW", Range = 1700, Speed = math.huge, Delay = 3, Width = 400, collision = false, aoe = true, type = "circular", IsDangerous = false}
        },
  ["Galio"] = {
  	        [_Q] = { Name = "GalioResoluteSmite", Range = 900, Speed = 1300, Delay = 0.25, Width = 200, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_E] = { Name = "GalioRighteousGust", Range = 1200, Speed = 250, Delay = 0.25, Width = 120, collision = false, aoe = false, type = "linear", IsDangerous = false}
        },
  ["Jinx"] = {
		[_W] = { Name = "JinxW", Range = 1450, Speed = 3300, Delay = 0.6, Width = 60, collision = true, aoe = false, type = "circular", IsDangerous = true},
		[_E] = { Name = "JinxE", Range = 900, Speed = 1750, Delay = 0.6, Width = 120, collision = false, aoe = false, type = "circular", IsDangerous = true},
		[_R] = { Name = "JinxR", Range = 20000, Speed = 1700, Delay = 0.316, Width = 140, collision = false, aoe = true, type = "cone", IsDangerous = true}
	},
  ["Kalista"] = {
		[_Q] = { Name = "KalistaMysticShot", Range = 1150, Speed = 1700, Delay = 0.25, Width = 50, collision = true, aoe = false, type = "linear", IsDangerous = false}
	},
  ["Lucian"] = {
        [_W] = { Name = "LucianW", Range = 1000, Speed = 1600, Delay = 0.3, Width = 55, collision = true, aoe = false, type = "circular", IsDangerous = false}
        },
  ["Nidalee"] = {
		[_Q] = { Name = "JavelinToss", Range = 1450, Speed = 1350, Delay = 0.25, Width = 37, collision = true, aoe = false, type = "linear", IsDangerous = true},
		[_W] = { Name = "", Range = 900, Speed = math.huge, Delay = 1, Width = 50, collision = false, aoe = false, type = "circular", IsDangerous = false}
	},
  ["Orianna"] = {
                [_Q] = { Name = "OriannasQ", Range = 825, Speed = 1200, Delay = 0, Width = 80, collision = false, aoe = false, type = "circular", IsDangerous = false}
        },
  ["Riven"] = {
                [_R] = { Name = "rivenizunablade", Range = 1100, Speed = 1600, Delay = 0.25, Width = 200, collision = false, aoe = false, type = "circular", IsDangerous = false}
        },
  ["Rumble"] = {
		[_E] = { Name = "RumbleGrenadeMissile", Range = 850, Speed = 1200, Delay = 0.25, Width = 90, collision = true, aoe = false, type = "linear", IsDangerous = false},
		[_R] = { Name = "RumbleCarpetBomb", Range = 1700, Speed = 1200, Delay = 0.25, Width = 90, collision = false, aoe = false, type = "linear", IsDangerous = false}
	},
  ["Ryze"] = {
  	        [_Q] = { Name = "Overload", Range = 900, Speed = 1700, Delay = 0.25, Width = 55, collision = true, aoe = false, type = "linear", IsDangerous = false}
        },
  ["Sivir"] = {
  	        [_Q] = { Name = "SivirQ", Range = 1075, Speed = 1350, Delay = 0.25, Width = 85, collision = false, aoe = false, type = "linear", IsDangerous = false}
        },
  ["Syndra"] = {
  	        [_Q] = { Name = "SyndraQ", Range = 790, Speed = math.huge, Delay = 0.25, Width = 125, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_W] = { Name = "syndrawcast", Range = 925, Speed = math.huge, Delay = 0.25, Width = 190, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_E] = { Name = "SyndraE", Range = 1250, Speed = 2500, Delay = 0.25, Width = 45, collision = false, aoe = false, type = "cone", IsDangerous = false}
       },
   ["Thresh"] = {
  	        [_Q] = { Name = "ThreshQ", Range = 1000, Speed = 1200, Delay = 0.5, Width = 80, collision = true, aoe = false, type = "linear", IsDangerous = true},
  	        [_E] = { Name = "ThreshE", Range = 515, Speed = math.huge, Delay = 0.3, Width = 160, collision = false, aoe = false, type = "linear", IsDangerous = false}
       },
   ["Twitch"] = {
   	        [_W] = { Name = "TwitchVenomCask", Range = 950, Speed = 1750, Delay = 0.5, Width = 275, collision = false, aoe = false, type = "circular", IsDangerous = false}
       },
   ["Viktor"] = {
  	        [_W] = { Name = "ViktorGravitonField", Range = 700, Speed = math.huge, Delay = 0.5, Width = 300, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_R] = { Name = "ViktorChaosStorm", Range = 700, Speed = math.huge, Delay = 0.25, Width = 450, collision = false, aoe = false, type = "circular", IsDangerous = false}
       },
   ["Xerath"] = {
   	        [_Q] = { Name = "xeratharcanopulse2", Range = 750, Speed = math.huge, Delay = 0.6, Width = 100, collision = false, aoe = false, type = "linear", IsDangerous = false},
  	        [_W] = { Name = "XerathArcaneBarrage2", Range = 1150, Speed = math.huge, Delay = 0.65, Width = 200, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_E] = { Name = "XerathMageSpear", Range = 975, Speed = 1200, Delay = 0, Width = 60, collision = true, aoe = false, type = "linear", IsDangerous = true},
                [_R] = { Name = "xerathrmissilewrapper", Range = GetCastRange(myHero,_R), Speed = math.huge, Delay = 0.5, Width = 180, collision = false, aoe = false, type = "circular", IsDangerous = true}
       }
}

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
    ["Vayne"]      = {Spellslot = _Q, Range = 300, Delay = 250},
    ["Riven"]      = {Spellslot = _E, Range = 325, Delay = 250},
    ["Ezreal"]     = {Spellslot = _E, Range = 450, Delay = 250},
    ["Caitlyn"]    = {Spellslot = _E, Range = 400, Delay = 250},
    ["Kassadin"]   = {Spellslot = _R, Range = 700, Delay = 250},
    ["Graves"]     = {Spellslot = _E, Range = 425, Delay = 250},
    ["Renekton"]   = {Spellslot = _E, Range = 450, Delay = 250},
    ["Aatrox"]     = {Spellslot = _Q, Range = 650, Delay = 250},
    ["Gragas"]     = {Spellslot = _E, Range = 600, delay = 250},
    ["Khazix"]     = {Spellslot = _E, Range = 600, Delay = 250},
    ["Lucian"]     = {Spellslot = _E, Range = 425, Delay = 250},
    ["Sejuani"]    = {Spellslot = _Q, Range = 650, Delay = 250},
    ["Shen"]       = {Spellslot = _E, Range = 575, Delay = 250},
    ["Tryndamere"] = {Spellslot = _E, Range = 660, Delay = 250},
    ["Tristana"]   = {Spellslot = _W, Range = 900, Delay = 250},
    ["Corki"]      = {Spellslot = _W, Range = 800, Delay = 250},
}

local LudensStacks = 0
Turrets = {}
maxTurrets = 0

OnObjectLoad(function(Object)
  if GetObjectType(Object) == Obj_AI_Turret and GetTeam(Object) ~= GetTeam(myHero) then
  insert(Object)
  end
end)

OnCreateObj(function(Object) 
  if GetObjectType(Object) == Obj_AI_Turret and GetTeam(Object) ~= GetTeam(myHero) then
  insert(Object)
  end
end)

function IsUnderTower(unit,team)
  local team = team or MINION_ENEMY
  for i,turret in pairs(Turrets) do
    if GetTeam(turret) == GetTeam(team) and GetDistance(unit, GetOrigin(turret)) <= 950 then
    return true
    end
  end
  return false
end

function insert(turret)
  local function FindSpot()
    for i=1, maxTurrets do
      local turret = Turrets[i]
      if not turret or not IsObjectAlive(turret) then
      return i
      end
    end
    maxTurrets = maxTurrets + 1
    return maxTurrets
  end
  Turrets[FindSpot()] = turret
end

local PredictionMenu = MenuConfig("PredictionMenu", "PredictionMenu")
PredictionMenu:DropDown("Pred", "Choose Prediction : ", 1, {"GoS", "IPrediction"})
	
IPredSpells = {}
function Cast(spell, target, source, speed, delay, range, width, hitchance, coll, collM, collH, Name, type)
	local source = source or myHero
	local hitchance = hitchance or 3
	if PredictionMenu.Pred:Value() == 1 then
	        local speed = speed or SpellData[GetObjectName(myHero)][spell].Speed or math.huge
		local delay = delay or SpellData[GetObjectName(myHero)][spell].Delay or 0
		local range = range or SpellData[GetObjectName(myHero)][spell].Range
		local width = width or SpellData[GetObjectName(myHero)][spell].Width
		local coll = coll or SpellData[GetObjectName(myHero)][spell].collision
		local hc = hc or 1
		if ValidTarget(target, range+width) then
                  local Predicted = GetPredictionForPlayer(GetOrigin(source),target,GetMoveSpeed(target), speed, delay*1000, range, width, coll, true)
                  if Predicted.HitChance >= hc then
                  CastSkillShot(spell, Predicted.PredPos)
                  end
                end
        end
	
	if PredictionMenu.Pred:Value() == 2 then
	  if not IPredSpells[GetObjectName(myHero)] then
		IPredSpells[GetObjectName(myHero)] = {}
	  end
	  if not IPredSpells[GetObjectName(myHero)][spell] then
		local speed = speed or SpellData[GetObjectName(myHero)][spell].Speed or math.huge
		local delay = delay or SpellData[GetObjectName(myHero)][spell].Delay or 0
		local range = range or SpellData[GetObjectName(myHero)][spell].Range
		local width = width or SpellData[GetObjectName(myHero)][spell].Width
		local coll = coll or SpellData[GetObjectName(myHero)][spell].collision
		local collM = collM or true
		local collH = collH or true
		local types = type or SpellData[GetObjectName(myHero)][spell].type or "linear"
		local Name = Name or SpellData[GetObjectName(myHero)][spell].Name
		local Predicted = IPrediction.Prediction({name=Name, range=range, speed=speed, delay=delay, width=width, type=types, collision=coll, collisionM=collM, collisionH=collH})
		IPredSpells[GetObjectName(myHero)][spell] = Predicted
	  end
	  local hit, pos = IPredSpells[GetObjectName(myHero)][spell]:Predict(target,source)
	  if hit >= hitchance then
		CastSkillShot(spell, pos)
          end
        end
end

function Cast2(spell, target, source, speed, delay, range, width, hitchance, coll, collM, collH, Name, type)
	local source = source or myHero
	local hitchance = hitchance or 3
	if PredictionMenu.Pred:Value() == 1 then
	        local speed = speed or SpellData[GetObjectName(myHero)][spell].Speed or math.huge
		local delay = delay or SpellData[GetObjectName(myHero)][spell].Delay or 0
		local range = range or SpellData[GetObjectName(myHero)][spell].Range
		local width = width or SpellData[GetObjectName(myHero)][spell].Width
		local coll = coll or SpellData[GetObjectName(myHero)][spell].collision
		local hc = hc or 1
                if ValidTarget(target, range+width) then
                  local Predicted = GetPredictionForPlayer(GetOrigin(source),target,GetMoveSpeed(target), speed, delay*1000, range, width, coll, true)
                  if Predicted.HitChance >= hc then
                  CastSkillShot2(spell, Predicted.PredPos)
                  end
                end
        end
	
	if PredictionMenu.Pred:Value() == 2 then
	  if not IPredSpells[GetObjectName(myHero)] then
		IPredSpells[GetObjectName(myHero)] = {}
	  end
	  if not IPredSpells[GetObjectName(myHero)][spell] then
		local speed = speed or SpellData[GetObjectName(myHero)][spell].Speed or math.huge
		local delay = delay or SpellData[GetObjectName(myHero)][spell].Delay or 0
		local range = range or SpellData[GetObjectName(myHero)][spell].Range
		local width = width or SpellData[GetObjectName(myHero)][spell].Width
		local coll = coll or SpellData[GetObjectName(myHero)][spell].collision
		local collM = collM or true
		local collH = collH or true
		local types = type or SpellData[GetObjectName(myHero)][spell].type or "linear"
		local Name = Name or SpellData[GetObjectName(myHero)][spell].Name
		local Predicted = IPrediction.Prediction({name=Name, range=range, speed=speed, delay=delay, width=width, type=types, collision=coll, collisionM=collM, collisionH=collH})
		IPredSpells[GetObjectName(myHero)][spell] = Predicted
	  end
	  local hit, pos = IPredSpells[GetObjectName(myHero)][spell]:Predict(target,myHero)
	  if hit >= hitchance then
		CastSkillShot2(spell, pos)
          end
        end
end

function GetPredictedPos(unit, time) 
  if unit == nil then return end
  local time = time or 125
  return GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),math.huge,time,math.huge,1,false,false).PredPos
 -- return Prediction.Core.PredictPos(unit, time/1000)
end

function EnemiesAround2(pos, range, time)
  local c = 0
  local time = time or 250
  if pos == nil then return 0 end
  for k,v in pairs(GetEnemyHeroes()) do 
    if v and ValidTarget(v) and GetDistanceSqr(pos,GetPredictedPos(v, time)) < range*range then
      c = c + 1
    end
  end
  return c
end

function IsFacing(target,range,unit) 
    local range = range or 20000
    local unit = unit or myHero
    if GetDistance(unit,target) < range then return end
    return GetDistance(GetPredictedPos(unit), target) < GetDistance(unit, target)
end

function IsMe(unit)
    return unit == GetMyHero()
end

function IsAlly(unit)
    if unit == GetMyHero() then return end
    return GetTeam(unit) == GetTeam(myHero)
end

function IsEnemy(unit)
    return GetTeam(unit) ~= GetTeam(myHero)
end

function Ludens()
    return LudensStacks == 100 and 100+0.1*GetBonusAP(myHero) or 0
end

Shield = {}
Recalling = {}
Slowed = {}
Immobile = {}
toQSS = false
ccstun = {5,29,30,24}
ccslow = {9,21,22,28}
RecallTable = {"Recall", "RecallImproved", "OdinRecall"}

OnUpdateBuff(function(unit,buff)
  if unit == myHero then
    if buff.Name == "itemmagicshankcharge" then 
    LudensStacks = buff.Count
    end

    if buff.Name == "zedultexecute" or buff.Name == "summonerexhaust"  then 
    toQSS = true
    end
    
  end
  
    for i = 1, #RecallTable do
      if buff.Name == RecallTable[i] then 
      Recalling[GetNetworkID(unit)] = buff.Count
      end
    end

    for i = 1, #ccstun do
      if buff.Type == ccstun[i] then
      Immobile[GetNetworkID(unit)] = buff.Count
      DelayAction(function() Immobile[GetNetworkID(unit)] = 0 end, buff.ExpireTime-buff.StartTime)
      end
    end
  
  if buff.Type == 15 then
  Shield[GetNetworkID(unit)] = buff.Count
  end

end)

OnRemoveBuff(function(unit,buff)
  if unit == myHero then

    if buff.Name == "itemmagicshankcharge" then 
    LudensStacks = 0
    end
    
    if buff.Name == "zedultexecute" or buff.Name == "summonerexhaust"  then 
    toQSS = false
    end

  end

  for i = 1, #RecallTable do
    if buff.Name == RecallTable[i] then 
    Recalling[GetNetworkID(unit)] = 0
    end
  end

  if buff.Type == 15 then
  Shield[GetNetworkID(unit)] = 0
  end

end)

function HasSpellShield(unit)
   return (Shield[GetNetworkID(unit)] or 0) > 0
end

function IsImmobile(unit)
   return (Immobile[GetNetworkID(unit)] or 0) > 0
end

function IsSlowed(unit)
   return (Slowed[GetNetworkID(unit)] or 0) > 0
end

function IsRecalling(unit)
   return (Recalling[GetNetworkID(unit)] or 0) > 0
end

local WINDOW_W = GetResolution().x
local WINDOW_H = GetResolution().y
local _DrawText, _PrintChat, _DrawLine, _DrawArrow, _DrawCircle, _DrawRectangle, _DrawLines, _DrawLines2 = DrawText, PrintChat, DrawLine, DrawArrow, DrawCircle, DrawRectangle, DrawLines, DrawLines2

function EnableOverlay()
    _G.DrawText, _G.PrintChat, _G.DrawLine, _G.DrawArrow, _G.DrawCircle, _G.DrawRectangle, _G.DrawLines, _G.DrawLines2 = _DrawText, _PrintChat, _DrawLine, _DrawArrow, _DrawCircle, _DrawRectangle, _DrawLines, _DrawLines2
end

function DisableOverlay()
    _G.DrawText, _G.PrintChat, _G.DrawLine, _G.DrawArrow, _G.DrawCircle, _G.DrawRectangle, _G.DrawLines, _G.DrawLines2 = function() end, function() end, function() end, function() end, function() end, function() end, function() end, function() end
end

function GetTextArea2(str, size)
  return { x = str:len() * size * 0.375, y = size * 1.25 }
end

function OnScreen(x, y) 
    local typex = type(x)
    if typex == "number" then 
        return x <= WINDOW_W and x >= 0 and y >= 0 and y <= WINDOW_H
    elseif typex == "userdata" or typex == "table" then
        local p1, p2, p3, p4 = {x = 0,y = 0}, {x = WINDOW_W,y = 0}, {x = 0,y = WINDOW_H}, {x = WINDOW_W,y = WINDOW_H}
        return OnScreen(x.x, x.z or x.y) or (y and OnScreen(y.x, y.z or y.y) or 
            IsLineSegmentIntersection(x,y,p1,p2) or IsLineSegmentIntersection(x,y,p3,p4) or 
            IsLineSegmentIntersection(x,y,p1,p3) or IsLineSegmentIntersection(x,y,p2,p4))
    end
end

function DrawRectangle(x, y, width, height, color, thickness)
    local thickness = thickness or 1
	if thickness == 0 then return end
    x = x - 1
    y = y - 1
    width = width + 2
    height = height + 2
    local halfThick = math.floor(thickness/2)
    DrawLine(x - halfThick, y, x + width + halfThick, y, thickness, color)
    DrawLine(x, y + halfThick, x, y + height - halfThick, thickness, color)
    DrawLine(x + width, y + halfThick, x + width, y + height - halfThick, thickness, color)
    DrawLine(x - halfThick, y + height, x + width + halfThick, y + height, thickness, color)
end

function DrawLines2(t,w,c)
  for i=1, #t-1 do
    DrawLine(t[i].x, t[i].y, t[i+1].x, t[i+1].y, w, c)
  end
end

function DrawLineBorder3D(x1, y1, z1, x2, y2, z2, size, color, width)
    local o = { x = -(z2 - z1), z = x2 - x1 }
    local len = math.sqrt(o.x ^ 2 + o.z ^ 2)
    o.x, o.z = o.x / len * size / 2, o.z / len * size / 2
    local points = {
        WorldToScreen(1,Vector(x1 + o.x, y1, z1 + o.z)),
        WorldToScreen(1,Vector(x1 - o.x, y1, z1 - o.z)),
        WorldToScreen(1,Vector(x2 - o.x, y2, z2 - o.z)),
        WorldToScreen(1,Vector(x2 + o.x, y2, z2 + o.z)),
        WorldToScreen(1,Vector(x1 + o.x, y1, z1 + o.z)),
    }
    for i, c in ipairs(points) do points[i] = Vector(c.x, c.y) end
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawLineBorder(x1, y1, x2, y2, size, color, width)
    local o = { x = -(y2 - y1), y = x2 - x1 }
    local len = math.sqrt(o.x ^ 2 + o.y ^ 2)
    o.x, o.y = o.x / len * size / 2, o.y / len * size / 2
    local points = {
        Vector(x1 + o.x, y1 + o.y),
        Vector(x1 - o.x, y1 - o.y),
        Vector(x2 - o.x, y2 - o.y),
        Vector(x2 + o.x, y2 + o.y),
        Vector(x1 + o.x, y1 + o.y),
    }
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2D(x, y, radius, width, color, quality)
    quality, radius = quality and 2 * math.pi / quality or 2 * math.pi / 20, radius or 50
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        points[#points + 1] = Vector(x + radius * math.cos(theta), y - radius * math.sin(theta))
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle3D(x, y, z, radius, width, color, quality)
    radius = radius or 300
    quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(1,Vector(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = Vector(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(40, Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
		
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(1,Vector(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = Vector(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)	
end

function DrawLine3D(x1, y1, z1, x2, y2, z2, width, color)
    local p = WorldToScreen(1,Vector(x1, y1, z1))
    local px, py = p.x, p.y
    local c = WorldToScreen(1,Vector(x2, y2, z2))
    local cx, cy = c.x, c.y
    if OnScreen({ x = px, y = py }, { x = px, y = py }) then
        DrawLine(cx, cy, px, py, width or 1, color or 4294967295)
    end
end

function DrawLines3D(points, width, color)
    local l
    for _, point in ipairs(points) do
        local p = { x = point.x, y = point.y, z = point.z }
        if not p.z then p.z = p.y; p.y = nil end
        p.y = p.y or player.y
        local c = WorldToScreen(1,Vector(p.x, p.y, p.z))
        if l and OnScreen({ x = l.x, y = l.y }, { x = c.x, y = c.y }) then
            DrawLine(l.x, l.y, c.x, c.y, width or 1, color or 4294967295)
        end
        l = c
    end
end

function DrawTextA(text, size, x, y, color, halign, valign)
    local textArea = GetTextArea2(tostring(text) or "", size or 12)
    halign, valign = halign and halign:lower() or "left", valign and valign:lower() or "top"
    x = (halign == "right"  and x - textArea.x) or (halign == "center" and x - textArea.x/2) or x or 0
    y = (valign == "bottom" and y - textArea.y) or (valign == "center" and y - textArea.y/2) or y or 0
    DrawText(tostring(text) or "", size or 12, math.floor(x), math.floor(y), color or 4294967295)
end

function DrawText3D(text, x, y, z, size, color, center)
    local p = WorldToScreen(1,Vector(x, y, z))
    local textArea = GetTextArea2(text, size or 12)
    if center then
        if OnScreen(p.x + textArea.x / 2, p.y + textArea.y / 2) then
            DrawText(text, size or 12, p.x - textArea.x / 2, p.y, color or 4294967295)
        end
    else
        if OnScreen({ x = p.x, y = p.y }, { x = p.x + textArea.x, y = p.y + textArea.y }) then
            DrawText(text, size or 12, p.x, p.y, color or 4294967295)
        end
    end
end

function Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
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

local SQRT = math.sqrt

function TargetDist(point, target)
    local origin = GetOrigin(target)
    local dx, dz = origin.x-point.x, origin.z-point.z
    return SQRT( dx*dx + dz*dz )
end

function ExcludeFurthest(point, tbl)
    local removalId = 1
    for i=2, #tbl do
        if TargetDist(point, tbl[i]) > TargetDist(point, tbl[removalId]) then
            removalId = i
        end
    end
    
    local newTable = {}
    for i=1, #tbl do
        if i ~= removalId then
            newTable[#newTable+1] = tbl[i]
        end
    end
    return newTable
end

function GetMEC(aoe_radius, listOfEntities, starTarget)
    local average = {x=0, y=0, z=0, count = 0}
    for i=1, #listOfEntities do
        local ori = GetOrigin(listOfEntities[i])
        average.x = average.x + ori.x
        average.y = average.y + ori.y
        average.z = average.z + ori.z
        average.count = average.count + 1
    end
    if starTarget then
        local ori = GetOrigin(starTarget)
        average.x = average.x + ori.x
        average.y = average.y + ori.y
        average.z = average.z + ori.z
        average.count = average.count + 1
    end
    average.x = average.x / average.count
    average.y = average.y / average.count
    average.z = average.z / average.count
    
    local targetsInRange = 0
    for i=1, #listOfEntities do
        if TargetDist(average, listOfEntities[i]) <= aoe_radius then
            targetsInRange = targetsInRange + 1
        end
    end
    if starTarget and TargetDist(average, starTarget) <= aoe_radius then
        targetsInRange = targetsInRange + 1
    end
    
    if targetsInRange == average.count then
        return average
    else
        return GetMEC(aoe_radius, ExcludeFurthest(average, listOfEntities), starTarget)
    end
end
