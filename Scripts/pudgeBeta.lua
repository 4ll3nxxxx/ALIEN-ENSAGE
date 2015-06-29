require("libs.HotkeyConfig2")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Skillshot")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Pudge")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("hotkey","Key",SGC_TYPE_ONKEYDOWN,false,false,32)
ScriptConfig:AddParam("hook","Auto Hook",SGC_TYPE_TOGGLE,false,true,nil)

play, myhero, target, castQueue, castsleep = false, nil, nil, {}, 0

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
			castsleep = tick + v[1]
			return
		end
	end

	if ScriptConfig.hotkey and SleepCheck("sleeping") then	
		target = targetFind:GetLowestEHP(2000,magic)
		if target and not me:IsChanneling() then
			local Q, W, rot, R, distance = me:GetAbility(1), me:GetAbility(2), me:DoesHaveModifier("modifier_pudge_rot"), me:GetAbility(4), GetDistance2D(target,me)
			local blink, ethereal = me:FindItem("item_blink"), me:FindItem("item_ethereal_blade")
			if Q and Q.abilityPhase and (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, target))) - 0.1, 0)) ~= 0 or me:FindRelativeAngle(target) > 0.1 then
				me:Stop() Sleep(client.latency + 100,"sleeping")
			end
			if tick > castsleep then
				if not target:DoesHaveModifier("modifier_item_blade_mail_reflect") and not target:DoesHaveModifier("modifier_item_lotus_orb_active") and not target:IsMagicImmune() and target:CanDie() then
					if ScriptConfig.hook and Q and Q:CanBeCasted() and me:CanCast() then
						if distance >= me.attackRange and distance <= Q:GetSpecialData("hook_distance",Q.level) then
							local xyz = SkillShot.BlockableSkillShotXYZ(me,target,1600,(100+client.latency+me:GetTurnTime(target)*1000),100,true)
							if xyz then
								table.insert(castQueue,{100,Q,xyz})
							end
						end
					end
					if W and W:CanBeCasted() and me:CanCast() and SleepCheck("rot") then
						if distance < 250 and not W.toggled then
							table.insert(castQueue,{100,W}) Sleep(500 + client.latency,"rot")
						elseif Q and math.ceil(Q.cd - 0.1) == math.ceil(Q:GetCooldown(Q.level)) and not W.toggled then
							table.insert(castQueue,{100,W}) Sleep(500 + client.latency,"rot")
						elseif W.toggled and distance > 250 then
							table.insert(castQueue,{100,W}) Sleep(500 + client.latency,"rot")
						end
					end
					if R and R:CanBeCasted() and me:CanCast() and rot then
						table.insert(castQueue,{100,R,target}) Sleep(3000 + client.latency,"sleeping")
					end
					if ethereal and ethereal:CanBeCasted() and me:CanCast() then
						table.insert(castQueue,{100,ethereal,target})
					end
				end
				if not target:DoesHaveModifier("modifier_item_ethereal_blade_slow") then
					me:Attack(target)
					castsleep = tick + 100
				end
			end
		end
	end 
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Pudge then 
			script:Disable() 
		else
			ScriptConfig:SetVisible(true)
			play, target, myhero = true, nil, me.classId
			script:RegisterEvent(EVENT_FRAME, Main)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	myhero, target = nil, nil
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
