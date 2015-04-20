--<<Meepo helper. Combos, Poof, forest's stack and auto go to fontaine>>
-- Made by Staskkk.

require("libs.Utils")
require("libs.stackpos")
-- Config
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("poofall", "R", config.TYPE_HOTKEY)
config:SetParameter("poofallplusself", "E", config.TYPE_HOTKEY)
config:SetParameter("pooffontain", "D", config.TYPE_HOTKEY)
config:SetParameter("junglewithshift", "F", config.TYPE_HOTKEY)
config:SetParameter("earthbind", "Q", config.TYPE_HOTKEY)
config:SetParameter("activate", "32", config.TYPE_HOTKEY)
config:SetParameter("WomboCombo", "F", config.TYPE_HOTKEY)
config:SetParameter("stopcombo", "S", config.TYPE_HOTKEY)
config:SetParameter("poofseltofirstsel", "T", config.TYPE_HOTKEY)
config:SetParameter("hpPercent", 0.50)
config:SetParameter("hpPercentR", "219", config.TYPE_HOTKEY)
config:SetParameter("hpPercentL", "221", config.TYPE_HOTKEY)
config:SetParameter("Xcord", 50)
config:SetParameter("Ycord", 30)
config:Load()

-- Config
x = config.Xcord -- x lable position
y = config.Ycord -- y lable position
hpPercent = config.hpPercent -- % when meepo go to base for heal
hotkey1 = config.poofall -- poof all meepo's to selected meepo
hotkey2 = config.poofallplusself -- poof all meepo's to selected meepo and selected meepo poof on hisself
hotkey3 = config.pooffontain -- use poof to fountain side
hotkey4 = config.junglewithshift -- Jungle with Shift
hotkey5 = config.earthbind -- all meepos using his net to catch enemy ,ur mouse cursor must be on enemy hero, it using net one by one.
hotkey6 = config.activate -- Press for script activate(one time)
hotkey7 = config.WomboCombo -- WomboCombo with blinkdagger
hotkey8 = config.stopcombo -- stop combo, working only if script activated
hotkey9 = config.hpPercentR
hotkey10 = config.hpPercentL
hotkey11 = config.poofseltofirstsel -- poof selected meepo's to first selected meepo

-- Code
local font = drawMgr:CreateFont("meepofont","Tahoma",14,500)
local text = drawMgr:CreateText(x,y,0x6CF58CFF,"Meepo script: NOT ACTIVE",font) text.visible = false
local play = false
local activated = false
local fount = {false,false,false,false,false}
local com = false
local meeponumb = {}
local ordered = {}
local sleep = {0, 0, 0, 0}

function Key(msg,code)
	if client.chat or client.console or client.loading then return end
	if msg == KEY_UP and code == hotkey6 then
		activated = not activated 
		if activated then
			text.text = "Meepo script: ACTIVE hpPercent = "..tostring(hpPercent)
		else
			local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO})
			for n,m in ipairs(meepos) do
				meeponumb[m.handle] = 0
			end
			text.text = "Meepo script: NOT ACTIVE"
		end
	end
	if activated then
		if msg == KEY_UP then
			if code == hotkey7 and not IsKeyDown(16) then
				local sel = mp.selection[1]
				local spell = sel:FindItem("item_blink")
				if sel and sel.name == "npc_dota_hero_meepo" and spell and spell:CanBeCasted() then
					poofall(sel,false)
					if not eff then
						eff = Effect(sel, "range_display")
						eff:SetVector( 1, Vector(1200,0,0) )
					end
					targ = entityList:GetMouseover()
					if dot then
						dot = nil
						collectgarbage("collect")
					end
					if targ and targ.type == LuaEntity.TYPE_HERO and targ.team ~= mp.team then
						nota = 0
							dot = Effect(targ, "urn_of_shadows_damage")
							dot:SetVector( 1, Vector(0,0,0))
					else
						nota = client.mousePosition
							dot = Effect(nota, "fire_torch")
							dot:SetVector(0, nota)
					end
					seld = sel
					dag = spell
					if sleep[2] <= GetTick() then
						sleep[2] = GetTick() + 1400
						com = true
					end
				end
			elseif code == hotkey8 and com then
				sleep[2] = 0
				sele = false
				com = false
				eff = nil
				dot = nil
				collectgarbage("collect")
				local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
				for i,v in ipairs(meepos) do
					v:Stop()
				end
			elseif code == hotkey1 or code == hotkey2 then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					poofall(sel,false)
					if code == hotkey2 and sel.health/sel.maxHealth >= hpPercent then
						local spell = sel:GetAbility(2)
						if spell and spell:CanBeCasted() then
							sel:CastAbility(spell,sel)
						end
					end
				end
			elseif code == hotkey11 then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					poofall(sel,true)
					if code == hotkey11 then
						local spell = sel:GetAbility(2)
						if spell and spell:CanBeCasted() then
							sel:CastAbility(spell,sel)
						end
					end
				end
			elseif code == hotkey3 then
				local sel = mp.selection[1]
				if sel and sel.name == "npc_dota_hero_meepo" then
					local spell = sel:GetAbility(2)
					if spell and spell:CanBeCasted() then
						sel:CastAbility(spell,foun)
					end
				end
			elseif code == hotkey4 and IsKeyDown(16) then
				local sel = mp.selection[1]
				if not meeponumb[sel.handle] or meeponumb[sel.handle] == 0 then
					if sel then
						local range = 100000
						for n,m in ipairs(routes) do 
							local rang = GetDistance2D(sel.position,m[1])
							local empty = true
							local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
							for o,p in ipairs(meepos) do
								if meeponumb[p.handle] and meeponumb[p.handle] == n then
									empty = false
								end
							end
							if m.team == mp.team and range > rang and empty then
								range = rang
								meeponumb[sel.handle] = n
							end
						end
						sel:Move(routes[meeponumb[sel.handle]][3])
					end
				else
					meeponumb[sel.handle] = 0
				end
			elseif code == hotkey9 then
				hpPercent = hpPercent-0.05
				text.text = "Meepo script: ACTIVE hpPercent = "..tostring(hpPercent)
			elseif code == hotkey10 then
				hpPercent = hpPercent+0.05
				text.text = "Meepo script: ACTIVE hpPercent = "..tostring(hpPercent)
			end
		elseif msg == KEY_DOWN and code == hotkey5 and target and target.visible and ((sleep[3] <= GetTick() and target == targe) or (target ~= targe)) then
			targe = target
			local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
			local throw = true
			for i,v in ipairs(meepos) do 
				local spell = v:GetAbility(1)
				if throw and spell and spell:CanBeCasted() and GetDistance2D(target.position,v.position) <= spell.castRange then
					v:CastAbility(spell,Vector(target.position.x+220*math.cos(target.rotR), target.position.y+220*math.sin(target.rotR), target.position.z))
					v:Attack(target,true)
					sleep[3] = GetTick() + 1500
					throw = false
				end
			end
		end
	end
end

function poofall(sel,selecti)
	if selecti then
		meeposs = mp.selection
		local retu = false
		for i,v in ipairs(meeposs) do
			if v.name ~= "npc_dota_hero_meepo" then
				retu = true
			end
		end
		if not meeposs or retu then
			return
		end
	else
		meeposs = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
	end
	for i,v in ipairs(meeposs) do
		if v ~= sel and v.health/v.maxHealth >= hpPercent then
			local spell = v:GetAbility(2)
			if spell and spell:CanBeCasted() and not spell.abilityPhase then
				v:CastAbility(spell,sel)
				if not selecti then
					n = 0
					sele = true
					sleep[4] = GetTick() + 1500
				end
			end
		end
	end
end

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero() if not me then return end
	if com and tick > sleep[2] then
		com = false
		eff = nil
		dot = nil
		collectgarbage("collect")
		if nota ~= 0 then
			seld:CastAbility(dag, nota)
		else 
			seld:CastAbility(dag, targ.position)
		end
		n = 0
		spell = seld:GetAbility(1)
		if spell and spell:CanBeCasted() then
			if nota ~= 0 then
				seld:CastAbility(spell, nota,true)
			else
				seld:CastAbility(spell, targ.position,true)
			end
		end
		spell = seld:GetAbility(2)
		if spell and spell:CanBeCasted() then
			if nota ~= 0 then
				seld:CastAbility(spell, nota,true)
			else
				seld:CastAbility(spell, targ.position,true)
			end
		end
	end
	if sele and tick > sleep[4] then
	local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
	local sel = mp.selection[1]
		if n == 0 then
			for i,v in ipairs(meepos) do
				if v ~= sel then
					mp:SelectAdd(v)
				end
			end
		elseif v ~= sel then
			mp:SelectAdd(meepos[n])
		end
		sele = false
	end
	if tick <= sleep[1] then return end
	sleep[1] = tick + 200
		
	mp = entityList:GetMyPlayer()
	if mp.team == LuaEntity.TEAM_RADIANT then
		foun = Vector(-7272,-6757,270)
	else
		foun = Vector(7200,6624,256)
	end

	local ent = entityList:GetMouseover()
	if ent and ent.type == LuaEntity.TYPE_HERO and ent.team ~= mp.team then
		target = ent
	end
	if activated then
		local meepos = entityList:FindEntities({ type = LuaEntity.TYPE_MEEPO, alive = true})
		for i,v in ipairs(meepos) do
			if meeponumb[v.handle] and meeponumb[v.handle] ~= 0 and not ordered[v.handle] and isPosEqual(v.position,routes[meeponumb[v.handle]][3],100) and math.floor(client.gameTime%60) == math.floor(52.48-540/v.movespeed) then
				ordered[v.handle] = true
				v:Move(routes[meeponumb[v.handle]][1])
				v:Move(routes[meeponumb[v.handle]][2],true)
				v:Move(routes[meeponumb[v.handle]][3],true)
			elseif ordered[v.handle] and math.floor(client.gameTime%60) < 51 then
				ordered[v.handle] = false
			end
			if not fount[i] and v.health/v.maxHealth < hpPercent then
				mp:Unselect(v)
					v:Move(foun)
				fount[i] = true
			end
			if fount[i] and v.health == v.maxHealth then
				if GetDistance2D(v.position,foun) <= 1200 then
					local sel = mp.selection[1]
					if sel and sel.name == "npc_dota_hero_meepo" then
						local spell = v:GetAbility(2)
						if spell and spell:CanBeCasted() then
							v:CastAbility(spell,sel)
							sleep[4] = tick + 1500
							n = i
							sele = true
							fount[i] = false
						end
					end
				else
					fount[i] = false
				end
			end
		end
	end
end

function isPosEqual(v1, v2, d)
	return (v1-v2).length <= d
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Meepo then 
			script:Disable() 
		else
			play = true
			text.visible = true
			script:RegisterEvent(EVENT_TICK,Tick)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	text.visible = false
	activated = false
	fount = {false,false,false,false,false}
	com = false
	ordered = {}
	meeponumb = {}
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
