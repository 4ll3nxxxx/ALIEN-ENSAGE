require("libs.Utils")
require("libs.SideMessage")

local play = false local sleep = {0,0,0,0,0,0,0,0}

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO, visible = true, alive = true, team = me:GetEnemyTeam(), illusion=false})
	for i,v in ipairs(enemies) do
		if tick > sleep[1] and v:FindModifier("modifier_mirana_moonlight_shadow") then
			GenerateSideMessage("mirana","mirana_invis")
			sleep[1] = tick + 15000
		end
		if tick > sleep[2] and v:FindModifier("modifier_alchemist_unstable_concoction") then
			GenerateSideMessage("alchemist","alchemist_unstable_concoction")
			sleep[2] = tick + 15000
		end
		if tick > sleep[3] and v:FindModifier("modifier_morphling_replicate_timer") then
			GenerateSideMessage("morphling","morphling_replicate")
			sleep[3] = tick + 15000
		end
		if tick > sleep[4] and v:FindModifier("modifier_ember_spirit_fire_remnant_timer") then
			GenerateSideMessage("ember_spirit","ember_spirit_fire_remnant")
			sleep[4] = tick + 15000
		end
		if tick > sleep[5] and v:FindModifier("modifier_bloodseeker_thirst_speed") then
			GenerateSideMessage("bloodseeker","bloodseeker_thirst")
			sleep[5] = tick + 15000
		end
		if tick > sleep[6] and me:FindModifier("modifier_invoker_ghost_walk_enemy") then
			GenerateSideMessage("invoker","invoker_ghost_walk")
			sleep[6] = tick + 15000
		end
		if tick > sleep[7] and v.name == "npc_dota_hero_oracle" and v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
			GenerateSideMessage("oracle","oracle_false_promise")
			sleep[7] = tick + 15000
		end
		if tick > sleep[8] and v:FindModifier("modifier_item_invisibility_edge_windwalk")
			then ItemSideMessage(v.name:gsub("npc_dota_hero_",""),"invis_sword")
			sleep[8] = tick + 15000
		end
	end
end

function GenerateSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(180,50)
	test:AddElement(drawMgr:CreateRect(10,10,54,30,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName)))
	test:AddElement(drawMgr:CreateRect(70,12,62,31,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/arrow_usual")))
	test:AddElement(drawMgr:CreateRect(140,10,30,30,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
end

function ItemSideMessage(heroName,itemName)
	local test = sideMessage:CreateMessage(180,48)
	test:AddElement(drawMgr:CreateRect(006,06,72,36,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName)))
	test:AddElement(drawMgr:CreateRect(078,12,64,32,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/arrow_usual")))
    test:AddElement(drawMgr:CreateRect(142,06,72,36,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/items/"..(itemName))))
end


function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		collectgarbage("collect")
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
