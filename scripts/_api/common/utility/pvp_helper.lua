
-- Example:
-- ---@type pvp_helper
-- local x = require("common/utility/pvp_helper")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class pvp_helper
---@field public is_player fun(self: pvp_helper, unit: game_object): boolean
---@field public is_pvp_scenario fun(self: pvp_helper, local_player: game_object, target: game_object): boolean
---@field public cc_flags cc_flags_table
---@field public cc_flag_descriptions table<number, string>
---@field public cc_debuffs table<number, {debuff_id: number, debuff_name: string, flag: number}>
---@field public cc_immune_buff table<number, {buff_id: number, buff_name: string, flag: number, class: number, mult: number}>
---@field public cc_slows table<number, {debuff_id: number, debuff_name: string, flag: number, mult: number}>
---@field public is_crowd_controlled fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): boolean, number, number
---@field public is_cc_immune fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): boolean, number, number
---@field public get_cc_reduction_mult fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public get_cc_reduction_percentage fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public has_cc_reduction fun(self: pvp_helper, unit: game_object, threshold: number?, type_flags: number?, min_remaining: number?): boolean, number, number
---@field public is_slow fun(self: pvp_helper, unit: game_object, threshold: number?, min_remaining: number?): boolean, number, number
---@field public get_slow_percentage fun(self: pvp_helper, unit: game_object, min_remaining: number?): number, number

---@class cc_flags_table
---@field public MAGICAL number
---@field public PHYSICAL number
---@field public SLOW number
---@field public ROOT number
---@field public STUN number
---@field public INCAPACITATE number
---@field public DISORIENT number
---@field public FEAR number
---@field public SAP number
---@field public CYCLONE number
---@field public KICK number
---@field public SILENCE number
---@field public ANY number
---@field public ANY_BUT_SLOW number
---@field public combine fun(...: string): number

---@class pvp_helper
---@field public damage_type_flags damage_type_flags_table
---@field public damage_type_flag_descriptions table<number, string>
---@field public damage_reduction_buff table<number, {buff_id: number, buff_name: string, flag: number, class: number, mult: number}>
---@field public get_damage_reduction_mult fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public get_damage_reduction_percentage fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): number, number, number
---@field public has_damage_reduction fun(self: pvp_helper, unit: game_object, threshold: number?, type_flags: number?, min_remaining: number?): boolean, number, number
---@field public is_damage_immune fun(self: pvp_helper, unit: game_object, type_flags: number?, min_remaining: number?): boolean, number, number

---@class damage_type_flags_table
---@field public PHYSICAL number
---@field public MAGICAL number
---@field public ANY number
---@field public BOTH number
---@field public combine fun(...: string): number

---@class pvp_helper
---@field public offensive_cooldowns table<number, {buff_id: number, buff_name: string, class: number}>
---@field public has_offensive_cooldown_active fun(self: pvp_helper, unit: game_object, min_remaining: number?): boolean
---@field public get_combined_cc_descriptions fun(self: pvp_helper, type: number): string
---@field public get_combined_damage_type_descriptions fun(self: pvp_helper, type: number): string

---@class pvp_helper
---@field public purgeable_buffs {buff_id: number, buff_name: string, priority: number, min_remaining: number}[] 
---@field public is_purgeable fun(self: pvp_helper, unit: game_object, min_remaining: number?): {is_purgeable: boolean, table: {buff_id: number, buff_name: string, priority: number, min_remaining: number}?, current_remaining_ms: number, expire_time: number}
