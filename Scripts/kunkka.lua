--<<Download texture https://mega.co.nz/#!8AZiFAbY!kMdEz0Fezz6cRzpVPrsNJTuUd4RFwHqDSI3cOV51U34 and unpack to nyanui/other>>

require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("HotKey", "32", config.TYPE_HOTKEY)
config:SetParameter("HomeKey", "D", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local sleep = {0,0}
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end
	
	local Q = me:GetAbility(1)
	local E = me:GetAbility(3)
	local R = me:GetAbility(4)

	if me.team == LuaEntity.TEAM_RADIANT then
		foun = Vector(-7272,-6757,270)
	else
		foun = Vector(7200,6624,256)
	end

	if IsKeyDown(config.HomeKey) and not client.chat then
		if tick > sleep[1] and me.alive then
			local travel = me:FindItem("item_tpscroll") or me:FindItem("item_travel_boots")
			if E and E:CanBeCasted() and travel and travel:CanBeCasted() then
				me:CastAbility(E,me)
			end
			if travel and travel:CanBeCasted() then
				me:CastAbility(travel,foun)
				sleep[1] = tick + 1000
			end
		end
	end

	local victim = FindTarget(me.team)

	if victim and victim.visible then
		if not rec[i] then
			rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..victim.name:gsub("npc_dota_hero_",""))
		end
	else
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
	end
	
	if victim and tick > sleep[2] then
		if E.name == "kunkka_x_marks_the_spot" and Q and Q:CanBeCasted() and E.level > 0 and E.abilityPhase then
			me:CastAbility(Q,victim.position)
		end
		if E.name == "kunkka_return" and me:CanCast() and math.floor(Q.cd*10) == 110 + math.floor((client.latency/1100)) then
			me:CastAbility(E)
		end

		if IsKeyDown(config.HotKey) and not client.chat then
			if E.name == "kunkka_x_marks_the_spot" and E:CanBeCasted() and me:CanCast() then
				me:CastAbility(E,victim)
				lastpos = victim.position
			end
			if R and R:CanBeCasted() and me:CanCast() and E.level > 0 and E.abilityPhase then
				me:CastAbility(R,lastpos)
			end
			if Q and Q:CanBeCasted() and me:CanCast() and R.level > 0 and R.abilityPhase then
				me:CastAbility(Q,lastpos)
			end
			if E.name == "kunkka_return" and me:CanCast() and math.floor(Q.cd*10) == 110 + math.floor((client.latency/1100)) then
				me:CastAbility(E)
			end
		end
		sleep[2] = tick + 100
	end
end

function FindTarget(teams)
	local enemy = entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.team ~= teams and v.visible and v.alive and not v.illusion end)
	if #enemy == 0 then
		return entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.team ~= teams and v.visible and v.alive and not v.illusion end)[1]
	elseif #enemy == 1 then
		return enemy[1]	
	else
		local mouse = client.mousePosition
		table.sort( enemy, function (a,b) return GetDistance2D(mouse,a) < GetDistance2D(mouse,b) end)
		return enemy[1]
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Kunkka then 
			script:Disable() 
		else
			play = true
			myhero = me.classId
			rec[1].w = 90*rate + 30*0*rate + 65*rate rec[1].visible = true
			rec[2].x = 30*rate + 90*rate + 30*0*rate + 65*rate - 95*rate rec[2].visible = true
			rec[3].x = 80*rate + 90*rate + 30*0*rate + 65*rate - 50*rate rec[3].visible = true
			script:RegisterEvent(EVENT_FRAME, Main)
			script:UnregisterEvent(Load)
		end
	end	
end
function Close()
	myhero = nil
	victim = nil
	rec[1].visible = false
	rec[2].visible = false
	rec[3].visible = false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
