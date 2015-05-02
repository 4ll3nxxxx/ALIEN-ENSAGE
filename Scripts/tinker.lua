--<<Download texture https://mega.co.nz/#!8AZiFAbY!kMdEz0Fezz6cRzpVPrsNJTuUd4RFwHqDSI3cOV51U34 and unpack to nyanui/other>>

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("hotkey", "32", config.TYPE_HOTKEY)
config:SetParameter("blink", true)
config:SetParameter("rearm", true)
config:Load()

local play = false local myhero = nil local victim = nil local start = false local resettime = nil local sleep = {0,0,0}
local rate = client.screenSize.x/1600 local rec = {} local castQueue = {}
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

	for i=1,#castQueue,1 do
		local v = castQueue[1]
		table.remove(castQueue,1)
		local ability = v[2]
		if type(ability) == "string" then
			ability = me:FindItem(ability)
		end
		if ability and ((me:SafeCastAbility(ability,v[3],false)) or (v[4] and ability:CanBeCasted())) then
			if v[4] and ability:CanBeCasted() then
				me:CastAbility(ability,v[3],false)
			end
			sleep[1] = tick + v[1] + client.latency
			return
		end
	end

	local attackRange = me.attackRange	

	if IsKeyDown(config.hotkey) and not client.chat then	
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
			if not Animations.isAttacking(me) and victim.alive and victim.visible then
				if tick > sleep[2] and SleepCheck("123") then
					local rearm = me:DoesHaveModifier("modifier_tinker_rearm")
					local slow = victim:DoesHaveModifier("modifier_item_ethereal_blade_slow")
					local blink = me:FindItem("item_blink")
					local sheep = me:FindItem("item_sheepstick")
					local ethereal = me:FindItem("item_ethereal_blade")
					local dagon = me:FindDagon()
					local shiva = me:FindItem("item_shivas_guard")
					local soulring = me:FindItem("item_soul_ring")
					local distance = GetDistance2D(victim,me)
					local Q = me:GetAbility(1)
					local W = me:GetAbility(2)
					local R = me:GetAbility(4)
					if not rearm then
						if blink and blink:CanBeCasted() and me:CanCast() and distance > attackRange and config.blink then
							local CP = blink:FindCastPoint()
							local delay = ((500-Animations.getDuration(blink)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
							local speed = blink:GetSpecialData("blink_range")
							local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
							if xyz then
								table.insert(castQueue,{math.ceil(blink:FindCastPoint()*1000),blink,xyz})
							end
						end
						if W and W:CanBeCasted() and me:CanCast() then
							table.insert(castQueue,{100,W})
						end
						if Q and Q:CanBeCasted() and me:CanCast() then 
							table.insert(castQueue,{math.ceil(Q:FindCastPoint()*1000),Q,victim,true})
						end
						if me.mana < me.maxMana*0.5 and soulring and soulring:CanBeCasted() then
							table.insert(castQueue,{100,soulring})
						end
						if shiva and shiva:CanBeCasted() and distance <= 600 then
							table.insert(castQueue,{100,shiva})
						end
						if sheep and sheep:CanBeCasted() and me:CanCast() then
							table.insert(castQueue,{math.ceil(sheep:FindCastPoint()*1000),sheep,victim})
						end
						if dagon and dagon:CanBeCasted() and me:CanCast() then 
							table.insert(castQueue,{math.ceil(dagon:FindCastPoint()*1000),dagon,victim})
						end
						if ethereal and ethereal:CanBeCasted() and me:CanCast() then
							table.insert(castQueue,{math.ceil(ethereal:FindCastPoint()*1000),ethereal,victim})
						end
						if config.rearm then
							if dagon and not ethereal and not sheep and R and R:CanBeCasted() and me:CanCast() then
								if dagon.cd ~= 0 and W.cd ~= 0 then
									table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
									Sleep(1100+client.latency,"123")
								end
							end
							if dagon and ethereal and not sheep and R and R:CanBeCasted() and me:CanCast() then
								if dagon.cd ~= 0 and ethereal.cd ~= 0 and W.cd ~= 0 then
									table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
									Sleep(1100+client.latency,"123")
								end
							end
							if dagon and not ethereal and sheep and R and R:CanBeCasted() and me:CanCast() then
								if dagon.cd ~= 0 and sheep.cd ~= 0 and W.cd ~= 0 then
									table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
									Sleep(1100+client.latency,"123")
								end
							end
							if dagon and ethereal and sheep and R and R:CanBeCasted() and me:CanCast() then
								if dagon.cd ~= 0 and ethereal.cd ~= 0 and sheep.cd ~= 0 and W.cd ~= 0 then
									table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
									Sleep(1100+client.latency,"123")
								end
							end
						end
					end
					if not rearm and not slow then
						me:Attack(victim)
						sleep[2] = tick + 100
					end
				end
			end
		elseif tick > sleep[3] then
			local rearm = me:DoesHaveModifier("modifier_tinker_rearm") or me:IsChanneling()
			if victim and not rearm then
				if victim.visible then
					local xyz = SkillShot.PredictedXYZ(victim,me:GetTurnTime(victim)*1000+client.latency+500)
					me:Move(xyz)
				else
					me:Follow(victim)
				end
			end
			sleep[3] = tick + 100
			start = false
		end
	elseif victim then
		if not resettime then
			resettime = client.gameTime
		elseif (client.gameTime - resettime) >= 2 then
			victim = nil		
		end
		start = false
	end 
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Tinker then 
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
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
