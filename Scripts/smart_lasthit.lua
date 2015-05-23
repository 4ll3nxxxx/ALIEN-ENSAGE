--<<Hold "tab" key Auto Lasthit>>

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.VectorOp")

local config = ScriptConfig.new()
config:SetParameter("Lasthit", "9", config.TYPE_HOTKEY)
config:Load()

local play = false local dmg = 0

function Main(tick)
	if not SleepCheck() or not PlayingGame() then return end
	Sleep(100)
	local me = entityList:GetMyHero()
	if IsKeyDown(config.Lasthit) and not client.chat then
		for i,v in ipairs(entityList:FindEntities(function (v) return (v.type == LuaEntity.TYPE_CREEP or v.classId == CDOTA_BaseNPC_Tower) and v.alive and v.visible and GetDistance2D(v,me) <= 2000 end)) do
			if v.health < v:DamageTaken(dmg + 50 + me.dmgMin + me.dmgBonus, DAMAGE_PHYS, me) then
				me:Attack(v)
				if v.health < v:DamageTaken(me.dmgMin + me.dmgBonus, DAMAGE_PHYS, me) then
					me:Attack(v)
				else
					if SleepCheck("attack") then
						me:Stop()
						Sleep(250, "attack")
					end
				end
			end
		end
	end
end

function Load()
	if PlayingGame() then
		play = true
		activated = true
		script:RegisterEvent(EVENT_TICK, Main)
		script:UnregisterEvent(Load)
	end
end

function Close()
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK, Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_TICK, Load)