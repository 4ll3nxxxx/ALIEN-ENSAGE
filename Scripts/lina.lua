require("libs.HotkeyConfig2")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Skillshot")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Lina")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("hotkey","Key",SGC_TYPE_ONKEYDOWN,false,false,32)
ScriptConfig:AddParam("ult","Auto Laguna Blade",SGC_TYPE_TOGGLE,false,true,nil)

play, myhero, target, castQueue, castsleep, move = false, nil, nil, {}, 0, 0

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
		if ability and me:SafeCastAbility(ability,v[3],false) then
			return
		end
	end

	if ScriptConfig.hotkey then	
		target = targetFind:GetClosestToMouse(100)
		if target and GetDistance2D(me,target) <= 2000 then
			if tick > move then
				local blow = target:DoesHaveModifier("modifier_eul_cyclone")
				if GetDistance2D(target,me) <= 625 and not blow then
					me:Attack(target)
				else
					me:Follow(target)
				end
				move = tick + 150
			end
			if tick > castsleep then
				if not target:DoesHaveModifier("modifier_item_blade_mail_reflect") and not target:DoesHaveModifier("modifier_item_lotus_orb_active") and not target:IsMagicImmune() and target:CanDie() then
					local Q, W, R, euls = me:GetAbility(1), me:GetAbility(2), me:GetAbility(4), me:FindItem("item_cyclone")
					if ScriptConfig.ult and R and R:CanBeCasted() and not target:IsLinkensProtected() then
						if target.health < target:DamageTaken(R:GetSpecialData("damage",R.level), DAMAGE_MAGC, me) then
							table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R,target})
						end
					end
					if euls then
						if euls and euls:CanBeCasted() then
							if GetDistance2D(target,me) <= euls.castRange and W and W:CanBeCasted() then
								table.insert(castQueue,{math.ceil(euls:FindCastPoint()*1000),euls,target,true})
								castsleep = tick + 1700 + client.latency
							end
						end
						if W and W:CanBeCasted() and euls.cd ~= 0 then
							xyz2(target,me,W)
						end
						if Q and Q:CanBeCasted() and W.cd ~= 0 then
							xyz1(target,me,Q)
						end
					end
					if not euls then
						if W and W:CanBeCasted() then
							xyz2(target,me,W)
						end
						if Q and Q:CanBeCasted() and W.cd ~= 0 then
							xyz1(target,me,Q)
						end
					end
				end
			end
		end
	end 
end

function xyz1(target,me,Q)
	local xyz = SkillShot.SkillShotXYZ(me,target,Q:FindCastPoint()*1000+client.latency+me:GetTurnTime(target)*1000,800)
	if xyz and GetDistance2D(target,me) <= Q.castRange then 
		table.insert(castQueue,{math.ceil(Q:FindCastPoint()*1000+client.latency),Q,xyz})
	end
end

function xyz2(target,me,W)
	local xyz = SkillShot.SkillShotXYZ(me,target,W:FindCastPoint()*1000+client.latency+me:GetTurnTime(target)*1000,625)
	if xyz and GetDistance2D(target,me) <= W.castRange then 
		table.insert(castQueue,{math.ceil(W:FindCastPoint()*1000+client.latency),W,xyz})
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Lina then 
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
