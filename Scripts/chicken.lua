--<<Chicken lick my bottle Please!>>

require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "Y", config.TYPE_HOTKEY)
config:SetParameter("distance", 1200)
config:SetParameter("Xcord", 500)
config:SetParameter("Ycord", 50)
config:Load()

local play = false local activated = false local giveitem = false local safety = false local delay = 0
local font = drawMgr:CreateFont("chicken","Tahoma",14,500)
local text = drawMgr:CreateText(config.Xcord,config.Ycord,0xFFFF00FF,"Hello, I'm Waiting for lick your bottle!",font) text.visible = false

function Key(msg,code)
	if msg ~= KEY_UP and code == config.Hotkey and not client.chat then
		if not activated then
			activated = true
			text.text = "Hello, I'm Waiting for lick your bottle!"
		else
			activated = false
			text.text = "You Dont't need me?, Dont Call me again, Your Motherfucker"
		end
	end
end

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero() local mp = entityList:GetMyPlayer()
	local chicken = entityList:FindEntities({classId=CDOTA_Unit_Courier,team=me.team,alive=true})[1]
	if chicken then
		if tick > delay and SleepCheck("Zzz") then
			local bottle = me:FindItem("item_bottle")
			local heros = entityList:GetEntities({type=LuaEntity.TYPE_HERO,visible=true,alive=true,team=me:GetEnemyTeam()})
			for i,v in ipairs(heros) do
				if GetDistance2D(chicken,v) <= config.distance and chicken:GetAbility(1):CanBeCasted() then
					chicken:CastAbility(chicken:GetAbility(1))
					Boost(chicken)
					Sleep(client.latency,"Zzz")
					safety = false
				else
					safety = true
				end
			end
			if activated and safety then
				if bottle and bottle.charges == 0 then
					giveitem = true
					CheckStash(chicken)
					chicken:Follow(me)
					Sleep(client.latency,"Zzz")
				end
				if GetDistance2D(chicken,me) <= 250 and bottle and bottle.charges == 0  then
					giveitem = false
					Deliver(chicken)
					mp:GiveItem(chicken,bottle)
					Sleep(client.latency,"Zzz")
				end
				local chickenbottle = chicken:FindItem("item_bottle")
				if chickenbottle and chickenbottle.charges == 0 and chicken:GetAbility(1):CanBeCasted() then
					chicken:CastAbility(chicken:GetAbility(1))
					Boost(chicken)
					Sleep(client.latency,"Zzz")
				end
				if chickenbottle and chickenbottle.charges == 3 and chicken:GetAbility(5):CanBeCasted() then
					chicken:CastAbility(chicken:GetAbility(5))
					CheckStash(chicken)
					Boost(chicken)
					Sleep(client.latency,"Zzz")
				end
			end
			delay = tick + 550
		end
	end
end

function Deliver(chicken)
	if chicken and chicken:GetAbility(5):CanBeCasted() then
		chicken:CastAbility(chicken:GetAbility(5))
	end
end

function Boost(chicken)
	if chicken and chicken:GetAbility(6):CanBeCasted() then
		chicken:CastAbility(chicken:GetAbility(6))
	end
end

function CheckStash(chicken)
	for i = 7, 12 do
		local item = entityList:GetMyHero():GetItem(i)
		if item and chicken:GetAbility(4):CanBeCasted() then
			chicken:CastAbility(chicken:GetAbility(4))
		end
	end
end

function Load()
	if PlayingGame() then
		play = true
		safety = true
		activated = true
		text.visible = true
		script:RegisterEvent(EVENT_KEY,Key)
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	activated = false
	giveitem = false
	safety = false
	text.visible = false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
