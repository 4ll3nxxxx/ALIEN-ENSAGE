--<<Automatic: Midas, Phase boots, bottle in fountain, Magic stick and Bloodstone if low hp>>
require("libs.Utils")

local play = false local sleep = {0,0,0,0,0}

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()

    local bloodstone = me:FindItem("item_bloodstone")
    local bottle = me:FindItem("item_bottle")
	local phaseboots = me:FindItem("item_phase_boots")
	local midas = me:FindItem("item_hand_of_midas")
	local stick = me:FindItem("item_magic_stick") or me:FindItem("item_magic_wand")
	local shadowplay = me:DoesHaveModifier("modifier_item_silver_edge_windwalk") or me:DoesHaveModifier("modifier_item_invisibility_edge_windwalk") or me:DoesHaveModifier("modifier_clinkz_wind_walk") or me:DoesHaveModifier("modifier_riki_permanent_invisibility") or me:DoesHaveModifier("modifier_bounty_hunter_wind_walk") or me:DoesHaveModifier("modifier_invoker_ghost_walk_self") or me:DoesHaveModifier("modifier_templar_assassin_meld") or me:DoesHaveModifier("modifier_mirana_moonlight_shadow") or me:DoesHaveModifier("modifier_rune_invis")

	if me.alive and not shadowplay and not me:IsChanneling() then
		if tick > sleep[1] and midas and midas:CanBeCasted() then
			for _,v in ipairs(entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_CREEP and v.team ~= me.team and v.alive and v.visible and v.spawned and v.level >= 5 and not v.ancient and v.health > 0 and v.attackRange < 650 and v:GetDistance2D(me) < midas.castRange + 25 end)) do
				me:CastAbility(midas,v)
				sleep[1] = tick + 1000
			end
		end

		if tick > sleep[2] and bloodstone and bloodstone:CanBeCasted() and me.health/me.maxHealth < 0.1 then
			me:CastAbility(bloodstone,me.position)
			sleep[2] = tick + 1000
		end

		if tick > sleep[3] and bottle and bottle:CanBeCasted() and me:DoesHaveModifier("modifier_fountain_aura_buff") and not me:DoesHaveModifier("modifier_bottle_regeneration") and (me.health < me.maxHealth or me.mana < me.maxMana) then
			me:CastAbility(bottle)
			sleep[3] = tick + 1000
		end

		if tick > sleep[4] and phaseboots and phaseboots:CanBeCasted() then
			me:CastAbility(phaseboots)
			sleep[4] = tick + 1000
		end

		if tick > sleep[5] and stick and stick:CanBeCasted() and stick.charges > 0 and me.health/me.maxHealth < 0.3 then
			me:CastAbility(stick)
			sleep[5] = tick + 1000
		end

	end
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
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
