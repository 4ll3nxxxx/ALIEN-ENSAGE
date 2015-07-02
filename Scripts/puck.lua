require("libs.HotkeyConfig2")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Puck")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("hotkey","Key",SGC_TYPE_ONKEYDOWN,false,false,32)
ScriptConfig:AddParam("blink","Auto Blink To Enemy",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("ult","Auto Dream Coil",SGC_TYPE_TOGGLE,false,true,nil)

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

	if ScriptConfig.hotkey then	
		if Animations.CanMove(me) or not start or (victim and GetDistance2D(victim,me) > me.attackRange+50) then
			start = true
			local lowestHP = targetFind:GetLowestEHP(3000, phys)
			if lowestHP and (not victim or GetDistance2D(me,victim) > 600 or not victim.alive or lowestHP.health < victim.health) and SleepCheck("victim") then			
				victim = lowestHP
				Sleep(250,"victim")
			end
			if victim and GetDistance2D(victim,me) > me.attackRange+200 and victim.visible then
				local closest = targetFind:GetClosestToMouse(me,2000)
				if closest and (not victim or closest.handle ~= victim.handle) then 
					victim = closest
				end
			end
		end
		if not Animations.CanMove(me) and victim and GetDistance2D(me,victim) <= 2000 then
			if tick > castsleep then
				if not Animations.isAttacking(me) and victim.alive and victim.visible then
					local Q, W, D, R = me:GetAbility(1), me:GetAbility(2), me:GetAbility(4), me:GetAbility(5)
					local sheep, dagon, blink, shivas, ethereal = me:FindItem("item_sheepstick"), me:FindDagon(), me:FindItem("item_blink"), me:FindItem("item_shivas_guard"), me:FindItem("item_ethereal_blade")
					local disabled, distance = victim:IsSilenced() or victim:IsHexed() or victim:IsStunned(), GetDistance2D(victim,me)
					if not victim:DoesHaveModifier("modifier_item_blade_mail_reflect") and not victim:DoesHaveModifier("modifier_item_lotus_orb_active") and not victim:IsMagicImmune() and victim:CanDie() then
						if ScriptConfig.blink and blink and blink:CanBeCasted() and me:CanCast() and distance >= me.attackRange then
							local xyz = SkillShot.SkillShotXYZ(me,victim,blink:FindCastPoint()*1000+client.latency+me:GetTurnTime(victim)*1000,blink:GetSpecialData("blink_range"))
							if xyz then
								table.insert(castQueue,{math.ceil(blink:FindCastPoint()*1000),blink,xyz})
							end
						end
						if Q and Q:CanBeCasted() and me:CanCast() and (blink and blink.cd ~= 0 or not blink or not ScriptConfig.blink) and distance <= 1200 and distance >= me.attackRange then
							local xyz = SkillShot.SkillShotXYZ(me,victim,((270-Animations.getDuration(Q)*1000)+Q:FindCastPoint()*1000+client.latency+me:GetTurnTime(victim)*1000),1233)
							if xyz then 
								table.insert(castQueue,{math.ceil(Q:FindCastPoint()*1000),Q,xyz})
							end
						end
						if W and W:CanBeCasted() and me:CanCast() and (sheep and sheep.cd ~= 0 and not disabled or not sheep) and distance <= 360 then
							table.insert(castQueue,{100,W})
						end
						if D and D:CanBeCasted() and me:CanCast() then
							local orb = entityList:GetEntities({type = LuaEntity.TYPE_NPC, alive = true, team = me.team})
							for i = 1, #orb do
								local v = orb[i] 
								if GetDistance2D(v,victim) < 100 then
									table.insert(castQueue,{100,D})
								end
							end
						end
						if R and R:CanBeCasted() and me:CanCast() and distance <= 750 and ScriptConfig.ult then
							table.insert(castQueue,{math.ceil(R:FindCastPoint()*1000),R,victim.position})
						end
						if dagon and dagon:CanBeCasted() and me:CanCast() and (ethereal and ethereal.cd ~= 0 and victim:DoesHaveModifier("modifier_item_ethereal_blade_slow") or not ethereal) then 
							table.insert(castQueue,{math.ceil(dagon:FindCastPoint()*1000),dagon,victim})
						end
						if sheep and sheep:CanBeCasted() and not disabled then
							table.insert(castQueue,{math.ceil(sheep:FindCastPoint()*1000),sheep,victim})
						end
						if shivas and shivas:CanBeCasted() and distance <= 600 then
							table.insert(castQueue,{100,shivas})
						end
						if ethereal and ethereal:CanBeCasted() and me:CanCast() then
							table.insert(castQueue,{math.ceil(ethereal:FindCastPoint()*1000),ethereal,victim})
						end
					end
				end
				me:Attack(victim)
				castsleep = tick + 160
			end
		elseif tick > move then
			if victim then
				if victim.visible then
					local xyz = SkillShot.PredictedXYZ(victim,me:GetTurnTime(victim)*1000+client.latency+500)
					me:Move(xyz)
				else
					me:Follow(victim)
				end
			else
				me:Move(client.mousePosition)
			end
			move = tick + 160
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
		if me.classId ~= CDOTA_Unit_Hero_Puck then 
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
