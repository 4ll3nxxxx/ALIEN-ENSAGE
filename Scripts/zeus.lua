require("libs.Utils")
require("libs.TargetFind")
require("libs.HotkeyConfig2")
require("libs.Skillshot")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Zeus")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("hotkey","Key",SGC_TYPE_ONKEYDOWN,false,false,32)
ScriptConfig:AddParam("ult","Auto ult",SGC_TYPE_TOGGLE,false,true,nil)

play, target, castQueue, castsleep = false, nil, {}, 0

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

	if ScriptConfig.hotkey then
		target = targetFind:GetClosestToMouse(100)
		if tick > castsleep then
			if target and GetDistance2D(target,me) <= 2000 and not target:DoesHaveModifier("modifier_item_blade_mail_reflect") and not target:DoesHaveModifier("modifier_item_lotus_orb_active") and not target:IsMagicImmune() and target:CanDie() then
				local Q, W, R = me:GetAbility(1), me:GetAbility(2), me:GetAbility(4)
				local distance = GetDistance2D(target,me)
				local dagon, ethereal, veil, soulring = me:FindDagon(), me:FindItem("item_ethereal_blade"), me:FindItem("item_veil_of_discord"), me:FindItem("item_soul_ring")
				local slow = target:DoesHaveModifier("modifier_item_ethereal_blade_slow")
				if dagon and dagon:CanBeCasted() and me:CanCast() and (veil and veil.cd ~= 0 and target:DoesHaveModifier("modifier_item_veil_of_discord_debuff") or not veil) then
					table.insert(castQueue,{1000+math.ceil(dagon:FindCastPoint()*1000),dagon,target})
					Sleep(me:GetTurnTime(target)*1000, "casting")
				end
				if ethereal and ethereal:CanBeCasted() and me:CanCast() then
					table.insert(castQueue,{math.ceil(ethereal:FindCastPoint()*1000),ethereal,target})
				end
				if distance <= 850 and Q and Q:CanBeCasted() and me:CanCast() then
					table.insert(castQueue,{1000+math.ceil(Q:FindCastPoint()*1000),Q,target})
				end
				if W and W:CanBeCasted() and me:CanCast() then
					local CP = W:FindCastPoint()
					local delay = CP*1000+client.latency+me:GetTurnTime(target)*1000
					local speed = W:GetSpecialData("true_sight_radius")
					local xyz = SkillShot.SkillShotXYZ(me,target,delay,speed)
					if xyz and distance <= 700 then 
						table.insert(castQueue,{math.ceil(CP*1000+client.latency),W,xyz})
					end
				end
				if veil and veil:CanBeCasted() and me:CanCast() then
					table.insert(castQueue,{1000+math.ceil(veil:FindCastPoint()*1000),veil,target.position})        
				end
				if me.mana < me.maxMana*0.5 and soulring and soulring:CanBeCasted() then
					table.insert(castQueue,{100,soulring})
				end
				if ScriptConfig.ult and target and R and R:CanBeCasted() then
					Dmg = R:GetSpecialData("damage",R.level)
					if me:AghanimState() then		
						Dmg = R:GetSpecialData("damage_scepter",R.level)
					end
					if target.health < target:DamageTaken(Dmg, DAMAGE_MAGC, me) then
						table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
					end
				end
				if not slow then
					me:Attack(target)
				elseif slow then
					me:Follow(target)
				end
			end
			castsleep = tick + 150
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Zuus then 
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
	target, myhero = nil, nil
	ScriptConfig:SetVisible(false)
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close) 
script:RegisterEvent(EVENT_TICK, Load)
