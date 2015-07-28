require("libs.Utils")
require("libs.TargetFind")
require("libs.Skillshot")

play = false

function Tick(tick)
    if not PlayingGame() then return end
    local me, target = entityList:GetMyHero(), targetFind:GetClosestToMouse(100)
    if IsKeyDown(32) and target and GetDistance2D(target,me) <= 2000 and not target:DoesHaveModifier("modifier_item_blade_mail_reflect") and not target:DoesHaveModifier("modifier_item_lotus_orb_active") and not target:IsMagicImmune() and target:CanDie() then		
		for i,k in ipairs(me.abilities) do
			if k:CanBeCasted() and k:CanBeCasted() and me:CanCast() and SleepCheck("abilities") then
				if k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_UNIT_TARGET) and GetDistance2D(target,me) <= k.castRange-50 then
					me:CastAbility(k,target) Sleep(100,"abilities")
				end
				if k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_NO_TARGET) and GetDistance2D(target,me) <= me.attackRange+100 then
					me:CastAbility(k) Sleep(100,"abilities")
				end
				if k:IsBehaviourType(LuaEntityAbility.BEHAVIOR_POINT) then
					local xyz = SkillShot.SkillShotXYZ(me,target,k:FindCastPoint()*1000+client.latency+me:GetTurnTime(target)*1000,1000)
					if xyz and GetDistance2D(target,me) <= k.castRange-50 then
						me:CastAbility(k,xyz) Sleep(100,"abilities")
					end
				end
			end
		end
		for i,j in ipairs(me.items) do
			if j:CanBeCasted() and j:CanBeCasted() and me:CanCast() and j.name ~= "item_travel_boots" and j.name ~= "item_travel_boots_2" and j.name ~= "item_tpscroll" and SleepCheck("items") then
				if j:IsBehaviourType(LuaEntityAbility.BEHAVIOR_UNIT_TARGET) and GetDistance2D(target,me) <= j.castRange-50 then
					me:CastAbility(j,target) Sleep(100,"items")
				end
				if j:IsBehaviourType(LuaEntityAbility.BEHAVIOR_NO_TARGET) then
					me:CastAbility(j) Sleep(100,"items")
				end
				if j:IsBehaviourType(LuaEntityAbility.BEHAVIOR_POINT) then
					if j.name ~= "item_blink" and GetDistance2D(target,me) <= j.castRange-50  then
						me:CastAbility(j,target.position) Sleep(100,"items")
					elseif j.name == "item_blink" and GetDistance2D(target,me) <= 1199 and GetDistance2D(target,me) >= me.attackRange+450 then
						me:CastAbility(j,target.position) Sleep(100,"items")
					end
				end
			end
		end
	end
end

function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_FRAME,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
	