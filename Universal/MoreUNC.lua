local ___table = {}

___table.___getrawmetatable = function(object)
    local mt

    if debug and debug.getmetatable then
        mt = debug.getmetatable(object)
    else
        mt = getmetatable(object)
    end

    if mt and typeof(mt) == "table" then
        local success, isReadOnly = pcall(setreadonly, mt, false)

        if success then
            setreadonly(mt, isReadOnly) 
        end
    end
    
    return mt
end

getrawmetatable = __table.__getrawmetatable
