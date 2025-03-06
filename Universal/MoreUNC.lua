local gameEnv = {}
local functionList = {}
local environments = {}

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

table.insert(functionList, "getrawmetatable")

gameEnv.getfenv = function(fn)
    if type(fn) ~= "function" then
        error("bad argument #1 to 'getfenv' (function expected)", 2)
    end
    return environments[fn] or _G
end

table.insert(functionList, "getfenv")

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

table.insert(functionList, "setfenv")

gameEnv.getgenv = function()
    return gameEnv
end

table.insert(functionList, "getgenv")

if #functionList > 0 then
    for _, funcName in ipairs(functionList) do
        _G[funcName] = gameEnv[funcName]
        print("Loaded functions: {\n  " .. table.concat(functionList, ",\n  ") .. "\n}")
    end
end
