local internalNpcName = "Romir"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 153,
	lookHead = 19,
	lookBody = 48,
	lookLegs = 67,
	lookFeet = 126,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onCreatureAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onCreatureDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onCreatureSay(npc, creature, type, message)
end

npcHandler:addModule(FocusModule:new())

npcConfig.shop = {
	-- Sellable items
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "spellwand", clientId = 651, sell = 299 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
	-- Buyable items
	{ itemName = "avalanche rune", clientId = 3161, buy = 57 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "durable exercise rod", clientId = 35283, buy = 945000, count = 1800 },
	{ itemName = "durable exercise wand", clientId = 35284, buy = 945000, count = 1800 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "exercise rod", clientId = 28556, buy = 262500, count = 500 },
	{ itemName = "exercise wand", clientId = 28557, buy = 262500, count = 500 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 57 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 144 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 228 },
	{ itemName = "hailstorm rod", clientId = 3067, buy = 15000 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "lasting exercise rod", clientId = 35289, buy = 7560000, count = 14400 },
	{ itemName = "lasting exercise wand", clientId = 35290, buy = 7560000, count = 14400 },
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
	{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
	{ itemName = "northwind rod", clientId = 8083, buy = 7500 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
	{ itemName = "spellbook", clientId = 3059, buy = 150 },
	{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 93 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 135 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 625 },
	{ itemName = "terra rod", clientId = 3065, buy = 10000 },
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 438 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 438 },
	{ itemName = "underworld rod", clientId = 8082, buy = 22000 },
	{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
	{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
	{ itemName = "wand of draconia", clientId = 8093, buy = 7500 },
	{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
	{ itemName = "wand of inferno", clientId = 3071, buy = 15000 },
	{ itemName = "wand of starstorm", clientId = 8092, buy = 18000 },
	{ itemName = "wand of voodoo", clientId = 8094, buy = 22000 },
	{ itemName = "wand of vortex", clientId = 3074, buy = 500 }
}
-- On buy npc shop message
npcType.onPlayerBuyItem = function(npc, player, itemId, subType, amount, inBackpacks, name, totalCost)
	npc:sellItem(player, itemId, amount, subType, true, inBackpacks, 1988)
	npc:talk(player, string.format("You've bought %i %s for %i gold coins.", amount, name, totalCost), npc, player)
end
-- On sell npc shop message
npcType.onPlayerSellItem = function(npc, player, amount, name, totalCost, clientId)
	npc:talk(player, string.format("You've sold %i %s for %i gold coins.", amount, name, totalCost))
end

npcType:register(npcConfig)
