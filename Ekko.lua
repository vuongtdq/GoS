if GetObjectName(GetMyHero()) ~= "Ekko" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

local EkkoMenu = MenuConfig("Ekko", "Ekko")
EkkoMenu:Menu("Combo", "Combo")
EkkoMenu.Combo:Boolean("Q", "Use Q", true)
EkkoMenu.Combo:Boolean("W", "Use W", true)
EkkoMenu.Combo:Boolean("E", "Use E", true)
EkkoMenu.Combo:Boolean("R", "Use R", true)

EkkoMenu:Menu("Harass", "Harass")
EkkoMenu.Harass:Boolean("Q", "Use Q", true)
EkkoMenu.Harass:Boolean("W", "Use W", true)
EkkoMenu.Harass:Boolean("E", "Use E", true)
EkkoMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

EkkoMenu:Menu("Killsteal", "Killsteal")
EkkoMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
EkkoMenu.Killsteal:Boolean("R", "Killsteal with R", true)

EkkoMenu:Menu("Misc", "Misc")
if Ignite ~= nil then EkkoMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
EkkoMenu.Misc:Boolean("Autolvl", "Auto level", true)
EkkoMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-E-W", "Q-W-E", "E-Q-W"})

EkkoMenu:Menu("Drawings", "Drawings")
EkkoMenu.Drawings:Boolean("Q", "Draw Q Range", true)
EkkoMenu.Drawings:Boolean("W", "Draw W Range", true)
EkkoMenu.Drawings:Boolean("E", "Draw E Range", true)
EkkoMenu.Drawings:Boolean("R", "Draw R Range", true)
