--<<Download texture https://mega.co.nz/#!8AZiFAbY!kMdEz0Fezz6cRzpVPrsNJTuUd4RFwHqDSI3cOV51U34 and unpack to nyanui/other>>

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local start = false local resettime = nil local sleep = {0,0}
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end

	if victim and victim.visible then
		if not rec[i] then
			rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..victim.name:gsub("npc_dota_hero_",""))
		end
	else
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
	end

	local attackRange = me.attackRange	

	if IsKeyDown(config.Hotkey) and not client.chat then	
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
		end
		if not Animations.CanMove(me) and victim and GetDistance2D(me,victim) <= 2000 then
			if tick > sleep[1] and SleepCheck("casting") then
				if victim.hero and not Animations.isAttacking(me) then
					local Q = me:GetAbility(1)
					local R = me:GetAbility(4) 
					local W = me:GetAbility(2)
					local Overload = me:DoesHaveModifier("modifier_storm_spirit_overload")
					local Sheep = me:FindItem("item_sheepstick")
					local Orchid = me:FindItem("item_orchid")
					local Shivas = me:FindItem("item_shivas_guard")
					local Sphere = me:FindItem("item_sphere")
					local distance = GetDistance2D(victim,me)
					local disable = victim:IsSilenced() or victim:IsHexed() or victim:IsStunned() or victim:IsLinkensProtected()
					local balling = me:DoesHaveModifier("modifier_storm_spirit_ball_lightning")
					if R and R:CanBeCasted() and me:CanCast() and distance > me.attackRange and not balling and not R.abilityPhase then
						local CP = R:FindCastPoint()
						local delay = ((480-Animations.getDuration(R)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
						local speed = R:GetSpecialData("ball_lightning_move_speed", R.level)
						local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
						if xyz then 
							me:CastAbility(R,xyz)
							Sleep(CP*1000+me:GetTurnTime(victim)*1000, "casting")
						end
					end
					if Q and Q:CanBeCasted() and distance <= 260 then
						me:CastAbility(Q)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if W and W:CanBeCasted() and not disable and distance <= W.castRange then
						me:CastAbility(W,victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Orchid and Orchid:CanBeCasted() and not disable then
						me:CastAbility(Orchid, victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Sheep and Sheep:CanBeCasted() and not disable and Orchid.cd ~= 0 then
						me:CastAbility(Sheep, victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Sphere and Sphere:CanBeCasted() then
						me:CastAbility(Sphere,me)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Shivas and Shivas:CanBeCasted() and distance < 900 then
						me:CastAbility(Shivas)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
				end
				me:Attack(victim)
				sleep[1] = tick + 100
			end
		elseif tick > sleep[2] then
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
			sleep[2] = tick + 100
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
			rec[1].w = 90*rate + 30*0*rate + 65*rate rec[1].visible = true
			rec[2].x = 30*rate + 90*rate + 30*0*rate + 65*rate - 95*rate rec[2].visible = true
			rec[3].x = 80*rate + 90*rate + 30*0*rate + 65*rate - 50*rate rec[3].visible = true
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
	for i = 1, #rec do
		rec[i].visible = false
	end
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
