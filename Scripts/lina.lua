require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local start = false local resettime = nil local sleep = {0,0}
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end

	if victim and victim.visible then
		if not rec[i] then
			rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..victim.name:gsub("npc_dota_hero_",""))
		end
	else
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
	end

	local attackRange = me.attackRange	

	if IsKeyDown(config.Hotkey) and not client.chat then	
		if Animations.CanMove(me) or not start or (victim and GetDistance2D(victim,me) > attackRange+50) then
			start = true
			local lowestHP = targetFind:GetLowestEHP(3000, phys)
			if lowestHP and (not victim or victim.creep or GetDistance2D(me,victim) > 600 or not victim.alive or lowestHP.health < victim.health) and SleepCheck("victim") then			
				victim = lowestHP
				Sleep(250,"victim")
			end
			if victim and GetDistance2D(victim,me) > attackRange+200 and victim.visible then
				local closest = targetFind:GetClosestToMouse(me,2000)
				if closest and (not victim or closest.handle ~= victim.handle) then 
					victim = closest
				end
			end
		end
		if not Animations.CanMove(me) and victim and GetDistance2D(me,victim) <= 2000 then
			if tick > sleep[1] and SleepCheck("casting") then
				local Q = me:GetAbility(1)
				local W = me:GetAbility(2)
				local euls = me:FindItem("item_cyclone")
				if euls then
					if euls and euls:CanBeCasted() then
						if GetDistance2D(victim,me) <= euls.castRange and W and W:CanBeCasted() then
							me:CastAbility(euls,victim)
							Sleep(me:GetTurnTime(victim)*1000, "casting")
							sleep[1] = tick + 1700
						end
					end
					if W and W:CanBeCasted() and euls.cd ~= 0 then
						xyz2(victim,me,W)
						Sleep(W:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "casting")
					end
					if Q and Q:CanBeCasted() and W.cd ~= 0 then
						xyz1(victim,me,Q)
						Sleep(Q:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "casting")
					end
				end
				if not euls then
					if W and W:CanBeCasted() then
						xyz2(victim,me,W)
						Sleep(W:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "casting")
					end
					if Q and Q:CanBeCasted() and W.cd ~= 0 then
						xyz1(victim,me,Q)
						Sleep(Q:FindCastPoint()*1000+me:GetTurnTime(victim)*1000, "casting")
					end
				end
			end
			if tick > sleep[2] then
				if GetDistance2D(victim,me) <= 600 then
					me:Attack(victim)
				else
					me:Follow(victim)
				end
				sleep[2] = tick + 100
			end
		end
	elseif victim then
			if not resettime then
			resettime = client.gameTime
		elseif (client.gameTime - resettime) >= 6 then
			victim = nil		
		end
		start = false
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
			victim = nil
			start = false
			resettime = nil
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
	start = false
	resettime = nil
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
