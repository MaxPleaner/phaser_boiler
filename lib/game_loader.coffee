PlayState = require './play_state'

module.exports = GameLoader = start: ->
  game = new Phaser.Game(
    GameWidth, GameHeight, Phaser.WEBGL, 'game', null, false, true
  )
  game.state.add 'PlayState', PlayState
  game.state.start 'PlayState'
  game

