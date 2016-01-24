_  = require 'lodash'
co = require 'co'
ui = require './ui'

game     = require './game'
keyboard = require './keyboard'

{ Network, Architect } = require 'synaptic'

# Constants variables
GENOMES_NB = 12

testGenome = co.wrap (genome) ->

  # Ask neural network what action need to be done
  tester = setInterval ->

    # Fetch game inputs
    inputs = [
      game.getSpeed()
      game.getDistance()
      game.getHeight()
    ]

    # Apply to network
    [output] = genome.activate inputs
    ui.setActivation output

    # Use the result as game input
    if output < .45
      keyboard.down()
    else if output > .55
      keyboard.up()
  , 25

  # Wait for the game to finish and add results
  results = yield game.play()
  clearInterval tester

  return results

crossOver = (a, b) ->

  # 50% of swapping
  if Math.random() > .5 then [a, b] = [b, a]

  a = _.cloneDeep a

  cut = Math.round a.neurons.length * Math.random()
  a.neurons[k].bias = b.neurons[k].bias for k in [cut...b.neurons.length]

  return a

mutate = (net) ->
  res = _.cloneDeep net

  for k in [cut...res.neurons.length]

    if Math.random() > .3 then continue

    res.neurons[k].bias += (Math.random() - 0.5) * 3
    res.neurons[k].bias += Math.random() - 0.5

  cut = Math.round res.length * Math.random()
  for k in [cut...res.connections.length]

    if Math.random() > .3 then continue

    res.connections[k].weight += (Math.random() - 0.5) * 3
    res.connections[k].weight += Math.random() - 0.5

  return res

class Learner

  constructor: ->

    # init genomes
    @genomes = (new Architect.Perceptron 3, 4, 4, 1 for [0...GENOMES_NB])

  testGenomes: co.wrap ->

    # testGenome for each genomes
    for genome in @genomes
      [cactusJumped, distanceRan] = yield testGenome genome
      genome.cactusJumped = cactusJumped
      genome.distanceRan = distanceRan

  naturalSelection: ->

    # Select the two best genomes
    @genomes.sort (a, b) ->
      if a.cactusJumped > b.cactusJumped
        return 1
      else if a.cactusJumped < b.cactusJumped
        return -1
      else
        return 0

    [..., second, best] = @genomes
    @genomes = []

    # apply crossOver
    totalNb = GENOMES_NB
    crossOverNb = Math.round 2 * totalNb / 3
    mutationNb = totalNb - crossOverNb

    a = best.toJSON()
    b = second.toJSON()

    @genomes.push Network.fromJSON (crossOver a, b) for i in [0...crossOverNb]
    for i in [0...mutationNb]
      @genomes.push Network.fromJSON (mutate (crossOver a, b))

module.exports = Learner
