var path = require('path')

var phaserModule = path.join(__dirname, '/node_modules/phaser/');
var phaser = path.join(phaserModule, 'build/custom/phaser-split.js'),
  pixi = path.join(phaserModule, 'build/custom/pixi.js'),
  p2 = path.join(phaserModule, 'build/custom/p2.js');

module.exports = {
  entry: './loader.coffee',
  output: {
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee-loader" },
      { test: /pixi.js/, loader: "script-loader" },

    ]
  },
  resolve: {
    extensions: ["*", ".web.coffee", ".web.js", ".coffee", ".js"],
    alias: {
      'phaser': phaser,
      'pixi.js': pixi,
      'p2': p2
    }
  }
}
