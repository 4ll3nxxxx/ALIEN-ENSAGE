require("libs.Utils")

local play = false local myhero = nil local dmg = {100,200,250,325} local delay = 0

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
    local ID = me.classId if ID ~= myhero then return end
    local Q = me:GetAbility(1) local R = me:GetAbility(4)
    local heros = entityList:GetEntities({type=LuaEntity.TYPE_HERO,visible=true,alive=true,team=me:GetEnemyTeam(),illusion=false})
    for i,v in ipairs(heros) do
    	if me.alive and tick > delay then
	    	local distance = GetDistance2D(me,v)
			local buff = v:DoesHaveModifier("modifier_bounty_hunter_track") or me:DoesHaveModifier("modifier_bounty_hunter_wind_walk")
			local invis = v:FindItem("item_invis_sword") or v:FindItem("item_shadow_amulet") local irune = v:FindItem("item_bottle")
			if Q and Q:CanBeCasted() and (v.health > 0 and v.health < dmg[Q.level]) and GetDistance2D(v,me) <= Q.castRange then me:CastAbility(Q,v) end
			if R and R:CanBeCasted() and not buff and distance <= R.castRange then
				if irune and irune.storedRune == 3 then me:CastAbility(R,v) end
				if invis and v:CanCast() then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_riki" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_clinkz" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_nyx_assassin" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_templar_assassin" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_broodmother" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_weaver" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_treant" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_sand_king" then me:CastAbility(R,v) end
				if v.name == "npc_dota_hero_invoker" then me:CastAbility(R,v) end
				if v.health/v.maxHealth < 0.4 then me:CastAbility(R,v) end
			end
			delay = tick + 400
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_BountyHunter then 
			script:Disable() 
		else
			play = true
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	myhero = nil
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)