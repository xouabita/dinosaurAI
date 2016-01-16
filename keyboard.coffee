# inspired by: http://kiq.li/1FvN

keyCodes =
  DOWN: 40
  UP: 38

keydown = (k) ->

  type  = "keydown"
  event = document.createEvent 'KeyboardEvent'

  # Chromium hack
  Object.defineProperty event, 'keyCode', get: -> @keyCodeVal
  Object.defineProperty event, 'which', get: -> @keyCodeVal

  event.initKeyboardEvent type, yes, yes, document, no, no, no, no, k, k
  event.keyCodeVal = k

  document.dispatchEvent event

module.exports =
  up: -> keydown keyCodes.UP
  down: -> keydown keyCodes.DOWN
