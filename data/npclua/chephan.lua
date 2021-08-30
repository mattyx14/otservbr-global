local npcType = Game.createNpcType("Chephan")
local npcConfig = {}

npcConfig.description = "Chephan"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 128,
    lookHead = 2,
    lookBody = 26,
    lookLegs = 115,
    lookFeet = 76,
    lookAddons = 0
}

npcConfig.voices = {
    interval = 100,
    chance = 0,
    { text = "Cooking utensils and kitchen equipment! For pros and starters!", yell = false }
}

npcConfig.flags = {
    attackable = false,
    hostile = false,
    floorchange = false
}

npcType.onThink = function(npc, interval)
end

npcType.onAppear = function(npc, creature)
end

npcType.onDisappear = function(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
end

npcType:register(npcConfig)
