local app = require("core.application")

app
:init(env)
:args({}) -- 这里传入的表在回调函数处作为参数传入(args)
    :prefabs()
        -- 这里具体还没有实现
    :finish()
    :character()
        :new({}) -- 这里可以注入自定义字段在内部元表，但是需要注意，不能和内部使用的字段冲突
                 -- 内部一般情况下不会使用下划线，但为了规范推荐自定义字段命名为__name__此类前后各有两个下划线
                 -- 这里传入的表在回调函数处作为参数传入(character_table)
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
                gilgamesh_notice_ch = {
                    atlas = "images/inventoryimages/gilgamesh_notice.xml",
                    image = "gilgamesh_notice.tex"
                }
            })
            :set_player_prefabs({
                "key_of_babylon",
                "gilgamesh_notice_ch"
            })
            :set_player_assets({
                Asset("SCRIPT", "scripts/prefabs/player_common.lua")
            })
            :set_mini_map_icon("gilgamesh.tex")
            -- 下面两个args是app:args传入的
            :set_player_common_postinit(function (inst,character_table,args)
                
            end)
            :set_player_master_postinit(function (inst,character_table,args)
                
            end)
    :finish()
:finish()
