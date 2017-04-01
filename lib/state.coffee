module.exports = load: (caller) ->
  
  game_width = GameWidth
  game_height = GameHeight

  midpoint_x = game_width / 2 
  midpoint_y = game_height / 2

  hidden_x = -500
  hidden_y = -500

  collision_groups = {}
  materials = {}
  contact_materials = {}
  groups = {}
  animations = {}
  
  cursors = caller.game.input.keyboard.createCursorKeys();
  
  gravity =
    x: 0
    y: 800

  {

    game_width,
    game_height,
    midpoint_x,
    midpoint_y,
    hidden_x,
    hidden_y,
    collision_groups,
    materials,
    contact_materials,
    groups,
    animations,
    cursors,
    gravity
  }
