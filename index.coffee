keyboard = require './keyboard'
game     = require './game'

setInterval ->
  if game.getDistance() < 70
    keyboard.up()
, 25
