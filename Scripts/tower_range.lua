local Play = false local eff = {}

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
	local towers = entityList:FindEntities({classId=CDOTA_BaseNPC_Tower,alive=true})
	for i,v in ipairs(towers) do
		if GetDistance2D(me,v) < 1400 then
			if not eff[v.handle] then
				eff[v.handle] = Effect(v,"range_display")
				eff[v.handle]:SetVector(1,Vector(850,0,0))
			end
		elseif eff[v.handle] then
			eff[v.handle] = nil
			collectgarbage("collect")
		end
	end	
end

function Load()
	if PlayingGame() then
		Play = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	eff = {}
	collectgarbage("collect")
	if Play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		Play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)