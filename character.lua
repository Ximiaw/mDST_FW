GENDER = {MALE="MALE",FEMALE="FEMALE",ROBOT="ROBOT",NEUTRAL="NEUTRAL",PLURAL="PLURAL",__type="GENDER"}
character = {}

function character:new(name, gender, modes)
    if gender.__type ~= "GENDER" then
        error("参数gender必须是GENDER类型，当前为："..type(gender))
    end

    local o = {
        name=name,
        gender=gender,
        modes=modes
    }
    setmetatable(o,{__index=self})
    AddModCharacter(name, gender, modes)
    AddPrefabPostInit(name,name)
    return o
end

-- 添加制作配方
function character:AddRecipe(name, ingredients, tab, 
    level, placer_or_more_data, min_spacing, 
    nounlock, numtogive, 
    atlas, image, testfn, 
    product, build_mode, build_distance)

    AddRecipe(name, ingredients, tab, 
        level, placer_or_more_data, min_spacing, 
        nounlock, numtogive, self.name, 
        atlas, image, testfn, 
        product, build_mode, build_distance)
end

function character:AddTag(tag)
    AddPrefabPostInit(self.name, function(inst)
        inst:AddTag(tag)
    end)
end

-- 批量添加多个 tag
function character:AddTags(...)
    local tags = {...}
    AddPrefabPostInit(self.name, function(inst)
        for _, tag in ipairs(tags) do
            inst:AddTag(tag)
        end
    end)
end

-- 制作科技栏
function character:AddRecipeTab(rec_str, rec_sort, rec_atlas, rec_icon, rec_crafting_station)
    AddRecipeTab(rec_str, rec_sort, rec_atlas, rec_icon, self.name, rec_crafting_station)
end

function character:RemapSoundEvent(name, new_name)
    RemapSoundEvent(name, new_name)
end

-- 加载人物文本
function character:AddLines(path)
    modimport(path)
end