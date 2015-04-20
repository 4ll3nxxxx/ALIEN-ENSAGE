-- Made by Staskkk.

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
config:Load()

local spells = {}
spells[1] = config.a1spell --first ability hotkey.
spells[2] = config.a2spell --second ability hotkey.
spells[3] = config.a3spell --third ability hotkey.
spells[4] = config.a4spell --fourth ability hotkey.
spells[5] = config.a5spell --fifth ability hotkey.
spells[6] = config.a6spell --sixth ability hotkey.

if client.screenSize.x/client.screenSize.y == 1.25 or client.screenSize.x/client.screenSize.y == 4/3 then
	xx = math.ceil(client.screenSize.x*0.15234375) -- x parameter of left-top corner of top bar heroes of your team.
	yy = math.ceil(client.screenSize.y*0.0048828125) -- y parameter of left-top corner of top bar heroes of your team.
	ww = math.ceil(client.screenSize.x*0.04609375)
	hh = math.ceil(client.screenSize.y*0.03125)
	centwidth = math.ceil(client.screenSize.x*0.371875) -- distance between icons of heroes of different teams.
elseif client.screenSize.x/client.screenSize.y == 1.6 or client.screenSize.x/client.screenSize.y == 1.5 or client.screenSize.x/client.screenSize.y == 5/3 then
	xx = math.ceil(client.screenSize.x*0.21180555) -- x parameter of left-top corner of top bar heroes of your team.
	yy = math.ceil(client.screenSize.y*0.00347222) -- y parameter of left-top corner of top bar heroes of your team.
	ww = math.ceil(client.screenSize.x*0.03819444)
	hh = math.ceil(client.screenSize.y*0.02222222)
	centwidth = math.ceil(client.screenSize.x*0.31666666) -- distance between icons of heroes of different teams.
else
	xx = math.ceil(client.screenSize.x*0.23984375) -- x parameter of left-top corner of top bar heroes of your team.
	yy = math.ceil(client.screenSize.y*0.00416666) -- y parameter of left-top corner of top bar heroes of your team.
	ww = math.ceil(client.screenSize.x*0.034375)
	hh = math.ceil(client.screenSize.y*0.03472222)
	centwidth = math.ceil(client.screenSize.x*0.27890625) -- distance between icons of heroes of different teams.
end

local play = false local using = false local panel = {} local heroes = {{},{}} local reg = false local selected = false local sleeptick = 0

function Key(msg,code)
	if not PlayingGame() or client.console or client.paused or not play then return end

	if msg == RBUTTON_UP then
		using = false
	end

	if not client.chat and msg == KEY_UP and code == spells[1] or code == spells[2] or code == spells[3] or code == spells[4] or code == spells[5] or code == spells[6] then
		for i,v in ipairs(sel.abilities) do
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
						if v.team == sel.team then
							if IsKeyDown(16) then
								sel:Follow(v,true)
							else
								sel:Follow(v)
							end
							if v ~= sel then selected = true end
						else
							if IsKeyDown(16) then
								sel:Attack(v,true)
							else
								sel:Attack(v)
							end
						end
					end

					if msg == LBUTTON_UP and Skill and using then
						if list2[Skill.name].target == "target" then
							if IsKeyDown(16) then
								sel:SafeCastAbility(Skill,v,true)
							else
								sel:SafeCastAbility(Skill,v)
							end
						using = false
						elseif v.visible then
							if IsKeyDown(16) then
								sel:SafeCastAbility(Skill,v.position,true)
							else
								sel:SafeCastAbility(Skill,v.position)
							end
						using = false
						end
						if v ~= sel and v.team == sel.team then selected = true end
					end
				end
			end
		end
	end
end

function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function Tick(tick)
	if not client.connected or client.loading or client.console or tick < sleeptick  or not entityList:GetMyHero() then
		return
	end
	sleeptick = tick + 200
	mp = entityList:GetMyPlayer()
	sel = mp.selection[1]
	heroes[1] = entityList:GetEntities({type = LuaEntity.TYPE_HERO, team = mp.team, illusion = false})
	heroes[2] = entityList:GetEntities({type = LuaEntity.TYPE_HERO, team = (5-mp.team), illusion = false})
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
		mp:Select(sel)
		selected = false
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else
			play = true
			reg = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:RegisterEvent(EVENT_KEY,Key)
		script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	spells = {}
	panel = {}
	heroes = {{},{}}
	using = false
	selected = false
	sleeptick = 0
	play = false
	panel = {}
	collectgarbage("collect")
	if reg then
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK, Load)
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)