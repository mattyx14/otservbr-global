local internalNpcName = "Saideh"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 330
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
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onCreatureSay(npc, creature, type, message)
end

local playerTopic = {}
local function greetCallback(npc, creature)
	local player = Player(creature)
	if player:getStorageValue(Storage.Kilmaresh.First.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello, my name is Saideh. Once this was the entry to the crypt of our heroes. One of the graves belongs to our beloved hero Dayyan. Nowadays it is not a good idea to visit this place.")
		playerTopic[creature] = 1
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	npcHandler.topic[creature] = playerTopic[creature]
	local player = Player(creature)
	if msgcontains(message, "mission") and player:getStorageValue(Storage.Kilmaresh.Fourteen.Remains) == 1 then
		if player:getStorageValue(Storage.Kilmaresh.Fourteen.Remains) == 1 then
			npcHandler:say({" I would like you to visit the grave of our beloved hero Dayyan. His remains have to be reburied, because a horde of ogres controls this place. Do you want to start this holy mission?"}, npc, creature)
			npcHandler.topic[creature] = 1
			playerTopic[creature] = 1
		end
	elseif msgcontains(message, "yes") and playerTopic[creature] == 1 and player:getStorageValue(Storage.Kilmaresh.Fourteen.Remains) == 1 then
		if player:getStorageValue(Storage.Kilmaresh.Fourteen.Remains) == 1 then
			npcHandler:say({"Well, I appreciate that. Good luck!"}, npc, creature)
			player:setStorageValue(Storage.Kilmaresh.Fourteen.Remains, 2)
			npcHandler.topic[creature] = 2
			playerTopic[creature] = 2
		else
			npcHandler:say({"Sorry."}, npc, creature)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)