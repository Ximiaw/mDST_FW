local character = require("core.character")
character:init(env)

character:new()
    :set_info("test","MALE",nil)
    :add_status("default",80,80,80)
    :set_status("default")
    :set_monicker("aaa")
    :add_assets({
        Asset( "IMAGE", "bigportraits/test.tex" ),
        Asset( "ATLAS", "bigportraits/test.xml" )
    })

character:load_game()
