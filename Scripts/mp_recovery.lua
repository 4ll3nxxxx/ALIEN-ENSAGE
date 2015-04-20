--<<Drop all hp/mp adding items and also use acrane, bottle, etc. Also has keys for dropping tranquil boots and blink.>>
--===By Blaxpirit===--

require("libs.Utils")
require("libs.ScriptConfig")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "B", config.TYPE_HOTKEY)
config:SetParameter("DropBlink", "J", config.TYPE_HOTKEY)
config:SetParameter("DropTranquils", "N", config.TYPE_HOTKEY)
config:Load()

local play = false local active = false local activated = false local disableAutoAttack = false local treads_laststate
local treads_changed local BugedItems = {"item_ancient_janggo","item_veil_of_discord"}

function Key(msg,code)
	if client.chat or client.console or client.loading then return end
	local me = entityList:GetMyHero()
	local mp = entityList:GetMyPlayer()
	if msg == KEY_DOWN then
		if active then
			if code == config.Hotkey then
				DropItems(me,mp)
			end
		end
		if code == config.DropBlink then
			DropBlink(me,mp)
		end
	end	
	if msg == KEY_UP then
		if code == toggleKey then
			PickUpItems(me,mp)
		end
		if code == dropblink then
			PickUpItems(me,mp)
		end
		if code == config.DropTranquils then
			DropTranquils(me,mp)
			PickUpTranquils(me,mp)
		end
	end
end
	
function Tick( tick )
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
	if not SleepCheck() then
		active = false 
	else
		active = true
	end
	if not SleepCheck("auto_attack") and disableAutoAttack then
		client:ExecuteCmd("dota_player_units_auto_attack_after_spell 0")
		disableAutoAttack = false
	elseif SleepCheck("auto_attack") and not disableAutoAttack then
		client:ExecuteCmd("dota_player_units_auto_attack_after_spell 1")
		disableAutoAttack = true
	end
end	
	
function DropItems(me,mp)
	if me.alive and (me.mana ~= me.maxMana or me.health ~= me.maxHealth) then
		Sleep(3250,"auto_attack")
		mp:HoldPosition()
		local aboots = me:FindItem("item_arcane_boots")
		local soulring = me:FindItem("item_soul_ring")
		local lowstick = me:FindItem("item_magic_stick")
		local gradestick = me:FindItem("item_magic_wand")
		local mek = me:FindItem("item_mekansm")
		local bottle = me:FindItem("item_bottle")
		local invis = me:IsInvisible()
		local chanel = me:IsChanneling()
		local cuseitems = me:CanUseItems()
		
		for i,v in ipairs(me.items) do	
			local bonusStrength = v:GetSpecialData("bonus_strength")
			local bonusMana = v:GetSpecialData("bonus_mana")
			local bonusHealth = v:GetSpecialData("bonus_health")
			local bonusIntellect = v:GetSpecialData("bonus_intellect")
			local bonusAll = v:GetSpecialData("bonus_all_stats")
			local treads = me:FindItem("item_power_treads")
			
			if not chanel then
				if v.name == "item_power_treads" then
					if treads.bootsState == 0 and me.health ~= me.maxHealth then
						me:SetPowerTreadsState(2)
						treads_laststate = 0
						treads_changed = true
					elseif treads.bootsState == 1 and me.mana ~= me.maxMana then
						me:SetPowerTreadsState(2)
						treads_laststate = 1
						treads_changed = true
					elseif treads.bootsState == 2 and not treads_changed then
						treads_laststate = 2
					end
				end
				if v.name == "item_refresher" and me.mana ~= me.maxMana then
					mp:DropItem(v,me.position)
				end
				for j,k in ipairs(BugedItems) do
					if v.name == BugedItems[j] then
						mp:DropItem(v,me.position)
					end
				end
				if bonusHealth or bonusMana or bonusStrength or bonusIntellect or bonusAll then
					if aboots and aboots.cd == 0 and me.mana ~= me.maxMana then
						if v.name ~= "item_arcane_boots" then
							mp:DropItem(v,me.position)
						end
					elseif mek and mek.cd == 0 and me.health ~= me.maxHealth then
						if v.name ~= "item_mekansm" then
							mp:DropItem(v,me.position)
						end
					elseif gradestick and gradestick.charges > 0 and gradestick.cd == 0 then
						if bottle and bottle.charges > 0 and bottle.cd == 0 then 
							mp:DropItem(v,me.position)
						else 
							if v.name ~= "item_magic_wand" then
								mp:DropItem(v,me.position)
							end
						end
					else 
						mp:DropItem(v,me.position)
					end
				end
			end
		end
		if cuseitems and not (invis and chanel) then
			if aboots and aboots.cd == 0 and me.mana ~= me.maxMana and aboots:CanBeCasted() then
				me:SafeCastItem("item_arcane_boots")
				Sleep(1000)
			elseif mek and mek.cd == 0 and me.health ~= me.maxHealth and mek:CanBeCasted() then
				me:SafeCastItem("item_mekansm")
				Sleep(1000)
			elseif soulring and soulring.cd == 0 and me.mana ~= me.maxMana then
				me:SafeCastItem("item_soul_ring")
				Sleep(50)
			elseif bottle and bottle.charges > 0 and bottle.cd == 0 and not me:FindModifier("modifier_bottle_regeneration") then
				me:SafeCastItem("item_bottle")
				Sleep(3000)
			elseif lowstick and lowstick.charges > 0 and lowstick.cd == 0 then
				me:SafeCastItem("item_magic_stick")
				Sleep(50)
			elseif gradestick and gradestick.charges > 0 and gradestick.cd == 0 then
				me:SafeCastItem("item_magic_wand")
				Sleep(1000)
			end
		end
	end	
end

function DropBlink(me,mp)	
	local blink  = me:FindItem("item_blink")
	local chanel = me:IsChanneling()
	if me.alive and not chanel then
		Sleep(1000,"auto_attack")
		mp:HoldPosition()
		if blink then
			mp:DropItem(blink,me.position)
		end
	end
end

function DropTranquils(me,mp)	
	local tranquilboots = me:FindItem("item_tranquil_boots")
	local chanel = me:IsChanneling()
	if me.alive and not chanel then
		if tranquilboots then 
			mp:DropItem(tranquilboots,me.position)
			mp:Attack(client.mousePosition)
		end
	end
end

function PickUpItems(me,mp)
	local DroppedItems = entityList:FindEntities({type=LuaEntity.TYPE_ITEM_PHYSICAL})
	local treads = me:FindItem("item_power_treads")
	for i,v in ipairs(DroppedItems) do
		local IH = v.itemHolds
		if IH.owner == me and GetDistance2D(me,v) <= 250 then
			mp:TakeItem(v)
		end
	end
	if treads and treads.bootsState ~= treads_laststate then
		if treads_laststate == 0 then
			me:SetPowerTreadsState(0)
		elseif treads_laststate == 1 then
			me:SetPowerTreadsState(1)
		end
	end
	treads_changed = false
	mp:Move(client.mousePosition)
	Sleep(500,"auto_attack")
end

function PickUpTranquils(me,mp)
	local DroppedItems = entityList:FindEntities({type=LuaEntity.TYPE_ITEM_PHYSICAL})
	for i,v in ipairs(DroppedItems) do
		local IH = v.itemHolds
		if IH.name == "item_tranquil_boots" and GetDistance2D(me,v) <= 500 then
			mp:TakeItem(v)
			mp:Move(client.mousePosition,true)
		end
	end
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
