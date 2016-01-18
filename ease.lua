local sin, cos, pi = math.sin, math.cos, math.pi

--Every function takes four arguments
--  t (time): starts in 0 and usually moves towards duration
--  b (begin): initial value of the of the property being eased.
--  c (change): ending value of the property - starting value of the property
--  d (duration): total duration of the tween
--And returns the new value

-- linear
local function linear(t, b, c, d)
    return c * t / d + b
end

-- quad
local function quadIn(t, b, c, d)
    return c * (t / d) ^ 2 + b
end

local function quadOut(t, b, c, d)
    t = t / d
    return -c * t * (t - 2) + b
end

local function quadInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return c / 2 * t ^ 2 + b
    else
        return -c / 2 * ((t - 1) * (t - 3) - 1) + b
    end
end

local function quadOutIn(t, b, c, d)
    if t < d / 2 then
        return quadOut(t * 2, b, c / 2, d)
    else
        return quadIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

-- cubic
local function cubicIn (t, b, c, d)
    return c * (t / d) ^ 3 + b
end

local function cubicOut(t, b, c, d)
    return c * ((t / d - 1) ^ 3 + 1) + b
end

local function cubicInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return c / 2 * t * t * t + b
    else
        t = t - 2
        return c / 2 * (t * t * t + 2) + b
    end
end

local function cubicOutIn(t, b, c, d)
    if t < d / 2 then
        return cubicOut(t * 2, b, c / 2, d)
    else
        return cubicIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

-- quart
local function quartIn(t, b, c, d)
    return c * (t / d) ^ 4 + b
end

local function quartOut(t, b, c, d)
    return -c * ((t / d - 1) ^ 4 - 1) + b
end

local function quartInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return c / 2 * t ^ 4 + b
    else
        return -c / 2 * ((t - 2) ^ 4 - 2) + b
    end
end

local function quartOutIn(t, b, c, d)
    if t < d / 2 then
        return quartOut(t * 2, b, c / 2, d)
    else
        return quartIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

-- quint
local function quintIn(t, b, c, d)
    return c * (t / d) ^ 5 + b
end

local function quintOut(t, b, c, d)
    return c * ((t / d - 1) ^ 5 + 1) + b
end

local function quintInOut(t, b, c, d)
    t = t / d * 2

    if t < 1 then
        return c / 2 * t ^ 5 + b
    else
        return c / 2 * ((t - 2) ^ 5 + 2) + b
    end
end

local function quintOutIn(t, b, c, d)
    if t < d / 2 then
        return quintOut(t * 2, b, c / 2, d)
    else
        return quintIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

-- sine
local function sineIn(t, b, c, d)
    return -c * cos(t / d * (pi / 2)) + c + b
end

local function sineOut(t, b, c, d)
    return c * sin(t / d * (pi / 2)) + b
end

local function sineInOut(t, b, c, d)
    return -c / 2 * (cos(pi * t / d) - 1) + b
end

local function sineOutIn(t, b, c, d)
    if t < d / 2 then
        return sineOut(t * 2, b, c / 2, d)
    else
        return sineIn((t * 2) -d, b + c / 2, c / 2, d)
    end
end

-- expo
local function expoIn(t, b, c, d)
    if t == 0 then
        return b
    else
        return c * 2 ^ (10 * (t / d - 1)) + b - c * 0.001
    end
end

local function expoOut(t, b, c, d)
    if t == d then
        return b + c
    else
        return c * 1.001 * (-(2 ^ (-10 * t / d)) + 1) + b
    end
end

local function expoInOut(t, b, c, d)
    if t == 0 then
        return b
    elseif t == d then
        return b + c
    end

    t = t / d * 2

    if t < 1 then
        return c / 2 * 2 ^ (10 * (t - 1)) + b - c * 0.0005
    else
        return c / 2 * 1.0005 * (-(2 ^ (-10 * (t - 1))) + 2) + b
    end
end

local function expoOutIn(t, b, c, d)
    if t < d / 2 then
        return expoOut(t * 2, b, c / 2, d)
    else
        return expoIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

-- circ
local function circIn(t, b, c, d)
    return(-c * ((1 - ((t / d) ^ 2)) ^ .5 - 1) + b)
end

local function circOut(t, b, c, d)
    return(c * (1 - ((t / d - 1) ^ 2)) ^ .5 + b)
end

local function circInOut(t, b, c, d)
    t = t / d * 2

    if t < 1 then
        return -c / 2 * ((1 - t * t) ^ .5 - 1) + b
    else
        t = t - 2
        return  c / 2 * ((1 - t * t) ^ .5 + 1) + b
    end
end

local function circOutIn(t, b, c, d)
    if t < d / 2 then
        return circOut(t * 2, b, c / 2, d)
    else
        return circIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

-- elastic
local function calculatePAS(p,a,c,d)
    p, a = p or d * 0.3, a or 0

    if a < math.abs(c) then
        return p, c, p / 4 -- p, a, s
    else
        return p, a, p / (2 * pi) * math.asin(c/a) -- p, a, s
    end
end

local function elasticIn(t, b, c, d, a, p)
    local s

    if t == 0 then
        return b
    end

    t = t / d

    if t == 1 then return b + c else
        p,a,s = calculatePAS(p,a,c,d)
        t = t - 1
        return -(a * 2 ^ (10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
    end
end

local function elasticOut(t, b, c, d, a, p)
    local s

    if t == 0 then
        return b
    end

    t = t / d

    if t == 1 then
        return b + c
    else
        p,a,s = calculatePAS(p,a,c,d)
        return a * 2 ^ (-10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
    end
end

local function elasticInOut(t, b, c, d, a, p)
    local s

    if t == 0 then
        return b
    end

    t = t / d * 2

    if t == 2 then
        return b + c
    end

    p,a,s = calculatePAS(p,a,c,d)
    t = t - 1

    local stds = sin((t * d - s) * (2 * pi) / p)

    if t < 0 then
        return -0.5 * (a * 2 ^ (10 * t) * stds) + b
    else
        return a * 2 ^ (-10 * t) * stds * 0.5 + c + b
    end
end

local function elasticOutIn(t, b, c, d, a, p)
    if t < d / 2 then
        return elasticOut(t * 2, b, c / 2, d, a, p)
    else
        return elasticIn((t * 2) - d, b + c / 2, c / 2, d, a, p)
    end
end

-- back
local function backIn(t, b, c, d, s)
    s = s or 1.70158
    t = t / d

    return c * t * t * ((s + 1) * t - s) + b
end

local function backOut(t, b, c, d, s)
    s = s or 1.70158
    t = t / d - 1

    return c * (t * t * ((s + 1) * t + s) + 1) + b
end

local function backInOut(t, b, c, d, s)
    s = (s or 1.70158) * 1.525
    t = t / d * 2

    if t < 1 then
        return c / 2 * (t * t * ((s + 1) * t - s)) + b
    else
        t = t - 2
        return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
    end
end

local function backOutIn(t, b, c, d, s)
    if t < d / 2 then
        return backOut(t * 2, b, c / 2, d, s)
    else
        return backIn((t * 2) - d, b + c / 2, c / 2, d, s)
    end
end

-- bounce
local function bounceOut(t, b, c, d)
    t = t / d

    if t < 1 / 2.75 then
        return c * (7.5625 * t * t) + b
    elseif t < 2 / 2.75 then
        t = t - (1.5 / 2.75)
        return c * (7.5625 * t * t + 0.75) + b
    elseif t < 2.5 / 2.75 then
        t = t - (2.25 / 2.75)
        return c * (7.5625 * t * t + 0.9375) + b
    else
        t = t - (2.625 / 2.75)
        return c * (7.5625 * t * t + 0.984375) + b
    end
end

local function bounceIn(t, b, c, d)
    return c - bounceOut(d - t, 0, c, d) + b
end

local function bounceInOut(t, b, c, d)
    if t < d / 2 then
        return bounceIn(t * 2, 0, c, d) * 0.5 + b
    else
        return bounceOut(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
    end
end

local function bounceOutIn(t, b, c, d)
    if t < d / 2 then
        return bounceOut(t * 2, b, c / 2, d)
    else
        return bounceIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

return {
    linear          = linear,       cubicBezier     = cubicBezier,
    quadIn          = quadIn,       quadOut         = quadOut,
    quadInOut       = quadInOut,    quadOutIn       = quadOutIn,
    cubicIn         = cubicIn,      cubicOut        = cubicOut,
    cubicInOut      = cubicInOut,   cubicOutIn      = cubicOutIn,
    quartIn         = quartIn,      quartOut        = quartOut,
    quartInOut      = quartInOut,   quartOutIn      = quartOutIn,
    quintIn         = quintIn,      quintOut        = quintOut,
    quintInOut      = quintInOut,   quintOutIn      = quintOutIn,
    sineIn          = sineIn,       sineOut         = sineOut,
    sineInOut       = sineInOut,    sineOutIn       = sineOutIn,
    expoIn          = expoIn,       expoOut         = expoOut,
    expoInOut       = expoInOut,    expoOutIn       = expoOutIn,
    circIn          = circIn,       circOut         = circOut,
    circInOut       = circInOut,    circOutIn       = circOutIn,
    elasticIn       = elasticIn,    elasticOut      = elasticOut,
    elasticInOut    = elasticInOut, elasticOutIn    = elasticOutIn,
    backIn          = backIn,       backOut         = backOut,
    backInOut       = backInOut,    backOutIn       = backOutIn,
    bounceIn        = bounceIn,     bounceOut       = bounceOut,
    bounceInOut     = bounceInOut,  bounceOutIn     = bounceOutIn
}
