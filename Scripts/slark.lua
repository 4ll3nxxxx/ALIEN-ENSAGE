--<<Download texture https://mega.co.nz/#!8AZiFAbY!kMdEz0Fezz6cRzpVPrsNJTuUd4RFwHqDSI3cOV51U34 and unpack to nyanui/other>>

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:SetParameter("distanceXYZ", 400)
config:Load()

local play = false local myhero = nil local victim = nil local start = false local resettime = nil local sleep = {0,0,0}
local rate = client.screenSize.x/1600 local rec = {} local castQueue = {}
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

	for i=1,#castQueue,1 do
		local v = castQueue[1]
		table.remove(castQueue,1)
		local ability = v[2]
		if type(ability) == "string" then
			ability = me:FindItem(ability)
		end
		if ability and me:SafeCastAbility(ability,v[3],false) then
			sleep[3] = tick + v[1] + client.latency
			return
		end
	end

	local attackRange = me.attackRange	

	if IsKeyDown(config.Hotkey) and not client.chat then	
		if Animations.CanMove(me) or not start or (victim and GetDistance2D(victim,me) > attackRange+50) then
			start = true
			local lowestHP = targetFind:GetLowestEHP(3000, phys)
			if lowestHP and (not victim or GetDistance2D(me,victim) > 600 or not victim.alive or lowestHP.health < victim.health) and SleepCheck("victim") then			
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
			if tick > sleep[1] then
				if not Animations.isAttacking(me) and victim.alive and victim.visible then
					local immune = victim:DoesHaveModifier("modifier_omniknight_repel") or victim:DoesHaveModifier("modifier_black_king_bar_immune")
					local disable = victim:IsHexed() or victim:IsStunned() or victim:IsLinkensProtected()
					local shadowplay = me:DoesHaveModifier("modifier_item_invisibility_edge_windwalk")
					local abyssal = me:FindItem("item_abyssal_blade")
					local butterfly = me:FindItem("item_butterfly")
					local mom = me:FindItem("item_mask_of_madness")
					local satanic = me:FindItem("item_satanic")
					local BlackKingBar = me:FindItem("item_black_king_bar")
					local Q = me:GetAbility(1)
					local W = me:GetAbility(2)
					local R = me:GetAbility(4) 
					local distance = GetDistance2D(victim,me)
					if not shadowplay then
						if Q and Q:CanBeCasted() and me:CanCast() and not immune and distance <= 325 then
							table.insert(castQueue,{100,Q})
						end
						if W and W:CanBeCasted() and me:CanCast() and not immune and distance <= config.distanceXYZ then
							table.insert(castQueue,{1000+math.ceil(W:FindCastPoint()*1000),W})
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
						if mom and mom:CanBeCasted() and distance <= attackRange+100 then
							table.insert(castQueue,{100,mom})
						end
						if satanic and satanic:CanBeCasted() and me.health/me.maxHealth <= 0.4 and distance <= attackRange+100 then
							table.insert(castQueue,{100,satanic})
						end
						if BlackKingBar and BlackKingBar:CanBeCasted() and me:CanCast() then
							local heroes = entityList:GetEntities(function (v) return v.type==LuaEntity.TYPE_HERO and v.alive and v.visible and v.team~=me.team and me:GetDistance2D(v) <= 1200 end)
							if #heroes == 3 then
								table.insert(castQueue,{100,BlackKingBar})
							elseif #heroes == 4 then
								table.insert(castQueue,{100,BlackKingBar})
							elseif #heroes == 5 then
								table.insert(castQueue,{100,BlackKingBar})
								return
							end
						end
					end
				end
				if GetDistance2D(victim,me) > attackRange+100 then
					local xyz = SkillShot.PredictedXYZ(victim,me:GetTurnTime(victim)*1000+300+ client.latency)
					me:Move(xyz)
				else
					me:Attack(victim)
				end
				sleep[1] = tick + 100
			end
		elseif tick > sleep[2] then 
			if not Animations.isAttacking(me) then
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
		if me.classId ~= CDOTA_Unit_Hero_Slark then 
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
	rec[1].visible = false
	rec[2].visible = false
	rec[3].visible = false
	if play then
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
