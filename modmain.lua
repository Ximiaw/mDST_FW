local character = require("character")
character:init(env)

-- env.AddModCharacter("t","MALE",nil)

-- print("AddModCharacter " .. _ENV.AddModCharacter == nil)

character:new()
    :set_info("test","MALE",nil)
    :add_tag("test")

character:load_game()
