local prefabs = {

}

local ENV = nil
local STACK = {}
local ARGS = {}

function prefabs.init(env,stack,args)
    ENV = env
    STACK = stack
    ARGS = args
    return prefabs
end

function prefabs.load_game()
    
end

function prefabs.start()
    table.insert(STACK,prefabs)
    return prefabs
end

function prefabs:finish()
    table.remove(STACK)
    return STACK[#STACK]
end

return prefabs