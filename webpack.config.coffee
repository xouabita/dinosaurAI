module.exports =
  entry: "./index.coffee"
  output:
    path: __dirname + '/dist/'
    filename: 'app.js'
  module:
    loaders: [
      test: /\.coffee$/, loader: 'coffee'
    ]
  resolve:
    extensions: ['', '.coffee', '.js']
