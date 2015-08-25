require("libs.HotkeyConfig2")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Slark")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("hotkey","Key",SGC_TYPE_ONKEYDOWN,false,false,32)

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
		if ability and me:SafeCastAbility(ability,v[3],false) then
			castsleep = tick + v[1] + client.latency
			return
		end
	end 

	if ScriptConfig.hotkey then
		if Animations.CanMove(me) or not start or (victim and GetDistance2D(victim,me) > me.attackRange	+50) then
			start = true
			local lowestHP = targetFind:GetLowestEHP(3000, phys)
			if lowestHP and (not victim or GetDistance2D(me,victim) > 600 or not victim.alive or lowestHP.health < victim.health) and SleepCheck("victim") then			
				victim = lowestHP
				Sleep(250,"victim")
			end
			if victim and GetDistance2D(victim,me) > me.attackRange	+200 and victim.visible then
				local closest = targetFind:GetClosestToMouse(me,2000)
				if closest and (not victim or closest.handle ~= victim.handle) then 
					victim = closest
				end
			end
		end
		if not Animations.CanMove(me) and victim and GetDistance2D(me,victim) <= 2000 then
			if tick > castsleep then
				if not Animations.isAttacking(me) and victim.alive and victim.visible then
					local immune = victim:DoesHaveModifier("modifier_omniknight_repel") or victim:DoesHaveModifier("modifier_black_king_bar_immune")
					local disable = victim:IsHexed() or victim:IsStunned() or victim:IsLinkensProtected()
					local shadowplay = me:DoesHaveModifier("modifier_item_silver_edge_windwalk") or me:DoesHaveModifier("modifier_item_invisibility_edge_windwalk")
					local abyssal, butterfly, mom, satanic, bkb = me:FindItem("item_abyssal_blade"), me:FindItem("item_butterfly"), me:FindItem("item_mask_of_madness"), me:FindItem("item_satanic"), me:FindItem("item_black_king_bar")
					local Q, W, R, distance = me:GetAbility(1), me:GetAbility(2), me:GetAbility(4), GetDistance2D(victim,me)
					if not shadowplay then
						if not immune then
							if Q and Q:CanBeCasted() and me:CanCast() and distance <= 325 then
								table.insert(castQueue,{100,Q})
							end
							if W and W:CanBeCasted() and me:CanCast() and distance <= 580 and (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, victim))) - 0.1, 0)) == 0 then
								table.insert(castQueue,{1000+math.ceil(W:FindCastPoint()*1000),W})
							end
						end
						if me.health < me.maxHealth*0.25 and R and R:CanBeCasted() then
							table.insert(castQueue,{1000+math.ceil(R:FindCastPoint()*1000),R})
						end
						if abyssal and abyssal:CanBeCasted() and distance <= abyssal.castRange and not disable then
							table.insert(castQueue,{math.ceil(abyssal:FindCastPoint()*1000),abyssal,victim})
						end
						if butterfly and butterfly:CanBeCasted() and me:CanCast() then
							table.insert(castQueue,{100,butterfly})
						end
						if mom and mom:CanBeCasted() and distance <= me.attackRange	+100 then
							table.insert(castQueue,{100,mom})
						end
						if satanic and satanic:CanBeCasted() and me.health/me.maxHealth <= 0.4 and distance <= me.attackRange	+100 then
							table.insert(castQueue,{100,satanic})
						end
						if bkb and bkb:CanBeCasted() and me:CanCast() then
							local heroes = entityList:GetEntities(function (v) return v.type==LuaEntity.TYPE_HERO and v.alive and v.visible and v.team~=me.team and me:GetDistance2D(v) <= 1200 end)
							if #heroes == 3 then
								table.insert(castQueue,{100,bkb})
							elseif #heroes == 4 then
								table.insert(castQueue,{100,bkb})
							elseif #heroes == 5 then
								table.insert(castQueue,{100,bkb})
								return
							end
						end
					end
				end
				me:Attack(victim)
				castsleep = tick + 100
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
		if me.classId ~= CDOTA_Unit_Hero_Slark then 
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
	myhero, victim, start, resettime, castQueue = nil, nil, false, nil, {}
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
