require('Inspired')

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
