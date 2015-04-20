require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:Load()
	
toggleKey = config.Hotkey

local play = false local myhero = nil local victim = nil local attack = 0 local move = 0 local start = false local resettime = nil local movetomouse = nil

local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*monitor,550*monitor) 
local victimText = drawMgr:CreateText(-50*monitor,1*monitor,0xFFFF00FF,"Chasing this guy!",F14) victimText.visible = false

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end
 	
	if victim and victim.visible then 
		if not victimText.visible then
			victimText.entity = victim
			victimText.entityPosition = Vector(0,0,victim.healthbarOffset)
			victimText.visible = true
		end
	else
		victimText.visible = false
	end
	
	local attackRange = me.attackRange	

	if IsKeyDown(toggleKey) and not client.chat then	
		if Animations.CanMove(me) or not start or (victim and GetDistance2D(victim,me) > attackRange+50) then
			start = true
			local lowestHP = targetFind:GetLowestEHP(3000, phys)
			if lowestHP and (not victim or victim.creep or GetDistance2D(me,victim) > 600 or not victim.alive or lowestHP.health < victim.health) and SleepCheck("victim") then			
				victim = lowestHP
				Sleep(250,"victim")
			end
			if victim and GetDistance2D(victim,me) > attackRange+200 and victim.visible then
				local closest = targetFind:GetClosestToMouse(me,2000)
				if closest and (not victim or closest.handle ~= victim.handle) then 
					victim = closest
				end
			end
			if not victim or not victim.hero then 					
				local creeps = entityList:GetEntities(function (v) return (v.courier or (v.creep and v.spawned) or (v.classId == CDOTA_BaseNPC_Creep_Neutral and v.spawned) or v.classId == CDOTA_BaseNPC_Tower or v.classId == CDOTA_BaseNPC_Venomancer_PlagueWard or v.classId == CDOTA_BaseNPC_Warlock_Golem or (v.classId == CDOTA_BaseNPC_Creep_Lane and v.spawned) or (v.classId == CDOTA_BaseNPC_Creep_Siege and v.spawned) or v.classId == CDOTA_Unit_VisageFamiliar or v.classId == CDOTA_Unit_Undying_Zombie or v.classId == CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit or v.classId == CDOTA_BaseNPC_Creep) and v.team ~= me.team and v.alive and v.health > 0 and me:GetDistance2D(v) <= attackRange*2 + 50 end)
				if creeps and #creeps > 0 then
					table.sort(creeps, function (a,b) return a.health < b.health end)
					if creeps[1] and (not victim or victim.handle ~= creeps[1]) then
						victim = creeps[1]	
					end
				end
			end
		end
		if not Animations.CanMove(me) and victim and GetDistance2D(me,victim) <= 2000 then
			if tick > attack and SleepCheck("casting") then
				if victim.hero and not Animations.isAttacking(me) then
					local R = me:GetAbility(4) 
					local W = me:GetAbility(2)
					local Overload = me:DoesHaveModifier("modifier_storm_spirit_overload")
					local Sheep = me:FindItem("item_sheepstick")
					local Orchid = me:FindItem("item_orchid")
					local Shivas = me:FindItem("item_shivas_guard")
					local Sphere = me:FindItem("item_sphere")
					local distance = GetDistance2D(victim,me)
					local Stuff = victim:IsSilenced() or victim:IsHexed() or victim:IsStunned() or victim:IsLinkensProtected()
					local balling = me:DoesHaveModifier("modifier_storm_spirit_ball_lightning")
					if R and R:CanBeCasted() and me:CanCast() and distance > attackRange and not balling and not R.abilityPhase then
						local CP = R:FindCastPoint()
						local delay = CP*1000+client.latency+me:GetTurnTime(victim)*1000
						local speed = R:GetSpecialData("ball_lightning_move_speed", R.level)
						local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
						if xyz then
							me:CastAbility(R,xyz)
							Sleep(CP*1000+me:GetTurnTime(victim)*1000, "casting")
						end
					end
					if Orchid and Orchid:CanBeCasted() and not Stuff then
						me:CastAbility(Orchid, victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Sheep and Sheep:CanBeCasted() and not Stuff and Orchid and Orchid.cd > 4 then
						me:CastAbility(Sheep, victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Shivas and Shivas:CanBeCasted() then
						me:CastAbility(Shivas)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Sphere and Sphere:CanBeCasted() then
						me:CastAbility(Sphere,me)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if not Overload then
						if W and W:CanBeCasted() and me:CanCast() and not Stuff and distance <= W.castRange+200 then
							me:CastAbility(W,victim)
							Sleep(W:FindCastPoint()*1000+me:GetTurnTime(victim)*1000,"casting")
							return
						end
					end
					if Q and Q:CanBeCasted() and me:CanCast() then
						local creeps = entityList:GetEntities(function (v) return (v.courier or (v.creep and v.spawned) or (v.classId == CDOTA_BaseNPC_Creep_Neutral and v.spawned) or (v.classId == CDOTA_BaseNPC_Creep_Lane and v.spawned) or (v.classId == CDOTA_BaseNPC_Creep_Siege and v.spawned) or v.classId == CDOTA_Unit_VisageFamiliar or v.classId == CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit or v.classId == CDOTA_BaseNPC_Creep) and v.team ~= me.team and v.alive and v.health > 0 and me:GetDistance2D(v) <= 425 end)
						if (not creeps or #creeps < 2) and distance <= 410 then
							me:CastAbility(Q)
							Sleep(client.latency, "casting")
							return
						end
					end						
				end
				me:Attack(victim)
				attack = tick + 100
			end
		elseif tick > move and SleepCheck("casting") then
			if victim and victim.hero and not Animations.isAttacking(me) then
				local Q = me:GetAbility(1)
				local Overload = me:DoesHaveModifier("modifier_storm_spirit_overload")
				local Dagon = me:FindDagon()
				local distance = GetDistance2D(victim,me)					
					
				if Dagon and Dagon:CanBeCasted() and me:CanCast() then
					me:CastAbility(Dagon, victim)
					Sleep(me:GetTurnTime(victim)*1000, "casting")
				end
				if not Overload then
					if Q and Q:CanBeCasted() and me:CanCast() and distance < attackRange then
						me:CastAbility(Q)
						Sleep(client.latency,"casting")
					end
				end					
			end
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
			move = tick + 100
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
			play = true
			victim = nil
			start = false
			resettime = nil
			myhero = me.classId
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
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
