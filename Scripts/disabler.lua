--<<Disabler of blinkers and initiators>>
--===By Blaxpirit===--

require("libs.Utils")
require("libs.ScriptConfig")
require("libs.Initiators")
require("libs.DisableSpells")

local config = ScriptConfig.new()
config:SetParameter("Active", "113", config.TYPE_HOTKEY)
config:SetParameter("indent", 255)
config:Load()

local active = false local play = false local activated = 0 local hero = {} local icon = {} local sleepTick = nil

local monitor = client.screenSize.x/1600
local F11 = drawMgr:CreateFont("F11","Tahoma",11*monitor,550*monitor) 
local statusText = drawMgr:CreateText(290*monitor,42*monitor,0xFF3399FF,"Disabler: Blink",F11) statusText.visible = false
 
function Key(msg,code)
	if IsKeyDown(config.Active) and not client.chat then
		active = not active
		if active then
			statusText.text = "Disabler: All"
		else
			statusText.text = "Disabler: Blink"
		end
	end

	for i = 1,5 do
		if IsMouseOnButton(config.indent*monitor-3+i*27,11*monitor-1,20,20) then
			if msg == LBUTTON_DOWN and hero[i] == nil then
				hero[i] = i
			elseif msg == LBUTTON_DOWN and hero[i] ~= nil then
				hero[i] = nil
			end
		end
	end
end
 
function IsMouseOnButton(x,y,h,w)
	local mx = client.mouseScreenPosition.x
	local my = client.mouseScreenPosition.y
	return mx > x and mx <= x + w and my > y and my <= y + h
end
 
function Tick( tick )
	if not PlayingGame() or sleepTick and sleepTick > tick then return end
	me = entityList:GetMyHero()
	
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team=me:GetEnemyTeam(),illusion=false})
	for i,v in ipairs(enemies) do
		target = v
		local IV  = v:IsInvul()
		local MI  = v:IsMagicImmune()
		local ST  = v:IsStunned()
		local HEX = v:IsHexed()
		local SI  = v:IsSilenced()
		local DA  = v:IsDisarmed()
		local invis = me:IsInvisible()
		local chanel = me:IsChanneling()
		local items = me:CanUseItems()
		local blink = v:FindItem("item_blink")
		local forcestaff = v:FindItem("item_force_staff")
		local dark_pact = v:FindModifier("modifier_slark_dark_pact") or v:FindModifier("modifier_slark_dark_pact_pulses")
	
		if me.alive and v.alive and v.visible then
			if items and not (IV or MI or invis or chanel or dark_pact) then
				if (blink and blink.cd > 11) or (forcestaff and forcestaff.cd > 18.6) then
					UseMedalliontarget()
					UseRodtarget()
					LinkensSelf()
				elseif active then
					UseMedalliontarget()
					UseRodtarget()
					LinkensSelf()
				elseif Initiation[v.name] then
					local Spell = v:FindSpell(Initiation[v.name].Spell)
					if Spell and Spell.level ~= 0 and Spell.cd > Spell:GetCooldown(Spell.level) - 1.6 then
						UseMedalliontarget()
						UseRodtarget()
						LinkensSelf()
					end
				end
			end
		end

		if me.alive and v.alive and v.visible and not hero[i] then
			if items and not (IV or MI or ST or HEX or SI or DA or invis or chanel or dark_pact) then
				if (blink and blink.cd > 11) or (forcestaff and forcestaff.cd > 18.6) then
					UseHex()
					UseSheepStickTarget()
					UseImmediateStun()
					UseAbyssaltarget()
					UseBatriderLasso()
					UseLegionDuel()
					UseOrchidtarget()
					UseSkysSeal()
					UsePucksRift()
					UseHeroSpell()
					UseEulScepterTarget()
					UseAstral()
					UseHalberdtarget()
					UseEtherealtarget()
				elseif active then
					UseHex()
					UseSheepStickTarget()
					UseImmediateStun()
					UseAbyssaltarget()
					UseBatriderLasso()
					UseLegionDuel()
					UseOrchidtarget()
					UseSkysSeal()
					UsePucksRift()
					UseEulScepterTarget()
					UseAstral()
					UseHalberdtarget()
				elseif Initiation[v.name] then
					local Spell = v:FindSpell(Initiation[v.name].Spell)
					if Spell and Spell.level ~= 0 and Spell.cd > Spell:GetCooldown(Spell.level) - 1.6 then
						UseHex()
						UseSheepStickTarget()
						UseImmediateStun()
						UseAbyssaltarget()
						UseBatriderLasso()
						UseOrchidtarget()
						UseSkysSeal()
						UsePucksRift()
						UseHeroSpell()
						UseEulScepterTarget()
						UseAstral()
						UseHalberdtarget()
						UseEtherealtarget()
					end
				end
			end
		end
		activated = 0

		if not icon[i] then
			icon[i] = {}
			icon[i].board = drawMgr:CreateRect(config.indent*monitor-3+i*27,11*monitor-1,20,20,0x8B008BFF)
			icon[i].back = drawMgr:CreateRect(config.indent*monitor-2+i*27,11*monitor,18,18,0x000000FF)
			icon[i].mini = drawMgr:CreateRect(config.indent*monitor-2+i*27,11*monitor,18,18,0x000000FF)
		end
		
		if not hero[i] then
			icon[i].back.textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
			icon[i].mini.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..v.name:gsub("npc_dota_hero_",""))
		else
			icon[i].mini.textureId = drawMgr:GetTextureId("NyanUI/spellicons/doom_bringer_empty1")
		end	
	end
end

-- functions for item or skill usage
    
function UseEulScepterTarget()
	if activated == 0 then
		local disable = me:FindItem("item_cyclone")
		if disable and disable:CanBeCasted() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end
   
function UseSheepStickTarget()
	if activated == 0 then
		local disable = me:FindItem("item_sheepstick")
		if disable and disable:CanBeCasted() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end
    
function UseOrchidtarget()
	if activated == 0 then
		local disable = me:FindItem("item_orchid")
		if disable and disable:CanBeCasted() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end
    
function UseAbyssaltarget()
	if activated == 0 then
		local disable = me:FindItem("item_abyssal_blade")
		if disable and disable:CanBeCasted() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1 
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end
	
function UseHalberdtarget()
	if activated == 0 then
		local disable = me:FindItem("item_heavens_halberd")
		if disable and disable:CanBeCasted() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end
	
function UseEtherealtarget()
	if activated == 0 then
		local disable = me:FindItem("item_ethereal_blade")
		if disable and disable:CanBeCasted() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UseRodtarget()
	local disable = me:FindItem("item_rod_of_atos")
	if disable and disable:CanBeCasted() then	
		if target and GetDistance2D(me,target) < disable.castRange then
			me:SafeCastAbility(disable,target)
			sleepTick = GetTick() + 100
			return
		end
	end
end

function UseMedalliontarget()
	if me.health/me.maxHealth > 0.1 then
		local disable = me:FindItem("item_medallion_of_courage")
		if disable and disable:CanBeCasted() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UseHex()
	if activated == 0 then
		local disable = nil
		local hex_lion  = me:FindSpell("lion_voodoo")
		local hex_rasta = me:FindSpell("shadow_shaman_voodoo")
		if hex_lion then
			disable = hex_lion
		elseif hex_rasta then
			disable = hex_rasta
		end
		if disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UseAstral()
	if activated == 0 then
		local disable = nil
		local astral_od = me:FindSpell("obsidian_destroyer_astral_imprisonment")
		local astral_sd = me:FindSpell("shadow_demon_disruption")
		if alstral_destr then
			disable = alstral_destr
		elseif astral_sd then
			disable = astral_sd
		end
		if disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < disable.castRange  then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function LinkensSelf()
	local disable = me:FindItem("item_sphere")
	if disable and disable:CanBeCasted() then	
		me:SafeCastAbility(disable,me)
		sleepTick = GetTick() + 100
		return
	end
end

function UseImmediateStun()
	if activated == 0 then
		local disable = nil
		local tlknz = me:FindSpell("rubick_telekinesis")
		local dtail = me:FindSpell("dragon_knight_dragon_tail")
		if tlknz then
			disable = tlknz
		elseif dtail then
			disable = dtail
		end
		if disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UseBatriderLasso()
	if activated == 0 then
		local disable = me:FindSpell("batrider_flaming_lasso")
		if disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 150 then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UseLegionDuel()
	if activated == 0 then
		local disable = me:FindSpell("legion_commander_duel")
		if disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 150 then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UseSkysSeal()
	if activated == 0 then
		local disable = me:FindSpell("skywrath_mage_ancient_seal")
		if disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < disable.castRange then
				me:SafeCastAbility(disable,target)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UsePucksRift()
	if activated == 0 then
		local disable = me:FindSpell("puck_waning_rift")
		if disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 400 then
				me:SafeCastAbility(disable)
				activated = 1
				sleepTick = GetTick() + 100
				return
			end
		end
	end
end

function UseHeroSpell()
	if activated == 0 then
		if DisableSpell[me.name] then
			local disable = me:FindSpell(DisableSpell[me.name].Spell)
			if disable and disable:CanBeCasted() and me:CanCast() then
				if target and GetDistance2D(me,target) < disable.castRange then
					me:SafeCastAbility(disable,target)
					activated = 1
					sleepTick = GetTick() + 100
					return
				end
			end
		end
	end
end

function Load()
	if PlayingGame() then
		play = true
		statusText.visible = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:RegisterEvent(EVENT_KEY,Key)
		script:UnregisterEvent(Load)
	end
end

function Close()
	statusText.visible = false
	hero = {}
	icon = {}
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