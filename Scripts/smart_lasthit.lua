--<<Hold "tab" key Auto Lasthit>>

require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Lasthit", "9", config.TYPE_HOTKEY)
config:Load()

local play = false local creeps = nil local dmg = 0

function Main(tick)
	if not SleepCheck() or not PlayingGame() then return end
	Sleep(100)
	local me = entityList:GetMyHero()
	local creeps = FindCreeps(me)
	if IsKeyDown(config.Lasthit) and not client.chat then
		if creeps.health < creeps:DamageTaken(dmg + 50 + me.dmgMin + me.dmgBonus, DAMAGE_PHYS, me) then
			me:Attack(creeps)
			if creeps.health < creeps:DamageTaken(me.dmgMin + me.dmgBonus, DAMAGE_PHYS, me) then
				me:Attack(creeps)
			else
				if SleepCheck("stop") then
					me:Stop()
					Sleep(250, "stop")
				end
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