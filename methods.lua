local path = (...):gsub('%.[^%.]+$', '')

local ease, methods = require (path .. ".ease"), {}

local add = function (self, prop, f)
    if not prop.duration or type(prop.duration) ~= "number" then
        error('Animation is missing the "duration" property', 3)
    end

    if (not prop.final or type(prop.final) ~= "number") and (not prop.change or type(prop.change) ~= "number") then
        error('Animation is missing the "final" property', 3)
    end

    table.insert(self._anim, {start = self.duration, prop = prop, f = f})
    self.duration = self.duration + prop.duration
end

--Easing methods
methods.delay = function (self, delay)
    add(self, {change = 0, duration = delay})

    return self
end

methods.sudden = function (self, value)
    add(self, {final = value, duration = 0})

    return self
end

methods.custom = function (self, prop)
    if prop.func and type(prop.func) == "function" then
        add(self, prop, prop.func)
    else
        error("custom expects a property called func of type function", 2)
    end

    return self
end

if love and love.math and love.math.newBezierCurve then
    methods.cubicBezier = function (self, prop)
        if prop.curve and type(prop.curve) == "table" and #prop.curve >= 4 then
            local x1, y1, x2, y2 = unpack(prop.curve)
            local curve = love.math.newBezierCurve(0, 0, x1, y1, x2, y2, 1, 1)

            local f = function (t, b, c, d)
                return c * curve:evaluate(t/d) + b
            end

            add(self, prop, f)
        else
            error("cubicBezier expects a property called curve of type table with at least 4 numbers from 0 to 1", 2)
        end

        return self
    end
end

for k,v in pairs(ease) do
    methods[k] = function (self, prop)
        add(self, prop, v)

        return self
    end
end

return ease
