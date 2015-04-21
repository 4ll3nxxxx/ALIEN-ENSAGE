require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.stackpos")

config = ScriptConfig.new()
config:SetParameter("activate", "32", config.TYPE_HOTKEY)
config:SetParameter("stackcamp", "L", config.TYPE_HOTKEY)
config:SetParameter("bearkey", "E", config.TYPE_HOTKEY)
config:Load()

hotkey1 = config.activate
hotkey2 = config.stackcamp
hotkey3 = config.bearkey

local eff = {}
local ordered = {}
local activated = false
local stack = false
local play = false
local creepHandle = nil
local mode=3 -- MODE 1/2/3

function Key(msg,code)
	if client.chat or client.console or client.loading then return end
	if code == hotkey1 then activated = (msg == KEY_DOWN) end
	if msg == KEY_UP then
		if code == hotkey2 then
			local mp = entityList:GetMyPlayer()
			local creep = mp.selection[1]
			if not eff[creep.handle] or eff[creep.handle] == 0 then
				if creep then
					local range = 100000
					local nc = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Neutral,controllable=true,alive=true,visible=true})
					for n,m in ipairs(routes) do 
						local rang = GetDistance2D(creep.position,m[1])
						local empty = true
						for o,p in ipairs(nc) do
							if eff[p.creepHandle] and eff[p.creepHandle] == n then
								empty = false
							end
						end
						if m.team == mp.team and range > rang and empty then
							range = rang
							eff[creep.handle] = n
						end
					end
					creep:Move(routes[eff[creep.handle]][3])
					stack = true
				end
			else
				eff[creep.handle] = 0
			end
		end
	end
end

function Tick( tick )
	if not PlayingGame() or sleepTick and sleepTick > tick then return end
	local target = nil
	local me = entityList:GetMyHero()
	local zz = entityList:FindEntities(function (v) return (v.classId==CDOTA_Unit_Broodmother_Spiderling or v.classId==CDOTA_BaseNPC_Invoker_Forged_Spirit or v.classId==CDOTA_BaseNPC_Warlock_Golem or v.classId==CDOTA_BaseNPC_Tusk_Sigil) and v.controllable and v.alive and v.visible end)
	local nc = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Neutral,controllable=true,alive=true,visible=true})
	local cc = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep,controllable=true,alive=true,visible=true})
	local ii = entityList:FindEntities({classId=TYPE_HERO,controllable=true,alive=true,visible=true,illusion=true})
	local pe = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalEarth,controllable=true,alive=true,team=me.team})
	local ps = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalStorm,controllable=true,alive=true,team=me.team})
	local pf = entityList:GetEntities({classId=CDOTA_Unit_Brewmaster_PrimalFire,controllable=true,alive=true,team=me.team})
	local vf = entityList:FindEntities({classId=CDOTA_Unit_VisageFamiliar,controllable=true,alive=true,team=me.team})
	local sb = entityList:FindEntities({classId=CDOTA_Unit_SpiritBear,controllable=true,alive=true,visible=true})

	if eff[creepHandle] ~= nil then
		creepHandle = nil
	end
	
	if mode == 1 then
		target = targetFind:GetLastMouseOver(1300)
	elseif mode == 2 then
		target = entityList:GetMouseover()
	elseif mode == 3 then
		target = targetFind:GetClosestToMouse(1300)
	else
		print("please check mode 1/2/3. Thank.")
		return
	end

	if target and activated then
		if target.team == (5-me.team) then
			if #nc > 0 then
			local disabled = target:DoesHaveModifier("modifier_sheepstick_debuff") or target:DoesHaveModifier("modifier_lion_voodoo_restoration") or target:DoesHaveModifier("modifier_shadow_shaman_voodoo_restoration") or target:IsStunned()
				for i,v in ipairs(nc) do
					if v.controllable and v.handle ~= creepHandle then
						if v.unitState ~= -1031241196 then
							local distance = GetDistance2D(v,target)
							if distance <= 1300 then
								if v.name == "npc_dota_neutral_centaur_khan" then
									if v:GetAbility(1):CanBeCasted() and distance < 200 and not disabled then
										v:CastAbility(v:GetAbility(1))
									end
								elseif v.name == "npc_dota_neutral_satyr_hellcaller" then
									if v:GetAbility(1):CanBeCasted() and distance < 850 then
										v:CastAbility(v:GetAbility(1),target.position)
									end						
								elseif v.name == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
									if v:GetAbility(1):CanBeCasted() and distance < 240 then
										v:CastAbility(v:GetAbility(1))
									end							
								elseif v.name == "npc_dota_neutral_dark_troll_warlord" then
									if v:GetAbility(1):CanBeCasted() and distance < 550 and not disabled then
										v:CastAbility(v:GetAbility(1),target)
									end	
								elseif v.name == "npc_dota_neutral_big_thunder_lizard" then
									if v:GetAbility(1):CanBeCasted() and distance < 250 then
										v:CastAbility(v:GetAbility(1))
									end
									if v:GetAbility(2):CanBeCasted() then
										v:CastAbility(v:GetAbility(2))
									end					
								end
								if distance <= 1300 then
									v:Attack(target)
								end
							end
						end
					end
				end
			end
		
			if #zz > 0 then
				for i,v in ipairs(zz) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #cc > 0 then
				for i,v in ipairs(cc) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if v.name:sub(1,28) == "npc_dota_necronomicon_archer" then
							if v:GetAbility(1):CanBeCasted() and distance <= 600 then
								v:CastAbility(v:GetAbility(1),target)
							end				
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #ii > 0 then
				for i,v in ipairs(ii) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #pe > 0 then
				for i,v in ipairs(pe) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if v:GetAbility(4):CanBeCasted() and distance <= 340 then
							v:CastAbility(v:GetAbility(4))
						end
						if v:GetAbility(1):CanBeCasted() and distance <= 800 then
							v:CastAbility(v:GetAbility(1),target)
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #ps > 0 then
				for i,v in ipairs(ps) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if v:GetAbility(1):CanBeCasted() and distance <= 500 then
							v:CastAbility(v:GetAbility(1),target.position)
						end
						if v:GetAbility(4):CanBeCasted() and distance <= 850 then
							v:CastAbility(v:GetAbility(4),target)
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #pf > 0 then
				for i,v in ipairs(pf) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #vf > 0 then
				for i,v in ipairs(vf) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						if v.health/v.maxHealth < 0.26 and v:GetAbility(1):CanBeCasted() then
							v:CastAbility(v:GetAbility(1))
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

			if #sb > 0 then
				for i,v in ipairs(sb) do
					if v.controllable and v.unitState ~= -1031241196 then
						local distance = GetDistance2D(v,target)
						local ab = v:FindItem("item_abyssal_blade")
						local mj = v:FindItem("item_mjollnir")
						local pb = v:FindItem("item_phase_boots")
						if IsKeyDown(hotkey3) and v:GetAbility(1):CanBeCasted() then
							v:CastAbility(v:GetAbility(1))
						end
						if pb and pb:CanBeCasted() then
							v:CastAbility(pb)
						end
						if mj and mj:CanBeCasted() and distance <= 525 then
							v:CastAbility(mj,v)
						end
						if ab and ab:CanBeCasted() and distance <= 140 and not disabled then
							v:CastAbility(ab,target)
						end
						if distance <= 1300 then
							v:Attack(target)
						end
					end
				end
			end

		end
	end
	if stack then
		for i,v in ipairs(nc) do
			if eff[v.handle] and eff[v.handle] ~= 0 and not ordered[v.handle] and isPosEqual(v.position,routes[eff[v.handle]][3],100) and math.floor(client.gameTime%60) == math.floor(52.48-540/v.movespeed) then
				ordered[v.handle] = true
				v:Move(routes[eff[v.handle]][1])
				v:Move(routes[eff[v.handle]][2],true)
				v:Move(routes[eff[v.handle]][3],true)
			elseif ordered[v.handle] and math.floor(client.gameTime%60) < 51 then
				ordered[v.handle] = false
			end
		end
	end
	sleepTick = tick + 250
end

function isPosEqual(v1, v2, d)
	return (v1-v2).length <= d
end

function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_KEY,Key)
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	eff = {}
	ordered = {}
	activated = false
	stack = false
	creepHandle = nil
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
