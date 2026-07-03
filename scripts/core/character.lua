--[[
local character = {
    data={
        [1]={
            name="mymodchar",                           -- 人物 prefab 名（小写）
            gender="FEMALE",                            -- 性别：FEMALE / MALE / ROBOT / NEUTRAL / PLURAL
            modes={ghost_skin = "ghost_mymodchar_build"}, -- 可选模式，如幽灵皮肤
            current_status="default"
            status={
                default={
                    health=130, 
                    hunger=150, 
                    sanity=200
                } 
            }, -- 三维
            combat={damage=25, damage_mult=1.0},        -- 战斗属性
            locomotor={runspeed=6, walkspeed=4},        -- 移速
            eater={strong_stomach=true, can_eat_raw=true, ignores_spoilage=false}, -- 饮食特性
            assets={                                    -- 资源
                Asset("ANIM", "anim/mymodchar.zip"),
                Asset("ANIM", "anim/ghost_mymodchar_build.zip"),
            },
            prefabs={"mymoditem"},                      -- 额外预构体依赖
            starting_inventory={"mymoditem", "twigs", "twigs"}, -- 初始物品
            character_recipe={                          -- 人物专属配方
                private={                               -- 仅该人物可见/可造
                    {
                        product = "mymoditem",
                        ingredients = {
                            Ingredient("twigs", 2),
                            Ingredient("rocks", 2),
                        },
                        tech = TECH.NONE,
                        config = {
                            builder_tag = "mymodbuilder",
                            atlas = "images/mymoditem.xml",
                            image = "mymoditem.tex",
                        },
                    },
                },
                public={}                               -- 对他人也可见的配方（可选）
            },
            recipe_tab={                                -- 人物专属制作栏标签（已弃用，建议用 recipe_filter）
                name = "MYMODTAB",
                sort = 999,
                atlas = "images/hud.xml",
                icon = "tab_mymod.tex",
                owner_tag = "mymodbuilder",
            },
            recipe_filter={                             -- 制作分类过滤器
                name = "MYMOD",
                atlas = "images/hud2.xml",
                image = "filter_mymod.tex",
            },
            tech={MYMODTECH = 1},                       -- 人物专属科技等级
            prototyper={                                -- 自定义科技站配置
                name = "mymod_prototyper",
                data = {
                    icon_atlas = "images/hud.xml",
                    icon_image = "tab_mymod.tex",
                    is_crafting_station = true,
                    action_str = "MYMODPROTOTYPER",
                    filter_text = "MYMODTECH",
                },
            },
            strings={                                   -- 角色 UI 文本
                title = "MOD 探险家",
                name = "艾拉",
                description = "* 擅长 crafting\n* 自带专属工具\n* 害怕黑暗",
            },
            speech = "speech_mymodchar",                -- 台词文件路径
            minimap_icons = {                           -- 小地图图集
                "images/map_icons/mymodchar.xml",
            },
            skilltree = "prefabs/skilltree_mymodchar",  -- 技能树文件路径
            common_postinit = function(inst)            -- 客户端/服务端都会执行的初始化
                inst:AddTag("mymodbuilder")
                inst.AnimState:AddOverrideBuild("mymodchar")
            end,
            master_postinit = function(inst)            -- 仅服务端执行的初始化
                inst.starting_inventory = inst.config.starting_inventory
                inst.components.health:SetMaxHealth(inst.config.stats.health)
                inst.components.hunger:SetMax(inst.config.stats.hunger)
                inst.components.sanity:SetMax(inst.config.stats.sanity)
                inst.components.combat:SetDefaultDamage(inst.config.combat.damage)
            end,
            events={                                    -- 角色事件监听
                {event = "death", fn = function(inst, data) print(inst.name .. " died") end},
            },
        }
    }
}
]]
local character = {
    data={}
}

local ENV = nil
local STRINGS = nil
local STACK = {}

function character.init(env,stack)
    ENV = env
    STRINGS = env.GLOBAL.STRINGS
    STACK = stack
    table.insert(STACK,character)
    return character
end

function character.load_game()
    for key, value in ipairs(character.data) do
        STRINGS.NAMES[string.upper(value.name)] = value.monicker

        ENV.Assets = ENV.Assets or {}
        for index, value in ipairs(value.assets) do
            table.insert(ENV.Assets,value)
        end

        ENV.AddModCharacter(value.name,value.gender,value.modes)
        
        local status = value.current_status
        ENV.TUNING[string.upper(value.name).."_HEALTH"]=tonumber(value.status[status].health)
        ENV.TUNING[string.upper(value.name).."_HUNGER"]=tonumber(value.status[status].hunger)
        ENV.TUNING[string.upper(value.name).."_SANITY"]=tonumber(value.status[status].sanity)
    end
end

function character:finish()
    table.remove(STACK)
    return STACK[#STACK]
end

function character:new(config)
    local o = {}
    if config ~= nil then
        o = config
    end
    table.insert(character.data,o)
    setmetatable(o,{__index=character})
    return o
end

function character:set_info(name,gender,modes)
    self.name = name
    self.gender = gender
    self.modes = modes
    return self
end

function character:add_status(status,health,hunger,sanity)
    self.status = self.status or {}
    self.status[status]={
        health=health,
        hunger=hunger,
        sanity=sanity
    }
    return self
end

function character:set_status(status)
    self.current_status=status
    return self
end

function character:get_status()
    return self.current_status
end

function character:set_monicker(name)
    self.monicker=name
    return self
end

function character:add_assets(ass)
    self.assets=ass
    return self
end

return character