local internalNpcName = "Eruaran"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 63,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0
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

local storage = Storage.DreamOutfit

local action = {}
local weapon = {}
local weapon_sub = {}

local Config = {
	Create = {
		Clusters = 20,
		DreamMatter = 1,
		Chance = 70 --70%
	},
	Improve = {
		Clusters = 75,
		Chance = 55, --55%
		BreakChance = 50 --50% of chance that when failing the improvement, the weapons is destroyed but you keep the clusters. Else, you keep the weapon and lose the clusters
	},
	Transform = {
		Clusters = 150,
		Chance = 45, --45%
		BreakChance = 50 --50% of chance that when failing the transforming, the weapon is destroyed but you keep all the clusters. Else, the weapon is downgraded to crude piece and you lose half of clusters.
	}
}

local IDS = {
	DREAM_MATTER = 22397,
	CLUSTER_OF_SOLACE = 22396,

	--weapons
	CRUDE_UMBRAL_BLADE = 22398,
	UMBRAL_BLADE = 22399,
	UMBRAL_MASTER_BLADE = 22400,

	CRUDE_UMBRAL_SLAYER = 22401,
	UMBRAL_SLAYER = 22402,
	UMBRAL_MASTER_SLAYER = 22403,

	CRUDE_UMBRAL_AXE = 22404,
	UMBRAL_AXE = 22405,
	UMBRAL_MASTER_AXE = 22406,

	CRUDE_UMBRAL_CHOPPER = 22407,
	UMBRAL_CHOPPER = 22408,
	UMBRAL_MASTER_CHOPPER = 22409,

	CRUDE_UMBRAL_MACE = 22410,
	UMBRAL_MACE = 22411,
	UMBRAL_MASTER_MACE = 22412,

	CRUDE_UMBRAL_HAMMER = 22413,
	UMBRAL_HAMMER = 22414,
	UMBRAL_MASTER_HAMMER = 22415,

	CRUDE_UMBRAL_BOW = 22416,
	UMBRAL_BOW = 22417,
	UMBRAL_MASTER_BOW = 22418,

	CRUDE_UMBRAL_CROSSBOW = 22419,
	UMBRAL_CROSSBOW = 22420,
	UMBRAL_MASTER_CROSSBOW = 22421,

	CRUDE_UMBRAL_SPELLBOOK = 22422,
	UMBRAL_SPELLBOOK = 22423,
	UMBRAL_MASTER_SPELLBOOK = 22424
}

local TYPES = {
	SWORD = 1,
	AXE = 2,
	CLUB = 3,
	BOW = 4,
	CROSSBOW = 5,
	SPELLBOOK = 6
}

local SUB_TYPES = {
	BLADE = 1,
	SLAYER = 2,
	AXE = 3,
	CHOPPER = 4,
	MACE = 5,
	HAMMER = 6,
	BOW = 7,
	CROSSBOW = 8,
	SPELLBOOK = 9
}

local ACTION = {
	CREATE = 1,
	IMPROVE = 2,
	TRANSFORM = 3
}

-- dream START --
function dreamFirst(creature, message, keywords, parameters, node)

	if isPremium(creature) then
		addon = getPlayerStorageValue(creature, storage)
		if addon == -1 then
			if getPlayerItemCount(creature,22610) >= 1 then
				if doPlayerRemoveItem(creature,22610,1) then
					selfSay(newaddon, npc, creature)

					doSendMagicEffect(getCreaturePosition(creature), 13)
					doPlayerAddOutfit(creature, 577, 1)
					doPlayerAddOutfit(creature, 578, 1)
					setPlayerStorageValue(creature, storage,1)
				end
			else
				selfSay(noitems, npc, creature)
			end
		else
			selfSay(already, npc, creature)
		end
	end

end

function dreamSecond(creature, message, keywords, parameters, node)
		
	if isPremium(creature) then
		addon = getPlayerStorageValue(creature, storage+1)
		if addon == -1 then
			if getPlayerItemCount(creature,22609) >= 1 then
				if doPlayerRemoveItem(creature,22609,1) then
					selfSay(newaddon, npc, creature)
					
					doSendMagicEffect(getCreaturePosition(creature), 13)
					doPlayerAddOutfit(creature, 577, 2)
					doPlayerAddOutfit(creature, 578, 2)
					setPlayerStorageValue(creature, storage+1,1)
				end
			else
				selfSay(noitems, npc, creature)
			end
		else
			selfSay(already, npc, creature)
		end
	end
	
end
-- dream END --

local function greetCallback(npc, creature)
	local player = Player(creature)
	if player:getStorageValue(Storage.EruaranGreeting) > 0 then
		npcHandler:setMessage(MESSAGE_GREET, "Ashari Lillithy, so we meet {again}! What brings you here this time, general {information}, {transform}, {improve}, {create}, {outfit}, or {talk}?")
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|.')
		player:setStorageValue(Storage.EruaranGreeting, 1)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if msgcontains(message, "create") then
		npcHandler:say("You can try to create {sword}s, {axe}s, {club}s, {bow}s, {crossbow}s and {spellbook}s.", npc, creature)
		npcHandler.topic[creature] = 1
		action[creature] = ACTION.CREATE
	elseif msgcontains(message, "improve") then
		npcHandler:say("The raw object is nothing but a pale of shadow of its potential. As unsafe and unpredictable the imporvement is, it might boot the powers of your item immensely. You can try to improve {sword}s, {axe}s, {club}s, {bow}s, {crossbow}s and {spellbook}s.", npc, creature)
		npcHandler.topic[creature] = 1
		action[creature] = ACTION.IMPROVE
	elseif msgcontains(message, "transform") then
		npcHandler:say("From time to time fate smiles upon those who take great risks and have strong dreams! If you have the {ingredients}, we can try to give the ultimate refinement to {sword}s, {axe}s, {club}s, {bow}s, {crossbow}s and {spellbook}s.", npc, creature)
		npcHandler.topic[creature] = 1
		action[creature] = ACTION.TRANSFORM
	elseif msgcontains(message, "sword") and npcHandler.topic[creature] == 1 then
		weapon[creature] = TYPES.SWORD
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to create a crude umbral {blade} or crude umbral {slayer}?", npc, creature)
			npcHandler.topic[creature] = 2
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to improve a crude umbral {blade} or crude umbral {slayer}?", npc, creature)
			npcHandler.topic[creature] = 2
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to transform an umbral {blade} or umbral {slayer}?", npc, creature)
			npcHandler.topic[creature] = 2
		end
	elseif msgcontains(message, "blade") or msgcontains(message, "slayer") and npcHandler.topic[creature] == 2 then
		weapon_sub[creature] = (msgcontains(message, "blade") and SUB_TYPES.BLADE or SUB_TYPES.SLAYER)
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to spend " .. (Config.Create.DreamMatter == 1 and "your" or Config.Create.DreamMatter) .. " dream matter with " .. (Config.Create.Clusters > 1 and "those" or "your") .. " " .. Config.Create.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to spend your crude umbral " .. (weapon_sub[creature] == SUB_TYPES.BLADE and "blade" or "slayer") .. " with " .. (Config.Improve.Clusters > 1 and "those" or "your") .. " " .. Config.Improve.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to spend your umbral " .. (weapon_sub[creature] == SUB_TYPES.BLADE and "blade" or "slayer") .. " with " .. (Config.Transform.Clusters > 1 and "those" or "your") .. " " .. Config.Transform.Clusters .. " clusters of {solace} and give it a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		end
	elseif msgcontains(message, "axe") and npcHandler.topic[creature] == 1 then
		weapon[creature] = TYPES.AXE
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to create a crude umbral {axe} or crude umbral {chopper}?", npc, creature)
			npcHandler.topic[creature] = 2
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to improve a crude umbral {axe} or crude umbral {chopper}?", npc, creature)
			npcHandler.topic[creature] = 2
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to transform an umbral {axe} or umbral {chopper}?", npc, creature)
			npcHandler.topic[creature] = 2
		end
	elseif msgcontains(message, "axe") or msgcontains(message, "chopper") and npcHandler.topic[creature] == 2 then
		weapon_sub[creature] = (msgcontains(message, "axe") and SUB_TYPES.AXE or SUB_TYPES.CHOPPER)
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to spend your dream matter with those 25 clusters of {solace} and give a shot. {Yes} or {no}", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to spend your crude umbral " .. (weapon_sub[creature] == SUB_TYPES.AXE and "axe" or "chopper") .. " with " .. (Config.Improve.Clusters > 1 and "those" or "your") .. " " .. Config.Improve.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to spend your umbral " .. (weapon_sub[creature] == SUB_TYPES.AXE and "axe" or "chopper") .. " with " .. (Config.Transform.Clusters > 1 and "those" or "your") .. " " .. Config.Transform.Clusters .. " clusters of {solace} and give it a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		end
	elseif msgcontains(message, "club") and npcHandler.topic[creature] == 1 then
		weapon[creature] = TYPES.CLUB
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to create a crude umbral {mace} or crude umbral {hammer}?", npc, creature)
			npcHandler.topic[creature] = 2
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to improve a crude umbral {mace} or crude umbral {hammer}?", npc, creature)
			npcHandler.topic[creature] = 2
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to transform an umbral {mace} or umbral {hammer}?", npc, creature)
			npcHandler.topic[creature] = 2
		end
	elseif isInArray({"mace", "hammer"}, message) and npcHandler.topic[creature] == 2 then
		weapon_sub[creature] = (msgcontains(message, "mace") and SUB_TYPES.MACE or SUB_TYPES.HAMMER)
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to spend your dream matter with " .. (Config.Create.Clusters > 1 and "those" or "your") .. " " .. Config.Create.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to spend your crude umbral " .. (weapon_sub[creature] == SUB_TYPES.MACE and "mace" or "hammer") .. " with " .. (Config.Improve.Clusters > 1 and "those" or "your") .. " " .. Config.Improve.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to spend your umbral " .. (weapon_sub[creature] == SUB_TYPES.MACE and "mace" or "hammer") .. " with " .. (Config.Transform.Clusters > 1 and "those" or "your") .. " " .. Config.Transform.Clusters .. " clusters of {solace} and give it a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		end
	elseif msgcontains(message, "bow") and npcHandler.topic[creature] == 1 then
		weapon[creature] = TYPES.BOW
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to spend your dream matter with " .. (Config.Create.Clusters > 1 and "those" or "your") .. " " .. Config.Create.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to spend your crude umbral bow with " .. (Config.Improve.Clusters > 1 and "those" or "your") .. " " .. Config.Improve.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to spend your umbral bow with " .. (Config.Transform.Clusters > 1 and "those" or "your") .. " " .. Config.Transform.Clusters .. " clusters of {solace} and give it a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		end
	elseif msgcontains(message, "crossbow") and npcHandler.topic[creature] == 1 then
		weapon[creature] = TYPES.CROSSBOW
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to spend your dream matter with " .. (Config.Create.Clusters > 1 and "those" or "your") .. " " .. Config.Create.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to spend your crude umbral crossbow with " .. (Config.Improve.Clusters > 1 and "those" or "your") .. " " .. Config.Improve.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to spend your umbral crossbow with " .. (Config.Transform.Clusters > 1 and "those" or "your") .. " " .. Config.Transform.Clusters .. " clusters of {solace} and give it a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		end
	elseif msgcontains(message, "spellbook") and npcHandler.topic[creature] == 1 then
		weapon[creature] = TYPES.SPELLBOOK
		if action[creature] == ACTION.CREATE then
			npcHandler:say("Do you want to spend your dream matter with " .. (Config.Create.Clusters > 1 and "those" or "your") .. " " .. Config.Create.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.IMPROVE then
			npcHandler:say("Do you want to spend your crude umbral spellbook with " .. (Config.Improve.Clusters > 1 and "those" or "your") .. " " .. Config.Improve.Clusters .. " clusters of {solace} and give a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		elseif action[creature] == ACTION.TRANSFORM then
			npcHandler:say("Do you want to spend your umbral spellbook with " .. (Config.Transform.Clusters > 1 and "those" or "your") .. " " .. Config.Transform.Clusters .. " clusters of {solace} and give it a shot. {Yes} or {no}?", npc, creature)
			npcHandler.topic[creature] = 3
		end
	elseif msgcontains(message, "yes") and npcHandler.topic[creature] == 3 then

		if action[creature] == ACTION.CREATE then --create
			if player:getItemCount(IDS.DREAM_MATTER) >= 1 and player:getItemCount(IDS.CLUSTER_OF_SOLACE) >= Config.Create.Clusters then
				if math.random(100) <= Config.Create.Chance then
					local newItemId = (weapon[creature] == TYPES.SWORD and (weapon_sub[creature] == SUB_TYPES.BLADE and IDS.CRUDE_UMBRAL_BLADE or IDS.CRUDE_UMBRAL_SLAYER) or weapon[creature] == TYPES.AXE and (weapon_sub[creature] == SUB_TYPES.AXE and IDS.CRUDE_UMBRAL_AXE or IDS.CRUDE_UMBRAL_CHOPPER) or weapon[creature] == TYPES.CLUB and (weapon_sub[creature] == SUB_TYPES.MACE and IDS.CRUDE_UMBRAL_MACE or IDS.CRUDE_UMBRAL_HAMMER) or weapon[creature] == TYPES.BOW and IDS.CRUDE_UMBRAL_BOW or weapon[creature] == TYPES.CROSSBOW and IDS.CRUDE_UMBRAL_CROSSBOW or weapon[creature] == TYPES.SPELLBOOK and IDS.CRUDE_UMBRAL_SPELLBOOK or false)
					if newItemId then
						player:addItem(newItemId)
						player:removeItem(IDS.DREAM_MATTER, Config.Create.DreamMatter)
						player:removeItem(IDS.CLUSTER_OF_SOLACE, Config.Create.Clusters)
						npcHandler:say("Your dreams are strong, the creation was successful. Take your " .. ItemType(newItemId):getName() .. ".", npc, creature)
					else
						npcHandler:say("Something weird happened! You should contact a gamemaster.", npc, creature)
					end
				else
					npcHandler:say("Oh no! The process failed.", npc, creature)
					player:removeItem(IDS.DREAM_MATTER, 1)
				end
			else
				npcHandler:say("Sorry, you don't have the required ingredients.", npc, creature)
			end
		elseif action[creature] == ACTION.IMPROVE then --improve
			local oldItemId = (weapon[creature] == TYPES.SWORD and (weapon_sub[creature] == SUB_TYPES.BLADE and IDS.CRUDE_UMBRAL_BLADE or IDS.CRUDE_UMBRAL_SLAYER) or weapon[creature] == TYPES.AXE and (weapon_sub[creature] == SUB_TYPES.AXE and IDS.CRUDE_UMBRAL_AXE or IDS.CRUDE_UMBRAL_CHOPPER) or weapon[creature] == TYPES.CLUB and (weapon_sub[creature] == SUB_TYPES.MACE and IDS.CRUDE_UMBRAL_MACE or IDS.CRUDE_UMBRAL_HAMMER) or weapon[creature] == TYPES.BOW and IDS.CRUDE_UMBRAL_BOW or weapon[creature] == TYPES.CROSSBOW and IDS.CRUDE_UMBRAL_CROSSBOW or weapon[creature] == TYPES.SPELLBOOK and IDS.CRUDE_UMBRAL_SPELLBOOK or false)
			local newItemId = (oldItemId and oldItemId + 1 or false)
			if player:getItemCount(IDS.CLUSTER_OF_SOLACE) >= Config.Improve.Clusters then
				if newItemId and oldItemId then
					if player:getItemCount(oldItemId) > 0 then
						if math.random(100) <= Config.Improve.Chance then
							player:removeItem(oldItemId, 1)
							player:addItem(newItemId)
							player:removeItem(IDS.CLUSTER_OF_SOLACE, Config.Improve.Clusters)
							npcHandler:say("Your dreams are strong, the improvement was successful. Take your " .. ItemType(newItemId):getName() .. ".", npc, creature)
						else
							npcHandler:say("Oh no! The process failed.", npc, creature)
							local rand = math.random(100)
							player:removeItem((rand <= Config.Improve.BreakChance and oldItemId or IDS.CLUSTER_OF_SOLACE), (rand <= Config.Improve.BreakChance and 1 or Config.Improve.Clusters))
						end
					else
						npcHandler:say("You do not have " .. ItemType(oldItemId):getArticle() .. " " .. ItemType(oldItemId):getName() .. " with you.", npc, creature)
					end
				else
					npcHandler:say("Something weird happened! You should contact a gamemaster.", npc, creature)
				end
			end
		elseif action[creature] == ACTION.TRANSFORM then --transform
			local oldItemId = (weapon[creature] == TYPES.SWORD and (weapon_sub[creature] == SUB_TYPES.BLADE and IDS.UMBRAL_BLADE or IDS.UMBRAL_SLAYER) or weapon[creature] == TYPES.AXE and (weapon_sub[creature] == SUB_TYPES.AXE and IDS.UMBRAL_AXE or IDS.UMBRAL_CHOPPER) or weapon[creature] == TYPES.CLUB and (weapon_sub[creature] == SUB_TYPES.MACE and IDS.UMBRAL_MACE or IDS.UMBRAL_HAMMER) or weapon[creature] == TYPES.BOW and IDS.UMBRAL_BOW or weapon[creature] == TYPES.CROSSBOW and IDS.UMBRAL_CROSSBOW or weapon[creature] == TYPES.SPELLBOOK and IDS.UMBRAL_SPELLBOOK or false)
			local newItemId =  (oldItemId and oldItemId + 1 or false)
			if player:getItemCount(IDS.CLUSTER_OF_SOLACE) >= Config.Transform.Clusters then
				if newItemId and oldItemId then
					if player:getItemCount(oldItemId) > 0 then
						if math.random(100) <= Config.Transform.Chance then
							player:removeItem(oldItemId, 1)
							player:addItem(newItemId)
							player:removeItem(IDS.CLUSTER_OF_SOLACE, Config.Transform.Clusters)
							npcHandler:say("Your dreams are strong, the transforming was successful. Take your " .. ItemType(newItemId):getName() .. ".", npc, creature)
						else
							npcHandler:say("Oh no! The process failed.", npc, creature)
							local rand = math.random(100)
							if Config.Transform.BreakChance <= rand then
								player:removeItem(oldItemId, 1)
							else
								player:removeItem(oldItemId, 1)
								player:addItem(oldItemId - 1, 1)
								player:removeItem(IDS.CLUSTER_OF_SOLACE, Config.Transform.Clusters / 2)
							end
						end
					else
						npcHandler:say("You do not have " .. ItemType(oldItemId):getArticle() .. " " .. ItemType(oldItemId):getName() .. " with you.", npc, creature)
					end
				else
					npcHandler:say("Something weird happened! You should contact a gamemaster.", npc, creature)
				end
			end
		end
		npcHandler:removeInteraction(npc, creature)
		npcHandler:resetNpc()
	end
end

keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, text = 'What addon you are looking? I need for first addon: {dream warden claw} and for second {dream warden mask}.'})
	node1 = keywordHandler:addKeyword({'dream warden mask'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'To achieve the first dream addon you need to give me 1 dream warden claw. Do you have them with you?'})
	node1:addChildKeyword({'yes'}, dreamFirst, {})
	node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got all neccessary items.', reset = true})

	node2 = keywordHandler:addKeyword({'dream warden claw'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'To achieve the second dream addon you need to give me 1 dream warden mask. Do you have them with you?'})
	node2:addChildKeyword({'yes'}, dreamSecond, {})
	node2:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got all neccessary items.', reset = true})

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Greetings, |PLAYERNAME|."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Goodbye, |PLAYERNAME|."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")

npcHandler:addModule(FocusModule:new())

-- npcType registering the npcConfig table
npcType:register(npcConfig)