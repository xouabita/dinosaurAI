co = require 'co'

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
  if oldObstacle isnt nextObstacle_ then cactusJumped += 1

# Update the next obstacle every 50ms
setInterval updateNextObstacle_, 50

module.exports.getDistance = ->
  if nextObstacle_ then nextObstacle_.xPos - xDino_
  else 600 - xDino_

module.exports.getHeight = ->
  if nextObstacle_ then 150 - nextObstacle_.yPos
  else 0

module.exports.getSpeed = -> Runner.instance_.currentSpeed * 100

module.exports.play = co.wrap ->
  {started, crashed} = Runner.instance_

  # reset cactusJumped
  cactusJumped = 0

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
          res [cactusJumped - 1, Runner.instance_.distanceRan]
      , 100
