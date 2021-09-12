local internalNpcName = "Dukosch"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 70
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

local function creatureSayCallback(npc, creature, type, message)	local player = Player(creature)
	-- WAGON TICKET
	if(msgcontains(message, "ticket")) then
		if player:getStorageValue(Storage.WagonTicket) < os.time() then
			npcHandler:say("Do you want to purchase a weekly ticket for the ore wagons? With it you can travel freely and swiftly through Kazordoon for one week. 250 gold only. Deal?", npc, creature)
			npcHandler.topic[creature] = 1
		else
			npcHandler:say("Your weekly ticket is still valid. Would be a waste of money to purchase a second one", npc, creature)
			npcHandler.topic[creature] = 0
		end
	elseif(msgcontains(message, "yes")) then
		if(npcHandler.topic[creature] == 1) then
			if player:getMoney() + player:getBankBalance() >= 250 then
				player:removeMoneyNpc(250)
				player:setStorageValue(Storage.WagonTicket, os.time() + 7 * 24 * 60 * 60)
				npcHandler:say("Here is your stamp. It can't be transferred to another person and will last one week from now. You'll get notified upon using an ore wagon when it isn't valid anymore.", npc, creature)
			else
				npcHandler:say("You don't have enough money.", npc, creature)
			end
			npcHandler.topic[creature] = 0
		end
	elseif(npcHandler.topic[creature] == 1) then
		if(msgcontains(message, "no")) then
			npcHandler:say("No then.", npc, creature)
			npcHandler.topic[creature] = 0
		end
	-- WAGON TICKET
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! Do you feel adventurous? Do you want a weekly {ticket} for the ore wagon system here? You can use it right here to get to the centre of Kazordoon!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Hope to see you again.")
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)