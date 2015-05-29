require('libs.DrawManager3D')

local play = false
local illusionTable = {}
local heroTable = {}

function Tick(tick)
    if not SleepCheck() or not PlayingGame() then return end Sleep(200)
	for _, heroEntity in ipairs(entityList:FindEntities({type = LuaEntity.TYPE_HERO, illusion = true, team = entityList:GetMyHero():GetEnemyTeam()})) do
		if not (heroEntity.type == 9 and heroEntity.meepoIllusion == false) then
			if heroEntity.visible and heroEntity.alive and heroEntity:GetProperty("CDOTA_BaseNPC","m_nUnitState") ~= -1031241196  then	
				if not illusionTable[heroEntity.handle] then
					illusionTable[heroEntity.handle] = drawMgr3D:CreateText(heroEntity, Vector(0,0,heroEntity.healthbarOffset),Vector2D(0,-9),0xFFFF00FF,"Illusion",drawMgr:CreateFont("defaultFont","Arial",16,1800))
				end
			else
				if illusionTable[heroEntity.handle] then
					illusionTable[heroEntity.handle]:Destroy()
					illusionTable[heroEntity.handle] = nil
				end
			end
		end
	end	

	for _, heroEntity in ipairs(entityList:FindEntities({type = LuaEntity.TYPE_HERO, illusion = false, team = entityList:GetMyHero():GetEnemyTeam()})) do
		if heroEntity.classId == CDOTA_Unit_Hero_PhantomLancer or heroEntity.classId == CDOTA_Unit_Hero_Naga_Siren or heroEntity.classId == CDOTA_Unit_Hero_ChaosKnight then
			if heroEntity.visible and heroEntity.alive then
				if not heroTable[heroEntity.handle] then
					heroTable[heroEntity.handle] = drawMgr3D:CreateText(heroEntity, Vector(0,0,heroEntity.healthbarOffset),Vector2D(0,-9),0xFF0000FF,"Real",drawMgr:CreateFont("defaultFont","Arial",16,1800))
				end
			else
				if heroTable[heroEntity.handle] then
					heroTable[heroEntity.handle]:Destroy()
					heroTable[heroEntity.handle] = nil
				end
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