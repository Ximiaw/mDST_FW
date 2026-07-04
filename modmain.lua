local app = require("core.application")

app
:init(env)
:args({}) -- 这里传入的表在某些地方会作为参数传入
    :prefabs()
        -- 这里具体还没有实现
    :finish()
    :character()
        :new()
            :set_info("gilgamesh","MALE",nil)
            :set_status(500,500,500)
            :set_monicker("吉尔伽美什")
            :set_assets({
                Asset( "IMAGE", "bigportraits/gilgamesh.tex" ),
                Asset( "ATLAS", "bigportraits/gilgamesh.xml" )
            })
            :set_player_prefabs({
                "keyofbabylon",
                "gilgamesh_notice_ch",
                --"gilgamesh_axe",
            })
            :set_player_assets({
                Asset("SCRIPT", "scripts/prefabs/player_common.lua")
            })
            :set_mini_map_icon("gilgamesh.tex")
            -- 下面两个args是app:args传入的
            :set_player_common_postinit(function (inst,args)
                
            end)
            :set_player_master_postinit(function (inst,args)
                
            end)
    :finish()
:finish()
