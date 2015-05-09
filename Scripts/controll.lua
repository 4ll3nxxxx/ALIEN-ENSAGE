require("libs.ScriptConfig")
require("libs.Utils")
require("libs.TargetFind")
require("libs.stackpos")

local config = ScriptConfig.new()
config:SetParameter("activate", "32", config.TYPE_HOTKEY)
config:SetParameter("starkkey", "L", config.TYPE_HOTKEY)
config:SetParameter("bearkey", "E", config.TYPE_HOTKEY)
config:Load()

local play = false local activated = false local startstack = false local creepHandle = nil local target = nil local creepTable = {} local ordered = {} local mode = 3 local control = 0

function Key(msg,code)
	if client.chat or client.console or not PlayingGame() then return end
	if code == config.activate then
		activated = (msg == KEY_DOWN)
	elseif code == config.bearkey then
		bearkey = (msg == KEY_DOWN)
	elseif msg == KEY_UP and code == config.starkkey then
		local mp = entityList:GetMyPlayer()
		local creeps = mp.selection[1]
		if not creepTable[creeps.handle] or creepTable[creeps.handle] == 0 then
			if creeps then
				local range = 100000
				local neutrals = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Neutral,controllable=true,alive=true,visible=true})
				for n,m in ipairs(routes) do 
					local rang = GetDistance2D(creeps.position,m[1])
					local empty = true
					for o,p in ipairs(neutrals) do
						if creepTable[p.creepHandle] and creepTable[p.creepHandle] == n then
							empty = false
						end
					end
					if m.team == mp.team and range > rang and empty then
						range = rang
						creepTable[creeps.handle] = n
					end
				end
				creeps:Move(routes[creepTable[creeps.handle]][3])
				startstack = true
			end
		else
			creepTable[creeps.handle] = 0
		end
	end
end

function Tick( tick )
	if not PlayingGame() then return end
	
	local me = entityList:GetMyHero()
	local manycreeps = entityList:FindEntities(function (v) return (v.classId==CDOTA_Unit_Broodmother_Spiderling or v.classId==CDOTA_BaseNPC_Invoker_Forged_Spirit or v.classId==CDOTA_BaseNPC_Warlock_Golem or v.classId==CDOTA_BaseNPC_Tusk_Sigil) and v.controllable and v.alive and v.visible end)
	local neutrals = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Neutral,controllable=true,alive=true,visible=true})
	local creeps = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep,controllable=true,alive=true,visible=true})
	local illusions = entityList:FindEntities({classId=TYPE_HERO,controllable=true,alive=true,visible=true,illusion=true})
	local primalearth = entityList:FindEntities({classId=CDOTA_Unit_Brewmaster_PrimalEarth,controllable=true,alive=true,team=me.team})
	local primalstorm = entityList:FindEntities({classId=CDOTA_Unit_Brewmaster_PrimalStorm,controllable=true,alive=true,team=me.team})
	local primalfire = entityList:FindEntities({classId=CDOTA_Unit_Brewmaster_PrimalFire,controllable=true,alive=true,team=me.team})
	local visagefamiliar = entityList:FindEntities({classId=CDOTA_Unit_VisageFamiliar,controllable=true,alive=true,team=me.team})
	local spiritbear = entityList:FindEntities({classId=CDOTA_Unit_SpiritBear,controllable=true,alive=true,visible=true})

	if creepTable[creepHandle] ~= nil then
		creepHandle = nil
	end
	
	if mode == 1 then
		target = targetFind:GetLastMouseOver(2000)
	elseif mode == 2 then
		target = entityList:GetMouseover()
	elseif mode == 3 then
		target = targetFind:GetClosestToMouse(2000)
	else
		print("please check mode 1/2/3. Thank.")
		return
	end

	if startstack then
		for i,v in ipairs(neutrals) do
			if creepTable[v.handle] and creepTable[v.handle] ~= 0 and not ordered[v.handle] and isPosEqual(v.position,routes[creepTable[v.handle]][3],100) and math.floor(client.gameTime%60) == math.floor(52.48-540/v.movespeed) then
				ordered[v.handle] = true
				v:Move(routes[creepTable[v.handle]][1])
				v:Move(routes[creepTable[v.handle]][2],true)
				v:Move(routes[creepTable[v.handle]][3],true)
			elseif ordered[v.handle] and math.floor(client.gameTime%60) < 51 then
				ordered[v.handle] = false
			end
		end
	end

	if target and (activated or bearkey) and tick > control then
		if target.team ~= me.team then
			if #neutrals > 0 then
			local disabled = target:DoesHaveModifier("modifier_sheepstick_debuff") or target:DoesHaveModifier("modifier_lion_voodoo_restoration") or target:DoesHaveModifier("modifier_shadow_shaman_voodoo_restoration") or target:IsStunned()
				for i,v in ipairs(neutrals) do
					local distance = GetDistance2D(v,target)
					if distance <= 2000 then
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
						if distance <= 2000 then
							v:Attack(target)
						end
					end
				end
			end
			
			if #creeps > 0 then
				for i,v in ipairs(creeps) do
					local distance = GetDistance2D(v,target)
					if v.name:sub(1,28) == "npc_dota_necronomicon_archer" then
						if v:GetAbility(1):CanBeCasted() and distance <= 600 then
							v:CastAbility(v:GetAbility(1),target)
						end				
					end
					if distance <= 2000 then
						v:Attack(target)
					end
				end
			end
			
			if #illusions > 0 then
				for i,v in ipairs(illusions) do
					local distance = GetDistance2D(v,target)
					if distance <= 2000 then
						v:Attack(target)
					end
				end
			end

			if me.name == "npc_dota_hero_broodmother" or me.name == "npc_dota_hero_invoker" or me.name == "npc_dota_hero_warlock" or me.name == "npc_dota_hero_tusk" then
				if #manycreeps > 0 then
					for i,v in ipairs(manycreeps) do
						local distance = GetDistance2D(v,target)
						if distance <= 2000 then
							v:Attack(target)
						end
					end
				end
			end

			if me.name == "npc_dota_hero_beastmaster" then
				if #primalearth > 0 then
					for i,v in ipairs(primalearth) do
						local distance = GetDistance2D(v,target)
						if v:GetAbility(4):CanBeCasted() and distance <= 340 then
							v:CastAbility(v:GetAbility(4))
						end
						if v:GetAbility(1):CanBeCasted() and distance <= 800 then
							v:CastAbility(v:GetAbility(1),target)
						end
						if distance <= 2000 then
							v:Attack(target)
						end
					end
				end

				if #primalstorm > 0 then
					for i,v in ipairs(primalstorm) do
						local distance = GetDistance2D(v,target)
						if v:GetAbility(1):CanBeCasted() and distance <= 500 then
							v:CastAbility(v:GetAbility(1),target.position)
						end
						if v:GetAbility(4):CanBeCasted() and distance <= 850 then
							v:CastAbility(v:GetAbility(4),target)
						end
						if distance <= 2000 then
							v:Attack(target)
						end
					end
				end

				if #primalfire > 0 then
					for i,v in ipairs(primalfire) do
						local distance = GetDistance2D(v,target)
						if distance <= 2000 then
							v:Attack(target)
						end
					end
				end
			end

			if me.name == "npc_dota_hero_visage" then
				if #visagefamiliar > 0 then
					for i,v in ipairs(visagefamiliar) do
						local distance = GetDistance2D(v,target)
						if v.health/v.maxHealth < 0.26 and v:GetAbility(1):CanBeCasted() then
							v:CastAbility(v:GetAbility(1))
						end
						if distance <= 2000 then
							v:Attack(target)
						end
					end
				end
			end

			if me.name == "npc_dota_hero_lone_druid" then
				if #spiritbear > 0 then
					for i,v in ipairs(spiritbear) do
						local distance = GetDistance2D(v,target)
						local abyssal = v:FindItem("item_abyssal_blade")
						local mjollnir = v:FindItem("item_mjollnir")
						local boots = v:FindItem("item_phase_boots")
						if bearkey and v:GetAbility(1):CanBeCasted() then
							v:CastAbility(v:GetAbility(1))
						end
						if boots and boots:CanBeCasted() then
							v:CastAbility(boots)
						end
						if mjollnir and mjollnir:CanBeCasted() and distance <= 525 then
							v:CastAbility(mjollnir,v)
						end
						if abyssal and abyssal:CanBeCasted() and distance <= 140 and not disabled then
							v:CastAbility(abyssal,target)
						end
						if distance <= 2000 then
							v:Attack(target)
						end
					end
				end
			end
		end
		control = tick + 100
	end
end

function isPosEqual(v1, v2, d)
	return (v1-v2).length <= d
end

function Load()
	if PlayingGame() then
		play = true
		target = nil
		script:RegisterEvent(EVENT_KEY,Key)
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	creepTable = {}
	ordered = {}
	activated = false
	startstack = false
	target = nil
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
