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

  for k in [0...res.neurons.length]

    if Math.random() > .3 then continue

    res.neurons[k].bias += (Math.random() - 0.5) * 3
    res.neurons[k].bias += Math.random() - 0.5

  for k in [0...res.connections.length]

    if Math.random() > .3 then continue

    res.connections[k].weight += (Math.random() - 0.5) * 3
    res.connections[k].weight += Math.random() - 0.5

  return res

class Learner

  constructor: ->

    # init genomes
    @genomes  = (new Architect.Perceptron 3, 4, 4, 1 for [0...GENOMES_NB])
    @autosave = yes

  testGenomes: co.wrap ->

    # testGenome for each genomes
    for genome, i in @genomes
      ui.setGenome i + 1
      [cactusJumped, distanceRan, jumps] = yield testGenome genome
      console.log cactusJumped
      genome.fitness =
        if jumps is 0 then -Infinity
        else cactusJumped * cactusJumped / jumps
      console.log genome.fitness

  toggleAutoSave: -> @autosave = not @autosave

  naturalSelection: co.wrap ->

    # if autosave, then post the data
    if @autosave
      data = JSON.stringify @genomes
      try
        yield fetch 'http://localhost:3000/genomes',
          method: 'POST'
          headers:
            'Accept': 'application/json'
            'Content-Type': 'application/json'
          body: data
      catch
        console.log "Cannot reach server. Check your server..."

    # Select the two best genomes
    @genomes.sort (a, b) ->
      if a.fitness > b.fitness
        return 1
      else if a.fitness < b.fitness
        return -1
      else
        return 0

    # Classify the tested genomes by the fitness
    buckets = []
    bucketIndex = 0
    buckets[0] = [@genomes.shift()]
    for genome in @genomes
      if buckets[bucketIndex][0].fitness is genome.fitness
        buckets[bucketIndex].push genome
      else
        bucketIndex += 1
        buckets[bucketIndex] = [genome]

    # fill selection array with more probability for genome with more fitness
    # to be selected
    multiplier = 1
    selection  = []
    for genomes in buckets
      for genome in genomes
        for i in [0...multiplier]
          selection.push genome
      multiplier *= 2

    @genomes = []

    # apply crossOver
    totalNb = GENOMES_NB
    crossOverNb = Math.round 2 * totalNb / 3
    mutationNb = totalNb - crossOverNb

    for i in [0...crossOverNb]
      a = (_.sample selection).toJSON()
      b = (_.sample selection).toJSON()
      @genomes.push Network.fromJSON crossOver a, b

    for i in [0...mutationNb]
      bestGenome = _.sample buckets[buckets.length - 1]
      @genomes.push Network.fromJSON mutate bestGenome.toJSON()

module.exports = Learner
