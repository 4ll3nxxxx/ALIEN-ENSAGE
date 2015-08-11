require("libs.HotkeyConfig2")
require("libs.Utils")

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("Furion Go!")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("pushscript","Auto push",SGC_TYPE_TOGGLE,false,true,116)
ScriptConfig:AddParam("castult","Auto cast ult",SGC_TYPE_TOGGLE,false,true,117)

play, myhero = false, nil

function Main(tick)
	if not PlayingGame() or not SleepCheck() then return end Sleep(1000)
	local me, mp = entityList:GetMyHero(), entityList:GetMyPlayer()
	local ID = me.classId if ID ~= myhero then return end
	local R = me:GetAbility(4)
	if ScriptConfig.castult then
		if R and R:CanBeCasted() and me:CanCast() then
			local dmg = R:GetSpecialData("damage",R.level)
			if not me:AghanimState() then
				dmg = R:GetSpecialData("damage",R.level)
			elseif me:AghanimState() then		
				dmg = R:GetSpecialData("damage_scepter",R.level)
			end
			local enemyNpc = entityList:GetEntities(function (v) return (v.creep or v.hero) and v.alive and v.visible and v.team == entityList:GetMyHero():GetEnemyTeam() and v.health <= v:DamageTaken(dmg, DAMAGE_MAGC, me) end)
			for i,v in ipairs(enemyNpc) do
				if #enemyNpc == 3 then
					me:CastAbility(R, v.position) break
				end
				if v.type == LuaEntity.TYPE_HERO then
					me:CastAbility(R, v.position) break
				end
			end
		end
	end
	if ScriptConfig.pushscript then
		local treants = entityList:GetEntities({classId = CDOTA_BaseNPC_Creep, controllable = true,alive = true, team = me.team})
		for i,v in ipairs(treants) do
			local enemyNpc = entityList:GetEntities(function (z) return z.npc and z.alive and z.visible and z.team == entityList:GetMyHero():GetEnemyTeam() and v:GetDistance2D(z) <= 2000 end)
			if #enemyNpc ~= 0 then
				table.sort(enemyNpc, function (a,b) return a.health < b.health end)
				v:Attack(enemyNpc[1])
			local creep = entityList:GetEntities(function (k) return k.classId == CDOTA_BaseNPC_Creep_Lane and k.alive and k.visible and k.team == me.team and v:GetDistance2D(k) <= 2000 end)
			elseif #enemyNpc == 0 and #creep > 0 then
				v:Follow(creep[1])
			end
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Furion then 
			script:Disable() 
		else
			ScriptConfig:SetVisible(true)
			play, myhero = true, me.classId
			script:RegisterEvent(EVENT_FRAME, Main)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	if play then
		myhero = nil
		ScriptConfig:SetVisible(false)
		collectgarbage("collect")
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)