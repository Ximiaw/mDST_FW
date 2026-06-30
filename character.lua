--[[
local character = {
    data={
        [1]={
            name="",
            gender="",
            modes={},
            tag={},
            character_recipe={
                private={},
                public={}
            },
            recipe_tab={},
            tech={},
            prototyper={},

        }
    }
}
]]


local character = {
    data={}
}

-- 封装配置选项，使得更好配置，但要保留一次性配置的接口
function character:new(...)
    local o = {...}
    table.insert(character.data,o)
    setmetatable(o,{__index=self})
    return o
end

function character:load_game()
    for key, value in pairs(character.data) do
        -- todo:加载和初始化，在modmain调用
    end
end

function character:set_info(name,gender,modes)
    self.name = name
    self.gender = gender
    self.modes = modes
end

function character:add_tag(tag)
    self.tag[tag] = tag
end

function character:rm_tag(tag)
    self.tag[tag] = nil
end

return character