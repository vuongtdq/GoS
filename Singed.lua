if GetObjectName(GetMyHero()) ~= "Singed" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

local SingedMenu = MenuConfig("Singed", "Singed")
SingedMenu:Key("Q", "Q Exploit", string.byte("T"))

OnTick(function(myHero)
if SingedMenu.Q:Value() then
CastSpell(_Q)
MoveToXYZ(GetMousePos())
end
end)
