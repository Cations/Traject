local traject = {
    __VERSION       = 'traject 0.1.0',
    __AUTHOR        = 'Pablo Ariel Mayobre'
    __DESCRIPTION   = 'A library to create complex easing animations easily for Lua and LÖVE',
    __URL           = 'https://github.com/Positive07/Traject',
    __LICENSE       = [[
        --------------  Copyright (c) 2016  Pablo Ariel Mayobre  --------------

        --------------------------  THE MIT LICENSE  --------------------------

        Permission is hereby granted, free of charge, to any person obtaining a
        copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

local methods = require (... .. ".methods")

local meta = {
    traject = {
        __call = function (self, ...)
            return self.new(...)
        end
    },

    new = {
        __index = methods,
        __call = function (self, ...)
            return self:start(...)
        end
    },
}

local update = function (self, dt)
    local rt    = self.time + dt
    local t     = rt * (self.anim.duration / self.duration)

    if t >= self.anim.duration then
        if self.loop then
            t = t % self.anim.duration
        else
            t = self.anim.duration
            self.finished = true
        end
    end

    local value = 0

    for i, step in ipairs(self.anim._anim) do
        local a = t - step.start
        if a < step.prop.duration then
            if step.f then
                local change = step.prop.final and (step.prop.final - value) or step.prop.change
                value = step.f(a, value, change, step.prop.duration)
            end
            break
        else
            value = step.prop.final and step.prop.final or (value + step.prop.change)
        end
    end

    self.value  = value
    self.time   = rt

    return self.finished
end


local start = function (anim, duration, loop, callback)
    if not anim._anim then error("start expects an animation as first argument", 2) end

    return {
        anim        = anim,
        duration    = duration,
        time        = 0,
        callback    = callback,
        value       = value,
        loop        = loop,
        update      = update,
    }
end

traject.new = function (start)
    local self = {
        start       = start or 0,

        _anim       = {},

        delay       = delay,
        sudden      = sudden,
        custom      = custom,

        cubicBezier = cubicBezier,

        duration    = 0,

        start       = start,
    }

    return setmetatable(self, meta.new)
end

return setmetatable(traject, meta.traject)
