co = require 'co'

keyboard = require './keyboard'
game     = require './game'
Learner  = require './learner'
ui       = require './ui'

learner = new Learner

generation = 1
co ->
  loop
    ui.setGeneration generation
    yield learner.testGenomes()
    learner.naturalSelection()
    generation += 1

ui.patchPage()
