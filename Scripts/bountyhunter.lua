require("libs.Utils")

local play = false local myhero = nil

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
    local ID = me.classId if ID ~= myhero then return end
    local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,visible=true,alive=true,team=me:GetEnemyTeam(),illusion=false})
    for i,v in ipairs(enemies) do
		local spell = me:GetAbility(1)
		local spell4 = me:GetAbility(4)
		local distance = GetDistance2D(me,v)
		local buff = v:DoesHaveModifier("modifier_bounty_hunter_track") or me:DoesHaveModifier("modifier_bounty_hunter_wind_walk")
		local invis = v:FindItem("item_invis_sword") or v:FindItem("item_shadow_amulet") local irune = v:FindItem("item_bottle")

		if me.alive and spell and spell:CanBeCasted() and v.health < v:DamageTaken(spell:GetSpecialData("bonus_damage",spell.level),DAMAGE_MAGC,me) and GetDistance2D(v,me) <= spell.castRange and  SleepCheck("spell") then
			me:SafeCastAbility(spell,v)
			Sleep(400, "spell")
		end

		if me.alive and spell4 and spell4:CanBeCasted() and not buff and distance <= spell4.castRange and SleepCheck("spell4") then
			if v.name == "npc_dota_hero_riki" or v.name == "npc_dota_hero_clinkz" or v.name == "npc_dota_hero_nyx_assassin" or v.name == "npc_dota_hero_templar_assassin" or v.name == "npc_dota_hero_broodmother" or v.name == "npc_dota_hero_weaver" or v.name == "npc_dota_hero_treant" or v.name == "npc_dota_hero_sand_king" or v.name == "npc_dota_hero_invoker" then
				me:SafeCastAbility(spell4,v)
				Sleep(400, "spell4")
			elseif irune and irune.storedRune == 3 then
				me:SafeCastAbility(spell4,v)
				Sleep(400, "spell4")
			elseif invis and v:CanCast() then
				me:SafeCastAbility(spell4,v)
				Sleep(400, "spell4")
			elseif v.health/v.maxHealth < 0.4 then
				me:SafeCastAbility(spell4,v)
				Sleep(400, "spell4")
				return
			end
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_BountyHunter then 
			script:Disable() 
		else
			play = true
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	myhero = nil
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)