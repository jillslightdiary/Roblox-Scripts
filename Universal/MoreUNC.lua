-- Custom global environment
local gameEnv = {}

-- Custom getrawmetatable implementation
gameEnv.getrawmetatable = function(object)
    local mt = debug.getmetatable(object) or getmetatable(object)
    if mt and type(mt) == "table" then
        local success, isReadOnly = pcall(setreadonly, mt, false)
        if success then
            setreadonly(mt, isReadOnly)
        end
    end
    return mt
end

-- Custom setfenv and getfenv implementations
local environments = {} -- Store function environments

gameEnv.getfenv = function(fn)
    if type(fn) ~= "function" then
        error("bad argument #1 to 'getfenv' (function expected)", 2)
    end
    return environments[fn] or _G
end

gameEnv.setfenv = function(fn, env)
    if type(fn) ~= "function" then
        error("bad argument #1 to 'setfenv' (function expected)", 2)
    end
    if type(env) ~= "table" then
        error("bad argument #2 to 'setfenv' (table expected)", 2)
    end

    environments[fn] = env
    return fn
end

-- Custom getgenv implementation
gameEnv.getgenv = function()
    return gameEnv
end

-- Add standard Lua functions (so scripts can still use them)
for k, v in pairs(_G) do
    gameEnv[k] = v
end
