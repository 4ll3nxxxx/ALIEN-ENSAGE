--<<Automatically kill enemy as soon as their health drops low enough>>

-- a lot of improve. (performance,calculation,prediction)
require("libs.ScriptConfig")
require("libs.Utils")
require("libs.SideMessage")

local config = ScriptConfig.new()
config:SetParameter("Active", "114", config.TYPE_HOTKEY)
config:SetParameter("GlobalKey", "115", config.TYPE_HOTKEY)
config:SetParameter("AutoGlobalSpells", false)
config:SetParameter("MinTarget4AutoKill", 2)
config:Load()

local xx = nil local yy = nil

if math.floor(client.screenRatio*100) == 177 then
	xx = client.screenSize.x/300
	yy = client.screenSize.y/1.372
elseif math.floor(client.screenRatio*100) == 125 then
	xx = client.screenSize.x/512
	yy = client.screenSize.y/1.341
elseif math.floor(client.screenRatio*100) == 160 then
	xx = client.screenSize.x/512
	yy = client.screenSize.y/1.378
else
	xx = client.screenSize.x/512
	yy = client.screenSize.y/1.378
end

--Stuff
local hero = {} local heroG = {} local note = {} local play = false local combo = false
local activ = true local draw = true local myhero = nil local dmgg = nil local mine = {}

--Draw function
local shft = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Tahoma",14*shft,500*shft)
local rect = drawMgr:CreateRect(xx-1,yy-1,26,26,0x00000090,true) rect.visible = false
local icon = drawMgr:CreateRect(xx,yy,24,24,0x000000ff) icon.visible = false
local dmgCalc = drawMgr:CreateText(xx*shft, yy-18*shft, 0x00000099,"Dmg",F14) dmgCalc.visible = false

function Tick(tick)
	if not SleepCheck() then return end	
	local me = entityList:GetMyHero() if not me then return end
	local ID = me.classId if ID ~= myhero then Close() end

	if not dmgg then 
		Sleep(150) 
	else
		Sleep(50)
		local pl = entityList:GetMyPlayer()
		if pl.orderId == 6 and pl.target then
			if pl.target.health > dmgg then
				me:Stop()		
				me:Stop(true)
			end
		end
	end

	dmgCalc.visible = draw
	rect.visible,icon.visible = activ,activ

	--Kill(false,linkin block,me,ability,damage,scepter damage,range,target(1-target,2-target.position,3-non target),classId,damage type)
	if ID == CDOTA_Unit_Hero_Abaddon then
		Kill(true,me,1,{100, 150, 200, 250},nil,nil,1)	
	elseif ID == CDOTA_Unit_Hero_Bane then
		Kill(true,me,2,{90, 160, 230, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_BountyHunter then
		Kill(true,me,1,{100, 200, 250, 325},nil,700,1)
	elseif ID == CDOTA_Unit_Hero_Broodmother then
		Kill(true,me,1,{75, 150, 225, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Centaur then
		Kill(true,me,2,{175, 250, 325, 400},nil,300,1)
	elseif ID == CDOTA_Unit_Hero_Chen then
		Kill(true,me,2,{50, 100, 150, 200},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_CrystalMaiden then		
		Kill(false,me,1,{100, 150, 200, 250},nil,700,2)
	elseif ID == CDOTA_Unit_Hero_DeathProphet then		
		Kill(false,me,1,{75, 150, 225, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_DragonKnight then
		Kill(false,me,1,{90, 170, 240, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_EarthSpirit then
		Kill(true,me,1,{125, 125, 125, 125},nil,250,1)
	elseif ID == CDOTA_Unit_Hero_Earthshaker then
		Kill(false,me,1,{125, 175, 225, 275},nil,nil,2)
	elseif ID == CDOTA_Unit_Hero_Leshrac then
		Kill(true,me,3,{80, 140, 200, 260},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lich then		
		Kill(true,me,1,{115, 200, 275, 350},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lion then
		Kill(true,me,4,{600, 725, 850},{725, 875, 1025},nil,1)
	elseif ID == CDOTA_Unit_Hero_Luna then		
		Kill(true,me,1,{75, 150, 210, 260},nil,nil,1)	
	elseif ID == CDOTA_Unit_Hero_NightStalker then
		Kill(true,me,1,{90, 160, 225, 335},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Oracle then
		Kill(true,me,3,{90, 180, 270, 360},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_PhantomLancer then
		Kill(true,me,1,{100, 150, 200, 250},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Puck then
		Kill(false,me,2,{70, 140, 210, 280},nil,400,3)
	elseif ID == CDOTA_Unit_Hero_PhantomAssassin then
		Kill(true,me,1,{30,50,70,90},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_QueenOfPain then
		Kill(false,me,3,{85, 165, 225, 300},nil,475,3)
	elseif ID == CDOTA_Unit_Hero_Rattletrap then
		Kill(false,me,3,{80, 120, 160, 200},nil,1000,2)
	elseif ID == CDOTA_Unit_Hero_Rubick then
		Kill(true,me,3,{70, 140, 210, 280},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_SkeletonKing then
		Kill(true,me,1,{80, 160, 230, 300},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Shredder then
		Kill(false,me,1,{100, 150, 200, 250},nil,300,3)
	elseif ID == CDOTA_Unit_Hero_Spectre then
		Kill(true,me,1,{50, 100, 150, 200},nil,2000,1)
	elseif ID == CDOTA_Unit_Hero_ShadowShaman then
		Kill(true,me,1,{140, 200, 260, 320},nil,nil,1)	
	elseif ID == CDOTA_Unit_Hero_Sniper then
		Kill(true,me,4,{350, 500, 650},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Sven then
		Kill(true,me,1,{100, 175, 250, 325},nil,650,1)
	elseif ID == CDOTA_Unit_Hero_Tidehunter then
		Kill(true,me,1,{110, 160, 210, 260},nil,750,1)
	elseif ID == CDOTA_Unit_Hero_Tinker then
		if me:GetAbility(1).state == LuaEntityAbility.STATE_READY then
			Kill(true,me,1,{80, 160, 240, 320},nil,nil,1)
		elseif me:GetAbility(2).state == LuaEntityAbility.STATE_READY then
			Kill(false,me,2,{125, 200, 275, 350},nil,2500,3)
		else	
			Kill(true,me,1,{80, 160, 240, 320},nil,nil,1)
		end
	elseif ID == CDOTA_Unit_Hero_VengefulSpirit then
		Kill(true,me,1,{100, 175, 250, 325},nil,nil,1)
	elseif ID == CDOTA_Unit_Hero_Lina then
		if not me:AghanimState() then
			Kill(true,me,4,{450,675,950},nil,nil,1)
		else
			KillLina(true,me,4,{450,675,950},nil,nil,1)
		end
	elseif ID == CDOTA_Unit_Hero_Alchemist then
		SmartKill(false,me,2,{24,33,42,52.5},nil,800,1,ID)
	elseif ID == CDOTA_Unit_Hero_Morphling then
		SmartKill(true,me,2,{20, 40, 60, 80},nil,nil,1,ID)
	elseif ID == CDOTA_Unit_Hero_Visage then
		SmartKill(true,me,2,{20,20,20,20},nil,nil,1,ID)
	elseif ID == CDOTA_Unit_Hero_Undying then
		SmartKill(true,me,2,{10,12,14,16},nil,nil,1,ID)
	elseif ID == CDOTA_Unit_Hero_Riki then
		RikiKill(true,me,4,{40,70,100},nil,4)
	--complex spells
	--Kill(linkin block,me,ability,damage,scepter damage,range,target,classId,damage type)
	elseif me.classId == CDOTA_Unit_Hero_AntiMage then
		ComplexKill(true,me,4,{.6,.85,1.1},nil,nil,1,ID)
	elseif me.classId == CDOTA_Unit_Hero_DoomBringer then
		ComplexKill(true,me,3,{1,1,1,1},nil,nil,1,ID)
	elseif me.classId == CDOTA_Unit_Hero_Legion_Commander then
		ComplexKill(false,me,1,{40,80,120,160},nil,nil,2,ID)
	elseif me.classId == CDOTA_Unit_Hero_Mirana then
		ComplexKill(false,me,1,{75,150,225,300},nil,625,3,ID)
	elseif ID == CDOTA_Unit_Hero_Necrolyte then
		ComplexKill(true,me,4,{0.4,0.6,0.9},{0.6,0.9,1.2},nil,1,ID)	
	elseif ID == CDOTA_Unit_Hero_Nyx_Assassin then
		ComplexKill(true,me,2,{3.5,4,4.5,5},nil,nil,1,ID)	
	elseif ID == CDOTA_Unit_Hero_Techies then
		Kill(false,me,3,{500,650,850,1150},nil,250,1)
		KillMines(me,6,{300,450,600},{450,600,750},true,ID)
	elseif ID == CDOTA_Unit_Hero_Tusk then
		local tkdmg = (me.dmgMin + me.dmgBonus)*3.5
		Kill(false,me,4,{tkdmg, tkdmg, tkdmg, tkdmg},nil,300,1)
	elseif ID == CDOTA_Unit_Hero_Obsidian_Destroyer then
		ComplexKill(false,me,4,{8,9,10},{9,10,11},nil,2,ID)	
	elseif ID == CDOTA_Unit_Hero_Elder_Titan then
		ComplexKill(false,me,2,{60,90,120,150},nil,nil,2,ID)
	elseif ID == CDOTA_Unit_Hero_Shadow_Demon then
		ComplexKill(false,me,3,{20, 35, 60, 65},nil,nil,4,ID)
	--prediction
	elseif ID == CDOTA_Unit_Hero_Magnataur then
		KillPrediction(me,1,{75, 150, 225, 300},0.3,1050)
	elseif ID == CDOTA_Unit_Hero_Windrunner then
		KillPrediction(me,2,{120, 200, 280, 360},1.2,3000)
	--global
	elseif ID == CDOTA_Unit_Hero_Furion then
		KillGlobal(me,4,{140,180,225},{155,210,275},1)
	elseif ID == CDOTA_Unit_Hero_Zuus then
		KillGlobal(me,4,{225,350,475},{440,540,640},3)
		ComplexKill(true,me,2,{100,175,275,350},nil,nil,1,ID)
	--other
	-------------------develop--------------------
	elseif ID == CDOTA_Unit_Hero_Invoker then
		SmartSS(me)
	elseif ID == CDOTA_Unit_Hero_Nevermore then
		SmartKoils(me)
	end
	
end

function Key(msg,code)
	if client.chat or client.console or client.loading then return end
	if msg == KEY_DOWN then
		if code == config.Active then
			activ = not activ
		elseif code == config.GlobalKey then
			combo = not combo
		end
	elseif msg == LBUTTON_DOWN then
		if IsMouseOnButton(xx,yy,24,24) then
			activ = (not activ)
		elseif IsMouseOnButton(xx*shft, yy-18*shft,24,24) then
			draw = (not draw)
		end
	end
end

function Kill(lsblock,me,ability,damage,adamage,range,target)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell.dmgType)
		local Range = GetRange(Spell.castRange,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local Channel = me:IsChanneling()
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not hero[hand] then
					hero[hand] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[hand].visible = false hero[hand].entity = v hero[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[hand].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					hero[hand].text = " "..DmgF
					hero[hand].color = GetColor(DmgF)
					if activ and not Channel then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell.manacost,DmgS) then								
							if target == 1 then
								KSCastSpell(Spell,v,me,lsblock)	break
							elseif target == 2 then
								KSCastSpell(Spell,v.position,me,lsblock) break
							elseif target == 3 then
								KSCastSpell(Spell,nil,me,nil) break
							end
						end
					end
				elseif hero[hand].visible then
					hero[hand].visible = false
				end
			end
		end
	end
end

function SmartKill(lsblock,me,ability,damage,adamage,range,target,id)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetSmartDmg(Spell.level,me,damage,id)
		local DmgT = GetDmgType(Spell.dmgType)
		local Range = GetRange(Spell.castRange,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local Channel = me:IsChanneling()
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not hero[hand] then
					hero[hand] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[hand].visible = false hero[hand].entity = v hero[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[hand].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					hero[hand].text = " "..DmgF
					hero[hand].color = GetColor(DmgF)
					if activ and not Channel then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell.manacost,DmgS) then								
							if target == 1 then
								KSCastSpell(Spell,v,me,lsblock)	break
							elseif target == 2 then
								KSCastSpell(Spell,v.position,me,lsblock) break
							elseif target == 3 then
								KSCastSpell(Spell,nil,me,nil) break
							end
						end
					end
				elseif hero[hand].visible then
					hero[hand].visible = false
				end
			end
		end
	end
end

function ComplexKill(lsblock,me,ability,damage,adamage,range,target,id)
	local Spell = me:GetAbility(ability)
	local Level = Spell.level
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell.dmgType)
		local Range = GetRange(Spell.castRange,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local Channel = me:IsChanneling()
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not hero[hand] then
					hero[hand] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[hand].visible = false hero[hand].entity = v hero[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[hand].visible = draw
					local DmgM = ComplexGetDmg(Level,me,v,Dmg,id)
					local DmgS = math.floor(v:DamageTaken(DmgM,DmgT,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					hero[hand].text = " "..DmgF
					hero[hand].color = GetColor(DmgF)
					if activ and not Channel then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell.manacost,DmgS) then								
							if target == 1 then
								KSCastSpell(Spell,v,me,lsblock)	break
							elseif target == 2 then
								KSCastSpell(Spell,v.position,me,lsblock) break
							elseif target == 3 then
								KSCastSpell(Spell,nil,me,nil) break
							end
						end
					end
				elseif hero[hand].visible then
					hero[hand].visible = false
				end
			end
		end
	end
end

function KillGlobal(me,ability,damage,adamage,target,comp)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	local count = {}
	if Spell.level > 0 then	
		local refresh = me:FindItem("item_refresher")
		local refresher = refresh and refresh:CanBeCasted() and me.mana > Spell.manacost*2 + refresh.manacost
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell.dmgType)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000		
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do				
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not heroG[hand] then
					heroG[hand] = drawMgr:CreateText(20*shft,-58*shft, 0xFF99FF99, "",F14) heroG[hand].visible = false heroG[hand].entity = v heroG[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					heroG[hand].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))	
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen + MorphMustDie(v,CastPoint))
					if refresher then
						heroG[hand].text = "("..DmgF-DmgS..")"
					else
						heroG[hand].text = " "..DmgF
					end					
					if DmgF < 0 and KSCanDie(v,me,Spell.manacost,DmgS) then
						if not note[hand] then
							note[hand] = true
							GenerateSideMessage(v.name,Spell.name)
						end
						if activ and not me:IsChanneling() then
							if config.AutoGlobalSpells or combo then
								if target == 1 then
									KSCastSpell(Spell,v,me,true)
									combo = false break
								elseif target == 2 then
									KSCastSpell(me:GetAbility(4),v.position,me,false)
									combo = false break
								elseif target == 3 then
									KSCastSpell(Spell,nil,me,nil)
									me:SafeCastAbility(Spell)
									combo = false break
								end
							else
								if v.meepoIllusion == nil then
									table.insert(count,v)
								end
							end
						end
					elseif note[hand] then
						note[hand] = false
					end						
				elseif heroG[hand].visible then
					heroG[hand].visible = false
				end
			end
		end
	end
	if #count >= config.MinTarget4AutoKill then
		if target == 1 then
			KSCastSpell(Spell,count[1],me,true)
		elseif target == 2 then
			KSCastSpell(me:GetAbility(4),count[1].position,me,nil)
		elseif target == 3 then
			KSCastSpell(Spell,nil,me,nil)						
		end
	end
	
end

function KillPrediction(me,ability,damage,cast,project)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell.dmgType)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local Channel = me:IsChanneling()
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not hero[hand] then
					hero[hand] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[hand].visible = false hero[hand].entity = v hero[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[hand].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DmgT,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen + MorphMustDie(v,CastPoint))
					hero[hand].text = " "..DmgF
					hero[hand].color = GetColor(DmgF)
					if activ and not Channel then
						if DmgF < 0 and KSCanDie(v,me,Spell.manacost,DmgS) then
							local move = v.movespeed local pos = v.position	local distance = GetDistance2D(v,me)
							if v.activity == LuaEntityNPC.ACTIVITY_MOVE and v:CanMove() then																		
								local range = Vector(pos.x + move * (distance/(project * math.sqrt(1 - math.pow(move/project,2))) + cast) * math.cos(v.rotR), pos.y + move * (distance/(project * math.sqrt(1 - math.pow(move/project,2))) + cast) * math.sin(v.rotR), pos.z)
								if GetDistance2D(me,range) < Spell.castRange + 25 then	
									 KSCastSpell(Spell,range,me,nil) break
								end
							elseif distance < Spell.castRange + 25 then
								local range1 = Vector(pos.x + move * 0.05 * math.cos(v.rotR), pos.y + move* 0.05 * math.sin(v.rotR), pos.z)									
								KSCastSpell(Spell,range1,me,nil) break
							end
						end
					end
				elseif hero[hand].visible then
					hero[hand].visible = false
				end
			end
		end
	end	
end

function KillMines(me,ability,damage,adamage,comp,id)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	local count = {}
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local DmgT = GetDmgType(Spell.dmgType)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local Channel = me:IsChanneling()
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})		
		local mines = entityList:GetEntities(function (v) return v.classId == CDOTA_NPC_TechiesMines and v.alive and v.maxHealth == 200 end)
		for z,x in ipairs(mines) do if not mine[x.handle] then mine[x.handle] = Dmg end end
		for i,v in ipairs(enemies) do				
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not heroG[hand] then
					heroG[hand] = drawMgr:CreateText(20*shft,-58*shft, 0xFF99FF99, "",F14) heroG[hand].visible = false heroG[hand].entity = v heroG[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then					
					local DmgS = 0
					local DmgF = 0					
					local exploit = {}
					for z,x in ipairs(mines) do 
						if GetDistance2D(x,v) < 425 then
							DmgS = DmgS + mine[x.handle]							
							exploit[#exploit+1] = x
							DmgF = v.health - math.floor(v:DamageTaken(DmgS,DmgT,me))
							if DmgF < 0 then
								if not note[hand] then
									note[hand] = true
									GenerateSideMessage(v.name,Spell.name)
								end
								if activ and (AutoGlobal or combo) then
									for a,s in ipairs(exploit) do
										s:CastAbility(s:GetAbility(1))										
									end
								elseif v.meepoIllusion == nil then
									table.insert(count,exploit)
								end
								break
							elseif note[hand] then
								note[hand] = false
							end	
						end 
					end
					heroG[hand].text = " "..DmgF
					heroG[hand].color = GetColor(DmgF)
					heroG[hand].visible = draw
				elseif heroG[hand].visible then
					heroG[hand].visible = false
				end
			end
		end
		if #count >= GlobalCount then
			for z,x in ipairs(count) do
				for a,s in ipairs(x) do
					if s.alive then
						s:CastAbility(s:GetAbility(1))
					end
				end
			end
		end
		combo = false
	end
end

function KillLina(lsblock,me,ability,damage,adamage,range,target)
	local Spell = me:GetAbility(ability)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local Dmg = GetDmg(Spell.level,me,damage,adamage)
		local Range = GetRange(Spell.castRange,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local Channel = me:IsChanneling()
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not hero[hand] then
					hero[hand] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[hand].visible = false hero[hand].entity = v hero[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive then
					hero[hand].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DAMAGE_PURE,me,true))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					hero[hand].text = " "..DmgF
					hero[hand].color = GetColor(DmgF)
					if activ then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell.manacost,DmgS) then
							KSCastSpell(Spell,v,me,lsblock)	break
						end
					end
				elseif hero[hand].visible then
					hero[hand].visible = false
				end
			end
		end
	end
end

function RikiKill(lsblock,me,ability,damage,range,target)
	local Spell = me:GetAbility(ability)
	local E_ = me:GetAbility(3)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 and E_.level > 0 and SleepCheck("riki")then
		local Dmg1 = damage[Spell.level]
		local bs = {0.5,0.75,1,1.25}
		local Dmg2 = bs[E_.level]*me.agilityTotal+me.dmgMin+me.dmgBonus
		local Range = GetRange(Spell.castRange,range)
		local CastPoint = Spell:FindCastPoint() + client.latency/1000
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team})
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 and not v:IsIllusion() then
				local hand = v.handle
				if not hero[hand] then
					hero[hand] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[hand].visible = false hero[hand].entity = v hero[hand].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[hand].visible = draw
					local DmgM = math.floor(v:DamageTaken(Dmg1,DAMAGE_MAGC,me))
					local DmgS = math.floor(v:DamageTaken(Dmg2,DAMAGE_PHYS,me))
					local DmgF = math.floor(v.health - DmgS - DmgM + CastPoint*v.healthRegen+MorphMustDie(v,CastPoint))
					hero[hand].text = " "..DmgF
					hero[hand].color = GetColor(DmgF)
					if not Spell.abilityPhase and activ and not me:IsChanneling() and me:CanAttack() then
						if DmgF < 0 and GetDistance2D(me,v) < Range and KSCanDie(v,me,Spell.manacost,DmgS+DmgM) then
							KSCastSpell(Spell,v,me,lsblock) Sleep(500,"riki") break
						end
					end
				elseif hero[hand].visible then
					hero[hand].visible = false
				end
			end
		end
	end
end

function SmartKoils(me)
	local Spell = me:GetAbility(3)
	local Spell2 = me:GetAbility(2)
	local Spell3 = me:GetAbility(1)
	local Dmg = {75,150,225,300}
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Spell.level > 0 then
		local DmgS = Dmg[Spell.level]
		local Phase = Spell.abilityPhase and Spell2.abilityPhase and Spell3.abilityPhase
		--local DmgS2 = Dmg[Spell.level]*2
		--local DmgS3 = Dmg[Spell.level]*3
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),illusion=false})			
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 then
				if not hero[v.handle] then
					hero[v.handle] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then
					hero[v.handle].visible = draw
					local DmgF = math.floor(v.health - v:DamageTaken(DmgS,DAMAGE_MAGC,me))
					hero[v.handle].text = " "..DmgF
					hero[v.handle].color = GetColor(DmgF)
					if activ and not me:IsChanneling() then
						if DmgF < 0 and GetDistance2D(me,v) < 1000 and KSCanDie(v,me,Spell.manacost,DmgS) and not Phase then
							local distance = GetDistance2D(me,SFrange(v,me))
							if distance < 900 and distance > 550 then
								KSCastSpellSF(Spell,v,me) break
							elseif distance < 550 and distance > 270 then
								KSCastSpellSF(Spell2,v,me) break
							elseif distance < 300 then	
								KSCastSpellSF(Spell3,v,me) break
							end
						end
					end
				else
					hero[v.handle].visible = false
				end
			end
		end
	end
end

function SFrange(ent,me)
	if ent.activity == LuaEntityNPC.ACTIVITY_MOVE and ent:CanMove() then
		local turn = TurnRate(ent.position,me)/1000
		return Vector(ent.position.x + ent.movespeed * (0.67+turn) * math.cos(ent.rotR), ent.position.y + ent.movespeed* (0.67+turn) * math.sin(ent.rotR), ent.position.z)
	else
		return ent.position
	end
end

function TurnRate(pos,me)
	local angel = ((((math.atan2(pos.y-me.position.y,pos.x-me.position.x) - me.rotR + math.pi) % (2 * math.pi)) - math.pi) % (2 * math.pi)) * 180 / math.pi
	if angel > 180 then 
		return ((360 - angel)/2)
	else
		return (angel/2)
	end
end

function SmartSS(me)
	local Spell = me:FindSpell("invoker_sun_strike")
	local Exort = me:GetAbility(3)
	icon.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
	if Exort.level > 0 then
		local SSDmg = {100,162,225,287,350,412,475}
		local Dmg = SSDmg[Exort.level]
		local CastPoint = 1.7 + client.latency/1000
		local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = 5-me.team,illusion=false})			
		for i,v in ipairs(enemies) do
			if v.healthbarOffset ~= -1 then
				if not hero[v.handle] then
					hero[v.handle] = drawMgr:CreateText(20*shft,-45*shft, 0xFFFFFF99, "",F14) hero[v.handle].visible = false hero[v.handle].entity = v hero[v.handle].entityPosition = Vector(0,0,v.healthbarOffset)
				end
				if v.visible and v.alive and v.health > 0 then					
					hero[v.handle].visible = draw
					local DmgS = math.floor(v:DamageTaken(Dmg,DAMAGE_PURE,me))
					local DmgF = math.floor(v.health - DmgS + CastPoint*v.healthRegen + MorphMustDie(v,CastPoint))
					hero[v.handle].text = " "..DmgF	
					hero[v.handle].color = GetColor(DmgF)
					if DmgF < 0 and KSCanDie(v,me,175,DmgS) then
						if not note[v.handle] then
							note[v.handle] = true
							GenerateSideMessage(v.name,Spell.name)
						end
						if activ and (AutoGlobal or combo) then
							if v:IsStunned() then
								local stun = FindStunModifier(v)
								if stun and stun > 1.7 then
									if NearCount(v,DmgF,Dmg,enemies,me.team) then
										KSCastSpell(Spell,Vector(v.position.x,v.position.y,v.position.z),me,nil) break
									end
								end
							elseif v.activity == LuaEntityNPC.ACTIVITY_MOVE and v:CanMove() then	
								if NearCount(v,DmgF,Dmg,enemies,me.team) then
									KSCastSpell(Spell,Vector(v.position.x + v.movespeed * 1.75 * math.cos(v.rotR), v.position.y + v.movespeed* 1.75 * math.sin(v.rotR), v.position.z),me,nil) break
								end
							else
								if NearCount(v,DmgF,Dmg,enemies,me.team) then	
									KSCastSpell(Spell,Vector(v.position.x + v.movespeed * 0.05 * math.cos(v.rotR), v.position.y + v.movespeed* 0.05 * math.sin(v.rotR), v.position.z),me,nil) break
								end
							end
							combo = false							
						end
					else
						note[v.handle] = nil
					end
				else
					hero[v.handle].visible = false
				end
			end
		end		
	end
end

function NearCount(v,DmgF,Dmg,table,teams)
	local count = 0
	for z,x in ipairs(table) do
		if v.alive and v.visible then
			if GetDistance2D(x,v) < 175 then
				count = count + 1
			end
		end
	end
	for z,x in ipairs(entityList:GetEntities({classId=CDOTA_BaseNPC_Creep_Lane,team=5-teams,alive=true})) do
		if GetDistance2D(x,v) < 175 then
			count = count + 1
		end
	end
	if count == 1 or DmgF + Dmg*(count-2)/(count-1) < 0 then
		return true
	end
	return false
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

function GetColor(c)
	if c < 0 then
		return 0x99FFFF99
	end
	return 0xFFFFFF99
end	

function GetDmg(lvl,me,tab1,tab2)
	local baseDmg = tab1[lvl]
	if not tab2 then 
		return baseDmg
	elseif me:AghanimState() then
		return tab2[lvl]
	end
	return baseDmg		
end

function GetSmartDmg(lvl,me,tab1,id)
	local baseDmg = tab1[lvl]
	if id == CDOTA_Unit_Hero_Alchemist then
		local stun = me:FindModifier("modifier_alchemist_unstable_concoction")
		if stun then
			if stun.elapsedTime < 4.8 then 
				return math.floor(stun.elapsedTime*baseDmg)
			end
			return math.floor(4.8*baseDmg)
		end
		return 0
	elseif id == CDOTA_Unit_Hero_Morphling then
		local agi = math.floor(me.agilityTotal)
		local dmg = agi/math.floor(me.strengthTotal)
		if dmg > 1.5 then 
			return math.floor(0.5*lvl*agi+ baseDmg)
		elseif dmg < 0.5 then 
			return math.floor(0.25*agi + baseDmg)
		elseif (dmg >= 0.5 and dmg <= 1.5) then 
			return math.floor(0.25+((dmg-0.5)*(0.5*lvl-0.25))*agi+baseDmg)
		end			
	elseif id == CDOTA_Unit_Hero_Visage then
		local soul = me:FindModifier("modifier_visage_soul_assumption")
		if soul then
			return 20 + 65 * soul.stacks
		end
		return 20
	elseif id == CDOTA_Unit_Hero_Undying then
		local count = entityList:GetEntities(function (v) return ((v.type == LuaEntity.TYPE_CREEP and v.classId ~= 292 and not v.ancient) or v.classId == CDOTA_Unit_Undying_Zombie or v.classId == CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId == CDOTA_Unit_Hero_Beastmaster_Hawk or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit or v.courier or v.hero) and v.alive and v.visible and v.health > 0 and GetDistance2D(v,me) < 1300 end)
		local num = #count-2
		local bonus = {18,22,26,30}
		if num < baseDmg then
			return num * bonus[lvl]
		else
			return baseDmg * bonus[lvl]
		end
	end
end

function ComplexGetDmg(lvl,me,ent,damage,id)
	if id == CDOTA_Unit_Hero_AntiMage then
		return  math.floor((ent.maxMana - ent.mana) * damage)
	elseif id == CDOTA_Unit_Hero_DoomBringer then
		local lvldeath = {{lvlM = 6, dmg = 125}, {lvlM = 5, dmg = 175}, {lvlM = 4, dmg = 225}, {lvlM = 3, dmg = 275}}
		return math.floor((ent.level == 25 or ent.level % lvldeath[lvl].lvlM == 0) and (ent.maxHealth * 0.20 + lvldeath[lvl].dmg) or (lvldeath[lvl].dmg))	
	elseif id == CDOTA_Unit_Hero_Mirana then
		if GetDistance2D(ent,me) < 200 then
			return damage*1.75
		end
		return damage
	elseif id == CDOTA_Unit_Hero_Necrolyte then
		return  math.floor((ent.maxHealth - ent.health) * damage)		
	elseif id == CDOTA_Unit_Hero_Nyx_Assassin then
		local tempBurn =  damage * math.floor(ent.intellectTotal)
		if ent.mana < tempBurn then
			return ent.mana
		end
		return tempBurn
	elseif id == CDOTA_Unit_Hero_Obsidian_Destroyer then
		if me.intellectTotal > ent.intellectTotal then			
			return (math.floor(me.intellectTotal) - math.floor(ent.intellectTotal))*damage
		end
		return 0
	elseif id == CDOTA_Unit_Hero_Elder_Titan then
		local pasDmg = {1.12,1.19,1.25,1.25}
		local pas = me:GetAbility(3).level
		if pas ~= 0 then
			if not ent:FindModifier("modifier_elder_titan_natural_order") then
				return pasDmg[pas]*damage
			end
			return damage
		end
		return damage	
	elseif id == CDOTA_Unit_Hero_Shadow_Demon then	
		local actDmg = {1, 2, 4, 8, 16}
		local poison = ent:FindModifier("modifier_shadow_demon_shadow_poison")
		if poison then
			local Mod = poison.stacks
			if Mod ~= 0 and Mod < 6 then 
				return (actDmg[Mod]) * damage
			elseif Mod > 5 then 
				return (damage*16) + ((Mod-5)*50)					
			end
		end
		return 0
	elseif id == CDOTA_Unit_Hero_Legion_Commander then
		local bonusCreep = {14,16,18,20}
		local bonusHero = {20,35,50,65}
		local heroDmg = #entityList:GetEntities(function (v) return v.type == LuaEntity.TYPE_HERO and v.alive and v.team ~= me.team and v.visible and v.health > 0 and GetDistance2D(ent,v) < 330 end)*bonusHero[lvl]
		local creepDmg = #entityList:GetEntities(function (v) return ((v.type == LuaEntity.TYPE_CREEP and v.classId ~= 292 and not v.ancient) or v.classId == CDOTA_Unit_VisageFamiliar or v.classId == CDOTA_Unit_Undying_Zombie or v.classId == CDOTA_Unit_SpiritBear or v.classId == CDOTA_Unit_Broodmother_Spiderling or v.classId == CDOTA_Unit_Hero_Beastmaster_Boar or v.classId == CDOTA_Unit_Hero_Beastmaster_Hawk or v.classId == CDOTA_BaseNPC_Invoker_Forged_Spirit) and v.team ~= me.team and v.alive and v.visible and v.health > 0 and GetDistance2D(ent,v) < 350 end)*bonusCreep[lvl]
		return  math.floor(damage + heroDmg + creepDmg)
	elseif id == CDOTA_Unit_Hero_Zuus then	
		local hp = {.05,.07,.09,.11}
		local static = me:GetAbility(3).level
		if static > 0 and GetDistance2D(me,ent) < 1000 then 
			damage = damage + ((hp[static]) * ent.health)
		end
		return damage				
	end
end

function GetRange(skill,range)
	if range then
		return range
	end
	return skill + 50
end

function GetDmgType(skill)
	if skill == LuaEntityAbility.DAMAGE_TYPE_MAGICAL then
		return DAMAGE_MAGC	
	elseif skill == LuaEntityAbility.DAMAGE_TYPE_PURE then
		return DAMAGE_PURE
	elseif skill == LuaEntityAbility.DAMAGE_TYPE_PHYSICAL then
		return DAMAGE_PHYS
	else
		return DAMAGE_PHYS
	end
end		

function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx > x and mx <= x + w and my > y and my <= y + h
end

function GenerateSideMessage(heroName,spellName)
	local test = sideMessage:CreateMessage(200,60)
	test:AddElement(drawMgr:CreateRect(10,10,72,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/"..heroName:gsub("npc_dota_hero_",""))))
	test:AddElement(drawMgr:CreateRect(85,16,62,31,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/other/arrow_usual")))
	test:AddElement(drawMgr:CreateRect(150,10,40,40,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/spellicons/"..spellName)))
end

function KSCastSpell(spell,target,me,lsblock)
	if spell and spell:CanBeCasted() and me:CanCast() and not (target and lsblock == true and target:IsLinkensProtected()) then
		local prev = SelectUnit(me)
		if not target then
			entityList:GetMyPlayer():UseAbility(spell)
		else
			entityList:GetMyPlayer():UseAbility(spell,target)
		end
		SelectBack(prev)
	end
end

function KSCastSpellSF(spell,target,me)
	if spell and spell:CanBeCasted() and me:CanCast() then
		local prev = SelectUnit(me)
		entityList:GetMyPlayer():Attack(target)
		entityList:GetMyPlayer():UseAbility(spell)
		SelectBack(prev)
	end
end

function KSCanDie(hero,me,skill,dmgs)
	if hero:CanDie() then
		if me:IsMagicDmgImmune() then
			return true	
		elseif NotDieFromSpell(skill,hero,me) and not hero:DoesHaveModifier("modifier_nyx_assassin_spiked_carapace") and NotDieFromBM(hero,me,dmgs) then
			return true
		end
	end
	return false
end

function NotDieFromSpell(skill,hero,me)
	if me:DoesHaveModifier("modifier_pugna_nether_ward_aura") then
		if me.health < me:DamageTaken((skill*1.75), DAMAGE_MAGC, hero) then
			return false
		end		
	end
	return true
end

function NotDieFromBM(hero,me,dmg)
	if hero:DoesHaveModifier("modifier_item_blade_mail_reflect") and me.health < me:DamageTaken(dmg, DAMAGE_PURE, hero) then
		return false
	end
	return true
end

function MorphMustDie(target,value)
	if target.classId == CDOTA_Unit_Hero_Morphling then
		local gain = target:GetAbility(3)
		local hp = {38,76,114,190}
		if gain and gain.level > 0 then
			if target:DoesHaveModifier("modifier_morphling_morph_agi") and target.strength > 1 then
				return value*(0 - hp[gain.level] + 1)
			elseif target:DoesHaveModifier("modifier_morphling_morph_str") and target.agility > 1 then
				return value*hp[gain.level]
			end
		end
	end
	return 0
end

function KillStealer(hero)
	local hId = hero.classId
	if hId == CDOTA_Unit_Hero_AncientApparition or hId == CDOTA_Unit_Hero_Batrider or hId == CDOTA_Unit_Hero_Razor or hId == CDOTA_Unit_Hero_Beastmaster or hId == CDOTA_Unit_Hero_Brewmaster or hId == CDOTA_Unit_Hero_Bristleback or hId == CDOTA_Unit_Hero_ChaosKnight or hId == CDOTA_Unit_Hero_Clinkz or hId == CDOTA_Unit_Hero_DarkSeer or hId == CDOTA_Unit_Hero_Dazzle or hId == CDOTA_Unit_Hero_Disruptor or hId == CDOTA_Unit_Hero_DrowRanger or hId == CDOTA_Unit_Hero_EmberSpirit or hId == CDOTA_Unit_Hero_Enchantress or hId == CDOTA_Unit_Hero_Enigma or hId == CDOTA_Unit_Hero_Gyrocopter or hId == CDOTA_Unit_Hero_Huskar or hId == CDOTA_Unit_Hero_Jakiro or hId == CDOTA_Unit_Hero_Juggernaut or hId == CDOTA_Unit_Hero_KeeperOfTheLight or hId == CDOTA_Unit_Hero_Kunkka or hId == CDOTA_Unit_Hero_LoneDruid or hId == CDOTA_Unit_Hero_Lycan or hId == CDOTA_Unit_Hero_Medusa or hId == CDOTA_Unit_Hero_Meepo or hId == CDOTA_Unit_Hero_Phoenix or hId == CDOTA_Unit_Hero_Pudge or hId == CDOTA_Unit_Hero_Pugna or hId == CDOTA_Unit_Hero_SandKing or hId == CDOTA_Unit_Hero_Silencer or hId == CDOTA_Unit_Hero_Skywrath_Mage or hId == CDOTA_Unit_Hero_Slardar or hId == CDOTA_Unit_Hero_Slark or hId == CDOTA_Unit_Hero_SpiritBreaker or hId == CDOTA_Unit_Hero_StormSpirit or hId == CDOTA_Unit_Hero_TemplarAssassin or hId == CDOTA_Unit_Hero_Terrorblade or hId == CDOTA_Unit_Hero_Tiny or hId == CDOTA_Unit_Hero_Treant or hId == CDOTA_Unit_Hero_TrollWarlord or hId == CDOTA_Unit_Hero_Ursa or hId == CDOTA_Unit_Hero_Venomancer or hId == CDOTA_Unit_Hero_Viper or hId == CDOTA_Unit_Hero_Warlock or hId == CDOTA_Unit_Hero_Weaver or hId == CDOTA_Unit_Hero_Wisp or hId == CDOTA_Unit_Hero_WitchDoctor or hId == CDOTA_Unit_Hero_AbyssalUnderlord or hId == CDOTA_Unit_Hero_Omniknight or hId == CDOTA_Unit_Hero_Ogre_Magi or hId == CDOTA_Unit_Hero_Naga_Siren or hId == CDOTA_Unit_Hero_Bloodseeker or hId == CDOTA_Unit_Hero_FacelessVoid then 
		return true
	end
	return false
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if KillStealer(me) then 
			script:Disable() 
		else
			play = true
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Tick)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(Load)
		end
	end
end

function Close()
	rect.visible = false
	icon.visible = false
	dmgCalc.visible = false
	hero = {} heroG = {}
	myhero = nil
	combo = false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
