require("libs.ScriptConfig")
require("libs.Utils")
require("libs.Skillshot")
require("libs.Animations")

local config = ScriptConfig.new()
config:SetParameter("combo", "32", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local sleep = {0,0}
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Tick(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end
	if IsKeyDown(config.combo) and not client.chat then
		local victim = FindTarget(me.team)
		local numb = 90*rate+30*0*rate+65*rate
		rec[1].w = numb
		rec[2].x = 30*rate + numb - 95*rate
		rec[3].x = 80*rate + numb - 50*rate
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..victim.name:gsub("npc_dota_hero_",""))
		for z = 1,3 do
			rec[z].visible = true
		end
		if not Animations.CanMove(me) and victim and victim.alive and GetDistance2D(me,victim) <= 2000 then
			if tick > sleep[1] and SleepCheck("Zzz") then
				if victim and not Animations.isAttacking(me) then
					local Q = me:GetAbility(1)
					local R = me:GetAbility(4)
					local diffusal = me:FindItem("item_diffusal_blade") or me:FindItem("item_diffusal_blade_2")
					local abyssal = me:FindItem("item_abyssal_blade")
					local butterfly = me:FindItem("item_butterfly")
					local mom = me:FindItem("item_mask_of_madness")
					local satanic = me:FindItem("item_satanic")
					local BlackKingBar = me:FindItem("item_black_king_bar")
					local distance = GetDistance2D(victim,me)
					local disable = victim:IsSilenced() or victim:IsSilenced() or victim:IsHexed() or victim:IsStunned() or victim:IsLinkensProtected()
					if Q and Q:CanBeCasted() then
						local CP = Q:FindCastPoint()
						local delay = ((550-Animations.getDuration(Q)*1000)+CP*1000+client.latency+me:GetTurnTime(victim)*1000)
						local speed = 1400
						local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
						if xyz and distance <= 550 then 
							me:CastAbility(Q,xyz)
							Sleep(CP*1000+me:GetTurnTime(victim)*1000, "Zzz")
						end
					end
					if R and R:CanBeCasted() and me:CanCast() and distance > me.attackRange+350 and not R.abilityPhase then
						me:CastAbility(R,victim)
						Sleep(me:GetTurnTime(victim)*1000, "Zzz")
					end
					if diffusal and diffusal:CanBeCasted() and distance <= diffusal.castRange and not disable then
						me:CastAbility(diffusal,victim)
						Sleep(me:GetTurnTime(victim)*1000, "Zzz")
					end
					if abyssal and abyssal:CanBeCasted() and distance <= abyssal.castRange and not disable then
						me:CastAbility(abyssal,victim)
						Sleep(me:GetTurnTime(victim)*1000, "Zzz")
					end
					if butterfly and butterfly:CanBeCasted() then
						me:CastAbility(butterfly)
						Sleep(me:GetTurnTime(victim)*1000, "Zzz")
					end
					if mom and mom:CanBeCasted() and distance <= me.attackRange then
						me:CastAbility(mom)
						Sleep(me:GetTurnTime(victim)*1000, "Zzz")
					end
					if satanic and satanic:CanBeCasted() and me.health/me.maxHealth <= 0.4 and distance <= me.attackRange then
						me:CastAbility(satanic)
						Sleep(me:GetTurnTime(victim)*1000, "Zzz")
					end
					if BlackKingBar and BlackKingBar:CanBeCasted() then
						local heroes = entityList:GetEntities(function (v) return v.type==LuaEntity.TYPE_HERO and v.alive and v.visible and v.team~=me.team and me:GetDistance2D(v) <= 1200 end)
						if #heroes == 3 then
							me:CastAbility(BlackKingBar)
							Sleep(client.latency,"Zzz")
						elseif #heroes == 4 then
							me:CastAbility(BlackKingBar)
							Sleep(client.latency,"Zzz")
						elseif #heroes == 5 then
							me:CastAbility(BlackKingBar)
							Sleep(client.latency,"Zzz")
							return
						end
					end
				end
				me:Attack(victim)
				sleep[1] = tick + 100
			end
			if victim and tick > sleep[2] then
				if victim.visible then
					local xyz = SkillShot.PredictedXYZ(victim,me:GetTurnTime(victim)*1000+client.latency+500)
					me:Move(xyz)
				else
					me:Follow(victim)
				end
			end
			sleep[2] = tick + 100
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
		if me.classId ~= CDOTA_Unit_Hero_Riki then 
			script:Disable() 
		else
			play = true
			victim = nil
			start = true
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
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
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
