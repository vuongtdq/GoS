myHero = GetMyHero()

SpellData = {
  ["Aatrox"] = {
		[_Q]  = { Name = "AatroxQ", ProjectileName = "AatroxQ.troy", Range = 650, Speed = 2000, Delay = 600, Width = 250, collision = false, type = "circular", IsDangerous = true},
		[_E]  = { Name = "AatroxE", ProjectileName = "AatroxBladeofTorment_mis.troy" , Range = 1075, Speed = 1250, Delay = 250, Width = 35, collision = false, type = "linear", IsDangerous = false},
	},
  ["Ahri"] = {
		[_Q]  = { Name = "AhriOrbofDeception", ProjectileName = "Ahri_Orb_mis.troy", Range = 1000, Speed = 2500, Delay = 250, Width = 100, collision = false, aoe = false, type = "linear", IsDangerous = false},
 	        [-1]  = { Name = "AhriOrbofDeceptionherpityderp", ProjectileName = "Ahri_Orb_mis_02.troy", Range = 1000, Speed = 900, Delay = 250, Width = 100, collision = false, aoe = false, type = "linear", IsDangerous = false},
		[_E]  = { Name = "AhriSeduce", ProjectileName = "Ahri_Charm_mis.troy", Range = 1000, Speed = 1550, Delay = 250,  Width = 60, collision = true, aoe = false, type = "linear", IsDangerous = true},
	},
  ["Ashe"] = {
		[_Q]  = { Name = "FrostShot", Range = 600},
		[_W]  = { Name = "Volley", ProjectileName = "", Range = 1250, Speed = 1500, Delay = 250, Width = 60, collision = true, aoe = false, type = "cone", IsDangerous = false},
		[_E]  = { Name = GetCastName(myHero,_E), Range = 20000, Speed = 1500, Delay = 500, Width = 1400, collision = false, aoe = false, type = "linear", IsDangerous = false},
		[_R]  = { Name = "EnchantedCrystalArrow", ProjectileName = "Ashe_Base_R_mis.troy", Range = 20000, Speed = 1600, Delay = 500, Width = 100, collision = false, aoe = false, type = "linear", IsDangerous = true}
        },
  ["Azir"] = {
		[_Q] = { Name = "AzirQ", Range = 950,  Speed = 1600, Width = 80, collision = false, aoe = false, type = "linear", IsDangerous = false},
		[_W] = { Name = "AzirW", Range = 750, Speed = math.huge, Width = 100, collision = false, aoe = false, type = "circular"},
		[_E] = { Name = "AzirE", Range = 1100, Speed = 1200, Delay = 250, Width = 60, collision = true, aoe = false, type = "linear", IsDangerous = false},
		[_R] = { Name = "AzirR", Range = 520, Speed = 1300, Delay = 250, Width = 600, collision = false, aoe = true, type = "linear", IsDangerous = true}
	},
  ["Blitzcrank"] = {
		[_Q] = { Name = "RocketGrabMissile", ProjectileName = "FistGrab_mis.troy", Range = 975, Speed = 1700, Width = 70, Delay = 250, collision = true, aoe = false, type = "linear", IsDangerous = true},
		[_R] = { Name = "StaticField", Range = 0, Speed = math.huge, Width = 600, Delay = 250, collision = false, aoe = false, type = "circular", IsDangerous = false}
	},
  ["Cassiopeia"] = {
		[_Q] = { Name = "CassiopeiaNoxiousBlast", ProjectileName = "CassNoxiousSnakePlane_green.troy", Range = 850, Speed = math.huge, Delay = 750, Width = 100, collision = false, aoe = true, type = "circular", IsDangerous = false},
		[_W] = { Name = "CassiopeiaMiasma", ProjectileName = "", Range = 925, Speed = 2500, Delay = 500, Width = 90, collision = false, aoe = true, type = "circular", IsDangerous = false},
		[_R] = { Name = "CassiopeiaPetrifyingGaze",  ProjectileName = "", Range = 825, Speed = math.huge, Delay = 600, Width = 80, collision = false, aoe = true, type = "cone", IsDangerous = true}
	},
  ["Chogath"] = {
		[_Q] = { Name = "", ProjectileName = "", Range = 950, Speed = math.huge, Delay = 600, Width = 250, collision = false, aoe = true, type = "circular", IsDangerous = true},
		[_W] = { Name = "", ProjectileName = "", Range = 650, Speed = math.huge, Delay = 250, Width = 210, collision = false, aoe = false, type = "cone", IsDangerous = false}
	},
  ["Ekko"] = { 
  	        [_Q] = { Name = "EkkoQ", ProjectileName = "Ekko_Base_Q_Aoe_Dilation.troy", Range = 925, Speed = 1050, Delay = 250, Width = 140, collision = false, aoe = false, type = "linear", IsDangerous = false},
  	        [_W] = { Name = "EkkoW", ProjectileName = "Ekko_Base_W_Indicator.troy", Range = 1700, Speed = math.huge, Delay = 3000, Width = 400, collision = false, aoe = true, type = "circular", IsDangerous = false}
        },
  ["Jinx"] = {
		[_W] = { Name = "JinxW", ProjectileName = "Jinx_W_Mis.troy", Range = 1500, Speed = 3300, Delay = 600, Width = 60, collision = true, aoe = true, type = "circular", IsDangerous = true},
		[_R] = { Name = "JinxR",  ProjectileName = "Jinx_R_Mis.troy", Range = 20000, Speed = 1700, Delay = 600, Width = 140, collision = false, aoe = true, type = "cone", IsDangerous = true}
	},
  ["Kalista"] = {
		[_Q] = { Name = "KalistaMysticShot", ProjectileName = "", Range = 1150, Speed = 1700, Delay = 250, Width = 50, collision = true, aoe = false, type = "linear", IsDangerous = false}
	},
  ["Orianna"] = {
                [_Q] = { Name = "", ProjectileName = "", Range = 825, Speed = 1200, Delay = 0, Width = 80, collision = false, aoe = false, type = "circular", IsDangerous = false}
        },
  ["Ryze"] = {
  	        [_Q] = { Name = "Overload", ProjectileName = "Overload_mis.troy", Range = 900, Speed = 1400, Delay = 250, Width = 55, collision = true, aoe = false, type = "linear", IsDangerous = false}
        },
  ["Sivir"] = {
  	        [_Q] = { Name = "SivirQ", ProjectileName = "Sivir_Base_Q_mis.troy", Range = 1075, Speed = 1350, Delay = 250, Width = 85, collision = false, aoe = false, type = "linear", IsDangerous = false}
        },
  ["Syndra"] = {
  	        [_Q] = { Name = "SyndraQ", ProjectileName = "Syndra_Q_cas.troy", Range = 790, Speed = math.huge, Delay = 250, Width = 125, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_W] = { Name = "SyndraW", ProjectileName = "", Range = 925, Speed = math.huge, Delay = 250, Width = 190, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_E] = { Name = "SyndraE", ProjectileName = "", Range = 1250, Speed = 2500, Delay = 250, Width = 45, collision = false, aoe = false, type = "cone", IsDangerous = false}
       },
   ["Thresh"] = {
  	        [_Q] = { Name = "", ProjectileName = "", Range = 1100, Speed = 1900, Delay = 500, Width = 70, collision = true, aoe = false, type = "linear", IsDangerous = true}
       },
   ["Viktor"] = {
  	        [_W] = { Name = "", ProjectileName = "", Range = 700, Speed = math.huge, Delay = 500, Width = 300, collision = false, aoe = false, type = "circular", IsDangerous = false},
  	        [_R] = { Name = "", ProjectileName = "", Range = 700, Speed = math.huge, Delay = 250, Width = 450, collision = false, aoe = false, type = "circular", IsDangerous = false}
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
    ["ShenStandUnited"]             = {Name = "Shen",         Spellslot = _R},
    ["Destiny"]                     = {Name = "TwistedFate",  Spellslot = _R},
    ["UrgotSwap2"]                  = {Name = "Urgot",        Spellslot = _R},
    ["VarusQ"]                      = {Name = "Varus",        Spellslot = _Q},
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

function Cast(spell, target, origin, hitchance, speed, delay, range, width, coll)
      local hitchance = hitchance or 1
      local origin = GetOrigin(origin) or GetOrigin(myHero)
      local speed = speed or SpellData[GetObjectName(myHero)][spell].Speed or math.huge
      local delay = delay or SpellData[GetObjectName(myHero)][spell].Delay or 0
      local range = range or SpellData[GetObjectName(myHero)][spell].Range
      local width = width or SpellData[GetObjectName(myHero)][spell].Width
      local coll = coll or  SpellData[GetObjectName(myHero)][spell].collision
      local Predicted = GetPredictionForPlayer(origin,target,GetMoveSpeed(target), speed, delay, range, width, coll, true)
      if Predicted.HitChance >= hitchance then
      CastSkillShot(spell, Predicted.PredPos)
      end
end

function GetPredictedPos(unit,delay,from)
    if not ValidTarget(unit) then return end
    local delay = delay or 125
    local from = from or myHero
    return GetPredictionForPlayer(GetOrigin(from),unit,GetMoveSpeed(unit),math.huge,delay,math.huge,1,false,false).PredPos
end

function IsFacing(target,range,unit) 
    local range = range or 20000
    local unit = unit or myHero
    if GetDistance(unit,target) < range then return end
    return GetDistance(GetPredictedPos(unit), target) < GetDistance(unit, target)
end

function mousePos()
    return GetMousePos()
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

OnUpdateBuff(function(Object,buff)
  if Object == myHero then
    if buff.Name == "itemmagicshankcharge" then 
    LudensStacks = buff.Count
    end

    if buff.Name == "zedultexecute" or buff.Name == "summonerexhaust"  then 
    toQSS = true
    end
    
  end
  
    for i = 1, #RecallTable do
      if buff.Name == RecallTable[i] then 
      Recalling[GetNetworkID(Object)] = buff.Count
      end
    end

    for i = 1, #ccstun do
      if buff.Type == ccstun[i] then
      Immobile[GetNetworkID(Object)] = buff.Count
      DelayAction(function() Immobile[GetNetworkID(Object)] = 0 end, buff.ExpireTime-buff.StartTime)
      end
    end
  
  if buff.Type == 15 then
  Shield[GetNetworkID(Object)] = buff.Count
  end

end)

OnRemoveBuff(function(Object,buff)
  if Object == myHero then

    if buff.Name == "itemmagicshankcharge" then 
    LudensStacks = 0
    end
    
    if buff.Name == "zedultexecute" or buff.Name == "summonerexhaust"  then 
    toQSS = false
    end

  end

  for i = 1, #RecallTable do
    if buff.Name == RecallTable[i] then 
    Recalling[GetNetworkID(Object)] = 0
    end
  end

  if buff.Type == 15 then
  Shield[GetNetworkID(Object)] = 0
  end

end)

function HasShield(unit)
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

function GetJLineFarmPosition(range, width)
    local BestPos 
    local BestHit = 0
    local objects = minionManager.objects
    for i, object in pairs(objects) do
      local EndPos = Vector(myHero) + range * (Vector(object) - Vector(myHero)):normalized()
      local hit = CountObjectsOnLineSegment(GetOrigin(myHero), EndPos, width, objects)
      if GetTeam(object) == 300 and hit > BestHit and GetDistanceSqr(GetOrigin(object)) < range * range then
        BestHit = hit
        BestPos = Vector(object)
        if BestHit == #objects then
        break
        end
      end
    end
    return BestPos, BestHit
end

function GetJFarmPosition(range, width)
  local BestPos 
  local BestHit = 0
  local objects = minionManager.objects
    for i, object in pairs(objects) do
    local hit = CountObjectsNearPos(Vector(object), range, width, objects)
    if GetTeam(object) == 300 and hit > BestHit and GetDistanceSqr(Vector(object)) < range * range then
      BestHit = hit
      BestPos = Vector(object)
      if BestHit == #objects then
      break
      end
    end
  end
  return BestPos, BestHit
end

-- Credits To Inferno for MEC
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
