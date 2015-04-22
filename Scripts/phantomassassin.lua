--<<Download texture https://mega.co.nz/#!8AZiFAbY!kMdEz0Fezz6cRzpVPrsNJTuUd4RFwHqDSI3cOV51U34 and unpack to nyanui/other>>

require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.Animations")
require("libs.Skillshot")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "32", config.TYPE_HOTKEY)
config:SetParameter("lasthit", "D", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local victim = nil local attack = 0 local move = 0 local start = false local resettime = nil local dmg = {60,100,140,180}
local rate = client.screenSize.x/1600 local rec = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end

	if IsKeyDown(config.lasthit) and not client.chat then
		local Q = me:GetAbility(1)
		local creeps = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Lane,team=TEAM_ENEMY,alive=true,visible=true,team = me:GetEnemyTeam()})
		for i,v in ipairs(creeps) do
			if SleepCheck("lasthit") and Q and Q:CanBeCasted() and (v.health > 0 and v.health < dmg[Q.level]) and GetDistance2D(v,me) <= Q.castRange then
				me:CastAbility(Q,v)
				Sleep(150+client.latency, "lasthit")
			end
		end
	end

	local attackRange = me.attackRange	

	if victim and victim.visible then
		if not rec[i] then
			rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..victim.name:gsub("npc_dota_hero_",""))
		end
	else
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
	end

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
		if not Animations.CanMove(me) and victim and victim.alive and GetDistance2D(me,victim) <= 2000 then
			if tick > attack and SleepCheck("casting") then
				if victim.hero and not Animations.isAttacking(me) then
					local Q = me:GetAbility(1) local W = me:GetAbility(2)
					local medallion = me:FindItem("item_medallion_of_courage")
					local abyssal = me:FindItem("item_abyssal_blade")
					local butterfly = me:FindItem("item_butterfly")
					local mom = me:FindItem("item_mask_of_madness")
					local satanic = me:FindItem("item_satanic")
					local BlackKingBar = me:FindItem("item_black_king_bar")
					local disable = victim:IsSilenced() or victim:IsHexed() or victim:IsStunned() or victim:IsLinkensProtected()
					if Q and Q:CanBeCasted() and GetDistance2D(victim,me) <= Q.castRange then
						me:CastAbility(Q,victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if W and W:CanBeCasted() and GetDistance2D(victim,me) <= W.castRange then
						me:CastAbility(W,victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if medallion and medallion:CanBeCasted() and GetDistance2D(victim,me) <= me.attackRange then
						me:CastAbility(medallion,victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if abyssal and abyssal:CanBeCasted() and GetDistance2D(victim,me) <= abyssal.castRange and not disable then
						me:CastAbility(abyssal,victim)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if butterfly and butterfly:CanBeCasted() then
						me:CastAbility(butterfly)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if mom and mom:CanBeCasted() and GetDistance2D(victim,me) <= me.attackRange then
						me:CastAbility(mom)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if satanic and satanic:CanBeCasted() and me.health/me.maxHealth <= 0.4 and GetDistance2D(victim,me) <= me.attackRange then
						me:CastAbility(satanic)
						Sleep(me:GetTurnTime(victim)*1000, "casting")
					end
					if BlackKingBar and BlackKingBar:CanBeCasted() then
						local heroes = entityList:GetEntities(function (v) return v.type==LuaEntity.TYPE_HERO and v.alive and v.visible and v.team~=me.team and me:GetDistance2D(v) <= 1200 end)
						if #heroes == 3 then
							me:CastAbility(BlackKingBar)
							Sleep(client.latency,"casting")
						elseif #heroes == 4 then
							me:CastAbility(BlackKingBar)
							Sleep(client.latency,"casting")
						elseif #heroes == 5 then
							me:CastAbility(BlackKingBar)
							Sleep(client.latency,"casting")
							return
						end
					end
				end
				me:Attack(victim)
				attack = tick + 100
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
		if me.classId ~= CDOTA_Unit_Hero_PhantomAssassin then 
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
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
