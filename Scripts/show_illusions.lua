local play = false
local illusionTable = {}

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
	local illusions = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=true,team = (5-me.team)})	--
	for _, heroEntity in ipairs(illusions) do
		if not (heroEntity.type == 9 and heroEntity.meepoIllusion == false) then
			if heroEntity.visible and heroEntity.alive and heroEntity:GetProperty("CDOTA_BaseNPC","m_nUnitState") ~= -1031241196  then	
				if not illusionTable[heroEntity.handle] then
					illusionTable[heroEntity.handle] = {}
					illusionTable[heroEntity.handle].effect1 = Effect(heroEntity,"shadow_amulet_active_ground_proj")			
					illusionTable[heroEntity.handle].effect2 = Effect(heroEntity,"smoke_of_deceit_buff")
					illusionTable[heroEntity.handle].effect3 = Effect(heroEntity,"smoke_of_deceit_buff")			
					illusionTable[heroEntity.handle].effect4 = Effect(heroEntity,"smoke_of_deceit_buff")
				end
			elseif illusionTable[heroEntity.handle] then
				illusionTable[heroEntity.handle] = nil
				collectgarbage("collect")
			end
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
	llusionTable = {}
	collectgarbage("collect")
	if play then	
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end
 
script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)