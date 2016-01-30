UI =
  cactusJumped: document.createElement 'div'
  jumps: document.createElement 'div'
  speed: document.createElement 'div'
  distance: document.createElement 'div'
  height: document.createElement 'div'
  activation: document.createElement 'div'
  generation: document.createElement 'div'
  genome: document.createElement 'div'

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
    @cactusJumped, @jumps, @speed, @distance, @height, @activation,
    @generation, @genome
  ]
  menu.appendChild elt for elt in elements

  toggleAutoSave = document.createElement 'input'
  toggleAutoSave.type = 'checkbox'
  toggleAutoSave.checked = yes
  toggleAutoSave.style.opacity = 1
  toggleAutoSave.onclick = ->
    console.log 'click'
    learner.toggleAutoSave()

  label = document.createElement 'label'
  label.innerHTML = 'Auto Save'
  label.insertBefore toggleAutoSave, label.firstChild

  menu.appendChild label

UI.setItem = (elt, val) -> @[elt].innerHTML = val

UI.setDistance = (val) -> @setItem 'distance', "Distance: #{val}"
UI.setSpeed = (val) -> @setItem 'speed', "Speed: #{val}"
UI.setHeight = (val) -> @setItem 'height', "Height: #{val}"
UI.setActivation = (val) -> @setItem 'activation', "Activation: #{val}"
UI.setGeneration = (val) -> @setItem 'generation', "Generation: #{val}"
UI.setCactusJumped = (val) ->
  @setItem 'cactusJumped', "Cactus Jumped: #{val}"
UI.setGenome = (val) -> @setItem 'genome', "Genome: #{val}/12"
UI.setJumps = (val) -> @setItem 'jumps', "Jumps: #{val}"

module.exports = UI
