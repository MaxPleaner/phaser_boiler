module.exports = ->

  Object.assign this,
    require("../state").load(this),
    require("../util"),
    Assets: require("../assets")

  @physics.startSystem Phaser.Physics.P2JS
  @game.physics.p2.setImpactEvents(true);
  Object.assign @game.physics.p2.gravity, @gravity

  window.App = this
  
