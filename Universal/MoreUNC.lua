local gameEnv = {}
local functionList = {}
local environments = {}

-- Custom getrawmetatable implementation
gameEnv.getrawmetatable = function(object)
    local mt = debug.getmetatable(object) or getmetatable(object)
    if mt and type(mt) == "table" then
        -- Try making it writable
        local success, isReadOnly = pcall(function()
            return setreadonly(mt, false) and true or false
        end)
        if success then
            setreadonly(mt, isReadOnly)
        end
    end
    return mt
end

table.insert(functionList, "getrawmetatable")

-- Custom getfenv implementation
gameEnv.getfenv = function(fn)
    if type(fn) ~= "function" then
        error("bad argument #1 to 'getfenv' (function expected)", 2)
    end
    return environments[fn] or _G
end

table.insert(functionList, "getfenv")

-- Custom setfenv implementation
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

-- Custom getgenv implementation
gameEnv.getgenv = function()
    return gameEnv
end

table.insert(functionList, "getgenv")

-- Inject functions into _G
for _, funcName in ipairs(functionList) do
    _G[funcName] = gameEnv[funcName]
end

-- Print loaded functions
print("Loaded functions: {\n  " .. table.concat(functionList, ",\n  ") .. "\n}")
