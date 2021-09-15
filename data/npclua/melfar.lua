local internalNpcName = "Melfar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 69
}

npcConfig.flags = {
	floorchange = false
}
npcConfig.shop = {
	{ itemName = "broken crossbow", clientId = 11451, buy = 30, sell = 0},
	{ itemName = "minotaur horn", clientId = 11472, buy = 75, sell = 0},
	{ itemName = "piece of archer armor", clientId = 11483, buy = 20, sell = 0},
	{ itemName = "piece of warrior armor", clientId =  11482, buy = 50, sell = 0},
	{ itemName = "purple robe", clientId = 11473, buy = 110, sell = 0},
	{ itemName = "flask with beaver bait", clientId = 9843, buy = 0, sell = 100}
}

-- On buy npc shop message
npcType.onPlayerBuyItem = function(npc, player, itemId, subType, amount, inBackpacks, name, totalCost)
	npc:sellItem(player, itemId, amount, subType, true, inBackpacks, 1988)
	npc:talk(player, string.format("You've bought %i %s for %i gold coins.", amount, name, totalCost))
end
-- On sell npc shop message
npcType.onPlayerSellItem = function(npc, player, clientId, amount, name, totalCost)
	npc:talk(player, string.format("You've sold %i %s for %i gold coins.", amount, name, totalCost))
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onPlayerCloseChannel = function(npc, creature)
	npcHandler:onPlayerCloseChannel(npc, creature)
end

local config = {
	{position = Position(32474, 31947, 7), type = 2, description = 'Tree 1'},
	{position = Position(32515, 31927, 7), type = 2, description = 'Tree 2'},
	{position = Position(32458, 31997, 7), type = 2, description = 'Tree 3'}
}

local function creatureSayCallback(npc, creature, type, message)
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local playerId = creature:getId()
	local player = Player(creature)
	if(msgcontains(message, "mission")) then
		if(player:getStorageValue(Storage.TheNewFrontier.Questline) == 4) then
			npcHandler:say({
				"Ha! Men and wood you say? Well, I might be able to relocate some of our miners to the base. Acquiring wood is an entirely different matter though. ... ",
				"I can't spare any men for woodcutting right now but I have an unusual idea that might help. ... ",
				"As you might know, this area is troubled by giant beavers. Once a year, the miners decide to have some fun, so they lure the beavers and jump on them to have some sort of rodeo. ... ",
				"However, I happen to have some beaver bait left from the last year's competition. ... ",
				"If you place it on trees on some strategic locations, we could let the beavers do the work and later on, I'll send men to get the fallen trees. ... ",
				"Does this sound like something you can handle? "
			}, npc, creature)
			npcHandler.topic[playerId] = 1
		elseif(player:getStorageValue(Storage.TheNewFrontier.Questline) == 6) then
			npcHandler:say("Yes, I can hear them even from here. It has to be a legion of beavers! I'll send the men to get the wood as soon as their gnawing frenzy has settled! You can report to Ongulf that men and wood will be on their way!", npc, creature)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 7)
			player:setStorageValue(Storage.TheNewFrontier.Mission02, 6) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
		end
	elseif(msgcontains(message, "yes")) then
		if(npcHandler.topic[playerId] == 1) then
			npcHandler:say({
				"So take this beaver bait. It will work best on dwarf trees. I'll mark the three trees on your map. Here .. here .. and here! So now mark those trees with the beaver bait. ... ",
				"If you're unlucky enough to meet one of the giant beavers, try to stay calm. Don't do any hectic moves, don't yell, don't draw any weapon, and if you should carry anything wooden on you, throw it away as far as you can. "
			}, npc, creature)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 5)
			player:setStorageValue(Storage.TheNewFrontier.Mission02, 2) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			player:addItem(11100, 1)
			for i = 1, #config do
				player:addMapMark(config[i].position, config[i].type, config[i].description)
			end
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			if player:removeMoneyBank(100) then
				player:addItem(11100, 1)
				npcHandler:say("Here you go.", npc, creature)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You dont have enough of gold coins.", npc, creature)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(message, "buy flask") or msgcontains(message, "flask") then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) == 5 then
			npcHandler:say("You want to buy a Flask with Beaver Bait for 100 gold coins?", npc, creature)
			npcHandler.topic[playerId] = 2
		else
			npcHandler:say("Im out of stock.", npc, creature)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
