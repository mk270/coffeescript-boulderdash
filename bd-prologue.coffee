#timestamp = () -> new Date().getTime()
#random = () -> (min + (Math.random() * (max - min)))
#randomInt = () -> Math.floor(random(min,max))

#randomChoice = (choices) ->
#  choices[Math.round(random(0, choices.length-1))]

# http://paulirish.com/2011/requestanimationframe-for-smart-animating/
if not window.requestAnimationFrame
  window.requestAnimationFrame = (window.webkitRequestAnimationFrame or
                                   window.mozRequestAnimationFrame or 
                                   window.oRequestAnimationFrame or
                                   window.msRequestAnimationFrame or
                                   (callback, element) -> window.setTimeout(callback, 1000 / 60))

Object.prototype.extend = (source) ->
  for property of source
    if source.hasOwnProperty(property)
      this[property] = source[property]
  this
