nextObstacle_ = undefined
{ tRex }      = Runner.instance_
xDino_        = tRex.xPos + tRex.config.WIDTH

# Function to update the next obstacle
updateNextObstacle_ = ->
  obstacles = Runner.instance_.horizon.obstacles
  if obstacles.length is 0
    nextObstacle_ = undefined
  else
    nextObstacle_ =
      if obstacles[0].xPos > xDino_ then obstacles[0]
      else obstacles[1]

# Update the next obstacle every 50ms
setInterval updateNextObstacle_, 50

module.exports.getDistance = ->
  if nextObstacle_ then nextObstacle_.xPos - xDino_
  else 600 - xDino_

module.exports.getHeight = ->
  if nextObstacle_ then 150 - nextObstacle_.yPos
  else 0

module.exports.getSpeed = -> Runner.instance_.currentSpeed
