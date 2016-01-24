UI =
  cactusJumped: document.createElement 'div'
  speed: document.createElement 'div'
  distance: document.createElement 'div'
  height: document.createElement 'div'
  activation: document.createElement 'div'
  generation: document.createElement 'div'

UI.patchPage = ->
  game = document.createElement 'div'
  game.id = 'game'

  menu = document.createElement 'div'
  menu.id = 'menu'

  document.body.appendChild game
  document.body.appendChild menu

  game.appendChild (document.getElementById 'main-frame-error')

  game.style.display = 'inline-block'
  menu.style.display = 'inline-block'

  game.style.width = "66%"
  menu.style.width = "33%"
  menu.style.verticalAlign = "top"

  elements = [
    @cactusJumped, @speed, @distance, @height, @activation, @generation
  ]
  menu.appendChild elt for elt in elements

UI.setItem = (elt, val) -> @[elt].innerHTML = val

UI.setDistance = (val) -> @setItem 'distance', "Distance: #{val}"
UI.setSpeed = (val) -> @setItem 'speed', "Speed: #{val}"
UI.setHeight = (val) -> @setItem 'height', "Height: #{val}"
UI.setActivation = (val) -> @setItem 'activation', "Activation: #{val}"
UI.setGeneration = (val) -> @setItem 'generation', "Generation: #{val}"
UI.setCactusJumped = (val) ->
  @setItem 'cactusJumped', "Cactus Jumped: #{val}"

module.exports = UI
