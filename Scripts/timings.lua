--<<Shows you timings of stuns, silences, immunes and useful modifiers>>
-- Made by Staskkk.

-- Config
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Fontsize", 20)
config:SetParameter("Imagesize", 20)
config:SetParameter("Distancefontimage", 15)
config:SetParameter("Verticaldistance", 14)
config:SetParameter("Antiheight", 150)
config:Load()

play, timers, entities, wisp, modifs, sleeptick = false, {}, {}, {}, {}, 0

font = drawMgr:CreateFont("timersfont","Arial",config.Fontsize,500)
wispTime = drawMgr:CreateText(0,0,-1,"",font) wispTime.visible = false
wispTexture = drawMgr:CreateRect(0,0,config.Imagesize,config.Imagesize,0x000000FF,drawMgr:GetTextureId("NyanUI/modifiers/wisp_relocate_return")) wispTexture.visible = false

-- Code
modifnames = {
{
"modifier_morphling_waveform",
"modifier_naga_siren_mirror_image",
"modifier_brewmaster_primal_split_delay",
"modifier_chaos_knight_phantasm",
"modifier_omninight_guardian_angel",
"modifier_phantomlancer_dopplewalk_phase",
"modifier_phoenix_sun_ray",
"modifier_sandking_burrowstrike",
"modifier_slark_dark_pact",
"modifier_slark_pounce",
"modifier_storm_spirit_ball_lightning",
"modifier_templar_assassin_refraction_absorb",
"modifier_terrorblade_metamorphosis_transform",
"modifier_item_satanic_unholy",
"modifier_manta_phase",
"modifier_item_forcestaff_active",
"modifier_item_invisibility_edge_windwalk",
"modifier_item_blade_mail_reflect",
"modifier_mirana_leap",
"modifier_item_sphere_target",
"modifier_alchemist_unstable_concoction",
"modifier_kill",
"modifier_morphling_replicate_timer",
"modifier_illusion",
"modifier_cold_feet",
"modifier_dazzle_shallow_grave",
"modifier_enigma_malefice",
"modifier_invoker_cold_snap",
"modifier_keeper_of_the_light_illuminate",
"modifier_keeper_of_the_light_mana_leak",
"modifier_puck_coiled",
"modifier_chen_test_of_faith_teleport",
"modifier_crystal_maiden_frostbite",
"modifier_ember_spirit_searing_chains",
"modifier_ember_spirit_fire_remnant",
"modifier_huskar_life_break_charge",
"modifier_elder_titan_earth_splitter_scepter",
"modifier_kunkka_x_marks_the_spot",
"modifier_meepo_earthbind",
"modifier_black_king_bar_immune",
"modifier_omniknight_repel",
"modifier_abaddon_borrowed_time",
"modifier_keeper_of_the_light_recall",
"modifier_pugna_decrepify",
"modifier_ghost_state",
"modifier_item_ethereal_blade_ethereal",
"modifier_juggernaut_blade_fury",
"modifier_juggernaut_omnislash",
"modifier_nyx_assassin_spiked_carapace",
"modifier_medusa_stone_gaze",
"modifier_slark_shadow_dance",
"modifier_windrunner_windrun",
"modifier_puck_phase_shift",
"modifier_heavens_halberd_debuff",
"modifier_tinker_laser_blind",
"modifier_invoker_deafening_blast_disarm",
"modifier_keeper_of_the_light_blinding_light",
"modifier_life_stealer_rage",
"modifier_earth_spirit_magnetize",
"modifier_bloodseeker_rupture",
"modifier_winter_wyvern_cold_embrace",
"modifier_item_lotus_orb_active",
"modifier_item_glimmer_cape_fade",
"modifier_item_silver_edge_windwalk"
},
{
"modifier_lone_druid_true_form_transform",
"modifier_lone_druid_druid_form_transform",
"modifier_lycan_shapeshift_transform",
"modifier_crystal_maiden_freezing_field",
"modifier_nevermore_requiem_invis_break",
"modifier_zuus_arc_lightning",
"modifier_drowranger_wave_of_silence_knockback",
"modifier_ancientapparition_coldfeet_freeze",
"modifier_axe_berserkers_call",
"modifier_bane_nightmare",
"modifier_bane_fiends_grip",
"modifier_batrider_flaming_lasso",
"modifier_beastmaster_prima_roar_push",
"modifier_dark_seer_vacuum",
"modifier_earth_spirit_boulder_smash",
"modifier_earth_spirit_geomagnetic_grip",
"modifier_earthspirit_petrify",
"modifier_earthshaker_fissure_stun",
"modifier_elder_titan_echo_stomp",
"modifier_faceless_void_timelock_freeze",
"modifier_invoker_cold_snap_freeze",
"modifier_invoker_deafening_blast_knockback",
"modifier_invoker_tornado",
"modifier_jakiro_ice_path_stun",
"modifier_kunkka_torrent",
"modifier_legion_commander_duel",
"modifier_lion_impale",
"modifier_lion_voodoo",
"modifier_lone_druid_spirit_bear_entangle_effect",
"modifier_magnataur_skewer_impact",
"modifier_magnataur_skewer_movement",
"modifier_medusa_stone_gaze_stone",
"modifier_morphling_adaptive_strike",
"modifier_naga_siren_ensnare",
"modifier_naga_siren_song_of_the_siren_aura",
"modifier_teleporting",
"modifier_necrolyte_reapers_scythe",
"modifier_nyx_assassin_impale",
"modifier_obsidian_destroyer_astral_imprisonment_prison",
"modifier_pudge_dismember",
"modifier_sandking_impale",
"modifier_shadow_shaman_voodoo",
"modifier_shadow_shaman_shackles",
"modifier_knockback",
"modifier_blinding_light_knockback",
"modifier_storm_spirit_electric_vortex_pull",
"modifier_techies_stasis_trap_stunned",
"modifier_tidehunter_ravage",
"modifier_tiny_avalanche_stun",
"modifier_tiny_toss",
"modifier_treant_overgrowth",
"modifier_tusk_walrus_punch_air_time",
"modifier_windrunner_shackle_shot",
"modifier_brewmaster_storm_cyclone",
"modifier_eul_cyclone",
"modifier_sheepstick_debuff",
"modifier_rattletrap_cog_push",
"modifier_shadow_demon_disruption",
"modifier_dark_troll_warlord_ensnare",
"modifier_stunned",
"modifier_winter_wyvern_winters_curse",
"modifier_winter_wyvern_winters_curse_aura"
},
{
"modifier_lycan_shapeshift",
"modifier_sniper_headshot_slow",
"modifier_silence",
"modifier_doom_bringer_doom",
"modifier_earth_spirit_boulder_smash_silence",
"modifier_night_stalker_crippling_fear",
"modifier_silencer_global_silence",
"modifier_skywrath_mage_ancient_seal",
"modifier_orchid_malevolence_debuff"
}
}

function regi(v,z)
	if not timers[v.handle] then
		timers[v.handle] = {}
	end
	if not timers[v.handle][z] then
		timers[v.handle][z] = {}
		timers[v.handle][z].time = drawMgr:CreateText(0,(config.Imagesize+config.Verticaldistance )*z+-1*config.Antiheight,-1,"",font)
		timers[v.handle][z].texture = drawMgr:CreateRect(-1*(config.Imagesize+config.Distancefontimage),(config.Imagesize+config.Verticaldistance )*z+-1*config.Antiheight,config.Imagesize,config.Imagesize,0x000000FF)
		timers[v.handle][z].time.entity = v
		timers[v.handle][z].texture.entity = v
		timers[v.handle][z].time.entityPosition = Vector(0,0,v.healthbarOffset)
		timers[v.handle][z].texture.entityPosition = Vector(0,0,v.healthbarOffset)
	end
end

function prepare(v,z,modif)
	if string.sub(modif.texture,1,5) ~= "item_" then
		timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..modif.texture)
	else
		local tname = string.sub(modif.name,10)
		if tname == "item_sphere_target" then
			timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/items/"..string.sub(modif.texture,6))
		elseif tname == "item_silver_edge_windwalk" then
			timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/items/silver_edge")
		elseif tname == "item_glimmer_cape_fade" then
			timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/items/glimmer_cape")
		elseif tname == "item_lotus_orb_active" then
			timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/items/lotus_orb")
		elseif string.sub(modif.texture,1,17) == "item_necronomicon" then
			timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/modifiers/necronomicon_archer_aura")
		elseif tname ~= "eul_cyclone" and tname ~= "manta_phase" then
			timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/modifiers/"..tname)
		else
			timers[v.handle][z].texture.textureId = drawMgr:GetTextureId("NyanUI/modifiers/"..string.sub(modif.texture,6))
		end
	end
end

function findmodifs(entity,handle,name)
	local array = entity.modifiers
	if array then
		local m = 1
		local sizea = #array+1
		while m ~= sizea and (handle ~= array[m].handle or name ~= array[m].name) do
			m = m+1
		end
		if m ~= sizea then
			return true
		end
	end
	return false
end

function removes(r,t)
	local rem = 1
	while rem <= #modifs and (r == rem or modifs[rem][2] ~= t[2] or modifs[rem][5] ~= t[5]) do
		rem = rem+1
	end
	if rem <= #modifs and entityList:GetEntity(modifs[rem][2]) and findmodifs(modifs[rem][1],modifs[rem][3],modifs[rem][7]) then
		prepare(modifs[rem][1],modifs[rem][5],modifs[rem][4])
	end
	table.remove(modifs,r)
end

function Modifadd(v,modif)
	if not PlayingGame() then return end
	if ((v.type == LuaEntity.TYPE_HERO and not v.illusion and modif.name ~= "modifier_morphling_replicate_timer") or v.type == LuaEntity.TYPE_MEEPO) or ((v.type == LuaEntity.TYPE_NPC or v.type == LuaEntity.TYPE_CREEP or v.type == LuaEntity.TYPE_HERO) and (modif.name == "modifier_enigma_black_hole_thinker" or modif.name == "modifier_disruptor_static_storm_thinker" or modif.name == "modifier_riki_smoke_screen_thinker" or modif.name == "modifier_faceless_void_chronosphere_selfbuff" or modif.name == "modifier_phoenix_sun" or modif.name == "modifier_shadow_shaman_serpent_ward" or modif.name == "modifier_skywrath_mage_mystic_flare" or modif.name == "modifier_rattletrap_cog" or modif.name == "modifier_alchemist_acid_spray_thinker" or modif.name == "modifier_brewmaster_primal_split_duration" or modif.name == "modifier_dark_seer_wall_of_replica" or modif.name == "modifier_disruptor_kinetic_field_thinker" or modif.name == "modifier_ember_spirit_fire_remnant_thinker" or modif.name == "modifier_demonic_conversion" or modif.name == "modifier_invoker_sun_strike" or modif.name == "modifier_juggernaut_healing_ward_aura" or modif.name == "modifier_keeper_of_the_light_spirit_form_illuminate" or modif.name == "modifier_kunkka_torrent_thinker" or modif.name == "modifier_lina_light_strike_array" or modif.name == "modifier_pugna_nether_ward" or modif.name == "modifier_storm_spirit_static_remnant_thinker" or modif.name == "modifier_tinker_march_thinker" or modif.name == "modifier_weaver_swarm" or modif.name == "modifier_zuus_lightningbolt_vision_thinker" or modif.name == "modifier_zuus_thundergodswrath_vision_thinker" or modif.name == "modifier_bloodseeker_bloodbath_thinker" or modif.name == "modifier_kill" or (modif.name == "modifier_morphling_replicate_timer" and v.illusion) or modif.name == "modifier_illusion")) then
		z = 0
		stun = false
		while not stun and z ~= 3 do
			z = z+1
			x = 0
			while not stun and x ~= #modifnames[z] do
				x = x+1
				if (v.type == LuaEntity.TYPE_NPC or v.type == LuaEntity.TYPE_CREEP or modif.name == modifnames[z][x]) then
					regi(v,z)
					table.insert(modifs,{v,v.handle,modif.handle,modif,z,modif.remainingTime,modif.name})
					table.sort(modifs,function (a,b) return a[6] > b[6] end)
					local rem = 1
					while rem <= #modifs and (modifs[rem][2] ~= v.handle or modifs[rem][5] ~= z) do
						rem = rem+1
					end
					if modifs[rem][3] == modif.handle then
						prepare(v,z,modif)
					end
					stun = true
				end
			end
		end
	end
end

function Tick(tick)
    if not PlayingGame() then return end
	local stop = {}
	for r,t in ipairs(modifs) do
		if not stop[t[2]] then
			stop[t[2]] = {}
		end
		if entityList:GetEntity(t[2]) then
			if not stop[t[2]][t[5]] then
				if timers[t[2]][t[5]].time then
					timers[t[2]][t[5]].time.visible = true
					timers[t[2]][t[5]].texture.visible = true
					if findmodifs(t[1],t[3],t[7]) then
						if t[4].name ~= "modifier_enigma_black_hole_thinker" and t[4].name ~= "modifier_cold_feet" then
							if t[4].name ~= "modifier_alchemist_unstable_concoction" then
								if t[4].name ~= "modifier_kunkka_torrent_thinker" then
									if t[4].name ~= "modifier_lina_light_strike_array" then
										if t[4].name ~= "modifier_nevermore_requiem_invis_break" then
											if t[4].name ~= "modifier_storm_spirit_static_remnant_thinker" then
												timers[t[2]][t[5]].time.text = tostring(math.floor(t[4].remainingTime*10)/10)
												t[6] = t[4].remainingTime
												if t[4].texture == "wisp_relocate" then
													if math.floor(t[4].remainingTime*10) == 1 then
														wisp.pos = t[1].position
													elseif t[4].remainingTime == 0 then
														count = 121
														pretime,delay = math.modf(client.totalGameTime*10)
														pretime = pretime+1
													end
												end
											else
												timers[t[2]][t[5]].time.text = tostring(math.floor((12.05-t[4].elapsedTime)*10)/10)
											end
										else
											timers[t[2]][t[5]].time.text = tostring(math.floor((1.74-t[4].elapsedTime)*10)/10)
										end
									else
										timers[t[2]][t[5]].time.text = tostring(math.floor((0.51-t[4].elapsedTime)*10)/10)
									end
								else
									timers[t[2]][t[5]].time.text = tostring(math.floor((1.61-t[4].elapsedTime)*10)/10)
								end
							else
								local alchemisttime = 5.55-t[4].elapsedTime
								timers[t[2]][t[5]].time.text = tostring(math.floor((alchemisttime)*10)/10)
								t[6] = alchemisttime
							end
						else
							timers[t[2]][t[5]].time.text = tostring(math.floor((4.09-t[4].elapsedTime)*10)/10)
						end
						stop[t[2]][t[5]] = true
					else
						timers[t[2]][t[5]].time.visible = false
						timers[t[2]][t[5]].texture.visible = false
						removes(r,t)
						return
					end
				end
			elseif not findmodifs(t[1],t[3],t[7]) then
				removes(r,t)
				return
			end
		else
			if timers[t[2]][t[5]].time.visible then
				timers[t[2]][t[5]].time.visible = false
				timers[t[2]][t[5]].texture.visible = false
			end
			removes(r,t)
			return
		end
	end
	if sleeptick < tick then
		sleeptick = tick+50
		local heroes = {entityList:GetEntities({type = LuaEntity.TYPE_HERO, illusion = false}),entityList:GetEntities({type = LuaEntity.TYPE_MEEPO})}
		for o,p in ipairs(heroes) do
			for _,w in ipairs(p) do
				if w.reincarnating then
					if not timers[w.handle] or not timers[w.handle][3] or not timers[w.handle][3].reincarnate then
						regi(w,3)
						timers[w.handle][3].reincarnate = true
						timers[w.handle][3].time.visible = true
						timers[w.handle][3].texture.textureId = drawMgr:GetTextureId("NyanUI/spellicons/skeleton_king_reincarnation")
						timers[w.handle][3].texture.visible = true
					end
					timers[w.handle][3].time.text = tostring(math.floor(w.respawnTime*10)/10)
				elseif timers[w.handle] and timers[w.handle][3] and timers[w.handle][3].reincarnate then
					timers[w.handle][3].time.visible = false
					timers[w.handle][3].texture.visible = false
					timers[w.handle][3].reincarnate = nil
				end
			end
		end
	end
	if pretime then
		local gametime = client.totalGameTime*10
		if gametime >= pretime+delay then
			pretime = pretime+1
			count = count-1
			wispTime.text = tostring(count/10)
		end
		q,positi = client:ScreenPosition(wisp.pos)
		if q then
			wispTime.position = Vector2D(positi.x+config.Distancefontimage,positi.y)
			wispTexture.position = Vector2D(positi.x-config.Distancefontimage,positi.y)
			if not wispTime.visible then
				wispTime.visible = true
				wispTexture.visible = true
			end
		elseif wispTime.visible then
			wispTime.visible = false
			wispTexture.visible = false
		end
		if count == 0 then
			wispTime.visible = false
			wispTexture.visible = false
			pretime = nil
		end
	end
end

function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:RegisterEvent(EVENT_MODIFIER_ADD,Modifadd)
		script:UnregisterEvent(Load)
	end
end

function Close()
	timers, entities, wisp, modifs, wispTime.visible, wispTexture.visible = {}, {}, {}, {}, false, false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:UnregisterEvent(Modifadd)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
