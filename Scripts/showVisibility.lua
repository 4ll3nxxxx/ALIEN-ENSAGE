require("libs.Utils")

play, effects = false, {}

function Tick(tick)
    if not PlayingGame() then return end
    local npc, dirty = entityList:GetEntities(function (ent) return ent.npc end), false
    for i,v in ipairs(npc) do
        if v.team ~= entityList:GetMyHero():GetEnemyTeam() and v.classId ~= CDOTA_BaseNPC_Creep_Lane and v.classId ~= CDOTA_BaseNPC_Creep_Siege then
            if effects[v.handle] == nil and v.visibleToEnemy and v.alive then                  
                effects[v.handle] = Effect(v,"aura_shivas")
                effects[v.handle]:SetVector(1,Vector(0,0,0))
            elseif effects[v.handle] ~= nil and not v.visibleToEnemy or not v.alive then
                effects[v.handle] = nil
                dirty = true
            end
        end
    end
    if dirty then
        collectgarbage("collect")
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
    effects = {}
	collectgarbage("collect")
    if play then
        script:UnregisterEvent(Tick)
        script:RegisterEvent(EVENT_TICK,Load)
        play = false
    end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
