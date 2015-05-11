--<<Download texture https://mega.co.nz/#!8AZiFAbY!kMdEz0Fezz6cRzpVPrsNJTuUd4RFwHqDSI3cOV51U34 and unpack to nyanui/other>>

require("libs.ScriptConfig")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("HotKey", "32", config.TYPE_HOTKEY)
config:SetParameter("HomeKey", "D", config.TYPE_HOTKEY)
config:Load()

local play = false local myhero = nil local target = nil local sleep = {0,0}
local rate = client.screenSize.x/1600 local rec = {} local castQueue = {}
rec[1] = drawMgr:CreateRect(70*rate,26*rate,270*rate,60*rate,0xFFFFFF30,drawMgr:GetTextureId("NyanUI/other/CM_status_1")) rec[1].visible = false
rec[2] = drawMgr:CreateText(175*rate,52*rate,0xFFFFFF90,"Target :",drawMgr:CreateFont("manabarsFont","Arial",18*rate,700)) rec[2].visible = false
rec[3] = drawMgr:CreateRect(220*rate,54*rate,16*rate,16*rate,0xFFFFFF30) rec[3].visible = false

function Main(tick)
	if not PlayingGame() then return end
	local me = entityList:GetMyHero()
	local ID = me.classId if ID ~= myhero then return end

	for i=1,#castQueue,1 do
		local v = castQueue[1]
		table.remove(castQueue,1)
		local ability = v[2]
		if type(ability) == "string" then
			ability = me:FindItem(ability)
		end
		if ability and ((me:SafeCastAbility(ability,v[3],false)) or (v[4] and ability:CanBeCasted())) then
			if v[4] and ability:CanBeCasted() then
				me:CastAbility(ability,v[3],false)
			end
			sleep[1] = tick + v[1] + client.latency
			return
		end
	end
	
	local torrent = me:GetAbility(1)
	local xmarks = me:GetAbility(3)
	local ghostship = me:GetAbility(4)

	if me.team == LuaEntity.TEAM_RADIANT then
		foun = Vector(-7272,-6757,270)
	else
		foun = Vector(7200,6624,256)
	end

	if IsKeyDown(config.HomeKey) and not client.chat then
		if tick > sleep[1] and me.alive then
			local travel = me:FindItem("item_tpscroll") or me:FindItem("item_travel_boots") or me:FindItem("item_travel_boots_2")
			if xmarks and xmarks:CanBeCasted() and travel and travel:CanBeCasted() then
				table.insert(castQueue,{1000+math.ceil(xmarks:FindCastPoint()*1000),xmarks,me})
			end
			if travel and travel:CanBeCasted() then
				table.insert(castQueue,{1000+math.ceil(travel:FindCastPoint()*1000),travel,foun})
				sleep[1] = tick + 1000
			end
		end
	end

	local target = Findtarget(100)

	if target and target.alive and target.visible then
		if not rec[i] then
			rec[3].textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..target.name:gsub("npc_dota_hero_",""))
		end
	else
		rec[3].textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
	end
	
	if not IsKeyDown(config.HomeKey) and target and target.alive and GetDistance2D(me,target) <= 2000 then
		if  xmarks.name == "kunkka_x_marks_the_spot" and torrent and torrent:CanBeCasted() and xmarks.level > 0 and xmarks.abilityPhase then
			table.insert(castQueue,{1000+math.ceil(torrent:FindCastPoint()*1000),torrent,target.position})
		end
		if xmarks.name == "kunkka_return" and me:CanCast() and math.ceil(torrent.cd) ~= math.ceil(torrent:GetCooldown(torrent.cd)) then
			table.insert(castQueue,{100,xmarks})
		end
	end

	if IsKeyDown(config.HotKey) and not client.chat then
		if target and target.alive and GetDistance2D(me,target) <= 2000 and target.visible then
			if xmarks.name == "kunkka_x_marks_the_spot" and xmarks:CanBeCasted() and me:CanCast() then
				table.insert(castQueue,{1000+math.ceil(xmarks:FindCastPoint()*1000),xmarks,target})
				lastpos = target.position
			end
			if ghostship and ghostship:CanBeCasted() and me:CanCast() and xmarks.level > 0 and xmarks.abilityPhase then
				table.insert(castQueue,{1000+math.ceil(ghostship:FindCastPoint()*1000),ghostship,lastpos})
			end
			if torrent and torrent:CanBeCasted() and me:CanCast() and ghostship.level > 0 and ghostship.abilityPhase then
				table.insert(castQueue,{1000+math.ceil(torrent:FindCastPoint()*1000),torrent,lastpos})
			end
			if xmarks.name == "kunkka_return" and me:CanCast() and math.ceil(torrent.cd) ~= math.ceil(torrent:GetCooldown(torrent.cd)) then
				table.insert(castQueue,{100,xmarks})
			end
		end
	end
end

function Findtarget(source,range,includeFriendly)
	local me = entityList:GetMyHero()
	if not includeFriendly and type(range) == "boolean" then
		includeFriendly = range
	end
	if not range or type(range) == "boolean" then 
		range = source
		source = nil
	end
	local enemies 
	if includeFriendly then
		enemies = entityList:FindEntities(function (v) return v.hero and v.alive and v.health > 0 and not v:IsIllusion() and (not source or v:GetDistance2D(source) < range) and v:GetDistance2D(me) < 2000 end)
	else
		local enemyTeam = me:GetEnemyTeam()
		enemies = entityList:FindEntities(function (v) return v.hero and v.alive and v.health > 0 and not v:IsIllusion() and v.team == enemyTeam and (not source or v:GetDistance2D(source) < range) and v:GetDistance2D(me) < 2000 end)
	end
	table.sort( enemies, function (a,b) return a:GetDistance2D(client.mousePosition) < b:GetDistance2D(client.mousePosition) end )
	return enemies[1]
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Kunkka then 
			script:Disable() 
		else
			play = true
			myhero = me.classId
			rec[1].w = 90*rate + 30*0*rate + 65*rate rec[1].visible = true
			rec[2].x = 30*rate + 90*rate + 30*0*rate + 65*rate - 95*rate rec[2].visible = true
			rec[3].x = 80*rate + 90*rate + 30*0*rate + 65*rate - 50*rate rec[3].visible = true
			script:RegisterEvent(EVENT_FRAME, Main)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	myhero = nil
	target = nil
	rec[1].visible = false
	rec[2].visible = false
	rec[3].visible = false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
