local internalNpcName = "Wyda"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 54,
	lookHead = 0,
	lookBody = 119,
	lookLegs = 119,
	lookFeet = 126
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

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(60, 2000, -10)

local function creatureSayCallback(npc, creature, type, message)
	if not npcHandler:isFocused(creature) then
		return false
	end

	local player = Player(creature)

	if msgcontains(message, 'cookie') then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31
				and player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.Wyda) ~= 1 then
			npcHandler:say('You brought me a cookie?', npc, creature)
			npcHandler.topic[creature] = 1
		end
	elseif msgcontains(message, 'mission') or msgcontains(message, 'quest') then
		npcHandler:say({
			"A quest? Well, if you\'re so keen on doing me a favour... Why don\'t you try to find a {blood herb}?",
			"To be honest, I\'m drowning in blood herbs by now."
		}, npc, creature)
		npcHandler.topic[creature] = 0
	elseif msgcontains(message, 'bloodherb') or msgcontains(message, 'blood herb') then
		if player:getStorageValue(Storage.BloodHerbQuest) == 1  then
			npcHandler:say('Arrr... here we go again.... do you have a #$*§# blood herb for me?', npc, creature)
			npcHandler.topic[creature] = 2
		else
			npcHandler:say({
				"The blood herb is very rare. This plant would be very useful for me, but I don't know any accessible places to find it.",
				"To be honest, I'm drowning in blood herbs by now. But if it helps you, well yes.. I guess I could use another blood herb..."
			}, npc, creature)
			npcHandler.topic[creature] = 0
		end
	elseif msgcontains(message, 'yes') then
		if npcHandler.topic[creature] == 1 then
			if not player:removeItem(8111, 1) then
				npcHandler:say('You have no cookie that I\'d like.', npc, creature)
				npcHandler.topic[creature] = 0
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.Wyda, 1)
			player:addCondition(condition)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('Well, it\'s a welcome change from all that gingerbread ... AHHH HOW DARE YOU??? FEEL MY WRATH!', npc, creature)
			npcHandler:releaseFocus(creature)
			npcHandler:resetNpc(creature)
		elseif npcHandler.topic[creature] == 2 then
			if player:removeItem(2798, 1) then
				player:setStorageValue(Storage.BloodHerbQuest, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
				local TornTeddyRand = math.random(1, 100)
				if TornTeddyRand <= 70 then
					player:addItem(2324, 1) -- witchesbroom
					npcHandler:say('Thank you -SOOO- much! No, I really mean it! Really! Here, let me give you a reward...', npc, creature)
					npcHandler.topic[creature] = 0
				else
					player:addItem(13774, 1) -- torn teddy
					npcHandler:say('Thank you -SOOO- much! No, I really mean it! Really! Ah, you know what, you can have this old thing...', npc, creature)
					npcHandler.topic[creature] = 0
				end
			else
				npcHandler:say('No, you don\'t have any...', npc, creature)
				npcHandler.topic[creature] = 0
			end
		end
	elseif msgcontains(message, 'no') then
		if npcHandler.topic[creature] == 1 or npcHandler.topic[creature] == 2 then
			npcHandler:say('I see.', npc, creature)
			npcHandler.topic[creature] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)
