local prefabs = {
    data = {}
}

local ENV = nil
local STRINGS = nil
local STACK = {}
local ARGS = {}

function prefabs.init(env,stack,args)
    ENV = env
    STRINGS = env.GLOBAL.STRINGS
    STACK = stack
    ARGS = args
    return prefabs
end

function prefabs.load_game()
    for index, value in ipairs(prefabs.data) do
        if value.name ~= nil and value.describe ~= nil then
            STRINGS.NAMES[string.upper(value.prefab_name)] = value.name
            STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(value.prefab_name)] = value.describe
        end
        RegisterPrefabs(ENV.Prefab(value.prefab_name,value.fn,value.assets,value.prefabs))
    end
end

function prefabs.start()
    table.insert(STACK,prefabs)
    return prefabs
end

function prefabs:finish()
    table.remove(STACK)
    return STACK[#STACK]
end

function prefabs:new(config)
    local o = config or {}
    table.insert(prefabs.data,o)
    setmetatable(o,{__index = prefabs})
    return o
end

function prefabs:set_assets(asset)
    self.assets = asset
    return self
end

function prefabs:set_prefabs(prefabs)
    self.prefabs = prefabs
    return self
end

function prefabs:set_prefab_name(name)
    self.prefab_name = name
    return self
end

function prefabs:set_info(name,describe)
    self.name = name
    self.describe = describe
    return self
end

function prefabs:set_fn(fn)
    self.fn = function ()
        local inst = ENV.CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        if fn ~= nil then
            fn(inst,self,ARGS)
        end
        return inst
    end
    return self
end

return prefabs