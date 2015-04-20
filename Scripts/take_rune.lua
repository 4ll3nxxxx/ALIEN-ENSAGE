require("libs.DrawManager3D")
require("libs.ScriptConfig")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "M", config.TYPE_HOTKEY)
config:Load()

local play = false local activated = false

local rec1 = drawMgr3D:CreateRect(Vector(-2272,1792,0), Vector(0,0,0), Vector2D(0,0), Vector2D(30,30), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/fav_heart"))
local rec2 = drawMgr3D:CreateRect(Vector(3000,-2450,0), Vector(0,0,0), Vector2D(0,0), Vector2D(30,30), 0x000000ff, drawMgr:GetTextureId("NyanUI/other/fav_heart"))

function Key(msg,code)
	if msg ~= KEY_UP and code == config.Hotkey and not client.chat then
		if not activated then
			activated = true
			rec1.visible = true
			rec2.visible = true
		else
			activated = false
			rec1.visible = false
			rec2.visible = false
		end
	end
end

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local runes = entityList:GetEntities(function (ent) return ent.classId==CDOTA_Item_Rune and GetDistance2D(ent,me) < 200 end)[1]	
	if activated and runes then 
		entityList:GetMyPlayer():Select(me)
		entityList:GetMyPlayer():TakeRune(runes)	
	end
end


function Load()
	if PlayingGame() then
		play = true
		activated = true
		rec1.visible = true
		rec2.visible = true
		script:RegisterEvent(EVENT_KEY,Key)
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	collectgarbage("collect")
	rec1.visible = false
	rec2.visible = false
	if play then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
