local app = {
    args = {},
    __character = require("core.character")
}

local STACK = {
}

local ENV = nil

function app:init(env)
    ENV = env
    table.insert(STACK,app)
    self.__character.init(env,STACK)
    return self
end

function app:args(args)
    self.args = args
    return self
end

function app:character()
    return self.__character
end

function app:finish()
    self.__character.load_game()

    STACK = {}
    return self
end

return app