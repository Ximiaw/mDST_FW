local app = require("core.application")

app:init(env)
-- :args({}) -- 这里传入的表在某些地方会作为参数传入
    :prefabs()
        -- 这里具体还没有实现
    :finish()
    :character()
        :new()
            :set_info("test","MALE",nil)
            :add_status("default",80,80,80)
            :add_status("power",500,500,500)
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
