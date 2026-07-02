local character = require("core.character")
character:init(env)

character:new()
    :set_info("test","MALE",nil)
    :add_status("default",80,80,80)
    :set_status("default")

character:load_game()
