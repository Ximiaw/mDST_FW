local app = require("core.application")

app:init(env)
    :character()
        :new()
            :set_info("test","MALE",nil)
            :add_status("default",80,80,80)
            :set_status("default")
            :set_monicker("aaa")
            :add_assets({
                Asset( "IMAGE", "bigportraits/test.tex" ),
                Asset( "ATLAS", "bigportraits/test.xml" )
            })
        :new()
            :set_info("t","MALE",nil)
            :add_status("default",100,50,80)
            :set_status("default")
            :set_monicker("bbb")
            :add_assets({
                Asset( "IMAGE", "bigportraits/test.tex" ),
                Asset( "ATLAS", "bigportraits/test.xml" )
            })
    :finish()
:finish()
