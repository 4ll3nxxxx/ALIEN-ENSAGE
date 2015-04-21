--<<Download texture https://mega.co.nz/#!8AZiFAbY!kMdEz0Fezz6cRzpVPrsNJTuUd4RFwHqDSI3cOV51U34 and unpack to nyanui/other>>

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.Skillshot")
require("libs.Animations")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local attack = 0 local move = 0
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end
	if IsKeyDown(config.Hotkey) and not client.chat then
		local victim = FindTarget(me.team)
		rec[1].w = 90*rate + 30*0*rate + 65*rate
		rec[2].x = 30*rate + 90*rate + 30*0*rate + 65*rate - 95*rate
		rec[3].x = 80*rate + 90*rate + 30*0*rate + 65*rate - 50*rate
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..victim.name:gsub("npc_dota_hero_",""))
		for z = 1,3 do
			rec[z].visible = true
		end
		if not Animations.CanMove(me) and victim and victim.alive and GetDistance2D(me,victim) <= 2000 then
			if tick > attack and SleepCheck("casting") then
				if victim and not Animations.isAttacking(me) then
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
						if xyz and distance <= 1600 then 
							me:CastAbility(R,xyz)
							Sleep(CP*1000+me:GetTurnTime(victim)*1000, "casting")
						end
					end
					if W and W:CanBeCasted() and not disable and distance <= W.castRange then
						me:CastAbility(W,victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if Q and Q:CanBeCasted() and distance <= 260 and not Overload then
						me:CastAbility(Q)
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
				attack = tick + 100
			end
			if tick > move and victim then
				if victim.visible then
					local xyz = SkillShot.PredictedXYZ(victim,me:GetTurnTime(victim)*1000+client.latency+500)
					me:Move(xyz)
				else
					me:Follow(victim)
				end
			end
			move = tick + 100
		end
	end
end

function FindTarget(teams)
	local enemy = entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.team ~= teams and v.visible and v.alive and not v.illusion end)
	if #enemy == 0 then
		return entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.team ~= teams end)[1]
	elseif #enemy == 1 then
		return enemy[1]	
	else
		local mouse = client.mousePosition
		table.sort( enemy, function (a,b) return GetDistance2D(mouse,a) < GetDistance2D(mouse,b) end)
		return enemy[1]
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_StormSpirit then 
			script:Disable() 
		else
			play = true
			myhero = me.classId
			script:RegisterEvent(EVENT_FRAME, Main)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	myhero = nil
	victim = nil
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
