--<<Chicken lick my bottle Please!>>

require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "Y", config.TYPE_HOTKEY)
config:SetParameter("distance", 1200)
config:SetParameter("Xcord", 1550)
config:SetParameter("Ycord", 50)
config:Load()

local play = false local activated = false local giveitem = false local safety = false local delay = 0
local font = drawMgr:CreateFont("chicken","Arial",14,500)
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
		if tick > delay and SleepCheck("chicken") then
			local bottle = me:FindItem("item_bottle")
			local enemy = entityList:GetEntities(function (v) return (v.type==LuaEntity.TYPE_HERO or v.classId==CDOTA_BaseNPC_Tower or v.classId==CDOTA_Unit_SpiritBear) and v.team ~= me.team and v.alive and v.visible end)
			for i,v in ipairs(enemy) do
				if GetDistance2D(chicken,v) <= config.distance and chicken:GetAbility(1):CanBeCasted() then
					chicken:CastAbility(chicken:GetAbility(1))
					boost(chicken)
					Sleep(client.latency,"chicken")
					safety = false
				else
					safety = true
				end
			end
			if activated and safety then
				if bottle and bottle.charges == 0 then
					giveitem = true
					chicken:Follow(me)
					checkbase(chicken)
					boost(chicken)
					Sleep(1000+client.latency,"chicken")
				end
				if GetDistance2D(chicken,me) <= 250 and bottle and bottle.charges == 0  then
					giveitem = false
					checkchicken(chicken)
					mp:GiveItem(chicken,bottle)
					Sleep(1000+client.latency,"chicken")
				end
				local chickenbottle = chicken:FindItem("item_bottle")
				if chickenbottle and chickenbottle.charges == 0 and chicken:GetAbility(1):CanBeCasted() then
					chicken:CastAbility(chicken:GetAbility(1))
					boost(chicken)
					Sleep(1000+client.latency,"chicken")
				end
				if chickenbottle and chickenbottle.charges == 3 then
					checkchicken(chicken)
					checkbase(chicken)
					boost(chicken)
					Sleep(1000+client.latency,"chicken")
				end
			end
			delay = tick + 100
		end
	end
end

function checkbase(chicken)
	for i = 7, 12 do
		local item = entityList:GetMyHero():HasItem(i)
		if item and chicken and chicken:GetAbility(4):CanBeCasted() then
			chicken:CastAbility(chicken:GetAbility(4))
		end
	end
end

function checkchicken(chicken)
	if chicken and chicken:GetAbility(5):CanBeCasted() then
		chicken:CastAbility(chicken:GetAbility(5))
	end
end

function boost(chicken)
	if chicken:GetProperty("CDOTA_Unit_Courier","m_bFlyingCourier") then
		if chicken and chicken:GetAbility(6):CanBeCasted() then
			chicken:CastAbility(chicken:GetAbility(6))
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
