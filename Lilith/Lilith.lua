_addon.name = 'Lilith'
_addon.author = 'Ryan'
_addon.version = '0.1.0'
_addon.commands = {'lilith'}

-- Entry point for the Lilith farming addon.
--
-- Flow:
--   1. //lilith hp        - set home point in Mhaura (run once per character)
--   2. //lilith ki 1      - farm the Ambuscade Primer Volume One KI for this month
--   3. //lilith ki 2      - farm the Ambuscade Primer Volume Two KI for this month
--   4. //lilith farm      - run the actual Lilith farming loop
--   5. //lilith stop      - stop whatever is currently running

packets = require('packets')
resources = require('resources')
require('sets')

bot = require('bot/bot')
homepoint = require('setup/homepoint')
ambuscade = require('ambuscade/ambuscade')
farm = require('farm/lilith')

local task_running = false

local function run(name, f, ...)
  if task_running then
    windower.add_to_chat(123, '[Lilith] A task is already running. Use //lilith stop first.')
    return
  end

  local args = {...}
  task_running = true
  coroutine.schedule(function()
    windower.add_to_chat(207, '[Lilith] Starting task: ' .. name)
    local ok, err = pcall(f, unpack(args))
    if not ok then
      windower.add_to_chat(123, '[Lilith] Task failed: ' .. tostring(err))
    end
    windower.add_to_chat(207, '[Lilith] Task finished: ' .. name)
    task_running = false
  end, 0)
end

-- Running tasks are coroutines that sleep in loops; there is no clean way
-- to kill them mid-flight in Lua 5.1, so stop() halts movement/handlers and
-- reloads the addon to guarantee everything is torn down.
local function stop()
  bot.stop_running()
  events.unregister_all()
  task_running = false
  windower.add_to_chat(207, '[Lilith] Stopped - reloading addon.')
  windower.send_command('lua reload lilith')
end

windower.register_event('addon command', function(cmd, ...)
  cmd = cmd and cmd:lower() or 'help'
  local args = {...}

  if cmd == 'hp' then
    run('set homepoint (Mhaura)', homepoint.set_mhaura)
  elseif cmd == 'ki' then
    local volume = tonumber(args[1])
    if volume ~= 1 and volume ~= 2 then
      windower.add_to_chat(123, '[Lilith] Usage: //lilith ki <1|2>')
      return
    end
    run('farm Ambuscade KI Vol.' .. volume, ambuscade.farm_ki, volume)
  elseif cmd == 'farm' then
    run('farm Lilith', farm.run)
  elseif cmd == 'stop' then
    stop()
  else
    windower.add_to_chat(207, '[Lilith] Commands:')
    windower.add_to_chat(207, '  //lilith hp      - set home point in Mhaura')
    windower.add_to_chat(207, '  //lilith ki 1    - farm Ambuscade Primer Volume One')
    windower.add_to_chat(207, '  //lilith ki 2    - farm Ambuscade Primer Volume Two')
    windower.add_to_chat(207, '  //lilith farm    - farm Lilith')
    windower.add_to_chat(207, '  //lilith stop    - stop the current task')
  end
end)
