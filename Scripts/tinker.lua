require("libs.HotkeyConfig2")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Tinker")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("hotkey","Key",SGC_TYPE_ONKEYDOWN,false,false,32)
ScriptConfig:AddParam("blink","Auto Blink",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("rearm","Auto Rearm",SGC_TYPE_TOGGLE,false,true,nil)

play, myhero, victim, start, resettime, castQueue, castsleep, move = false, nil, nil, false, false, {}, 0, 0

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end

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
			castsleep = tick + v[1] + client.latency
			return
		end
	end

	local attackRange = me.attackRange	

	if ScriptConfig.hotkey then	
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
		if not Animations.CanMove(me) and victim and GetDistance2D(me,victim) <= 2000 then
			if not Animations.isAttacking(me) and victim.alive and victim.visible then
				if tick > castsleep and SleepCheck("123") then
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
						if ScriptConfig.blink and blink:CanBeCasted() and me:CanCast() and distance >= attackRange then
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
						if ScriptConfig.rearm then
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
						castsleep = tick + 200
					end
				end
			end
		elseif tick > move then
			local rearm = me:DoesHaveModifier("modifier_tinker_rearm") or me:IsChanneling()
			if victim and not rearm then
				if victim.visible then
					local xyz = SkillShot.PredictedXYZ(victim,me:GetTurnTime(victim)*1000+client.latency+500)
					me:Move(xyz)
				else
					me:Follow(victim)
				end
			else
				me:Move(client.mousePosition)
			end
			move = tick + 200
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

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Tinker then 
			script:Disable() 
		else
			ScriptConfig:SetVisible(true)
			play, victim, start, resettime, myhero = true, nil, false, nil, me.classId
			script:RegisterEvent(EVENT_FRAME, Main)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	myhero, victim, start, resettime = nil, nil, false, nil
	ScriptConfig:SetVisible(false)
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
