require("libs.ScriptConfig")
require("libs.Utils")
require("libs.Skillshot")
require("libs.Animations")

local config = ScriptConfig.new()
config:SetParameter("HotKey", "32", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local move = 0 local delay = 0
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end
	if IsKeyDown(config.HotKey) and not client.chat then
		local victim = FindTarget(me.team)
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
				move = tick + 100
			end
			if tick > delay and SleepCheck("Zzz") then
				local Q = me:GetAbility(1)
				local W = me:GetAbility(2)
				local euls = me:FindItem("item_cyclone")
				if euls then
					if euls and euls:CanBeCasted() then
						if GetDistance2D(victim,me) <= euls.castRange and W and W:CanBeCasted() then
							me:CastAbility(euls,victim)
							Sleep(me:GetTurnTime(victim)*1000, "Zzz")
							delay = tick + 1700
						end
					end
					if W and W:CanBeCasted() and euls.cd ~= 0 then
						xyz2(victim,me,W)
						Sleep(W:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "Zzz")
					end
					if Q and Q:CanBeCasted() and W.cd ~= 0 then
						xyz1(victim,me,Q)
						Sleep(Q:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "Zzz")
					end
				end
				if not euls then
					if W and W:CanBeCasted() then
						xyz2(victim,me,W)
						Sleep(W:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "Zzz")
					end
					if Q and Q:CanBeCasted() and W.cd ~= 0 then
						xyz1(victim,me,Q)
						Sleep(Q:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "Zzz")
					end
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

function xyz1(victim,me,Q)
	local CP = Q:FindCastPoint()
	local delay = ((800-Animations.getDuration(Q)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
	local speed = 2500
	local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
	if xyz and GetDistance2D(victim,me) <= Q.castRange then 
		me:CastAbility(Q,xyz)
	end
end

function xyz2(victim,me,W)
	local CP = W:FindCastPoint()
	local delay = ((625-Animations.getDuration(W)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
	local speed = 1900
	local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
	if xyz and GetDistance2D(victim,me) <= W.castRange then 
		me:CastAbility(W,xyz)
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Lina then 
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
