require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:SetParameter("Ult", true)
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
		if ability and me:SafeCastAbility(ability,v[3],false) then
			sleep[3] = tick + v[1] + client.latency
			return
		end
	end

	local attackRange = me.attackRange	

	if IsKeyDown(config.Hotkey) and not client.chat then	
		if Animations.CanMove(me) or not start or (victim and GetDistance2D(victim,me) > attackRange+50) then
			start = true
			local lowestHP = targetFind:GetLowestEHP(3000, phys)
			if lowestHP and (not victim or GetDistance2D(me,victim) > 600 or not victim.alive or lowestHP.health < victim.health) and SleepCheck("victim") then			
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
		if not Animations.CanMove(me) then
			if victim and GetDistance2D(me,victim) <= 2000 then
				if tick > sleep[1] then
					local blow = victim:DoesHaveModifier("modifier_eul_cyclone")
					if GetDistance2D(victim,me) <= 590 and not blow then
						me:Attack(victim)
					else
						me:Follow(victim)
					end
					sleep[1] = tick + 100 + client.latency
				end
				if tick > sleep[2] then
					local Q = me:GetAbility(1)
					local W = me:GetAbility(2)
					local R = me:GetAbility(4)
					local euls = me:FindItem("item_cyclone")
					if config.Ult and victim and R and R:CanBeCasted() and victim:CanDie() and not victim:DoesHaveModifier("modifier_item_blade_mail_reflect") and not victim:IsLinkensProtected() and not victim:DoesHaveModifier("modifier_item_lotus_orb_active") then
						Dmg = R:GetSpecialData("damage",R.level)
						if victim.health < victim:DamageTaken(Dmg, DAMAGE_MAGC, me) and victim.health > 400 then
							table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R,victim})
						end
					end
					if euls then
						if euls and euls:CanBeCasted() then
							if GetDistance2D(victim,me) <= euls.castRange and W and W:CanBeCasted() then
								me:CastAbility(euls,victim)
								table.insert(castQueue,{math.ceil(euls:FindCastPoint()*1000),euls,victim,true})
								sleep[2] = tick + 1700 + client.latency
							end
						end
						if W and W:CanBeCasted() and euls.cd ~= 0 then
							xyz2(victim,me,W)
						end
						if Q and Q:CanBeCasted() and W.cd ~= 0 then
							xyz1(victim,me,Q)
						end
					end
					if not euls then
						if W and W:CanBeCasted() then
							xyz2(victim,me,W)
						end
						if Q and Q:CanBeCasted() and W.cd ~= 0 then
							xyz1(victim,me,Q)
						end
					end
				end
			end
			start = false
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
	local delay = ((400-Animations.getDuration(Q)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
	local speed = Q:GetSpecialData("dragon_slave_speed")
	local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
	if xyz and GetDistance2D(victim,me) <= Q.castRange then 
		table.insert(castQueue,{math.ceil(CP*1000+client.latency),Q,xyz})
	end
end

function xyz2(victim,me,W)
	local CP = W:FindCastPoint()
	local delay = ((312.5-Animations.getDuration(W)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
	local speed = W:GetSpecialData("light_strike_array_delay_time")
	local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
	if xyz and GetDistance2D(victim,me) <= W.castRange then 
		table.insert(castQueue,{math.ceil(CP*1000+client.latency),W,xyz})
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
