require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Active", "113", config.TYPE_HOTKEY)
config:SetParameter("indent", 255)
config:Load()

monitor = client.screenSize.x/1600
statusText = drawMgr:CreateText(290*monitor,42*monitor,0xFFFF00FF,"Disabler: Blink",drawMgr:CreateFont("text","Arial",11*monitor,550*monitor)) statusText.visible = false

active, play, activated, hero, icon, sleepTick, target = false, false, 0, {}, {}, nil, nil

DisableSpell = {
	npc_dota_hero_crystal_maiden = {Spell = "crystal_maiden_frostbite"},
	npc_dota_hero_drow_ranger = {Spell = "drow_ranger_silence"},
	npc_dota_hero_morphling = {Spell = "morphling_adaptive_strike"},
	npc_dota_hero_sandking = {Spell = "sandking_burrowstrike"},
	npc_dota_hero_storm_spirit = {Spell = "storm_spirit_electric_vortex"},
	npc_dota_hero_sven = {Spell = "sven_storm_bolt"},
	npc_dota_hero_tiny = {Spell = "tiny_avalanche"},
	npc_dota_hero_vengefulspirit = {Spell = "vengefulspirit_magic_missile"},
	npc_dota_hero_riki = {Spell = "riki_smoke_screen"},
	npc_dota_hero_enigma = {Spell = "enigma_malefice"},
	npc_dota_hero_death_prophet = {Spell = "death_prophet_silence"},
	npc_dota_hero_night_stalker = {Spell = "night_stalker_crippling_fear"},
	npc_dota_hero_doom_bringer = {Spell = "doom_bringer_doom"},
	npc_dota_hero_oracle = {Spell = "oracle_fates_edict"},
	npc_dota_hero_zuus = {Spell = "zuus_lightning_bolt"},
	--[[npc_dota_hero_chaos_knight = {Spell = "chaos_knight_chaos_bolt"},]]
	--[[npc_dota_hero_ogre_magi = {Spell = "ogre_magi_fireblast"},]]
	--[[npc_dota_hero_tusk = {Spell = "death_prophet_silence"},]]
	--[[npc_dota_hero_batrider = {Spell = "batrider_flaming_lasso"},]]
	--[[npc_dota_hero_skeleton_king = {Spell = "death_prophet_silence"},]]
}

Initiation = {
	npc_dota_hero_faceless_void = {Spell = "faceless_void_time_walk"},
	npc_dota_hero_shredder = {Spell = "shredder_timber_chain"},
	npc_dota_hero_phoenix = {Spell = "phoenix_icarus_dive"},
	npc_dota_hero_antimage = {Spell = "antimage_blink"},
	npc_dota_hero_legion_commander = {Spell = "legion_commander_duel"},
	npc_dota_hero_mirana = {Spell = "mirana_leap"},
	npc_dota_hero_phantom_lancer = {Spell = "phantom_lancer_doppelwalk"},
	npc_dota_hero_terrorblade = {Spell = "terrorblade_sunder"},
	npc_dota_hero_huskar = {Spell = "huskar_life_break"},
	npc_dota_hero_rattletrap = {Spell = "rattletrap_hookshot"},
	npc_dota_hero_earth_spirit = {Spell = "earth_spirit_rolling_boulder"},
	npc_dota_hero_chaos_knight = {Spell = "chaos_knight_reality_rift"},
	npc_dota_hero_morphling = {Spell = "morphling_waveform"},
	npc_dota_hero_vengefulspirit = {Spell = "vengefulspirit_nether_swap"},
	npc_dota_hero_phantom_assassin = {Spell = "phantom_assassin_phantom_strike"},
	npc_dota_hero_riki = {Spell = "riki_blink_strike"},
	npc_dota_hero_weaver = {Spell = "weaver_time_lapse"},
	npc_dota_hero_sandking = {Spell = "sandking_epicenter"},
	npc_dota_hero_slark = {Spell = "slark_pounce"},
	npc_dota_hero_crystal_maiden = {Spell = "crystal_maiden_freezing_field"},
	npc_dota_hero_pudge = {Spell = "pudge_dismember"},
	npc_dota_hero_Bane = {Spell = "bane_fiends_grip"},
	npc_dota_hero_Enigma = {Spell = "enigma_black_hole"},
	npc_dota_hero_witch_doctor = {Spell = "witch_doctor_death_ward"},
	npc_dota_hero_queenofpain = {Spell = "queenofpain_blink"},
	npc_dota_hero_storm_spirit = {Spell = "storm_spirit_ball_lightning"},
	npc_dota_hero_puck = {Spell = "puck_illusory_orb"},
	npc_dota_hero_magnataur = {Spell = "magnataur_skewer"},
	npc_dota_hero_ember_spirit = {Spell = "ember_spirit_fire_remnant"},
	--[[npc_dota_hero_furion = {Spell = "furion_teleportation"},]]
	--[[npc_dota_hero_pugna = {Spell = "pugna_life_drain"},]]
}

function Key(msg,code)
	if IsKeyDown(config.Active) and not client.chat then
		active = not active
		if active then
			statusText.text = "Disabler: Blink or attack order"
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
	
	local enemies = entityList:GetEntities({type = LuaEntity.TYPE_HERO, team = me:GetEnemyTeam(), illusion = false})

	for i = 1, #enemies do

		target = enemies[i]

		local IV, MI, ST, HEX, SI, DA  = target:IsInvul(), target:IsMagicImmune(), target:IsStunned(), target:IsHexed(), target:IsSilenced(), target:IsDisarmed()
		local invis, chanel, items = me:IsInvisible(), me:IsChanneling(), me:CanUseItems()
		local blink, forcestaff = target:FindItem("item_blink"), target:FindItem("item_force_staff")
		local dark_pact = target:FindModifier("modifier_slark_dark_pact") or target:FindModifier("modifier_slark_dark_pact_pulses")
	
		if me.alive and target.alive and target.visible then
			if items and not (IV or MI or invis or chanel or dark_pact) then
				if (blink and blink.cd > 11) or (forcestaff and forcestaff.cd > 18.6) then
					UseMedalliontarget() UseRodtarget()
				elseif active and entityList:GetMyPlayer().orderId == Player.ORDER_ATTACKENTITY and entityList:GetMyPlayer().target then
					UseMedalliontarget() UseRodtarget()
				elseif Initiation[target.name] then
					local Spell = target:FindSpell(Initiation[target.name].Spell)
					if Spell and Spell.level ~= 0 and Spell.cd > Spell:GetCooldown(Spell.level) - 1.6 then
						UseMedalliontarget() UseRodtarget()
					end
				end
			end
		end

		if me.alive and target.alive and target.visible and not hero[i] then
			if items and not (IV or MI or ST or HEX or SI or DA or invis or chanel or dark_pact) then
				if (blink and blink.cd > 11) or (forcestaff and forcestaff.cd > 18.6) then
					UseHex() UseSheepStickTarget() UseImmediateStun() UseAbyssaltarget() UseBatriderLasso() UseLegionDuel() UseOrchidtarget() UseSkysSeal()
					UsePucksRift() UseHeroSpell() UseEulScepterTarget() UseAstral() UseHalberdtarget() UseEtherealtarget() EmberSpirit()
				elseif active and entityList:GetMyPlayer().orderId == Player.ORDER_ATTACKENTITY and entityList:GetMyPlayer().target or (blink and blink.cd > 11) or (forcestaff and forcestaff.cd > 18.6) then
					UseHex() UseSheepStickTarget() UseImmediateStun() UseAbyssaltarget() UseBatriderLasso() UseLegionDuel() UseOrchidtarget() UseSkysSeal()
					UsePucksRift() UseEulScepterTarget() UseAstral() UseHalberdtarget() EmberSpirit()
				elseif Initiation[target.name] then
					local Spell = target:FindSpell(Initiation[target.name].Spell)
					if Spell and Spell.level ~= 0 and Spell.cd > Spell:GetCooldown(Spell.level) - 1.6 then
						UseHex() UseSheepStickTarget() UseImmediateStun() UseAbyssaltarget() UseBatriderLasso() UseOrchidtarget() UseSkysSeal() UsePucksRift()
						UseHeroSpell() UseEulScepterTarget() UseAstral() UseHalberdtarget() UseEtherealtarget() EmberSpirit()
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
			icon[i].mini.textureId = drawMgr:GetTextureId("NyanUI/miniheroes/"..target.name:gsub("npc_dota_hero_",""))
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
		end
	end
end

function UseMedalliontarget()
	local disable = me:FindItem("item_medallion_of_courage") or me:FindItem("item_solar_crest")
	if disable and disable:CanBeCasted() then
		if target and GetDistance2D(me,target) < disable.castRange then
			me:SafeCastAbility(disable,target)
			sleepTick = GetTick() + 100
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
			end
		end
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
			end
		end
	end
end

function EmberSpirit()
	if activated == 0 then
		local remnant = entityList:GetEntities(function (target) return target.npc and target.name == "npc_dota_ember_spirit_remnant" and target.alive end)
		local disable, activate = me:FindSpell("ember_spirit_searing_chains"), me:FindSpell("ember_spirit_activate_fire_remnant")
		if #remnant == 1 and activate and activate:CanBeCasted() and me:CanCast() then
			me:SafeCastAbility(activate,me.position)
			activated = 1
			sleepTick = GetTick() + 1000
		elseif #remnant == 0 and disable and disable:CanBeCasted() and me:CanCast() then
			if target and GetDistance2D(me,target) < 400 then
				me:SafeCastAbility(disable)
				activated = 1
				sleepTick = GetTick() + 100
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
	if play then
		active, statusText.visible, hero, icon, activated, sleepTick, target = false, false, {}, {}, 0, nil, nil
		collectgarbage("collect")
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)