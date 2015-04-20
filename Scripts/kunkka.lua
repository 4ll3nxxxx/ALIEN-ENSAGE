require("libs.ScriptConfig")
require("libs.Skillshot")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("HotKey", "32", config.TYPE_HOTKEY)
config:SetParameter("HomeKey", "D", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local move = 0 local home = 0
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end
	local Q = me:GetAbility(1)
	local E = me:GetAbility(3)
	local R = me:GetAbility(4)
	local victim = FindTarget(me.team)
	if me.team == LuaEntity.TEAM_RADIANT then
		foun = Vector(-7272,-6757,270)
	else
		foun = Vector(7200,6624,256)
	end
	if E.name == "kunkka_x_marks_the_spot" and Q and Q:CanBeCasted() and E.level > 0 and E.abilityPhase then
		me:CastAbility(Q,victim.position)
		Sleep(250+client.latency, "combo")
	end
	if E.name == "kunkka_return" and me:CanCast() and math.floor(Q.cd*10) == 110 + math.floor((client.latency/1100)) then
		me:CastAbility(E)
		Sleep(250+client.latency, "combo")
	end
	if IsKeyDown(config.HomeKey) and not client.chat then
		local travel = me:FindItem("item_tpscroll") or me:FindItem("item_travel_boots")
		if tick > home and SleepCheck("home") then
			if E and E:CanBeCasted() then
				me:CastAbility(E,me)
				Sleep(client.latency,"home")
			end
			if travel and travel:CanBeCasted() then
				me:CastAbility(travel,foun)
				Sleep(client.latency,"home")
			end
		end
		home = tick + 560
	end
	if IsKeyDown(config.HotKey) and not client.chat then
		rec[1].w = 90*rate + 30*0*rate + 65*rate
		rec[2].x = 30*rate + 90*rate + 30*0*rate + 65*rate - 95*rate
		rec[3].x = 80*rate + 90*rate + 30*0*rate + 65*rate - 50*rate
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..victim.name:gsub("npc_dota_hero_",""))
		for z = 1,3 do
			rec[z].visible = true
		end
		if victim and victim.alive and GetDistance2D(me,victim) <= 2000 then
			if tick > move then
				if GetDistance2D(victim,me) <= 550 then
					me:Attack(victim)
				else
					me:Follow(victim)
				end
			end
			move = tick + 250
			if victim and SleepCheck("Zzz") then
				if E.name == "kunkka_x_marks_the_spot" and E:CanBeCasted() and me:CanCast() then
					me:CastAbility(E,victim)
					lastpos = victim.position
					Sleep(client.latency,"Zzz")
				end
				if Q and Q:CanBeCasted() and me:CanCast() and E.level > 0 and E.abilityPhase then
					me:CastAbility(Q,lastpos)
					Sleep(client.latency,"Zzz")
				end
				if R and R:CanBeCasted() and me:CanCast() and Q.level > 0 and Q.abilityPhase then
					me:CastAbility(R,lastpos)
					Sleep(client.latency,"Zzz")
				end
				if E.name == "kunkka_return" and me:CanCast() and math.floor(Q.cd*10) == 110 + math.floor((client.latency/1100)) then
					me:CastAbility(E)
					Sleep(client.latency,"Zzz")
				end
			end
		end
	end
end

function FindTarget(teams)
	local enemy = entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.team ~= teams and v.visible and v.alive and not v.illusion end)
	if #enemy == 0 then
		return entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.team ~= teams end)[1]
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
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end
end

function Close()
	myhero = nil
	victim = nil
	for i = 1, #rec do
		rec[i].visible = false
	end
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
