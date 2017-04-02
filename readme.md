## phaser-p2-coffee-webpack-boiler

This is a starting point for writing games using the Phaser javascript library with the P2 physics engine.

It sets up a project to use coffeescript and webpack.

---

**using**

1. clone
2. `npm install`
3. `npm run dev`.
4. visit localhost:8080


---

**example**

take a look at the snood-pinball-coffee folder in the [phaser_wrapper](http://github.com/phaser_wrapper) repo. This can be played
at [maxpleaner.github.io/pinball](http://maxpleaner.github.io/pinball). This boiler was extracted from that project so the file
organization is the same.

**guide to source code**

- `webpack.config.js` is the entry point for _development_ mode webpack. It starts a static server on port 8080
and serves index.html as its root. It uses coffee-loader to compile all coffeescript files into a single, in-memory
bundle.js which is loaded from index.html.  
  This gets started with `npm run dev`. See the `package.json` for the definition of this command.

- `webpack.config.production.js` will prepare the app for _production_. It does not run its own static server. Rather, it
compiles all the coffeescripts into a `prod-bundle.js` that can be deployed to a static-website host such as github pages.  
  Start this with `npm run deploy`. You'll need to manually create a deployment folder and copy the index.html and style.css in there along with the prod-bundle.
  Also the script src in index.html needs to be changed from bundle.js to prod-bundle.js.

- `style.css` - hardly used here. 

- `loader.coffee` - the entry of the application, the first thing read by webpack. Loads other files then starts the game.  
  _note_ this is where the game width and height are configured. Also there's a setting in here to toggle debugMode. Setting this to
  true will outline all sprite bounds and hitboxes. The only things added to `window` are done so in here.

- `index.html` - a super simple html page that is basically empty. It loads the Phaser game as a script and lets it take over.

- _assets_: There are two folders for assets. The `asset-src` is intended to be used for incomplete assets - for example the original version of an image that is
  modified for use in the game. `assets` is indended as a place for finished assets of any kind. Files in here have their paths specified in `assets.coffee`.
  This boiler ships with one example asset + physics file.

- _lib folder_: This one is more complex than the rest and is where the core of the game lives.
  - `game_loader.coffee` (required by `loader.coffee`). It loads `play_state.coffee` and sets it as the initial state of the game.
  - `play_state.coffee` a very minimal file that just requires the files in `play_state/`. Each of those files is a single function and they
  get combined into one object which is a proper Phaser state. 
  - `assets`: A manifest of assets. All assets should get their paths assigned to variables here and then be referenced from `preload.coffee` using those variables.
  - `play_state/init.coffee` - this is the first function called by phaser. Like create, it's only called once upon the game's initial load. 
    This file doesn't do a whole lot. It loads the state/assets/util files and tells Phaser to use P2 physics.
  - `play_state/preload.coffee` - all assets need to get added here in addition to the `assets` file. There is a different load method
    that needs to be called for different assets types. See the Phaser docs on that.
  - `play_state/create.coffee` - this is the most important file in terms of dictating the behavior of the game. Here, assets are added to the page,
  custom hitboxes are added, and collision behavior is defined. The methods in `util.coffee` can be used here. 
  - `state.coffee` - properties that make up the initial state of the game.
  - `util.coffee` - Alot of the files in this repo are sparse, but `util.coffee` has an API that can be used to build the game.
    There are a bunch of methods in there:
    - `random_int(min, max)`
    - `random_from_list(list)`
    - `collide_world_bounds(sprite)` - limit the sprite's movement to the game board
    - `add_physics_file(sprite, physics_file, physics_file_key)` - physics files are used to create polygonal hitboxes.  
      They can be created with PhysicsEditor and exported in the lime/corona json format.
      The physics file needs to be loaded in preload
      as well as the sprite, and the name assigned to it there is the
      value that gets passed here as `physics_file`. The `physics_key`
      is whatever name was given for the asset in PhysicsEditor.
      This can be inspected by opening the json file.  
      _tricky things_  
      I haven't yet found a good way to scale polygonal sprites, adjust their anchor x/y, or change their center of mass. Doing all these things messes up the
      polygonal hitbox.
    - `set_game_size_and_background(width, height, background_key)` - background key refers to an asset that was loaded in the preload function
    - `set_game_size(width, height)`
    - `add_p2_sprite(x, y, key)` - this is called from the create function. It puts a sprite on the page and sets it up to use P2 physics.
    - `make_static(sprite)` prevent it from responding to collisions
    - `turn_off_gravity(sprite)` - prevent it from responding to gravity
    - `create_collision_group` this needs to be done for every kind of asset that collides. This just creates an anonymous one; it's customized later.
    - `set_sprite_collision_group(sprite, collision_group)` assigns the collision group to the sprite. 
    - `add_group` - creates a new anonymous sprite group with P2 physics enabled
    - `add_sprite_material(sprites..., key)` - the key here is just an arbitrary name. See below for an explanation of materials vs collisions
    - `add_world_material(key)` - probably just needs to be called once, allows for customizing the collision physics with the world bounds.
    - `add_contact_material(material1, material2, opts)` - customize the physics of a collision between two materials. The options here all have defaults set,
       but here are the keys: friction, restitution (bounciness), stuffness, relaxation, frictionStiffness, frictionRelaxation, and surfaceVelocity.

It's probably worth explaining the difference between materials and
collisions here because it's a little confusing. With any two objects that collide (i.e. they push each other), there needs to be a collision group for each
and a connection declared at both ends (this is explained below). Beyond this, there's no reason to write any more code regarding collisions _except_ if there's
a custom Javscript function you want to run when the collision happens.

In either case, after calling `create_collision_group` and `set_collision_group` on two sprites it's necessary to call `collide`:

```coffee
sprite1.body.collides sprite2_collision_group, (sprite1, sprite2) =>
  # do custom stuff here
```

You'd _also_ need to declare `sprite2.body.collides sprite1` (note that the callback is optional and there's no reason to declare it in both places). 

Materials, on the other hand, don't offer callbacks but they do allow customizing the physics of the collision. These are totally optional in all situations. 
