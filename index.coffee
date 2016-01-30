co = require 'co'

keyboard = require './keyboard'
game     = require './game'
Learner  = require './learner'
ui       = require './ui'

window.learner = new Learner

generation = 1
co ->
  loop
    ui.setGeneration generation
    yield learner.testGenomes()
    yield learner.naturalSelection()
    generation += 1

ui.patchPage()

# Fix the game
setInterval ->
  Runner.instance_.tRex.xPos = 21
, 2000
