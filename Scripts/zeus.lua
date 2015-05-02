require("libs.Utils")
require("libs.TargetFind")
require("libs.ScriptConfig")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("HotKey", "32", config.TYPE_HOTKEY)
config:SetParameter("RefresherCombo", true)
config:SetParameter("Ult", true)
config:Load()

local play = false local targetHandle = nil local effect = {} local castQueue = {} local sleep = {0,0,0}

function Main(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()

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
			sleep[2] = tick + v[1] + client.latency
			return
		end
	end

	if IsKeyDown(config.HotKey) and not client.chat then
		target = targetFind:GetClosestToMouse(100)
		if tick > sleep[1] then
			if target and GetDistance2D(target,me) <= 2000 and not target:DoesHaveModifier("modifier_item_blade_mail_reflect") and not target:IsMagicImmune() then
				local Q = me:GetAbility(1)
				local W = me:GetAbility(2)
				local R = me:GetAbility(4)
				local distance = GetDistance2D(target,me)
				local ultimate = me:FindItem("item_ultimate_scepter")
				local refresher = me:FindItem("item_refresher")
				local veil = me:FindItem("item_veil_of_discord")
				local soulring = me:FindItem("item_soul_ring")
				local damage1 = {225,350,475}
				local damage2 = {440,540,640}
				local damage3 = {880,1080,1280}
				if config.RefresherCombo and refresher and refresher:CanBeCasted() and R.cd ~= 0 then
					table.insert(castQueue,{1000+math.ceil(refresher:FindCastPoint()*1000),refresher})
				end
				if distance <= 850 and Q and Q:CanBeCasted() and me:CanCast() then
					table.insert(castQueue,{1000+math.ceil(Q:FindCastPoint()*1000),Q,target})
				end
				if W and W:CanBeCasted() and me:CanCast() then
					local CP = W:FindCastPoint()
					local delay = ((270-Animations.getDuration(W)*1000)+CP*1000+client.latency+me:GetTurnTime(target)*1000)
					local speed = 1600
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
				if config.Ult and R and R:CanBeCasted() then
					if not ultimate and not refresher and (target.health > 0 and target.health < damage1[R.level]) then 
						table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
					elseif ultimate and not refresher and (target.health > 0 and target.health < damage2[R.level]) then
						table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
					elseif ultimate and refresher and (target.health > 0 and target.health < damage3[R.level]) then
						table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
						return
					end
				end
				me:Attack(target)
				sleep[1] = tick + 100
			end
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Zuus then 
			script:Disable()
		else
			play = true
			script:RegisterEvent(EVENT_FRAME, Main)
			script:UnregisterEvent(Load)
		end
	end
end

function Close()
	active = false 
	targetHandle = nil 
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close) 
script:RegisterEvent(EVENT_TICK, Load)
