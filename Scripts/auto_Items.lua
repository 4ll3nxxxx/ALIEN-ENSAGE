--<<Automatic: Midas, Phase boots, bottle in fountain, Magic stick and Bloodstone if low hp>>
require("libs.Utils")

local play = false local delay = 0

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
    local bloodstone = me:FindItem("item_bloodstone")
    local bottle = me:FindItem("item_bottle")
	local phaseboots = me:FindItem("item_phase_boots")
	local midas = me:FindItem("item_hand_of_midas")
	local stick = me:FindItem("item_magic_stick") or me:FindItem("item_magic_wand")
	
	if tick > delay and SleepCheck("Zzz") then 

		if me.alive and not me:IsInvisible() and not me:IsChanneling() then

			local creeps = entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_CREEP and v.team ~= me.team and v.alive and v.visible and v.spawned and v.level >= 5 and not v.ancient and v.health > 0 and v.attackRange < 650 and v:GetDistance2D(me) < midas.castRange + 25 end)
			if midas and midas:CanBeCasted() then
				for _,v in ipairs(creeps) do
					me:CastAbility(midas,v)
				end
			end

			if bloodstone and bloodstone:CanBeCasted() and me.health/me.maxHealth < 0.1 then
				me:CastAbility(bloodstone,me.position)
			end

			if bottle and bottle:CanBeCasted() and me:DoesHaveModifier("modifier_fountain_aura_buff") and not me:DoesHaveModifier("modifier_bottle_regeneration") and (me.health < me.maxHealth or me.mana < me.maxMana) then
				me:CastAbility(bottle)
			end

			if phaseboots and phaseboots:CanBeCasted() then
				me:CastAbility(phaseboots)
			end

			if stick and stick:CanBeCasted() and stick.charges > 0 and me.health/me.maxHealth < 0.3 then
				me:CastAbility(stick)
			end
			
		end
		Sleep(client.latency,"Zzz")
		delay = tick + 250
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
