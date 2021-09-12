local internalNpcName = "Valentina"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 157,
	lookHead = 116,
	lookBody = 116,
	lookLegs = 98,
	lookFeet = 45,
	lookAddons = 1
}

npcConfig.flags = {
	floorchange = false
}

 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onAppear = function(npc, creature)
	npcHandler:onCreatureAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onCreatureDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onCreatureSay(npc, creature, type, message)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcConfig.voices = {
	interval = 5000,
	chance = 50,
	{text = 'Love is beautiful, we are loved.'}
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
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onCreatureSay(npc, creature, type, message)
end

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am known as the saleswoman of love, as a cupid."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Valentine's Store. Let's {trade} something?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

npcHandler:addModule(FocusModule:new())

npcConfig.shop = {
	-- Buyable items
	{ itemName = "crimson rose", clientId = 21954, buy = 15 },
	{ itemName = "flower bouquet", clientId = 649, buy = 20 },
	{ itemName = "heart backpack", clientId = 10202, buy = 500 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "sweetheart ring", clientId = 21955, buy = 500 },
	{ itemName = "truelove teddy", clientId = 21953, buy = 1000 },
	{ itemName = "valentines cake", clientId = 6392, buy = 30 },
	{ itemName = "valentines card", clientId = 6538, buy = 5 }
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