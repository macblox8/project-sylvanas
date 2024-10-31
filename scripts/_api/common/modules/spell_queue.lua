
-- Example:
-- ---@type spell_queue
-- local sq = require("common/modules/spell_queue")
-- sq: -> IntelliSense
-- Warning: Access with ":", not "."

---@class spell_queue
---Queues a spell with a target.
---@field public queue_spell_target fun(self: spell_queue, spell_id: number, target: any, priority: number, message?: string)
---Queues a spell that skips global cooldown with a target.
---@field public queue_spell_target_fast fun(self: spell_queue, spell_id: number, target: any, priority: number, message?: string)
---Queues a spell with a position.
---@field public queue_spell_position fun(self: spell_queue, spell_id: number, position: any, priority: number, message?: string)
---Queues a spell that skips global cooldown with a position.
---@field public queue_spell_position_fast fun(self: spell_queue, spell_id: number, position: any, priority: number, message?: string)