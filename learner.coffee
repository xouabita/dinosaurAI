_  = require 'lodash'
co = require 'co'

game     = require './game'
keyboard = require './keyboard'

{ Architect, Network } = require 'synaptic'

# Constants variables
GENOMES_NB = 8
SELECTION = 2

# Extract neurons from a Perceptron
getNeurons = (perceptron) ->
  {input, hidden, output} = perceptron.layers
  layers = [input, hidden..., output]
  neurons = []
  for layer in layers
    neurons.push neuron for neuron in layer.list
  console.log neurons

# Set the neurons in a Perceptron
setNeurons = (perceptron, neurons) ->
  {input, hidden, output} = perceptron.layers
  input.list  = neurons.shift()
  output.list = neurons.pop()

  for layer in hidden
    list = []
    for neuron in layer.list
      list.push neurons.shift()
    layer.list = list

testGenome = co.wrap (genome) ->

  # Ask neural network what action need to be done
  setInterval ->

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
  return yield game.play()

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

  {neurons} = res
  cut = Math.round neurons.length * Math.random()
  for k in [cut...neurons.length]
    neurons[k].bias = neurons[k].bias * (Math.random() - 0.5) * 3

  return res

class Learner

  constructor: ->

    # init genomes
    @genomes = (new Architect.Perceptron 3, 4, 4, 1 for i in [0...GENOMES_NB])

  testGenomes: co.wrap ->

    # testGenome for each genomes
    for genome in @genomes
      [cactusJumped, distanceRan] = yield testGenome genome
      console.log cactusJumped
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

    @genomes.push (crossOver best, second) for i in [0...crossOverNb]
    @genomes.push (mutate best) for i in [0...mutationNb]

module.exports = Learner
