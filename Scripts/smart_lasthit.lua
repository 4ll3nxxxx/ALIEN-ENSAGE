--<<Hold "tab" key Auto Lasthit>>

require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Lasthit", "9", config.TYPE_HOTKEY)
config:Load()

local play = false local creeps = nil local sleep = 0

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local creeps = FindCreeps(me)
	local damageMin = GetDamage(creeps,me)
	if IsKeyDown(config.Lasthit) and not client.chat and tick > sleep then
		if creeps.health < creeps.maxHealth * 0.4 and not isAttacking(me) and SleepCheck("move") and GetDistance2D(creeps,me) >= me.attackRange + 50 then
			me:Move(creeps.position, true)
			Sleep(1000, "move")
		end
		if creeps.health < damageMin then
			me:Attack(creeps)
			sleep = tick + 100
		else
			if isAttacking(me) and GetDistance2D(creeps,me) <= me.attackRange + 50 and SleepCheck("stop") then
				me:Stop()
				Sleep(100, "stop")
			end
		end
	end
end

function FindCreeps(me)
	local creeps = entityList:GetEntities(function (v) return (v.classId == CDOTA_BaseNPC_Creep_Lane or v.classId == CDOTA_BaseNPC_Creep_Siege or v.classId == CDOTA_BaseNPC_Tower) and (v.team ~= me.team or v.team == me.team) and v.visible and v.alive and v.health > 0 and me:GetDistance2D(v) <= 2000 end)
	if #creeps == 0 then
		return entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.team ~= me.team end)[1]
	elseif #creeps == 1 then
		return creeps[1]	
	else
		table.sort(creeps, function (a,b) return a.health < b.health end)
		return creeps[1]
	end
end

function isAttacking(ent)
	return ent.activity == LuaEntityNPC.ACTIVITY_ATTACK or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK1 or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK2
end

function GetDamage(creeps,me)
	local creeps = FindCreeps(me)
	local damageMin = me.dmgMin + me.dmgBonus
	local qb = me:FindItem("item_quelling_blade")
	if creeps.team ~= me.team and creeps.classId ~= CDOTA_BaseNPC_Creep_Siege then
		if qb then
            if me.attackType == LuaEntityNPC.ATTACK_MELEE then
            	local bonus = qb:GetSpecialData("damage_bonus")/100
                damageMin = damageMin + damageMin * bonus
            elseif me.attackType == LuaEntityNPC.ATTACK_RANGED then
            	local bonus = qb:GetSpecialData("damage_bonus_ranged")/100
                damageMin = damageMin + damageMin * bonus
            end
        end
        if me.classId == CDOTA_Unit_Hero_BountyHunter then
			local Ability = me:GetAbility(2)
			local bonus = Ability:GetSpecialData("crit_multiplier",Ability.level)/100
			if Ability.level > 0 and Ability.cd == 0 then
				damageMin = damageMin + damageMin * bonus
			end
        elseif me.classId == CDOTA_Unit_Hero_Kunkka then
			local Ability = me:GetAbility(2)
			local bonus = Ability:GetSpecialData("damage_bonus",Ability.level)
			if Ability.level > 0 and Ability.cd == 0 then
				damageMin = damageMin + damageMin + bonus
			end
		end
    end
    if creeps.classId == CDOTA_BaseNPC_Creep_Siege then
        damageMin = damageMin / 2
    end
    return creeps:DamageTaken(damageMin,DAMAGE_PHYS,me)
end

function Load()
	if PlayingGame() then
		play = true
		creeps = nil
		script:RegisterEvent(EVENT_FRAME, Main)
		script:UnregisterEvent(Load)
	end
end

function Close()
	creeps = nil
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK, Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)