
-- Example:
-- ---@type movement_handler
-- local x = require("common/utility/movement_handler")
-- x: -> IntelliSense
-- Warning: Access with ":", not "."

---@class movement_handler
---@field public pause_movement fun(self: movement_handler, seconds: number): nil
---@field public resume_movement fun(self: movement_handler, seconds: number): nil
---@field public on_process fun(self: movement_handler): nil
---@field public start_move_forward fun(self: movement_handler, walk_duration: number, delay?: number): nil
---@field public stop_move_forward fun(self: movement_handler): nil
---@field public start_strafe_left fun(self: movement_handler, strafe_duration: number, delay?: number): nil
---@field public stop_strafe_left fun(self: movement_handler): nil
---@field public start_strafe_right fun(self: movement_handler, strafe_duration: number, delay?: number): nil
---@field public stop_strafe_right fun(self: movement_handler): nil

-- Example Usage:
-- local handler = require("common/utility/movement_handler")
-- handler:pause_movement(2.0) -- Pauses movement for 2 seconds
-- handler:resume_movement(0.0) -- Instantly resumes movement
-- handler:on_process() -- Call every frame
-- handler:start_move_forward(5.0, 1.0) -- Starts moving forward for 5 seconds after a 1-second delay
-- handler:stop_move_forward() -- Stops moving forward
-- handler:start_strafe_left(3.0) -- Strafes left for 3 seconds
-- handler:stop_strafe_left() -- Stops strafing left
-- handler:start_strafe_right(4.0, 2.0) -- Strafes right for 4 seconds after a 2-second delay
-- handler:stop_strafe_right() -- Stops strafing right
