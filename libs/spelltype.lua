-- Made my Staskkk.
-- Save as spelltype.lua and place this script to the Ensage\Scripts\libs folder.

-- target = "target","area". Type of target
-- number = 1,2,3,4,5,6. Number of hotkey you use for spell.

list2 = {

	abaddon_death_coil = { target = "target", number = 1 }, -- 1
	abaddon_aphotic_shield = { target = "target", number = 2 }, -- 2
--	abaddon_frostmourne, -- 3
--	abaddon_borrowed_time, -- 4

	alchemist_acid_spray = { target = "area", number = 1 }, -- 1
--	alchemist_unstable_concoction, -- 2
--	alchemist_goblins_greed, -- 3
--	alchemist_chemical_rage, -- 4
	alchemist_unstable_concoction_throw = { target = "target", number = 2 }, -- 6

	ancient_apparition_cold_feet = { target = "target", number = 1 }, -- 1
	ancient_apparition_ice_vortex = { target = "area", number = 2 }, -- 2
	ancient_apparition_chilling_touch = { target = "area", number = 3 }, -- 3
	ancient_apparition_ice_blast = { target = "area", number = 4 }, -- 4
--	ancient_apparition_ice_blast_release, -- 5

--	antimage_mana_break, -- 1
	antimage_blink = { target = "area", number = 2 }, -- 2
--	antimage_spell_shield, -- 3
	antimage_mana_void = { target = "target", number = 4 }, -- 4

--	axe_berserkers_call, -- 1
	axe_battle_hunger = { target = "target", number = 2 }, -- 2
--	axe_counter_helix, -- 3
	axe_culling_blade = { target = "target", number = 4 }, -- 4

	bane_enfeeble = { target = "target", number = 1 }, -- 1
	bane_brain_sap = { target = "target", number = 2 }, -- 2
	bane_nightmare = { target = "target", number = 3 }, -- 3
	bane_fiends_grip = { target = "target", number = 4 }, -- 4
--	bane_nightmare_end, -- 6

	batrider_sticky_napalm = { target = "area", number = 1 }, -- 1
	batrider_flamebreak = { target = "area", number = 2 }, -- 2
--	batrider_firefly, -- 3
	batrider_flaming_lasso = { target = "target", number = 4 }, -- 4

	beastmaster_wild_axes = { target = "target", number = 1 }, -- 1
--	beastmaster_call_of_the_wild, -- 2
--	beastmaster_call_of_the_wild_boar, -- 3
--	beastmaster_inner_beast, -- 4
	beastmaster_primal_roar = { target = "target", number = 4 }, -- 5

	bloodseeker_bloodrage = { target = "target", number = 1 }, -- 1
	bloodseeker_blood_bath = { target = "area", number = 2 }, -- 2
--	bloodseeker_thirst, -- 3
	bloodseeker_rupture = { target = "target", number = 4 }, -- 4

	bounty_hunter_shuriken_toss = { target = "target", number = 1 }, -- 1
--	bounty_hunter_jinada, -- 2
--	bounty_hunter_wind_walk, -- 3
	bounty_hunter_track = { target = "target", number = 4 }, -- 4

--	brewmaster_thunder_clap, -- 1
	brewmaster_drunken_haze = { target = "target", number = 2 }, -- 2
--	brewmaster_drunken_brawler, -- 3
--	brewmaster_primal_split, -- 4

	bristleback_viscous_nasal_goo = { target = "target", number = 1 }, -- 1
--	bristleback_quill_spray, -- 2
--	bristleback_bristleback, -- 3
--	bristleback_warpath, -- 4

	broodmother_spawn_spiderlings = { target = "target", number = 1 }, -- 1
	broodmother_spin_web = { target = "area", number = 2 }, -- 2
--	broodmother_incapacitating_bite, -- 3
--	broodmother_insatiable_hunger, -- 4

--	centaur_hoof_stomp, -- 1
	centaur_double_edge = { target = "target", number = 2 }, -- 2
--	centaur_return, -- 3
--	centaur_stampede, -- 4

	chaos_knight_chaos_bolt = { target = "target", number = 1 }, -- 1
	chaos_knight_reality_rift = { target = "target", number = 2 }, -- 2
--	chaos_knight_chaos_strike}, -- 3
--	chaos_knight_phantasm, -- 4

	chen_penitence = { target = "target", number = 1 }, -- 1
	chen_test_of_faith = { target = "target", number = 2 }, -- 2
	chen_test_of_faith_teleport = { target = "target", number = 3 }, -- 3
--	chen_holy_persuasion, -- 4
--	chen_hand_of_god, -- 5

--	clinkz_strafe, -- 1
	clinkz_searing_arrows = { target = "target", number = 2 }, -- 2
--	clinkz_wind_wal, -- 3
--	clinkz_death_pact, -- 4

--	rattletrap_battery_assault, -- 1
--	rattletrap_power_cogs, -- 2
	rattletrap_rocket_flare = { target = "area", number = 3 }, -- 3
	rattletrap_hookshot = { target = "area", number = 4 }, -- 4

	crystal_maiden_crystal_nova = { target = "area", number = 1 }, -- 1
	crystal_maiden_frostbite = { target = "target", number = 2 }, -- 2
--	crystal_maiden_brilliance_aura, -- 3
--	crystal_maiden_freezing_field, -- 4

	dark_seer_vacuum = { target = "area", number = 1 }, -- 1
	dark_seer_ion_shell = { target = "target", number = 2 }, -- 2
	dark_seer_surge = { target = "target", number = 3 }, -- 3
	dark_seer_wall_of_replica = { target = "area", number = 4 }, -- 4

	dazzle_poison_touch = { target = "target", number = 1 }, -- 1
	dazzle_shallow_grave = { target = "target", number = 2 }, -- 2
	dazzle_shadow_wave = { target = "target", number = 3 }, -- 3
	dazzle_weave = { target = "area", number = 4 }, -- 4

	death_prophet_carrion_swarm = { target = "target", number = 1 }, -- 1
	death_prophet_silence = { target = "area", number = 2 }, -- 2
--	death_prophet_witchcraft, -- 3
--	death_prophet_exorcism, -- 4

	disruptor_thunder_strike = { target = "target", number = 1 }, -- 1
	disruptor_glimpse = { target = "target", number = 2 }, -- 2
	disruptor_kinetic_field = { target = "area", number = 3 }, -- 3
	disruptor_static_storm = { target = "area", number = 4 }, -- 4

--	doom_bringer_devour, -- 1
--	doom_bringer_scorched_earth, -- 2
	doom_bringer_lvl_death = { target = "target", number = 3 }, -- 3
--	doom_bringer_empty1, -- 4
--	doom_bringer_empty2, -- 5
	doom_bringer_doom = { target = "target", number = 4 }, -- 6

	dragon_knight_breathe_fire = { target = "target", number = 1 }, -- 1
	dragon_knight_dragon_tail = { target = "target", number = 2 }, -- 2
--	dragon_knight_dragon_blood, -- 3
--	dragon_knight_elder_dragon_form, -- 4

	drow_ranger_frost_arrows = { target = "target", number = 1 }, -- 1
	drow_ranger_wave_of_silence = { target = "area", number = 2 }, -- 2
--	drow_ranger_trueshot, -- 3
--	drow_ranger_marksmanship, -- 4

	earth_spirit_boulder_smash = { target = "target", number = 1 }, -- 1
	earth_spirit_rolling_boulder = { target = "area", number = 2 }, -- 2
	earth_spirit_geomagnetic_grip = { target = "target", number = 3 }, -- 3
	earth_spirit_stone_caller = { target = "area", number = 5 }, -- 4
	earth_spirit_petrify = { target = "target", number = 6 }, -- 5
--	earth_spirit_magnetize, -- 6

	earthshaker_fissure = { target = "target", number = 1 }, -- 1
--	earthshaker_enchant_totem, -- 2
--	earthshaker_aftershock, -- 3
--	earthshaker_echo_slam, -- 4

--	elder_titan_echo_stomp, -- 1
	elder_titan_ancestral_spirit = { target = "area", number = 2 }, -- 2
--	elder_titan_natural_order, -- 3
--	elder_titan_return_spirit, -- 4
	elder_titan_earth_splitter = { target = "area", number = 4 }, -- 5

--	ember_spirit_searing_chains, -- 1
	ember_spirit_sleight_of_fist = { target = "area", number = 2 }, -- 2
--	ember_spirit_flame_guard, -- 3
	ember_spirit_activate_fire_remnant = { target = "area", number = 5 }, -- 4
	ember_spirit_fire_remnant = { target = "area", number = 4 }, -- 5

--	enchantress_untouchable, -- 1
	enchantress_enchant = { target = "target", number = 2 }, -- 2
--	enchantress_natures_attendants, -- 3
	enchantress_impetus = { target = "target", number = 4 }, -- 4

	enigma_malefice = { target = "target", number = 1 }, -- 1
--	enigma_demonic_conversion, -- 2
	enigma_midnight_pulse = { target = "area", number = 3 }, -- 3
	enigma_black_hole = { target = "area", number = 4 }, -- 4

	faceless_void_time_walk = { target = "area", number = 1 }, -- 1
--	faceless_void_backtrack, -- 2
--	faceless_void_time_lock, -- 3
	faceless_void_chronosphere = { target = "area", number = 4 }, -- 4

--	gyrocopter_rocket_barrage, -- 1
	gyrocopter_homing_missile = { target = "target", number = 2 }, -- 2
--	gyrocopter_flak_cannon, -- 3
	gyrocopter_call_down = { target = "area", number = 4 }, -- 5

	huskar_inner_vitality = { target = "target", number = 1 }, -- 1
	huskar_burning_spear = { target = "target", number = 2 }, -- 2
--	huskar_berserkers_blood, -- 3
	huskar_life_break = { target = "target", number = 4 }, -- 4

--	invoker_quas, -- 1
--	invoker_wex, -- 2
--	invoker_exort, -- 3
--	invoker_empty1, -- 4
--	invoker_empty2, -- 5
--	invoker_invoke, -- 6
	invoker_cold_snap = { target = "target", number = 5 }, -- 7
--	invoker_ghost_walk, -- 8
	invoker_tornado = { target = "area", number = 5 }, -- 9
	invoker_emp = { target = "area", number = 5 }, -- 10
	invoker_alacrity = { target = "target", number = 5 }, -- 11
	invoker_chaos_meteor = { target = "area", number = 5 }, -- 12
	invoker_sun_strike = { target = "area", number = 5 }, -- 13
--	invoker_forge_spirit, -- 14
--	invoker_ice_wall, -- 15
	invoker_deafening_blast = { target = "area", number = 5 }, -- 16

	wisp_tether = { target = "target", number = 1 }, -- 1
--	wisp_tether_break, -- 2
--	wisp_spirits, -- 3
--	wisp_overcharge, -- 4
--	wisp_empty1, -- 5
--	wisp_empty2, -- 6
	wisp_relocate = { target = "area", number = 4 }, -- 7
--	wisp_spirits_in, -- 9
--	wisp_spirits_out, -- 10

	jakiro_dual_breath = { target = "target", number = 1 }, -- 1
	jakiro_ice_path = { target = "area", number = 2 }, -- 2
	jakiro_liquid_fire = { target = "target", number = 3 }, -- 3
	jakiro_macropyre = { target = "target", number = 4 }, -- 4

--	juggernaut_blade_fury, -- 1
	juggernaut_healing_ward = { target = "area", number = 2 }, -- 2
--	juggernaut_blade_dance, -- 3
	juggernaut_omni_slash = { target = "target", number = 4 }, -- 4

	keeper_of_the_light_illuminate = { target = "area", number = 1 }, -- 1
	keeper_of_the_light_mana_leak = { target = "target", number = 2 }, -- 2
	keeper_of_the_light_chakra_magic = { target = "target", number = 3 }, -- 3
	keeper_of_the_light_recall = { target = "target", number = 5 }, -- 4
	keeper_of_the_light_blinding_light = { target = "area", number = 6 }, -- 5
--	keeper_of_the_light_spirit_form, -- 6
--	keeper_of_the_light_illuminate_end, -- 7
	keeper_of_the_light_spirit_form_illuminate = { target = "area", number = 1 }, -- 8
--	keeper_of_the_light_spirit_form_illuminate_end, -- 9

	kunkka_torrent = { target = "area", number = 1 }, -- 1
--	kunkka_tidebringer, -- 2
	kunkka_x_marks_the_spot = { target = "target", number = 3 }, -- 3
	kunkka_ghostship = { target = "area", number = 4 }, -- 4
--	kunkka_return, -- 6

	legion_commander_overwhelming_odds = { target = "area", number = 1 }, -- 1
	legion_commander_press_the_attack = { target = "target", number = 2 }, -- 2
--	legion_commander_moment_of_courage, -- 3
	legion_commander_duel = { target = "target", number = 4 }, -- 4

	leshrac_split_earth = { target = "area", number = 1 }, -- 1
--	leshrac_diabolic_edict, -- 2
	leshrac_lightning_storm = { target = "target", number = 3 }, -- 3
--	leshrac_pulse_nova, -- 4

	lich_frost_nova = { target = "target", number = 1 }, -- 1
	lich_frost_armor = { target = "target", number = 2 }, -- 2
--	lich_dark_ritual, -- 3
	lich_chain_frost = { target = "target", number = 4 }, -- 4

--	life_stealer_rage, -- 1
--	life_stealer_feast, -- 2
	life_stealer_open_wounds = { target = "target", number = 3 }, -- 3
	life_stealer_infest = { target = "target", number = 4 }, -- 4
--	life_stealer_consume, -- 6

	lina_dragon_slave = { target = "target", number = 1 }, -- 1
	lina_light_strike_array = { target = "area", number = 2 }, -- 2
--	lina_fiery_soul, -- 3
	lina_laguna_blade = { target = "target", number = 4 }, -- 4

	lion_impale = { target = "target", number = 1 }, -- 1
	lion_voodoo = { target = "target", number = 2 }, -- 2
	lion_mana_drain = { target = "target", number = 3 }, -- 3
	lion_finger_of_death = { target = "target", number = 4 }, -- 4

--	lone_druid_spirit_bear, -- 1
--	lone_druid_rabid, -- 2
--	lone_druid_synergy, -- 3
--	lone_druid_true_form_battle_cry, -- 4
--	lone_druid_true_form, -- 5
--	lone_druid_true_form_druid, -- 6

	luna_lucent_beam = { target = "target", number = 1 }, -- 1
--	luna_moon_glaive, -- 2
--	luna_lunar_blessing, -- 3
--	luna_eclipse, -- 4

--	lycan_summon_wolves, -- 1
--	lycan_howl, -- 2
--	lycan_feral_impulse, -- 3
--	lycan_shapeshift, -- 4

	magnataur_shockwave = { target = "target", number = 1 }, -- 1
	magnataur_empower = { target = "target", number = 2 }, -- 2
	magnataur_skewer = { target = "area", number = 3 }, -- 3
--	magnataur_reverse_polarity, -- 4

--	medusa_split_shot, -- 1
	medusa_mystic_snake = { target = "target", number = 2 }, -- 2
--	medusa_mana_shield, -- 3
--	medusa_stone_gaze, -- 4

	meepo_earthbind = { target = "area", number = 1 }, -- 1
	meepo_poof = { target = "target", number = 2 }, -- 2
--	meepo_geostrike, -- 3
--	meepo_divided_we_stand, -- 4

--	mirana_starfal, -- 1
	mirana_arrow = { target = "area", number = 2 }, -- 2
--	mirana_leap, -- 3
--	mirana_invis, -- 4

	morphling_waveform = { target = "area", number = 1 }, -- 1
	morphling_adaptive_strike = { target = "target", number = 2 }, -- 2
--	morphling_morph_agi, -- 3
--	morphling_morph_str, -- 4
	morphling_replicate = { target = "target", number = 4 }, -- 5
--	morphling_morph, -- 6
--	morphling_morph_replicate, -- 7

--	naga_siren_mirror_image, -- 1
	naga_siren_ensnare = { target = "target", number = 2 }, -- 2
--	naga_siren_rip_tide, -- 3
--	naga_siren_song_of_the_siren, -- 4
--	naga_siren_song_of_the_siren_cancel, -- 5

	furion_sprout = { target = "target", number = 1 }, -- 1
	furion_teleportation = { target = "area", number = 2 }, -- 2
	furion_force_of_nature = { target = "area", number = 3 }, -- 3
	furion_wrath_of_nature = { target = "target", number = 4 }, -- 4

--	necrolyte_death_pulse, -- 1
--	necrolyte_heartstopper_aura, -- 2
--	necrolyte_sadist, -- 3
	necrolyte_reapers_scythe = { target = "target", number = 4 }, -- 4

	night_stalker_void = { target = "target", number = 1 }, -- 1
	night_stalker_crippling_fear = { target = "target", number = 2 }, -- 2
--	night_stalker_hunter_in_the_night, -- 3
--	night_stalker_darkness, -- 4

	nyx_assassin_impale = { target = "area", number = 1 }, -- 1
	nyx_assassin_mana_burn = { target = "target", number = 2 }, -- 2
--	nyx_assassin_spiked_carapace, -- 3
--	nyx_assassin_vendetta, -- 4

	ogre_magi_fireblast = { target = "target", number = 1 }, -- 1
	ogre_magi_ignite = { target = "target", number = 2 }, -- 2
	ogre_magi_bloodlust = { target = "target", number = 3 }, -- 3
	ogre_magi_unrefined_fireblast = { target = "target", number = 5 }, -- 4
--	ogre_magi_multicast, -- 5

	omniknight_purification = { target = "target", number = 1 }, -- 1
	omniknight_repel = { target = "target", number = 2 }, -- 2
--	omniknight_degen_aura, -- 3
--	omniknight_guardian_angel, -- 4

	obsidian_destroyer_arcane_orb = { target = "target", number = 1 }, -- 1
	obsidian_destroyer_astral_imprisonment = { target = "target", number = 2 }, -- 2
--	obsidian_destroyer_essence_aura, -- 3
	obsidian_destroyer_sanity_eclipse = { target = "area", number = 4 }, -- 4

	phantom_assassin_stifling_dagger = { target = "target", number = 1 }, -- 1
	phantom_assassin_phantom_strike = { target = "target", number = 2 }, -- 2
--	phantom_assassin_blur, -- 3
--	phantom_assassin_coup_de_grace, -- 4

	phantom_lancer_spirit_lance = { target = "target", number = 1 }, -- 1
	phantom_lancer_doppelwalk = { target = "area", number = 2 }, -- 2
--	phantom_lancer_phantom_edge, -- 3
--	phantom_lancer_juxtapose, -- 4

	phoenix_icarus_dive = { target = "area", number = 1 }, -- 1
--	phoenix_fire_spirits, -- 2
	phoenix_sun_ray = { target = "area", number = 3 }, -- 3
--	phoenix_sun_ray_toggle_move_empty, -- 4
--	phoenix_supernova, -- 5
	phoenix_launch_fire_spirit = { target = "area", number = 2 }, -- 6
--	phoenix_icarus_dive_stop, -- 7
--	phoenix_sun_ray_stop, -- 8
--	phoenix_sun_ray_toggle_move, -- 9

	puck_illusory_orb = { target = "area", number = 1 }, -- 1
--	puck_waning_rift, -- 2
--	puck_phase_shift, -- 3
--	puck_ethereal_jaunt, -- 4
	puck_dream_coil = { target = "area", number = 4 }, -- 5

	pudge_meat_hook = { target = "area", number = 1 }, -- 1
--	pudge_rot, -- 2
--	pudge_flesh_heap, -- 3
	pudge_dismember = { target = "target", number = 4 }, -- 4

	pugna_nether_blast = { target = "area", number = 1 }, -- 1
	pugna_decrepify = { target = "target", number = 2 }, -- 2
--	pugna_nether_ward, -- 3
	pugna_life_drain = { target = "target", number = 4 }, -- 4

	queenofpain_shadow_strike = { target = "target", number = 1 }, -- 1
	queenofpain_blink = { target = "area", number = 2 }, -- 2
--	queenofpain_scream_of_pain, -- 3
	queenofpain_sonic_wave = { target = "target", number = 4 }, -- 4

--	razor_plasma_field, -- 1
	razor_static_link = { target = "target", number = 2 }, -- 2
--	razor_unstable_current, -- 3
--	razor_eye_of_the_storm, -- 4

	riki_smoke_screen = { target = "area", number = 1 }, -- 1
--	riki_permanent_invisibility, -- 2
--	riki_backstab, -- 3
	riki_blink_strike = { target = "target", number = 4 }, -- 4

	rubick_telekinesis = { target = "target", number = 1 }, -- 1
	rubick_telekinesis_land = { target = "area", number = 1 }, -- 2
	rubick_fade_bolt = { target = "target", number = 2 }, -- 3
--	rubick_null_field, -- 4
--	rubick_empty1, -- 5
--	rubick_empty2, -- 6
	rubick_spell_steal = { target = "target", number = 4 }, -- 7
--	rubick_hidden1, -- 9
--	rubick_hidden2, -- 10
--	rubick_hidden3, -- 11

	sandking_burrowstrike = { target = "target", number = 1 }, -- 1
--	sandking_sand_storm, -- 2
--	sandking_caustic_finale, -- 3
--	sandking_epicenter, -- 4

	shadow_demon_disruption = { target = "target", number = 1 }, -- 1
	shadow_demon_soul_catcher = { target = "area", number = 2 }, -- 2
	shadow_demon_shadow_poison = { target = "area", number = 3 }, -- 3
--	shadow_demon_shadow_poison_release, -- 4
	shadow_demon_demonic_purge = { target = "target", number = 4 }, -- 5

--	nevermore_shadowraze1, -- 1
--	nevermore_shadowraze2, -- 2
--	nevermore_shadowraze3, -- 3
--	nevermore_necromastery, -- 4
--	nevermore_dark_lord, -- 5
--	nevermore_requiem, -- 6

	shadow_shaman_ether_shock = { target = "target", number = 1 }, -- 1
	shadow_shaman_voodoo = { target = "target", number = 2 }, -- 2
	shadow_shaman_shackles = { target = "target", number = 3 }, -- 3
	shadow_shaman_mass_serpent_ward = { target = "area", number = 4 }, -- 4

	silencer_curse_of_the_silent = { target = "area", number = 1 }, -- 1
	silencer_glaives_of_wisdom = { target = "target", number = 2 }, -- 2
	silencer_last_word = { target = "target", number = 3 }, -- 3
--	silencer_global_silence, -- 4

	skywrath_mage_arcane_bolt = { target = "target", number = 1 }, -- 1
--	skywrath_mage_concussive_shot, -- 2
	skywrath_mage_ancient_seal = { target = "target", number = 3 }, -- 3
	skywrath_mage_mystic_flare = { target = "area", number = 4 }, -- 4

--	slardar_sprint, -- 1
--	slardar_slithereen_crush, -- 2
--	slardar_bash, -- 3
	slardar_amplify_damage = { target = "target", number = 4 }, -- 4

--	slark_dark_pact, -- 1
--	slark_pounce, -- 2
--	slark_essence_shift, -- 3
--	slark_shadow_dance, -- 4

	sniper_shrapnel = { target = "area", number = 1 }, -- 1
--	sniper_headshot, -- 2
--	sniper_take_aim, -- 3
	sniper_assassinate = { target = "target", number = 4 }, -- 4

	spectre_spectral_dagger = { target = "target", number = 1 }, -- 1
--	spectre_desolate, -- 2
--	spectre_dispersion, -- 3
	spectre_reality = { target = "area", number = 5 }, -- 4
--	spectre_haunt, -- 5

	spirit_breaker_charge_of_darkness = { target = "target", number = 1 }, -- 1
--	spirit_breaker_empowering_haste, -- 2
--	spirit_breaker_greater_bash, -- 3
	spirit_breaker_nether_strike = { target = "target", number = 4 }, -- 4

--	storm_spirit_static_remnant, -- 1
	storm_spirit_electric_vortex = { target = "target", number = 2 }, -- 2
--	storm_spirit_overload, -- 3
	storm_spirit_ball_lightning = { target = "area", number = 4 }, -- 4

	sven_storm_bolt = { target = "target", number = 1 }, -- 1
--	sven_great_cleave, -- 2
--	sven_warcry, -- 3
--	sven_gods_strength, -- 4

--	templar_assassin_refraction, -- 1
--	templar_assassin_meld, -- 2
--	templar_assassin_psi_blades, -- 3
--	templar_assassin_trap, -- 4
	templar_assassin_psionic_trap = { target = "area", number = 4 }, -- 5

	terrorblade_reflection = { target = "target", number = 1 }, -- 1
--	terrorblade_conjure_image, -- 2
--	terrorblade_metamorphosis, -- 3
	terrorblade_sunder = { target = "target", number = 4 }, -- 4

	tidehunter_gush = { target = "target", number = 1 }, -- 1
--	tidehunter_kraken_shell, -- 2
--	tidehunter_anchor_smash, -- 3
--	tidehunter_ravage, -- 4

--	shredder_whirling_death, -- 1
	shredder_timber_chain = { target = "area", number = 2 }, -- 2
--	shredder_reactive_armor, -- 3
	shredder_chakram_2 = { target = "area", number = 5 }, -- 4
--	shredder_return_chakram_2, -- 5
	shredder_chakram = { target = "area", number = 4 }, -- 6
--	shredder_return_chakram, -- 7

	techies_land_mines = { target = "area", number = 1 }, -- 1
	techies_stasis_trap = { target = "area", number = 2 }, -- 2
	techies_suicide = { target = "target", number = 3 }, -- 3
	techies_focused_detonate = { target = "area", number = 5 }, -- 4
	techies_minefield_sign = { target = "area", number = 6 }, -- 5
	techies_remote_mines = { target = "area", number = 4 }, -- 6

	tinker_laser = { target = "target", number = 1 }, -- 1
--	tinker_heat_seeking_missile, -- 2
	tinker_march_of_the_machines = { target = "area", number = 3 }, -- 3
--	tinker_rearm , -- 4

	tiny_avalanche = { target = "area", number = 1 }, -- 1
	tiny_toss = { target = "target", number = 2 }, -- 2
--	tiny_craggy_exterior, -- 3
--	tiny_grow, -- 4

	treant_natures_guise = { target = "target", number = 1 }, -- 1
	treant_leech_seed = { target = "target", number = 2 }, -- 2
	treant_living_armor = { target = "target", number = 3 }, -- 3
--	treant_eyes_in_the_forest, -- 4
--	treant_overgrowth, -- 5

--	troll_warlord_berserkers_rage, -- 1
	troll_warlord_whirling_axes_ranged = { target = "target", number = 2 }, -- 2
--	troll_warlord_whirling_axes_melee, -- 3
--	troll_warlord_fervor, -- 4
--	troll_warlord_battle_trance, -- 5

	tusk_ice_shards = { target = "area", number = 1 }, -- 1
	tusk_snowball = { target = "target", number = 2 }, -- 2
--	tusk_frozen_sigil, -- 3
--	tusk_walrus_punch, -- 4
--	tusk_launch_snowball, -- 6

	undying_decay = { target = "area", number = 1 }, -- 1
	undying_soul_rip = { target = "target", number = 2 }, -- 2
	undying_tombstone = { target = "area", number = 3 }, -- 3
--	undying_flesh_golem, -- 4

--	ursa_earthshock, -- 1
--	ursa_overpower, -- 2
--	ursa_fury_swipes, -- 3
--	ursa_enrage, -- 5

	vengefulspirit_magic_missile = { target = "target", number = 1 }, -- 1
	vengefulspirit_wave_of_terror = { target = "area", number = 2 }, -- 2
--	vengefulspirit_command_aura, -- 3
	vengefulspirit_nether_swap = { target = "target", number = 4 }, -- 4

	venomancer_venomous_gale = { target = "area", number = 1 }, -- 1
--	venomancer_poison_sting, -- 2
	venomancer_plague_ward = { target = "area", number = 3 }, -- 3
--	venomancer_poison_nova, -- 4

	viper_poison_attack = { target = "target", number = 1 }, -- 1
--	viper_nethertoxin, -- 2
--	viper_corrosive_skin, -- 3
	viper_viper_strike = { target = "target", number = 4 }, -- 4

	visage_grave_chill = { target = "target", number = 1 }, -- 1
	visage_soul_assumption = { target = "target", number = 2 }, -- 2
--	visage_gravekeepers_cloak, -- 3
--	visage_summon_familiars, -- 4

	warlock_fatal_bonds = { target = "target", number = 1 }, -- 1
	warlock_shadow_word = { target = "target", number = 2 }, -- 2
	warlock_upheaval = { target = "area", number = 3 }, -- 3
	warlock_rain_of_chaos = { target = "area", number = 4 }, -- 4

	weaver_the_swarm = { target = "area", number = 1 }, -- 1
--	weaver_shukuchi, -- 2
--	weaver_geminate_attack, -- 3
--	weaver_time_lapse, -- 4

	windrunner_shackleshot = { target = "target", number = 1 }, -- 1
	windrunner_powershot = { target = "area", number = 2 }, -- 2
--	windrunner_windrun, -- 3
	windrunner_focusfire = { target = "target", number = 4 }, -- 4

	witch_doctor_paralyzing_cask = { target = "target", number = 1 }, -- 1
--	witch_doctor_voodoo_restoration, -- 2
	witch_doctor_maledict = { target = "area", number = 3 }, -- 3
	witch_doctor_death_ward = { target = "area", number = 4 }, -- 4

	skeleton_king_hellfire_blast = { target = "target", number = 1 }, -- 1
--	skeleton_king_vampiric_aura, -- 2
--	skeleton_king_mortal_strike, -- 3
--	skeleton_king_reincarnation, -- 4

	zuus_arc_lightning = { target = "target", number = 1 }, -- 1
	zuus_lightning_bolt = { target = "target", number = 2 }, -- 2
--	zuus_static_field, -- 3
--	zuus_thundergods_wrath, -- 4

	brewmaster_earth_hurl_boulder = { target = "target", number = 1 }, -- 1
--	brewmaster_earth_spell_immunity, -- 2
--	brewmaster_earth_pulverize, -- 3
--	brewmaster_thunder_clap, -- 4

	brewmaster_storm_dispel_magic = { target = "area", number = 1 }, -- 1
	brewmaster_storm_cyclone = { target = "target", number = 2 }, -- 2
--	brewmaster_storm_wind_walk, -- 3
--	brewmaster_drunken_haze = { target = "target", number = 5 }, -- 4

--	brewmaster_fire_permanent_immolation, -- 1
--	brewmaster_drunken_brawler, -- 2

	enraged_wildkin_tornado = { target = "area", number = 1 }, -- 1
--	enraged_wildkin_toughness_aura, -- 2

	ogre_magi_frost_armor = { target = "target", number = 1 }, -- 1

--	centaur_khan_war_stomp, -- 1
--	centaur_khan_endurance_aura, -- 2

	dark_troll_warlord_ensnare = { target = "target", number = 1 }, -- 1
--	dark_troll_warlord_raise_dead, -- 2

	satyr_hellcaller_shockwave = { target = "target", number = 1 }, -- 1
--	satyr_hellcaller_unholy_aura, -- 2

--	alpha_wolf_critical_strike, -- 1
--	alpha_wolf_command_aura, -- 2

--	polar_furbolg_ursa_warrior_thunder_clap, -- 1

	forest_troll_high_priest_heal = { target = "target", number = 1 }, -- 1
--	forest_troll_high_priest_mana_aura, -- 2

--	kobold_taskmaster_speed_aura, -- 1

--	ghost_frost_attack, -- 1

	satyr_soulstealer_mana_burn = { target = "target", number = 1 }, -- 1

	satyr_trickster_purge = { target = "target", number = 1 }, -- 1

--	giant_wolf_critical_strike, -- 1

	harpy_storm_chain_lightning = { target = "target", number = 1 }, -- 1

--	gnoll_assassin_envenomed_weapon, -- 1

--	necronomicon_warrior_mana_burn, -- 1
--	necronomicon_warrior_last_will, -- 2
--	necronomicon_warrior_sight, -- 3

	necronomicon_archer_mana_burn = { target = "target", number = 1 }, -- 1
--	necronomicon_archer_aoe, -- 2

--	beastmaster_greater_boar_poison, -- 1

--	beastmaster_hawk_invisibility, -- 1

--	lycan_summon_wolves_critical_strike, -- 1
--	lycan_summon_wolves_invisibility, -- 2

--	visage_summon_familiars_stone_form, -- 1
--	neutral_spell_immunity, -- 2

--	warlock_golem_flaming_fists, -- 1
--	warlock_golem_permanent_immolation, -- 2

--	forged_spirit_melting_strike, -- 1

--	broodmother_poison_sting, -- 1
--	broodmother_spawn_spiderite, -- 2

--	lone_druid_spirit_bear_return, -- 1
--	lone_druid_spirit_bear_entangle, -- 2
--	lone_druid_spirit_bear_demolish, -- 3

--	templar_assassin_self_trap, -- 1

--	courier_return_to_base, -- 1
--	courier_go_to_secretshop, -- 2
--	courier_return_stash_items, -- 3
--	courier_take_stash_items, -- 4
--	courier_transfer_items, -- 5
--	courier_burst, -- 6

}
