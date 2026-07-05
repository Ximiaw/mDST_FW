local app = require("core.application")

app
:init(env)
:args()
    :character()
        :new()
            :set_info("gilgamesh","MALE",nil)
            :set_status(500,500,500)
            :set_monicker("吉尔伽美什")
            :set_assets({
                Asset( "IMAGE", "bigportraits/gilgamesh.tex" ),
                Asset( "ATLAS", "bigportraits/gilgamesh.xml" ),
                Asset( "IMAGE", "bigportraits/gilgamesh_none.tex" ),
                Asset( "ATLAS", "bigportraits/gilgamesh_none.xml" ),
                Asset( "IMAGE", "images/names_gilgamesh.tex" ),
                Asset( "ATLAS", "images/names_gilgamesh.xml" ),
                Asset( "IMAGE", "images/avatars/avatar_gilgamesh.tex" ),
                Asset( "ATLAS", "images/avatars/avatar_gilgamesh.xml" ),
                Asset( "IMAGE", "images/avatars/avatar_ghost_gilgamesh.tex" ),
                Asset( "ATLAS", "images/avatars/avatar_ghost_gilgamesh.xml" ),
                Asset( "IMAGE", "images/avatars/self_inspect_gilgamesh.tex" ),
                Asset( "ATLAS", "images/avatars/self_inspect_gilgamesh.xml" ),
                Asset( "IMAGE", "images/saveslot_portraits/gilgamesh.tex" ),
                Asset( "ATLAS", "images/saveslot_portraits/gilgamesh.xml" )
            })
            :set_mini_map_icon("images/map_icons/gilgamesh.xml")
            :set_player_common_postinit()
            :set_player_master_postinit()
            :set_skin_assets({
                Asset( "ANIM", "anim/gilgamesh.zip" ),
                Asset( "ANIM", "anim/ghost_archer_build.zip" )
            })
            :set_skin_base_prefab("gilgamesh")
            :set_skin_normal("gilgamesh")
            :set_skin_ghost("ghost_archer_build")
    :finish()
:finish()
