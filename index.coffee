co = require 'co'

window.keyboard = require './keyboard'
game     = require './game'
Learner  = require './learner'

learner = new Learner

co ->
  loop
    yield learner.testGenomes()
    learner.naturalSelection()
