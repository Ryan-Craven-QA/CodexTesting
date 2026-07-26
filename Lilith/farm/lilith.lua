-- The actual Lilith farming loop.
--
-- Preconditions (checked at the start of run()):
--   * Home point is set in Mhaura (see setup/homepoint.lua).
--   * Both Ambuscade primer key items are in possession
--     (see ambuscade/ambuscade.lua).
--
-- TODO: port the existing Lilith fight logic on top of the bot/ library
-- (trust summoning, entering the fight, kill loop, exit, repeat).

bot = require('bot/bot')
ambuscade = require('ambuscade/ambuscade')

local farm = {}

function farm.check_prerequisites()
  for volume = 1, 2 do
    if not ambuscade.has_ki(volume) then
      windower.add_to_chat(123, string.format(
        '[Lilith] Missing %s - run //lilith ki %d first.',
        ambuscade.KEY_ITEMS[volume], volume))
      return false
    end
  end
  return true
end

function farm.run()
  if not farm.check_prerequisites() then
    return false
  end

  -- TODO: implement the Lilith farming loop:
  --   1. Travel to the fight entrance.
  --   2. Summon trusts (bot.summon_trust).
  --   3. Enter, fight (bot.kill_mob with tuned options), collect rewards.
  --   4. Exit and repeat, warping back to the Mhaura home point as needed.
  error('Lilith farming loop is not implemented yet.')
end

return farm
