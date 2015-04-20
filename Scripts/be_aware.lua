require("libs.Utils")
require("libs.SideMessage")

local play = false

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO, visible = true, alive = true, team = me:GetEnemyTeam(), illusion=false})
	for i,v in ipairs(enemies) do
		if SleepCheck("mirana") and v:FindModifier("modifier_mirana_moonlight_shadow") then
			GenerateSideMessage("mirana","mirana_invis") Sleep(15000,"mirana")
		elseif SleepCheck("alchemist") and v:FindModifier("modifier_alchemist_unstable_concoction") then
			GenerateSideMessage("alchemist","alchemist_unstable_concoction") Sleep(10000,"alchemist")
		elseif SleepCheck("morphling") and v:FindModifier("modifier_morphling_replicate_timer") then
			GenerateSideMessage("morphling","morphling_replicate") Sleep(10000,"morphling")
		elseif SleepCheck("ember_spirit") and v:FindModifier("modifier_ember_spirit_fire_remnant_timer") then
			GenerateSideMessage("ember_spirit","ember_spirit_fire_remnant") Sleep(15000,"ember_spirit")
		elseif SleepCheck("bloodseeker") and v:FindModifier("modifier_bloodseeker_thirst_speed") then
			GenerateSideMessage("bloodseeker","bloodseeker_thirst") Sleep(15000,"bloodseeker")
		elseif SleepCheck("invoker") and me:FindModifier("modifier_invoker_ghost_walk_enemy") then
			GenerateSideMessage("invoker","invoker_ghost_walk") Sleep(10000,"invoker")
		elseif SleepCheck("oracle") and v.name == "npc_dota_hero_oracle" and v:GetAbility(4) and v:GetAbility(4).level > 0 and v:GetAbility(4).abilityPhase then
			GenerateSideMessage("oracle","oracle_false_promise") Sleep(10000,"oracle")
		elseif SleepCheck("shadowblade") and v:FindModifier("modifier_item_invisibility_edge_windwalk") then
			ItemSideMessage(v.name:gsub("npc_dota_hero_",""),"invis_sword") Sleep(10000,"shadowblade") 
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
