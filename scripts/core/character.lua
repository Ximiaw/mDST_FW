local character = {
    data = {}
}

local ENV = nil
local GLOBAL = nil
local STRINGS = nil
local TUNING = nil
local STACK = {}
local ARGS = {}

function character.init(env,stack,args)
    ENV = env
    GLOBAL = env.GLOBAL
    STRINGS = env.GLOBAL.STRINGS
    TUNING = env.TUNING
    STACK = stack
    ARGS = args
    return character
end

function character.load_game()
    for key, value in ipairs(character.data) do
        STRINGS.NAMES[string.upper(value.name)] = value.monicker

        ENV.Assets = ENV.Assets or {}
        for key, value in pairs(value.assets) do
            table.insert(ENV.Assets,value)
        end
        for key, value in pairs(value.skin.assets) do
            table.insert(ENV.Assets,value)
        end

        local MakePlayerCharacter = require("prefabs/player_common")
        local character_prefab = MakePlayerCharacter(value.name,value.player_prefabs,value.player_assets,value.player_common_postinit,value.player_master_postinit)
        RegisterPrefabs(character_prefab)

        local skin_prefab = CreatePrefabSkin(value.name.."_none",{
            base_prefab = value.skin.base_prefab,
            skins = value.skin.skins, 
            assets = value.skin.assets,
            tags = value.skin.tags or {string.upper(value.name),"CHARACTER"},
            skip_item_gen = value.skin.skip_item_gen or true,
            skip_giftable_gen = value.skin.skip_giftable_gen or true
        })
        RegisterPrefabs(skin_prefab)

        ENV.AddMinimapAtlas(value.mini_map_icon)

        ENV.AddModCharacter(value.name,value.gender,value.modes)
        
        TUNING[string.upper(value.name).."_HEALTH"]=tonumber(value.status.health)
        TUNING[string.upper(value.name).."_HUNGER"]=tonumber(value.status.hunger)
        TUNING[string.upper(value.name).."_SANITY"]=tonumber(value.status.sanity)

        if value.start_items ~= nil then
            local start_items = {}
            for key, value in pairs(value.start_items) do
                table.insert(start_items,key)
                TUNING.STARTING_ITEM_IMAGE_OVERRIDE[key] = value
            end
            TUNING.GAMEMODE_STARTING_ITEMS = TUNING.GAMEMODE_STARTING_ITEMS or {}
            TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT = TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT or {}
            TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper(value.name)] = start_items
        end
    end
end

function character.start()
    table.insert(STACK,character)
    return character
end

function character:finish()
    table.remove(STACK)
    return STACK[#STACK]
end

function character:new(config)
    local o = config or {}
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

function character:set_status(health,hunger,sanity)
    self.status = {
        health=health,
        hunger=hunger,
        sanity=sanity
    }
    return self
end

function character:set_monicker(name)
    self.monicker=name
    return self
end

function character:set_start_items(items)
    self.start_items = items
    return self
end

function character:set_tags(tags)
    self.tags = tags
    return self
end

function character:set_assets(ass)
    self.assets=ass
    return self
end

function character:set_combat_mul(mul)
    self.combat = self.combat or {}
    self.combat.mul = mul
    return self
end

function character:set_combat_bonus(num)
    self.combat = self.combat or {}
    self.combat.bonus  = num
    return self
end

function character:set_combat_hand(num)
    self.combat = self.combat or {}
    self.combat.hand = num
    return self
end

function character:set_combat_frequency(num)
    self.combat = self.combat or {}
    self.combat.frequency = num
    return self
end

function character:set_combat_range(attack,hit)
    self.combat = self.combat or {}
    self.combat.range = self.combat.range or {}
    self.combat.range.attack = attack
    self.combat.range.hit = hit or attack
    return self
end

function character:set_aoe_enable(o)
    self.combat = self.combat or {}
    self.combat.aoe = self.combat.aoe or {}
    self.combat.aoe.on = o
    return self
end

function character:set_combat_aoe(range, percent, area_hit_check)
    self.combat = self.combat or {}
    self.combat.aoe = self.combat.aoe or {}
    self.combat.aoe.range = range
    self.combat.aoe.percent = percent
    self.combat.aoe.areahitcheck = function (inst,target)
        area_hit_check(inst,target,self,ARGS)
    end
    return self
end

function character:set_player_assets(ass)
    self.player_assets = ass
    return self
end

function character:set_player_prefabs(prefabs)
    self.player_prefabs = prefabs
    return self
end

function character:set_mini_map_icon(filename)
    self.mini_map_icon = filename
    return self
end

function character:set_ghost_speed_mul(speed_mul)
    self.ghost_speed_mul = speed_mul
    return self
end

function character:set_player_common_postinit(fn)
    self.player_common_postinit = function (inst)
        inst.MiniMapEntity:SetIcon(self.mini_map_icon)
        inst:AddTag(self.name)
        if self.tags ~= nil then
            for index, value in pairs(self.tags) do
                inst:AddTag(value)
            end
        end
        if fn ~= nil then
            fn(inst,self,ARGS)
        end
    end
    return self
end

function character:set_player_master_postinit(fn)
    self.player_master_postinit = function (inst)
        inst.components.health:SetMaxHealth(self.status.health or TUNING.WILSON_HEALTH)
        inst.components.hunger:SetMax(self.status.hunger or TUNING.WILSON_HUNGER)
        inst.components.sanity:SetMax(self.status.sanity or TUNING.WILSON_SANITY)
        if self.combat ~= nil then
            inst.components.combat:SetDefaultDamage(self.combat.hand or 1)
            inst.components.combat.damagemultiplier = self.combat.mul or 1
            inst.components.combat.damagembonus = self.combat.bonus or 0

            if self.combat.range ~= nil then
                inst.components.combat:SetRange(self.combat.range.attack or 2,self.combat.range.hit or 2)
            end
            if self.combat.aoe ~= nil then
                inst.components.combat:EnableAreaDamage(self.combat.aoe.on or false)
                inst.components.combat:SetAreaDamage(self.combat.aoe.range, self.combat.aoe.percent, self.combat.aoe.areahitcheck)
            end
        end
        if inst.components.inventory ~= nil and self.start_items ~= nil then
            for key, value in pairs(self.start_items) do
                inst.components.inventory:GiveItem(GLOBAL.SpawnPrefab(key))
            end
        end
        local load = function (inst)
            local function onbecamehuman(inst)
                inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ghost")
            end
            local function onbecameghost(inst)
                inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ghost", self.ghost_speed_mul or 1)
            end

            inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
            inst:ListenForEvent("ms_becameghost", onbecameghost)

            if inst:HasTag("playerghost") then
                onbecameghost(inst)
            else
                onbecamehuman(inst)
            end
        end
        inst.OnLoad = load
        inst.OnNewSpawn = load
        if fn ~= nil then
            fn(inst,self,ARGS)
        end
    end
    return self
end

function character:set_skin_assets(assets)
    self.skin = self.skin or {}
    self.skin.assets = assets
    return self
end

function character:set_skin_tags(tags)
    self.skin = self.skin or {}
    self.skin.tags = tags
    table.insert(self.skin.tags,string.upper(self.name))
    table.insert(self.skin.tags,"CHARACTER")
    return self
end

function character:set_skin_base_prefab(prefab)
    self.skin = self.skin or {}
    self.skin.base_prefab = prefab
    return self
end

function character:set_skin_normal(normal)
    self.skin = self.skin or {}
    self.skin.skins = self.skin.skins or {}
    self.skin.skins.normal_skin = normal
    return self
end

function character:set_skin_ghost(ghost)
    self.skin = self.skin or {}
    self.skin.skins = self.skin.skins or {}
    self.skin.skins.ghost_skin = ghost
    return self
end

function character:set_skin(skin,append)
    self.skin = self.skin or {}
    self.skin.skins = self.skin.skins or {}
    if append then
        for key, value in pairs(skin) do
            self.skin.skins[key] = value
        end
    else
        self.skin.skins = skin
    end
    return self
end

function character:set_skip_item_gen(on)
    self.skin = self.skin or {}
    self.skin.skip_item_gen = on
    return self
end

function character:set_skip_giftable_gen(on)
    self.skin = self.skin or {}
    self.skin.skip_giftable_gen = on
    return self
end

return character