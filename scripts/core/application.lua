local app = {
    args = {},
    __character = require("core.character"),
    __prefabs = require("core.prefabs")
}

local STACK = {
}

local ENV = nil

function app:init(env)
    ENV = env
    table.insert(STACK,app)
    self.__character.init(env,STACK)
    self.__prefabs.init(env,STACK)
    return self
end

function app:args(args)
    self.args = args
    return self
end

function app:character()
    return self.__character.start()
end

function app:prefabs()
    return self.__prefabs.start()
end

function app:finish()
    self.__character.load_game()
    self.__prefabs.load_game()
    STACK = {}
    return self
end

return app