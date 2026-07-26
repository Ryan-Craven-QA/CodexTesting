-- Ambuscade KI gathering.
--
-- Each month, Ambuscade rotates which monster family must be killed to
-- obtain the two primer key items:
--   Volume One: "Ambuscade Primer Volume One" - kill XP-yielding mobs of
--               the Volume 1 family for the month.
--   Volume Two: "Ambuscade Primer Volume Two" - kill XP-yielding mobs of
--               the Volume 2 family for the month.
--
-- The rotation lives in ambuscade/months/<YYYY-MM>.lua, which maps each
-- volume to a family. The details of where to hunt each family live in
-- ambuscade/families/<family>.lua.

bot = require('bot/bot')

local ambuscade = {}

ambuscade.KEY_ITEMS = {
  [1] = 'Ambuscade Primer Volume One',
  [2] = 'Ambuscade Primer Volume Two',
}

-- Load the month config for the current (or given) month.
-- e.g. ambuscade/months/2026-07.lua
function ambuscade.load_month(year, month)
  year = year or tonumber(os.date('%Y'))
  month = month or tonumber(os.date('%m'))

  local key = string.format('%04d-%02d', year, month)
  local ok, month_data = pcall(require, 'ambuscade/months/' .. key)
  if not ok then
    error('No Ambuscade data for ' .. key ..
          ' - create ambuscade/months/' .. key .. '.lua (see months/template.lua)')
  end
  return month_data
end

-- Load the family hunting data (camps, travel, target mobs) for a family.
-- e.g. ambuscade/families/qiqirn.lua
function ambuscade.load_family(family_name)
  local key = family_name:lower()
  local ok, family = pcall(require, 'ambuscade/families/' .. key)
  if not ok then
    error('No family data for "' .. family_name ..
          '" - create ambuscade/families/' .. key .. '.lua')
  end
  return family
end

function ambuscade.has_ki(volume)
  return bot.has_key_item(ambuscade.KEY_ITEMS[volume])
end

-- Farm the primer KI for the given volume (1 or 2) for the current month.
function ambuscade.farm_ki(volume)
  if ambuscade.has_ki(volume) then
    windower.add_to_chat(207, '[Lilith] Already have ' .. ambuscade.KEY_ITEMS[volume] .. '.')
    return true
  end

  local month = ambuscade.load_month()
  local volume_data = volume == 1 and month.volume1 or month.volume2
  local family = ambuscade.load_family(volume_data.family)
  local camp = family.camps[1]  -- TODO: support choosing between multiple camps

  windower.add_to_chat(207, string.format(
    '[Lilith] Farming %s: killing %s family mobs in %s.',
    ambuscade.KEY_ITEMS[volume], family.name, camp.zone_name))

  ambuscade.travel_to_camp(camp)
  ambuscade.kill_until_ki(volume, camp)

  return ambuscade.has_ki(volume)
end

-- Travel from Mhaura (our home point) to the camp.
-- TODO: implement travel per camp (warp ring back to HP first, then follow
-- camp.travel steps - e.g. HP warp, Unity warp, run route).
function ambuscade.travel_to_camp(camp)
  if windower.ffxi.get_info().zone == camp.zone_id then
    return true
  end

  error('Travel to ' .. camp.zone_name .. ' is not implemented yet.')
end

-- Kill XP-yielding mobs of the target family until the primer KI drops.
function ambuscade.kill_until_ki(volume, camp)
  while not ambuscade.has_ki(volume) do
    local mob_id = bot.wait_for_mob_by_name(camp.mob_names)

    -- TODO: tune kill options (skillchain, buffs, pull spell) per job setup.
    bot.camp_mob(mob_id, camp.x, camp.y, {
      pull_spell_or_ability = camp.pull_spell_or_ability,
    })

    coroutine.sleep(1)
  end

  windower.add_to_chat(207, '[Lilith] Obtained ' .. ambuscade.KEY_ITEMS[volume] .. '!')
end

return ambuscade
