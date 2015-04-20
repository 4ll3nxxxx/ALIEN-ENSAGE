require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("hotkey", "F", config.TYPE_HOTKEY)
config:Load()

local eff = {} local play = false local sleep = 0

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()

    if not eff[me.handle] then
        eff[me.handle] = Effect(me,"range_display")
        eff[me.handle]:SetVector(1, Vector(1200,0,0))
    end
    
    if IsKeyDown(config.hotkey) and not client.chat then
        local blink = me:FindItem("item_blink")
        local distance = math.sqrt(math.pow(client.mousePosition.x - me.position.x, 2) + math.pow(client.mousePosition.y - me.position.y, 2))
        local expectedY = ((client.mousePosition.y - me.position.y) / distance) * 1199 + me.position.y
        local expectedX = ((client.mousePosition.x - me.position.x) / distance) * 1199 + me.position.x
        local blinkPosition = Vector(expectedX, expectedY, 0)

        if tick > sleep and blink and blink:CanBeCasted() then
            if distance > 0 and distance > 1200 then
                me:CastAbility(blink, blinkPosition)
            else
                me:CastAbility(blink, Vector(client.mousePosition.x, client.mousePosition.y, 0))
            end
        end
        sleep = tick + 250
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

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
