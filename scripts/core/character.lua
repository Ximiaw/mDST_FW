local character = {
    data={}
}

local ENV = nil
local STRINGS = nil
local TUNING = nil
local STACK = {}
local ARGS = {}

function character.init(env,stack,args)
    ENV = env
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
        for index, value in pairs(value.assets) do
            table.insert(ENV.Assets,value)
        end

        local MakePlayerCharacter = require("prefabs/player_common")
        MakePlayerCharacter(value.name,value.player_prefabs,value.player_assets,value.player_common_postinit,value.player_master_postinit)

        ENV.AddModCharacter(value.name,value.gender,value.modes)
        
        local status = value.current_status
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
        inst.components.health:SetMaxHealth(self.health or TUNING.WILSON_HEALTH)
        inst.components.hunger:SetMax(self.hunger or TUNING.WILSON_HUNGER)
        inst.components.sanity:SetMax(self.sanity or TUNING.WILSON_SANITY)
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
        local load = function (inst)
            local function onbecamehuman(inst)
                inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ghost", self.ghost_speed_mul or 1)
            end
            local function onbecameghost(inst)
                inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ghost")
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

return character