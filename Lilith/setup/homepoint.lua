-- Sets the character's home point in Mhaura.
--
-- This must be done once per character before any farming runs, so that
-- death / warp-to-HP always returns the character to Mhaura.

bot = require('bot/bot')
resources = require('resources')

local homepoint = {}

homepoint.MHAURA_ZONE_ID = 249  -- Mhaura

-- Home Point #1 in Mhaura, near the dock.
-- TODO: verify NPC name and coordinates in game.
homepoint.crystal = {
  npc_name = 'Home Point #1',
  x = 0,    -- TODO: fill in
  y = 0,    -- TODO: fill in
}

-- Menu option index for "Set this as your home point." in the home point
-- crystal dialog.
-- TODO: capture the real menu id / option index with a packet viewer.
homepoint.SET_HP_OPTION_INDEX = 1

function homepoint.is_in_mhaura()
  return windower.ffxi.get_info().zone == homepoint.MHAURA_ZONE_ID
end

-- Travel to Mhaura from wherever we currently are.
-- TODO: implement actual travel logic (e.g. warp to current HP, then take
-- the ferry / teleport / Unity warp as appropriate).
function homepoint.go_to_mhaura()
  if homepoint.is_in_mhaura() then
    return true
  end

  error('Travel to Mhaura is not implemented yet - please move there manually.')
end

-- Walk to the home point crystal and set it as our home point.
function homepoint.set_mhaura()
  if not homepoint.go_to_mhaura() then
    return false
  end

  bot.run_to_pos(homepoint.crystal.x, homepoint.crystal.y, {timeout = 60})

  local crystal_id = bot.wait_for_mob_by_name(homepoint.crystal.npc_name, false)
  local menu_id = bot.start_dialog(crystal_id)

  -- TODO: walk the dialog menu and pick the "set home point" option:
  -- bot.send_dialog_packet(crystal_id, menu_id, homepoint.SET_HP_OPTION_INDEX)

  windower.add_to_chat(207, '[Lilith] Home point set in Mhaura (stub).')
  return true
end

return homepoint
