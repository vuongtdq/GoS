if GetObjectName(GetMyHero()) ~= "Galio" then return end

require('Inspired')
require('DeftLib')
require('DamageLib')

AutoUpdate("/D3ftsu/GoS/master/Galio.lua","/D3ftsu/GoS/master/Galio.version","Galio.lua",1)

local GalioMenu = MenuConfig("Galio", "Galio")
GalioMenu:Menu("Combo", "Combo")
GalioMenu.Combo:Boolean("Q", "Use Q", true)
GalioMenu.Combo:Boolean("W", "Use W", true)
GalioMenu.Combo:Boolean("E", "Use E", true)
GalioMenu.Combo:Menu("R", "Use R")
GalioMenu.Combo.R:Boolean("REnabled", "Enabled", true)
GalioMenu.Combo.R:Boolean("Rkill", "if Can Kill", true)
GalioMenu.Combo.R:Slider("Rtaunt", "if can Taunt X enemies", 2, 0, 5, 1)

GalioMenu:Menu("Harass", "Harass")
GalioMenu.Harass:Boolean("Q", "Use Q", true)
GalioMenu.Harass:Boolean("E", "Use E", true)

GalioMenu:Menu("Killsteal", "Killsteal")
GalioMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
GalioMenu.Killsteal:Boolean("E", "Killsteal with E", true)

GalioMenu:Menu("Misc", "Misc")
if Ignite ~= nil then GalioMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
GalioMenu.Misc:KeyBinding("Flee", "Flee", string.byte("T"))
GalioMenu.Misc:Menu("AutoUlt", "Auto Ult")
GalioMenu.Misc.AutoUlt:Boolean("Enabled", "Enabled", true)
GalioMenu.Misc.AutoUlt:Slider("tauntable", "if Can Taunt X Enemies", 3, 0, 5, 1)
GalioMenu.Misc.AutoUlt:Slider("killable", "if Can Kill X Enemies", 2, 0, 5, 1)

GalioMenu:Menu("JungleClear", "JungleClear")
GalioMenu.JungleClear:Boolean("Q", "Use Q", true)
GalioMenu.JungleClear:Boolean("E", "Use E", true)

GalioMenu:Menu("LaneClear", "LaneClear")
GalioMenu.LaneClear:Boolean("Q", "Use Q", true)
GalioMenu.LaneClear:Boolean("E", "Use E", true)

GalioMenu:Menu("Drawings", "Drawings")
GalioMenu.Drawings:Boolean("Q", "Draw Q Range", true)
GalioMenu.Drawings:Boolean("W", "Draw W Range", true)
GalioMenu.Drawings:Boolean("E", "Draw E Range", true)
GalioMenu.Drawings:Boolean("R", "Draw R Range", true)
