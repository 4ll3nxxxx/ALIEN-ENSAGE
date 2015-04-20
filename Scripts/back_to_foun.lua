--<<You can use hotkey for quick teleport meepos.>>

require("libs.ScriptConfig")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "B", config.TYPE_HOTKEY)
config:Load()

local play = false

function Tick(tick)
	if not PlayingGame() then return end
	
	local mp = entityList:GetMyPlayer()  local sel = mp.selection[1]

	if mp.team == LuaEntity.TEAM_RADIANT then
		foun = Vector(-7272,-6757,270)
	else
		foun = Vector(7200,6624,256)
	end

	if IsKeyDown(config.Hotkey) and not client.chat then
		local scroll = sel:FindItem("item_tpscroll") or sel:FindItem("item_travel_boots")
		if SleepCheck("scroll") and scroll and scroll:CanBeCasted() then
			sel:CastAbility(scroll,foun) Sleep(700,"scroll")
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

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
