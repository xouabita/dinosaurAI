koa        = require 'koa'
r          = require 'koa-route'
bodyParser = require 'koa-bodyparser'
mkdirp     = require 'co-mkdirp'
fs         = require 'co-fs'

genomes =
  list: ->
    try
      files = yield fs.readdir './genomes'
    catch
      files = []
    @body = JSON.stringify files
  show: (name) ->
    data = yield fs.readFile "./genomes/#{name}"
    @body = data
  create: ->
    data = JSON.stringify @request.body
    yield mkdirp './genomes'
    filename = "#{new Date().toISOString().slice(0,19)}.json"
    yield fs.writeFile "./genomes/#{filename}", data
    @status = 200

app = koa()
app.use bodyParser()

# Deal with CORS
app.use (next) ->
  @set 'Access-Control-Allow-Origin', '*'
  @set 'Access-Control-Allow-Headers', 'X-Requested-With'
  @set 'Access-Control-Allow-Methods', 'POST,GET'
  yield next

app.use r.get '/genomes', genomes.list
app.use r.get '/genomes/:name', genomes.show
app.use r.post '/genomes', genomes.create

app.listen 3000
