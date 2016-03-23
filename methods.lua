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
    methods.bezier = function (self, prop)
        if prop.curve and type(prop.curve) == "table" and #prop.curve % 2 == 0 then
            local points = {0, 0, unpack(prop.curve)}

            table.insert(points, 1)
            table.insert(points, 1)

            local curve = love.math.newBezierCurve(points)

            local f = function (t, b, c, d)
                return c * curve:evaluate(t/d) + b
            end

            add(self, prop, f)
        elseif not prop.curve then
            add(self, prop, ease.linear)
        else
            error("bezier expects a property called curve of type table with even number of elements", 2)
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
