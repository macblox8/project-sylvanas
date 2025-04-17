

<Buffs _ Project Sylvanas.html>
Buffs | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Buffs
On this page
Buffs
Overview​
The Lua Buff Class provides a way to represent buffs in Lua scripts. Buffs are temporary enhancements or negative effects (debuffs) applied to game characters (players and npcs). For example, a deffensive cooldown would be a buff and a poison applied to an enemy would be a debuff. This is very basic, but we aim to be beginner friendly and welcome everybody abroad 🌟
The Way Raw Buffs and Debuffs Work
In WoW, buffs and debuffs are essentially a (usually) large list for each game_object. As you can imagine, checking every frame every buff for every unit in the game is very
expensive CPU-wise. So, if you were to use the raw buffs given by Blizzard to check every frame, for example, if you have one buff up that would make you deal more dmg, you would quickly realize how your FPS take a slight hit, since your PC has to also go through all other irrelevant buffs. This scalates with the number of units for which you are checking buffs or debuffs. So, let's say you are an affliction warlock and your script is checking how many units around you have Corruption; or maybe you are a resto druid and you are checking how many dots from you does everyone on your party have: in this case,
your FPS will take a big hit. 💣💣
How To: Retrieve Buffs and Debuffs Information 📃​
To get the buffs and debuffs info from a unit, we have 2 choices:
1 - Raw 💣​
1 - Using Raw Buffs and Debuffs
For the reasons explained in the previous point, this method is not recommended in most cases. However, you are still allowed to use it (at your own risk).
Acessing to the game_object function get_buffs() we can get the table of buffs. For the debuffs, we can just use get_debuffs(). This function will return a table with the following elements:
.buff_name (string)
.buff_id (integer)
.count (integer)
.expire_time (number)
.duration (number)
.type (integer)
.caster (game_object)
Here is the code to print all (raw) buffs information for a given unit:
---@param target game_object
local function print_buffs_info(target)
--- buff_name - string
--- buff_id - integer
--- count - number
--- expire_time - number
--- duration - number
--- type - integer
--- caster - game_object
local buffs = target:get_buffs()
for k, buff in ipairs(buffs) do
core.log("Buff name: " .. buff.buff_name)
core.log("Buff id: " .. tostring(buff.buff_id))
core.log("Buff Stacks: " .. tostring(buff.count))
core.log("Buff Expire Time: " .. tostring(buff.expire_time))
core.log("Buff Duration: " .. tostring(buff.duration))
core.log("Buff Type: " .. tostring(buff.type))
core.log("Buff Caster: " .. buff.caster:get_name())
core.log("- - - - - - - - - - - - - - - - - - - - - - - - - - -")
end
end
Here is the code to print all (raw) debuffs information for a given unit:
---@param target game_object
local function print_debuffs_info(target)
--- buff_name - string
--- buff_id - integer
--- count - number
--- expire_time - number
--- duration - number
--- type - integer
--- caster - game_object
local debuffs = target:deget_buffs()
for k, debuff in ipairs(buffs) do
core.log("Buff name: " .. debuff.buff_name)
core.log("Buff id: " .. tostring(debuff.buff_id))
core.log("Buff Stacks: " .. tostring(debuff.count))
core.log("Buff Expire Time: " .. tostring(debuff.expire_time))
core.log("Buff Duration: " .. tostring(debuff.duration))
core.log("Buff Type: " .. tostring(debuff.type))
core.log("Buff Caster: " .. debuff.caster:get_name())
core.log("- - - - - - - - - - - - - - - - - - - - - - - - - - -")
end
end
This is what you will be seeing in the console after running the showcased code (in this case, the parameter was local_player)
2 - Buff Manager Module 🔥​
2 - Using Our Custom-Made Buffs Module
For the reasons already explained, we recommend using this module to check buffs information, since we have a special cache system that reduces FPS impact to almost zero.
The usage is very simple, you just have to import 2 modules: the enums module (although this is optional), and the buff_manager module.
Then, we just have to use either the buff_manager:get_buff_data() function or the buff_manager:get_debuff_data() function, depending on if we want to check the information of a buff or a debuff.
So, to get a specific buff information, you could use this code:
---@type buff_manager
local buff_manager = require("common/modules/buff_manager")
---@type enums
local enums = require("common/enums")
---@param target game_object
local function print_buffs_info(target)
local buff_info = buff_manager:get_buff_data(target, enums.buff_db.BARSKIN)
core.log("Is Buff Active: " .. tostring(buff_info.is_active))
core.log("Buff Remaining: " .. tostring(buff_info.remaining)) -- in MILISECONDS (ms)
core.log("Buff Stacks: " .. tostring(buff_info.stacks))
core.log("- - - - - - - - - - - - - - - - - - - - - - - - -")
end
And to get a specific debuff information, you could use this code:
---@type buff_manager
local buff_manager = require("common/modules/buff_manager")
---@type enums
local enums = require("common/enums")
---@param target game_object
local function print_buffs_info(target)
local debuff_info = buff_manager:get_debuff_data(target, enums.buff_db.BARSKIN)
core.log("Is Buff Active: " .. tostring(debuff_info.is_active))
core.log("Buff Remaining: " .. tostring(debuff_info.remaining)) -- in MILISECONDS (ms)
core.log("Buff Stacks: " .. tostring(debuff_info.stacks))
core.log("- - - - - - - - - - - - - - - - - - - - - - - - -")
end
Parameters:
1- target (game_object) (the unit to check the buffs/debuffs)
2- buff_ids (table of integers) (this is a TABLE)
3- custom_cache_duration (number) (the unit to check the buffs/debuffs)
note
The parameters are the same, for both get_debuff_data and get_buff_data functions.
Brief Explanation Of The Parameters
1- Target:
This is just the game_object that we want to analyze the buffs or debuffs of.
2- Buff IDs:
This is a table that contains the possible IDs of the same buff or debuff. For example, let's say you have the buff named "Shiny Day". There might be something that alters the ID of this buff, in most cases a spec change. However, the buff is still "Shiny Day", and its functionality might even remain the same. This is a good reason why we are using a table here, so we can catch the buff or debuff even if it has multiple possible IDs. However, the most important reason for us to use a table is so that the buffs are compatible across all game versions, since all of them are expected to be supported in the future. For example, the "Rend" debuff might have a different ID in WoW Classic than in Retail. If the buff or debuff that you are trying to analyze only has one ID, you can just pass a table containing this one ID.
3- Custom Cache Duration:
This is an optional parameter and should usually not be modified. This is useful in some specific cases where you want the cache to renew very quickly (or slowly), for some buffs that only appear a very brief of time, for example. However, this is very rare and take into account that modifying this parameter might affect FPS.
This is how our console would look like after running the previous code passing an active buff id as parameter:
How To: Recommended Workflow With Buffs and Debuffs 📃​
The Way We Work
We offer you multiple tools to check all buffs and debuffs information of any unit. In the "Developer Tools" tab, in the main menu, you will find the following tools:
The buttons functionalities are self-explanatory. Everything will be printed to the console uppon pressing. This is useful to find, for example, the ID of a buff or a debuff that is not added to our buffs db (located in enums) and that you might need.
Another option is to use the Debug Panel, located just below "Benchmark Plugin" in the
"Developer Tools" menu.
The buttons are, again, self-explanatory. Upon pressing them, a new window (made completely in LUA using our custom GUI. Check Custom UI to learn how to make your own visuals) will appear showing all the information available for the selected unit in the "Mode" combobox.
tip
When you already know all the buffs and the debuffs that you are going to use, and have all of their IDs stored or know that they are in the buffs database, you can begin using them. If you are going to need the same buff or debuff information in multiple places of your code, maybe you should consider sepparating the said buff or debuff information into a function that you can call multiple times.
For example:
---@return boolean
---@param target game_object
local function has_hunters_mark(target)
local buff_data = buff_manager:get_debuff_data(target, enums.buff_db.HUNTERS_MARK)
return buff_data.is_active
end
--- Or, alternatively, using a custom buff ID table:
---@return boolean
---@param target game_object
local function has_hunters_mark(target)
local possible_hunters_mark_debuff_ids = {257284, }
local buff_data = buff_manager:get_debuff_data(target, possible_hunters_mark_debuff_ids)
return buff_data.is_active
end
Then, we can call has_hunters_mark(target) as many times as we want more easily.
Previous
Game Object - Code Examples
Next
Spell Book - Raw Functions
Overview
How To: Retrieve Buffs and Debuffs Information 📃1 - Raw 💣
2 - Buff Manager Module 🔥
How To: Recommended Workflow With Buffs and Debuffs 📃
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Buffs _ Project Sylvanas.html>

<Combat Forecast Library _ Project Sylvanas.html>
Combat Forecast Library | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
Combat Forecast Library
On this page
Combat Forecast Library
Overview​
The Combat Forecast module is designed to help developers make more informed decisions during combat by predicting the length of encounters and the potential impact of spells. This module integrates with Sylvanas’ core functionality to provide accurate combat data, enhancing strategies for PvE scenarios. Below, we'll delve into its core functions and how to effectively utilize them.
tip
You should check User Combat Forecast Guide to understand what this module is about in more depth
before starting to work with it.
Including the Module​
Like with all other LUA modules developed by us, you will need to import the health prediction module into your project.
To do so, you can just use the following lines:
---@type combat_forecast
local combat_forecast = require("common/modules/combat_forecast")
warning
To access the module's functions, you must use : instead of .
For example, this code is not correct:
---@type combat_forecast
local combat_forecast = require("common/modules/combat_forecast")
local function should_cast_hard_cast_spell(player)
local combat_length_simple = combat_forecast.get_forecast()
return combat_length_simple >= 3.0
end
And this would be the corrected code:
---@type combat_forecast
local combat_forecast = require("common/modules/combat_forecast")
local function should_cast_hard_cast_spell(player)
local combat_length_simple = combat_forecast:get_forecast()
return combat_length_simple >= 3.0
end
Functions​
Forecast Lengths Enum 📋​
forecast_lengths​
The forecast_lengths enum provides various lengths for combat forecasting:
DISABLED: No forecast applied.
VERY_SHORT: Forecast is for a very short duration.
SHORT: Forecast is for a short duration.
MEDIUM: Forecast is for a medium duration.
LONG: Forecast is for a long duration.
This enum is used to specify the expected length of a combat scenario when making logic decisions.
Combat Data Retrieval 📊​
get_forecast() -> number​
Retrieves the forecast data for the current combat situation. This function provides an overall view of the combat forecast, which can be used to adapt strategies on the fly.
get_forecast_single(unit: game_object, include_pvp?: boolean) -> number​
Fetches the forecast data specifically for a single unit, with an option to include PvP-related considerations. This is particularly useful for predicting the impact of spells on individual targets.
Minimum Combat Length 📈​
get_min_combat_length(forecast_mode: any, plugin_name: string, spell_name: string) -> number​
Determines the minimum combat length required for a specified forecast mode, plugin, and spell. This data helps in deciding whether to use long cooldown abilities or time-sensitive spells.
Forecast Logic Validation 📋​
is_valid_forecast_logic(min_combat_length: number, unit?: game_object, include_pvp?: boolean) -> boolean​
Validates the forecast logic based on the minimum combat length and the specified unit. This function ensures that actions are only taken if they align with the expected duration of the encounter, avoiding the misuse of cooldowns.
Usage Example and Best Practices​
Here is an example of how to implement the Combat Forecast module effectively in your code:
---@type combat_forecast
local combat_forecast = require("common/modules/combat_forecast")
local function should_cast_spell_based_on_global_forecast(spell_name)
local min_combat_length = combat_forecast:get_min_combat_length(combat_forecast.enum.SHORT, "my_plugin", spell_name)
local is_valid_logic = combat_forecast:is_valid_forecast_logic(min_combat_length)
if is_valid_logic then
core.log("Casting " .. spell_name .. " based on combat forecast")
return true
else
core.log("Skipping " .. spell_name .. " due to short combat forecast")
return false
end
end
Or, if we just want to check our main target:
---@type combat_forecast
local combat_forecast = require("common/modules/combat_forecast")
local function should_cast_spell_based_on_single_forecast(target, spell_name, forecast_max_time)
local combat_length_single = combat_forecast:get_forecast_single(target)
local is_valid_logic = combat_length_single <= forecast_max_time
if is_valid_logic then
core.log("Casting " .. spell_name .. " based on single - combat forecast")
return true
end
core.log("Skipping " .. spell_name .. " due to short single - combat forecast")
return false
end
Or, if we just want a quick, simple check for general usage (eg. not a very important spell)
---@type combat_forecast
local combat_forecast = require("common/modules/combat_forecast")
local function should_cast_spell_based_on_general_forecast(target, spell_name, forecast_max_time)
local combat_length_simple = combat_forecast:get_forecast()
local is_valid_logic = combat_length_single <= forecast_max_time
if is_valid_logic then
core.log("Casting " .. spell_name .. " based on single - combat forecast")
return true
end
core.log("Skipping " .. spell_name .. " due to short single - combat forecast")
return false
end
Best Practice Tip​
tip
Always ensure that you validate the combat length before casting spells with
long cooldowns or spells that have a
long cast time. This approach will prevent unnecessary use of critical abilities in short fights, optimizing your overall strategy.
Previous
Spell Prediction
Next
Health Prediction Library
Overview
Including the Module
FunctionsForecast Lengths Enum 📋
forecast_lengths
Combat Data Retrieval 📊
get_forecast() -> number
get_forecast_single(unit: game_object, include_pvp?: boolean) -> number
Minimum Combat Length 📈
get_min_combat_length(forecast_mode: any, plugin_name: string, spell_name: string) -> number
Forecast Logic Validation 📋
is_valid_forecast_logic(min_combat_length: number, unit?: game_object, include_pvp?: boolean) -> boolean
Usage Example and Best PracticesBest Practice Tip
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Combat Forecast Library _ Project Sylvanas.html>

<Dungeons Helper _ Project Sylvanas.html>
Dungeons Helper | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
Dungeons Helper
On this page
Dungeons Helper
Overview​
The Dungeons Helper module provides a comprehensive set of utility functions that aims to make your life easier when trying to gather information about dungeons. Below, we'll explore its functionality.
Including the Module​
As with all other LUA modules developed by us, you will need to import the Dungeons Helper module into your project. To do so, you can use the following lines:
---@type dungeons_helper
local dungeons_helper = require("common/utility/dungeons_helper")
warning
To access the module's functions, you must use : instead of .
For example, this code is not correct:
---@type dungeons_helper
local dungeons_helper = require("common/utility/dungeons_helper")
local function check_if_player(unit)
return dungeons_helper.is_mythic_dungeon(unit)
end
And this would be the corrected code:
---@type inventory_helper
local dungeons_helper = require("common/utility/dungeons_helper")
local function is_player_in_mythic_dungeon()
return dungeons_helper:is_mythic_dungeon()
end
Functions​
is_mythic_dungeon() -> boolean​
Returns true if the local player is currently in a Mythic dungeon.
Returns:
boolean -> True if the local player is currently in a Mythic dungeon, false otherwise.
get_mythic_key_level() -> integer​
Retrieves the key level of the current Mythic dungeon.
Returns:
key level integer: The key level of the current Mythic dungeon.
is_kite_exception() -> boolean​
Checks if we are on kite exception.
Returns:
boolean: If we are on kite exception.
game_object | nil:
game_object | nil:
is_kikatal_near_cosmic_cast(energy_threshold: number) -> boolean​
Checks if kikatal is near a cosmic cast within a given energy threshold.
Returns:
boolean: If Kikatal is near cosmic cast.
game_object | nil:
is_kikatal_grasping_blood_exception() -> boolean, game_object | nil, game_object | nil​
Checks if we are under a kikatal grasping blood exception.
Returns:
boolean: If Kikatal is near cosmic cast.
game_object | nil:
game_object | nil:
Previous
Inventory Helper
Next
Custom UI Functions 🪖
Overview
Including the Module
Functionsis_mythic_dungeon() -> boolean
get_mythic_key_level() -> integer
is_kite_exception() -> boolean
is_kikatal_near_cosmic_cast(energy_threshold: number) -> boolean
is_kikatal_grasping_blood_exception() -> boolean, game_object | nil, game_object | nil
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Dungeons Helper _ Project Sylvanas.html>

<Control Panel _ Project Sylvanas.html>
Control Panel | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Control Panel
On this page
Control Panel
Overview​
The control_panel module is essentially a separate unique graphical window that allows the user to track and easily modify the state of specific menu elements whose values are of special importance or are designed to be modified constantly, so the user doesn't have to open the main menu every time. This is usually how the Control Panel might look like for an average user:
How it Works - Basic Explanation
To add elements to the Control Panel, we need to use a specific callback. The core is expecting a table containing some information on the menu elements that are going to be shown in the Control Panel window to return from that callback. When this information is correct, the menu elements can be displayed in the Control Panel window, allowing them to be modified by clicking on them.
note
Drag & Drop is also supported, although this approach requires a special handling that will be covered later.
How to Make it Work - Step by Step (With an Example)​
1- Include the Necessary Plugins
---@type key_helper
local key_helper = require("common/utility/key_helper")
---@type control_panel_helper
local control_panel_utility = require("common/utility/control_panel_helper")
2- Define your menu elements:
local combat_mode_enum =
{
AUTO = 1,
AOE = 2,
SINGLE = 3,
}
local combat_mode_options =
{
"Auto",
"AoE",
"Single"
}
local test_tree_node = core.menu.tree_node()
local menu =
{
-- note that we are initializing the keybinds with the value "7". This value corresponds to <span style={{color: "rgba(220, 220, 255, 0.6)"}}>"Unbinded"</span>.
-- We do this so the user has to manually set the key they want. Otherwise, this menu element won't appear
-- in the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span>, and will be treated as if its value were true.
enable_toggle = core.menu.keybind(7, false, "enable_toggle"),
switch_combat_mode = core.menu.keybind(7, false, "switch_combat_mode"),
soft_cooldown_toggle = core.menu.keybind(7, false, "soft_cooldown_toggle"),
heavy_cooldown_toggle = core.menu.keybind(7, false, "heavy_cooldown_toggle"),
combat_mode = core.menu.combobox(combat_mode_enum.AUTO, "combat_mode_auto_aoe_single"),
}
3- Define the Function to Render your Menu Elements:
local function on_render_menu_elements()
test_tree_node:render("Testing <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> Elements", function()
menu.enable_toggle:render("Enable Toggle")
menu.switch_combat_mode:render("Switch Combat Mode")
menu.soft_cooldown_toggle:render("Soft Cooldowns Toggle")
menu.combat_mode:render("Combat Mode", combat_mode_options)
end)
end
4- Define the Callback Function
local function on_control_panel_render()
-- this is how we build the toggle table that we return from the callback, as previously discussed:
local enable_toggle_key = menu.enable_toggle:get_key_code()
-- toggle table -> must have:
-- member 1: .name
-- member 2: .keybind (the menu element itself)
local enable_toggle =
{
name = "[My Plugin] Enable (" .. key_helper:get_key_name(enable_toggle_key) .. ") ",
keybind = menu.enable_toggle
}
local soft_toggle_key = menu.soft_cooldown_toggle:get_key_code()
local soft_cooldowns_toggle =
{
name = "[My Plugin] Soft Cooldowns (" .. key_helper:get_key_name(soft_toggle_key) .. ") ",
keybind = menu.soft_cooldown_toggle
}
-- combo table -> must have:
-- member 1: .name
-- member 2: .combobox (the menu element itself)
-- member 3: .preview_value (the current value that the combobox has, in string format)
-- member 4: .max_items (the amount of items that the combobox has)
local combat_mode_key = menu.switch_combat_mode:get_key_code()
local combat_mode = {
name = "[My Plugin] Combat Mode (" .. key_helper:get_key_name(combat_mode_key) .. ") ",
combobox = menu.combat_mode,
preview_value = combat_mode_options[menu.combat_mode:get()],
max_items = combat_mode_options
}
local hard_toggle_key = menu.heavy_cooldown_toggle:get_key_code()
local hard_cooldowns_toggle =
{
name = "[My Plugin] Hard Cooldowns (" .. key_helper:get_key_name(hard_toggle_key) .. ") ",
keybind = menu.heavy_cooldown_toggle
}
-- finally, we define the table that we are going to return from the callback
local control_panel_elements = {}
-- we use the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> utility to insert this menu element in the table that we are going to return. This function has
-- code that internally handles stuff related to <span style={{color: "rgba(150, 250, 200, 0.8)"}}>Drag & Drop</span>, so if you want to enable this functionality you must insert the
-- menu elements by using this table. Otherwise, you could just return the elements without using the ccontrol_panel_helper plugin,
-- but this way is recommended anyways for scalability reasons.
control_panel_utility:insert_toggle_(control_panel_elements, enable_toggle.name, enable_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, soft_cooldowns_toggle.name, soft_cooldowns_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, hard_cooldowns_toggle.name, hard_cooldowns_toggle.keybind, false)
control_panel_utility:insert_combo_(control_panel_elements, combat_mode.name, combat_mode.combobox,
combat_mode.preview_value, combat_mode.max_items, main_menu.switch_combat_mode, false)
return control_panel_elements
end
5- Use the Callbacks
-- finally, we just need to implement the callbacks. If we want drag and drop, we must also call on_update.
core.register_on_update_callback(function()
control_panel_utility:on_update(menu)
end)
core.register_on_render_control_panel_callback(on_control_panel_render)
core.register_on_render_menu_callback(on_render_menu_elements)
5- Summary
So far, this is all the code that we created:
---@type key_helper
local key_helper = require("common/utility/key_helper")
---@type control_panel_helper
local control_panel_utility = require("common/utility/control_panel_helper")
local combat_mode_enum =
{
AUTO = 1,
AOE = 2,
SINGLE = 3,
}
local combat_mode_options =
{
"Auto",
"AoE",
"Single"
}
local test_tree_node = core.menu.tree_node()
local menu =
{
-- note that we are initializing the keybinds with the value "7". This value corresponds to <span style={{color: "rgba(220, 220, 255, 0.6)"}}>"Unbinded"</span>.
-- We do this so the user has to manually set the key they want. Otherwise, this menu element won't appear
-- in the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span>, and will be treated as if its value were true.
enable_toggle = core.menu.keybind(7, false, "enable_toggle"),
switch_combat_mode = core.menu.keybind(7, false, "switch_combat_mode"),
soft_cooldown_toggle = core.menu.keybind(7, false, "soft_cooldown_toggle"),
heavy_cooldown_toggle = core.menu.keybind(7, false, "heavy_cooldown_toggle"),
combat_mode = core.menu.combobox(combat_mode_enum.AUTO, "combat_mode_auto_aoe_single"),
}
local function on_render_menu_elements()
test_tree_node:render("Testing <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> Elements", function()
menu.enable_toggle:render("Enable Toggle")
menu.switch_combat_mode:render("Switch Combat Mode")
menu.soft_cooldown_toggle:render("Soft Cooldowns Toggle")
menu.heavy_cooldown_toggle:render("Heavy Cooldowns Toggle")
menu.combat_mode:render("Combat Mode", combat_mode_options)
end)
end
local function on_control_panel_render()
-- this is how we build the toggle table that we return from the callback, as previously discussed:
local enable_toggle_key = menu.enable_toggle:get_key_code()
-- toggle table -> must have:
-- member 1: .name
-- member 2: .keybind (the menu element itself)
local enable_toggle =
{
name = "[My Plugin] Enable (" .. key_helper:get_key_name(enable_toggle_key) .. ") ",
keybind = menu.enable_toggle
}
local soft_toggle_key = menu.soft_cooldown_toggle:get_key_code()
local soft_cooldowns_toggle =
{
name = "[My Plugin] Soft Cooldowns (" .. key_helper:get_key_name(soft_toggle_key) .. ") ",
keybind = menu.soft_cooldown_toggle
}
-- combo table -> must have:
-- member 1: .name
-- member 2: .combobox (the menu element itself)
-- member 3: .preview_value (the current value that the combobox has, in string format)
-- member 4: .max_items (the amount of items that the combobox has)
local combat_mode_key = menu.switch_combat_mode:get_key_code()
local combat_mode = {
name = "[My Plugin] Combat Mode (" .. key_helper:get_key_name(combat_mode_key) .. ") ",
combobox = menu.combat_mode,
preview_value = combat_mode_options[menu.combat_mode:get()],
max_items = combat_mode_options
}
local hard_toggle_key = menu.heavy_cooldown_toggle:get_key_code()
local hard_cooldowns_toggle =
{
name = "[My Plugin] Hard Cooldowns (" .. key_helper:get_key_name(hard_toggle_key) .. ") ",
keybind = menu.heavy_cooldown_toggle
}
-- finally, we define the table that we are going to return from the callback
local control_panel_elements = {}
-- we use the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> utility to insert this menu element in the table that we are going to return. This function has
-- code that internally handles stuff related to <span style={{color: "rgba(150, 250, 200, 0.8)"}}>Drag & Drop</span>, so if you want to enable this functionality you must insert the
-- menu elements by using this table. Otherwise, you could just return the elements without using the ccontrol_panel_helper plugin,
-- but this way is recommended anyways for scalability reasons.
control_panel_utility:insert_toggle_(control_panel_elements, enable_toggle.name, enable_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, soft_cooldowns_toggle.name, soft_cooldowns_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, hard_cooldowns_toggle.name, hard_cooldowns_toggle.keybind, false)
control_panel_utility:insert_combo_(control_panel_elements, combat_mode.name, combat_mode.combobox,
combat_mode.preview_value, combat_mode.max_items, menu.switch_combat_mode, false)
return control_panel_elements
end
-- finally, we just need to implement the callbacks. If we want drag and drop, we must also call on_update.
core.register_on_update_callback(function()
control_panel_utility:on_update(menu)
end)
core.register_on_render_control_panel_callback(on_control_panel_render)
core.register_on_render_menu_callback(on_render_menu_elements)
If you run that code, you will see the following result:
Control Panel Behaviour Explanation​
As you can see in the previous video, the user can remove and add elements from the Control Panel manually. There are 2 ways to do this:
1- The menu element was dragged and dropped: In this case, the user can remove the element from the Control Panel by double-clicking with the right-mouse button on its hitbox.
2- The menu element keybind was set:
The user can also make the menu elements appear just by changing the keybind to another key different than the "Unbinded" one. In the same way, a user can remove an element from the Control Panel by setting its key value to "Unbinded" again (right clicking sets the value to default, which in the code example is "Unbinded" or "7").
note
To drag a menu element that has Drag & Drop enabled, you have to press SHIFT and then click. When the Drag & Drop is ready, you will see a box with the menu element name appear. Then, you can drag the said box to the Control Panel. When the Control Panel is higlighted in green, you can drop the box there. After that, you will see that the menu element is now successfully binded to the Control Panel.
warning
If a menu element was dragged and dropped in the Control Panel, setting its value to "Unbinded" won't remove it from the Control Panel. Instead, RMB double-click is mandatory.
Likewise, if a menu element was introduced to the Control Panel by setting its value to one different than "Unbinded", RMB double-click won't remove it from the Control Panel.
Tables Expected By The Callback​
1 - Toggle table
This table is reserved for toggle keybinds.
Its members must be the following:
1. name: The label that will appear in the Control Panel (string)
2. keybind: The keybind itself (menu_element)
2 - Combobox table
This table is reserved for comboboxes.
Its members must be the following:
1. name: The label that will appear in the Control Panel (string)
2. combobox: The combobox itself (menu_element)
3. preview_value`: The current value that the combobox currently has, in string format. (string)
4. max_items: The items that the combobox has (integer)
Registering the Callback​
The procedure is the same as with all other callbacks:
warning
Keep in mind that this callback expects a table as a return value. This is the only callback that expects a return value.
core.register_on_render_control_panel_callback(function()
local menu_elements_table = {}
-- your control panel code here
return menu_elements
end)
Or:
local function on_render_control_panel()
local menu_elements_table = {}
-- your control panel code here
return menu_elements
end
core.register_on_render_control_panel_callback(on_render_control_panel)
note
To use the following functions, you will need to include the Control Panel Helper module. To do this, you can just copy these lines:
---@type control_panel_helper
local control_panel_utility = require("common/utility/control_panel_helper")
Functions - Control Panel Helper​
on_update(menu)​
Updates the Control Panel elements by setting drag-and-drop flags based on the current Control Panel label.
Parameters:
menu (table) — The menu containing Control Panel elements to be updated.
Returns: nil
warning
You must call this function inside the on_update callback for Drag & Drop functionality to work for your menu elements. Ideally, call this function the first thing on your on_update function.
If this function is not called, Drag & Drop will not work.
insert_toggle(control_panel_table, toggle_table, only_drag_drop)​
Inserts a toggle into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the toggle will be inserted.
toggle_table (table) — The table containing the toggle element details.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the toggle was inserted successfully; otherwise, false.
insert_toggle_(control_panel_table, display_name, keybind_element, only_drag_drop)​
Inserts a toggle into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the toggle will be inserted.
display_name (string) — The name to be displayed for the toggle element.
keybind_element (userdata) — The keybind menu element.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the toggle was inserted successfully; otherwise, false.
insert_combo(control_panel_table, combo_table, increase_index_key, only_drag_drop)​
Inserts a combobox into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the combo will be inserted.
combo_table (table) — The table containing the combo element details.
increase_index_key (userdata, optional) — The keybind to increase the index, if applicable.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the combo was inserted successfully; otherwise, false.
insert_combo_(control_panel_table, display_name, combobox_element, preview_value, max_items, increase_index_key, only_drag_drop)​
Inserts a combobox into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the combo will be inserted.
display_name (string) — The name to be displayed for the combo element.
combobox_element (userdata) — The combobox menu element.
preview_value (any) — The preview value to be shown for the combobox.
max_items (number) — The maximum number of items in the combobox.
increase_index_key (userdata, optional) — The keybind to increase the index, if applicable.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the combo was inserted successfully; otherwise, false.
Previous
Geometry
Next
Vector 2
OverviewHow to Make it Work - Step by Step (With an Example)
Control Panel Behaviour Explanation
Tables Expected By The Callback
Registering the Callback
Functions - Control Panel Helperon_update(menu)
insert_toggle(control_panel_table, toggle_table, only_drag_drop)
insert_toggle_(control_panel_table, display_name, keybind_element, only_drag_drop)
insert_combo(control_panel_table, combo_table, increase_index_key, only_drag_drop)
insert_combo_(control_panel_table, display_name, combobox_element, preview_value, max_items, increase_index_key, only_drag_drop)
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Control Panel _ Project Sylvanas.html>

<Core _ Project Sylvanas.html>
Core | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Core
On this page
Core Functions
Overview​
This module contains a collection of essential functions that you will probably need sooner or later in your scripts. This module includes utilities for logging, callbacks, time management, and accessing game information.
Callbacks - Brief Explanation
This is essentially the most important part of scripting, since most of your code must be ran inside a callback.
What is a Callback?
A callback is a function that you write, which you then pass to the game engine or framework. The engine doesn't execute this function immediately. Instead, it "calls back" to your function at a specific time or when a particular event occurs in the game.
Think of it like leaving your phone number with a friend (the game engine) and asking them to call you (execute your function) when a certain event happens.
Why Use Callbacks?
Callbacks allow your game to respond to events without constantly checking for them. This makes your code more efficient and easier to manage. Instead of writing code that keeps asking, "Has the player pressed a button yet? Has an enemy appeared yet?" you can simply tell the game engine, "When this happens, run this function." So, all games use callbacks to run, and same with WoW.
Real-World Analogy
Imagine you're waiting for a package to be delivered. You don't stand by the door all day waiting for it (which would be like constantly checking in a loop). Instead, you might continue with your day, and when the doorbell rings (the event), you go to answer it (the callback function is executed).
What was explained is what is a callback in general in the context of videogames. In our case, we have multiple events that our callbacks will be listening to.
These are the following:
On Update — This is the callback that you will use to run your logic most of the time. The code placed inside this callback is called at a reduced speed, relative to the speed of On Render. It's ideal for logic that doesn't need to be executed every frame. In a game where 95% of spells have a global cooldown, 50% of spells are cast, and units move at 7 yards per second, you don't need to read all the information and check everything every frame. Doing so at 120 FPS means you're, for example, checking the position of all units 120 times per second, which is unnecessary. That's where On Update comes in.
On Render — This is a callback used only for rendering graphics, like rectangles, circles, etc. (See graphics). It is the most important and central callback, placed within the game inside DirectX in a part called EndScene. Every time DirectX is about to render something, this callback is called. That's why it's called On Render, and it's the callback that's called the most times of all—exactly once per frame. This allows the game to draw the graphics and call your callback so that you can draw at the same speed, neither one frame more nor less, ensuring it feels natural within the game. While you could place your logic here, common sense suggests otherwise.
On Render Menu — This is a callback used only for rendering menu elements. (See Menu Elements)
On Render Control Panel — This is a very specialized callback that will be used ONLY to handle the control panel elements. (See Control Panel)
On Spell Cast — This callback will only trigger if a spell is cast, so it might be useful to control some specific cooldowns or how your spells (or other game objects) are being cast.
On Legit Spell Cast — This callback will only trigger if a spell is MANUALLY cast by the player.
note
As you will see in the following examples, all callbacks expect you to pass a function. This function must contain all the code that will be read in the case that the event that the callback is listening to is triggered.
You can pass it anonymously:
core.register_on_render_callback(function()
-- your render code here
end)
Or you can pass a defined function:
local function all_my_render_code_function()
-- your render code here
end
core.register_on_render_callback(all_my_render_code_function)
On render callback was used just as an example, but this behaviour is the same for all available callbacks.
Callback Functions 🔄​
core.register_on_pre_tick_callback​
Syntax
core.register_on_pre_tick_callback(callback: function)
Parameters
callback: function - The function to be called before each game tick.
Description
Registers a callback function to be executed before each game tick.
Example Usage
core.register_on_pre_tick_callback(function()
-- Code to execute before each game tick
end)
core.register_on_update_callback​
Syntax
core.register_on_update_callback(callback: function)
Parameters
callback: function - The function to be called on each frame update.
Description
Registers a callback function to be executed on each frame update.
Example Usage
core.register_on_update_callback(function()
-- Code to execute every frame
end)
core.register_on_render_callback​
Syntax
core.register_on_render_callback(callback: function)
Parameters
callback: function - The function to be called during the render phase.
Description
Registers a callback function to be executed during the render phase.
Example Usage
local function on_render()
-- Rendering code here
end
core.register_on_render_callback(on_render)
core.register_on_render_menu_callback​
Syntax
core.register_on_render_menu_callback(callback: function)
Parameters
callback: function - The function to render custom menu elements.
Description
Registers a callback function to render custom menu elements.
warning
Avoid calling game functions within this callback. It should be used solely for rendering menus and variables.
Example Usage
local function render_menu()
-- Menu rendering code here
end
core.register_on_render_menu_callback(render_menu)
core.register_on_render_control_panel_callback​
Syntax
core.register_on_render_control_panel_callback(callback: function)
Parameters
callback: function - The function to render control panel elements.
Description
Registers a callback function to render control panel elements.
Example Usage
local function render_control_panel()
-- Control panel rendering code here
end
core.register_on_render_control_panel_callback(render_control_panel)
core.register_on_spell_cast_callback​
Syntax
core.register_on_spell_cast_callback(callback: function)
Parameters
callback: function - The function to be called when any spell is cast.
Description
Registers a callback function that is invoked whenever any spell is cast in the game, including spells cast by the player, allies, and enemies.
Example Usage
local function on_spell_casted(data)
-- Access spell data
local spell_name = core.spell_book.get_spell_name(data.spell_id)
core.log(string.format("Spell cast detected: %s", spell_name))
end
core.register_on_spell_cast_callback(on_spell_casted)
core.register_on_legit_spell_cast_callback​
Syntax
core.register_on_legit_spell_cast_callback(callback: function)
Parameters
callback: function - The function to be called when the local player casts a spell, including unsuccessful attempts.
Description
Registers a callback function that is invoked when the local player casts a spell, including unsuccessful attempts.
Example Usage
local function on_legit_spell_cast(data)
-- Handle local player's spell cast
end
core.register_on_legit_spell_cast_callback(on_legit_spell_cast)
note
The "data" parameter is filled with the ID of the spell that was just casted. You can check the way this callback works by adding a
core.log(tostring(data)) call inside the function called by the callback.
Logging - An Important Tool 🔥​
Use Logs In Your Code!
Adding debug logs is a very powerfull tool that you should use in all your plugins. This will help you find bugs and typos very easily. One option that we recommend is that you add a debug local variable (boolean) at the top of your code. When true, the debug for your code will be enabled. For example:
local debug = false
local function my_logics()
local is_check_1_ok = true
if not is_check_1_ok then
if debug then
core.log("Check 1 is not ok! .. aborting logics because of it - -")
end
return false
end
local is_check_2_ok = true
if not is_check_2_ok then
if debug then
core.log("Check 2 is not ok! .. aborting logics because of it - -")
end
return false
end
if debug then
core.log("All checks were ok! .. Running logics succesfully!")
end
return true
end
Obviously, this is a very simple example without any real logic or functionality, but it was showcased here just so you see the recommended workflow. All these prints will only work if your debug variable is true, which is something you can change in less than a second.
Logging - Functions 📄​
core.log​
Syntax
core.log(message: string)
Parameters
message: string - The message to log.
Description
Logs a standard message.
Example Usage
core.log("This is a standard log message.")
tip
Use LUA's in-built strings function to format your logs. For example, to pass from boolean or number to string, you would have to use the tostring() function.
Example: Logging the cooldown of a spell:
local function print_spell_cd(spell_id)
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local spell_cd = core.spell_book.get_spell_cooldown(spell_id)
core.log("Remaining Spell (ID: " .. tostring(spell_id) .. ") CD: " .. tostring(spell_cd) .. "s")
end
core.log_error​
Syntax
core.log_error(message: string)
Parameters
message: string - The error message to log.
Description
Logs an error message.
Example Usage
core.log_error("An error has occurred.")
core.log_warning​
Syntax
core.log_warning(message: string)
Parameters
message: string - The warning message to log.
Description
Logs a warning message.
Example Usage
core.log_warning("This is a warning message.")
core.log_file​
Syntax
core.log_file(message: string)
Parameters
message: string - The message to log to a file.
Description
Logs a message to a file.
warning
Access to log files may be restricted due to security considerations.
Example Usage
core.log_file("Logging this message to a file.")
Time and Performance Functions ⏱️​
core.get_ping​
Syntax
core.get_ping() -> number
Returns
number: The current network ping.
Description
Retrieves the current network ping.
Example Usage
local ping = core.get_ping()
core.log("Current ping: " .. ping .. " ms")
core.time​
Syntax
core.time() -> number
Returns
number: The time in milliseconds since the script was injected.
Description
Returns the time elapsed since the script was injected.
Example Usage
local script_time = core.time()
core.log("Time since script injection: " .. script_time .. " ms")
core.game_time​
Syntax
core.game_time() -> number
Returns
number: The time in milliseconds since the game started.
Description
Returns the time elapsed since the game started.
Example Usage
local game_time = core.game_time()
core.log("Game time elapsed: " .. game_time .. " ms")
core.delta_time​
Syntax
core.delta_time() -> number
Returns
number: The time in milliseconds since the last frame.
Description
Returns the time elapsed since the last frame.
Example Usage
local dt = core.delta_time()
-- Use dt for frame-dependent calculations
core.cpu_time​
Syntax
core.cpu_time() -> number
Returns
number: The CPU time used.
Description
Retrieves the CPU time used.
Example Usage
local cpu_time = core.cpu_time()
core.log("CPU time used: " .. cpu_time)
core.cpu_ticks_per_second​
Syntax
core.cpu_ticks_per_second() -> number
Returns
number: The number of CPU ticks per second.
Description
Retrieves the number of CPU ticks per second.
Example Usage
local ticks_per_second = core.cpu_ticks_per_second()
core.log("CPU ticks per second: " .. ticks_per_second)
Game Information Functions 🗺️​
core.get_map_id​
Syntax
core.get_map_id() -> number
Returns
number: The current map ID.
Description
Retrieves the ID of the current map.
Example Usage
local map_id = core.get_map_id()
core.log("Current map ID: " .. map_id)
core.get_map_name​
Syntax
core.get_map_name() -> string
Returns
string: The name of the current map.
Description
Retrieves the name of the current map.
Example Usage
local map_name = core.get_map_name()
core.log("Current map: " .. map_name)
core.get_cursor_position​
Syntax
core.get_cursor_position() -> vec2
Returns
vec2: The current cursor position.
Description
Retrieves the current cursor position on the screen.
Example Usage
local cursor_pos = core.get_cursor_position()
core.log(string.format("Cursor position: (%.2f, %.2f)", cursor_pos.x, cursor_pos.y))
core.get_instance_id()​
Syntax
core.get_instance_id() -> integer
Returns
integer: the ID of the current instance.
core.get_instance_name()​
Syntax
core.get_instance_name() -> string
Returns
string: the name of the current instance.
core.get_difficulty_id()​
Syntax
core.get_difficulty_id() -> integer
Returns
integer: the ID of the current instance difficulty.
core.get_difficulty_name()​
Syntax
core.get_difficulty_name() -> string
Returns
string: the name of the current instance's difficulty.
Inventory 🗺️​
note
See Inventory Helper for more info.
core.inventory.get_items_in_bag(id: integer) -> table<item_slot_info>​
Retrieves all items in the bag with the specified ID.
Syntax
core.inventory.get_items_in_bag(id) -> table<item_slot_info>
Returns
table<item_slot_info>: A table containing the item data.
note
The item slot info contains 2 members:
.slot_id -> the id of the slot
.object -> the item itself (game_object)
Description
This function returns all the items in the bag with the ID that you pass as parameter. This is a low-level function, and we recommend, like always, to use our LUA libraries that we crafted so the development is easier for everyone. For mor info, check out the Inventory Helper library.
note
-2 for the keyring
-4 for the tokens bag
0 = backpack, 1 to 4 for the bags on the character
While bank is opened:
-1 for the bank content
5 to 11 for bank bags (numbered left to right, was 5-10 prior to tbc expansion, 2.0 game version)
Check https://wowwiki-archive.fandom.com/wiki/BagId for more info.
Additional Notes 📝​
Performance Monitoring: Utilize the time and CPU functions to monitor and optimize your script's performance.
Event Handling: Register appropriate callbacks to handle events effectively within your script.
Logging Best Practices: Consistently log important information for easier debugging and maintenance.
Previous
Getting Started
Next
Object Manager
Overview
Callback Functions 🔄core.register_on_pre_tick_callback
core.register_on_update_callback
core.register_on_render_callback
core.register_on_render_menu_callback
core.register_on_render_control_panel_callback
core.register_on_spell_cast_callback
core.register_on_legit_spell_cast_callback
Logging - An Important Tool 🔥Logging - Functions 📄
core.log
core.log_error
core.log_warning
core.log_file
Time and Performance Functions ⏱️core.get_ping
core.time
core.game_time
core.delta_time
core.cpu_time
core.cpu_ticks_per_second
Game Information Functions 🗺️core.get_map_id
core.get_map_name
core.get_cursor_position
core.get_instance_id()
core.get_instance_name()
core.get_difficulty_id()
core.get_difficulty_name()
Inventory 🗺️core.inventory.get_items_in_bag(id: integer) -> table<item_slot_info>
Additional Notes 📝
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Core _ Project Sylvanas.html>

<Getting Started _ Project Sylvanas.html>
Getting Started | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
On this page
Getting Started
Overview​
In this document, you will learn how to setup your environment and begin developing scripts for Sylvanas. We will try to cover as much information as possible in this short guide, but if you still have any questions you can contact us and we will gladly help you as soon as possible. If you don't have your loader/user setup yet, check Getting Started - User Guide before continuing with this guide.
Welcome Letter
First of all, thanks for your interest in developing scripts for Sylvanas. Since we are internal, we have our
own custom-made Lua API that is nothing like the WoW one, which can make it seem like working with us is more difficult than what you might be used to; this is why we will always appreciate your hard work and dedication, as we are aware that not everybody would be able to tackle such challenges. As a fellow developer, you will earn our respect; active developers will enjoy a series of unique benefits. We still don't know the specifics, but one thing is for sure: you will have a
free subscription as long as you are active. As for the other benefits that we are planning, we can't discuss them all with you yet, but more information will be shared as soon as possible. Among these benefits, we are thinking of monetization support for some Lua Scripts.
Without further ado, let's begin programming!
Getting Started​
note
You can skip this part if you already have Visual Studio Code installed and the sumneko Lua extension installed and enabled.
First of all, we have to setup our IDE. You can program even with a notepad if you want, but we recommend you to follow this small tutorial, since we provide with intellisense mechanisms that are only available on Visual Studio Code with the sumneko Lua extension. (You can ignore the first 2 steps if you already have Visual Studio Code installed)
Navigate to Visual Studio Code - Official Page
Click on the "Download for Windows" button and install the program.
Open Visual Studio Code
Navigate to the extensions section (on the left bar, the second icon starting from the botton). Then, search "LUA" and install the first plugin that appears. (Check that the developer is "sumneko", just in case).
Now, our IDE is good to go. The next step is to prepare our scripting development environment.
Go to the folder where you have placed your loader
Locate the "Scripts" folder and place yourself inside of it.
There, you will see many encripted scripts that were donwloaded after you logged into your account using the loader.
The files that are required for you to develop your scripts are "Common" and the ones starting with "Core". Developer tools and prediction playground are nice to have too. (Although we recommend to not modify the initial Scripts folder)
Create a folder inside the scripts folder. For example, "script_plugin_test"
Inside "script_plugin_test", we will create 2 files: header.lua and main.lua
Now, everything is almost ready to actually begin coding.
note
You can also just download the example plugin below. (Although downloading it from the Github repo is recommended, so you can be sure that you are downloading the latest version.)
Checking the API file​
The Lua plugin that we previously added to our Visual Studio Code requires some specific lua files for the intellisense to work. This is how your environment should look like, more or less:
note
You can download the _api folder here: _api or just visit the open GitHub repository
tip
You can also just download the mage fire example, which
already includes the setup.
warning
To make sure that you always have the latest _api version, we strongly suggest that you use the GitHub repository instead of the static download from this page, as it might be outdated from time to time.
After your setup is successfull, you should see the Intellisense working:
Now, we should be good to actually start programming :)
Header File​
warning
The name of this file MUST be "header.lua". Other names are not accepted and the core won't recognize your script if you attempt to modify its file name.
This is the file that will essentially tell the core if your script will be loaded or not. This makes sense because you might develop a Fire Mage script, for example.
The script shouldn't be loaded under any circumstance if the user is not playing a Fire Mage in this case. This file is also used to uniquely identify your plugin.
You will see how to use it more clearly with an example (the following example is the same code that we use in the Placeholder Plugin):
local plugin = {}
plugin["name"] = "Placeholder Script"
plugin["version"] = "0.0.0"
plugin["author"] = "Placeholder Author"
plugin["load"] = true
-- check if local player exists before loading the script (user is on loading screen / not ingame)
local local_player = core.object_manager.get_local_player()
if not local_player then
plugin["load"] = false
return plugin
end
---@type enums
local enums = require("common/enums")
local player_class = local_player:get_class()
-- change this line with the class of your script
local is_valid_class = player_class == enums.class_id.DRUID
if not is_valid_class then
plugin["load"] = false
return plugin
end
local player_spec_id = core.spell_book.get_specialization_id()
-- change this line with the spec id of your script
-- the spec id is in the same order as it appears in the talents WoW UI
local is_valid_spec_id = player_spec_id == 1
if not is_valid_spec_id then
plugin["load"] = false
return plugin
end
return plugin
As you can see, the core is expecting a table to be returned, with the following members filled:
"name"
"version"
"author"
"load"
All the elements of the table are self-explanatory. Just note that when the table["load"] is false, the plugin won't be loaded.
Main File​
warning
The name of this file MUST be "main.lua". Other names are not accepted and the core won't recognize your script if you attempt to modify its file name.
This is the file where all your logics must be placed, as this is the only file that the core will read, other than the header one. You can obviously have multiple files, just note that you will eventually have to
import the code that you want to be run to the main file.
Since main.lua can become quite lengthy, we’ll start with a brief example here. For more detailed scripts, see the examples below.
-- Note:
-- This is a very basic example.
-- For a more comprehensive example, visit our GitHub or download the Fire Mage example script provided below.
local menu_elements =
{
main_tree = core.menu.tree_node(),
keybinds_tree_node = core.menu.tree_node(),
-- you can add more menu elements in future here
}
-- and now render them:
local function my_menu_render()
menu_elements.main_tree:render("Simple Example", function()
-- this is the checkbohx that will appear upon opening the previous tree node
menu_elements.enable_script_check:render("Enable Script")
-- you can render more menu elements in future here...
end)
end
core.log("Hello World! (This should be printed just once on console)")
local function my_on_update()
local is_plugin_enabled = menu_elements.enable_script_check:get_state()
if is_plugin_enabled then
-- When menu element enable_script_check
-- Is true, this will spam console in white
core.log("Plugin Test is ENABLED!")
else
-- When menu element enable_script_check
-- Is false, this will spam console in yellow
core.log_warning("[DISABLED] Test Plugin")
end
end
core.register_on_update_callback(my_on_update)
core.register_on_render_menu_callback(my_menu_render)
The way Sylvanas uses the main/header files​
The way we handle the Lua is simple. We just read the header file and the main file once (on injection / Lua reload). Then, we store all the information that is present in both files and then we internally run the code that we just stored. All the code that are not callbacks, or inside a callback, is just read and executed once.
note
For more information about callbacks, check the more in-depth explanation of the available callbacks. You should know the way they work and what each one of them does before begining to develop scripts.
Fire Mage Example​
Below, we provide you with a placeholder script. This has most of the required basic functionality and checks. This is, by no means, enough to develop a complete script, you should still check the guides for more info and slowly improve yourself.
Download Scripts Folder with Code Examples
Visit Public OpenSource Github Repository
Previous
👋 Welcome
Next
Core
Overview
Getting Started
Checking the API file
Header File
Main File
The way Sylvanas uses the main/header files
Fire Mage Example
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Getting Started _ Project Sylvanas.html>

<Game Object - Code Examples _ Project Sylvanas.html>
Game Object - Code Examples | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Game Object
Game Object - Code Examples
On this page
Game Object - Code Examples
Overview​
In this section, we are going to showcase some usefull code examples that you could use for your own scripts. We advise you to understand the code before copying and pasting it. Before beginning, have a look at Game Object - Functions since you will be able to find all available functions for game objects there.
Starting The Journey
Before continuing, note that you should have some idea about callbacks, what they are and how they work, and the way functions work in LUA. Check Core - Callbacks
Example 1 - Retrieving the Tank From Your Party​
In this case, we already prepared a function that does this functionality for you. It's located in the unit_helper module.
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
---@param local_player game_object
---@returns game_object | nil
local get_tank_from_party(local_player)
local allies_from_party = unit_helper:get_ally_list_around(local_player:get_position(), 40.0, true, true)
for k, ally in ipairs(allies_from_party) do
local is_current_ally_tank = unit_helper:is_tank(ally)
if is_current_ally_tank then
return ally
end
end
return nil
end
note
To retrieve the healer, we can do likewise and use the unit_helper. In this case, just use the function is_healer instead of is_tank
Example 2 - Retrieving the Skull-Marked Unit​
---@type enums
local enums = require("common/enums")
---@return game_object | nil
local function get_skull_marked_unit()
-- first, we check if local player exists
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- then, we check all possible units in 40yds radius (for example)
local search_radius = 40.0
-- we will use squared distance, since this is much more efficient than the regular distance function,
-- as it prevents a square root operation from being performed. (The final result is exactly the same one)
local squared_search_radius = 40.0 * 40.0
local all_units = core.object_manager.get_all_objects()
-- important: do not try to get the local player position inside the loop, since this
-- will drop fps as your CPU would be performing useless extra work.
local local_player_position = local_player:get_position()
for k, unit in ipairs(all_units) do
local unit_position = unit:get_position()
local squared_distance = unit_position:squared_dist_to_ignore_z(local_player_position)
if squared_distance <= squared_search_radius then
local unit_marker_index = unit:get_target_marker_index()
local is_skull = unit_marker_index == enums.mark_index.SKULL
if is_skull then
return unit
end
end
end
return nil
end
tip
You can check that the code works by using the following lines:
core.register_on_update_callback(function()
local skull_marked_npc = get_skull_marked_npc()
if skull_marked_npc then
core.log("The Skull-Marked NPC's name is: " .. skull_marked_npc:get_name())
else
core.log("No Skull-Marked NPC was found!")
end
end)
You can also retrieve the units marked with other marks by re-using the same code, you would just need to change the enums.mark_index. index. (Basically, you would just need to change line 30)
Example 3 - Retrieving the Future Position of a Unit​
---@param unit game_object
---@param time number
---@return vec3
local function get_future_position(unit, time)
local unit_current_position = unit:get_position() -- vec3
local unit_direction = unit:get_direction() -- vec3
local unit_speed = unit:get_movement_speed() -- number
-- first, we normalize the direction vector to ensure it has a length of 1
local unit_direction_normalized = unit_direction:normalize()
-- then, we calculate the displacement: distance = speed * time
local displacement = unit_direction_normalized * unit_speed * time
-- finally, we just calculate the future position by adding the displacement to the current position
local future_position = unit_current_position + displacement
return future_position
end
tip
To test the previous code, you could use the following lines:
core.register_on_render_callback(function()
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- lets draw a line between current position and our calculated future position
local local_player_position = local_player:get_position()
local local_player_future_pos_in_1_sec = get_future_position(local_player, 0.50)
core.graphics.circle_3d(local_player_future_pos_in_1_sec, 2.5, color.cyan(200), 25.0, 1.5)
core.graphics.line_3d(local_player_position, local_player_future_pos_in_1_sec, color.cyan(255), 6.0)
end)
Example 4 - Set Glowing To Enemies That Are Not On Line Of Sight​
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
---@type enums
local enums = require("common/enums")
core.register_on_update_callback(function()
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local local_player_position = local_player:get_position()
-- we get the enemies around 40 yards from player
local enemies = unit_helper:get_enemy_list_around(local_player_position, 40.0, true)
for k, enemy in ipairs(enemies) do
local enemy_pos = enemy:get_position()
-- trace line will return true if the enemy is in line of sight, as long as we pass the enums.collision_flags.LineOfSight flag
local is_in_los = core.graphics.trace_line(local_player_position, enemy_pos, enums.collision_flags.LineOfSight)
-- we have to check if the unit is glowing already
local is_glowing_already = enemy:is_glow()
if not is_in_los then
if not is_glowing_already then
-- make it glow if not glowing yet
enemy:set_glow(enemy, true)
end
else
if is_glowing_already then
-- make it not glow if it's in line of sight, if it was glowing before
enemy:set_glow(enemy, false)
end
end
end
end)
Previous
Game Object - Functions
Next
Buffs
Overview
Example 1 - Retrieving the Tank From Your Party
Example 2 - Retrieving the Skull-Marked Unit
Example 3 - Retrieving the Future Position of a Unit
Example 4 - Set Glowing To Enemies That Are Not On Line Of Sight
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Game Object - Code Examples _ Project Sylvanas.html>

<Game Object - Functions _ Project Sylvanas.html>
Game Object - Functions | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Game Object
Game Object - Functions
On this page
Game Object - Functions
Overview​
The game_object class represents entities within the game world. This class provides a comprehensive set of methods to interact with and retrieve information about game objects, such as players, NPCs, items, and more. Almost everything that we are ever going to interact with is a game_object, so this class is one of the most important ones.
Functions​
Validation and Type Checks 📃​
is_valid() -> boolean​
Checks if the game_object is valid (exists in the game world).
get_type() -> number​
Returns the type identifier of the object.
get_class() -> number​
Retrieves the class identifier of the object.
tip
You can use the following code to translate from class ID to class name:
---@type enums
local enums = require("common/enums")
local function call_this_function_inside_the_on_update_callback()
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local class_name = enums.class_id_to_name[local_player:get_class()]
core.log("This is my current class: " .. class_name)
end
is_basic_object() -> boolean​
Determines if the object is a basic game object.
is_player() -> boolean​
Checks if the object is a player.
is_unit() -> boolean​
Checks if the object is a unit (NPC, creature, etc.).
is_item() -> boolean​
Checks if the object is an item.
is_pet() -> boolean​
Determines if the object is a pet.
is_boss() -> boolean​
Checks if the object is classified as a boss.
warning
Blizzard's "is_boss" function is not accurate, since only certain bosses like world bosses have this flag enabled. To check if a mob is a boss more accurately, you should use the function provided in the unit_helper module.
Here is a code showing how to properly check if a unit is a boss or not:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
local function is_boss(target)
return unit_helper:is_boss(target)
end
Identification and Attributes 📃​
get_npc_id() -> number​
Retrieves the NPC ID of the object (if applicable).
warning
This only works for npcs!
get_level() -> number​
Returns the level of the object.
get_faction_id() -> number​
Gets the faction ID the object belongs to.
get_target_marker_index() -> number​
Retrieves the target marker (raid icon) index:
0: No Icon
1: Yellow 4-point Star
2: Orange Circle
3: Purple Diamond
4: Green Triangle
5: White Crescent Moon
6: Blue Square
7: Red "X" Cross
8: White Skull
get_classification() -> number​
Gets the classification of the object:
-1: Unknown
0: Normal
1: Elite
2: Rare Elite
3: World Boss
4: Rare
5: Trivial
6: Minus
get_group_role() -> number​
Retrieves the group role of the object:
-1: Unknown / None
0: Tank
1: Healer
2: Damage Dealer
get_name() -> string​
Returns the name of the object.
get_attack_speed() -> number​
Retrieves the auto-attack swing speed.
Status and State Checks 📃​
get_specialization_id() -> integer​
Returns the spec_id if the game_object is a player.
get_creature_type() -> integer​
Returns the type of the creature.
is_dead() -> boolean​
Checks if the object is dead.
is_visible() -> boolean​
Checks if the object is visible or not. Also might be useful to check if an object is alive / useful or it's removed from the game (for example, a trap expiring).
is_mounted() -> boolean​
Determines if the object is mounted.
is_outdoors() -> boolean​
Checks if the object is outdoors.
is_indoors() -> boolean​
Checks if the object is indoors.
is_in_combat() -> boolean​
Checks if the object is currently in combat.
is_moving() -> boolean​
Determines if the object is moving.
is_dashing() -> boolean​
Checks if the object is dashing.
is_casting_spell() -> boolean​
Checks if the object is casting a spell.
is_channelling_spell() -> boolean​
Determines if the object is channeling a spell.
is_active_spell_interruptable() -> boolean​
Checks if the currently casting spell can be interrupted.
is_glow() -> boolean​
Checks if the object is glowing.
set_glow(state: boolean)​
Sets the glowing state of the object.
Combat and Threat 📃​
can_attack(other: game_object) -> boolean​
Determines if the object can attack another object.
is_enemy_with(other: game_object) -> boolean​
Checks if the object is an enemy of another object.
is_friend_with(other: game_object) -> boolean​
Checks if the object is friendly with another object.
get_threat_situation(obj: game_object) -> threat_table​
Retrieves the threat status relative to another object.
threat_table Properties:
is_tanking: Whether the object is tanking.
status: Threat status (0 to 3).
threat_percent: Threat percentage (0 to 100).
Position and Movement 📃​
get_position() -> vec3​
Gets the current position of the object. See vec3
get_rotation() -> number​
Retrieves the rotation angle of the object.
get_direction() -> vec3​
Gets the directional vector the object is facing. See vec3
get_movement_speed() -> number​
Returns the current movement speed.
get_movement_speed_max() -> number​
Retrieves the maximum possible movement speed.
get_swim_speed_max() -> number​
Gets the maximum swim speed.
get_flight_speed_max() -> number​
Returns the maximum flight speed.
get_bounding_radius() -> number​
Retrieves the bounding radius of the object.
get_height() -> number​
Returns the height of the object.
get_scale() -> number​
Gets the scale factor of the object.
Health and Power 📃​
get_health() -> number​
Retrieves the current health value.
get_max_health() -> number​
Gets the maximum health value.
get_max_health_modifier() -> number​
Returns any modifiers affecting max health.
get_power(power_type: number) -> number​
Gets the current power for a specified power type.
Refer to Power Types.
tip
Use the enums power types to check all the possible values. For example:
---@type enums
local enums = require("common/enums")
local function print_player_fury()
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local local_player_power = local_player:get_power(enums.power_type.FURY)
core.log("Local Player Current Fury: " .. tostring(local_player_power))
end
get_max_power(power_type: number) -> number​
Retrieves the maximum power for a specified power type. Same like the previous function , only that this one returns the maximum possible power that the character can have, instead of the current one.
get_xp() -> number​
Returns the current experience points (XP).
get_max_xp() -> number​
Gets the maximum XP for the current level.
Casting and Spells 📃​
get_active_spell_id() -> number​
Retrieves the spell ID of the spell currently being cast.
get_active_spell_cast_start_time() -> number​
Gets the start time of the active spell cast.
get_active_spell_cast_end_time() -> number​
Retrieves the end time of the active spell cast.
get_active_spell_target() -> game_object​
Gets the target of the spell currently being cast.
get_active_channel_spell_id() -> number​
Retrieves the spell ID of the spell currently being channeled.
get_active_channel_cast_start_time() -> number​
Gets the start time of the active channel spell.
get_active_channel_cast_end_time() -> number​
Retrieves the end time of the active channel spell.
is_ghost() -> boolean​
Returns true when the game object is a ghost (not dead but not alive either)
Relationships 📃​
get_owner() -> game_object​
Returns the owner of the object (if any).
get_pet() -> game_object​
Retrieves the pet of the object (if any).
get_target() -> game_object​
Gets the current target of the object.
is_party_member() -> boolean​
Checks if the object is a party member.
Auras and Effects 📃​
get_auras() -> table<buff>​
Retrieves all auras affecting the object.
get_buffs() -> table<buff>​
Gets all buffs applied to the object. See buffs
get_debuffs() -> table<buff>​
Retrieves all debuffs applied to the object. see debuffs
buff Properties:
buff_name: Name of the buff.
buff_id: Unique identifier.
count: Stack count.
expire_time: When the buff expires.
duration: Total duration.
type: Type identifier.
caster: The object that applied the buff.
get_loss_of_control_info() -> loss_of_control_info​
Provides information on any loss of control effects.
loss_of_control_info Properties:
valid: Whether the info is valid.
spell_id: Associated spell ID.
start_time: Effect start time.
end_time: Effect end time.
duration: Total duration.
type: Type of control loss.
get_total_shield() -> number​
Returns the total shield applied to the game_object.
Items and Inventory 📃​
get_item_cooldown(item_id: integer) -> number​
Retrieves the cooldown for a specific item.
has_item(item_id: integer) -> boolean​
Checks if the object possesses a specific item.
get_item_id() -> integer​
Gets the item id from an item gameobject
get_equipped_items() -> table of item_slot_info​
note
The item_slot info is a table with 2 members:
.object (game_object) -> the item itself
.slot_id (integer) -> the id of the slot
Check the Wiki for more info.
tip
Also, check our Inventory Helper which provides the most important and required functionality in regards to inventory.
get_item_at_inventory_slot(integer) -> item_slot_info​
The item_slot_info of the item with at the given slot.
get_item_stack_count() -> integer​
The stack count of the item.
Previous
Object Manager
Next
Game Object - Code Examples
Overview
FunctionsValidation and Type Checks 📃
is_valid() -> boolean
get_type() -> number
get_class() -> number
is_basic_object() -> boolean
is_player() -> boolean
is_unit() -> boolean
is_item() -> boolean
is_pet() -> boolean
is_boss() -> boolean
Identification and Attributes 📃
get_npc_id() -> number
get_level() -> number
get_faction_id() -> number
get_target_marker_index() -> number
get_attack_speed() -> number
Status and State Checks 📃
get_specialization_id() -> integer
get_creature_type() -> integer
is_dead() -> boolean
is_visible() -> boolean
is_mounted() -> boolean
is_outdoors() -> boolean
is_indoors() -> boolean
is_in_combat() -> boolean
is_moving() -> boolean
is_dashing() -> boolean
is_casting_spell() -> boolean
is_channelling_spell() -> boolean
is_active_spell_interruptable() -> boolean
is_glow() -> boolean
set_glow(state: boolean)
Combat and Threat 📃
can_attack(other: game_object) -> boolean
is_enemy_with(other: game_object) -> boolean
is_friend_with(other: game_object) -> boolean
get_threat_situation(obj: game_object) -> threat_table
Position and Movement 📃
get_position() -> vec3
get_rotation() -> number
get_direction() -> vec3
get_movement_speed() -> number
get_movement_speed_max() -> number
get_swim_speed_max() -> number
get_flight_speed_max() -> number
get_bounding_radius() -> number
get_height() -> number
get_scale() -> number
Health and Power 📃
get_health() -> number
get_max_health() -> number
get_max_health_modifier() -> number
get_power(power_type: number) -> number
get_max_power(power_type: number) -> number
get_xp() -> number
Casting and Spells 📃
get_active_spell_id() -> number
get_active_spell_cast_start_time() -> number
get_active_spell_cast_end_time() -> number
get_active_spell_target() -> game_object
get_active_channel_spell_id() -> number
get_active_channel_cast_start_time() -> number
get_active_channel_cast_end_time() -> number
is_ghost() -> boolean
Relationships 📃
get_owner() -> game_object
get_pet() -> game_object
get_target() -> game_object
is_party_member() -> boolean
Auras and Effects 📃
get_auras() -> table<buff>
get_buffs() -> table<buff>
get_debuffs() -> table<buff>
get_loss_of_control_info() -> loss_of_control_info
get_total_shield() -> number
Items and Inventory 📃
get_item_cooldown(item_id: integer) -> number
has_item(item_id: integer) -> boolean
get_item_id() -> integer
get_equipped_items() -> table of item_slot_info
get_item_at_inventory_slot(integer) -> item_slot_info
get_item_stack_count() -> integer
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Game Object - Functions _ Project Sylvanas.html>

<Graphics - Functions _ Project Sylvanas.html>
Graphics - Notifications | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Graphics
Graphics - Notifications
On this page
Lua Graphics - Notifications Documentation
Overview​
As you might know already, our project have an in-built notifications system. A notification is basically a box that spawns in a given position, containing some information. The cool part about them is that the user can interact with them, allowing you to create interactive functions. For example, if you are a hunter and your pet dies, you can send a notification that warns the user that the pet has died. Since the notifications are interactive, as previously said, you could add a functionality to revive the pet if the notification is clicked.
Basic Functionality Explanation
Using notifications is very simple, since almost everything is handled internally. You just have to keep in mind a couple key points:
1- Callbacks: You can use all notifications functionalities from
any callback, since the rendering is handled internally.
2- Positioning: By default, all notifications are rendered in the position that is specified in the main menu
(System -> Notifications). However, you can still customize their spawn position, although this is
not recommended in general since the user might be expecting all notifications from all plugins to spawn in the same place. You can still do something like the Hunter Plugins notifications customizations, where by default the position is the same as the main menu one, but the user can specifically customize the notifications from your plugin.
3- Identification: Every notification must have its own unique ID, same like with menu elements.
This ID is a string, so we recommend using local variables (defined outside of the callbacks) that are easy to recognize for each individual notification. Only 1 notification with the same ID can be active at a time.
Functions 🛠️​
Add Notification 🔔​
Syntax
core.graphics.add_notification(header, message, duration_s, color, x_pos_offset, y_pos_offset, max_background_alpha, length, height)
Parameters
header: string - The information text for the notification that will appear on top.
message: string - The message text for the notification. This is the actual notification information.
duration_s: integer - The duration of the notification in seconds.
color: color - The color of the notification.
x_pos_offset (Optional): number - The x-position offset for the notification. Default is 0.0.
y_pos_offset (Optional): number - The y-position offset for the notification. Default is 0.0.
max_background_alpha (Optional): number - The maximum background alpha value. Default is 0.95.
length (Optional): number - The length offset of the notification (This value adds up to the default notification length). Default is 0.0.
height (Optional): number - The height offset of the notification (This value adds up to the default notification height). Default is 0.0.
Description
Adds a notification with the specified information, message, duration, color, and optional positional offsets, background alpha, length, and height.
Example:
Adding a notification after right mouse button was clicked
---@type color
local color = require("common/color")
local notification_id = "rmb_pressed_notification"
local function notify_rmb_was_pressed()
-- you can avoid this check if you checked it earlier in your code.
-- It's just to make sure nothing is rendered while on loading screen.
local local_player = core.object_manager.get_local_player()
if not local_player then
return nil
end
local is_rmb_pressed = core.input.is_key_pressed(0x02)
if is_rmb_pressed then
core.graphics.add_notification(notification_id, "[Notifying]", "RMB Was Pressed!", 5, color.get_rainbow_color(20))
end
end
Is Notification Clicked 🔔🖱️​
Syntax
core.graphics.is_notification_clicked(id, trigger_after_time)
Parameters
id: string - The ID of the notification to check.
trigger_after_time (Optional): number - The time in seconds after which the notification click is triggered. Default is 0.0.
Returns
boolean: true if the notification has been clicked, false otherwise.
Description
Checks if a notification with the specified message has been clicked, with an optional trigger time delay.
Get Notifications Core Position 📍​
Syntax
core.graphics.get_notifications_core_pos()
Returns
vec2: The core position of the notifications.
Description
Retrieves the core position of the notifications. This is the position that can be customized in the main menu
(System -> Notifications)
Get Notifications Default Size 📏​
Syntax
core.graphics.get_notifications_default_size()
Returns
vec2: The default size of the notifications.
Description
Retrieves the default size of the notifications. This size cannot be modified by user input.
Complete Example​
Lets finish off with an example that summarizes all functionality. The code will add a notification when RMB is pressed by the user. It will spam in the console whether the notification is active or not, and if it's clicked by the user, it will print so in the console and the notification won't be shown again until the LUA modules are reloaded.
Summarizing Example:
Interiorizing the concepts
---@type color
local color = require("common/color")
local notification_id = "rmb_pressed_notification"
local function notify_rmb_was_pressed()
-- you can avoid this check if you checked it earlier in your code.
-- It's just to make sure nothing is rendered while on loading screen.
local local_player = core.object_manager.get_local_player()
if not local_player then
return nil
end
local is_rmb_pressed = core.input.is_key_pressed(0x02)
if is_rmb_pressed then
core.graphics.add_notification(notification_id, "[Notifying]", "RMB Was Pressed!", 5, color.get_rainbow_color(20))
end
end
local notification_ended = false
core.register_on_update_callback(function()
if notification_ended then
return
end
notify_rmb_was_pressed()
local is_notification_clicked = core.graphics.is_notification_clicked(notification_id)
if not is_notification_clicked then
core.log("Is Notification Appearing On Screen: " .. tostring(core.graphics.is_notification_active(notification_id)))
else
core.log("Is Notification Clicked: " .. tostring(is_notification_clicked))
notification_ended = true
end
end)
Previous
Graphics - Functions
Next
Menu Elements
Overview
Functions 🛠️Add Notification 🔔
Is Notification Clicked 🔔🖱️
Get Notifications Core Position 📍
Get Notifications Default Size 📏
Complete Example
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Graphics - Functions _ Project Sylvanas.html>

<Graphics - Notifications _ Project Sylvanas.html>
Graphics - Notifications | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Graphics
Graphics - Notifications
On this page
Lua Graphics - Notifications Documentation
Overview​
As you might know already, our project have an in-built notifications system. A notification is basically a box that spawns in a given position, containing some information. The cool part about them is that the user can interact with them, allowing you to create interactive functions. For example, if you are a hunter and your pet dies, you can send a notification that warns the user that the pet has died. Since the notifications are interactive, as previously said, you could add a functionality to revive the pet if the notification is clicked.
Basic Functionality Explanation
Using notifications is very simple, since almost everything is handled internally. You just have to keep in mind a couple key points:
1- Callbacks: You can use all notifications functionalities from
any callback, since the rendering is handled internally.
2- Positioning: By default, all notifications are rendered in the position that is specified in the main menu
(System -> Notifications). However, you can still customize their spawn position, although this is
not recommended in general since the user might be expecting all notifications from all plugins to spawn in the same place. You can still do something like the Hunter Plugins notifications customizations, where by default the position is the same as the main menu one, but the user can specifically customize the notifications from your plugin.
3- Identification: Every notification must have its own unique ID, same like with menu elements.
This ID is a string, so we recommend using local variables (defined outside of the callbacks) that are easy to recognize for each individual notification. Only 1 notification with the same ID can be active at a time.
Functions 🛠️​
Add Notification 🔔​
Syntax
core.graphics.add_notification(header, message, duration_s, color, x_pos_offset, y_pos_offset, max_background_alpha, length, height)
Parameters
header: string - The information text for the notification that will appear on top.
message: string - The message text for the notification. This is the actual notification information.
duration_s: integer - The duration of the notification in seconds.
color: color - The color of the notification.
x_pos_offset (Optional): number - The x-position offset for the notification. Default is 0.0.
y_pos_offset (Optional): number - The y-position offset for the notification. Default is 0.0.
max_background_alpha (Optional): number - The maximum background alpha value. Default is 0.95.
length (Optional): number - The length offset of the notification (This value adds up to the default notification length). Default is 0.0.
height (Optional): number - The height offset of the notification (This value adds up to the default notification height). Default is 0.0.
Description
Adds a notification with the specified information, message, duration, color, and optional positional offsets, background alpha, length, and height.
Example:
Adding a notification after right mouse button was clicked
---@type color
local color = require("common/color")
local notification_id = "rmb_pressed_notification"
local function notify_rmb_was_pressed()
-- you can avoid this check if you checked it earlier in your code.
-- It's just to make sure nothing is rendered while on loading screen.
local local_player = core.object_manager.get_local_player()
if not local_player then
return nil
end
local is_rmb_pressed = core.input.is_key_pressed(0x02)
if is_rmb_pressed then
core.graphics.add_notification(notification_id, "[Notifying]", "RMB Was Pressed!", 5, color.get_rainbow_color(20))
end
end
Is Notification Clicked 🔔🖱️​
Syntax
core.graphics.is_notification_clicked(id, trigger_after_time)
Parameters
id: string - The ID of the notification to check.
trigger_after_time (Optional): number - The time in seconds after which the notification click is triggered. Default is 0.0.
Returns
boolean: true if the notification has been clicked, false otherwise.
Description
Checks if a notification with the specified message has been clicked, with an optional trigger time delay.
Get Notifications Core Position 📍​
Syntax
core.graphics.get_notifications_core_pos()
Returns
vec2: The core position of the notifications.
Description
Retrieves the core position of the notifications. This is the position that can be customized in the main menu
(System -> Notifications)
Get Notifications Default Size 📏​
Syntax
core.graphics.get_notifications_default_size()
Returns
vec2: The default size of the notifications.
Description
Retrieves the default size of the notifications. This size cannot be modified by user input.
Complete Example​
Lets finish off with an example that summarizes all functionality. The code will add a notification when RMB is pressed by the user. It will spam in the console whether the notification is active or not, and if it's clicked by the user, it will print so in the console and the notification won't be shown again until the LUA modules are reloaded.
Summarizing Example:
Interiorizing the concepts
---@type color
local color = require("common/color")
local notification_id = "rmb_pressed_notification"
local function notify_rmb_was_pressed()
-- you can avoid this check if you checked it earlier in your code.
-- It's just to make sure nothing is rendered while on loading screen.
local local_player = core.object_manager.get_local_player()
if not local_player then
return nil
end
local is_rmb_pressed = core.input.is_key_pressed(0x02)
if is_rmb_pressed then
core.graphics.add_notification(notification_id, "[Notifying]", "RMB Was Pressed!", 5, color.get_rainbow_color(20))
end
end
local notification_ended = false
core.register_on_update_callback(function()
if notification_ended then
return
end
notify_rmb_was_pressed()
local is_notification_clicked = core.graphics.is_notification_clicked(notification_id)
if not is_notification_clicked then
core.log("Is Notification Appearing On Screen: " .. tostring(core.graphics.is_notification_active(notification_id)))
else
core.log("Is Notification Clicked: " .. tostring(is_notification_clicked))
notification_ended = true
end
end)
Previous
Graphics - Functions
Next
Menu Elements
Overview
Functions 🛠️Add Notification 🔔
Is Notification Clicked 🔔🖱️
Get Notifications Core Position 📍
Get Notifications Default Size 📏
Complete Example
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Graphics - Notifications _ Project Sylvanas.html>

<Health Prediction Library _ Project Sylvanas.html>
Health Prediction Library | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
Health Prediction Library
On this page
Health Prediction Library
Overview​
The Health Prediction module is a powerful tool that provides developers with various functions to predict
incoming damage and make better decisions for defensive and healing logics. This module plays a crucial role in enhancing the adaptability and accuracy of gameplay strategies in both
PvP and PvE scenarios. Below, we'll explore its core functions and how to utilize them effectively.
tip
You should check User Health Pred Guide to understand what this module is about in more depth
before starting to work with it.
Including the Module​
Like with all other LUA modules developed by us, you will need to import the health prediction module into your project.
To do so, you can just use the following lines:
---@type health_prediction
local health_pred = require("common/modules/health_prediction")
warning
To access the module's functions, you must use : instead of .
For example, this code is not correct:
---@type health_prediction
local health_pred = require("common/modules/health_prediction")
local function get_incoming_damage_in_3_seconds(player)
local health_pred_calculated_health = health_pred.get_incoming_damage(player, 3.0)
return health_pred_calculated_health
end
And this would be the corrected code:
---@type health_prediction
local health_pred = require("common/modules/health_prediction")
local function get_incoming_damage_in_3_seconds(player)
local health_pred_calculated_health = health_pred:get_incoming_damage(player, 3.0)
return health_pred_calculated_health
end
Functions​
note
There is only one relevant function for developers within the health prediction module. That is the get_incoming_damage function. You could also use the unit_helper library, which also has a function that will return the health percentage taking into account the incoming damage. This functions is get_health_percentage_inc.
tip
Instead of using the health_prediction module, you can just include directly the unit_helper module, which already includes the functionality below.
get_incoming_damage(target: game_object, deadline_time_in_seconds: number, is_exception?: boolean) -> number​
Retrieves the amount of incoming damage to a specified target within a given timeframe.
Code Example 📋​
Below, a complete function example to check if you should cast deffensives or not, according to health prediction or raw health.
warning
This function is using previously defined menu elements. The comments explain them, but you can choose to remove them or create your own menu elements to replace them. This is just a real-life example used in one of our Mythic+ plugins.
---@type health_prediction
local health_pred = require("common/modules/health_prediction")
local function should_cast_deffensive_spell_on_incoming_damage(local_player)
-- menu element to check if we are using health pred or not (you can remove this)
local is_using_inc_dmg_logic = menu_elements.override_min_hp_on_incoming_hp_pct:get_state()
-- we store player hp and max hp on a local variable to avoid calling the same function multiple times (performance)
local local_player_hp = local_player:get_health()
local local_player_max_hp = local_player:get_max_health()
-- if this is true, it means that the user decided not to use the health prediction, so we just check for plain health percentage
if not is_using_inc_dmg_logic then
local player_current_hp_pct = local_player_hp / local_player_max_hp
return player_current_hp_pct <= menu_elements.spell_min_hp_pct:get()
end
-- if this code is read, means the previous check was false, so the user decided to use health prediction
--- get incoming damage in the next 3 seconds
local inc_dmg_hp = health_pred:get_incoming_damage(local_player, 3.0)
-- get our hp after all the incoming damage is received
local hp_minus_inc_dmg = local_player - inc_dmg_hp
-- check our future health percentage, after all the expected damage is received
local inc_dmg_hp_pct = hp_minus_inc_dmg / local_player_max_hp
local min_inc_dmg_hp_pct_slider_value = menu_elements.incoming_hp_pct:get()
-- compare the previous future hp pct that we calculated to the min hp pct value set by the user
local should_cast_deffensive = inc_dmg_hp_pct <= min_inc_dmg_hp_pct_slider_value
if should_cast_deffensive then
-- change spell_data.name with your spell name!
core.log("Should Cast " .. spell_data.name .. "On Inc DMG HP PCT - - Inc Dmg: " .. tostring(inc_dmg_hp_pct))
return true
end
return false
end
note
As stated before, you can swap the health_pred module for the unit_helper module, since the latter also provides the get_inc_damage functionality.
Previous
Combat Forecast Library
Next
Unit Helper Library
Overview
Including the Module
Functionsget_incoming_damage(target: game_object, deadline_time_in_seconds: number, is_exception?: boolean) -> number
Code Example 📋
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Health Prediction Library _ Project Sylvanas.html>

<Custom UI Functions 🪖 _ Project Sylvanas.html>
Custom UI Functions 🪖 | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
Custom UI Functions 🪖
Barney's Basic Guide (With examples) 🎯
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Custom UI
Custom UI Functions 🪖
On this page
Custom UI Functions 🪖
Overview​
The Lua Menu Element Window module provides a range of functions for creating and managing custom GUI windows in Lua scripts. This module allows developers to design sophisticated interfaces with various visual elements and controls.
Create New Window 📃​
core.menu.window.new(id)
id: String - The unique identifier for the window.
Returns: window - A new window instance.
Creates a new window with the specified ID. Remember this should always be called outside of the render callback, since
we are creating a new unique instance of a window.
Set Initial Size 📃​
window:set_initial_size(size)
size: vec2 - The initial size of the window.
note
This function just sets the initial size of the window. It can be overriden later, either by user input or by code by calling this function inside the render callback
(this is not the recommended behaviour)
Set Initial Position 📃​
window:set_initial_position(pos)
pos: vec2 - The initial position of the window.
note
This function just sets the initial position of the window. It can be overriden later, either by user input or by code by calling the "force_next_begin_window_pos" function inside the render callback (this is not the recommended behaviour)
Set Next Close Cross Position Offset 📃​
window:set_next_close_cross_pos_offset(pos_offset)
pos_offset: vec2 - The position offset for the close cross.
note
This function will add an offset on the close cross position. By default, it is rendered at the top-right corner of the window.
Add Menu Element Position Offset 📃​
window:add_menu_element_pos_offset(pos_offset)
pos_offset: vec2 - The position offset for menu elements.
note
This function will add a position offset to the internal dynamic position variable. See
"The Advanceds - Explaining Dynamic Drawing" for a more in-depth explanation on the matter.
Get Window Size 📃​
window:get_size()
Returns: vec2 - The current size of the window.
Get Window Position 📃​
window:get_position()
Returns: vec2 - The current position of the window.
Get Mouse Position 📃​
window:get_mouse_pos()
Returns: vec2 - The current mouse position relative to the window.
Get Current Context Dynamic Drawing Offset 📃​
window:get_current_context_dynamic_drawing_offset()
Returns: vec2 - The current context dynamic drawing offset.
note
Retrieves the internal dynamic position variable's current value. See
"The Advanceds - Explaining Dynamic Drawing" for a more in-depth explanation on the matter.
Get Text Size 📃​
window:get_text_size(str)
str: String - The text to measure.
Returns: vec2 - The size of the text.
Get Centered Text X Position 📃​
window:get_text_centered_x_pos(text)
text: String - The text to center.
Returns: Number - The X position offset for centered text.
note
After we get the centered text x position offset, we just need to add this value to the dynamic drawing offset by using
"window:get_current_context_dynamic_drawing_offset()".
Another option is to use the "Center Text" function directly (recommended)
Center Text 📃​
window:center_text(text)
text: String - The text to center.
note
After calling this function, we just need to render the text using the "add_text_on_dynamic_pos" function. You will see that the text is centered in the middle of the window.
Render Text 🖌️​
window:render_text(font_id, pos_offset, color, text)
font_id: Integer - The ID of the font to use.
pos_offset: vec2 - The position offset for the text.
color: color - The color of the text.
text: String - The text to render.
note
Renders a text at the specified position with the given font and color. This function renders
statically, so this text is not taken into account for the dynamic position offset.
Render Rectangle 🖌️​
window:render_rect(pos_min_offset, pos_max_offset, color, rounding, thickness [, flags])
pos_min_offset: vec2 - The minimum position offset for the rectangle.
pos_max_offset: vec2 - The maximum position offset for the rectangle.
color: color - The color of the rectangle.
rounding: Number - The rounding radius for the rectangle corners.
thickness: Number - The thickness of the rectangle border.
flags (Optional): Integer - Flags for rectangle rendering. Default is 0.
Available rounding flags: ( enums.window_enums.rect_borders_rounding_flags. )
NO_ROUNDING
ROUND_TOP_LEFT_CORNERS
ROUND_TOP_RIGHT_CORNERS
ROUND_BOTTOM_LEFT_CORNER
ROUND_BOTTOM_RIGHT_CORNER
ROUND_TOP_CORNERS
ROUND_BOTTOM_CORNERS
ROUND_LEFT_CORNERS
ROUND_RIGHT_CORNERS
ROUND_ALL_CORNERS
note
Renders a rectangle at the specified position with the given properties. This function renders
statically, so this rectangle is not taken into account for the dynamic position offset.
Render Filled Rectangle 🖌️​
window:render_rect_filled(pos_min_offset, pos_max_offset, color, rounding [, flags])
pos_min_offset: vec2 - The minimum position offset for the filled rectangle.
pos_max_offset: vec2 - The maximum position offset for the filled rectangle.
color: color - The fill color of the rectangle.
rounding: Number - The rounding radius for the rectangle corners.
flags (Optional): Integer - Flags for rectangle rendering. Default is 0.
Available rounding flags: ( enums.window_enums.rect_borders_rounding_flags. )
NO_ROUNDING
ROUND_TOP_LEFT_CORNERS
ROUND_TOP_RIGHT_CORNERS
ROUND_BOTTOM_LEFT_CORNER
ROUND_BOTTOM_RIGHT_CORNER
ROUND_TOP_CORNERS
ROUND_BOTTOM_CORNERS
ROUND_LEFT_CORNERS
ROUND_RIGHT_CORNERS
ROUND_ALL_CORNERS
note
Renders a filled rectangle at the specified position with the given properties. This function renders
statically, so this rectangle is not taken into account for the dynamic position offset.
Render Filled Rectangle with Multiple Colors 🖌️​
window:render_rect_filled_multicolor(pos_min_offset, pos_max_offset, col_upr_left, col_upr_right, col_bot_right, col_bot_left, rounding [, flags])
pos_min_offset: vec2 - The minimum position offset for the filled rectangle.
pos_max_offset: vec2 - The maximum position offset for the filled rectangle.
col_upr_left: color - The color for the upper-left corner.
col_upr_right: color - The color for the upper-right corner.
col_bot_right: color - The color for the bottom-right corner.
col_bot_left: color - The color for the bottom-left corner.
rounding: Number - The rounding radius for the rectangle corners.
flags (Optional): Integer - Flags for rectangle rendering. Default is 0.
Available rounding flags: ( enums.window_enums.rect_borders_rounding_flags. )
NO_ROUNDING
ROUND_TOP_LEFT_CORNERS
ROUND_TOP_RIGHT_CORNERS
ROUND_BOTTOM_LEFT_CORNER
ROUND_BOTTOM_RIGHT_CORNER
ROUND_TOP_CORNERS
ROUND_BOTTOM_CORNERS
ROUND_LEFT_CORNERS
ROUND_RIGHT_CORNERS
ROUND_ALL_CORNERS
note
Renders a filled rectangle at the specified position with the given properties. This function renders
statically, so this rectangle is not taken into account for the dynamic position offset. The specified colors will be blended so we recommend testing to get used to this function. You can achieve cool-looking visuals with this function. An example is the height / width resizing rectangles that appear when the mouse is hovering the draggable regions of the window. (You can see that on the bottom of the main menu, for example.)
Render Circle 🖌️​
window:render_circle(center, radius, color [, num_segments [, thickness]])
center: vec2 - The center position of the circle.
radius: Number - The radius of the circle.
color: color - The color of the circle.
num_segments (Optional): Integer - The number of segments for the circle. Default is 0.
thickness (Optional): Number - The thickness of the circle outline. Default is 1.0.
note
Renders a circunference (non-filled circle) at the specified position with the given properties. This function renders
statically, so this circle is not taken into account for the dynamic position offset.
Render Filled Circle 🖌️​
window:render_circle_filled(center, radius, color [, num_segments])
center: vec2 - The center position of the circle.
radius: Number - The radius of the circle.
color: color - The fill color of the circle.
num_segments (Optional): Integer - The number of segments for the circle. Default is 0.
note
Renders a filled circle at the specified position with the given properties. This function renders
statically, so this circle is not taken into account for the dynamic position offset.
Render Quadratic Bezier Curve 🖌️​
window:render_bezier_quadratic(p1, p2, p3, color, num_segments, thickness)
p1: vec2 - The start point of the curve.
p2: vec2 - The control point of the curve.
p3: vec2 - The end point of the curve.
color: color - The color of the curve.
num_segments: Integer - The number of segments for the curve.
thickness: Number - The thickness of the curve.
note
Renders a quadratic bezier curve at the specified position with the given properties. This function renders
statically, so this curve is not taken into account for the dynamic position offset.
Render Cubic Bezier Curve 🖌️​
window:render_bezier_cubic(p1, p2, p3, p4, color, num_segments, thickness)
p1: vec2 - The start point of the curve.
p2: vec2 - The first control point of the curve.
p3: vec2 - The second control point of the curve.
p4: vec2 - The end point of the curve.
color: color - The color of the curve.
num_segments: Integer - The number of segments for the curve.
thickness: Number - The thickness of the curve.
note
Renders a cubic bezier curve at the specified position with the given properties. This function renders
statically, so this curve is not taken into account for the dynamic position offset.
Render Triangle 🖌️​
window:render_triangle(p1, p2, p3, color, thickness)
p1: vec2 - The first point of the triangle.
p2: vec2 - The second point of the triangle.
p3: vec2 - The third point of the triangle.
color: color - The color of the triangle.
thickness: Number - The thickness of the triangle outline.
note
Renders a triangle at the specified position with the given properties. This function renders
statically, so this triangle is not taken into account for the dynamic position offset.
Render Filled Triangle 🖌️​
window:render_triangle_filled(p1, p2, p3, color)
p1: vec2 - The first point of the triangle.
p2: vec2 - The second point of the triangle.
p3: vec2 - The third point of the triangle.
color: color - The fill color of the triangle.
note
Renders a filled triangle at the specified position with the given properties. This function renders
statically, so this filled triangle is not taken into account for the dynamic position offset.
Render Filled Triangle with Multiple Colors 🖌️​
window:render_triangle_filled_multi_color(p1, p2, p3, col_1, col_2, col_3)
p1: vec2 - The first point of the triangle.
p2: vec2 - The second point of the triangle.
p3: vec2 - The third point of the triangle.
col_1: color - The color for the first point.
col_2: color - The color for the second point.
col_3: color - The color for the third point.
note
Renders a filled triangle at the specified position with the given properties. This function renders
statically, so this triangle is not taken into account for the dynamic position offset. The specified colors will be blended so we recommend testing to get used to this function. You can achieve cool-looking visuals with this function. An example is the height and width resizing triangle that appear when the mouse is hovering the draggable regions of the window. (You can see that on the right-left of the console, for example.)
Render Line 🖌️​
window:render_line(p1, p2, color, thickness)
p1: vec2 - The start point of the line.
p2: vec2 - The end point of the line.
color: color - The color of the line.
thickness: Number - The thickness of the line.
note
Renders a line from p1 to p2 with the given properties. This function renders
statically, so this line is not taken into account for the dynamic position offset.
Add Separator 🖌️​
window:add_separator(right_sep_offset, left_sep_offset, y_offset, width_offset, custom_color)
right_sep_offset: Number - The right offset for the separator.
left_sep_offset: Number - The left offset for the separator.
y_offset: Number - The y-offset for the separator.
width_offset: Number - The width offset for the separator.
custom_color: color - The custom color for the separator.
faded_line: Boolean - Render the separator as a faded line.
note
Renders a separator from p1 to p2 with the given properties. This function renders
statically, so the separator is not taken into account for the dynamic position offset.
Is Mouse Hovering Rect 📃​
window:is_mouse_hovering_rect(rect_min, rect_max)
rect_min: vec2 - The minimum position of the rectangle.
rect_max: vec2 - The maximum position of the rectangle.
Returns: Boolean
note
Returns true if the mouse is hovering the specified bounds.
Is Rect Clicked 📃​
window:is_rect_clicked(rect_min, rect_max)
rect_min: vec2 - The minimum position of the rectangle.
rect_max: vec2 - The maximum position of the rectangle.
Returns: Boolean
note
Returns true if the mouse left button was clicked while hovering the rect.
Is Rect Double Clicked 📃​
window:is_rect_double_clicked(rect_min, rect_max)
rect_min: vec2 - The minimum position of the rectangle.
rect_max: vec2 - The maximum position of the rectangle.
Returns: Boolean
note
Returns true if the mouse left button was double-clicked while hovering the rect.
Set Visibility 📃​
window:set_visibility(visibility)
visibility: Boolean - The visibility state of the window.
note
If visibility is false, the window will not be rendered. This is useful for window-popups, for example. See the examples in the guide.
Is Being Shown 📃​
window:is_being_shown()
Returns: Boolean - The current visibility state of the window.
Render 📃​
window:render(resizing_flag, is_adding_cross, bg_color, border_color, cross_style_flag, flag_1 (optional), flag_2 (optional), flag_3 (optional), callback)
resizing_flag: Integer - The resizing flag for the window.
is_adding_cross: Boolean - Indicates if a cross is being added.
bg_color: color - The background color of the window. Use color.new(0,0,0,0) to use the
Sylvana's theme default color.
border_color: color - The border color of the window.
cross_style_flag (Optional): Integer - The style flag for the cross. Default is 0.
flag_1 (Optional): Integer - Additional rendering flag. Default is 0.
flag_2 (Optional): Integer - Additional rendering flag. Default is 0.
flag_3 (Optional): Integer - Additional rendering flag. Default is 0.
callback: Function - The callback function to execute during rendering.
Available flags: ( enums.window_enums.window_behaviour_flags. )
NO_MOVE - Disables the option for the user to drag the window.
ALWAYS_AUTO_RESIZE - Makes the window content automatically resize according to the space occupied by the widgets that affect the dynamic drawing variable.
NO_SCROLLBAR - Disables scrollbars on the window.
Returns: Boolean - True if the window is being rendered.
note
Renders the window with the specified properties and executes the callback function if the window is open. This is the main function, so all the code regarding visuals will always be inside a window:render block. The callback function must always be the last parameter of the window:render function.
A use example:
---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")
---@type enums
local enums = require("common/enums")
local test_window = core.menu.window("Test window - ")
local initial_size = vec2.new(200, 200)
test_window:set_initial_size(initial_size)
local initial_position = vec2.new(500, 300)
test_window:set_initial_position(initial_position)
local bg_color = color.new(16, 16, 20, 180)
local border_color = color.new(100, 99, 150, 255)
core.register_on_render_window_callback(function()
test_window:begin(enums.window_enums.window_resizing_flags.RESIZE_BOTH_AXIS, true, color.new(0,0,0,0),
border_color, enums.window_enums.window_cross_visuals.BLUE_THEME, function()
-- render your stuff here
end)
end)
Begin Group 📃​
window:begin_group(callback)
callback: Function - The callback function to execute within the group.
note
Begins a new group and executes the callback function within the group context. This is useful when we want to draw
multiple widgets at the same x offset, for example. By using this function, we avoid having to manually set the position for each widget. Instead, we can just set the position once and it will be applied for all widgets inside the callback.
For example, this is the code that we use for the main debug panel buttons:
-- popup triggers
window:add_menu_element_pos_offset(vec2.new(actual_offset, 7.0))
window:begin_group(function()
if menu_elements.unit_info_launch_popup:render("Show Unit Info") then
is_unit_info_popup_enabled = true
unit_info_window.set_visibility(true)
end
local auras_warning_msg = "Auras Table Is Empty\nFor Target: " .. target:get_name()
if menu_elements.unit_auras_launch_popup:render("Show Auras Info") then
is_unit_auras_popup_enabled = true
auras_info_window.set_visibility(true)
if #all_strings_to_show.auras_strings == 0 then
core.graphics.add_notification(auras_warning_msg_id, "[Debug Panel - Warning]", auras_warning_msg,
5.0, color.yellow(200))
is_unit_auras_popup_enabled = false
auras_info_window.set_visibility(false)
end
end
local is_auras_popup_warning_clicked = core.graphics.is_notification_clicked(auras_warning_msg_id, 0.0)
if is_auras_popup_warning_clicked then
is_unit_auras_popup_enabled = true
auras_info_window.set_visibility(true)
end
local buffs_warning_msg = "Buffs Table Is Empty\nFor Target: " .. target:get_name()
if menu_elements.unit_buffs_launch_popup:render("Show Buffs Info") then
is_unit_buffs_popup_enabled = true
buffs_info_window.set_visibility(true)
if #all_strings_to_show.buffs_strings == 0 then
core.graphics.add_notification(buffs_warning_msg_id, "[Debug Panel - Warning]", buffs_warning_msg,
5.0, color.yellow(200))
is_unit_buffs_popup_enabled = false
buffs_info_window.set_visibility(false)
end
end
local is_buffs_popup_warning_clicked = core.graphics.is_notification_clicked(buffs_warning_msg_id, 0.0)
if is_buffs_popup_warning_clicked then
is_unit_buffs_popup_enabled = true
buffs_info_window.set_visibility(true)
end
local debuffs_warning_msg = "Debuffs Table Is Empty\nFor Target: " .. target:get_name()
if menu_elements.unit_debuffs_launch_popup:render("Show Debuffs Info") then
is_unit_debuffs_popup_enabled = true
debuffs_info_window.set_visibility(true)
if #all_strings_to_show.debuffs_strings == 0 then
core.graphics.add_notification(debuffs_warning_msg_id, "[Debug Panel - Warning]", debuffs_warning_msg, 5.0, color.yellow(200))
is_unit_debuffs_popup_enabled = false
debuffs_info_window.set_visibility(false)
end
end
local is_debuffs_popup_warning_clicked = core.graphics.is_notification_clicked(debuffs_warning_msg_id, 0.0)
if is_debuffs_popup_warning_clicked then
debuffs_info_window.set_visibility(true)
is_unit_debuffs_popup_enabled = true
end
if menu_elements.more_info_launch_popup:render("Show Extra Info") then
is_extra_info_popup_enabled = true
extra_unit_info_window.set_visibility(true)
end
end)
It is a very extense example, however, you can focus on the following: We are adding the position offset just once, and as you can see in-game, all buttons are centered at the same X position. Note that the "begin_group" function ONLY works for
dynamic offset drawings.
Begin Popup 📃​
window:begin_popup(background_color, border_color, size, pos, is_close_on_release, is_triggering_from_button, callback)
background_color: color - The background color of the popup.
border_color: color - The border color of the popup.
size: vec2 - The size of the popup.
pos: vec2 - The initial position of the popup. Note that this position is relative to the parent window's position (the window that spawned the popup)
is_close_on_release: Boolean - Indicates if the popup should close on release, instead of on click.
is_triggering_from_button: Boolean - Indicates if the popup is triggered from a core.menu button, since this requires a special handling.
callback: Function - The callback function to execute within the popup.
Returns: Boolean
note
Begins a new popup with the specified properties and executes the callback function if the popup is open. Essentially, a popup is just another window, with 2 main differences:
1 - We don't need to create a new object for it
2 - A popup will close automatically when the user clicks (or releases the mouse, if that's the specified behaviour) outside of its bounds.
The begin popup will return false when the popup is not being rendered (in other words, when the user closed it.) We have to use this information to set a boolean declared outside of the main render loop that will dictaminate wheter the popup will be rendered again after the user closed it or not. For this, we usually have to use a button or something similar.
This might sound confusing at first, but here is a quick example to show how this works:
-- use a custom rect as a button (you can also use core.menu buttons)
if window:is_rect_clicked(open_popup_rect_v1, open_popup_rect_v2) then
-- note: define this boolean is defined outside of the main render callback.
is_popup_active = true
end
if is_popup_active then
if window:begin_popup(color.new(16, 16, 20, 230), border_color, vec2.new(250, 250), vec2.new(150, 50), false, false, function()
-- render your stuff here
end)
end) then
-- You can do whatever you want here. If the code here is read it means that the popup is currently being rendered.
else
-- This means that the user clicked outside of the popup bounds (or released the mouse), so it shouldn't be rendered anymore.
is_popup_active = false
end
end
You can also check "The Intermediates - Popups" part on Barney's Guide for a more extense explanation and code examples.
Draw Next Dynamic Widget on Same Line 📃​
window:draw_next_dynamic_widget_on_same_line(offset_from_start_x [, spacing_w])
offset_from_start_x: Number - The offset from the start X position.
spacing_w (Optional): Number - The spacing width. Default is -1.0.
note
Draws the next dynamic widget on the same line with the specified offset and spacing. This esentially prevents the internal handling system to automatically add a Y offset for the next dynamic widget that will be rendered.
Draw Next Dynamic Widget on New Line 📃​
window:draw_next_dynamic_widget_on_new_line()
note
Draws the next dynamic widget on a new line. This esentially forces the internal handling system to automatically add a Y offset for the next dynamic widget that will be rendered.
Add Text on Dynamic Position 📃​
window:add_text_on_dynamic_pos(color, text)
color: color - The color of the text.
text: String - The text to add.
note
Adds text on the current dynamic position with the specified color.
Push Font 📃​
window:push_font(font_id)
font_id: Integer - The ID of the font to push.
note
Pushes the specified font onto the internal font stack. Every text rendered after this call will be performed with the specified font, until a new push_font call is found.
The currently available fonts are the following ones:
Available Fonts: ( enums.window_enums.font_id. )
FONT_SMALL = 0
FONT_NORMAL = 1
FONT_SEMI_BIG = 2
FONT_BIG = 3
FONT_ICONS_SMALL = 4
FONT_ICONS_BIG = 5
FONT_ICONS_VERY_BIG = 6
Animate Widget 📃​
window:animate_widget(animation_id, start_pos, end_pos, starting_alpha, max_alpha, alpha_speed, movement_speed, only_once)
animation_id: Integer - The ID of the animation.
start_pos: vec2 - The starting position of the animation.
end_pos: vec2 - The ending position of the animation.
starting_alpha: Integer - The starting alpha value.
max_alpha: Integer - The maximum alpha value.
alpha_speed: Number - The speed of the alpha change.
movement_speed: Number - The speed of the movement.
only_once: Boolean - Indicates if the animation should run only once.
Returns: Table - A table containing the animation result with keys current_position and alpha.
note
Animates a widget with the specified properties and returns the animation result. Check "The Advanceds - Animations" part on Barney's Guide for a more in-depth explanation and code examples.
Set Next Window Items Spacing 📃​
window:set_next_window_items_spacing(spacing)
spacing: vec2 - The spacing between window items.
note
Sets the spacing between items in the next window. This only applies to dynamic drawings. This function should be called
before the window:render function.
Set Next Window Items Inner Spacing 📃​
window:set_next_window_items_inner_spacing(inner_spacing)
inner_spacing: vec2 - The inner spacing between window items.
note
Sets the inner spacing between items in the next window. This only applies to dynamic drawings. This function should be called
before the window:render function.
Set Next Window Padding 📃​
window:set_next_window_padding(padding)
padding: vec2 - The padding of the next window.
note
Sets the padding for the next window. This only applies to dynamic drawings. This function should be called
before the window:render function.
Set Background Multicolored 📃​
window:set_background_multicolored(top_left_color: color, top_right_color: color, bot_right_color: color, bot_left_color: color))
This function enables multi-color support for the given window's background.
warning
This function MUST be called before the window:begin function.
tip
You could use a colorpicker for each color, giving infinite color customization options to the user. An example is the PvP UI module.
Manually Set End Called State 📃​
window:set_end_called_state()
This function is to manually set the end_called flag that's used within the core to check if a begin function was called for the given window. The implementation is a bit complex, just keep in mind that this function exists for when you use the functions to set the next window padding/spacing and it gives a Lua Error on the console. This means that we just found an unhandled exception.
To fix this, just call this function at the end of your :begin function.
Force Next Begin Window Position 📃​
window:force_next_begin_window_pos(pos)
pos: vec2 - The position to force the next window to begin at.
note
Forces the next window to be rendered at the specified position. This function's use is not recommended in most cases. This function should be called
before the window:render function.
Stop Forcing Next Begin Window Position 📃​
window:stop_forcing_position()
note
Stops the next window to be rendered at the specified position. This function's use is not recommended in most cases. This function should be called
before the window:render function.
tip
An example where force_next_begin_window_pos / stop_forcing_position might be useful is when you have to enable attachment / deattachment of one window to another window. (See PvP UI Module). This would be the simple code example:
if not menu.menu_elements.deattach_check:get_state() then
settings_window:force_next_begin_window_pos(vec2.new(current_window_pos.x + window_size_elements.x:get(), current_window_pos.y))
else
settings_window:stop_forcing_position()
end
The previous code is extracted directly from the PvP UI Module. The settings window is the one that attaches to current window, which would be the main window (the one with the buttons).
Set Next Window Minimum Size 📃​
window:set_next_window_min_size(min_size)
min_size: vec2 - The minimum size of the next window.
note
Sets the minimum size of the next window, so the user cannot reduce its size to less than the specified value. This function should be called
before the window:render function.
Is Animation Finished 📃​
window:is_animation_finished(id)
id: Integer - The ID of the animation.
Returns: Boolean
note
Returns true if the animation with the given ID has already finished.
Set Window Cross Round 📃​
window:set_next_window_cross_round()
note
Sets the next window cross to be a circumference, instead of a rectangle. This function should be called
before the window:render function.
Make Loading Circle Animation 📃​
window:make_loading_circle_animation(animation_id, origin, radius, color, thickness, animation_type)
animation_id: Integer - The ID of the animation.
origin: vec2 - The origin of the animation.
radius: Number - The radius of the circle.
color: color - The color of the circle.
thickness: Number - The thickness of the circle.
animation_type: Integer - The type of the animation.
note
Creates a loading circle animation with the specified properties. These are the animations used by the loader, for example.
Get Window Type 📃​
window:get_type()
Returns: Integer - The type of the window.
Previous
Dungeons Helper
Next
Barney's Basic Guide (With examples) 🎯
OverviewCreate New Window 📃
Set Initial Size 📃
Set Initial Position 📃
Set Next Close Cross Position Offset 📃
Add Menu Element Position Offset 📃
Get Window Size 📃
Get Window Position 📃
Get Mouse Position 📃
Get Current Context Dynamic Drawing Offset 📃
Get Text Size 📃
Get Centered Text X Position 📃
Center Text 📃
Render Text 🖌️
Render Rectangle 🖌️
Render Filled Rectangle 🖌️
Render Filled Rectangle with Multiple Colors 🖌️
Render Circle 🖌️
Render Filled Circle 🖌️
Render Quadratic Bezier Curve 🖌️
Render Cubic Bezier Curve 🖌️
Render Triangle 🖌️
Render Filled Triangle 🖌️
Render Filled Triangle with Multiple Colors 🖌️
Render Line 🖌️
Add Separator 🖌️
Is Mouse Hovering Rect 📃
Is Rect Clicked 📃
Is Rect Double Clicked 📃
Set Visibility 📃
Is Being Shown 📃
Render 📃
Begin Group 📃
Begin Popup 📃
Draw Next Dynamic Widget on Same Line 📃
Draw Next Dynamic Widget on New Line 📃
Add Text on Dynamic Position 📃
Push Font 📃
Animate Widget 📃
Set Next Window Items Spacing 📃
Set Next Window Items Inner Spacing 📃
Set Next Window Padding 📃
Set Background Multicolored 📃
Manually Set End Called State 📃
Force Next Begin Window Position 📃
Stop Forcing Next Begin Window Position 📃
Set Next Window Minimum Size 📃
Is Animation Finished 📃
Set Window Cross Round 📃
Make Loading Circle Animation 📃
Get Window Type 📃
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Custom UI Functions 🪖 _ Project Sylvanas.html><Barney's Basic Guide (With examples) 🎯 _ Project Sylvanas.html>
Barney's Basic Guide (With examples) 🎯 | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
Custom UI Functions 🪖
Barney's Basic Guide (With examples) 🎯
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Custom UI
Barney's Basic Guide (With examples) 🎯
On this page
Barney's Basic Guide (With examples) 🎯
Overview​
This guide attempts to guide our fellow Sylvanas programmers into building
their own custom user interfaces for their plugins. For this, I have created a
step-by-step guide basic that anyone with programming knowledge can follow (hopefully, open to suggestions), adding multiple code examples and exercises to practise. The idea is to give you a starting point, so you can keep learning and evolving yourself afterwards.
🎯 Barney's Basic Guide 🎯
With this guide, our goal is to generate the following UI:
All the code that generates what we can see in the previous image will be extensively explained. The code is obviously open source for you to practise and be creative.
Basics - 0​
The basics - Getting Started
This module is located within the core.menu module. All our custom UI code will be rendered within a
"Window". Each window is, and must be treated as, an independent object. Therefore, each individual window that we generate will have its own sepparate visuals and code. Before begining, these are the
modules that will be required:
---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")
---@type enums
local enums = require("common/enums")
Basics - 1​
The basics - Creating a Window Object
As previously stated, each window must be an individual object. So, same like with menu elements, we are going to generate a window as follows:
local test_window = core.menu.window("Test window")
-- Important: every window must have a unique identifier.
-- In this case, the identifier is "Test window".
Now that we already have our window object, we have to set its initial position and size.
(This can be changed later, either by user input or by code, on the rendering callback,
however, it's important to always set the initial position and size, which will be used as default.)
note
Size and position are of type vec2, since we need X and Y axis to define both magnitudes. See vec2
Case 1
We don't want size or position to be saved aftear each injection:
We can just set the hardcoded position and size as follows:
local initial_size = vec2.new(200, 200)
window:set_initial_size(initial_size)
local initial_position = vec2.new(500, 500)
window:set_initial_position(initial_position)
Case 2
We want size or position to be saved aftear each injection:
In this case, we also have to generate "ghost" sliders that will save the last known value of position and size of the window, since menu elements are the only
available resources that allows us to save information between different injections.
local window_position_elements =
{
x = core.menu.slider_int(0, 10000, 250, "test_window_x_initial_position"),
y = core.menu.slider_int(0, 10000, 360, "test_window_y_initial_position"),
}
local window_size_elements =
{
x = core.menu.slider_int(0, 10000, 250, "test_window_x_initial_size"),
y = core.menu.slider_int(0, 10000, 360, "test_window_y_initial_size"),
}
Now that we have our sliders defined (you can also use float sliders if you want more precision), we can actually set
the window's initial size and position:
local initial_size = vec2.new(window_size_elements.x:get(), window_size_elements.y:get())
test_window:set_initial_size(initial_size)
local initial_position = vec2.new(window_position_elements.x:get(), window_position_elements.y:get())
test_window:set_initial_position(initial_position)
note
Everything that we used up to this point must be called OUTSIDE the render callback.
Basics - 2​
The basics - Rendering our First Window
Everything's ALMOST ready for us to render things and have fun. There is only one thing missing: we need to use the window's special rendering callback! We will use an anonymous function, so we can start rendering directly, but like with all other callbacks,
you can define a function and then call the callback passing the said function.
core.register_on_render_window_callback(function()
end)
Now that we have our callback defined, let's actually start rendering. To render any window, we must use the window:begin function. This function's last parameter is another function, and from now on, almost all code will be placed inside this last function. I know it might sound confusing at first, but trust me, it's very simple. You will understand everything with this next example:
core.register_on_render_window_callback(function()
-- I know all these parameters might overwhelm you at the beginning, but don't worry since all
-- these parameters are straightforward and pretty much self-explanatory.
-- Parameter 1: Resizing flags -> Accepts window_resizing_flags enum member: .NO_RESIZE or 0,
-- .RESIZE_WIDTH,
-- .RESIZE_HEIGHT,
-- .RESIZE_BOTH_AXIS
-- .NO_RESIZE: The draggable resizing areas will be completely disabled,
-- making it impossible for the user to change the window's size.
-- .RESIZE_WIDTH: Only the lateral draggable zone will be enabled, so the user will only be able to increase the window's width.
-- .RESIZE_HEIGHT: Only the bottom draggable zone will be enabled, so the user will only be able to increase the window's height.
-- .RESIZE_BOTH_AXIS: The bottom-right draggable zone will be enabled, so the user will be able to modify both, width and height.
-- Parameter 2: Is adding cross -> Accepts Boolean. The cross refers to the top right X that when pressed will make the window invisible. If false, no cross will be rendered,
-- so you will have to manually handle a way to close and open the window (eg. custom buttons).
-- Parameter 3: Background color -> Accepts Color
-- Parameter 4: Border color -> Accepts Color
-- Parameter 5: Cross style flag -> Accepts window_cross_visuals enum member: DEFAULT = 0,
-- PURPLE_THEME = 1,
-- GREEN_THEME = 2,
-- RED_THEME = 3,
-- BLUE_THEME = 4,
-- NO_BACKGROUND = 5,
-- ONLY_HITBOX = 6,
-- NO_BORDER = 7,
-- NO_BACKGROUND_AND_NO_BORDER = 8,
-- NO_CROSS = 9
-- The cross style enum names are self explanatory, but I advise you to play with all these values and see how they change.
-- There are up to 3 extra possible parameters that are optional before we add the function call, which is always the last parameter no matter what.
-- These parameters are just extra flags that we can add that will alter the way the window behaves. They are inside the enums.window_enums.window_behaviour_flags.
-- These flags are:
-- .NO_MOVE: Disables the window's movement, so the user won't be able to move the window by dragging it.
-- .NO_SCROLLBAR: Disables scrollbars for the window.
-- .ALWAYS_AUTO_RESIZE: Window will automatically resize according to the elements, always according to the dynamic spacing size (see advanced guide)
-- NOTE: To use the default color, we need to pass color.new(0,0,0,0)
test_window:begin(enums.window_enums.window_resizing_flags.RESIZE_BOTH_AXIS, true, color.new(0,0,0,0),
color.new(0,0,0,0), enums.window_enums.window_cross_visuals.BLUE_THEME, function()
end)
end)
Basics - Last​
The basics - Summary
Up to this point, this is all the code that we have created:
---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")
---@type enums
local enums = require("common/enums")
local test_window = core.menu.window("Test window")
-- Important: every window must have a unique identifier.
-- In this case, the identifier is "Test window".
local window_position_elements =
{
x = core.menu.slider_int(0, 10000, 500, "test_window_x_initial_position_"),
y = core.menu.slider_int(0, 10000, 500, "test_window_y_initial_position_"),
}
local window_size_elements =
{
x = core.menu.slider_int(0, 10000, 500, "test_window_x_initial_size_"),
y = core.menu.slider_int(0, 10000, 300, "test_window_y_initial_size_"),
}
local initial_size = vec2.new(window_size_elements.x:get(), window_size_elements.y:get())
test_window:set_initial_size(initial_size)
local initial_position = vec2.new(window_position_elements.x:get(), window_position_elements.y:get())
test_window:set_initial_position(initial_position)
core.register_on_render_window_callback(function()
-- I know all these parameters might overwhelm you at the beginning, but don't worry since all these parameters are straightforward and pretty much self-explanatory.
-- Parameter 1: Resizing flags -> Accepts window_resizing_flags enum member: .NO_RESIZE or 0,
-- .RESIZE_WIDTH,
-- .RESIZE_HEIGHT,
-- .RESIZE_BOTH_AXIS
-- .NO_RESIZE: The draggable resizing areas will be completely disabled, making it impossible for the user to change the window's size.
-- .RESIZE_WIDTH: Only the lateral draggable zone will be enabled, so the user will only be able to increase the window's width.
-- .RESIZE_HEIGHT: Only the bottom draggable zone will be enabled, so the user will only be able to increase the window's height.
-- .RESIZE_BOTH_AXIS: The bottom-right draggable zone will be enabled, so the user will be able to modify both, width and height.
-- Parameter 2: Is adding cross -> Accepts Boolean. The cross refers to the top right X that when pressed will make the window invisible. If false, no cross will be rendered,
-- so you will have to manually handle a way to close and open the window (eg. custom buttons).
-- Parameter 3: Background color -> Accepts Color
-- Parameter 4: Border color -> Accepts Color
-- Parameter 5: Cross style flag -> Accepts window_cross_visuals enum member: DEFAULT = 0,
-- PURPLE_THEME = 1,
-- GREEN_THEME = 2,
-- RED_THEME = 3,
-- BLUE_THEME = 4,
-- NO_BACKGROUND = 5,
-- ONLY_HITBOX = 6,
-- NO_BORDER = 7,
-- NO_BACKGROUND_AND_NO_BORDER = 8,
-- NO_CROSS = 9
-- The cross style enum names are self explanatory, but I advise you to play with all these values and see how they change.
-- There are up to 3 extra possible parameters that are optional before we add the function call, which is always the last parameter no matter what.
-- These parameters are just extra flags that we can add that will alter the way the window behaves. They are inside the enums.window_enums.window_behaviour_flags.
-- These flags are:
-- .NO_MOVE: Disables the window's movement, so the user won't be able to move the window by dragging it.
-- .NO_SCROLLBAR: Disables scrollbars for the window.
-- .ALWAYS_AUTO_RESIZE: Window will automatically resize according to the elements, always according to the dynamic spacing size (see advanced guide)
-- NOTE: To use the default color, we need to pass color.new(0,0,0,0)
test_window:begin(enums.window_enums.window_resizing_flags.RESIZE_BOTH_AXIS, true, color.new(0,0,0,0),
color.new(0,0,0,0), enums.window_enums.window_cross_visuals.BLUE_THEME, function()
end)
end)
As you can see, if we remove the comments, it's a pretty short and straightforward code. This is what we will be seeing on screen after we run this code:
Intermediates - 1​
The Intermediates - Rendering The Title
I am going to introduce the "dynamic" positions offsets, since this is something we need for our showcase. However, this is more advanced, and therefore will be explained in detail in the "The Advanceds" part of the guide.
For now, you can just copy and paste the code and play with its parameters.
If you go back to the first image, you can notice there is a color-picker on the top-left of the window. Yes, we can render menu elements inside our windows, so you will be able to make your own menus for your plugins,
visual guides or whatever your imagination is capable of.
First, we will create and render this color picker, since it's the first element that appears on the window.
--- note: this is a menu element declaration, so it must be outside of the callback function.
local color_picker_test = core.menu.colorpicker(bg_color, "color_picker_test_id_1")
test_window:add_menu_element_pos_offset(vec2.new(13, 13))
color_picker_test:render("BG Color")
test_window:add_menu_element_pos_offset(vec2.new(-3, -3))
Now, the colorpicker should be appearing on the top-left of the window. Let's move on to render the title:
local title_text = "Barney's UI Mini Demo"
-- With this function we get the exact X position offset required to add to the current dynamic position so the text is in the center of the window:
local text_centered_x_pos = window:get_text_centered_x_pos(title_text)
-- We add the X position offset that we just calculated, and also we adjust the Y position:
window:add_menu_element_pos_offset(vec2.new(text_centered_x_pos, -32))
-- Finally, we just render the text on the dynamic position that we just set:
window:add_text_on_dynamic_pos(color.green_pale(255), title_text)
Now that we just rendered the title and the color picker, let's add something to highlight the title. For example, a rectangle:
window:render_rect(vec2.new(text_centered_x_pos - text_size.x / 20 - 3, 7.5), vec2.new(text_centered_x_pos + text_size.x * 1.05 - 1, 35), color.white(100), 0, 1.0)
And now we just have to add some separators, so it's clear that this is the title preview, right?
window:add_separator(3.0, 3.0, 15.0, 0.0, color.new(100, 99, 150, 255))
window:add_separator(3.0, 3.0, 17.0, 0.0, color.new(100, 99, 150, 255))
So, up to this point, this should be how our window's begin function code is looking like:
note
As you will see soon, we can use the color picker that we just declared to set the color of our window.
test_window:begin(enums.window_enums.window_resizing_flags.RESIZE_BOTH_AXIS, true, color_picker_test:get_color(),
color.new(0,0,0,0), enums.window_enums.window_cross_visuals.BLUE_THEME, function()
test_window:add_menu_element_pos_offset(vec2.new(13, 13))
color_picker_test:render("BG Color")
test_window:add_menu_element_pos_offset(vec2.new(-3, -3))
local title_text = "Barney's UI Mini Demo"
-- With this function we get the exact X position offset required to add to the current dynamic position so the text is in the center of the window:
local text_centered_x_pos = window:get_text_centered_x_pos(title_text) -- This function accepts a string, returns a number (which is the X offset)
-- We add the X position offset that we just calculated, and also we adjust the Y position:
window:add_menu_element_pos_offset(vec2.new(text_centered_x_pos, -32)) -- This function accepts a vec2, returns nothing (the parameter is the position offset)
-- Finally, we just render the text on the dynamic position that we just set:
window:add_text_on_dynamic_pos(color.green_pale(255), title_text) -- This function accepts a color and a string. This just renders the string with the color.
local text_size = window:get_text_size(title_text)
-- Now we render the rectangle to highlight the title:
-- This function accepts start_position (vec2), end_position (vec2), color, rounding, thickness and extra flags. The extra flags are covered in the docs, in the function info.
window:render_rect(vec2.new(text_centered_x_pos - text_size.x / 20 - 3, 12.0), vec2.new(text_centered_x_pos + text_size.x * 1.05 - 1, 37), color.white(100), 0, 1.0)
-- We finished rendering the title, so let's add some separators:
-- This function accepts the following parameters: separation from right offset (number), separation from left offset (number), y offset (number), width_offset (number) and color.
window:add_separator(3.0, 3.0, 15.0, 0.0, color.new(100, 99, 150, 255))
window:add_separator(3.0, 3.0, 17.0, 0.0, color.new(100, 99, 150, 255))
end)
This is how our window should be looking like in game with the current code:
Intermediates - 2​
The Intermediates - Popups
We can also spawn popups (or other windows) from our window. To do this, we obviously need something that triggers the event of the popup appearing.
To achieve this, we will usually need buttons. We can use either the buttons that are given from core.menu or we can make our own. In this case, since it's a guide,
we will make the buttons ourselves.
First, we need to define the button bounds, and then we just need to control the cursor positioning and behaviour.
-- top-left position of the button rect
local open_popup_rect_v1 = vec2.new(13, 70)
-- bot-right position of the button rect
local open_popup_rect_v2 = vec2.new(123, 90)
-- we can change alpha if the mouse is hovering our rect, so the user gets visual feedback and knows that the button does something.
local alpha = 120
if window:is_mouse_hovering_rect(open_popup_rect_v1, open_popup_rect_v2) then
alpha = 255
end
-- now, we just need to render the rect accordingly
-- this is the background of the rect
window:render_rect_filled(open_popup_rect_v1, open_popup_rect_v2, color.black(alpha), 1.0)
-- this is the borders of the rect
window:render_rect(open_popup_rect_v1, open_popup_rect_v2, color.white(alpha), 1.0, 1.0)
window:render_text(enums.window_enums.font_id.FONT_SMALL, vec2.new(40, 71), color.white(255), "Open Me!")
-- if the window is clicked, then we can do whatever. In this case, we are going to open a popup.
if window:is_rect_clicked(open_popup_rect_v1, open_popup_rect_v2) then
-- note: define this boolean outside of the render callback
is_popup_active = true
end
Note that popups are essentially windows too, the only difference is that they will be closed upon pressing outside of its bounds (or releasing the mouse, depending on the behaviour flag passed),
so everything that we do inside its begin function is relative to the popup. Inside the popup begin function, the parent window's bounds etc are ignored.
With this said, we can now go ahead and add the popup code:
if is_popup_active then
-- the begin_popup function is very similar to the window:begin function. In this case, the parameters are:
-- background color
-- border color
-- size
-- start position (relative to the parent window)
-- is_close_on_release (boolean)
-- is_triggering_from_button (boolean) -> this is true only if you are using a core.menu.button as trigger, since it has a special internal handling. False otherwise.
if window:begin_popup(color.new(16, 16, 20, 230), border_color, vec2.new(250, 250), vec2.new(150, 50), false, false, function()
-- same like before, we add the title and separators
local popup_title_text = "Popup Demo"
local popup_text_centered_x_pos = window:get_text_centered_x_pos(popup_title_text)
window:add_menu_element_pos_offset(vec2.new(popup_text_centered_x_pos, 10))
window:add_text_on_dynamic_pos(color.green_pale(255), popup_title_text)
window:add_separator(3.0, 3.0, 5.0, 0.0, color.new(100, 99, 150, 255))
-- even tho this is a little bit more advanced, it's actually very simple.
-- we are adding a position offset to the next dynamic element that we are rendering (see what's a dynamic element in the advanced guide).
-- by doing a window:begin_group(), what we are doing is we are essentially saying that everything inside the begin_group function is a unique dynamic element.
-- Therefore, the position offset will be applied to all elements inside equally.
-- So, yes, begin group is used to group stuff, basically. In this case, we are grouping 4 menu elements. (Previously defined outside the render callback, like always)
window:add_menu_element_pos_offset(vec2.new(250/4, 5))
window:begin_group(function()
checkbox1:render("Enable Test 1", "Showcasing ...")
checkbox2:render("Enable Test 2")
checkbox3:render("Enable Test 3")
slider_float_test:render("Slider\nTest")
end)
end) then
-- You can do whatever you want here. If the code here is read it means that the popup is currently being rendered.
else
-- This means that the user clicked outside of the popup bounds (or released the mouse), so it shouldn't be rendered anymore.
is_popup_active = false
end
end
So far, this is what should be appearing on your screen after you hit the "Open Me!" button:
Intermediates - 3​
The Intermediates - Spawning Windows
This is pretty similar to what we did with the popups. The only difference is that now we need to create a window object and we need to handle its visibility in a different way,
since windows by default don't close when pressing outside of its bounds.
First, we will generate the button that will trigger the window appeareance, just like we did with the popup:
local open_window_rect_v1 = vec2.new(13, 120)
local open_window_rect_v2 = vec2.new(123, 150)
local alpha2 = 120
if window:is_mouse_hovering_rect(open_window_rect_v1, open_window_rect_v2) then
alpha2 = 255
end
window:render_rect_filled(open_window_rect_v1, open_window_rect_v2, color.black(alpha2), 1.0)
window:render_rect(open_window_rect_v1, open_window_rect_v2, color.white(alpha2), 1.0, 1.0)
window:render_text(enums.window_enums.font_id.FONT_SMALL, vec2.new(open_window_rect_v1.x + 27, open_window_rect_v1.y + 7), color.white(255), "Open Me!")
if window:is_rect_clicked(open_window_rect_v1, open_window_rect_v2) then
-- since this is a window, when the user presses the exit cross, its visibility will be set to false automatically. The button was just clicked, so we need to make sure
-- the window is visible again.
window_popup:set_visibility(true)
-- same like with the popup, we declare this variable outside of the render callback.
is_window_popup_open = true
end
Now we just need to render this window. Pretty easy, right? Just like we did for the main window:
if is_window_popup_open then
-- window_popup:set_next_window_padding(vec2.new(33, 33))
window_popup:begin(enums.window_enums.window_resizing_flags.RESIZE_HEIGHT, true, color_picker_test:get(),
border_color, enums.window_enums.window_cross_visuals.DEFAULT, function()
local window_popup_title_text = "Window Popup Demo"
local window_popup_text_centered_x_pos = window:get_text_centered_x_pos(window_popup_title_text)
-- we render the title following the same principles as before
window:add_menu_element_pos_offset(vec2.new(window_popup_text_centered_x_pos, 10))
window:add_text_on_dynamic_pos(color.green_pale(255), window_popup_title_text)
window:add_separator(3.0, 3.0, 15.0, 0.0, color.new(100, 99, 150, 255))
window:add_menu_element_pos_offset(vec2.new(30, 20))
window:begin_group(function()
checkbox1:render("Enable Test 1", "Tooltip Test ...")
checkbox2:render("Enable Test 2")
checkbox3:render("Enable Test 3")
end)
end)
else
is_window_popup_open = false
end
Intermediates - Last​
The Intermediates - Summary
So far, this is all the code that we created:
---@type color
local color = require("common/color")
---@type vec2
local vec2 = require("common/geometry/vector_2")
---@type enums
local enums = require("common/enums")
-- Important: every window must have a unique identifier.
-- In this case, the identifier is "Test window".
local test_window = core.menu.window("Test window - ")
local window_position_elements =
{
x = core.menu.slider_int(0, 10000, 500, "test_window_x_initial_position_"),
y = core.menu.slider_int(0, 10000, 500, "test_window_y_initial_position_"),
}
local window_size_elements =
{
x = core.menu.slider_int(0, 10000, 500, "test_window_x_initial_size_"),
y = core.menu.slider_int(0, 10000, 300, "test_window_y_initial_size_"),
}
local initial_size = vec2.new(window_size_elements.x:get(), window_size_elements.y:get())
test_window:set_initial_size(initial_size)
local initial_position = vec2.new(window_position_elements.x:get(), window_position_elements.y:get())
test_window:set_initial_position(initial_position)
local bg_color = color.new(16, 16, 20, 180)
local border_color = color.new(100, 99, 150, 255)
local color_picker_test = core.menu.colorpicker(bg_color, "color_picker_test_id_1")
local window_popup = core.menu.window("Window Popup Test")
window_popup:set_initial_size(vec2.new(300, 200))
-- this is relative to the parent window, not relative to screen, unlike the parent window initial position.
window_popup:set_initial_position(vec2.new(500, 500))
local is_window_popup_open = false
local is_popup_active = false
core.register_on_render_window_callback(function()
-- -- I know all these parameters might overwhelm you at the beginning, but don't worry since all these parameters are straightforward and pretty much self-explanatory.
-- -- Parameter 1: Resizing flags -> Accepts window_resizing_flags enum member: .NO_RESIZE or 0,
-- -- .RESIZE_WIDTH,
-- -- .RESIZE_HEIGHT,
-- -- .RESIZE_BOTH_AXIS
-- -- .NO_RESIZE: The draggable resizing areas will be completely disabled, making it impossible for the user to change the window's size.
-- -- .RESIZE_WIDTH: Only the lateral draggable zone will be enabled, so the user will only be able to increase the window's width.
-- -- .RESIZE_HEIGHT: Only the bottom draggable zone will be enabled, so the user will only be able to increase the window's height.
-- -- .RESIZE_BOTH_AXIS: The bottom-right draggable zone will be enabled, so the user will be able to modify both, width and height.
-- -- Parameter 2: Is adding cross -> Accepts Boolean. The cross refers to the top right X that when pressed will make the window invisible. If false, no cross will be rendered,
-- -- so you will have to manually handle a way to close and open the window (eg. custom buttons).
-- -- Parameter 3: Background color -> Accepts Color
-- -- Parameter 4: Border color -> Accepts Color
-- -- Parameter 5: Cross style flag -> Accepts window_cross_visuals enum member: DEFAULT = 0,
-- -- PURPLE_THEME = 1,
-- -- GREEN_THEME = 2,
-- -- RED_THEME = 3,
-- -- BLUE_THEME = 4,
-- -- NO_BACKGROUND = 5,
-- -- ONLY_HITBOX = 6,
-- -- NO_BORDER = 7,
-- -- NO_BACKGROUND_AND_NO_BORDER = 8,
-- -- NO_CROSS = 9
-- -- The cross style enum names are self explanatory, but I advise you to play with all these values and see how they change.
-- -- There are up to 3 extra possible parameters that are optional before we add the function call, which is always the last parameter no matter what.
-- -- These parameters are just extra flags that we can add that will alter the way the window behaves. They are inside the enums.window_enums.window_behaviour_flags.
-- -- These flags are:
-- -- .NO_MOVE: Disables the window's movement, so the user won't be able to move the window by dragging it.
-- -- .NO_SCROLLBAR: Disables scrollbars for the window.
-- -- .ALWAYS_AUTO_RESIZE: Window will automatically resize according to the elements, always according to the dynamic spacing size (see advanced guide)
-- -- NOTE: To use the default color, we need to pass color.new(0,0,0,0)
test_window:begin(enums.window_enums.window_resizing_flags.RESIZE_BOTH_AXIS, true, color.new(0,0,0,0),
border_color, enums.window_enums.window_cross_visuals.BLUE_THEME, function()
test_window:add_menu_element_pos_offset(vec2.new(13, 13))
color_picker_test:render("BG Color")
test_window:add_menu_element_pos_offset(vec2.new(-3, -3))
local title_text = "Barney's UI Mini Demo"
-- With this function we get the exact X position offset required to add to the current dynamic position so the text is in the center of the window:
local text_centered_x_pos = window:get_text_centered_x_pos(title_text) -- This function accepts a string, returns a number (which is the X offset)
-- We add the X position offset that we just calculated, and also we adjust the Y position:
window:add_menu_element_pos_offset(vec2.new(text_centered_x_pos, -32)) -- This function accepts a vec2, returns nothing (the parameter is the position offset)
-- Finally, we just render the text on the dynamic position that we just set:
window:add_text_on_dynamic_pos(color.green_pale(255), title_text) -- This function accepts a color and a string. This just renders the string with the color.
local text_size = window:get_text_size(title_text)
-- Now we render the rectangle to highlight the title:
-- This function accepts start_position (vec2), end_position (vec2), color, rounding, thickness and extra flags. The extra flags are covered in the docs, in the function info.
window:render_rect(vec2.new(text_centered_x_pos - text_size.x / 20 - 3, 12.0), vec2.new(text_centered_x_pos + text_size.x * 1.05 - 1, 37), color.white(100), 0, 1.0)
-- We finished rendering the title, so let's add some separators:
-- This function accepts the following parameters: separation from right offset (number), separation from left offset (number), y offset (number), width_offset (number) and color.
window:add_separator(3.0, 3.0, 15.0, 0.0, color.new(100, 99, 150, 255))
window:add_separator(3.0, 3.0, 17.0, 0.0, color.new(100, 99, 150, 255))
-- top-left position of the button rect
local open_popup_rect_v1 = vec2.new(13, 70)
-- bot-right position of the button rect
local open_popup_rect_v2 = vec2.new(123, 90)
-- we can change alpha if the mouse is hovering our rect, so the user gets visual feedback and knows that the button does something.
local alpha = 120
if window:is_mouse_hovering_rect(open_popup_rect_v1, open_popup_rect_v2) then
alpha = 255
end
-- now, we just need to render the rect accordingly
-- this is the background of the rect
window:render_rect_filled(open_popup_rect_v1, open_popup_rect_v2, color.black(alpha), 1.0)
-- this is the borders of the rect
window:render_rect(open_popup_rect_v1, open_popup_rect_v2, color.white(alpha), 1.0, 1.0)
window:render_text(enums.window_enums.font_id.FONT_SMALL, vec2.new(40, 71), color.white(255), "Open Me!")
-- if the window is clicked, then we can do whatever. In this case, we are going to open a popup.
if window:is_rect_clicked(open_popup_rect_v1, open_popup_rect_v2) then
-- note: define this boolean outside of the render callback
is_popup_active = true
end
if is_popup_active then
-- the begin_popup function is very similar to the window:begin function. In this case, the parameters are:
-- background color
-- border color
-- size
-- start position (relative to the parent window)
-- is_close_on_release (boolean)
-- is_triggering_from_button (boolean) -> this is true only if you are using a core.menu.button as trigger, since it has a special internal handling. False otherwise.
if window:begin_popup(color.new(16, 16, 20, 230), border_color, vec2.new(250, 250), vec2.new(150, 50), false, false, function()
-- same like before, we add the title and separators
local popup_title_text = "Popup Demo"
local popup_text_centered_x_pos = window:get_text_centered_x_pos(popup_title_text)
window:add_menu_element_pos_offset(vec2.new(popup_text_centered_x_pos, 10))
window:add_text_on_dynamic_pos(color.green_pale(255), popup_title_text)
window:add_separator(3.0, 3.0, 5.0, 0.0, color.new(100, 99, 150, 255))
-- even tho this is a little bit more advanced, it's actually very simple.
-- we are adding a position offset to the next dynamic element that we are rendering (see what's a dynamic element in the advanced guide).
-- by doing a window:begin_group(), what we are doing is we are essentially saying that everything inside the begin_group function is a unique dynamic element.
-- Therefore, the position offset will be applied to all elements inside equally.
-- So, yes, begin group is used to group stuff, basically. In this case, we are grouping 4 menu elements. (Previously defined outside the render callback, like always)
window:add_menu_element_pos_offset(vec2.new(250/4, 5))
window:begin_group(function()
checkbox1:render("Enable Test 1", "Showcasing ...")
checkbox2:render("Enable Test 2")
checkbox3:render("Enable Test 3")
slider_float_test:render("Slider\nTest")
end)
end) then
-- You can do whatever you want here. If the code here is read it means that the popup is currently being rendered.
else
-- This means that the user clicked outside of the popup bounds (or released the mouse), so it shouldn't be rendered anymore.
is_popup_active = false
end
end
-- now, the window popup code:
local open_window_rect_v1 = vec2.new(13, 120)
local open_window_rect_v2 = vec2.new(123, 150)
local alpha2 = 120
if window:is_mouse_hovering_rect(open_window_rect_v1, open_window_rect_v2) then
alpha2 = 255
end
window:render_rect_filled(open_window_rect_v1, open_window_rect_v2, color.black(alpha2), 1.0)
window:render_rect(open_window_rect_v1, open_window_rect_v2, color.white(alpha2), 1.0, 1.0)
window:render_text(enums.window_enums.font_id.FONT_SMALL, vec2.new(open_window_rect_v1.x + 27, open_window_rect_v1.y + 7), color.white(255), "Open Me!")
if window:is_rect_clicked(open_window_rect_v1, open_window_rect_v2) then
window_popup:set_visibility(true)
is_window_popup_open = true
end
if is_window_popup_open then
-- window_popup:set_next_window_padding(vec2.new(33, 33))
window_popup:begin(enums.window_enums.window_resizing_flags.RESIZE_HEIGHT, true, color_picker_test:get(),
border_color, enums.window_enums.window_cross_visuals.DEFAULT, function()
local window_popup_title_text = "Window Popup Demo"
local window_popup_text_centered_x_pos = window:get_text_centered_x_pos(window_popup_title_text)
window:add_menu_element_pos_offset(vec2.new(window_popup_text_centered_x_pos, 10))
window:add_text_on_dynamic_pos(color.green_pale(255), window_popup_title_text)
window:add_separator(3.0, 3.0, 15.0, 0.0, color.new(100, 99, 150, 255))
window:add_menu_element_pos_offset(vec2.new(30, 20))
window:begin_group(function()
checkbox1:render("Enable Test 1", "Tooltip Test ...")
checkbox2:render("Enable Test 2")
checkbox3:render("Enable Test 3")
end)
end)
else
is_window_popup_open = false
end
end)
end)
And this is what you should be seeing, after running this code in-game:
If you noticed, in the first image, on the right of the main window, there are some drawings that we havn't covered yet. Try to do that yourself as an excercise.
tip
You will need to use the following functions: window:render_circle_filled, window:render_circle, window:render_triangle_filled_multicolor, window:render_rect_filled_multicolor,
window::render_bezier_quadratic, window:render_bezier_cubic, window:render_text.
However, you can be creative, look into the documentation the different possibilities available and make your own design, or if you have ideas, you can always request more features.
Advanceds - 1​
The Advanceds - Animations
If you look closely at the first image, you will notice there are some random circles on the left. These circles are not static, but animated.
You are more than welcome to do your own animations, but our windows provide a simple feature to animate widgets. First, we just need to declare the animations
(they behave like independant objects)
-- parameter 1: the id of the animation (integer)
-- parameter 2: the starting position of the animation (vec2)
-- parameter 3: the ending position of the animation (vec2)
-- parameter 4: the starting alpha of the animation (integer)
-- parameter 5: the ending (max alpha) of the animation (integer)
-- parameter 6: alpha speed (integer)
-- parameter 7: movement speed (integer)
-- parameter 8: animate only once (boolean)
local animation = window:animate_widget(1, vec2.new(0,0), vec2.new(50, 300), 0, 100, 100, 50, false)
local animation2 = window:animate_widget(2, vec2.new(0,0), vec2.new(180, 300), 0, 100, 80, 60, false)
local animation3 = window:animate_widget(3, vec2.new(0,0), vec2.new(210, 300), 0, 100, 100, 50, false)
local animation4 = window:animate_widget(4, vec2.new(300,0), vec2.new(50, 300), 0, 100, 105, 50, false)
The animation objects that we just created are returning a table. This table contains 2 elements:
1 - current_position (vec2)
2 - alpha (integer)
We are going to use these values to now draw our widgets accordingly:
window:render_circle(animation.current_position, 10.0, color.new(100, 99, 150, animation.alpha), 3.0)
window:render_circle(animation2.current_position, 10.0, color.green_pale(animation2.alpha), 3.0)
window:render_circle(animation3.current_position, 10.0, color.green_pale(animation3.alpha), 3.0)
window:render_circle(animation4.current_position, 10.0, color.new(100, 99, 150, animation3.alpha), 3.0)
And that's it. We now have some animated circles.
Advanceds - 2​
The Advanceds - Explaining Dynamic Drawing
If you remember, in the previous section we used window:add_menu_element_pos_offset() and :add_text_on_dynamic_pos() function.. I will try to explain how our windows work internally, giving a brief overview so you can understand how this works, more or less.
So, there are 2 ways to draw stuff in a window:
- Statically: function. this is very simple, since you are just basically hardcoding where you want to draw things, and they will be drawn there, not caring about other things that are currently being rendered in the window etc.
(Note that all positions that you pass to the functions that draw statically are relative to the current window position, not the screen position. So, if you pass vec2(100, 100), the actual position would be vec2(100 + window_position.x, 100 + window_position.y))
- Dynamically: function. this is a little bit more complex to work with. Let's say there is an internal position variable. This variable's value is a vec2, and it changes according to the dynamic widgets that we render.
For example, if the internal position variable currently has value vec2(100, 50) and we render something dynamically (a text, for example), this text will be rendered at the position vec2(100, 50) and this internal position variable will change according to the text bounds. Let's say the text size is vec2(50, 50). In this case, the internal position variable will be (after rendering the text), vec2(150, 100).
So far, this doesn't sound too bad, and the only native dynamic drawing functionality (by native I mean the only function that allows you to directly draw in the internal position variable) is the :add_text_on_dynamic_pos function.
However, we can still do cool stuff with this dynamic position offset, since we can manually add space. For example, we can just render a rectangle and then add the rectangle bounds to this internal position variable, so it's taken into account for multiple stuff (for example, scrollbars are dependant on the internal position variable). To do this, we have to use the function :add_artificial_item_bounds function.
By using :add_menu_element_pos_offset, :get_current_context_dynamic_drawing_offset, :add_artificial_item_bounds you can achieve very interesting results.
tip
Check the "Panel Debug Target - Show Auras Info" to dive deeper into this matter and see some use examples. In this case, I am using static text drawings and making them dynamic, so we can use the scrollbar (necessary since there are many auras and they don't fit on the screen), and also the "Remaining" is a number that varies a lot with time. If we didn't use static text, since the dynamic text varies according to the previous widgets sizes, all the line would have a very ugly flickering all the time, according to the "Remaining" number text size.
"The basic guide ends here. I hope you are having fun creating some cool visuals so far! Check all the available code examples and all the individual functions documentation, with their code examples, and play with them. That's the best way to learn after all. Cya soon as a fellow developer :)"
Best regards, Barney
Previous
Custom UI Functions 🪖
Next
Common Issues
OverviewBasics - 0
Basics - 1
Basics - 2
Basics - Last
Intermediates - 1
Intermediates - 2
Intermediates - 3
Intermediates - Last
Advanceds - 1
Advanceds - 2
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Barney's Basic Guide (With examples) 🎯 _ Project Sylvanas.html>

<Geometry _ Project Sylvanas.html>
Control Panel | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Control Panel
On this page
Control Panel
Overview​
The control_panel module is essentially a separate unique graphical window that allows the user to track and easily modify the state of specific menu elements whose values are of special importance or are designed to be modified constantly, so the user doesn't have to open the main menu every time. This is usually how the Control Panel might look like for an average user:
How it Works - Basic Explanation
To add elements to the Control Panel, we need to use a specific callback. The core is expecting a table containing some information on the menu elements that are going to be shown in the Control Panel window to return from that callback. When this information is correct, the menu elements can be displayed in the Control Panel window, allowing them to be modified by clicking on them.
note
Drag & Drop is also supported, although this approach requires a special handling that will be covered later.
How to Make it Work - Step by Step (With an Example)​
1- Include the Necessary Plugins
---@type key_helper
local key_helper = require("common/utility/key_helper")
---@type control_panel_helper
local control_panel_utility = require("common/utility/control_panel_helper")
2- Define your menu elements:
local combat_mode_enum =
{
AUTO = 1,
AOE = 2,
SINGLE = 3,
}
local combat_mode_options =
{
"Auto",
"AoE",
"Single"
}
local test_tree_node = core.menu.tree_node()
local menu =
{
-- note that we are initializing the keybinds with the value "7". This value corresponds to <span style={{color: "rgba(220, 220, 255, 0.6)"}}>"Unbinded"</span>.
-- We do this so the user has to manually set the key they want. Otherwise, this menu element won't appear
-- in the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span>, and will be treated as if its value were true.
enable_toggle = core.menu.keybind(7, false, "enable_toggle"),
switch_combat_mode = core.menu.keybind(7, false, "switch_combat_mode"),
soft_cooldown_toggle = core.menu.keybind(7, false, "soft_cooldown_toggle"),
heavy_cooldown_toggle = core.menu.keybind(7, false, "heavy_cooldown_toggle"),
combat_mode = core.menu.combobox(combat_mode_enum.AUTO, "combat_mode_auto_aoe_single"),
}
3- Define the Function to Render your Menu Elements:
local function on_render_menu_elements()
test_tree_node:render("Testing <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> Elements", function()
menu.enable_toggle:render("Enable Toggle")
menu.switch_combat_mode:render("Switch Combat Mode")
menu.soft_cooldown_toggle:render("Soft Cooldowns Toggle")
menu.combat_mode:render("Combat Mode", combat_mode_options)
end)
end
4- Define the Callback Function
local function on_control_panel_render()
-- this is how we build the toggle table that we return from the callback, as previously discussed:
local enable_toggle_key = menu.enable_toggle:get_key_code()
-- toggle table -> must have:
-- member 1: .name
-- member 2: .keybind (the menu element itself)
local enable_toggle =
{
name = "[My Plugin] Enable (" .. key_helper:get_key_name(enable_toggle_key) .. ") ",
keybind = menu.enable_toggle
}
local soft_toggle_key = menu.soft_cooldown_toggle:get_key_code()
local soft_cooldowns_toggle =
{
name = "[My Plugin] Soft Cooldowns (" .. key_helper:get_key_name(soft_toggle_key) .. ") ",
keybind = menu.soft_cooldown_toggle
}
-- combo table -> must have:
-- member 1: .name
-- member 2: .combobox (the menu element itself)
-- member 3: .preview_value (the current value that the combobox has, in string format)
-- member 4: .max_items (the amount of items that the combobox has)
local combat_mode_key = menu.switch_combat_mode:get_key_code()
local combat_mode = {
name = "[My Plugin] Combat Mode (" .. key_helper:get_key_name(combat_mode_key) .. ") ",
combobox = menu.combat_mode,
preview_value = combat_mode_options[menu.combat_mode:get()],
max_items = combat_mode_options
}
local hard_toggle_key = menu.heavy_cooldown_toggle:get_key_code()
local hard_cooldowns_toggle =
{
name = "[My Plugin] Hard Cooldowns (" .. key_helper:get_key_name(hard_toggle_key) .. ") ",
keybind = menu.heavy_cooldown_toggle
}
-- finally, we define the table that we are going to return from the callback
local control_panel_elements = {}
-- we use the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> utility to insert this menu element in the table that we are going to return. This function has
-- code that internally handles stuff related to <span style={{color: "rgba(150, 250, 200, 0.8)"}}>Drag & Drop</span>, so if you want to enable this functionality you must insert the
-- menu elements by using this table. Otherwise, you could just return the elements without using the ccontrol_panel_helper plugin,
-- but this way is recommended anyways for scalability reasons.
control_panel_utility:insert_toggle_(control_panel_elements, enable_toggle.name, enable_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, soft_cooldowns_toggle.name, soft_cooldowns_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, hard_cooldowns_toggle.name, hard_cooldowns_toggle.keybind, false)
control_panel_utility:insert_combo_(control_panel_elements, combat_mode.name, combat_mode.combobox,
combat_mode.preview_value, combat_mode.max_items, main_menu.switch_combat_mode, false)
return control_panel_elements
end
5- Use the Callbacks
-- finally, we just need to implement the callbacks. If we want drag and drop, we must also call on_update.
core.register_on_update_callback(function()
control_panel_utility:on_update(menu)
end)
core.register_on_render_control_panel_callback(on_control_panel_render)
core.register_on_render_menu_callback(on_render_menu_elements)
5- Summary
So far, this is all the code that we created:
---@type key_helper
local key_helper = require("common/utility/key_helper")
---@type control_panel_helper
local control_panel_utility = require("common/utility/control_panel_helper")
local combat_mode_enum =
{
AUTO = 1,
AOE = 2,
SINGLE = 3,
}
local combat_mode_options =
{
"Auto",
"AoE",
"Single"
}
local test_tree_node = core.menu.tree_node()
local menu =
{
-- note that we are initializing the keybinds with the value "7". This value corresponds to <span style={{color: "rgba(220, 220, 255, 0.6)"}}>"Unbinded"</span>.
-- We do this so the user has to manually set the key they want. Otherwise, this menu element won't appear
-- in the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span>, and will be treated as if its value were true.
enable_toggle = core.menu.keybind(7, false, "enable_toggle"),
switch_combat_mode = core.menu.keybind(7, false, "switch_combat_mode"),
soft_cooldown_toggle = core.menu.keybind(7, false, "soft_cooldown_toggle"),
heavy_cooldown_toggle = core.menu.keybind(7, false, "heavy_cooldown_toggle"),
combat_mode = core.menu.combobox(combat_mode_enum.AUTO, "combat_mode_auto_aoe_single"),
}
local function on_render_menu_elements()
test_tree_node:render("Testing <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> Elements", function()
menu.enable_toggle:render("Enable Toggle")
menu.switch_combat_mode:render("Switch Combat Mode")
menu.soft_cooldown_toggle:render("Soft Cooldowns Toggle")
menu.heavy_cooldown_toggle:render("Heavy Cooldowns Toggle")
menu.combat_mode:render("Combat Mode", combat_mode_options)
end)
end
local function on_control_panel_render()
-- this is how we build the toggle table that we return from the callback, as previously discussed:
local enable_toggle_key = menu.enable_toggle:get_key_code()
-- toggle table -> must have:
-- member 1: .name
-- member 2: .keybind (the menu element itself)
local enable_toggle =
{
name = "[My Plugin] Enable (" .. key_helper:get_key_name(enable_toggle_key) .. ") ",
keybind = menu.enable_toggle
}
local soft_toggle_key = menu.soft_cooldown_toggle:get_key_code()
local soft_cooldowns_toggle =
{
name = "[My Plugin] Soft Cooldowns (" .. key_helper:get_key_name(soft_toggle_key) .. ") ",
keybind = menu.soft_cooldown_toggle
}
-- combo table -> must have:
-- member 1: .name
-- member 2: .combobox (the menu element itself)
-- member 3: .preview_value (the current value that the combobox has, in string format)
-- member 4: .max_items (the amount of items that the combobox has)
local combat_mode_key = menu.switch_combat_mode:get_key_code()
local combat_mode = {
name = "[My Plugin] Combat Mode (" .. key_helper:get_key_name(combat_mode_key) .. ") ",
combobox = menu.combat_mode,
preview_value = combat_mode_options[menu.combat_mode:get()],
max_items = combat_mode_options
}
local hard_toggle_key = menu.heavy_cooldown_toggle:get_key_code()
local hard_cooldowns_toggle =
{
name = "[My Plugin] Hard Cooldowns (" .. key_helper:get_key_name(hard_toggle_key) .. ") ",
keybind = menu.heavy_cooldown_toggle
}
-- finally, we define the table that we are going to return from the callback
local control_panel_elements = {}
-- we use the <span style={{color: "rgba(255, 100, 200, 0.8)"}}>Control Panel</span> utility to insert this menu element in the table that we are going to return. This function has
-- code that internally handles stuff related to <span style={{color: "rgba(150, 250, 200, 0.8)"}}>Drag & Drop</span>, so if you want to enable this functionality you must insert the
-- menu elements by using this table. Otherwise, you could just return the elements without using the ccontrol_panel_helper plugin,
-- but this way is recommended anyways for scalability reasons.
control_panel_utility:insert_toggle_(control_panel_elements, enable_toggle.name, enable_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, soft_cooldowns_toggle.name, soft_cooldowns_toggle.keybind, false)
control_panel_utility:insert_toggle_(control_panel_elements, hard_cooldowns_toggle.name, hard_cooldowns_toggle.keybind, false)
control_panel_utility:insert_combo_(control_panel_elements, combat_mode.name, combat_mode.combobox,
combat_mode.preview_value, combat_mode.max_items, menu.switch_combat_mode, false)
return control_panel_elements
end
-- finally, we just need to implement the callbacks. If we want drag and drop, we must also call on_update.
core.register_on_update_callback(function()
control_panel_utility:on_update(menu)
end)
core.register_on_render_control_panel_callback(on_control_panel_render)
core.register_on_render_menu_callback(on_render_menu_elements)
If you run that code, you will see the following result:
Control Panel Behaviour Explanation​
As you can see in the previous video, the user can remove and add elements from the Control Panel manually. There are 2 ways to do this:
1- The menu element was dragged and dropped: In this case, the user can remove the element from the Control Panel by double-clicking with the right-mouse button on its hitbox.
2- The menu element keybind was set:
The user can also make the menu elements appear just by changing the keybind to another key different than the "Unbinded" one. In the same way, a user can remove an element from the Control Panel by setting its key value to "Unbinded" again (right clicking sets the value to default, which in the code example is "Unbinded" or "7").
note
To drag a menu element that has Drag & Drop enabled, you have to press SHIFT and then click. When the Drag & Drop is ready, you will see a box with the menu element name appear. Then, you can drag the said box to the Control Panel. When the Control Panel is higlighted in green, you can drop the box there. After that, you will see that the menu element is now successfully binded to the Control Panel.
warning
If a menu element was dragged and dropped in the Control Panel, setting its value to "Unbinded" won't remove it from the Control Panel. Instead, RMB double-click is mandatory.
Likewise, if a menu element was introduced to the Control Panel by setting its value to one different than "Unbinded", RMB double-click won't remove it from the Control Panel.
Tables Expected By The Callback​
1 - Toggle table
This table is reserved for toggle keybinds.
Its members must be the following:
1. name: The label that will appear in the Control Panel (string)
2. keybind: The keybind itself (menu_element)
2 - Combobox table
This table is reserved for comboboxes.
Its members must be the following:
1. name: The label that will appear in the Control Panel (string)
2. combobox: The combobox itself (menu_element)
3. preview_value`: The current value that the combobox currently has, in string format. (string)
4. max_items: The items that the combobox has (integer)
Registering the Callback​
The procedure is the same as with all other callbacks:
warning
Keep in mind that this callback expects a table as a return value. This is the only callback that expects a return value.
core.register_on_render_control_panel_callback(function()
local menu_elements_table = {}
-- your control panel code here
return menu_elements
end)
Or:
local function on_render_control_panel()
local menu_elements_table = {}
-- your control panel code here
return menu_elements
end
core.register_on_render_control_panel_callback(on_render_control_panel)
note
To use the following functions, you will need to include the Control Panel Helper module. To do this, you can just copy these lines:
---@type control_panel_helper
local control_panel_utility = require("common/utility/control_panel_helper")
Functions - Control Panel Helper​
on_update(menu)​
Updates the Control Panel elements by setting drag-and-drop flags based on the current Control Panel label.
Parameters:
menu (table) — The menu containing Control Panel elements to be updated.
Returns: nil
warning
You must call this function inside the on_update callback for Drag & Drop functionality to work for your menu elements. Ideally, call this function the first thing on your on_update function.
If this function is not called, Drag & Drop will not work.
insert_toggle(control_panel_table, toggle_table, only_drag_drop)​
Inserts a toggle into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the toggle will be inserted.
toggle_table (table) — The table containing the toggle element details.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the toggle was inserted successfully; otherwise, false.
insert_toggle_(control_panel_table, display_name, keybind_element, only_drag_drop)​
Inserts a toggle into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the toggle will be inserted.
display_name (string) — The name to be displayed for the toggle element.
keybind_element (userdata) — The keybind menu element.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the toggle was inserted successfully; otherwise, false.
insert_combo(control_panel_table, combo_table, increase_index_key, only_drag_drop)​
Inserts a combobox into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the combo will be inserted.
combo_table (table) — The table containing the combo element details.
increase_index_key (userdata, optional) — The keybind to increase the index, if applicable.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the combo was inserted successfully; otherwise, false.
insert_combo_(control_panel_table, display_name, combobox_element, preview_value, max_items, increase_index_key, only_drag_drop)​
Inserts a combobox into the Control Panel table if it is not already inserted and meets the specified criteria.
Parameters:
control_panel_table (table) — The Control Panel table where the combo will be inserted.
display_name (string) — The name to be displayed for the combo element.
combobox_element (userdata) — The combobox menu element.
preview_value (any) — The preview value to be shown for the combobox.
max_items (number) — The maximum number of items in the combobox.
increase_index_key (userdata, optional) — The keybind to increase the index, if applicable.
only_drag_drop (boolean, optional) — Flag to indicate if the insertion should only occur during drag-and-drop.
Returns: boolean — true if the combo was inserted successfully; otherwise, false.
Previous
Geometry
Next
Vector 2
OverviewHow to Make it Work - Step by Step (With an Example)
Control Panel Behaviour Explanation
Tables Expected By The Callback
Registering the Callback
Functions - Control Panel Helperon_update(menu)
insert_toggle(control_panel_table, toggle_table, only_drag_drop)
insert_toggle_(control_panel_table, display_name, keybind_element, only_drag_drop)
insert_combo(control_panel_table, combo_table, increase_index_key, only_drag_drop)
insert_combo_(control_panel_table, display_name, combobox_element, preview_value, max_items, increase_index_key, only_drag_drop)
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Geometry _ Project Sylvanas.html>

<Input _ Project Sylvanas.html>
Input | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Input
On this page
Input Functions and Spell Queue
Overview 📃​
In this module we introduce one of the most (if not the most) important features for scripting: a way to manage input from code. For now, this only includes spell casting. However, stay tuned to the changelogs, since other input methods like movement are planned to be supported in the near future.
The Way Raw Input Functions Work
Similar to what we previously discussed in the buffs page, the raw input functions that the game provides to us have some disadvantages. In this case, they are not FPS-related, but rather usability and safety related. These functions basically send a paquet to the game's server that mimics a legit spell cast or movement. Therefore, spamming raw inputs from code may be dangerous since you might be sending many more requests per seconds than any human would be able to send. So far, this is not a problem for us, but it's something to take into account for the future, as Blizzard anticheat evolves.
The real problem is usability 💥:
1 - Compatibility between plugins: If your scripts spam input requests, you will make everything else useless. For example, other modules like "Core Interrupt" might want to cast a spell to interrupt an important enemy cast. This usually has more priority than the normal damage rotation, but since you are flooding the server with your requests, the interruptor spell cast request won't have a chance to be sent.
2 - User Experience: If your script spam input requests you make the user unable to cast their own spells manually. As you could imagine, there might me certain situations in which the users have to cast certain spells on their own, so blocking this could be very frustrating them. To fix this, we handle everything in our LUA Spell Queue Module, which will be explained in detail below.
warning
You can still use raw input functions, but at your own risk. We advise you to read thoroughly the previous explanation and check if you really really need to use the raw functions. If you have any question,
contact us and we will guide you through without any problem
- Better safe than sorry. ❤️
note
For some items that don't have global cooldown, the raw "Use Item" functions are perfectly fine, just make sure to add checks before the cast so you don't spam when the item isn't ready.
Raw Input Functions 📃​
Cast Target Spell 💣​
core.input.cast_target_spell(spell_id: integer, target: game_object) -> boolean
Cast a spell directly at a target.
Parameters:
spell_id: The ID of your chosen spell
target: The game_object that you want to cast the spell to
Returns: true if the spell was cast, false if it fizzled
note
This function JUST sends a cast request to the server. It doesn't check if the enemy is close enough, if you are facing it, if the spell is ready, etc. Therefore, you must apply all these checks before casting. To do so, we created a LUA Spell Helper module that will make the job very easy. Check spell book.
We advise you to check the Spell Book module before jumping into input code. This is the proper way you should be casting spells:
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 0.50 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- since this is just a test, we will just get the hud target
local hud_target = local_player:get_target()
-- only cast the fireball when there is a target selected
if not hud_target then
return
end
-- avoid spamming cast request while already casting
-- NOTE: in your scripts, you might want to do the same for channels.
-- approach 1: take into account network latency
-- local network = plugin_helper:get_latency()
-- local cast_end_time = local_player:get_active_spell_cast_end_time()
-- local cast_delta = math.max(cast_end_time - current_time, 0.0)
-- if cast_delta > (network * 1000) then
-- return
-- end
-- approach 2: more simple, works well in most cases.
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
local fireball_id = 133
-- check first if the spell is castable, so we avoid sending useless packets (the script will be stuck permanently trying to cast a spell that can't be casted)
local can_cast_fireball = spell_helper:is_spell_castable(fireball_id, local_player, hud_target, false, false)
if not can_cast_fireball then
return
end
local spell_cast = core.input.cast_target_spell(fireball_id, hud_target)
if spell_cast then
core.log("Fireball Cast!")
last_cast_time = current_time
end
end)
This example might be an overkill, specially if you are a beginner and are learning. Feel free to play with the code and go step by step. However, if you want to produce good quality products, consider adding at least all the steps specified in the previous example to your casts.
Cast Position Spell 💣​
core.input.cast_position_spell(spell_id: integer, position: vec3) -> boolean
Cast a spell at a specific location in the world.
Parameters:
spell_id: Your spell's ID
position: The XYZ coordinates for your spell. See vec3
Returns: true if cast successfully, false if not
note
This function is only used for spells that don't require a target game_object, but instead require a target position. This is usually the case for some AOE spells like Blizzard or Flamestrike.
Let's cast a Flamestrike:
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 0.50 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- since this is just a test, we will just get the hud target
local hud_target = local_player:get_target()
-- only cast the fireball when there is a target selected
if not hud_target then
return
end
-- avoid spamming cast request while already casting
-- NOTE: in your scripts, you might want to do the same for channels.
-- approach 1: take into account network latency
-- local network = plugin_helper:get_latency()
-- local cast_end_time = local_player:get_active_spell_cast_end_time()
-- local cast_delta = math.max(cast_end_time - current_time, 0.0)
-- if cast_delta > (network * 1000) then
-- return
-- end
-- approach 2: more simple, works well in most cases.
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
local flamestrike_id = 2120
-- check first if the spell is castable, so we avoid sending useless packets (the script will be stuck permanently trying to cast a spell that can't be casted)
local can_cast_fireball = spell_helper:is_spell_castable(flamestrike_id, local_player, hud_target, false, false)
if not can_cast_fireball then
return
end
local position_to_cast = hud_target:get_position()
local spell_cast = core.input.cast_position_spell(flamestrike_id, position_to_cast)
if spell_cast then
core.log("Flamestrike Cast On Target Position!")
last_cast_time = current_time
end
end)
tip
As you can see, in the previous example we are casting the spell to the target's position, without any further checks. For AOE spells, you would ideally want to cast on the position that would hit the most enemies, which is usually not the same as your main target's position. To do this, you should use some sort of algorithm to determine which is the actual best point to cast, according to your spell's characteristics. To do this, we have developed the
"Spell Prediction" module. See Spell Prediction Module
Use Item 🎭​
We have three item usage functions, each with its own purpose:
1- Item Self-Cast
core.input.use_item(item_id: integer) -> boolean
This function is used for items that don't require a target or a target position.
2- Item Targeted-Cast
core.input.use_item_target(item_id: integer, target: game_object) -> boolean
This function is used for items that require a target or a target position.
3- Item Position-Cast
core.input.use_item_position(item_id: integer, position: vec3) -> boolean
Use an item at a specific location. (Note: This feature is still in development)
tip
Most items don't have a global cooldown, so these raw functions are usually fine, as we discussed earlier. However,
for items that apply GCD, consider using the spell_queue.
The code for casting items is pretty similar to the code for casting spells. You just have to be careful with the way you check if the item is ready, since it's different from checking if a spell is ready. Below, a simple example on how to cast a health potion:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 5.0 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
-- the potion for this example is the "Greater Healing Potion"
local potion_id = 1710
local item_cooldown = local_player:get_item_cooldown(potion_id)
local can_cast_potion = item_cooldown <= 0.0
if not can_cast_potion then
return false
end
-- we add this check so the potion is not attempted to be cast while full HP, since the game won't allow it.
if unit_helper:get_health_percentage(local_player) >= 1.0 then
return false
end
local spell_cast = core.input.use_item(potion_id)
if spell_cast then
core.log("Potion cast!")
last_cast_time = current_time
end
end)
Set Target 🎯​
core.input.set_target(unit: game_object) -> boolean
Set your current target.
Returns: true if targeting was successful, false if not
Example:
local local_player = core.object_manager.get_local_player()
if local_player then
local player_position = local_player:get_position()
local nearby_enemies = unit_helper:get_enemy_list_around(player_position, 30)
for _, unit in ipairs(nearby_enemies) do
local success = core.input.set_target(unit)
if success then
core.log("New target acquired! 🎯")
break
else
core.log("Targeting failed. They're quick! 💨")
end
end
end
Set and Get Focus 🔍​
core.input.set_focus(unit: game_object) -> boolean: Set your focus target
core.input.get_focus() -> game_object | nil: Retrieve your current focus
Checking your focus:
local current_focus = core.input.get_focus()
if current_focus then
core.log("Current focus: " .. current_focus:get_name() .. " 🔍")
else
core.log("No focus set currently")
end
Spell Queue Module: Advanced Spell Management 🧠​
As discussed earlier, spell_queue module offers sophisticated spell management with priority queuing. It's the go-to tool for complex spell rotations and efficient casting, and what you should be using in most cases.
The Way The Spell Queue Module Works
Basically, this module just implements a priority queue for spell casts. When you send a spell cast request, it's added into the queue with a priority value that's passed by parameter. The queue is sorted every frame according to the priority values of the elements inside the said data structure. This way, we can make sure that the most important spells are casted before the less important ones, and we also secure compatibility between plugins, as any plugin can send a cast request at any given time.
Importing the Module​
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")
warning
Remember to use the colon (:) when calling spell_queue methods!
Queue Spell with Target 🎯​
spell_queue:queue_spell_target(spell_id: number, target: game_object, priority: number, message?: string)
Queue a targeted spell with priority.
priority: Higher numbers = higher priority (1 is default, 9 is highest)
message: Optional logging message
Queueing a Fireball:
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 0.50 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- since this is just a test, we will just get the hud target
local hud_target = local_player:get_target()
-- only cast the fireball when there is a target selected
if not hud_target then
return
end
-- avoid spamming cast request while already casting
-- NOTE: in your scripts, you might want to do the same for channels.
-- approach 1: take into account network latency
-- local network = plugin_helper:get_latency()
-- local cast_end_time = local_player:get_active_spell_cast_end_time()
-- local cast_delta = math.max(cast_end_time - current_time, 0.0)
-- if cast_delta > (network * 1000) then
-- return
-- end
-- approach 2: more simple, works well in most cases.
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
local fireball_id = 133
-- check first if the spell is castable, so we avoid sending useless packets (the script will be stuck permanently trying to cast a spell that can't be casted)
local can_cast_fireball = spell_helper:is_spell_castable(fireball_id, local_player, hud_target, false, false)
if not can_cast_fireball then
return
end
spell_queue:queue_spell_target(fireball_id, hud_target, 1, "Trying to cast fireball!")
last_cast_time = current_time
end)
As you can see, the code is pretty much the same as the code that we would use for raw functions, the only thing that changes is the way we are attempting to cast the spell.
Queue Fast Spell with Target 🎯​
spell_queue:queue_spell_target_fast(spell_id: number, target: game_object, priority: number, message?: string)
The code would be exactly the same as the previous example, you just need to replace the queue spell function call.
Queue Spell with Position 🎯​
spell_queue:queue_spell_position(spell_id: number, position: vec3, priority: number, message?: string)
Queue a position-based spell.
As you can imagine, the code to cast Flamestrike using spell queue is pretty much the same as the code we used to cast Flamestrike with raw spells, the only thing that changes is the way we are issuing the actual cast. So, maybe it's more interesting to use the spell prediction for a smart Blizzard cast for this example:
local local_player = core.object_manager.get_local_player()
if local_player then
local hud_target = local_player:get_target()
if hud_target then
local blizzard_id = 10
local player_position = local_player:get_position()
local prediction_spell_data = spell_prediction:new_spell_data(
blizzard_id, -- spell_id
30, -- range
6, -- radius
0.2, -- cast_time
0.0, -- projectile_speed
spell_prediction.prediction_type.MOST_HITS, -- prediction_type
spell_prediction.geometry_type.CIRCLE, -- geometry_type
player_position -- source_position
)
local prediction_result = spell_prediction:get_cast_position(hud_target, prediction_spell_data)
if prediction_result and prediction_result.amount_of_hits > 0 then
spell_queue:queue_spell_position(blizzard_id, prediction_result.cast_position, 1, "Queueing Blizzard at optimal position")
end
end
end
This code:
Sets up a Blizzard spell with prediction data
Uses MOST_HITS prediction type to maximize the spell's impact
Queues the Blizzard at the optimal position if targets are predicted to be hit
note
As you can see, we call prediction_type.MOST_HITS to fire Death and Decay on the Priest. Instead of casting on the center, it strategically places the spell slightly to the left to hit extra dummies aswell.
tip
Test with the prediction_type.ACCURACY values for pinpointing situations where the cast should be avoided
Queue Fast Spell with Position 🎯​
spell_queue:queue_spell_position_fast(spell_id: number, position: vec3, priority: number, message?: string)
Queue a position-based spell that ignores the global cooldown.
The code would be exactly the same as the previous example, you just need to replace the queue spell function call
Best Practices 🧙‍♂️💡​
1- Embrace the Spell Queue
2- Remember the priority scale (1-9). Use it to create sophisticated casting logic.
warning
Be cautious with priority levels! While 1 is the default,
higher priorities should be applied only when absolutely necessary.
1 is the default priority, intended for the majority of spells in the standard rotation. Developers should strive to keep spells at priority 1 unless a clear, specific reason justifies using a higher priority. This preserves rotation efficiency and prevents disruption.
Higher priorities are intended for spells that require urgent action outside the rotation. For example, interrupts use priority 7 to ensure they execute immediately when conditions demand it, as timing is crucial for effective interruption. Core utility spells, such as racials, dispels, or spell reflections, are typically set between 4 to 6. They preempt the rotation without overshadowing interrupts, allowing critical utilities to occur in time-sensitive situations.
Finally, priority 9 is exclusively reserved for manual player actions, ensuring that the player’s chosen spell overrides any automated rotation or interrupt, with no delay.
In short, unless there is a compelling plan, stick with priority 1 for your spells. Use 2 only if you have a strong plan.
3- Fast Track Important Spells
Use _fast versions for critical, non-GCD spells.
4- Leave Breadcrumbs
Use the message parameter in spell_queue for easier debugging.
5- Learn to Use The Prediction Module
The spell_prediction module is powerful and easy to use library to evolve your logics.
Remember, mastering these tools takes practice. Experiment with different combinations and priorities to find what works best for your scripting needs.
Previous
Menu Elements
Next
Geometry
Overview 📃
Raw Input Functions 📃Cast Target Spell 💣
Cast Position Spell 💣
Use Item 🎭
Set Target 🎯
Set and Get Focus 🔍
Spell Queue Module: Advanced Spell Management 🧠Importing the Module
Queue Spell with Target 🎯
Queue Fast Spell with Target 🎯
Queue Spell with Position 🎯
Queue Fast Spell with Position 🎯
Best Practices 🧙‍♂️💡
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Input _ Project Sylvanas.html>

<Inventory Helper _ Project Sylvanas.html>
Inventory Helper | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
Inventory Helper
On this page
Inventory Helper
Overview​
The Inventory Helper module provides a comprehensive set of utility functions that aims to make your life easier when working with items. Below, we'll explore its functionality.
Including the Module​
As with all other LUA modules developed by us, you will need to import the Inventory Helper module into your project. To do so, you can use the following lines:
---@type inventory_helper
local inventory_helper = require("common/utility/inventory_helper")
warning
To access the module's functions, you must use : instead of .
For example, this code is not correct:
---@type inventory_helper
local inventory_helper = require("common/utility/pvp_helper")
local function check_if_player(unit)
return inventory_helper.get_bank_slots(unit)
end
And this would be the corrected code:
---@type inventory_helper
local inventory_helper = require("common/utility/pvp_helper")
local function check_if_player(unit)
return inventory_helper:get_bank_slots(unit)
end
Functions​
get_all_slots() -> table<slot_data>​
Retrieves all item slots available to the player, including both character bags and bank slots.
Returns:
slots (table<slot_data>): A table containing slot data for all items.
get_character_bag_slots() -> table<slot_data>​
Retrieves all item slots from the character's bags, excluding bank slots.
Returns:
slots (table<slot_data>): A table containing slot data for items in character bags.
get_bank_slots() -> table<slot_data>​
Retrieves all item slots from the bank.
Returns:
slots (table<slot_data>): A table containing slot data for items in the bank.
get_current_consumables_list() -> table<consumable_data>​
Retrieves a list of consumables currently in the player's inventory.
Returns:
consumables (table<consumable_data>): A table containing data for each consumable item.
update_consumables_list()​
Updates the internal list of consumables. Call this function whenever the inventory changes to refresh the consumables list.
Example:
---@type inventory_helper
local inventory_helper = require("common/utility/pvp_helper")
-- After picking up new consumables
inventory_helper:update_consumables_list()
debug_print_consumables()​
Prints the current consumables list to the debug log for debugging purposes.
Data Structures​
Slot Data Structure 🎒​
The slot_data class represents an item slot in the inventory or bank.
Fields:​
item (game_object): The item object in this slot.
global_slot (number): Global slot identifier.
bag_id (integer): ID of the bag containing the item.
bag_slot (integer): Slot number within the bag.
stack_count (integer): Stack count of the item in this slot.
Example:
local slot = all_slots[1]
core.log("Item: " .. slot.item:get_name())
core.log("Stack Count: " .. tostring(slot.stack_count))
Consumable Data Structure 🧪​
The consumable_data class represents a consumable item in the inventory.
Fields:​
is_mana_potion (boolean): Whether the item is a mana potion.
is_health_potion (boolean): Whether the item is a health potion.
is_damage_bonus_potion (boolean): Whether the item is a damage bonus potion.
item (game_object): The item object for the consumable.
bag_id (integer): ID of the bag containing the item.
bag_slot (integer): Slot number within the bag.
stack_count (integer): Stack count of the item in this slot.
Examples​
Iterating Over All Inventory Slots​
---@type inventory_helper
local inventory = require("common/utility/inventory_helper")
local function print_all_items()
local all_slots = inventory:get_all_slots()
for _, slot in ipairs(all_slots) do
core.log("Item: " .. slot.item:get_name() .. " in slot: " .. tostring(slot.global_slot))
end
end
print_all_items()
Previous
PvP UI Module Library
Next
Dungeons Helper
Overview
Including the Module
Functionsget_all_slots() -> table<slot_data>
get_character_bag_slots() -> table<slot_data>
get_bank_slots() -> table<slot_data>
get_current_consumables_list() -> table<consumable_data>
update_consumables_list()
debug_print_consumables()
Data StructuresSlot Data Structure 🎒
Consumable Data Structure 🧪
ExamplesIterating Over All Inventory Slots
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Inventory Helper _ Project Sylvanas.html>

<Menu Elements _ Project Sylvanas.html>
Input | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Input
On this page
Input Functions and Spell Queue
Overview 📃​
In this module we introduce one of the most (if not the most) important features for scripting: a way to manage input from code. For now, this only includes spell casting. However, stay tuned to the changelogs, since other input methods like movement are planned to be supported in the near future.
The Way Raw Input Functions Work
Similar to what we previously discussed in the buffs page, the raw input functions that the game provides to us have some disadvantages. In this case, they are not FPS-related, but rather usability and safety related. These functions basically send a paquet to the game's server that mimics a legit spell cast or movement. Therefore, spamming raw inputs from code may be dangerous since you might be sending many more requests per seconds than any human would be able to send. So far, this is not a problem for us, but it's something to take into account for the future, as Blizzard anticheat evolves.
The real problem is usability 💥:
1 - Compatibility between plugins: If your scripts spam input requests, you will make everything else useless. For example, other modules like "Core Interrupt" might want to cast a spell to interrupt an important enemy cast. This usually has more priority than the normal damage rotation, but since you are flooding the server with your requests, the interruptor spell cast request won't have a chance to be sent.
2 - User Experience: If your script spam input requests you make the user unable to cast their own spells manually. As you could imagine, there might me certain situations in which the users have to cast certain spells on their own, so blocking this could be very frustrating them. To fix this, we handle everything in our LUA Spell Queue Module, which will be explained in detail below.
warning
You can still use raw input functions, but at your own risk. We advise you to read thoroughly the previous explanation and check if you really really need to use the raw functions. If you have any question,
contact us and we will guide you through without any problem
- Better safe than sorry. ❤️
note
For some items that don't have global cooldown, the raw "Use Item" functions are perfectly fine, just make sure to add checks before the cast so you don't spam when the item isn't ready.
Raw Input Functions 📃​
Cast Target Spell 💣​
core.input.cast_target_spell(spell_id: integer, target: game_object) -> boolean
Cast a spell directly at a target.
Parameters:
spell_id: The ID of your chosen spell
target: The game_object that you want to cast the spell to
Returns: true if the spell was cast, false if it fizzled
note
This function JUST sends a cast request to the server. It doesn't check if the enemy is close enough, if you are facing it, if the spell is ready, etc. Therefore, you must apply all these checks before casting. To do so, we created a LUA Spell Helper module that will make the job very easy. Check spell book.
We advise you to check the Spell Book module before jumping into input code. This is the proper way you should be casting spells:
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 0.50 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- since this is just a test, we will just get the hud target
local hud_target = local_player:get_target()
-- only cast the fireball when there is a target selected
if not hud_target then
return
end
-- avoid spamming cast request while already casting
-- NOTE: in your scripts, you might want to do the same for channels.
-- approach 1: take into account network latency
-- local network = plugin_helper:get_latency()
-- local cast_end_time = local_player:get_active_spell_cast_end_time()
-- local cast_delta = math.max(cast_end_time - current_time, 0.0)
-- if cast_delta > (network * 1000) then
-- return
-- end
-- approach 2: more simple, works well in most cases.
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
local fireball_id = 133
-- check first if the spell is castable, so we avoid sending useless packets (the script will be stuck permanently trying to cast a spell that can't be casted)
local can_cast_fireball = spell_helper:is_spell_castable(fireball_id, local_player, hud_target, false, false)
if not can_cast_fireball then
return
end
local spell_cast = core.input.cast_target_spell(fireball_id, hud_target)
if spell_cast then
core.log("Fireball Cast!")
last_cast_time = current_time
end
end)
This example might be an overkill, specially if you are a beginner and are learning. Feel free to play with the code and go step by step. However, if you want to produce good quality products, consider adding at least all the steps specified in the previous example to your casts.
Cast Position Spell 💣​
core.input.cast_position_spell(spell_id: integer, position: vec3) -> boolean
Cast a spell at a specific location in the world.
Parameters:
spell_id: Your spell's ID
position: The XYZ coordinates for your spell. See vec3
Returns: true if cast successfully, false if not
note
This function is only used for spells that don't require a target game_object, but instead require a target position. This is usually the case for some AOE spells like Blizzard or Flamestrike.
Let's cast a Flamestrike:
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 0.50 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- since this is just a test, we will just get the hud target
local hud_target = local_player:get_target()
-- only cast the fireball when there is a target selected
if not hud_target then
return
end
-- avoid spamming cast request while already casting
-- NOTE: in your scripts, you might want to do the same for channels.
-- approach 1: take into account network latency
-- local network = plugin_helper:get_latency()
-- local cast_end_time = local_player:get_active_spell_cast_end_time()
-- local cast_delta = math.max(cast_end_time - current_time, 0.0)
-- if cast_delta > (network * 1000) then
-- return
-- end
-- approach 2: more simple, works well in most cases.
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
local flamestrike_id = 2120
-- check first if the spell is castable, so we avoid sending useless packets (the script will be stuck permanently trying to cast a spell that can't be casted)
local can_cast_fireball = spell_helper:is_spell_castable(flamestrike_id, local_player, hud_target, false, false)
if not can_cast_fireball then
return
end
local position_to_cast = hud_target:get_position()
local spell_cast = core.input.cast_position_spell(flamestrike_id, position_to_cast)
if spell_cast then
core.log("Flamestrike Cast On Target Position!")
last_cast_time = current_time
end
end)
tip
As you can see, in the previous example we are casting the spell to the target's position, without any further checks. For AOE spells, you would ideally want to cast on the position that would hit the most enemies, which is usually not the same as your main target's position. To do this, you should use some sort of algorithm to determine which is the actual best point to cast, according to your spell's characteristics. To do this, we have developed the
"Spell Prediction" module. See Spell Prediction Module
Use Item 🎭​
We have three item usage functions, each with its own purpose:
1- Item Self-Cast
core.input.use_item(item_id: integer) -> boolean
This function is used for items that don't require a target or a target position.
2- Item Targeted-Cast
core.input.use_item_target(item_id: integer, target: game_object) -> boolean
This function is used for items that require a target or a target position.
3- Item Position-Cast
core.input.use_item_position(item_id: integer, position: vec3) -> boolean
Use an item at a specific location. (Note: This feature is still in development)
tip
Most items don't have a global cooldown, so these raw functions are usually fine, as we discussed earlier. However,
for items that apply GCD, consider using the spell_queue.
The code for casting items is pretty similar to the code for casting spells. You just have to be careful with the way you check if the item is ready, since it's different from checking if a spell is ready. Below, a simple example on how to cast a health potion:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 5.0 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
-- the potion for this example is the "Greater Healing Potion"
local potion_id = 1710
local item_cooldown = local_player:get_item_cooldown(potion_id)
local can_cast_potion = item_cooldown <= 0.0
if not can_cast_potion then
return false
end
-- we add this check so the potion is not attempted to be cast while full HP, since the game won't allow it.
if unit_helper:get_health_percentage(local_player) >= 1.0 then
return false
end
local spell_cast = core.input.use_item(potion_id)
if spell_cast then
core.log("Potion cast!")
last_cast_time = current_time
end
end)
Set Target 🎯​
core.input.set_target(unit: game_object) -> boolean
Set your current target.
Returns: true if targeting was successful, false if not
Example:
local local_player = core.object_manager.get_local_player()
if local_player then
local player_position = local_player:get_position()
local nearby_enemies = unit_helper:get_enemy_list_around(player_position, 30)
for _, unit in ipairs(nearby_enemies) do
local success = core.input.set_target(unit)
if success then
core.log("New target acquired! 🎯")
break
else
core.log("Targeting failed. They're quick! 💨")
end
end
end
Set and Get Focus 🔍​
core.input.set_focus(unit: game_object) -> boolean: Set your focus target
core.input.get_focus() -> game_object | nil: Retrieve your current focus
Checking your focus:
local current_focus = core.input.get_focus()
if current_focus then
core.log("Current focus: " .. current_focus:get_name() .. " 🔍")
else
core.log("No focus set currently")
end
Spell Queue Module: Advanced Spell Management 🧠​
As discussed earlier, spell_queue module offers sophisticated spell management with priority queuing. It's the go-to tool for complex spell rotations and efficient casting, and what you should be using in most cases.
The Way The Spell Queue Module Works
Basically, this module just implements a priority queue for spell casts. When you send a spell cast request, it's added into the queue with a priority value that's passed by parameter. The queue is sorted every frame according to the priority values of the elements inside the said data structure. This way, we can make sure that the most important spells are casted before the less important ones, and we also secure compatibility between plugins, as any plugin can send a cast request at any given time.
Importing the Module​
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")
warning
Remember to use the colon (:) when calling spell_queue methods!
Queue Spell with Target 🎯​
spell_queue:queue_spell_target(spell_id: number, target: game_object, priority: number, message?: string)
Queue a targeted spell with priority.
priority: Higher numbers = higher priority (1 is default, 9 is highest)
message: Optional logging message
Queueing a Fireball:
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type plugin_helper
local plugin_helper = require("common/utility/plugin_helper")
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")
local last_cast_time = 0.0
core.register_on_update_callback(function()
-- if we remove this check, you will see in the console that more than 1 cast request is issued.
-- To avoid this and only send one (this is good practice behaviour), we add a minimum delay of 0.25 seconds
-- for this function to be ran again.
local current_time = core.game_time()
if current_time - last_cast_time < 0.50 then
return false
end
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
-- since this is just a test, we will just get the hud target
local hud_target = local_player:get_target()
-- only cast the fireball when there is a target selected
if not hud_target then
return
end
-- avoid spamming cast request while already casting
-- NOTE: in your scripts, you might want to do the same for channels.
-- approach 1: take into account network latency
-- local network = plugin_helper:get_latency()
-- local cast_end_time = local_player:get_active_spell_cast_end_time()
-- local cast_delta = math.max(cast_end_time - current_time, 0.0)
-- if cast_delta > (network * 1000) then
-- return
-- end
-- approach 2: more simple, works well in most cases.
local cast_end_time = local_player:get_active_spell_cast_end_time()
if current_time <= cast_end_time then
return
end
local fireball_id = 133
-- check first if the spell is castable, so we avoid sending useless packets (the script will be stuck permanently trying to cast a spell that can't be casted)
local can_cast_fireball = spell_helper:is_spell_castable(fireball_id, local_player, hud_target, false, false)
if not can_cast_fireball then
return
end
spell_queue:queue_spell_target(fireball_id, hud_target, 1, "Trying to cast fireball!")
last_cast_time = current_time
end)
As you can see, the code is pretty much the same as the code that we would use for raw functions, the only thing that changes is the way we are attempting to cast the spell.
Queue Fast Spell with Target 🎯​
spell_queue:queue_spell_target_fast(spell_id: number, target: game_object, priority: number, message?: string)
The code would be exactly the same as the previous example, you just need to replace the queue spell function call.
Queue Spell with Position 🎯​
spell_queue:queue_spell_position(spell_id: number, position: vec3, priority: number, message?: string)
Queue a position-based spell.
As you can imagine, the code to cast Flamestrike using spell queue is pretty much the same as the code we used to cast Flamestrike with raw spells, the only thing that changes is the way we are issuing the actual cast. So, maybe it's more interesting to use the spell prediction for a smart Blizzard cast for this example:
local local_player = core.object_manager.get_local_player()
if local_player then
local hud_target = local_player:get_target()
if hud_target then
local blizzard_id = 10
local player_position = local_player:get_position()
local prediction_spell_data = spell_prediction:new_spell_data(
blizzard_id, -- spell_id
30, -- range
6, -- radius
0.2, -- cast_time
0.0, -- projectile_speed
spell_prediction.prediction_type.MOST_HITS, -- prediction_type
spell_prediction.geometry_type.CIRCLE, -- geometry_type
player_position -- source_position
)
local prediction_result = spell_prediction:get_cast_position(hud_target, prediction_spell_data)
if prediction_result and prediction_result.amount_of_hits > 0 then
spell_queue:queue_spell_position(blizzard_id, prediction_result.cast_position, 1, "Queueing Blizzard at optimal position")
end
end
end
This code:
Sets up a Blizzard spell with prediction data
Uses MOST_HITS prediction type to maximize the spell's impact
Queues the Blizzard at the optimal position if targets are predicted to be hit
note
As you can see, we call prediction_type.MOST_HITS to fire Death and Decay on the Priest. Instead of casting on the center, it strategically places the spell slightly to the left to hit extra dummies aswell.
tip
Test with the prediction_type.ACCURACY values for pinpointing situations where the cast should be avoided
Queue Fast Spell with Position 🎯​
spell_queue:queue_spell_position_fast(spell_id: number, position: vec3, priority: number, message?: string)
Queue a position-based spell that ignores the global cooldown.
The code would be exactly the same as the previous example, you just need to replace the queue spell function call
Best Practices 🧙‍♂️💡​
1- Embrace the Spell Queue
2- Remember the priority scale (1-9). Use it to create sophisticated casting logic.
warning
Be cautious with priority levels! While 1 is the default,
higher priorities should be applied only when absolutely necessary.
1 is the default priority, intended for the majority of spells in the standard rotation. Developers should strive to keep spells at priority 1 unless a clear, specific reason justifies using a higher priority. This preserves rotation efficiency and prevents disruption.
Higher priorities are intended for spells that require urgent action outside the rotation. For example, interrupts use priority 7 to ensure they execute immediately when conditions demand it, as timing is crucial for effective interruption. Core utility spells, such as racials, dispels, or spell reflections, are typically set between 4 to 6. They preempt the rotation without overshadowing interrupts, allowing critical utilities to occur in time-sensitive situations.
Finally, priority 9 is exclusively reserved for manual player actions, ensuring that the player’s chosen spell overrides any automated rotation or interrupt, with no delay.
In short, unless there is a compelling plan, stick with priority 1 for your spells. Use 2 only if you have a strong plan.
3- Fast Track Important Spells
Use _fast versions for critical, non-GCD spells.
4- Leave Breadcrumbs
Use the message parameter in spell_queue for easier debugging.
5- Learn to Use The Prediction Module
The spell_prediction module is powerful and easy to use library to evolve your logics.
Remember, mastering these tools takes practice. Experiment with different combinations and priorities to find what works best for your scripting needs.
Previous
Menu Elements
Next
Geometry
Overview 📃
Raw Input Functions 📃Cast Target Spell 💣
Cast Position Spell 💣
Use Item 🎭
Set Target 🎯
Set and Get Focus 🔍
Spell Queue Module: Advanced Spell Management 🧠Importing the Module
Queue Spell with Target 🎯
Queue Fast Spell with Target 🎯
Queue Spell with Position 🎯
Queue Fast Spell with Position 🎯
Best Practices 🧙‍♂️💡
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Menu Elements _ Project Sylvanas.html>

<Object Manager _ Project Sylvanas.html>
Object Manager | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Object Manager
On this page
Lua Object Manager
Introduction 📃​
The Lua Object Manager module is your gateway to interacting with game objects in your scripts. While the core engine provides fundamental functions, we've developed additional tools to enhance your scripting capabilities and optimize performance. Let's explore how to leverage these features effectively!
Raw Functions 💣​
Local Player​
core.object_manager.get_local_player() -> game_object​
Retrieves the local player game_object.
Returns: game_object - The local player game_object.
tip
Always verify the local player object before use. Implement a guard clause in your callbacks to prevent errors and ensure safe execution. Remember, the local_player is a pointer (8 bytes) to the game memory object, which can become invalid. Check its existence before each use.
Example of a guard clause:
local function on_update()
local local_player = core.object_manager.get_local_player()
if not local_player then
return -- Exit early if local_player is invalid
end
-- Your logic here, safely using local_player
end
This approach maintains code stability and prevents accessing invalid memory addresses.
All Objects​
core.object_manager.get_all_objects() -> table​
Retrieves all game objects.
Returns: table - A table containing all game_objects.
warning
Use get_all_objects() and get_visible_objects() judiciously. These functions return a comprehensive list, including non-unit entities, which can be computationally expensive to process every frame.
For most scenarios, our custom unit_helper library (discussed later) is recommended for optimized performance and more relevant object lists.
tip
New to scripting? Visualize objects with this example:
---@type color
local color = require("common/color")
core.register_on_render_callback(function()
local all_objects = core.object_manager.get_all_objects()
for _, object in ipairs(all_objects) do
local current_object_position = object:get_position()
core.graphics.circle_3d(current_object_position, 2.0, color.cyan(100), 30.0, 1.5)
end
end)
Code breakdown:
Import the color module for color creation.
Register a function for frame rendering.
Retrieve all game objects.
Iterate through each object.
Get each object's position (returns a vec3).
Draw a 3D circle at each position:
Center: Object's position
Radius: 2.0 yards
Color: Cyan (alpha 100)
Thickness: 30.0 units
Fade factor: 1.5 (higher value = faster fade)
This visualization helps you grasp the scope of objects returned by get_all_objects().
tip
Want to dive deeper? Try accessing more object properties:
---@type enums
local enums = require("common/enums")
core.register_on_render_callback(function()
local all_objects = core.object_manager.get_all_objects()
for _, object in ipairs(all_objects) do
local name = object:get_name()
local health = object:get_health()
local max_health = object:get_max_health()
local position = object:get_position()
local class_id = object:get_class()
-- Convert class_id to a readable string
local class_name = "Unknown"
if class_id == enums.class_id.WARRIOR then
class_name = "Warrior"
elseif class_id == enums.class_id.WARLOCK then
class_name = "Warlock"
-- Add more class checks as needed
end
-- Log the information
core.log(string.format("Name: %s, Class: %s, Health: %d/%d, Position: (%.2f, %.2f, %.2f)",
name, class_name, health, max_health, position.x, position.y, position.z))
end
end)
This example showcases how to access various game object properties and use the enums module for interpreting class IDs. Feel free to expand on this for more complex visualizations or analysis tools!
Visible Objects​
warning
---- Not currently implemented ----
core.object_manager.get_visible_objects() -> table​
Retrieves all visible game objects.
Returns: table - A table containing all visible game_objects.
Unit Helper - Optimized Object Retrieval 🚀​
To address performance concerns and provide targeted functionality, we've developed the unit_helper library. This toolkit offers optimized methods for retrieving specific types of game objects, utilizing caching and filtering for improved performance.
note
To use the unit_helper module, include it in your script:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
Enemies Around​
unit_helper:get_enemy_list_around(point: vec3, range: number, include_out_of_combat: boolean, include_blacklist: boolean) -> table​
Retrieves a list of enemy units around a specified point.
Returns: table - A table containing enemy game_objects.
Parameters:
point: vec3 - The center point to search around.
range: number - The radius (in yards) to search within.
include_out_of_combat: boolean - If true, includes units not in combat.
include_blacklist: boolean - If true, includes special units (use with caution).
Example usage:
---@type color
local color = require("common/color")
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
core.register_on_render_callback(function()
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local local_player_position = local_player:get_position()
local range_to_check = 40.0 -- yards
local enemies_around = unit_helper:get_enemy_list_around(local_player_position, range_to_check, false, false)
for _, enemy in ipairs(enemies_around) do
local enemy_position = enemy:get_position()
core.graphics.circle_3d(enemy_position, 2.0, color.red(255), 30.0, 1.2)
end
end)
This code visualizes enemies around the player with red circles, demonstrating the focused nature of unit_helper functions.
Allies Around​
unit_helper:get_ally_list_around(point: vec3, range: number, players_only: boolean, party_only: boolean) -> table​
Retrieves a list of allied units around a specified point.
Returns: table - A table containing allied game_objects.
Parameters:
point: vec3 - The center point to search around.
range: number - The radius (in yards) to search within.
players_only: boolean - If true, only includes player characters.
party_only: boolean - If true, only includes party members.
Example usage:
---@type color
local color = require("common/color")
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
local function my_on_render()
local local_player = core.object_manager.get_local_player()
if not local_player then
return
end
local range_to_check = 40.0 -- yards
local green_color = color.new(0, 255, 0, 230)
local player_position = local_player:get_position()
local allies_around = unit_helper:get_ally_list_around(player_position, range_to_check, false, false)
for _, ally in ipairs(allies_around) do
local ally_position = ally:get_position()
core.graphics.circle_3d(ally_position, 2.0, green_color, 30.0, 1.5)
end
end
core.register_on_render_callback(my_on_render)
Mouse over Oject​
object_manager.get_mouse_over_object() -> game_object​
Returns the object that you are hovering with your mouse.
Let's break down the optimizations in this code:
Module Imports: We import necessary modules for color and unit helper functions.
Named Function: We use a named function my_on_render() for better readability and debugging.
Early Exit: We implement a guard clause for the local player check.
Pre-loop Calculations: We define constants and calculate values outside the loop for efficiency.
Optimized Retrieval: We use unit_helper:get_ally_list_around() for targeted, efficient object retrieval.
Efficient Looping: We use ipairs() for optimal iteration.
Performance Considerations 🏎️​
This code showcases several key performance optimizations:
Color Calculation: Pre-calculating the color object reduces redundant calculations.
Player Position: Calculating player_position once avoids repeated calls.
Targeted Retrieval: Using unit_helper functions significantly reduces processed objects.
Efficient Looping: Proper use of ipairs() ensures optimal iteration.
Optimization Principles 📊​
Key principles demonstrated:
Minimize Repetitive Calculations: Perform constant calculations outside loops.
Use Specialized Functions: Employ targeted functions for efficient processing.
Early Exit: Use guard clauses to avoid unnecessary computations.
Readability and Maintainability: Balance optimizations with code clarity.
tip
The unit_helper functions not only boost performance but also provide more relevant data for most scripting scenarios. By using these functions, you can create more efficient and focused scripts, reducing unnecessary iterations and checks.
Remember, effective scripting often involves balancing raw data access with optimized helper functions. As you develop more complex scripts, consider the performance implications of your choices and leverage the unit_helper library when appropriate. Happy scripting! 🚀
Previous
Core
Next
Game Object - Functions
Introduction 📃
Raw Functions 💣Local Player
core.object_manager.get_local_player() -> game_object
All Objects
core.object_manager.get_all_objects() -> table
Visible Objects
core.object_manager.get_visible_objects() -> table
Unit Helper - Optimized Object Retrieval 🚀Enemies Around
unit_helper:get_enemy_list_around(point: vec3, range: number, include_out_of_combat: boolean, include_blacklist: boolean) -> table
Allies Around
unit_helper:get_ally_list_around(point: vec3, range: number, players_only: boolean, party_only: boolean) -> table
Mouse over Oject
object_manager.get_mouse_over_object() -> game_object
Performance Considerations 🏎️
Optimization Principles 📊
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Object Manager _ Project Sylvanas.html>

<PvP Helper Library _ Project Sylvanas.html>
PvP Helper Library | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
PvP Helper Library
On this page
PvP Helper Library
Overview​
The PVP Helper module provides a comprehensive set of utility functions and data structures for working with player-versus-player (PVP) scenarios in Sylvanas. This module simplifies tasks such as identifying PVP players, checking crowd control statuses, handling damage reductions, and managing PVP-specific buffs and debuffs. Below, we'll explore its core functions and how to effectively utilize them.
Including the Module​
As with all other LUA modules developed by us, you will need to import the PVP Helper module into your project. To do so, you can use the following lines:
---@type pvp_helper
local pvp_helper = require("common/utility/pvp_helper")
warning
To access the module's functions, you must use : instead of .
For example, this code is not correct:
---@type pvp_helper
local pvp_helper = require("common/utility/pvp_helper")
local function check_if_player(unit)
return pvp_helper.is_player(unit)
end
And this would be the corrected code:
---@type pvp_helper
local pvp_helper = require("common/utility/pvp_helper")
local function check_if_player(unit)
return pvp_helper:is_player(unit)
end
Functions​
Player Identification Functions 👤​
is_player(unit: game_object) -> boolean​
Determines if the given unit is a player character.
local is_unit_player = pvp_helper:is_player(unit)
if is_unit_player then
core.log("The unit is a player.")
end
is_pvp_scenario() -> boolean​
Determines if the current scenario is a PVP situation.
local is_pvp_scenario = pvp_helper:is_pvp_scenario()
if is_pvp_scenario then
core.log("Engaging in PVP combat.")
end
Crowd Control Functions 🌀​
The PVP Helper provides extensive functionality for handling crowd control (CC) effects. It uses a set of CC flags to categorize different types of CC.
CC Flags​
The module defines a cc_flags table containing various CC types as flags:
pvp_helper.cc_flags.MAGICAL -- Magical CC effects
pvp_helper.cc_flags.PHYSICAL -- Physical CC effects
pvp_helper.cc_flags.SLOW -- Slow effects
pvp_helper.cc_flags.ROOT -- Root effects
pvp_helper.cc_flags.STUN -- Stun effects
pvp_helper.cc_flags.INCAPACITATE -- Incapacitate effects
pvp_helper.cc_flags.DISORIENT -- Disorient effects
pvp_helper.cc_flags.FEAR -- Fear effects
pvp_helper.cc_flags.SAP -- Sap effects
pvp_helper.cc_flags.CYCLONE -- Cyclone effects
pvp_helper.cc_flags.KICK -- Kick effects
pvp_helper.cc_flags.SILENCE -- Silence effects
pvp_helper.cc_flags.ANY -- Any CC effect
pvp_helper.cc_flags.ANY_BUT_SLOW -- Any CC effect except slows
You can combine multiple CC flags using the combine function:
local combined_flags = pvp_helper.cc_flags:combine("STUN", "ROOT")
CC Flag Descriptions​
You can access human-readable descriptions of CC flags:
local cc_description = pvp_helper.cc_flag_descriptions[pvp_helper.cc_flags.STUN]
is_crowd_controlled(unit: game_object, type_flags?: number, min_remaining?: number) -> boolean, number, number​
Determines if the unit is under any crowd control effect specified by type_flags.
Returns:
is_cc (boolean): Whether the unit is crowd controlled.
current_remaining_ms (number): The remaining duration of the CC in milliseconds.
expire_time (number): The timestamp when the CC effect will expire.
Parameters:
unit (game_object): Unit to check CC data.
type_flags (number, optional): CC flags to check for. Defaults to pvp_helper.cc_flags.ANY.
min_remaining (number, optional): Minimum remaining duration in milliseconds.
local is_cced, remaining_ms, expire_time = pvp_helper:is_crowd_controlled(enemy_unit, pvp_helper.cc_flags.STUN)
if is_cced then
core.log("Enemy is stunned for " .. (remaining_ms / 1000) .. " seconds.")
end
is_cc_immune(unit: game_object, type_flags?: number, min_remaining?: number) -> boolean, number, number​
Determines if the unit is immune to any crowd control effects specified by type_flags.
local is_immune, remaining_ms, expire_time = pvp_helper:is_cc_immune(enemy_unit, pvp_helper.cc_flags.ROOT)
if is_immune then
core.log("Enemy is immune to roots.")
end
get_cc_reduction_mult(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number​
Gets the CC reduction multiplier for the unit.
Returns:
mult (number): The reduction multiplier (e.g., 0.5 means 50% reduction).
current_remaining_ms (number): Remaining duration in milliseconds.
expire_time (number): The timestamp when the effect expires.
local reduction_mult = pvp_helper:get_cc_reduction_mult(enemy_unit)
if reduction_mult < 1 then
core.log("Enemy has CC reduction: " .. ((1 - reduction_mult) * 100) .. "%")
end
get_cc_reduction_percentage(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number​
Gets the CC reduction percentage for the unit.
local reduction_pct = pvp_helper:get_cc_reduction_percentage(enemy_unit)
if reduction_pct > 0 then
core.log("Enemy's CC duration is reduced by " .. (reduction_pct * 100) .. "%")
end
has_cc_reduction(unit: game_object, threshold?: number, type_flags?: number, min_remaining?: number) -> boolean, number, number​
Checks if the unit has any CC reduction above a certain threshold.
Parameters:
threshold (number, optional): The minimum reduction multiplier to consider. Defaults to 0.
local has_reduction = pvp_helper:has_cc_reduction(enemy_unit, 0.2)
if has_reduction then
core.log("Enemy has significant CC reduction.")
end
is_slow(unit: game_object, threshold?: number, min_remaining?: number) -> boolean, number, number​
Determines if the unit is affected by a slowing effect.
Parameters:
threshold (number, optional): The minimum slow percentage to consider.
min_remaining (number, optional): Minimum remaining duration in milliseconds.
local is_slowed, slow_pct, expire_time = pvp_helper:is_slow(enemy_unit, 0.5)
if is_slowed then
core.log("Enemy is slowed by at least 50%")
end
get_slow_percentage(unit: game_object, min_remaining?: number) -> number, number​
Gets the slow percentage applied to the unit.
Returns:
slow_percentage (number): The slow percentage (e.g., 0.3 for 30% slow).
expire_time (number): The timestamp when the slow effect expires.
local slow_pct, expire_time = pvp_helper:get_slow_percentage(enemy_unit)
if slow_pct > 0 then
core.log("Enemy is slowed by " .. (slow_pct * 100) .. "%")
end
Damage Reduction Functions 🛡️​
The module provides functions to handle damage reduction effects, helping you determine if an enemy has active damage reduction buffs.
Damage Type Flags​
Similar to CC flags, damage type flags categorize types of damage:
pvp_helper.damage_type_flags.PHYSICAL -- Physical damage
pvp_helper.damage_type_flags.MAGICAL -- Magical damage
pvp_helper.damage_type_flags.ANY -- Any damage type
pvp_helper.damage_type_flags.BOTH -- Both physical and magical damage
You can combine multiple damage type flags:
local combined_damage_flags = pvp_helper.damage_type_flags:combine("PHYSICAL", "MAGICAL")
get_damage_reduction_mult(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number​
Gets the damage reduction multiplier for the unit.
Returns:
mult (number): Damage reduction multiplier (e.g., 0.8 means 20% damage reduction).
current_remaining_ms (number): Remaining duration in milliseconds.
expire_time (number): The timestamp when the effect expires.
local reduction_mult = pvp_helper:get_damage_reduction_mult(enemy_unit)
if reduction_mult < 1 then
core.log("Enemy has damage reduction: " .. ((1 - reduction_mult) * 100) .. "%")
end
get_damage_reduction_percentage(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number​
Gets the damage reduction percentage for the unit.
local reduction_pct = pvp_helper:get_damage_reduction_percentage(enemy_unit)
if reduction_pct > 0 then
core.log("Enemy's damage taken is reduced by " .. (reduction_pct * 100) .. "%")
end
has_damage_reduction(unit: game_object, threshold?: number, type_flags?: number, min_remaining?: number) -> boolean, number, number​
Checks if the unit has any damage reduction above a certain threshold.
Parameters:
threshold (number, optional): The minimum reduction multiplier to consider. Defaults to 0.
local has_reduction = pvp_helper:has_damage_reduction(enemy_unit, 0.2)
if has_reduction then
core.log("Enemy has significant damage reduction.")
end
is_damage_immune(unit: game_object, type_flags?: number, min_remaining?: number) -> boolean, number, number​
Determines if the unit is immune to any damage specified by type_flags.
local is_immune, remaining_ms, expire_time = pvp_helper:is_damage_immune(enemy_unit, pvp_helper.damage_type_flags.MAGICAL)
if is_immune then
core.log("Enemy is immune to magical damage.")
end
Offensive Cooldown Functions 🔥​
offensive_cooldowns​
A table containing information about offensive cooldown buffs.
for _, cooldown in pairs(pvp_helper.offensive_cooldowns) do
core.log("Offensive cooldown: " .. cooldown.buff_name)
end
has_offensive_cooldown_active(unit: game_object, min_remaining?: number) -> boolean​
Checks if the unit has any offensive cooldowns active.
local has_off_cd = pvp_helper:has_offensive_cooldown_active(enemy_unit)
if has_off_cd then
core.log("Enemy has an offensive cooldown active.")
end
Purgeable Buffs Functions ✨​
purgeable_buffs​
A list of buffs that can be purged from a unit.
is_purgeable(unit: game_object, min_remaining?: number) -> {is_purgeable: boolean, table: {buff_id: number, buff_name: string, priority: number, min_remaining: number}?, current_remaining_ms: number, expire_time: number}​
Determines if the unit has any purgeable buffs.
Returns:
is_purgeable (boolean): Whether the unit has a purgeable buff.
table (table): Details about the purgeable buff.
current_remaining_ms (number): Remaining duration in milliseconds.
expire_time (number): The timestamp when the buff expires.
local purge_info = pvp_helper:is_purgeable(enemy_unit)
if purge_info.is_purgeable then
core.log("Enemy has a purgeable buff: " .. purge_info.table.buff_name)
end
Utility Functions 🛠️​
get_combined_cc_descriptions(type: number) -> string​
Gets a combined description of CC types based on the type flags.
local cc_description = pvp_helper:get_combined_cc_descriptions(pvp_helper.cc_flags:combine("STUN", "ROOT"))
core.log("CC types: " .. cc_description)
get_combined_damage_type_descriptions(type: number) -> string​
Gets a combined description of damage types based on the type flags.
local damage_description = pvp_helper:get_combined_damage_type_descriptions(pvp_helper.damage_type_flags.BOTH)
core.log("Damage types: " .. damage_description)
Data Structures​
CC Flags Table 🏳️​
The cc_flags table is a collection of CC type flags used by the module.
Fields:​
MAGICAL (number): Represents magical CC effects.
PHYSICAL (number): Represents physical CC effects.
SLOW (number): Represents slow effects.
ROOT (number): Represents root effects.
STUN (number): Represents stun effects.
INCAPACITATE (number): Represents incapacitate effects.
DISORIENT (number): Represents disorient effects.
FEAR (number): Represents fear effects.
SAP (number): Represents sap effects.
CYCLONE (number): Represents cyclone effects.
KICK (number): Represents kick effects.
SILENCE (number): Represents silence effects.
ANY (number): Represents any CC effect.
ANY_BUT_SLOW (number): Represents any CC effect except slows.
Methods:​
combine(...: string) -> number: Combines multiple CC flags into a single flag value.
Damage Type Flags Table 💥​
The damage_type_flags table is a collection of damage type flags used by the module.
Fields:​
PHYSICAL (number): Represents physical damage.
MAGICAL (number): Represents magical damage.
ANY (number): Represents any damage type.
BOTH (number): Represents both physical and magical damage.
Methods:​
combine(...: string) -> number: Combines multiple damage type flags into a single flag value.
Examples​
Checking if a Unit is Under CC​
---@type pvp_helper
local pvp_helper = require("common/utility/pvp_helper")
local function is_enemy_stunned(enemy_unit)
local is_cced = pvp_helper:is_crowd_controlled(enemy_unit, pvp_helper.cc_flags.STUN)
return is_cced
end
Applying Logic Based on Damage Reduction​
local function should_cast_big_damage(enemy_unit)
local has_reduction = pvp_helper:has_damage_reduction(enemy_unit, 0.3)
return not has_reduction
end
Checking for Purgeable Buffs​
local function can_purge(enemy_unit)
local purge_info = pvp_helper:is_purgeable(enemy_unit)
return purge_info.is_purgeable
end
Tips and Notes​
Always ensure you're using the correct CC or damage type flags when checking for effects.
Utilize the combine function to check for multiple types simultaneously.
Remember to consider min_remaining durations if you're interested in effects that last beyond a certain time frame.
Previous
Target Selector
Next
PvP UI Module Library
Overview
Including the Module
FunctionsPlayer Identification Functions 👤
is_player(unit: game_object) -> boolean
is_pvp_scenario() -> boolean
Crowd Control Functions 🌀
is_crowd_controlled(unit: game_object, type_flags?: number, min_remaining?: number) -> boolean, number, number
is_cc_immune(unit: game_object, type_flags?: number, min_remaining?: number) -> boolean, number, number
get_cc_reduction_mult(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number
get_cc_reduction_percentage(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number
has_cc_reduction(unit: game_object, threshold?: number, type_flags?: number, min_remaining?: number) -> boolean, number, number
is_slow(unit: game_object, threshold?: number, min_remaining?: number) -> boolean, number, number
get_slow_percentage(unit: game_object, min_remaining?: number) -> number, number
Damage Reduction Functions 🛡️
get_damage_reduction_mult(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number
get_damage_reduction_percentage(unit: game_object, type_flags?: number, min_remaining?: number) -> number, number, number
has_damage_reduction(unit: game_object, threshold?: number, type_flags?: number, min_remaining?: number) -> boolean, number, number
is_damage_immune(unit: game_object, type_flags?: number, min_remaining?: number) -> boolean, number, number
Offensive Cooldown Functions 🔥
offensive_cooldowns
has_offensive_cooldown_active(unit: game_object, min_remaining?: number) -> boolean
Purgeable Buffs Functions ✨
purgeable_buffs
is_purgeable(unit: game_object, min_remaining?: number) -> {is_purgeable: boolean, table: {buff_id: number, buff_name: string, priority: number, min_remaining: number}?, current_remaining_ms: number, expire_time: number}
Utility Functions 🛠️
get_combined_cc_descriptions(type: number) -> string
get_combined_damage_type_descriptions(type: number) -> string
Data StructuresCC Flags Table 🏳️
Damage Type Flags Table 💥
ExamplesChecking if a Unit is Under CC
Applying Logic Based on Damage Reduction
Checking for Purgeable Buffs
Tips and Notes
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</PvP Helper Library _ Project Sylvanas.html>

<PvP UI Module Library _ Project Sylvanas.html>
PvP UI Module Library | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
PvP UI Module Library
On this page
PvP UI Module Library
Overview​
The PvP UI Module provides the required functions for you to implement your own PvP-UI own panel. Read (pvp ui module - user) todo add link -- before continuing with this guide, so you know what this module is about.
Including the Module​
As with all other LUA modules developed by us, you will need to import the PVP Helper module into your project. To do so, you can use the following lines:
---@type ui_buttons_info
local ui_buttons_info = require("common/utility/ui_buttons_info")
warning
To access the module's functions, you must use . instead of :. This is the only module where : is not required.
Functions​
note
Almost everything is handled automatically, so there is just one function that you must call under any circumstance. This is the push_button function. All the other functions are just regarding available customizations for the user, that are centralized within the plugin and can be modified by the user directly on the window that spawns. You should take into consideration these settings that the user might modify for your logic so your plugin is coherent.
warning
The function that you are going to pass to the GUI module MUST return
TRUE at some point. When your logic function returns true, the logic
is removed from the queue. Otherwise, the button will be permanently stuck on the "On Queue" state.
Check the code example and the rest of documentation so you can fully understand how this works. Just keep this information in mind for when you read the "push_button" function definition, just below.
push_button(button_id: string, title: string, spell_ids:table<number>, logic_function:fun) -> nil​
Parameters explanation:
button_id: This is the unique identifier for the button.
title: This is the name that will appear in the button. For example, if you want to use scatter and trap, a desirable name would be Scatter-Trap, for example.
note
Avoid long title names, as the buttons should be as small as possible so the PvP UI Window occupies as little space as possible on the screen.
spell_ids: These are the ids of the spells that you want to check the CD of. For example, if you want the button to be disabled when Scatter and Trap are on cooldown, you need to pass {scatter_id, trap_id} to this function. This is independent of the logic function, so you can just pass here Trap cooldown and then also cast Scatter.
function: This is the logic that will be run when the user presses the button from the UI.
warning
This function must be called just once, on script load. Do not place it inside any callback.
get_button_info(button_id: string) -> table​
Return value explanation:
This function returns a table containing all available data for the button with the specifed ID. This table has the following members:
.button_id -> The id of the button.
.title -> The title of the button.
.spell_ids -> The table containing the IDs that are used to check the remaining time of the logic.
.is_pressed -> If the button is pressed now
.is_enabled -> If the button is enabled (when disabled, it won't be shown in the UI)
.last_trigger_time -> Last time that the button was pressed.
.is_attempting_to_run_logic -> If the logic is trying to be run right now (the logic is on queue).
.arena_frame_pressed_to -> The index of the button that was pressed. This is used internally to handle the target.
.logic -> The logic_function itself.
get_current_buttons_info() -> table​
Returns the table containing all the available UI buttons information. (See the previous function to see what elements does a UI button table contain)
is_logic_attempting_only_once() -> boolean​
Returns the configuration that the user set for the Logic Cast Mode, found within the GUI customization window. If true, the logic should be also attempted to be run once. Otherwise, you can apply your custom logics or behaviour. You should always set a maximum timer to reset the button state (return true from its function).
get_timeout_time() -> number​
Returns the timeout time that the user set.
.launch_checkbox -> checkbox​
warning
This is the checkbox that you must render within your plugin's menu, so the user is able to
launch the PvP GUI Window. If you don't render this button, the user won't be able to re-launch the window after they close it, or it will never be shown to begin with.
Complete Example​
This is the logic that we are currently using for our Beast Mastery Hunter plugin. We made sure to explain everything in the comments, so you have an easier time understanding everything.
In the pvp_ui_implementation.lua file we have the following code:
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")
---@type pvp_helper
local pvp_helper = require("common/utility/pvp_helper")
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
-- used spells ids
local inti_id = 19577
local trap_id = 187650
local scatter_id = 213691
---@type ui_buttons_info
local ui_buttons_info = require("common/utility/ui_buttons_info")
-- return true means remove logic from queue - it was casted already / aborted
local function scatter_trap_logic(local_player, target, trigger_time)
-- target is immune to stun right now, so wait for them to stop being immune
if pvp_helper:is_cc_immune(target, pvp_helper.cc_flags.STUN, 1000.0) then
return false
end
-- check if we have pet
local pet = local_player:get_pet()
local is_there_pet = pet and not pet:is_dead()
local is_trying_only_once = ui_buttons_info:is_logic_attempting_only_once()
-- get the timeout time from the ui itself, since this can be modified by the user there
local timeout_time = ui_buttons_info:get_timeout_time()
local current_time = core.time()
local attempting_time = current_time - trigger_time
-- check if the spell has been in queue for longer than the value the user set.
if attempting_time > timeout_time then
return true
end
local tried_to_cast = false
-- check if target is cced with at least 1 second of remaining cc time
local is_target_cced_already, cc_flag, remaining = pvp_helper:is_crowd_controlled(target, pvp_helper.cc_flags.ANY_BUT_SLOW, 1000)
if is_target_cced_already then
-- trap is the most important spell, the other ones are just complementary to this one so they are stuck in place and the trap doesn't miss.
-- therefore, if the target is cc'ed we can just cast the trap, we don't care about stun.
if remaining < 2500 and spell_helper:is_spell_castable(trap_id, local_player, target, true, false) then
spell_queue:queue_spell_position(trap_id, target:get_position(), 8, "Hunter MM - UI - Trap")
-- set tried_to_cast flag to true, so if the user sets the behaviour to attempt only once we
-- can already return true and remove this logic from the queue
tried_to_cast = true
end
-- if the spell is on cooldown (> 2.0 to make sure global cooldown is not interfering) then our purppose is fullfilled and we can remove this logic
-- from the queue, as we casted it already.
return core.spell_book.get_spell_cooldown(trap_id) > 2.0
else
-- target was not cc'ed, which means that we have to cc him.
-- First prio is pet stun since it doesn't share DR with trap.
-- check if our pet is impaired
local pet_cced = false
if is_there_pet then
pet_cced, cc_flag, remaining = pvp_helper:is_crowd_controlled(pet, pvp_helper.cc_flags.ANY_BUT_SLOW, 1000)
end
-- if we can cast intimidation (pet not cc'ed, spell castable) then we cast it
if spell_helper:is_spell_castable(inti_id, local_player, target, false, false) and not pet_cced then
spell_queue:queue_spell_target(inti_id, target, 8, "Hunter MM - UI - Inti")
else
-- otherwise, ONLY if intimidation is on CD, we try to cast scatter. Otherwise we just wait for the pet to go out of cooldown or for us
-- to be able to cast the spell to the target.
if core.spell_book.get_spell_cooldown(inti_id) > 2.0 then
if spell_helper:is_spell_castable(scatter_id, local_player, target, false, false) then
spell_queue:queue_spell_target(scatter_id, target, 8, "Hunter MM - UI - Inti (Scatter Backup Alt)")
end
end
end
end
-- we already tried to cast, if the user set the behaviour to cast only once then this function fullfilled its purpose and we can
-- remove it from the queue.
if tried_to_cast then
tried_to_cast = is_trying_only_once
end
-- we always remove this spell from queue if trap is on cd (was casted) or already attempted to cast and user set behaviour to attempt only once.
return core.spell_book.get_spell_cooldown(trap_id) > 2.0 or tried_to_cast
end
-- call this in the main, ONLY ONCE. Do not place it inside any callback.
local function set_pvp_ui_buttons()
-- PARAMETERS explanation:
-- 1 -> remember to always use an unique identifier for each button.
-- 2 -> remember to use a short title (as short as possible, but the user shuld still be able to understand what it's going to do upon press)
-- 3 -> the ids of the spells that will be taken into account for tue GUI for the cooldown. In this case, only if trap is on CD, the button is going
-- to be disabled. The GUI won't care about intimidation or scatter shot.
-- 4 -> the logic itself. Remember it MUST return TRUE for the logic to be removed from queue. If your function never returns TRUE under any
-- circumstance, the button will be stuck forever in the "On Queue" state after being pressed.
ui_buttons_info:push_button("hunter_mm_scatter_trap", "Stun-Trap", {trap_id}, scatter_trap_logic)
end
local function hide_time_slider()
-- if you want to use a custom timeout slider and don't want to let the user modify this value, hide the slider from the
-- GUI customization window. (set the parameter to TRUE instead of FALSE).
ui_buttons_info:set_no_render_timeout_time_slider_flag(false)
end
-- export these functions (and the launch button) to our main file, where we will call them
return
{
set_pvp_ui_buttons = set_pvp_ui_buttons,
launch_pvp_ui_button = buttons.launch_checkbox,
hide_time_slider = hide_time_slider,
}
Then, for the main file we just have:
-- (...)
-- (this is NOT inside any callback)
local pvp_ui = require("pvp_ui_logics")
ui_buttons_info:set_pvp_ui_buttons()
ui_buttons_info:hide_time_slider()
-- (...)
--- (this IS inside the on_render_menu callback)
local on_render_menu()
-- (...)
pvp_ui.launch_pvp_ui_button:render("Enable PvP UI Window")
-- (...)
end
This is the behaviour expected for the code above:
Previous
PvP Helper Library
Next
Inventory Helper
Overview
Including the Module
Functionspush_button(button_id: string, title: string, spell_ids:table<number>, logic_function:fun) -> nil
get_button_info(button_id: string) -> table
get_current_buttons_info() -> table
is_logic_attempting_only_once() -> boolean
get_timeout_time() -> number
.launch_checkbox -> checkbox
Complete Example
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</PvP UI Module Library _ Project Sylvanas.html>

<Spell Book - Raw Functions _ Project Sylvanas.html>
Spell Book - Raw Functions | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Spell Book
Spell Book - Raw Functions
On this page
Spell Book - Raw Functions
Overview​
The spell_book module provides a comprehensive set of methods to interact with spells in your scripts. You can use these functions to query spell cooldowns, retrieve spell names, check if a spell is equipped, etc. However, same like with the Input module, using the raw functions directly might not be the best idea in most cases. For example, to check if a spell is castable, you would need to first check if the spell is equipped, if the spell is on cooldown, then range... As you can see, this is going to become an annoying task in most of your scripts. To make your life easier and centralize code as much as possible so the amount of bugs is reduced, we developed the
Spell helper module.
tip
Check the Spell helper module after checking the raw functions, provided below.
Functions​
General Functions 📃​
get_specialization_id()​
Returns the specialization ID of the local player.
Returns: number — The specialization ID.
note
This function is specially useful to decide whether to
load or not your script. Here is an example to properly avoid loading scripts when they are
not necessary (for example, your script is for rogues and the user is playing a monk).
--- this is the HEADER file
local plugin_info = require("plugin_info")
local plugin = {}
plugin["name"] = plugin_info.plugin_load_name
plugin["version"] = plugin_info.plugin_version
plugin["author"] = plugin_info.author
-- by default, we load the plugin always
plugin["load"] = true
-- if there is no local player (eg. user injected before being in-game or is in loading screen) then
-- we don't load the script
local local_player = core.object_manager.get_local_player()
if not local_player then
plugin["load"] = false
return plugin
end
-- we check if the class that is being played currently matches our script's intended class
local enums = require("common/enums")
local player_class = local_player:get_class()
local is_valid_class = player_class == enums.class_id.ROGUE
if not is_valid_class then
plugin["load"] = false
return plugin
end
-- then, we check if the spec id that is being currently played matches our script's intended spec
local player_spec_id = core.spell_book.get_specialization_id()
local is_valid_spec_id = player_spec_id == 3
if not is_valid_spec_id then
plugin["load"] = false
return plugin
end
return plugin
Cooldowns and Charges ⏳​
get_global_cooldown()​
Returns the duration of the global cooldown, which is the time between casting spells.
Returns: number — The global cooldown duration in seconds.
get_spell_cooldown(spell_id)​
Returns the cooldown duration of the specified spell in seconds.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: number — The cooldown duration in seconds.
get_spell_charge(spell_id)​
Returns the current number of charges available for the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: integer — The current number of charges.
get_spell_charge_max(spell_id)​
Returns the maximum number of charges available for the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: integer — The maximum number of charges.
Spell Information ℹ️​
get_spell_name(spell_id)​
Returns the name of the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: string — The name of the spell.
get_spell_description(spell_id)​
Retrieves the tooltip text of the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: string — The tooltip text.
get_spells()​
Returns a table containing all spells and their corresponding IDs.
Returns: table — A table mapping spell IDs to spell names.
has_spell(spell_id)​
Checks if the specified spell is equipped.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: boolean — true if the spell is equipped; otherwise, false.
is_spell_learned(spell_id)​
Determines if the specified spell is learned.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: boolean — true if the spell is learned; otherwise, false.
Note: is_spell_learned is more reliable than has_spell for checking talents.
Spell Costs 💰​
get_spell_costs(spell_id)​
Returns a table containing the power cost details of the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: table — A table containing power cost details.
spell_cost Properties:
min_cost: Minimum cost required to cast the spell.
cost: Standard cost to cast the spell.
cost_per_sec: Cost per second if the spell is channeled.
cost_type: Type of resource used (e.g., mana, energy).
required_buff_id: ID of any buff required to modify the cost.
warning
Do not use this function, as it returns a table that needs to be handled in a specific way. We still provide its functionality, but in general you wouldn't want to use it.
Spell Range and Damage 🎯​
get_spell_range_data(spell_id)​
Returns a table containing the minimum and maximum range of the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: table — A table with min_range and max_range.
Range Data Properties:
min_range: Minimum distance required to cast the spell.
max_range: Maximum distance within which the spell can be cast.
get_spell_min_range(spell_id)​
Returns the minimum range of the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: number — The minimum range.
get_spell_max_range(spell_id)​
Returns the maximum range of the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: number — The maximum range.
get_spell_damage(spell_id)​
Retrieves the damage value of the specified spell.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: number — The damage value.
Casting Types 🎭​
is_melee_spell(spell_id)​
Determines if the specified spell is of melee type.
Parameters:
spell_id (integer) — The ID of the spell.
Returns: boolean — true if the spell is melee type; otherwise, false.
is_spell_position_cast(spell_id)​
Checks if the specified spell is a skillshot (position-cast spell).
Parameters:
spell_id (integer) — The ID of the spell.
Returns: boolean — true if the spell is a skillshot; otherwise, false.
cursor_has_spell()​
Checks if the cursor is currently busy with a skillshot.
Returns: boolean — true if the cursor is busy; otherwise, false.
Talents 🌟​
get_talent_name(talent_id)​
Returns the name of the specified talent.
Parameters:
talent_id (integer) — The ID of the talent.
Returns: string — The name of the talent.
get_talent_spell_id(talent_id)​
Returns the spell ID associated with the specified talent.
Parameters:
talent_id (integer) — The ID of the talent.
Returns: number — The spell ID.
Previous
Buffs
Next
Spell helper
Overview
FunctionsGeneral Functions 📃
get_specialization_id()
Cooldowns and Charges ⏳
get_global_cooldown()
get_spell_cooldown(spell_id)
get_spell_charge(spell_id)
get_spell_charge_max(spell_id)
Spell Information ℹ️
get_spell_name(spell_id)
get_spell_description(spell_id)
get_spells()
has_spell(spell_id)
is_spell_learned(spell_id)
Spell Costs 💰
get_spell_costs(spell_id)
Spell Range and Damage 🎯
get_spell_range_data(spell_id)
get_spell_min_range(spell_id)
get_spell_max_range(spell_id)
get_spell_damage(spell_id)
Casting Types 🎭
is_melee_spell(spell_id)
is_spell_position_cast(spell_id)
cursor_has_spell()
Talents 🌟
get_talent_name(talent_id)
get_talent_spell_id(talent_id)
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Spell Book - Raw Functions _ Project Sylvanas.html>

<Spell helper _ Project Sylvanas.html>
Spell helper | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Menu Elements
Input
Geometry
Control Panel
Vectors
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Spell Book
Spell helper
On this page
Spell helper
Overview​
As explained in the previous page Spell Book Functions, the spell helper module will provide you most of the possible and most used functionalities related to spells.
tip
Check the examples section, which is essentially the summary of all this module.
Importing The Module​
warning
This is a Lua library stored inside the "common" folder. To use it, you will need to include the library. Use the require function and store it in a local variable.
Here is an example of how to do it:
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
Functions​
Spell Availability 📖​
has_spell_equipped(spell_id)​
Checks if the spell is in the spellbook.
Parameters:
spell_id (number) — The ID of the spell to check.
Returns: boolean — true if the spell is equipped; otherwise, false.
Spell Cooldown ⏳​
is_spell_on_cooldown(spell_id)​
Checks if the spell is currently on cooldown.
Parameters:
spell_id (number) — The ID of the spell to check.
Returns: boolean — true if the spell is on cooldown; otherwise, false.
Range and Angle Checks 🎯​
is_spell_in_range(spell_id, target, source, destination)​
Checks if a spell is within castable range given a target.
Parameters:
spell_id (number) — The ID of the spell.
target (game_object) — The target game object.
source (vec3) — The source position vector.
destination (vec3) — The destination position vector.
Returns: boolean — true if the spell is within range; otherwise, false.
is_spell_within_angle(spell_id, caster, target, caster_position, target_position)​
Checks if the target is within a permissible angle for casting a spell.
Parameters:
spell_id (number) — The ID of the spell.
caster (game_object) — The caster game object.
target (game_object) — The target game object.
caster_position (vec3) — The position of the caster.
target_position (vec3) — The position of the target.
Returns: boolean — true if the target is within angle; otherwise, false.
Line of Sight Checks 👁️​
is_spell_in_line_of_sight(spell_id, caster, target)​
Checks if the caster has the target in line of sight for a spell.
Parameters:
spell_id (number) — The ID of the spell.
caster (game_object) — The caster game object.
target (game_object) — The target game object.
Returns: boolean — true if the target is in line of sight; otherwise, false.
is_spell_in_line_of_sight_position(spell_id, caster, cast_position)​
Checks if the caster has the position in line of sight for a spell.
Parameters:
spell_id (number) — The ID of the spell.
caster (game_object) — The caster game object.
cast_position (vec3) — The position to check.
Returns: boolean — true if the position is in line of sight; otherwise, false.
Resource and Cost Checks 💰​
get_spell_cost(spell_id)​
Retrieves the cost of a spell.
Parameters:
spell_id (number) — The ID of the spell.
Returns: table — A table containing the cost details of the spell.
Cost Table Properties:
cost_type: The type of resource required (e.g., mana, energy).
cost: The amount of resource required to cast the spell.
cost_percent: The percentage of the resource pool required.
Other cost-related fields as applicable.
warning
In most cases, you do not want to use this function, as it returns a table that needs to be specially handled, same like the raw function.
can_afford_spell(unit, spell_id, spell_costs)​
Checks if a unit has enough resources to cast a spell.
Parameters:
unit (game_object) — The unit attempting to cast the spell.
spell_id (number) — The ID of the spell.
spell_costs (table) — The cost table retrieved from get_spell_cost.
Returns: boolean — true if the unit can afford the spell; otherwise, false.
Casting Readiness ✅​
is_spell_castable(spell_id, caster, target, skip_facing, skips_range)​
Checks if the spell can be cast to target.
Parameters:
spell_id (number) — The ID of the spell.
caster (game_object) — The caster game object.
target (game_object) — The target game object.
skip_facing (boolean) — If true, skips the facing check.
skips_range (boolean) — If true, skips the range check.
Returns: boolean — true if the spell can be cast; otherwise, false.
note
This function handles everything for you (line of sight, cooldown, spell cost, etc), so, for most cases, this is the only function you will need to check if you can cast a spell or not.
Examples​
How To - Check If You Can Cast A Spell 🎯​
tip
This is the recommended way to check if you can cast a spell. Just check the last two parameters (skip_facing and skip_range), since you might wanna set them to "true" in some cases (for example, for some self-cast spells).
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
local function can_cast(local_player, target)
local is_logic_allowed = spell_helper:is_spell_castable(spell_data.id, local_player, target, false, false)
return is_logic_allowed
end
Previous
Spell Book - Raw Functions
Next
Graphics - Functions
Overview
Importing The Module
FunctionsSpell Availability 📖
has_spell_equipped(spell_id)
Spell Cooldown ⏳
is_spell_on_cooldown(spell_id)
Range and Angle Checks 🎯
is_spell_in_range(spell_id, target, source, destination)
is_spell_within_angle(spell_id, caster, target, caster_position, target_position)
Line of Sight Checks 👁️
is_spell_in_line_of_sight(spell_id, caster, target)
is_spell_in_line_of_sight_position(spell_id, caster, cast_position)
Resource and Cost Checks 💰
get_spell_cost(spell_id)
can_afford_spell(unit, spell_id, spell_costs)
Casting Readiness ✅
is_spell_castable(spell_id, caster, target, skip_facing, skips_range)
ExamplesHow To - Check If You Can Cast A Spell 🎯
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Spell helper _ Project Sylvanas.html>

<Spell Prediction _ Project Sylvanas.html>
Spell Prediction | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
Spell Prediction
On this page
Spell Prediction
Overview​
The spell_prediction module provides functions and utilities for predicting spell cast positions and determining optimal targets based on different prediction methods and geometries.
This is a module that we provide to you, however we are basically using the geometry library and some math, so you could always try to make your own prediction and differentiate yourself from others.
Using the Prediction Playground
In the main menu you will see that there is a "Prediction Playground" tree node. This plugin is multi-purpose. Firstly, it offers a visual way to see how prediction works, and on the other hand it will allow you to determine the accurate spell data of some spells.
This is what you should be seeing upon opening the tree node:
Available Options - Brief Explanation
1- Source: Where the spell will be launched from.
2- Target: Where the spell will arrive.
3- Type: The prediction mode. The position output will be either the best possible position to hit the main target, if type is "Accuracy" or the best possible position to hit the most targets, if type is "Most Hits".
4- Geometry: The geometry type.
5- Radius: The radius of the debug spell.
6- Range: The range of the debug spell.
7- Angle: The angle of the cone. (Make sure the spell geometry is set to "Cone")
8- Cast Time: The cast time of the debug spell.
9- Projectile Speed: The projectile speed. Leave to 0 since Blizzard doesn't care about projectiles apparently.
10- Override Hit Time: Option to override the calculated hit time. If 0.0, no override happens.
11- Override Hitbox Min: Option to override the hitbox min radius of the target. If 0.0, no override happens.
12- Draw Hits Amount: Option to draw the calculated amount of hits, with the given spell data. (Red text)
13- Draw Hits Amount: Option to draw a circle on the calculated hits positions, with the given spell data. (Blue circle)
14- Cache Slider: The refresh rate of the spell result cache.
As you can see, this is a powerful tool to retrieve the correct spell datas too, since you can check when you are hitting the targets with accuracy, at the given spell data.
note
This plugin will be open source, for anyone to check its code and play with it.
Enums 🧮​
prediction_type​
Defines the prediction mode for the spell.
ACCURACY: Accuracy-based prediction.
MOST_HITS: Prediction to hit the maximum number of targets.
geometry_type​
Defines the geometry type of the spell's area of effect.
CIRCLE: Circular area.
RECTANGLE: Rectangular area.
CONE: Conical area.
Data Types 📊​
spell_data​
A table containing the following fields:
spell_id (number) — The ID of the spell.
max_range (number) — The maximum range of the spell.
radius (number) — The radius of the spell's area of effect.
cast_time (number) — The cast time of the spell.
projectile_speed (number) — The speed of the spell's projectile.
prediction_mode (prediction_type) — The prediction mode for the spell.
geometry_type (geometry_type) — The geometry type of the spell's area of effect.
source_position (vec3) — The source position of the spell.
intersection_factor (number) — The intersection factor for the spell.
angle (number) — The angle of the spell's area of effect (for cones).
exception_is_heal (boolean) — Whether the spell is a healing spell.
exception_player_included (boolean) — Whether to include the player in the spell's effect.
hitbox_min (number) — The minimum hitbox radius.
hitbox_max (number) — The maximum hitbox radius.
hitbox_mult (number) — The hitbox multiplier.
time_to_hit_override (number) — The override value for time to hit.
hit_data​
A table containing the following fields:
obj (game_object) — The game_object of the unit.
center_position (vec3) — The center position of the unit.
intersection_position (vec3) — The intersection position of the unit.
skillshot_result​
A table containing the following fields:
hit_list (table(hit_data)) — A list of hit_data tables for the units hit.
amount_of_hits (number) — The number of units hit.
cast_position (vec3) — The cast position for the spell.
Functions 📚​
new_spell_data(spell_id, max_range, radius, cast_time, projectile_speed, prediction_mode, geometry, source_position, intersection_factor, angle, exception_is_heal, exception_player_included)​
Creates new spell data with default or specified values.
Parameters:
spell_id (number) — The ID of the spell.
max_range (number, optional) — The maximum range of the spell.
radius (number, optional) — The radius of the spell's area of effect.
cast_time (number, optional) — The cast time of the spell.
projectile_speed (number, optional) — The speed of the spell's projectile.
prediction_mode (prediction_type, optional) — The prediction mode for the spell.
geometry (geometry_type, optional) — The geometry type of the spell's area of effect.
source_position (vec3, optional) — The source position of the spell.
intersection_factor (number, optional) — The interception factor for the spell.
angle (number, optional) — The angle of the spell's area of effect (for cones).
exception_is_heal (boolean, optional) — Whether the spell is a healing spell.
exception_player_included (boolean, optional) — Whether to include the player in the spell's effect.
Returns: spell_data — A table containing the spell data.
get_center_position(target, spell_data)​
Gets the center position of a target.
Parameters:
target (game_object) — The target game_object.
spell_data (spell_data) — The spell data.
Returns: vec3 — The center position of the target.
get_intersection_position(target, center_position, circle_radius, interception_percentage)​
Gets the intersection position for casting the spell.
Parameters:
target (game_object) — The target game_object.
center_position (vec3) — The center position of the target.
circle_radius (number) — The radius of the spell's area of effect.
interception_percentage (number) — The interception factor for the spell.
Returns: vec3 — The intersection position for casting the spell.
get_unit_list(position, range, is_heal)​
Gets the list of units around a position.
Parameters:
position (vec3) — The position to check around.
range (number) — The range to check within.
is_heal (boolean, optional) — Whether the spell is a healing spell.
Returns: table(hit_data) — A list of units around the position.
get_circle_list(target_position, spell_data, is_heal)​
Gets the list of units inside a circle.
Parameters:
target_position (vec3) — The center position of the circle.
spell_data (spell_data) — The spell data.
is_heal (boolean, optional) — Whether the spell is a healing spell.
Returns: table(hit_data) — A list of units inside the circle.
get_rectangle_list(target_position, spell_data, is_heal)​
Gets the list of units inside a rectangle.
Parameters:
target_position (vec3) — The center position of the rectangle.
spell_data (spell_data) — The spell data.
is_heal (boolean, optional) — Whether the spell is a healing spell.
Returns: table(hit_data) — A list of units inside the rectangle.
get_cone_list(target_position, spell_data, is_heal)​
Gets the list of units inside a cone.
Parameters:
target_position (vec3) — The center position of the cone.
spell_data (spell_data) — The spell data.
is_heal (boolean, optional) — Whether the spell is a healing spell.
Returns: table(hit_data) — A list of units inside the cone.
get_unit_geometry_list(position, spell_data)​
Gets the list of units inside a specified geometry.
Parameters:
position (vec3) — The center position of the geometry.
spell_data (spell_data) — The spell data.
Returns: table(hit_data) — A list of units inside the geometry.
get_most_hits_position(main_position, spell_data)​
Gets the best position to hit the most units.
Parameters:
main_position (vec3) — The center position to check from.
spell_data (spell_data) — The spell data.
Returns: skillshot_result — A table containing the best cast position and list of units hit.
get_cast_position(target, spell_data)​
Gets the cast position based on the prediction mode.
Parameters:
target (game_object) — The target game_object.
spell_data (spell_data) — The spell data.
Returns: skillshot_result — A table containing the cast position and list of units hit.
get_cast_position_(position_override, spell_data)​
Gets the cast position based on the prediction mode with a position override.
Parameters:
position_override (vec3) — The overridden position to check from.
spell_data (spell_data) — The spell data.
Returns: skillshot_result — A table containing the cast position and list of units hit.
Example Usage 🧰​
Using the Spell Prediction to Cast Blizzard​
---@type spell_queue
local spell_queue = require("common/modules/spell_queue")
---@type spell_helper
local spell_helper = require("common/utility/spell_helper")
---@type spell_prediction
local spell_prediction = require("common/modules/spell_prediction")
local function cast_blizzard_to_hud_target()
local local_player = core.object_manager.get_local_player()
if local_player then
local hud_target = local_player:get_target()
if hud_target then
local blizzard_id = 10
local player_position = local_player:get_position()
local prediction_spell_data = spell_prediction:new_spell_data(
blizzard_id, -- spell_id
30, -- range
6, -- radius
0.2, -- cast_time
0.0, -- projectile_speed
spell_prediction.prediction_type.MOST_HITS, -- prediction_type
spell_prediction.geometry_type.CIRCLE, -- geometry_type
player_position -- source_position
)
if spell_helper:is_spell_castable(blizzard_id, local_player, hud_target, false, false) then
local prediction_result = spell_prediction:get_cast_position(hud_target, prediction_spell_data)
if prediction_result and prediction_result.amount_of_hits > 0 then
spell_queue:queue_spell_position(blizzard_id, prediction_result.cast_position, 1, "Queueing Blizzard at optimal position")
end
end
end
end
end
This code:
Sets up a Blizzard spell with prediction data
Uses MOST_HITS prediction type to maximize the spell's impact
Queues the Blizzard at the optimal position if targets are predicted to be hit
Priest Death and Decay - Functionality Showcase​
note
As you can see, we call prediction_type.MOST_HITS to fire Death and Decay on the Priest. Instead of casting on the center, it strategically places the spell slightly to the left to hit extra dummies aswell.
tip
Test with the prediction_type.ACCURACY values for pinpointing situations where the cast should be avoided
Advanced Tips 💡​
Intersection Factor: Adjust intersection_factor in spell_data to control how the spell prediction accounts for moving targets. A higher value can anticipate where the target will be in the future.
Angle for Cones: When using geometry_type.CONE, ensure you set the angle parameter in spell_data to define the cone's spread.
Healing Spells: Set exception_is_heal to true if you're working with healing spells to target friendly units instead of enemies.
Prediction Modes: Use prediction_type.ACCURACY for single-target precision or prediction_type.MOST_HITS to maximize the number of targets hit.
Geometry Types: Choose the appropriate geometry_type based on your spell's area of effect shape.
Customizing Spell Data: When creating spell_data, you can override default values to fine-tune the prediction to match your spell's characteristics.
Exceptions: Use exception_is_heal and exception_player_included to adjust the prediction logic for healing spells or whether to include the player character.
Common Use Cases 🎯​
Area of Effect Spells: Use prediction_type.MOST_HITS with geometry_type.CIRCLE or RECTANGLE to maximize damage or healing.
Skill Shots: For spells that require precise targeting, use prediction_type.ACCURACY to predict the best cast position based on the target's movement.
Crowd Control: Combine prediction with geometry calculations to immobilize or debuff multiple enemies effectively.
Troubleshooting 🛠️​
Incorrect Cast Position: Verify that your spell_data parameters accurately reflect the spell's actual in-game properties.
No Targets Hit: Ensure that the get_unit_list function is correctly identifying units within range and that exception_is_heal is set appropriately.
Performance Issues: Limit the frequency of prediction calculations to prevent performance degradation, especially in scripts that run every frame.
Previous
Vector 3
Next
Combat Forecast Library
Overview
Enums 🧮prediction_type
geometry_type
Data Types 📊spell_data
hit_data
skillshot_result
Functions 📚new_spell_data(spell_id, max_range, radius, cast_time, projectile_speed, prediction_mode, geometry, source_position, intersection_factor, angle, exception_is_heal, exception_player_included)
get_center_position(target, spell_data)
get_intersection_position(target, center_position, circle_radius, interception_percentage)
get_unit_list(position, range, is_heal)
get_circle_list(target_position, spell_data, is_heal)
get_rectangle_list(target_position, spell_data, is_heal)
get_cone_list(target_position, spell_data, is_heal)
get_unit_geometry_list(position, spell_data)
get_most_hits_position(main_position, spell_data)
get_cast_position(target, spell_data)
get_cast_position_(position_override, spell_data)
Example Usage 🧰Using the Spell Prediction to Cast Blizzard
Priest Death and Decay - Functionality Showcase
Advanced Tips 💡
Common Use Cases 🎯
Troubleshooting 🛠️
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Spell Prediction _ Project Sylvanas.html>

<Target Selector _ Project Sylvanas.html>
Target Selector | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
Target Selector
On this page
Target Selector
Overview​
The Target Selector module gives you the tools to effectively retrieve the best targets for your logics. Its basic usage is very simple, so we encourage you to use this module in all your damage or healing-related plugins.
Including the Module​
As with all other LUA modules developed by us, you will need to import the Target Selector module into your project. To do so, you can use the following lines:
---@type target_selector
local target_selector = require("common/modules/target_selector")
warning
To access the module's functions, you must use : instead of .
For example, this code is not correct:
---@type target_selector
local target_selector = require("common/modules/target_selector")
local function get_targets()
return target_selector.get_targets()
end
And this would be the corrected code:
---@type target_selector
local target_selector = require("common/modules/target_selector")
local function get_targets()
return target_selector:get_targets()
end
Functions​
get_targets(limit: integer (optional)) -> table<game_object>​
Retrieves the table containing the best targets possible, according to the current Target Selector settings.
The max number of targets it returns is 3 , but you can limit it to less by specifying the limit parameter.
get_targets_heal(limit: integer (optional)) -> table<game_object>​
Retrieves the table containing the best targets to heal possible, according to the current Target Selector settings.
The max number of targets it returns is 3 , but you can limit it to less by specifying the limit parameter.
Manually Modifying the Settings​
Altough the TS config should be good to go by default, you can manually set them inside your plugin. To do so, you have to access the target selector's menu elements and modify them.
For example:
---@type target_selector
local target_selector = require("common/modules/target_selector")
-- this function is a simple one, not necessarily the best one for mage fires. This is just an example.
local is_ts_overriden = false
local function override_ts_settings()
if is_ts_overriden then
return
end
target_selector.menu_elements.damage.weight_multiple_hits:set(true)
target_selector.menu_elements.damage.slider_weight_multiple_hits:set(4)
target_selector.menu_elements.damage.slider_weight_multiple_hits_radius:set(8)
target_selector.menu_elements.settings.max_range_damage:set(40)
is_ts_overriden = true
end
In the previous example, we are manually setting the weight to multiple hits, and the max range of the TS. You can do this for all the parameters.
warning
In general, you will never need to modify the settings. If you have to modify them, we suggest that you add a menu element to give the user the power to disable your custom TS.
For example:
---@type target_selector
local target_selector = require("common/modules/target_selector")
local is_ts_overriden = false
local function override_ts_settings()
if is_ts_overriden then
return
end
-- define this menu element elsewhere in your code, and render it
local is_override_allowed = menu_elements.ts_custom_logic_override:get_state()
if not is_override_allowed then
return
end
target_selector.menu_elements.damage.is_damage_enabled:set(true)
target_selector.menu_elements.damage.is_damage_enabled:set(true)
target_selector.menu_elements.damage.weight_multiple_hits:set(true)
target_selector.menu_elements.damage.slider_weight_multiple_hits:set(4)
target_selector.menu_elements.damage.slider_weight_multiple_hits_radius:set(8)
target_selector.menu_elements.settings.max_range_damage:set(40)
is_ts_overriden = true
end
Previous
Unit Helper Library
Next
PvP Helper Library
Overview
Including the Module
Functionsget_targets(limit: integer (optional)) -> table<game_object>
get_targets_heal(limit: integer (optional)) -> table<game_object>
Manually Modifying the Settings
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Target Selector _ Project Sylvanas.html>

<Unit Helper Library _ Project Sylvanas.html>
Unit Helper Library | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Spell Prediction
Combat Forecast Library
Health Prediction Library
Unit Helper Library
Target Selector
PvP Helper Library
PvP UI Module Library
Inventory Helper
Dungeons Helper
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Libraries
Unit Helper Library
On this page
Unit Helper Library
Overview​
The Unit Helper module provides a collection of utility functions for working with game units in Sylvanas. This module
simplifies tasks such as checking unit states, retrieving unit information, and working with groups of units. Below, we'll explore its core functions and how to effectively utilize them.
Including the Module​
As with all other LUA modules developed by us, you will need to import the unit helper module into your project. To do so, you can use the following lines:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
warning
To access the module's functions, you must use : instead of .
For example, this code is not correct:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
local function is_target_dummy(unit)
return unit_helper.is_dummy(unit)
end
And this would be the corrected code:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
local function is_target_dummy(unit)
return unit_helper:is_dummy(unit)
end
Functions​
Unit Classification Functions 📋​
is_dummy(unit: game_object) -> boolean​
Returns true if the given unit is a training dummy.
local is_training_dummy = unit_helper:is_dummy(unit)
if is_training_dummy then
core.log("The unit is a training dummy.")
end
is_blacklist(npc_id: number) -> boolean​
Returns true if the npc_id is inside a blacklist. For example, incorporeal beings which should be ignored by the target selector.
local is_blacklisted = unit_helper:is_blacklist(npcID)
if is_blacklisted then
core.log("The NPC is blacklisted.")
end
is_boss(unit: game_object) -> boolean​
Determines if the unit is a boss with certain exceptions.
is_valid_enemy(unit: game_object) -> boolean​
Determines if the unit is a valid enemy with exceptions.
is_valid_ally(unit: game_object) -> boolean​
Determines if the unit is a valid ally with exceptions.
Combat State Functions 🛡️​
is_in_combat(unit: game_object) -> boolean​
Determines if the unit is in combat with certain exceptions.
Health and Resource Functions ❤️​
get_health_percentage(unit: game_object) -> number​
Returns the health percentage of the unit in a format from 0.0 to 1.0.
local health_pct = unit_helper:get_health_percentage(unit)
core.log("Unit's health percentage: " .. (health_pct * 100) .. "%")
get_health_percentage_inc(unit: game_object, time_limit?: number) -> number, number, number, number​
Calculates the health percentage of a unit considering incoming damage within a specified time frame. This function uses the Health Prediction Module
note
This function returns 4 values:
1- Total -> The value that you will want usually. It's the future health percentage that you willhave according to the incoming damage.
2- Incoming -> The amount of incoming damage.
3- Percentage -> The current HP percentage.
4- Incoming Percentage -> The HP percentage taking into account just the incoming damage and not current health.
local total, incoming, percentage, incoming_percent = unit_helper:get_health_percentage_inc(unit, 5)
core.log("Health after incoming damage: " .. (total * 100) .. "%")
tip
Generally, you will use this function as follows:
if unit_helper:get_health_percentage_inc(ally_target) < 0.45 then
is_anyone_low = true
end
Just taking into account the first value.
get_resource_percentage(unit: game_object, power_type: number) -> number​
Gets the power (resource) percentage of the unit. See PowerType Enum for power_type values.
---@type enums
local enums = require("common/enums")
local get_local_player_energy_pct(local_player)
local energy_percentage = unit_helper:get_resource_percentage(local_player, enums.power_type.ENERGY)
core.log("Unit's Energy percentage: " .. (energy_percentage * 100) .. "%")
return energy_percentage
end
Role Determination Functions 🏹​
get_role_id(unit: game_object) -> number​
Determines the role ID of the unit (Tank, DPS, Healer).
is_healer(unit: game_object) -> boolean​
Determines if the unit is healer.
warning
Might not work in open world (if the target is not a party member).
is_player_in_arena() -> boolean​
Determines if the local player is in arena.
is_player_in_bg() -> boolean​
Determines if the local player is in BG.
is_tank(unit: game_object) -> boolean​
warning
Might not work in open world (if the target is not a party member).
Determines if the unit is in the tank role.
tip
Below, an example on how to retrieve the tank from your party:
---@type unit_helper
local unit_helper = require("common/utility/unit_helper")
---@param local_player game_object
---@returns game_object | nil
local get_tank_from_party(local_player)
local allies_from_party = unit_helper:get_ally_list_around(local_player:get_position(), 40.0, true, true)
for k, ally in ipairs(allies_from_party) do
local is_current_ally_tank = unit_helper:is_tank(ally)
if is_current_ally_tank then
return ally
end
end
return nil
end
Group Unit Functions 👥​
tip
See Object Manager for a more in-depth explanation and code examples.
get_enemy_list_around(point: vec3, range: number, incl_out_combat?: boolean, incl_blacklist?: boolean) -> table<game_object>​
Returns a list of enemies within a designated area. This function is performance-friendly with Lua core cache.
point: The center point to search around.
range: The radius to search within.
incl_out_combat: Include units that are out of combat. Defaults to false.
incl_blacklist: Include units that are blacklisted. Defaults to false.
get_ally_list_around(point: vec3, range: number, players_only: boolean, party_only: boolean) -> table<game_object>​
Returns a list of allies within a designated area. This function is performance-friendly with Lua core cache.
point: The center point to search around.
range: The radius to search within.
players_only: Include only player units.
party_only: Include only party members.
Previous
Health Prediction Library
Next
Target Selector
Overview
Including the Module
FunctionsUnit Classification Functions 📋
is_dummy(unit: game_object) -> boolean
is_blacklist(npc_id: number) -> boolean
is_boss(unit: game_object) -> boolean
is_valid_enemy(unit: game_object) -> boolean
is_valid_ally(unit: game_object) -> boolean
Combat State Functions 🛡️
is_in_combat(unit: game_object) -> boolean
Health and Resource Functions ❤️
get_health_percentage(unit: game_object) -> number
get_health_percentage_inc(unit: game_object, time_limit?: number) -> number, number, number, number
get_resource_percentage(unit: game_object, power_type: number) -> number
Role Determination Functions 🏹
get_role_id(unit: game_object) -> number
is_healer(unit: game_object) -> boolean
is_player_in_arena() -> boolean
is_player_in_bg() -> boolean
is_tank(unit: game_object) -> boolean
Group Unit Functions 👥
get_enemy_list_around(point: vec3, range: number, incl_out_combat?: boolean, incl_blacklist?: boolean) -> table<game_object>
get_ally_list_around(point: vec3, range: number, players_only: boolean, party_only: boolean) -> table<game_object>
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Unit Helper Library _ Project Sylvanas.html>

<Vector 2 _ Project Sylvanas.html>
Vector 3 | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Vectors
Vector 3
On this page
Vector 3
Overview​
The vec3 module provides functions for working with 3D vectors in Lua scripts. These functions include vector creation, arithmetic operations, normalization, length calculation, dot and cross product calculation, interpolation, randomization, rotation, distance calculation, angle calculation, intersection checking, and more.
tip
If you are new and don't know what a vec3 is and want a deep understanding of this class, or the vec2 data structure, you might want to study some Linear Algebra. This information is basic and it will be useful for any game-related project that you might work on in the future. Since vec3 has 1 more coordinate in the space, working with vec3 is a little bit more complex. Therefore, if you are new, we recommend you to study vec2 first.
Importing the Module​
warning
This is a Lua library stored inside the "common" folder. To use it, you will need to include the library. Use the require function and store it in a local variable.
Here is an example of how to do it:
---@type vec3
local vec3 = require("common/geometry/vector_3")
Functions​
Vector Creation and Cloning​
new(x, y, z)​
Creates a new 3D vector with the specified x, y, and z components.
Parameters:
x (number) — The x component of the vector.
y (number) — The y component of the vector.
z (number) — The z component of the vector.
Returns: vec3 — A new vector instance.
note
If no number is passed as parameter (you construct the vector by using vec3.new()) then, a vector_3 is constructed with the values (0,0,0). So, :is_zero will be true.
clone()​
Clones the current vector.
Returns: vec3 — A new vector instance that is a copy of the original.
Arithmetic Operations ➕➖✖️➗​
__add(other)​
Overloads the addition operator (+) for vector addition.
Parameters:
other (vec3) — The vector to add.
Returns: vec3 — The result of the addition.
warning
Do not use this function directly. Instead, just use the operator +.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__add(v2)
--- Correct code:
local v3 = v1 + v2
__sub(other)​
Overloads the subtraction operator (-) for vector subtraction.
Parameters:
other (vec3) — The vector to subtract.
Returns: vec3 — The result of the subtraction.
warning
Do not use this function directly. Instead, just use the operator -.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__sub(v2)
--- Correct code:
local v3 = v1 - v2
__mul(value)​
Overloads the multiplication operator (*) for scalar multiplication or element-wise multiplication.
Parameters:
value (number or vec3) — The scalar or vector to multiply with.
Returns: vec3 — The result of the multiplication.
warning
Do not use this function directly. Instead, just use the operator *.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__mul(v2)
--- Correct code:
local v3 = v1 * v2
__div(value)​
Overloads the division operator (/) for scalar division or element-wise division.
Parameters:
value (number or vec3) — The scalar or vector to divide by.
Returns: vec3 — The result of the division.
warning
Do not use this function directly. Instead, just use the operator /.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__div(v2)
--- Correct code:
local v3 = v1 / v2
__eq(value)​
Overloads the equals operator (==).
Parameters:
value (vec3) — The vector 3 to check if it's equal.
Returns: boolean — True if both vectors are equal, false otherwise.
warning
Do not use this function directly. Instead, just use the operator ==.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local are_v1_and_v2_the_same = v1:__eq(v2)
--- Correct code:
local are_v1_and_v2_the_same = v1 == (v2)
Vector Properties and Methods 🧮​
normalize()​
Returns the normalized vector (unit vector) of the current vector.
Returns: vec3 — The normalized vector.
length()​
Returns the length (magnitude) of the vector.
Returns: number — The length of the vector.
dot(other)​
Calculates the dot product of two vectors.
Parameters:
other (vec3) — The other vector.
Returns: number — The dot product.
cross(other)​
Calculates the cross product of two vectors.
Parameters:
other (vec3) — The other vector.
Returns: vec3 — The cross product vector.
lerp(target, t)​
Performs linear interpolation between two vectors.
Parameters:
target (vec3) — The target vector.
t (number) — The interpolation factor (between 0.0 and 1.0).
Returns: vec3 — The interpolated vector.
Advanced Operations ⚙️​
rotate_around(origin, angle_degrees)​
Rotates the vector around a specified origin point by a given angle in degrees.
Parameters:
origin (vec3) — The origin point to rotate around.
angle_degrees (number) — The angle in degrees.
Returns: vec3 — The rotated vector.
dist_to(other)​
Calculates the Euclidean distance to another vector.
Parameters:
other (vec3) — The other vector.
Returns: number — The distance between the vectors.
tip
Usually, you would want to use dist_to_ignore_z, since for most cases you don't really care about the Z component of the vector (height differences).
We recommend using squared_dist_to_ignore_z, instead of dist_to_ignore_z or squared_dist_to instead of dist_to. If you check the mathematical formula to calculate a distance between 2 vectors, you will see there is a square root operation there. This is computationally expensive, so, for performance reasons, we advise you to just use the square function and then compare it to the value you want to compare it, but squared. For example:
-- check if the distance between v1 and v2 is > 10.0
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(5.0, 5.0, 5.0)
local v2 = vec3.new(10.0, 10.0, 10.0)
local distance_check = 10.0
local distance_check_squared = distance_check * distance_check
-- method 1: BAD
local distance = v1:dist_to(v2)
local is_dist_superior_to_10_method1 = distance > distance_check
core.log("Method 1 result: " .. tostring(is_dist_superior_to_10_method1))
-- method 2: GOOD
local distance_squared = v1:squared_dist_to(v2)
local is_dist_superior_to_10_method2 = distance_squared > distance_check_squared
core.log("Method 2 result: " .. tostring(is_dist_superior_to_10_method2))
If you run the previous code, you will notice that the result from the first method is the same as the result from the second method. However, the second one is much more efficient. This will make no difference in a low scale, but if you have multiple distance checks in your code it will end up being very noticeable in the user's FPS counter.
squared_dist_to(other)​
Calculates the Euclidean squared distance to another vector.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between the vectors.
note
This function is recommended over dist_to(other), for the reasons previously explained.
squared_dist_to_ignore_z(other)​
Calculates the Euclidean squared distance to another vector, ignoring the Z component of the vectors.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between the vectors, without taking into account the Z component of the vectors.
note
This function is recommended over dist_to_ignore_z(other), for the reasons previously explained.
dist_to_line_segment(line_segment_start, line_segment_end)​
Calculates the distance from self to a given line segment.
Parameters:
other (vec3) — The other vector.
Returns: number — The distance between self and a line segment.
squared_dist_to_line_segment(line_segment_start, line_segment_end)​
Calculates the distance from self to a given line segment.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between self and a line segment.
note
This function is recommended over dist_to_line_segment(), for the reasons previously explained.
squared_dist_to_ignore_z_line_segment(line_segment_start, line_segment_end)​
Calculates the distance from self to a given line segment, ignoring the Z component of the vector.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between self and a line segment, ignoring the Z component of the vector.
get_angle(origin)​
Calculates the angle between the vector and a target vector, relative to a specified origin point.
Parameters:
origin (vec3) — The origin point.
Returns: number — The angle in degrees.
intersects(p1, p2)​
Checks if the vector (as a point) intersects with a line segment defined by two points.
Parameters:
p1 (vec3) — The first point of the line segment.
p2 (vec3) — The second point of the line segment.
Returns: boolean — true if the point intersects the line segment; otherwise, false.
get_perp_left(origin)​
Returns the left perpendicular vector of the current vector relative to a specified origin point.
Parameters:
origin (vec3) — The origin point.
Returns: vec3 — The left perpendicular vector.
get_perp_right(origin)​
Returns the right perpendicular vector of the current vector relative to a specified origin point.
Parameters:
origin (vec3) — The origin point.
Returns: vec3 — The right perpendicular vector.
Additional Functions 🛠️​
dot_product(other)​
An alternative method to calculate the dot product of two vectors.
Parameters:
other (vec3) — The other vector.
Returns: number — The dot product.
is_nan()​
Checks if the vector is not a number.
Returns: boolean — True if the vector_3 is not a number, false otherwise.
is_zero()​
Checks if the vector is zero.
Returns: boolean — True if the vector_3 is the vector(0,0,0), false otherwise.
tip
Saying that a vector is_zero is the same as saying that the said vector equals the vec3.new(0,0,0)
Code Examples​
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 2, 3)
local v2 = vec3.new(4, 5, 6)
local v3 = v1:clone() -- Clone v1
-- Adding vectors
local v_add = v1 + v2
core.log("Vector addition result: " .. v_add.x .. ", " .. v_add.y .. ", " .. v_add.z)
-- Subtracting vectors
local v_sub = v1 - v2
core.log("Vector subtraction result: " .. v_sub.x .. ", " .. v_sub.y .. ", " .. v_sub.z)
-- Normalizing a vector
local v_norm = v1:normalize()
core.log("Normalized vector: " .. v_norm.x .. ", " .. v_norm.y .. ", " .. v_norm.z)
-- Finding the distance between two vectors, ignoring z
local dist_ignore_z = v1:dist_to_ignore_z(v2)
core.log("Distance ignoring Z: " .. dist_ignore_z)
-- Finding the squared length for efficiency
local dist_squared = v1:length_squared()
core.log("Squared length: " .. dist_squared)
Previous
Vector 2
Next
Spell Prediction
Overview
Importing the Module
FunctionsVector Creation and Cloning
new(x, y, z)
clone()
Arithmetic Operations ➕➖✖️➗
__add(other)
__sub(other)
__mul(value)
__div(value)
__eq(value)
Vector Properties and Methods 🧮
normalize()
length()
dot(other)
cross(other)
lerp(target, t)
Advanced Operations ⚙️
rotate_around(origin, angle_degrees)
dist_to(other)
squared_dist_to(other)
squared_dist_to_ignore_z(other)
dist_to_line_segment(line_segment_start, line_segment_end)
squared_dist_to_line_segment(line_segment_start, line_segment_end)
squared_dist_to_ignore_z_line_segment(line_segment_start, line_segment_end)
get_angle(origin)
intersects(p1, p2)
get_perp_left(origin)
get_perp_right(origin)
Additional Functions 🛠️
dot_product(other)
is_nan()
is_zero()
Code Examples
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Vector 2 _ Project Sylvanas.html>

<Vector 3 _ Project Sylvanas.html>
Vector 3 | Project Sylvanas
Skip to main content
Project SylvanasDocumentation
ctrlK
👋 Welcome
👨‍💻 Scripting Reference
Documentation
Dev Docs
Getting Started
Core
Object Manager
Game Object
Game Object - Functions
Game Object - Code Examples
Buffs
Spell Book
Spell Book - Raw Functions
Spell helper
Graphics
Graphics - Functions
Graphics - Notifications
Menu Elements
Input
Geometry
Control Panel
Vectors
Vector 2
Vector 3
Libraries
Custom UI
User Docs
Common Issues
Getting Started
Menu
Control Panel
Target Selector
Spell Queue
Combat Forecast
Health Prediction
Core Visuals
Core Utility
Core Interrupt
Rotations Guides
Paladin Retribution
👨‍💻 Scripting Reference
Documentation
Dev Docs
Vectors
Vector 3
On this page
Vector 3
Overview​
The vec3 module provides functions for working with 3D vectors in Lua scripts. These functions include vector creation, arithmetic operations, normalization, length calculation, dot and cross product calculation, interpolation, randomization, rotation, distance calculation, angle calculation, intersection checking, and more.
tip
If you are new and don't know what a vec3 is and want a deep understanding of this class, or the vec2 data structure, you might want to study some Linear Algebra. This information is basic and it will be useful for any game-related project that you might work on in the future. Since vec3 has 1 more coordinate in the space, working with vec3 is a little bit more complex. Therefore, if you are new, we recommend you to study vec2 first.
Importing the Module​
warning
This is a Lua library stored inside the "common" folder. To use it, you will need to include the library. Use the require function and store it in a local variable.
Here is an example of how to do it:
---@type vec3
local vec3 = require("common/geometry/vector_3")
Functions​
Vector Creation and Cloning​
new(x, y, z)​
Creates a new 3D vector with the specified x, y, and z components.
Parameters:
x (number) — The x component of the vector.
y (number) — The y component of the vector.
z (number) — The z component of the vector.
Returns: vec3 — A new vector instance.
note
If no number is passed as parameter (you construct the vector by using vec3.new()) then, a vector_3 is constructed with the values (0,0,0). So, :is_zero will be true.
clone()​
Clones the current vector.
Returns: vec3 — A new vector instance that is a copy of the original.
Arithmetic Operations ➕➖✖️➗​
__add(other)​
Overloads the addition operator (+) for vector addition.
Parameters:
other (vec3) — The vector to add.
Returns: vec3 — The result of the addition.
warning
Do not use this function directly. Instead, just use the operator +.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__add(v2)
--- Correct code:
local v3 = v1 + v2
__sub(other)​
Overloads the subtraction operator (-) for vector subtraction.
Parameters:
other (vec3) — The vector to subtract.
Returns: vec3 — The result of the subtraction.
warning
Do not use this function directly. Instead, just use the operator -.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__sub(v2)
--- Correct code:
local v3 = v1 - v2
__mul(value)​
Overloads the multiplication operator (*) for scalar multiplication or element-wise multiplication.
Parameters:
value (number or vec3) — The scalar or vector to multiply with.
Returns: vec3 — The result of the multiplication.
warning
Do not use this function directly. Instead, just use the operator *.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__mul(v2)
--- Correct code:
local v3 = v1 * v2
__div(value)​
Overloads the division operator (/) for scalar division or element-wise division.
Parameters:
value (number or vec3) — The scalar or vector to divide by.
Returns: vec3 — The result of the division.
warning
Do not use this function directly. Instead, just use the operator /.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local v3 = v1:__div(v2)
--- Correct code:
local v3 = v1 / v2
__eq(value)​
Overloads the equals operator (==).
Parameters:
value (vec3) — The vector 3 to check if it's equal.
Returns: boolean — True if both vectors are equal, false otherwise.
warning
Do not use this function directly. Instead, just use the operator ==.
For example:
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 1, 0)
local v2 = vec3.new(2, 2, 2)
--- Bad code:
-- local are_v1_and_v2_the_same = v1:__eq(v2)
--- Correct code:
local are_v1_and_v2_the_same = v1 == (v2)
Vector Properties and Methods 🧮​
normalize()​
Returns the normalized vector (unit vector) of the current vector.
Returns: vec3 — The normalized vector.
length()​
Returns the length (magnitude) of the vector.
Returns: number — The length of the vector.
dot(other)​
Calculates the dot product of two vectors.
Parameters:
other (vec3) — The other vector.
Returns: number — The dot product.
cross(other)​
Calculates the cross product of two vectors.
Parameters:
other (vec3) — The other vector.
Returns: vec3 — The cross product vector.
lerp(target, t)​
Performs linear interpolation between two vectors.
Parameters:
target (vec3) — The target vector.
t (number) — The interpolation factor (between 0.0 and 1.0).
Returns: vec3 — The interpolated vector.
Advanced Operations ⚙️​
rotate_around(origin, angle_degrees)​
Rotates the vector around a specified origin point by a given angle in degrees.
Parameters:
origin (vec3) — The origin point to rotate around.
angle_degrees (number) — The angle in degrees.
Returns: vec3 — The rotated vector.
dist_to(other)​
Calculates the Euclidean distance to another vector.
Parameters:
other (vec3) — The other vector.
Returns: number — The distance between the vectors.
tip
Usually, you would want to use dist_to_ignore_z, since for most cases you don't really care about the Z component of the vector (height differences).
We recommend using squared_dist_to_ignore_z, instead of dist_to_ignore_z or squared_dist_to instead of dist_to. If you check the mathematical formula to calculate a distance between 2 vectors, you will see there is a square root operation there. This is computationally expensive, so, for performance reasons, we advise you to just use the square function and then compare it to the value you want to compare it, but squared. For example:
-- check if the distance between v1 and v2 is > 10.0
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(5.0, 5.0, 5.0)
local v2 = vec3.new(10.0, 10.0, 10.0)
local distance_check = 10.0
local distance_check_squared = distance_check * distance_check
-- method 1: BAD
local distance = v1:dist_to(v2)
local is_dist_superior_to_10_method1 = distance > distance_check
core.log("Method 1 result: " .. tostring(is_dist_superior_to_10_method1))
-- method 2: GOOD
local distance_squared = v1:squared_dist_to(v2)
local is_dist_superior_to_10_method2 = distance_squared > distance_check_squared
core.log("Method 2 result: " .. tostring(is_dist_superior_to_10_method2))
If you run the previous code, you will notice that the result from the first method is the same as the result from the second method. However, the second one is much more efficient. This will make no difference in a low scale, but if you have multiple distance checks in your code it will end up being very noticeable in the user's FPS counter.
squared_dist_to(other)​
Calculates the Euclidean squared distance to another vector.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between the vectors.
note
This function is recommended over dist_to(other), for the reasons previously explained.
squared_dist_to_ignore_z(other)​
Calculates the Euclidean squared distance to another vector, ignoring the Z component of the vectors.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between the vectors, without taking into account the Z component of the vectors.
note
This function is recommended over dist_to_ignore_z(other), for the reasons previously explained.
dist_to_line_segment(line_segment_start, line_segment_end)​
Calculates the distance from self to a given line segment.
Parameters:
other (vec3) — The other vector.
Returns: number — The distance between self and a line segment.
squared_dist_to_line_segment(line_segment_start, line_segment_end)​
Calculates the distance from self to a given line segment.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between self and a line segment.
note
This function is recommended over dist_to_line_segment(), for the reasons previously explained.
squared_dist_to_ignore_z_line_segment(line_segment_start, line_segment_end)​
Calculates the distance from self to a given line segment, ignoring the Z component of the vector.
Parameters:
other (vec3) — The other vector.
Returns: number — The squared distance between self and a line segment, ignoring the Z component of the vector.
get_angle(origin)​
Calculates the angle between the vector and a target vector, relative to a specified origin point.
Parameters:
origin (vec3) — The origin point.
Returns: number — The angle in degrees.
intersects(p1, p2)​
Checks if the vector (as a point) intersects with a line segment defined by two points.
Parameters:
p1 (vec3) — The first point of the line segment.
p2 (vec3) — The second point of the line segment.
Returns: boolean — true if the point intersects the line segment; otherwise, false.
get_perp_left(origin)​
Returns the left perpendicular vector of the current vector relative to a specified origin point.
Parameters:
origin (vec3) — The origin point.
Returns: vec3 — The left perpendicular vector.
get_perp_right(origin)​
Returns the right perpendicular vector of the current vector relative to a specified origin point.
Parameters:
origin (vec3) — The origin point.
Returns: vec3 — The right perpendicular vector.
Additional Functions 🛠️​
dot_product(other)​
An alternative method to calculate the dot product of two vectors.
Parameters:
other (vec3) — The other vector.
Returns: number — The dot product.
is_nan()​
Checks if the vector is not a number.
Returns: boolean — True if the vector_3 is not a number, false otherwise.
is_zero()​
Checks if the vector is zero.
Returns: boolean — True if the vector_3 is the vector(0,0,0), false otherwise.
tip
Saying that a vector is_zero is the same as saying that the said vector equals the vec3.new(0,0,0)
Code Examples​
---@type vec3
local vec3 = require("common/geometry/vector_3")
local v1 = vec3.new(1, 2, 3)
local v2 = vec3.new(4, 5, 6)
local v3 = v1:clone() -- Clone v1
-- Adding vectors
local v_add = v1 + v2
core.log("Vector addition result: " .. v_add.x .. ", " .. v_add.y .. ", " .. v_add.z)
-- Subtracting vectors
local v_sub = v1 - v2
core.log("Vector subtraction result: " .. v_sub.x .. ", " .. v_sub.y .. ", " .. v_sub.z)
-- Normalizing a vector
local v_norm = v1:normalize()
core.log("Normalized vector: " .. v_norm.x .. ", " .. v_norm.y .. ", " .. v_norm.z)
-- Finding the distance between two vectors, ignoring z
local dist_ignore_z = v1:dist_to_ignore_z(v2)
core.log("Distance ignoring Z: " .. dist_ignore_z)
-- Finding the squared length for efficiency
local dist_squared = v1:length_squared()
core.log("Squared length: " .. dist_squared)
Previous
Vector 2
Next
Spell Prediction
Overview
Importing the Module
FunctionsVector Creation and Cloning
new(x, y, z)
clone()
Arithmetic Operations ➕➖✖️➗
__add(other)
__sub(other)
__mul(value)
__div(value)
__eq(value)
Vector Properties and Methods 🧮
normalize()
length()
dot(other)
cross(other)
lerp(target, t)
Advanced Operations ⚙️
rotate_around(origin, angle_degrees)
dist_to(other)
squared_dist_to(other)
squared_dist_to_ignore_z(other)
dist_to_line_segment(line_segment_start, line_segment_end)
squared_dist_to_line_segment(line_segment_start, line_segment_end)
squared_dist_to_ignore_z_line_segment(line_segment_start, line_segment_end)
get_angle(origin)
intersects(p1, p2)
get_perp_left(origin)
get_perp_right(origin)
Additional Functions 🛠️
dot_product(other)
is_nan()
is_zero()
Code Examples
Docs
Documentation
Explore
Home
Roadmap
More
Discord
Project Sylvanas — 2025
</Vector 3 _ Project Sylvanas.html>
