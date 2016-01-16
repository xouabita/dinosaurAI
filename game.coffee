dino = Runner.instance_ # Find the runner instance

module.exports.getObstacles = getObstacles = ->
  [].concat dino.horizon.obstacles

module.exports.getSpeed = getSpeed = ->
  dino.currentSpeed
