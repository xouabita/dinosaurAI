// dinosaurAI
// =========
//
// Help a T-Rex to jump cactus thanks to neural network and genetic algorithms

// Constants
// ---------

// Some constants helpers
const instance        = Runner.instance_
const {tRex, horizon} = instance
const REFRESH         = 50




// Game informations
// -----------------
//
// In this part of the code, we get all the informations about the game.

// Get the next obstacle. Return undefined if there is no next obstacle.
window.getNextObstacle = function getNextObstacle() {

  const {obstacles} = horizon

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
const updateSpeed    = setInterval(() => speed    = getSpeed(), REFRESH)
const updateDistance = setInterval(() => distance = getDistance(), REFRESH)
const updateHeight   = setInterval(() => height   = getHeight(), REFRESH)




// UI
// --
//
// Display all the informations we currently got about the game.

// Helper function to create div
const elm = () => document.createElement('div')

// Global object which represent the UI
const UI = {
  speed: elm(),
  distance: elm(),
  height: elm()
}

// Patch the game to display the UI
function patchGame() {
  const game = elm()
  const menu = elm()

  game.id = "game"
  menu.id = "menu"

  document.body.appendChild(game)
  document.body.appendChild(menu)

  game.appendChild(document.getElementById('main-frame-error'))
  game.style.display = menu.style.display = 'inline-block'

  game.style.width = '66%'
  menu.style.width = '33%'
  menu.style.verticalAlign = 'top'

  for (let k in UI)
    menu.appendChild(UI[k])
}

// Function which update the UI with the current infos
function updateUI() {
  const setItem = (elt, val) => UI[elt].innerHTML = val

  setItem('speed', `Speed: ${speed}`)
  setItem('distance', `Distance: ${distance}`)
  setItem('height', `Height: ${height}`)
}

patchGame()
const constantlyUpdateUI = setInterval(updateUI, REFRESH)
