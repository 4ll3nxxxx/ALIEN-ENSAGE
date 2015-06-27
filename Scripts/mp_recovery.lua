require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "9", config.TYPE_HOTKEY)
config:Load()

play, active, disableAutoAttack, treads_changed, treads_laststate = false, false, false 

function Key(msg,code)
	if client.chat or client.console or not PlayingGame() or client.paused then return end
	local me, mp = entityList:GetMyHero(), entityList:GetMyPlayer()
	if msg == KEY_DOWN then
		if active then
			if code == config.Hotkey then
				DropItems(me,mp)
			end
		end
	end	
	if msg == KEY_UP then
		if code == config.Hotkey then
			PickUpItems(me,mp)
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
	if me.alive and (me.mana ~= me.maxMana or me.health ~= me.maxHealth) then Sleep(1000,"auto_attack") mp:HoldPosition()
		local chanel, invis, cuseitems = me:IsChanneling(), me:IsInvisible(), me:CanUseItems()
		local arcane, soulring = me:FindItem("item_arcane_boots"), me:FindItem("item_soul_ring")
		local lowstick, gradestick = me:FindItem("item_magic_stick"), me:FindItem("item_magic_wand")
		local mek, bottle = me:FindItem("item_mekansm"), me:FindItem("item_bottle")
		for i,v in ipairs(me.items) do	
			local bonusStrength, bonusMana = v:GetSpecialData("bonus_strength"), v:GetSpecialData("bonus_mana")
			local bonusHealth, bonusIntellect = v:GetSpecialData("bonus_health"), v:GetSpecialData("bonus_intellect")
			local bonusAll, treads = v:GetSpecialData("bonus_all_stats"), me:FindItem("item_power_treads")
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
				local BugedItems = {"item_ancient_janggo","item_veil_of_discord"}
				for j,k in ipairs(BugedItems) do
					if v.name == BugedItems[j] then
						mp:DropItem(v,me.position)
					end
				end
				if bonusHealth or bonusMana or bonusStrength or bonusIntellect or bonusAll then
					if arcane and arcane.cd == 0 and me.mana ~= me.maxMana then
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
		if cuseitems and not (invis and chanel) then Sleep(1000)
			if arcane and arcane.cd == 0 and me.mana ~= me.maxMana and arcane:CanBeCasted() then
				me:SafeCastItem("item_arcane_boots")
			elseif mek and mek.cd == 0 and me.health ~= me.maxHealth and mek:CanBeCasted() then
				me:SafeCastItem("item_mekansm")
			elseif soulring and soulring.cd == 0 and me.mana ~= me.maxMana then
				me:SafeCastItem("item_soul_ring")
			elseif bottle and bottle.charges > 0 and bottle.cd == 0 and not me:FindModifier("modifier_bottle_regeneration") then
				me:SafeCastItem("item_bottle")
			elseif lowstick and lowstick.charges > 0 and lowstick.cd == 0 then
				me:SafeCastItem("item_magic_stick")
			elseif gradestick and gradestick.charges > 0 and gradestick.cd == 0 then
				me:SafeCastItem("item_magic_wand")
			end
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
	active, disableAutoAttack = false, false
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
