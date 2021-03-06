co = require 'co'
ui = require './ui'

nextObstacle_ = undefined
{ tRex }      = Runner.instance_
xDino_        = tRex.xPos + tRex.config.WIDTH

keyboard = require './keyboard'
cactusJumped = undefined

# Function to update the next obstacle
updateNextObstacle_ = ->
  obstacles = Runner.instance_.horizon.obstacles
  oldObstacle = nextObstacle_
  if obstacles.length is 0
    nextObstacle_ = undefined
  else
    nextObstacle_ =
      if obstacles[0].xPos > xDino_ then obstacles[0]
      else obstacles[1]

  # update the cactus jumped
  if oldObstacle isnt nextObstacle_ and oldObstacle
    cactusJumped += 1
    ui.setCactusJumped cactusJumped

# Update the next obstacle every 50ms
setInterval updateNextObstacle_, 50

module.exports.getDistance = ->
  distance =
    if nextObstacle_ then nextObstacle_.xPos - xDino_
    else 600 - xDino_
  ui.setDistance distance
  return distance

module.exports.getHeight = ->
  height =
    if nextObstacle_ then 150 - nextObstacle_.yPos
    else 0
  ui.setHeight height
  return height

module.exports.getSpeed = ->
  speed = Runner.instance_.currentSpeed
  ui.setSpeed speed
  return speed

module.exports.play = co.wrap ->
  {started, crashed} = Runner.instance_

  # reset cactusJumped
  cactusJumped = 0
  jumps = 0
  jumping = Runner.instance_.tRex.jumping

  ui.setJumps 0
  updateJumps = ->
    if not jumping and Runner.instance_.tRex.jumping
      jumps += 1
      ui.setJumps jumps
    jumping = Runner.instance_.tRex.jumping

  checkJump = setInterval updateJumps, 1

  nextObstacle_ = undefined
  ui.setCactusJumped 0

  if started and not crashed
    rej new Error "Game started and not crashed"
  else if not started
    keyboard.up()
  else
    Runner.instance_.restart()

  return yield co ->
    new Promise (res) ->
      checker = setInterval ->
        if Runner.instance_.crashed
          clearInterval checker
          clearInterval checkJump
          res [cactusJumped, Runner.instance_.distanceRan, jumps]
      , 100
