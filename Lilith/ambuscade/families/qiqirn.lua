-- Hunting data for the Qiqirn family.
--
-- Used when a monthly rotation file names 'Qiqirn' as the family for
-- Volume One or Volume Two. Mobs must yield XP for the primer KI to drop,
-- so pick camps with mobs that still give XP at the character's level.

return {
  name = 'Qiqirn',

  camps = {
    {
      -- TODO: verify this is the best XP-yielding Qiqirn camp and fill in
      -- the real zone id, camp coordinates, and mob names.
      zone_name = 'Aydeewa Subterrane',
      zone_id = 68,
      x = 0,   -- TODO: camp position
      y = 0,   -- TODO: camp position
      mob_names = S{
        'Qiqirn Enterpriser',  -- TODO: confirm mob names in this zone
      },
      pull_spell_or_ability = 'Dia III',

      -- Ordered travel steps from the Mhaura home point to this camp.
      -- TODO: define the step format and implement in ambuscade.travel_to_camp
      -- (e.g. {type = 'homepoint_warp', destination = '...'},
      --       {type = 'run_route', points = {...}}).
      travel = {},
    },
  },
}
