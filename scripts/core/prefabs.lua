local prefabs = {
    data = {}
}

local ENV = nil
local GLOBAL = nil
local STRINGS = nil
local STACK = {}
local ARGS = {}

function prefabs.init(env,stack,args)
    ENV = env
    GLOBAL = env.GLOBAL
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

function prefabs:set_transform(on)
    self.transform = on
    return self
end

function prefabs:set_anim_state(on)
    self.anim_state = on
    return self
end

function prefabs:set_network(on)
    self.network = on
    return self
end

function prefabs:set_banks(assetname)
    self.banks = assetname
    return self
end

function prefabs:set_build(assetname)
    self.build = assetname
    return self
end

function prefabs:set_inventory_item_atlas_name(name)
    self.inventory_item_atlas_name = name
    return self
end

function prefabs:set_component(component)
    if self.component ~= nil then
        for key, value in pairs(component) do
            table.insert(self.component,value)
        end
    else
        self.component = component
    end
    return self
end


function prefabs:set_fn(fn)
    self.fn = function ()
        local inst = GLOBAL.CreateEntity()
        if self.transform ~= false then
            inst.entity:AddTransform()        
        end
        if self.anim_state ~= false then
            inst.entity:AddAnimState()
        end
        if self.component ~= nil then
            for key, value in pairs(self.component) do
                inst.AddComponent(value)
            end
        end
        if self.network ~= false then
            inst.entity:AddNetwork()
        end
        if self.banks ~= nil then
            inst.AnimState:SetBanks(self.banks)
        end
        if self.build ~= nil then
            inst.AnimState:SetBuild(self.build)
        end
        if self.inventory_item_atlas_name ~= nil then
            inst.components.inventoryitem.atlasname = self.inventory_item_atlas_name
        end

        if fn ~= nil then
            fn(inst,self,ARGS)
        end
        return inst
    end
    return self
end

return prefabs