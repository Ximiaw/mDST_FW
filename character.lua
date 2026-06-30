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

function character:add(...)
    local o = {...}
    table.insert(character.data,o)
    setmetatable(o,{__index=self})
    return o
end

function character:load()
    for key, value in pairs(character.data) do
        -- todo:加载和初始化，在modmain调用
    end
end

return character