local character = require("character")
character:init(env)

-- env.AddModCharacter("t","MALE",nil)

-- print("AddModCharacter " .. _ENV.AddModCharacter == nil)

local test = character:new()
    :set_info("test","MALE",nil)

character:load_game()
