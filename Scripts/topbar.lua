require("libs.Utils")
require("libs.spelltype")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("a1spell", "Q", config.TYPE_HOTKEY)
config:SetParameter("a2spell", "W", config.TYPE_HOTKEY)
config:SetParameter("a3spell", "E", config.TYPE_HOTKEY)
config:SetParameter("a4spell", "R", config.TYPE_HOTKEY)
config:SetParameter("a5spell", "D", config.TYPE_HOTKEY)
config:SetParameter("a6spell", "F", config.TYPE_HOTKEY)
config:SetParameter("queue", true, config.TYPE_BOOL)
config:Load()

if client.screenSize.x/client.screenSize.y == 1.25 or client.screenSize.x/client.screenSize.y == 4/3 then
	xx = math.ceil(client.screenSize.x*0.15234375)
	yy = math.ceil(client.screenSize.y*0.0048828125)
	ww = math.ceil(client.screenSize.x*0.04609375)
	hh = math.ceil(client.screenSize.y*0.03125)
	centwidth = math.ceil(client.screenSize.x*0.371875)
elseif client.screenSize.x/client.screenSize.y == 1.6 or client.screenSize.x/client.screenSize.y == 1.5 or client.screenSize.x/client.screenSize.y == 5/3 then
	xx = math.ceil(client.screenSize.x*0.21180555)
	yy = math.ceil(client.screenSize.y*0.00347222)
	ww = math.ceil(client.screenSize.x*0.03819444)
	hh = math.ceil(client.screenSize.y*0.02222222)
	centwidth = math.ceil(client.screenSize.x*0.31666666)
else
	xx = math.ceil(client.screenSize.x*0.23984375)
	yy = math.ceil(client.screenSize.y*0.00416666)
	ww = math.ceil(client.screenSize.x*0.034375)
	hh = math.ceil(client.screenSize.y*0.03472222)
	centwidth = math.ceil(client.screenSize.x*0.27890625)
end

play, spells, panel, heroes, selected, using = false, {}, {}, {{},{}}, false, false

function Key(msg,code)
	if client.chat or client.console or not PlayingGame() or client.paused then return end
	if msg == RBUTTON_UP then
		using = false
	end
	spells[1], spells[2], spells[3], spells[4], spells[5], spells[6] = config.a1spell, config.a2spell, config.a3spell, config.a4spell, config.a5spell, config.a6spell
	if not client.chat and (code == spells[1] or code == spells[2] or code == spells[3] or code == spells[4] or code == spells[5] or code == spells[6]) then
		for i,v in ipairs(entityList:GetMyHero().abilities) do
			if list2[v.name] and code == spells[list2[v.name].number] and v.state == LuaEntityAbility.STATE_READY then
				Skill = v
				using = true
			end
		end
	end
	if msg == RBUTTON_UP or msg == LBUTTON_UP then
		for w = 1,2 do
			for i,v in ipairs(heroes[w]) do
				if v.team == 3 then
					selftop = centwidth
				else
					selftop = 0
				end

				if IsMouseOnButton(xx+i*ww+selftop,yy,hh,ww) then

					if msg == RBUTTON_UP then
						if v.team == entityList:GetMyHero().team then
							if config.queue then
								entityList:GetMyHero():Follow(v,true)
							else
								entityList:GetMyHero():Follow(v)
							end
							if v ~= entityList:GetMyHero() then selected = true end
						else
							if config.queue then
								entityList:GetMyHero():Attack(v,true)
							else
								entityList:GetMyHero():Attack(v)
							end
						end
					end
					if msg == LBUTTON_UP and Skill and using then
						if list2[Skill.name].target == "target" then
							if config.queue then
								entityList:GetMyHero():SafeCastAbility(Skill,v,true)
							else
								entityList:GetMyHero():SafeCastAbility(Skill,v)
							end
						using = false
						elseif v.visible then
							if config.queue then
								entityList:GetMyHero():SafeCastAbility(Skill,v.position,true)
							else
								entityList:GetMyHero():SafeCastAbility(Skill,v.position)
							end
						using = false
						end
						if v ~= entityList:GetMyHero() and v.team == entityList:GetMyHero().team then selected = true end
					end
				end
			end
		end
	end
end

function Tick(tick)
	if not PlayingGame() or not SleepCheck() then return end Sleep(250)
	heroes[1], heroes[2] = entityList:GetEntities({type = LuaEntity.TYPE_HERO, team = entityList:GetMyHero().team, illusion = false}), entityList:GetEntities({type = LuaEntity.TYPE_HERO, team = entityList:GetMyHero():GetEnemyTeam(), illusion = false})
	for k = 1,2 do
		table.sort( heroes[k], function (a,b) return a.playerId < b.playerId end )
		for g,h in ipairs(heroes[k]) do
			if not panel[h.playerId] then
				if h.team == 3 then
					selftop = centwidth
				else
					selftop = 0
				end
				panel[h.playerId] = drawMgr:CreateRect(xx+g*ww+selftop,yy,ww,hh,0x5050ffff,true)
				panel[h.playerId].visible = true
			end
			if not h.visible or not h.alive then
				panel[h.playerId].color = 0x808080ff
			else
				panel[h.playerId].color = 0x5050ffff
			end
		end
	end
	if using and Skill and Skill.abilityPhase then
		using = false
	end
	if selected then
		entityList:GetMyPlayer():Select(entityList:GetMyPlayer().selection[1])
		selected = false
	end
end

function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx >= x and mx <= x + w and my >= y and my <= y + h
end


function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:RegisterEvent(EVENT_KEY,Key)
		script:UnregisterEvent(Load)
	end	
end

function Close()
	spells, panel, heroes, selected, using = {}, {}, {{},{}}, false, false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK, Load)
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
