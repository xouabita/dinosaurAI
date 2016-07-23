// Constants
// =========
//
// Some constants helpers

const instance  = Runner.instance_
const obstacles = Runner.instance_.horizon.obstacles
const {tRex}    = instance

// Game informations
// =================
//
// In this part of the code, we get all the informations about the game.

// Getters
// -------

// Get the next obstacle. Return undefined if there is no next obstacle.
function getNextObstacle() {
  if (!obstacles.length)
    return undefined

  if (obstacles[0].xPos > tRex.xPos + tRex.config.WIDTH)
    return obstacles[0]
  else
    return obstacles[1]
}

// Get the distance between the dinosaur and the next obstacle
function getDistance() {
  let obstacle = getNextObstacle()
  if (!obstacle)
    return +Infinity
  else
    return obstacle.xPos - tRex.xPos
}

// Get the height of the next obstacle
function getHeight() {
  let obstacle = getNextObstacle()
  if (!obstacle)
    return 0
  else
    return 150 - obstacle.yPos
}

// Get the speed of the T-Rex
function getSpeed() {
  return instance.currentSpeed
}

// Variables that contains informations about the game
let speed    = getSpeed()
let distance = getDistance()
let height   = getHeight()

// We constantly update informations about the game
const updateSpeed    = setInterval(() => speed    = getSpeed(), 200)
const updateDistance = setInterval(() => distance = getDistance(), 200)
const updateHeight   = setInterval(() => height   = getHeight(), 200)
