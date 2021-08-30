local npcType = Game.createNpcType("Iwar")
local npcConfig = {}

npcConfig.description = "Iwar"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 160,
    lookHead = 115,
    lookBody = 127,
    lookLegs = 123,
    lookFeet = 76
}

npcConfig.voices = {
    interval = 100,
    chance = 0,
    { text = "Beds, chairs, tables, statues and everything you could imagine for decorating your home!", yell = false }
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
