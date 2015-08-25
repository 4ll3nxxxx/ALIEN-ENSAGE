require("libs.Utils")
require("libs.Animations")
require("libs.AbilityDamage")

play, spellList = false, {
	npc_dota_hero_pudge = {spell = "pudge_dismember"},
	npc_dota_hero_crystal_maiden = {spell = "crystal_maiden_freezing_field"},
	npc_dota_hero_enigma = {spell = "enigma_black_hole"},
	npc_dota_hero_witch_doctor = {spell = "witch_doctor_death_ward"},
	npc_dota_hero_luna = {spell = "luna_eclipse"}
}

function Tick(tick)
    if not PlayingGame() or not SleepCheck() then return end Sleep(250)
	local me = entityList:GetMyHero()
	local bloodstone, glimmercape = me:FindItem("item_bloodstone"), me:FindItem("item_glimmer_cape")
	local bottle, stick = me:FindItem("item_bottle"), me:FindItem("item_magic_stick") or me:FindItem("item_magic_wand")
	local phaseboots, forcestaff = me:FindItem("item_phase_boots"), me:FindItem("item_force_staff")
	local midas = me:FindItem("item_hand_of_midas")
	if not me:IsInvisible() and not me:IsChanneling() and me.alive then
		if forcestaff and forcestaff:CanBeCasted() then
			for i,v in ipairs(entityList:GetEntities(function (v) return v.hero and v.alive and v.visible and not v:IsIllusion() and v.team == me:GetEnemyTeam() end)) do
				for i,z in ipairs(v.abilities) do
					for i,k in ipairs(entityList:GetEntities(function (k) return (k.classId == CDOTA_BaseNPC_Tower or k.classId == CDOTA_BaseNPC_Building) and k.alive and k.team == me.team end)) do
						if entityList:GetMyPlayer().orderId == Player.ORDER_ATTACKENTITY and entityList:GetMyPlayer().target and (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, v))) - 0.30, 0)) == 0 and GetDistance2D(v,me) >= forcestaff.castRange-200 then
							me:CastAbility(forcestaff,me) break
						elseif entityList:GetMyPlayer().orderId == Player.ORDER_MOVETOPOSITION and (v.rot+180 > me.rot+180-(220/2) and v.rot+180 < me.rot+180+(220/2)) and (math.max(math.abs(FindAngleR(me) - math.rad(FindAngleBetween(me, k))) - 0.20, 0)) == 0 and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) < 0.15 then
							if (Animations.isAttacking(v) or z.abilityPhase and GetDistance2D(v,me) <= z.castRange+300) then
								me:CastAbility(forcestaff,me) break
							end
						end
					end
				end
			end
		end
		if bloodstone and bloodstone:CanBeCasted() then
			for i,v in ipairs(entityList:GetEntities(function (v) return v.hero and v.alive and v.visible and v.team == me:GetEnemyTeam() end)) do						
				for i,z in ipairs(v.abilities) do
					if GetDistance2D(v,me) <= z.castRange+100 and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) < 0.15 then
						local dmg, dmg2 = me:DamageTaken(AbilityDamage.GetDamage(z, me.healthRegen), AbilityDamage.GetDmgType(z), v), me:DamageTaken(v.dmgMin + v.dmgBonus, DAMAGE_PHYS, v)
						if (z.abilityPhase and me.health < dmg2 or me.health < dmg) then
							me:CastAbility(bloodstone,me.position)
						end
					end
				end
			end
		end
		if glimmercape and glimmercape:CanBeCasted() then
			if spellList[me.name] then
				local spell = me:FindSpell(spellList[me.name].spell)
				if spell and spell.level > 0 and spell.abilityPhase then
					me:CastAbility(glimmercape,me)
				end
			end
		end
		if midas and midas:CanBeCasted() then
			for i,v in ipairs(entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_CREEP and v.team ~= me.team and v.alive and v.visible and v.spawned and v.level >= 5 and not v.ancient and v.health > 0 and v.attackRange < 650 and v:GetDistance2D(me) < midas.castRange + 25 end)) do
				me:CastAbility(midas,v)
			end
		end
		if bottle and bottle:CanBeCasted() and me:DoesHaveModifier("modifier_fountain_aura_buff") and not me:DoesHaveModifier("modifier_bottle_regeneration") and (me.health < me.maxHealth or me.mana < me.maxMana) then
			me:CastAbility(bottle)
		end
		if phaseboots and phaseboots:CanBeCasted() then
			me:CastAbility(phaseboots)
		end
		if stick and stick:CanBeCasted() and stick.charges > 0 and me.health/me.maxHealth < 0.3 then
			me:CastAbility(stick)
		end
	end
end

function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_FRAME,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
