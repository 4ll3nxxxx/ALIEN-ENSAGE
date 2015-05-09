--<<Show a lot of hidden spells>>
--show sun strike, light strike, torrent, split earth, arrow, charge, infest, assassinate, hook, powershoot, Kunkka's ghost ship, ice blast, cold feed and supports stolen spell usage by rubick.
require("libs.Utils")
require("libs.Res")
require("libs.SideMessage")

local effect = {} local play = false local rate = client.screenSize.x/1600

--sunstrike, torrent, and other
effect.fromcast = {}
--arrow
effect.Arrow = {}
local ArrowS = nil
--boat
effect.Boat = {}
local BoatS = nil
--cold
effect.Cold = {}
local BlastM = nil
--charge
effect.speed = {600,650,700,750}
local speed = 600
local ChargeS = nil
--pudge and wr
effect.RC = {} effect.RangeCast = {}
--teches
effect.MS = {} 
--clock
local clockTime = 0
--jugernaut
local jugSleep = 0
--es
local EsSpiritTime = 0
effect.first = {}
effect.second = {}
effect.again = {}
effect.ESsleep = 0
--rubick
effect.rubick = {}
for i = 1,5 do 
	effect.rubick[i] = false
end
local stage = nil
--trap
effect.TS = {}
--in fog
effect.project = {} effect.projSleep = {} effect.illSleep = {} effect.projEnemy = {} effect.illsuion = {}
--smoke
effect.last = {}
--timers
effect.times = {}
--drawMgr
effect.ArrowI = drawMgr:CreateRect(0,0,18*rate,18*rate,0x000000ff) effect.ArrowI.visible = false
effect.PAI = drawMgr:CreateRect(0,0,18*rate,18*rate,0x000000ff) effect.PAI.visible = false
effect.InfestI = drawMgr:CreateRect(-10,-60,26*rate,26*rate,0xFF8AB160) effect.InfestI.visible = false
effect.SnipeI = drawMgr:CreateRect(-10,-60,26*rate,26*rate,0xFF8AB160) effect.SnipeI.visible = false
effect.CWI = drawMgr:CreateRect(0,0,18*rate,18*rate,0x000000ff) effect.CWI.visible = false
effect.ChargeI1 = drawMgr:CreateRect(-10,-60,26*rate,26*rate,0xFF8AB160) effect.ChargeI1.visible = false
effect.ChargeI2 = drawMgr:CreateRect(0,0,18*rate,18*rate,0xFF8AB160) effect.ChargeI2.visible = false
effect.Jugernaut = drawMgr:CreateRect(0,0,18*rate,18*rate,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/Juggernaut")) effect.Jugernaut.visible = false
effect.EsSpirit = drawMgr:CreateRect(0,0,18*rate,18*rate,0xFF8AB160,drawMgr:GetTextureId("NyanUI/miniheroes/Earth_Spirit")) effect.EsSpirit.visible = false

effect.spells = {
-- modifier name, effect name, second effect, aoe-range
{"modifier_invoker_sun_strike", "invoker_sun_strike_team","invoker_sun_strike_ring_b",175},
{"modifier_lina_light_strike_array", "lina_spell_light_strike_array_ring_collapse","lina_spell_light_strike_array_sphere",225},
{"modifier_kunkka_torrent_thinker", "kunkka_spell_torrent_pool","kunkka_spell_torrent_bubbles_b",225},
{"modifier_leshrac_split_earth_thinker", "leshrac_split_earth_b","leshrac_split_earth_c",225}
}

effect.HexList = {"modifier_sheepstick_debuff","modifier_lion_voodoo","modifier_shadow_shaman_voodoo"}
effect.SilenceList = {"modifier_skywrath_mage_ancient_seal","modifier_earth_spirit_boulder_smash_silence","modifier_orchid_malevolence_debuff","modifier_night_stalker_crippling_fear",
"modifier_silence","modifier_silencer_last_word_disarm","modifier_silencer_global_silence","modifier_doom_bringer_doom","modifier_legion_commander_duel"}

function Main(tick)
    if not SleepCheck() or not PlayingGame() then return end
    local me = entityList:GetMyHero()
	local cast = entityList:GetEntities({classId=CDOTA_BaseNPC})
	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO})
	--local projet F= entityList:GetProjectiles({})
	local team = me.team
	for i,v in ipairs(hero) do
		if v.team ~= team then 
			if not v:IsIllusion() then
				local id = v.classId
				if id == CDOTA_Unit_Hero_Mirana then ArrowF(cast,team,v.visible,"mirana")
				elseif id == CDOTA_Unit_Hero_SpiritBreaker then ChargeF(cast,team,v.visible,v:GetAbility(1),hero,"spirit_breaker")
				elseif id == CDOTA_Unit_Hero_Life_Stealer then InfestF(team,hero,"life_stealer")
				elseif id == CDOTA_Unit_Hero_Sniper then SnipeF(team,hero,"sniper")
				elseif id == CDOTA_Unit_Hero_Windrunner then RangeCastW(v,880,720)
				elseif id == CDOTA_Unit_Hero_Pudge then RangeCastP(v)
				elseif id == CDOTA_Unit_Hero_Rubick then WhatARubickF(hero,team,v.visible,v:GetAbility(5),cast)		
				elseif id == CDOTA_Unit_Hero_AncientApparition then AncientF(cast,team,hero,"ancient_apparition")
				elseif id == CDOTA_Unit_Hero_PhantomAssassin then PhantomKaF(v)
				elseif id == CDOTA_Unit_Hero_Rattletrap then ClockF(team,v.visible,cast,tick)
				elseif id == CDOTA_Unit_Hero_Kunkka then BoatF(cast,team)
				elseif id == CDOTA_Unit_Hero_Techies then MinesF(team)
				elseif id == CDOTA_Unit_Hero_TemplarAssassin or id == CDOTA_Unit_Hero_Pugna then TrapF(team)
				elseif id == CDOTA_Unit_Hero_Juggernaut then Jug(v.team,tick,v.visible)
				elseif id == CDOTA_Unit_Hero_EarthSpirit then ES(v.teams,tick,v.visible) end
			else
				--Illision(v,tick)
			end
		end
	end
	
	DirectBase(cast,team)
	--Project(projet,tick)
	ShowSmoke(me.team)
	--ShowTimers(me.team,tick,hero)
	
	Sleep(150)

end

function GenerateSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(200,60)
	test:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName)))
	test:AddElement(drawMgr:CreateRect(85,16,62,31,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/arrow_usual")))
	test:AddElement(drawMgr:CreateRect(150,11,40,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
end

function SmokeSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(200,60)
	test:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName)))
	test:AddElement(drawMgr:CreateRect(85,1,62,61,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/statpop_question")))
	test:AddElement(drawMgr:CreateRect(140,13,70,35,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/items/"..spellName)))
end

function RoshanSideMessage(title,sms)
	local test = sideMessage:CreateMessage(200,60)	
	test:AddElement(drawMgr:CreateRect(5,5,80,50,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/roshan")))
	test:AddElement(drawMgr:CreateText(90,3,-1,title,drawMgr:CreateFont("defaultFont","Arial",22,500)))
	test:AddElement(drawMgr:CreateText(100,25,-1,""..sms.."",drawMgr:CreateFont("defaultFont","Arial",25,500)))
end

function ShowTimers(teams,tick,enemy)

	if SleepCheck("ShowTimers") then

		for i,v in ipairs(enemy) do
		
			if v.team ~= teams and not v:IsIllusion() then

				local offset = v.healthbarOffset
				if offset == -1 then return end
				local hand = v.handle
				if not effect.times[hand] then
					effect.times[hand] = drawMgr:CreateText(-30,-50,0xFFFFFFFF,"",drawMgr:CreateFont("F13","Arial",20,500)) effect.times[hand].visible = false effect.times[hand].entity = v effect.times[hand].entityPosition = Vector(0,0,offset)			
				end

				if v.alive and v.visible and v.health > 0 then
					if v:IsStunned() then
						local stun = FindStunModifier(v)
						if stun then
							effect.times[hand].text = ""..stun
							effect.times[hand].color = 0xFFFFFFFF
							effect.times[hand].visible = true
						end
					elseif v:IsHexed() then
						local hex = FindHexOrSilenceModifier(v,effect.HexList)
						if hex then
							effect.times[hand].text = ""..hex
							effect.times[hand].color = 0xFFFF00FF
							effect.times[hand].visible = true
						end
					elseif v:IsSilenced() then
						local silence = FindHexOrSilenceModifier(v,effect.SilenceList)
						if silence then
							effect.times[hand].text = ""..silence
							effect.times[hand].color = 0xD50000FF
							effect.times[hand].visible = true
						end
					elseif effect.times[hand].visible then
						effect.times[hand].visible = false
					end
				elseif effect.times[hand].visible then
					effect.times[hand].visible = false
				end
				
			end
			
		end	
		
		Sleep(100,"ShowTimers")
		
	end
	
end

function ShowSmoke(teams)

	if SleepCheck("ShowSmoke") then

		local smoke = entityList:GetEntities(function (ent) return ent.type == LuaEntity.TYPE_ITEM and ent.owner.team ~= teams and ent.name == "item_smoke_of_deceit" end)
		
		for i = #smoke+1, 1, -1 do
			if not effect.last[i] then
				effect.last[i] = {0,0}
			end
			if #smoke ~= effect.last[i] then
				if smoke[i] then
					effect.last[i] = {#smoke,smoke[i].owner.name}
				elseif type(effect.last[i][2]) ~= "number" then
					SmokeSideMessage(effect.last[i][2]:gsub("npc_dota_hero_",""),"smoke_of_deceit")
					effect.last[i] = {0,0}
				end
			end
		end
		
		Sleep(1000,"ShowSmoke")
		
	end
	
end

function WhatARubickF(hero,team,status,spell,cast)
	if spell then
		local name = spell.name
		if name == "mirana_arrow" then
			effect.rubick[1] = true
			ArrowF(cast,team,status,"rubick")
		elseif name == "spirit_breaker_charge_of_darkness" then
			effect.rubick[2] = true
			ChargeF(cast,team,status,spell,hero,"rubick")
		elseif name == "life_stealer_infest" then
			effect.rubick[3] = true
			InfestF(team,hero,"rubick")
		elseif name == "sniper_assassinate" then
			effect.rubick[4] = true
			SnipeF(team,hero,"rubick")
		elseif name == "techies_land_mines" or name == "techies_stasis_trap" or name == "techies_remote_mines" then			
			effect.rubick[5] = true
			MinesF(team)
		elseif name == "kunkka_ghostship" then
			BoatF(cast,team)
		elseif name == "ancient_apparition_ice_blast" then
			AncientF(cast,team,hero,"rubick")			
		elseif effect.rubick[1] and effect.ArrowI.visible then
			effect.ArrowI.visible = false effect.rubick[1] = false effect.Arrow = {} collectgarbage("collect")
		elseif effect.rubick[2] and effect.ChargeI1.visible then
			effect.ChargeI1.visible.visible = false effect.ChargeI2.visible = false
		elseif effect.rubick[3] and effect.InfestI.visible then
			effect.InfestI.visible = false effect.rubick[3] = false
		elseif effect.rubick[4] and effect.SnipeI.visible then
			effect.SnipeI.visible = false effect.rubick[4] = false
		elseif effect.rubick[5] then
			effect.MS = {} effect.rubick[5] = false	collectgarbage("collect")
		end
	end
end

function DirectBase(cast,team)
	for i,v in ipairs(cast) do
		if v.team ~= team and #v.modifiers > 0 then
			local modifiers = v.modifiers
			for i,k in ipairs(effect.spells) do				
				if modifiers[1].name == k[1] and (not k.handle or k.handle ~= v.handle) then
					k.handle = v.handle
					local entry = { Effect(v, k[2]),Effect(v, k[3]),  Effect( v, "range_display") }
					entry[3]:SetVector(1, Vector( k[4], 0, 0) )
					table.insert(effect.fromcast,entry)
				end
			end
		end
	end
end

function Project(proj,tick)
	if SleepCheck("ShowPreject") then
		for i, v in ipairs(proj) do
			if v.source == nil then
				if string.sub(v.name, -11) == "base_attack" then
					local hero = v.name:gsub("_base_attack","")
					if not effect.project[hero] then
						effect.project[hero] = drawMgr:CreateRect(0,0,18,18,0x000000ff) effect.project[hero].visible = false					
						table.insert(effect.projEnemy,hero)
					elseif effect.project[hero].visible == false then	
						local minmap = MapToMinimap(v.position.x,v.position.y)
						effect.project[hero].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..hero)
						effect.project[hero].x = minmap.x-10
						effect.project[hero].y = minmap.y-10
						effect.project[hero].visible = true
						effect.projSleep[hero] = tick
					end
				end
			end
		end	
		for i,v in ipairs(effect.projEnemy) do
			if effect.project[v].visible then
				if tick >= effect.projSleep[v] + 1500 then
					effect.project[v].visible = false
				end
			end
		end
		Sleep(225,"ShowPreject")
	end	
end

function Illision(v,tick)
	if SleepCheck("ShowIllusion") then
		if not effect.illsuion[v.handle] then
			effect.illsuion[v.handle] = drawMgr:CreateRect(0,0,18,18,0x000000ff)
			effect.illSleep[v.handle] = tick + 1000
			local Minimap = MapToMinimap(v.position.x,v.position.y)
			effect.illsuion[v.handle].x = Minimap.x-10
			effect.illsuion[v.handle].y = Minimap.y-10
			effect.illsuion[v.handle].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..v.name:gsub("npc_dota_hero_",""))
		else
			effect.illsuion[v.handle].visible = (not v.visible and effect.illSleep[v.handle] >= tick and v.alive)
		end
		Sleep(250,"ShowIllusion")
	end
end

function Jug(teams,tick,visibl)
	if SleepCheck("Jug") then	
		if SleepCheck("healward") then
			local ward = entityList:GetEntities({classId=CDOTA_BaseNPC_Additive,alive = true,team=teams})[1]
			if ward then
				if not effect.Jugernaut.visible and jugSleep == 0 then
					jugSleep = tick + 2000
					local Minimap = MapToMinimap(ward.position.x,ward.position.y)
					effect.Jugernaut.x = Minimap.x-10
					effect.Jugernaut.y = Minimap.y-10
					effect.Jugernaut.visible = not visibl
					Sleep(50000,"healward")
				end			
			elseif jugSleep ~= 0 then
				jugSleep = 0
			end
		end
		effect.Jugernaut.visible = jugSleep > tick and not visible
		Sleep(500,"Jug")
	end	
end

function ES(teams,tick,visible)

	if SleepCheck("Smash") then
		
		local stone = entityList:GetEntities({classId = CDOTA_Unit_Earth_Spirit_Stone, team = teams})
	
		for i,v in ipairs(stone) do
		
			if not effect.first[v.handle] then
				EsSpiritTime = tick + 2000
				local Minimap = MapToMinimap(v.position.x,v.position.y)
				effect.EsSpirit.x = Minimap.x-10
				effect.EsSpirit.y = Minimap.y-10
				effect.EsSpirit.visible = not visible
				effect.first[v.handle] = true
			end
			
			--[[if #effect.second == 0 then
				if effect.first[v.handle].x ~= v.position.x or effect.first[v.handle].y ~= v.position.y then
					effect.ESsleep = tick + 1700
					local ret = FindRet(effect.first[v.handle],v.position)			
					for z=1,40 do
						local p = FindVector(effect.first[v.handle],ret,50*z+30)
						effect.second[z] = Effect(p,"draw_commentator")
						effect.second[z]:SetVector(1,Vector(255,255,255))
						effect.second[z]:SetVector(0,p)
					end					
				end				
			end ]]
			
		end
	
		--[[if effect.ESsleep ~= 0 and effect.ESsleep < tick then
			effect.ESsleep = 0					
			effect.second = {}			
			collectgarbage("collect")
			for i,v in ipairs(stone) do	
				effect.first[v.handle] = v.position
			end
		end]]

		effect.EsSpirit.visible = EsSpiritTime > tick and not visible
		
		Sleep(350,"Smash")
		
	end

end

function RangeCastW(v,befor,after)	
	local spell = v:GetAbility(2)
	if spell and spell.cd ~= 0 then
		local cd = math.floor(spell.cd*100)
		if cd < befor then
			if not effect.RangeCast[v.handle] then
				if cd > after then
					effect.RangeCast[v.handle] = true
					for a = 1, 140 do
						local pss = RCVector(v, 20 * a)
						effect.RC[a] = Effect(pss, "draw_commentator" )
						effect.RC[a]:SetVector(1,Vector(255,255,255))
						effect.RC[a]:SetVector(0, pss)
					end
				end
			elseif cd < after or v.alive == false then
				effect.RangeCast = {}
				effect.RC = {}
				collectgarbage("collect")
			end
		end
	end
end

function RangeCastP(v)	
	local spell = v:GetAbility(1)
	local before = {1374,1274,1174,1074}
	local after = {1280,1170,1060,950}
	local count = {52,57,62,67}
	if spell and spell.cd ~= 0 then
		local cd = math.floor(spell.cd*100)
		if not effect.RangeCast[v.handle] then
			if cd > before[spell.level] then
				effect.RangeCast[v.handle] = true
				for a = 1, count[spell.level] do
					local pss = RCVector(v, 20 * a)
					effect.RC[a] = Effect(pss, "draw_commentator" )
					effect.RC[a]:SetVector(1,Vector(255,255,255))
					effect.RC[a]:SetVector(0, pss)
				end
			end
		elseif cd < after[spell.level] or v.alive == false then
			effect.RangeCast = {}
			effect.RC = {}
			collectgarbage("collect")
		end
	end
end

function ArrowF(cast,team,status,heroName)
	local arrow = FindArrow(cast,team)
	if arrow then
		effect.ArrowI.visible = not status
		if not ArrowS then
			GenerateSideMessage(heroName,"mirana_arrow")
			ArrowS = arrow.position
			local Minimap = MapToMinimap(ArrowS.x,ArrowS.y)
			effect.ArrowI.x = Minimap.x-10
			effect.ArrowI.y = Minimap.y-10
			effect.ArrowI.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
		elseif #effect.Arrow == 0 and (ArrowS.x ~= arrow.position.x or ArrowS.y ~= arrow.position.y) then
			local ret = FindRet(ArrowS,arrow.position)
			for z = 1,147 do
				local p = FindVector(ArrowS,ret,20*z+60)
				effect.Arrow[z] = Effect(p, "draw_commentator" )
				effect.Arrow[z]:SetVector(1,Vector(255,255,255))
				effect.Arrow[z]:SetVector(0,p)
			end
		end
	elseif ArrowS then
		effect.Arrow = {}		
		ArrowS = nil
		effect.ArrowI.visible = false
		collectgarbage("collect")
	end
end

function BoatF(cast,team)
	local ship = FindBoat(cast,team)
	if ship then
		if not BoatS then
			BoatS = ship.position
		elseif not effect.Boat[1] and (BoatS.x ~= ship.position.x or BoatS.y ~= ship.position.y) then
			local ret = FindRet(BoatS,ship.position)
			local p = FindVector(BoatS,ret,1950)
			effect.Boat[1] = Effect(p,"range_display")
			effect.Boat[1]:SetVector(0,p)
			effect.Boat[1]:SetVector(1,Vector(425,0,0))
			effect.Boat[2] = Effect(p,"kunkka_ghostship_marker")
			effect.Boat[2]:SetVector(0,p)
		end
	elseif BoatS then
		effect.Boat = {}		
		BoatS = nil
		collectgarbage("collect")
	end
end

function AncientF(cast,team,hero,heroName)
	local blast = FindBlast(cast,team)
	if blast then
		if not BlastM then
			BlastM = true
			GenerateSideMessage(heroName,"ancient_apparition_ice_blast")
		end		
	elseif BlastM then
		BlastM = false
	end
	local cold = FindByModifierS(hero,"modifier_cold_feet",team)
	if cold then
		if not effect.Cold then
			local vpos = Vector(cold.position.x,cold.position.y,cold.position.z)
			effect.Cold = Effect(vpos,"range_display")
			effect.Cold:SetVector(0,vpos)
			effect.Cold:SetVector(1,Vector(740,0,0))
		end
	elseif effect.Cold then
		effect.Cold = nil
		collectgarbage("collect")
	end	
end

function ChargeF(cast,team,status,spell,hero,heroName)
	
	local target = FindByModifierS(hero,"modifier_spirit_breaker_charge_of_darkness_vision",team)
	if target then
		local clock = client.gameTime
		if status then ChargeS = clock end
		if spell and spell.level ~= 0 then speed = effect.speed[spell.level] end
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not effect.ChargeI1.visible then
			GenerateSideMessage(target.name:gsub("npc_dota_hero_",""),"spirit_breaker_charge_of_darkness")
			effect.ChargeI1.entity = target
			effect.ChargeI1.entityPosition = Vector(0,0,offset)
			effect.ChargeI1.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			effect.ChargeI1.visible = true
		end
		local Charged = FindCharge(cast)
		if Charged then
			if not ChargeS then
				ChargeS = clock
			end
			local distance = GetDistance2D(Charged,target)
			local Ddistance = distance - (clock - ChargeS)*speed
			local Minimap = MapToMinimap((Charged.position.x - target.position.x) * Ddistance / distance + target.position.x,(Charged.position.y - target.position.y) * Ddistance / distance + target.position.y)
			effect.ChargeI2.x = Minimap.x-10
			effect.ChargeI2.y = Minimap.y-10
			effect.ChargeI2.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			effect.ChargeI2.visible = not status
		end
	elseif effect.ChargeI1.visible then
		ChargeS = nil
		effect.ChargeI1.visible = false
		effect.ChargeI2.visible = false
	end
	
end

function InfestF(team,hero,heroName)
	local target = FindByModifierI(hero,"modifier_life_stealer_infest_effect",team)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not effect.InfestI.visible then
			GenerateSideMessage(target.name:gsub("npc_dota_hero_",""),"life_stealer_infest")
			effect.InfestI.entity = target
			effect.InfestI.entityPosition = Vector(0,0,offset)
			effect.InfestI.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			effect.InfestI.visible = true			
		end
	elseif effect.InfestI.visible then
		effect.InfestI.visible = false
	end
end

function SnipeF(team,hero,heroName)
	local target = FindByModifierS(hero,"modifier_sniper_assassinate",team)
	if target then
		local offset = target.healthbarOffset
		if offset == -1 then return end
		if not effect.SnipeI.visible then
			GenerateSideMessage(target.name:gsub("npc_dota_hero_",""),"sniper_assassinate")
			effect.SnipeI.entity = target
			effect.SnipeI.entityPosition = Vector(0,0,offset)
			effect.SnipeI.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..heroName)
			effect.SnipeI.visible = true
		end
	elseif effect.SnipeI.visible then
		effect.SnipeI.visible = false
	end
end

function PhantomKaF(v)
	if v:DoesHaveModifier("modifier_phantom_assassin_blur_active") then				
		local Minimap = MapToMinimap(v.position.x,v.position.y)
		effect.PAI.x = Minimap.x-10
		effect.PAI.y = Minimap.y-10
		effect.PAI.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/phantom_assassin")
		effect.PAI.visible = true
	elseif effect.PAI.visible then
		effect.PAI.visible = false
	end
end

function ClockF(team,status,cast,tick)	
	if SleepCheck("ShowClock") then		
		local march = FindMarch(cast,team)
		if march and clockTime == 0 then		
			local Minimap = MapToMinimap(march.position.x,march.position.y)
			effect.CWI.x = Minimap.x-10
			effect.CWI.y = Minimap.y-10			
			effect.CWI.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/rattletrap")
			effect.CWI.visible = not status
			clockTime = tick + 2000
		elseif clockTime < tick then
			clockTime = 0
			effect.CWI.visible = false
			Sleep(13000,"ShowClock")
		end			
	end
end

function MinesF(team)
	if SleepCheck("ShowMins") then
		local mins = entityList:GetEntities({classId=CDOTA_NPC_TechiesMines})
		for i,v in ipairs(mins) do
			if v.team ~= team then			
				if v.alive then	
					if not effect.MS[v.handle] then
						effect.MS[v.handle] = drawMgr:CreateRect(0,0,35,35,0x000000FF,drawMgr:GetTextureId("NyanUI/other/"..v.name))
						effect.MS[v.handle].entity = v effect.MS[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)	
					end
					effect.MS[v.handle].visible = not v.visible
				elseif effect.MS[v.handle] then
					effect.MS[v.handle].visible = false
					effect.MS[v.handle] = nil
				end
			end
		end
		Sleep(350,"ShowMins")
	end
end

function TrapF(team)
	if SleepCheck("ShowTrap") then
		local traps = entityList:GetEntities({classId=CDOTA_BaseNPC_Additive})
		for i,v in ipairs(traps) do
			if v.team ~= team then
				if not effect.TS[v.handle] then
					effect.TS[v.handle] = drawMgr:CreateRect(0,0,30,30,0x000000FF,drawMgr:GetTextureId("NyanUI/other/trap"))
					effect.TS[v.handle].entity = v effect.TS[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				effect.TS[v.handle].visible = not v.visible
			end
		end
		Sleep(350,"ShowTrap")
	end
end		

function Roha()
	if SleepCheck("Roshan") then
		local rosh = entityList:GetEntities({classId=CDOTA_Unit_Roshan})[1]
		if not stage then
			RoshanSideMessage("Respawn in","8:00-11:00")
			stage = 1
			sleep = math.floor(client.gameTime)		
		elseif sleep + 300 <= math.floor(client.gameTime) and stage == 1 then
			RoshanSideMessage("Respawn in:","3:00-6:00")
			stage = 2
		elseif sleep + 360 <= math.floor(client.gameTime) and stage == 2 then
			RoshanSideMessage("Respawn in:","2:00-5:00")
			stage = 3
		elseif sleep + 420 <= math.floor(client.gameTime) and stage == 3 then	
			RoshanSideMessage("Respawn in:","1:00-4:00")
			stage = 4
		elseif sleep + 480 <= math.floor(client.gameTime) and stage == 4 then	
			RoshanSideMessage("Respawn in:","0:00-3:00")
			stage = 5
		elseif rosh and rosh.alive and stage == 5 then
			stage = nil
			RoshanSideMessage("Respawn","00:00")	
			RoshanSideMessage("Respawn","00:00")
			script:UnregisterEvent(Roha)
		end
		Sleep(3000,"Roshan")
	end
end

function FindRet(first, second)
	local xAngle = math.deg(math.atan(math.abs(second.x - first.x)/math.abs(second.y - first.y)))	
	if first.x <= second.x and first.y >= second.y then
		return 270 + xAngle
	elseif first.x >= second.x and first.y >= second.y then
		return	(90-xAngle) + 180
	elseif first.x >= second.x and first.y <= second.y then
		return	90+xAngle
	elseif first.x <= second.x and first.y <= second.y then
		return	90 - xAngle
	end
end

function FindVector(first,ret,distance)
	local retVector = Vector()
	retVector = Vector(first.x + math.cos(math.rad(ret))*distance,first.y + math.sin(math.rad(ret))*distance,0)
	client:GetGroundPosition(retVector)
	retVector.z = retVector.z+100
	return retVector
end

function RCVector(ent,dis)
	local reVector = Vector()
	reVector = Vector(ent.position.x + dis * math.cos(ent.rotR), ent.position.y + dis * math.sin(ent.rotR), 0)
	client:GetGroundPosition(reVector)
	reVector.z = reVector.z+100
	return reVector
end	

function FindByModifierS(target,mod,team)
	for i,v in ipairs(target) do
		if v.team == team and v.visible and v.alive and v:DoesHaveModifier(mod) then
			return v
		end
	end
	return nil
end

function FindByModifierI(target,mod,team)
	for i,v in ipairs(target) do
		if v.team ~= team and v.visible and v.alive and v:DoesHaveModifier(mod) then
			return v
		end
	end
	return nil
end

function FindBlast(cast,team)
	for i, v in ipairs(cast) do
		if v.team ~= team and v.dayVision == 550 then
			return v
		end
	end
	return nil
end

function FindMarch(cast,team)
	for i, v in ipairs(cast) do
		if v.team ~= team and v.dayVision == 600 then
			return v
		end
	end
	return nil
end

function FindCharge(cast)
	for i, v in ipairs(cast) do
		if v.dayVision == 0 then
			return v
		end
	end
	return nil
end

function FindBoat(cast,team)
	for i,v in ipairs(cast) do
		if v.team ~= team and v.dayVision == 400 then
			return v
		end
	end
	return nil
end

function FindArrow(cast,team)
	for i, v in ipairs(cast) do
		if v.team ~= team and v.dayVision == 650 then
			return v
		end
	end
	return nil
end

function FindStunModifier(ent)
	for i = ent.modifierCount, 1, -1 do
		local v = ent.modifiers[i]
		if v.stunDebuff then
			return math.floor(v.remainingTime*10)/10
		end
	end
	return false
end

function FindHexOrSilenceModifier(ent,tab)
	for i = ent.modifierCount, 1, -1 do
		local v = ent.modifiers[i]
		if v.debuff then
			for k,l in ipairs(tab) do
				if v.name == l then
					return math.floor(v.remainingTime*10)/10
				end
			end
		end
	end
	return false
end

function Roshan( kill )
    if kill.name == "dota_roshan_kill" then		
		script:RegisterEvent(EVENT_TICK,Roha)
    end
end

function Load()
	if PlayingGame() then
		play = true		
		script:RegisterEvent(EVENT_TICK,Main)
		script:RegisterEvent(EVENT_DOTA,Roshan)
		script:UnregisterEvent(Load)
	end
end

function Close()
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Roshan)
		script:UnregisterEvent(Main)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
	if stage then
		script:UnregisterEvent(Roha)
	end		
	effect.fromcast = {} effect.Arrow = {} ArrowS = nil
	effect.Boat = {} BoatS = nil effect.Cold = {} BlastM = nil
	effect.speed = {600,650,700,750} speed = 600 ChargeS = nil
	effect.RC = {} effect.RangeCast = {} effect.MS = {} effect.last = {}
	clockTime = 0 stage = nil	effect.TS = {}	effect.rubick = {} 
	for i = 1,5 do 
		effect.rubick[i] = false
	end	
	effect.project = {} effect.projSleep = {} effect.illSleep = {} effect.projEnemy = {} effect.illsuion = {} effect.times = {}	
	EsSpiritTime = 0 effect.first = {} effect.second = {} effect.ESsleep = 0
	effect.ArrowI.visible = false
	effect.PAI.visible = false
	effect.InfestI.visible = false
	effect.SnipeI.visible = false
	effect.CWI.visible = false
	effect.ChargeI1.visible = false
	effect.ChargeI2.visible = false
	effect.Jugernaut.visible = false
	effect.EsSpirit.visible = false
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
