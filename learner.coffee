_  = require 'lodash'
co = require 'co'

game     = require './game'
keyboard = require './keyboard'

{ Network, Layer } = require 'synaptic'

# Constants variables
GENOMES_NB = 4
SELECTION = 2

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
    output = genome.activate inputs

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
  aNeurons = a.neurons
  bNeurons = b.neurons

  cut = Math.round aNeurons.length * Math.random()
  aNeurons[k].bias = bNeurons[k].bias for k in [cut...bNeurons.length]

  return a

mutate = (net) ->
  res = _.cloneDeep net

  cut = Math.round res.length * Math.random()
  for k in [cut...res.neurons.length]
    res.neurons[k].bias += res.neurons[k].bias * Math.random() * 3
    res.neurons[k].bias += Math.random()

  cut = Math.round res.length * Math.random()
  for k in [cut...res.connections.length]
    res.connections[k].weight += res.connections[k].weight * Math.random() * 3
    res.connections[k].weight += Math.random()

  return res

class Learner

  constructor: ->

    # init genomes
    @genomes = []
    for i in [0...GENOMES_NB]
      @genomes.push new Network
        input: new Layer 3
        hidden: [new Layer 4, new Layer 4]
        output: new Layer 1

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
      else if a.distanceRan > b.distanceRan
        return 1
      else if a.distanceRan < b.distanceRan
        return -1
      else
        return 0

    [..., second, best] = @genomes
    @genomes = [best, second]

    # apply crossOver
    totalNb = GENOMES_NB - 2
    crossOverNb = 2 * totalNb / 3
    mutationNb = totalNb - crossOverNb

    a = best.toJSON()
    b = second.toJSON()

    @genomes.push Network.fromJSON (crossOver a, b) for i in [0...crossOverNb]
    for i in [0...mutationNb]
      @genomes.push Network.fromJSON (mutate (crossOver a, b))

module.exports = Learner
