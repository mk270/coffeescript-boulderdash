
timestamp = () -> new Date().getTime()

KEY = { ENTER: 13, ESC: 27, SPACE: 32, PAGEUP: 33, PAGEDOWN: 34, LEFT: 37, UP: 38, RIGHT: 39, DOWN: 40 }

Dom = BD.Dom

DIR  = BD.DIR

Game = BD.Game

moving =
  dir:      DIR.NONE
  lastXDir: DIR.NONE
  up: false
  down: false
  left: false
  right: false
  grab: false
  startUp: () -> @up = true; @dir = DIR.UP
  startDown:  () -> @down  = true; @dir = DIR.DOWN 
  startLeft:  () -> @left  = true; @dir = DIR.LEFT;  @lastXDir = DIR.LEFT  
  startRight: () -> @right = true; @dir = DIR.RIGHT; @lastXDir = DIR.RIGHT 
  startGrab:  () -> @grab  = true 
  stopUp:     () -> @up    = false; @dir = if @dir == DIR.UP then @where() else @dir 
  stopDown:   () -> @down  = false; @dir = if @dir == DIR.DOWN then @where() else @dir 
  stopLeft:   () -> @left  = false; @dir = if @dir == DIR.LEFT then @where() else @dir 
  stopRight:  () -> @right = false; @dir = if @dir == DIR.RIGHT then @where() else @dir 
  stopGrab:   () -> @grab  = false 
  where: () ->
    if @up
      DIR.UP
    else if @down
      DIR.DOWN
    else if @left
      DIR.LEFT
    else if @right
      DIR.RIGHT


  #=========================================================================
  # GAME LOOP
  #=========================================================================

game   = new Game(moving)       # the boulderdash game logic (rendering independent)
render = new BD.Render(game, moving) # the boulderdash game renderer
stats  = new Stats()      # the FPS counter widget

  #-------------------------------------------------------------------------

run = () ->
  last = timestamp()
  dt = 0
  gdt = 0
  rdt = 0
  frame = () ->
    now = timestamp()
    dt  = Math.min(1, (now - last) / 1000) # using requestAnimationFrame have to be able to handle large delta's caused when it 'hibernates' in a background or non-visible tab
    gdt = gdt + dt
    while gdt > game.step
      gdt = gdt - game.step
      game.update()
    
    rdt = rdt + dt
    if rdt > render.step
      rdt = rdt - render.step
      render.update()
    
    stats.update()
    last = now
    requestAnimationFrame(frame, render.canvas)
  
  load((sprites) ->
    render.reset(sprites) # reset the canvas renderer with the loaded sprites <IMG>
    game.reset()          # reset the game
    addEvents()           # attach keydown and resize event handlers
    showStats()           # initialize FPS counter
    frame()               #  ... and start the first frame !
  )

load = (cb) ->
  sprites = document.createElement('img')
  sprites.addEventListener('load', (() -> cb(sprites)), false)
  sprites.src = 'images/sprites.png'

showStats = () ->
  stats.domElement.id = 'stats'
  Dom.get('boulderdash').appendChild(stats.domElement)

addEvents = () ->
  document.addEventListener('keydown', keydown, false)
  document.addEventListener('keyup',   keyup,   false)
  window.addEventListener('resize', (() -> render.resize()), false)
  Dom.get('prev').addEventListener('click', (() -> game.prev()), false)
  Dom.get('next').addEventListener('click', (() -> game.next()), false)

keydown = (ev) ->
  handled = true
  switch ev.keyCode
    when KEY.UP then moving.startUp()
    when KEY.DOWN then       moving.startDown()
    when KEY.LEFT then       moving.startLeft()
    when KEY.RIGHT then      moving.startRight()
    when KEY.ESC then        game.reset()
    when KEY.PAGEUP then     game.prev()
    when KEY.PAGEDOWN then   game.next()
    when KEY.SPACE then      moving.startGrab()
    else handled = false
  if handled
    ev.preventDefault() # prevent arrow keys from scrolling the page (supported in IE9+ and all other browsers)

keyup = (ev) ->
  handled = true
  switch ev.keyCode
    when KEY.UP then    moving.stopUp()
    when KEY.DOWN then  moving.stopDown()
    when KEY.LEFT then  moving.stopLeft()
    when KEY.RIGHT then moving.stopRight()
    when KEY.SPACE then moving.stopGrab()
    else handled = false
  if handled
    ev.preventDefault() # prevent arrow keys from scrolling the page (supported in IE9+ and all other browsers)
    
  #---------------------------------------------------------------------------

run.game   = game   # debug access using Boulderdash.game
run.render = render # debug access using Boulderdash.render

run()


