module.exports = Util = 

  random_int: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  random_from_list: (list) ->
    list[Math.floor((Math.random() * list.length))]

  collide_world_bounds: (sprite) ->
    sprite.body.collideWorldBounds = true
  
  add_physics_file: (sprite, physics_file, physics_file_key) ->
    sprite.body.clearShapes()
    sprite.body.loadPolygon physics_file, physics_file_key

  set_game_size_and_background: (width, height, background_key) ->
    @set_game_size(width, height)
    background = @add_p2_sprite @midpoint_x, @midpoint_y, background_key
    @make_static(background)
    @turn_off_gravity(background)
    background

  set_game_size: (width, height) ->
    @game.world.setBounds 0, 0, width, height

  add_p2_sprite: (x, y, key) ->
    sprite = @add.sprite x, y, key
    @physics.p2.enable sprite, DebugMode
    sprite

  make_static: (sprite) ->
    sprite.body.static = true

  turn_off_gravity: (sprite) ->
    sprite.body.data.gravityScale = 0

  create_collision_group: ->
    collision_group = @game.physics.p2.createCollisionGroup()
    @game.physics.p2.updateBoundsCollisionGroup()
    collision_group

  set_sprite_collision_group: (sprite, collision_group) ->
    sprite.body.setCollisionGroup(collision_group)

  add_group: ->
    group = @game.add.group();
    group.enableBody = true;
    group.physicsBodyType = Phaser.Physics.P2JS;
    group

  add_sprite_material: (sprites..., key) ->
    material = @game.physics.p2.createMaterial key
    sprites.forEach (sprite) =>
      sprite.body.setMaterial material
    material

  add_world_material: (key) ->
    material = @add_sprite_material key
    @game.physics.p2.setWorldMaterial material, true, true, true, true
    material

  add_contact_material: (material1, material2, opts) ->
    contact_material = @game.physics.p2.createContactMaterial material1, material2
    Object.assign contact_material, opts
    contact_material.friction           ||= 0
    contact_material.restitution        ||= 1.0
    contact_material.stuffness          ||= 1e7
    contact_material.relaxation         ||= 3
    contact_material.frictionStiffness  ||= 1e7
    contact_material.frictionRelaxation ||= 3
    contact_material.surfaceVelocity    ||= 0
    contact_material
