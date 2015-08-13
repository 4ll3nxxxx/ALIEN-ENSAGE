require("libs.HotkeyConfig2")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Storm Spirit")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("hotkey","Key",SGC_TYPE_ONKEYDOWN,false,false,32)
ScriptConfig:AddParam("dodge","Auto Dodge Spells",SGC_TYPE_TOGGLE,false,true,nil)

play, myhero, victim, start, resettime, castQueue, castsleep, move = false, nil, nil, false, false, {}, 0, 0

dodgeList = {
	npc_dota_hero_lina = {spell = "lina_laguna_blade"},
	npc_dota_hero_sven = {spell = "sven_storm_bolt"},
	npc_dota_hero_vengefulspirit = {spell = "vengefulspirit_magic_missile"},
	npc_dota_hero_skeleton_king = {spell = "skeleton_king_hellfire_blast"},
	npc_dota_hero_lion = {spell = "lion_finger_of_death"}
} 

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

	if ScriptConfig.dodge then
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team=me:GetEnemyTeam(),illusion=false})
		for i,v in ipairs(enemies) do
			local R = me:GetAbility(4)
			if R and R:CanBeCasted() and me:CanCast() and dodgeList[v.name] and SleepCheck("cd") then
				local spell = v:FindSpell(dodgeList[v.name].spell)
				if spell and spell.abilityPhase and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) == 0 then
					table.insert(castQueue,{math.ceil(R:FindCastPoint()*1000),R,me.position}) Sleep(1000 + client.latency, "cd")
				end
			end
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
				if not Animations.isAttacking(me) then
					local Q, W, R = me:GetAbility(1), me:GetAbility(2), me:GetAbility(4)
					local Overload, balling = me:DoesHaveModifier("modifier_storm_spirit_overload"), me:DoesHaveModifier("modifier_storm_spirit_ball_lightning")
					local Sheep, Orchid, Shivas, Sphere = me:FindItem("item_sheepstick"), me:FindItem("item_orchid"), me:FindItem("item_shivas_guard"), me:FindItem("item_sphere")
					local distance, disabled = GetDistance2D(victim,me),victim:IsSilenced() or victim:IsHexed() or victim:IsStunned()
					if R and R:CanBeCasted() and me:CanCast() and distance > me.attackRange and not balling and not R.abilityPhase then
						local xyz = SkillShot.SkillShotXYZ(me,victim,((50-Animations.getDuration(W)*1000)+R:FindCastPoint()*1000+client.latency+me:GetTurnTime(victim)*1000),R:GetSpecialData("ball_lightning_move_speed", R.level))
						if xyz then 
							table.insert(castQueue,{math.ceil(R:FindCastPoint()*1000),R,xyz})
						end
					end
					if Q and Q:CanBeCasted() and distance <= 260 then
						table.insert(castQueue,{100,Q})
					end
					if W and W:CanBeCasted() and not disable and distance <= W.castRange + 200 then
						table.insert(castQueue,{math.ceil(W:FindCastPoint()*1000),W,victim,true})
					end
					if Orchid and Orchid:CanBeCasted() and not disable and (Sheep and Sheep.cd ~= 0 and not victim:IsHexed() or not Sheep) then
						table.insert(castQueue,{math.ceil(Orchid:FindCastPoint()*1000),Orchid,victim})
					end
					if Sheep and Sheep:CanBeCasted() and not disable then
						table.insert(castQueue,{math.ceil(Sheep:FindCastPoint()*1000),Sheep,victim})
					end
					if Sphere and Sphere:CanBeCasted() then
						table.insert(castQueue,{100,Sphere})
					end
					if Shivas and Shivas:CanBeCasted() and distance < 900 then
						table.insert(castQueue,{100,Shivas})
					end
				end
				me:Attack(victim)
				castsleep = tick + 200
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
		if me.classId ~= CDOTA_Unit_Hero_StormSpirit then 
			script:Disable() 
		else
			ScriptConfig:SetVisible(true)
			play, myhero = true, me.classId
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
