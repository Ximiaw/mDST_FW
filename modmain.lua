local app = require("core.application")

app
:init(env)
:args({}) -- 这里传入的表在回调函数处作为参数传入(args)
    :prefabs()
        :new({}) -- 这里可以注入自定义字段在内部元表，但是需要注意，不能和内部使用的字段冲突
                 -- 内部一般情况下不会使用下划线，但为了规范推荐自定义字段命名为__name__此类前后各有两个下划线
                 -- 这里传入的表在回调函数处作为参数传入(character_table)
            :set_prefab_name("key_of_babylon")
            :set_info("王律钥匙","世上的一切皆为我所有。")
            :set_assets({
                Asset("ANIM", "anim/key_of_babylon.zip"),
                Asset("ANIM", "anim/swap_keyofbabylon_build.zip"),
                Asset("ATLAS", "images/inventoryimages/key_of_babylon.xml"),
                Asset("IMAGE", "images/inventoryimages/key_of_babylon.tex")
            })
            :set_prefabs({})
            :set_fn(function (inst,prefab_table,args)
                inst.entity:AddDynamicShadow()
     
                GLOBAL.MakeInventoryPhysics(inst)   

                inst.DynamicShadow:SetSize(1, 1)
                
                inst.AnimState:SetBank("key_of_babylon")
                inst.AnimState:SetBuild("key_of_babylon")
                inst.AnimState:PlayAnimation("idle",true)

                inst:AddTag("key_of_babylon")
                inst:AddTag("sharp")

                if not GLOBAL.TheWorld.ismastersim then
                    return inst
                end

                inst.entity:SetPristine()

                inst:AddComponent("inspectable")

                inst:AddComponent("inventoryitem")
                inst.components.inventoryitem.imagename = "key_of_babylon"
                inst.components.inventoryitem.atlasname = "images/inventoryimages/key_of_babylon.xml"

                inst:AddComponent("equippable")
                inst.components.equippable:SetOnEquip( OnEquip )
                inst.components.equippable:SetOnUnequip( OnUnequip )
                
                inst:AddComponent("weapon")
                inst.components.weapon:SetDamage(0.1)
                inst.components.weapon:SetRange(15,15)
                inst.components.weapon:SetOnAttack(key_attack)

                GLOBAL.MakeHauntableLaunch(inst)
            end)
    :finish()
    :character()
        :new({
            __gate_of_babylon_attack_fn__ = function (inst)
                local time = 10
                local period = 0.5

                if setSkillCooldown(inst) then
                    for i=1,time do
                        inst:DoTaskInTime(period*(i-math.random()),function()
                            gate_searching(inst,i)
                        end)
                    end
                end
            end
        })   -- 同上
            :set_info("gilgamesh","MALE",nil)
            :set_status(500,500,500)
            :set_monicker("吉尔伽美什")
            :set_ghost_speed_mul(2)
            :set_assets({
                Asset( "IMAGE", "bigportraits/gilgamesh.tex" ),
                Asset( "ATLAS", "bigportraits/gilgamesh.xml" ),
                Asset( "IMAGE", "bigportraits/gilgamesh_none.tex" ),
                Asset( "ATLAS", "bigportraits/gilgamesh_none.xml" ),
                Asset( "IMAGE", "images/names_gilgamesh.tex" ),
                Asset( "ATLAS", "images/names_gilgamesh.xml" ),
                Asset( "IMAGE", "images/inventoryimages/key_of_babylon.tex" ),
                Asset( "ATLAS", "images/inventoryimages/key_of_babylon.xml" ),
                Asset( "IMAGE", "images/inventoryimages/gilgamesh_notice.tex" ),
                Asset( "ATLAS", "images/inventoryimages/gilgamesh_notice.xml" )
            })
            :set_start_items({
                key_of_babylon = {
                    atlas = "images/inventoryimages/key_of_babylon.xml",
	                image = "key_of_babylon.tex"
                }, 
                spear = {} -- 原版物品使用空表
            })
            :set_player_prefabs({
                "key_of_babylon"
            })
            :set_player_assets({
                Asset("SCRIPT", "scripts/prefabs/player_common.lua")
            })
            :set_mini_map_icon("gilgamesh.tex")
            -- 下面两个args是app:args传入的
            :set_player_common_postinit(function (inst,character_table,args)
                inst.MiniMapEntity:SetIcon( "gilgamesh.tex" )
                inst:AddTag("gilgameshbuilder")
                inst:AddTag("gilgamesh")
                if not inst.components.keyhandler then
                    inst:AddComponent("keyhandler")
                end
                inst.components.keyhandler:AddActionListener("gilgamesh",KEY_C,"gate_of_babylon_attack")
                AddModRPCHandler("gilgamesh","gate_of_babylon_attack",character_table.__gate_of_babylon_attack_fn__)

            end)
            :set_player_master_postinit(function (inst,character_table,args)
                inst.MiniMapEntity:SetIcon( "gilgamesh.tex" )
                inst:AddTag("gilgameshbuilder")
                inst:AddTag("gilgamesh")
                if not inst.components.keyhandler then
                    inst:AddComponent("keyhandler")
                end
                inst.components.keyhandler:AddActionListener("gilgamesh",KEY_C,"gate_of_babylon_attack")
                AddModRPCHandler("gilgamesh","gate_of_babylon_attack",character_table.__gate_of_babylon_attack_fn__)

            end)
            :set_skin_assets({
                Asset( "ANIM", "anim/gilgamesh.zip" ),
                Asset( "ANIM", "anim/ghost_archer_build.zip" ),
            })
            :set_skin_base_prefab("gilgamesh")
            :set_skin_normal("gilgamesh")
            :set_skin_ghost("ghost_archer_build")
    :finish()
:finish()
