--<<"shift" Key On/Off>>

require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "16", config.TYPE_HOTKEY)
config:SetParameter("Xcord", 1462)
config:SetParameter("Ycord", 50)
config:Load()

local play = false local activated = false

local font = drawMgr:CreateFont("Lasthit","Arial",14,500)
local text = drawMgr:CreateText(config.Xcord,config.Ycord,0x00F9FF59,"Lasthit: On",font) text.visible = false

function Key(msg,code)
	if msg ~= KEY_UP and code == config.Lasthit and not client.chat then
		if not activated then
			activated = true
			text.text = "Lasthit: On"
		else
			activated = false
			text.text = "Lasthit: Off"
		end
	end
end

function Main(tick)
	if not SleepCheck() or not PlayingGame() then return end
	Sleep(100)
	local me = entityList:GetMyHero()
	if activated then
		local creeps = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Lane})
		for i,v in ipairs(creeps) do
			if v.alive and v.visible and GetDistance2D(v,me) <= me.attackRange then
				if isAttacking(creeps[1]) and v.health < v:DamageTaken(me.dmgMin+me.dmgBonus+v.dmgMin,DAMAGE_PHYS,me) then
					me:Attack(v)
				elseif isAttacking(creeps[2]) and v.health < v:DamageTaken(me.dmgMin+me.dmgBonus+v.dmgMin*2,DAMAGE_PHYS,me) then
					me:Attack(v)
				elseif v.health < v:DamageTaken(me.dmgMin+me.dmgBonus,DAMAGE_PHYS,me) then
					me:Attack(v)
				end
			end
		end
	end
end

function isAttacking(ent)
	return ent.activity == LuaEntityNPC.ACTIVITY_ATTACK or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK1 or ent.activity == LuaEntityNPC.ACTIVITY_ATTACK2
end

function Load()
	if PlayingGame() then
		play = true
		activated = true
		text.visible = true
		script:RegisterEvent(EVENT_KEY,Key)
		script:RegisterEvent(EVENT_FRAME, Main)
		script:UnregisterEvent(Load)
	end
end


function Close()
	activated = false
	text.visible = false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
