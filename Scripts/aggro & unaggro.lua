require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("aggro", "X", config.TYPE_HOTKEY)
config:SetParameter("unaggro", "C", config.TYPE_HOTKEY)
config:Load()

local play = false local sleep = 0

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	
	if tick > sleep and IsKeyDown(config.aggro) and not client.chat then
		for i, v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,team=me:GetEnemyTeam(),illusion=false})) do
			if v.alive then
				if GetDistance2D(v,me) <= 1200 then	
					entityList:GetMyPlayer():Attack(v)
					sleep = tick + 100
				end
			end
		end
	end
	if tick > sleep and IsKeyDown(config.unaggro) and not client.chat then
		local creeps = entityList:GetEntities(function (v) return v.classId == CDOTA_BaseNPC_Creep_Lane and v.team == me.team and v.alive and v.visible and v:GetDistance2D(me) < me.attackRange + 200 end)
		if creeps and #creeps > 0 then
			entityList:GetMyPlayer():Attack(creeps[1])
			sleep = tick + 100
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

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)