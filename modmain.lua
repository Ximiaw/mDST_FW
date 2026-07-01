local character = require("character")
character:init(_G)

local test = character:new()
    :set_info("test","MALE",nil)
    :add_tag("test")

character:load_game()
