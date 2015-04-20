require("libs.Utils")

local play = false local eff = {}

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
    local entities = entityList:GetEntities(function (v) return (v.type==LuaEntity.TYPE_HERO or v.classId==403 or v.classId==385 or v.classId==386 or v.classId==388 or v.classId==463 or v.classId==527 or v.classId==401) and v.team==me.team end)
    for _,v in ipairs(entities) do
        if v.visibleToEnemy and v.alive then
            if not eff[v.handle] then                            
                eff[v.handle] = Effect(v,"aura_shivas")
                eff[v.handle]:SetVector(1,Vector(0,0,0))
            end
        elseif eff[v.handle] then
            eff[v.handle] = nil
            collectgarbage("collect")
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
    eff = {}
	collectgarbage("collect")
    if play then
        script:UnregisterEvent(Tick)
        script:RegisterEvent(EVENT_TICK,Load)
        play = false
    end
end


script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
