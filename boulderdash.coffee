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

array_of_tuples = (l) ->
  tmp = []
  for i in l
    [k, v] = i
    tmp[k] = v
  tmp

Dom = 
  get: (id) -> if (id instanceof HTMLElement)
                  id
                else 
                  document.getElementById(id)
  set: (id, html) -> Dom.get(id).innerHTML = html
  disable: (id, enabled) -> Dom.get(id).className = if enabled then "disabled" else ""

DIR =
  UP: 0
  UPRIGHT: 1
  RIGHT: 2
  DOWNRIGHT: 3
  DOWN: 4
  DOWNLEFT: 5
  LEFT: 6
  UPLEFT: 7

DIRX = [     0,          1,        1,            1,       0,          -1,      -1,        -1 ]
DIRY = [    -1,         -1,        0,            1,       1,           1,       0,        -1 ]

Entity =
  SPACE:
    code: 0x00
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 0
      y: 6  
    flash: 
      x: 4
      y: 0 
  DIRT:              
    code: 0x01
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 1
      y: 7                  
  BRICKWALL:         
    code: 0x02
    rounded: true
    explodable: true
    vulnerable: false
    sprite: 
      x: 3
      y: 6                  
  MAGICWALL:         
    code: 0x03
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 4
      y: 6
      f: 4
      fps: 20  
  PREOUTBOX:         
    code: 0x04
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 1
      y: 6                  
  OUTBOX:            
    code: 0x05
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 1
      y: 6
      f: 2
      fps: 4   
  STEELWALL:         
    code: 0x07
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 1
      y: 6                  
  FIREFLY1:          
    code: 0x08
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 9
      f: 8
      fps: 20  
  FIREFLY2:          
    code: 0x09
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 9
      f: 8
      fps: 20  
  FIREFLY3:          
    code: 0x0A
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 9
      f: 8
      fps: 20  
  FIREFLY4:          
    code: 0x0B
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 9
      f: 8
      fps: 20  
  BOULDER:           
    code: 0x10
    rounded: true
    explodable: true
    vulnerable: false
    sprite: 
      x: 0
      y: 7                  
  BOULDERFALLING:    
    code: 0x12
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 0
      y: 7                  
  DIAMOND:           
    code: 0x14
    rounded: true
    explodable: true
    vulnerable: false
    sprite: 
      x: 0
      y: 10
      f: 8
      fps: 20  
  DIAMONDFALLING:    
    code: 0x16
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 0
      y: 10
      f: 8
      fps: 20  
  EXPLODETOSPACE0:   
    code: 0x1B
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 3
      y: 7                  
  EXPLODETOSPACE1:   
    code: 0x1C
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 4
      y: 7                  
  EXPLODETOSPACE2:   
    code: 0x1D
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 5
      y: 7                  
  EXPLODETOSPACE3:   
    code: 0x1E
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 4
      y: 7                  
  EXPLODETOSPACE4:   
    code: 0x1F
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 3
      y: 7                  
  EXPLODETODIAMOND0: 
    code: 0x20
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 3
      y: 7                  
  EXPLODETODIAMOND1: 
    code: 0x21
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 4
      y: 7                  
  EXPLODETODIAMOND2: 
    code: 0x22
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 5
      y: 7                  
  EXPLODETODIAMOND3: 
    code: 0x23
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 4
      y: 7                  
  EXPLODETODIAMOND4: 
    code: 0x24
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 3
      y: 7                  
  PREROCKFORD1:      
    code: 0x25
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 1
      y: 6
      f: 2
      fps: 4   
  PREROCKFORD2:      
    code: 0x26
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 1
      y: 0                  
  PREROCKFORD3:      
    code: 0x27
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 2
      y: 0                  
  PREROCKFORD4:      
    code: 0x28
    rounded: false
    explodable: false
    vulnerable: false
    sprite: 
      x: 3
      y: 0                  
  BUTTERFLY1:        
    code: 0x30
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 11
      f: 8
      fps: 20  
  BUTTERFLY2:        
    code: 0x31
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 11
      f: 8
      fps: 20  
  BUTTERFLY3:        
    code: 0x32
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 11
      f: 8
      fps: 20  
  BUTTERFLY4:        
    code: 0x33
    rounded: false
    explodable: true
    vulnerable: true
    sprite: 
      x: 0
      y: 11
      f: 8
      fps: 20  
  ROCKFORD:          
    code: 0x38
    rounded: false
    explodable: true
    vulnerable: true
    sprite:
      x: 0
      y: 0                # standing still
    left: 
      x: 0
      y: 4
      f: 8
      fps: 20  # running left
    right: 
      x: 0
      y: 5
      f: 8
      fps: 20  # running right
    blink: 
      x: 0
      y: 1
      f: 8
      fps: 20  # blinking
    tap: 
      x: 0
      y: 2
      f: 8
      fps: 20  # foot tapping
    blinktap: 
      x: 0
      y: 3
      f: 8
      fps: 20  # foot tapping and blinking
  AMOEBA:            
    code: 0x3A
    rounded: false
    explodable: true
    vulnerable: false
    sprite: 
      x: 0
      y: 8
      f: 8
      fps: 20 

for key of Entity
    Entity[key].name = key
    Entity[Entity[key].code] = Entity[key]

rotateLeft = (dir) -> (dir-2) + (if dir < 2 then 8 else 0)
rotateRight = (dir) -> (dir+2) - (if dir > 5 then 8 else 0)
horizontal = (dir) -> (dir is DIR.LEFT) or (dir is DIR.RIGHT)
vertical = (dir) -> (dir is DIR.UP) or (dir is DIR.DOWN)
Point = (x, y, dir) ->
  @x = x + (DIRX[dir] || 0)
  @y = y + (DIRY[dir] || 0)
isFirefly = (o) -> (Entity.FIREFLY1.code <= o.code) and (o.code <= Entity.FIREFLY4.code)
isButterfly = (o) -> (Entity.BUTTERFLY1.code <= o.code) and (o.code <= Entity.BUTTERFLY4.code)

Sequences =
  FIREFLIES: array_of_tuples( [
    [DIR.LEFT,  Entity.FIREFLY1],
    [DIR.UP,    Entity.FIREFLY2],
    [DIR.RIGHT, Entity.FIREFLY3],
    [DIR.DOWN,  Entity.FIREFLY4]
  ] )
  BUTTERFLIES: array_of_tuples( [
    [DIR.LEFT,  Entity.BUTTERFLY1],
    [DIR.UP,    Entity.BUTTERFLY2],
    [DIR.RIGHT, Entity.BUTTERFLY3],
    [DIR.DOWN,  Entity.BUTTERFLY4]
  ] )
  PREROCKFORDS: [ Entity.PREROCKFORD1, Entity.PREROCKFORD2, Entity.PREROCKFORD3, Entity.PREROCKFORD, Entity.ROCKFORD ]
  EXPLODETOSPACE: [ Entity.EXPLODETOSPACE0, Entity.EXPLODETOSPACE1, Entity.EXPLODETOSPACE2, Entity.EXPLODETOSPACE3, Entity.EXPLODETOSPACE4, Entity.SPACE ]
  EXPLODETODIAMOND: [ Entity.EXPLODETODIAMOND0, Entity.EXPLODETODIAMOND1, Entity.EXPLODETODIAMOND2, Entity.EXPLODETODIAMOND3, Entity.EXPLODETODIAMOND4, Entity.DIAMOND ]

class Render
  constructor: (game, moving) ->
    @game = game;
    @moving = moving;
    game.subscribe('level', @onChangeLevel,   this)
    game.subscribe('score', @invalidateScore, this)
    game.subscribe('timer', @invalidateScore, this)
    game.subscribe('flash', @invalidateCave,  this)
    game.subscribe('cell',  @invalidateCell,  this)

  reset: (sprites) ->
    @canvas = Dom.get('canvas')
    @ctx = @canvas.getContext('2d')
    @sprites = sprites
    @fps = 30
    @step = 1 / @fps
    @frame = 0
    @ctxSprites = document.createElement('canvas').getContext('2d')
    @ctxSprites.canvas.width = @sprites.width
    @ctxSprites.canvas.height = @sprites.height
    @ctxSprites.drawImage(this.sprites, 
                          0, 0, @sprites.width, @sprites.height,
                          0, 0, @sprites.width, @sprites.height)
    @resize()

  onChangeLevel: (info) ->
    @description(info.description)
    @colors(info.color1, info.color2)
    @invalidateCave()
    @invalidateScore()
    Dom.disable('prev', info.index is 0)
    Dom.disable('next', info.index is CAVES.length - 1)

  invalid:
    score: true
    cave: true

  invalidateScore: () -> @invalid.score = true
  invalidateCave: () -> @invalid.cave = true
  invalidateCell: (cell) -> cell.invalid = true
  validateScore: () -> @invalid.score = false
  validateCave: () -> @invalid.cave = false
  validateCell: (cell) -> cell.invalid = false

  update: () ->
    @frame++
    @score()
    @game.eachCell(@cell, this)
    @validateCave()

  score: () ->
    @ctx.fillStyle = 'black'
    @ctx.fillRect(0, 0, @canvas.width, @dy)
    @number(3, @game.diamonds.needed, 2, true)
    @letter(5, '$')
    @number(6, @game.diamonds.collected >= (if @game.diamonds.needed then @game.diamonds.extra else @game.diamonds.value), 2)
    @number(12, @game.diamonds.collected, 2, true)
    @number(25, @game.timer, 3)
    @number(31, @game.score, 6)
    @validateScore()

  number: (x, n, width, yellow) ->
    word = ("000000" + n.toString()).slice(-(width or 2))
    @letter(x + i, word[i], yellow) for i in [0 .. word.length-1]

  letter: (x, c, yellow) ->
    @ctx.drawImage(@ctxSprites.canvas,
                   (if yellow then 9 else 8) * 32,
                   (c.charCodeAt(0) - 32) * 16,
                   32, 16, (x * @dx), 0, @dx, @dy - 4)

  cell: (cell) ->
    object = cell.object
    sprite = object.sprite
    if @invalid.cave or cell.invalid or (sprite.f > 1) or (object is Entity.ROCKFORD)
      if object is Entity.ROCKFORD
        @rockford(cell)
      else 
        if (object is Entity.SPACE) and (@game.flash > @game.frame)
          sprite = Entity.SPACE.flash
        else if object is Entity.MAGICWALL and not @game.magic.active
          sprite = Entity.BRICKWALL.sprite
        @sprite(sprite, cell)
        @validateCell(cell)
        null

  sprite: (sprite, cell) ->
    f = if sprite.f
          Math.floor((sprite.fps/@fps) * @frame) % sprite.f
        else
          0
    @ctx.drawImage(@ctxSprites.canvas, (sprite.x + f) * 32, sprite.y * 32, 32, 32, cell.p.x * @dx, (1 + cell.p.y) * @dy, @dx, @dy)

  rockford: (cell) ->
    if @moving.dir is DIR.LEFT or vertical(@moving.dir) and @moving.lastXDir is DIR.LEFT
      @sprite(Entity.ROCKFORD.left, cell)
    else if @moving.dir is DIR.RIGHT or vertical(@moving.dir) and @moving.lastXDir is DIR.RIGHT
      @sprite(Entity.ROCKFORD.right, cell)
    else if @game.idle.blink and not @game.idle.tap
      @sprite(Entity.ROCKFORD.blink, cell)
    else if not @game.idle.blink and @game.idle.tap
      @sprite(Entity.ROCKFORD.tap, cell)
    else if @game.idle.blink and @game.idle.tap
      @sprite(Entity.ROCKFORD.blinktap, cell)
    else
      @sprite(Entity.ROCKFORD.sprite, cell)

  description: (msg) -> Dom.set('description', msg)

  colors: (color1, color2) ->
    @ctxSprites.drawImage(@sprites, 
                          0, 0, @sprites.width, @sprites.height, 
                          0, 0, @sprites.width, @sprites.height)
    pixels = @ctxSprites.getImageData(0, 0, @sprites.width, @sprites.height);

    for y in [0 .. @sprites.height-1]
      for x in [0 .. @sprites.width-1]
        n = (y * @sprites.width * 4) + (x * 4)
        color = (pixels.data[n + 0] << 16) + 
                (pixels.data[n + 1] << 8) +
                (pixels.data[n + 2] << 0)
        if (color is 0x3F3F3F) # mostly the metalic wall
          pixels.data[n + 0] = (color2 >> 16) & 0xFF
          pixels.data[n + 1] = (color2 >> 8)  & 0xFF
          pixels.data[n + 2] = (color2 >> 0)  & 0xFF
        else if (color is 0xA52A00) # mostly the dirt
          pixels.data[n + 0] = (color1 >> 16) & 0xFF
          pixels.data[n + 1] = (color1 >> 8)  & 0xFF
          pixels.data[n + 2] = (color1 >> 0)  & 0xFF

    @ctxSprites.putImageData(pixels, 0, 0);

  resize: () ->
    visibleArea =
      w: 40
      h: 23
    @canvas.width = @canvas.clientWidth
    @canvas.height = @canvas.clientHeight
    @dx = @canvas.width / visibleArea.w
    @dy = @canvas.height / visibleArea.h
    @invalidateScore()
    @invalidateCave()
 
# known physics bugs:
#  rocks are too eager to explode flies, partic in the "just started to fall" state and rolloffs
#  you can touch flies - the check for explode is in the wrong place / depends on fly movement
#  boulders on enchanted walls seem to be jammed in falling state

random = (min, max) -> (min + (Math.random() * (max - min)))
randomInt = (min, max) -> Math.floor(random(min,max))
randomChoice = (choices) ->
  choices[Math.round(random(0, choices.length-1))]

class Game
  constructor: (moving, options) ->
    @options = options or {}
    @storage = window.localStorage or {}
    @score   = 0
    @moving  = moving

  reset: (n) ->
    n = Math.min(CAVES.length-1, Math.max(0, ((if typeof n is 'number' then n else @storage.level) or 0)))
    @index    = @storage.level = n        # cave index
    @cave     = CAVES[@index]             # cave definition
    @width    = @cave.width               # cave cell width
    @height   = @cave.height              # cave cell height
    @cells    = []                            # will be built up into 2 dimensional array below
    @frame    = 0                             # game frame counter starts at zero
    @fps      = 10                            # how many game frames per second
    @step     = 1/@fps                    # how long is each game frame (in seconds)
    @birth    = 2*@fps                    # in which frame is rockford born ?
    @timer    = @cave.caveTime            # seconds allowed to complete this cave 
    @idle     = { blink: false, tap: false }  # is rockford showing any idle animation ?
    @flash    = false                         # trigger white flash when rockford has collected enought diamonds
    @won      = false                         # set to true when rockford enters the outbox
    @diamonds =
      collected: 0
      needed: @cave.diamondsNeeded
      value:  @cave.initialDiamondValue
      extra:  @cave.extraDiamondValue
    @amoeba =
      max: @cave.amoebaMaxSize,
      slow: @cave.amoebaSlowGrowthTime/@step
    @magic =
      active: false
      time: @cave.magicWallMillingTime/@step

    for y in [0 .. @height-1]
      for x in [0 .. @width-1]
        @cells[x]    = @cells[x] or [];
        @cells[x][y] =
          p: new Point(x,y)
          frame: 0
          object: Entity[@cave.map[x][y]]
    @publish('level', @cave)

  prev: () -> if (@index > 0)
                @reset(@index-1)
  next: () -> if (@index < CAVES.length-1)
                @reset(@index+1)

  get: (p,dir) -> @cells[p.x + (DIRX[dir] or 0)][p.y + (DIRY[dir] or 0)].object
    
  set: (p,o,dir) ->
    cell = @cells[p.x + (DIRX[dir] or 0)][p.y + (DIRY[dir] or 0)]
    cell.object = o
    cell.frame = @frame
    @publish('cell', cell)
    
  clear: (p,dir) -> @set(p,Entity.SPACE,dir)
  move: (p,dir,o) -> @clear(p); @set(p,o,dir)

  isempty:      (p,dir) -> @get(p,dir) is Entity.SPACE    
  isdirt:       (p,dir) -> @get(p,dir) is Entity.DIRT     
  isboulder:    (p,dir) -> @get(p,dir) is Entity.BOULDER  
  isrockford:   (p,dir) -> @get(p,dir) is Entity.ROCKFORD 
  isdiamond:    (p,dir) -> @get(p,dir) is Entity.DIAMOND  
  isamoeba:     (p,dir) -> @get(p,dir) is Entity.AMOEBA   
  ismagic:      (p,dir) -> @get(p,dir) is Entity.MAGICWALL
  isoutbox:     (p,dir) -> @get(p,dir) is Entity.OUTBOX   

  isfirefly:    (p,dir) -> isFirefly(@get(p,dir))
  isbutterfly:  (p,dir) -> isButterfly(@get(p,dir))
  isexplodable: (p,dir) -> @get(p,dir).explodable
  isvulnerable: (p,dir) -> @get(p,dir).vulnerable
  isrounded:    (p,dir) -> @get(p,dir).rounded

  isfallingdiamond: (p,dir) -> @get(p,dir) is Entity.DIAMONDFALLING
  isfallingboulder: (p,dir) -> @get(p,dir) is Entity.BOULDERFALLING

  eachCell: (fn, thisArg) ->
    for y in [0 .. @height-1]
      for x in [0 .. @width-1]
        fn.call(thisArg or this, @cells[x][y])

  update: () ->
    @beginFrame()
    @eachCell (cell) ->
      if cell.frame < @frame
        @entityDispatch(cell.object, cell.p, @moving.dir)
    @endFrame()
    
  subscribe: (event, callback, target) ->
    @subscribers = @subscribers or {}
    @subscribers[event] = @subscribers[event] or []
    @subscribers[event].push({ callback: callback, target: target })

  publish: (event) ->
    if @subscribers and @subscribers[event]
      subs = @subscribers[event];
      args = [].slice.call(arguments, 1)

      for n in [0 .. subs.length-1]
        sub = subs[n]
        sub.callback.apply(sub.target, args)

  decreaseTimer: (n) ->
    @timer = Math.max(0, @timer - (n or 1))
    @publish('timer', @timer)
    (@timer is 0)

  autoDecreaseTimer: () ->
    if (@frame > @birth) and ((@frame % @fps) is 0)
      @decreaseTimer(1)

  runOutTimer: () ->
    amount = Math.min(3, @timer)
    @increaseScore(amount);
    if @decreaseTimer(amount)
      @next()

  collectDiamond: () ->
    @diamonds.collected++
    @increaseScore(if @diamonds.collected > @diamonds.needed then @diamonds.extra else @diamonds.value)
    @publish('diamond', @diamonds)

  increaseScore: (n) ->
    @score += n;
    @publish('score', @score)

  flashWhenEnoughDiamondsCollected: () ->
    if (not @flash) and (@diamonds.collected >= @diamonds.needed)
      @flash = @frame + Math.round(@fps/5) # flash for 1/5th of a second 
    if @frame <= @flash
      @publish('flash')

  loseLevel: () -> @reset()
  winLevel: () -> @won = true

  beginFrame: () ->
    @frame++;
    @amoeba.size     = 0;
    @amoeba.enclosed = true;
    @idle = if @moving.dir
              {}
            else
              blink: if (randomInt(1,4) is 1) then (not @idle.blink) else @idle.blink
              tap:   if (randomInt(1,16) is 1) then (not @idle.tap) else @idle.tap

  endFrame: () ->
    if not @amoeba.dead
      if (@amoeba.enclosed)
        @amoeba.dead = Entity.DIAMOND
      else if @amoeba.size > @amoeba.max
        @amoeba.dead = Entity.BOULDER
      else if @amoeba.slow > 0
        @amoeba.slow--
    @magic.active = @magic.active and (--@magic.time > 0)
    @flashWhenEnoughDiamondsCollected()
    if @won
      @runOutTimer()
    else if (@frame - @foundRockford > (4 * @fps))
      @loseLevel()
    else
      @autoDecreaseTimer()

  updatePreRockford: (p, n) ->
    if @frame >= @birth
      @set(p, Sequences.PREROCKFORDS[n+1])

  updatePreOutbox: (p) ->
    if @diamonds.collected >= @diamonds.needed
        @set(p, Entity.OUTBOX)

  doGrab: (p, dir) ->
    if @isdirt(p, dir)
      @clear(p, dir)
    else if @isdiamond(p, dir) or @isfallingdiamond(p, dir)
      @clear(p, dir)
      @collectDiamond()
    else if horizontal(dir) and @isboulder(p, dir) 
      @push(p, dir)
    else
      null

  updateRockford: (p, dir) ->
    @foundRockford = @frame
    if @won
      null # do nothing -  dont let rockford move if he already found the outbox
    else if @timer is 0
      @explode(p)
    else if @moving.grab
      @doGrab(p, dir)
    else if @isempty(p, dir) or @isdirt(p, dir) 
      @move(p, dir, Entity.ROCKFORD)
    else if @isdiamond(p, dir) 
      @move(p, dir, Entity.ROCKFORD)
      @collectDiamond()
    else if horizontal(dir) and @isboulder(p, dir) 
      @push(p, dir)
    else if @isoutbox(p, dir) 
      @move(p, dir, Entity.ROCKFORD)
      @winLevel()

  updateRock: (p, rock) ->
    if @isempty(p, DIR.DOWN)
      @set(p, rock)
    else if @isrounded(p, DIR.DOWN) and @isempty(p, DIR.LEFT) and @isempty(p, DIR.DOWNLEFT)
      @move(p, DIR.LEFT, rock)
    else if @isrounded(p, DIR.DOWN) and @isempty(p, DIR.RIGHT) and @isempty(p, DIR.DOWNRIGHT)
      @move(p, DIR.RIGHT, rock)

  updateRockFalling: (p, rock, rockAtRest, convertedRock) ->
    if @isempty(p, DIR.DOWN)
      @move(p, DIR.DOWN, rock)
    else if @isvulnerable(p, DIR.DOWN)
      @explode_dir(p, DIR.DOWN)
    else if @ismagic(p, DIR.DOWN)
      @domagic(p, convertedRock)
    else if @isrounded(p, DIR.DOWN) and @isempty(p, DIR.LEFT) and @isempty(p, DIR.DOWNLEFT)
      @move(p, DIR.LEFT, rock)
    else if @isrounded(p, DIR.DOWN) and @isempty(p, DIR.RIGHT) and @isempty(p, DIR.DOWNRIGHT)
      @move(p, DIR.RIGHT, rock)
    else
      @set(p, rockAtRest)

  updateBoulder: (p) -> @updateRock(p, Entity.BOULDERFALLING)
  updateDiamond: (p) -> @updateRock(p, Entity.DIAMONDFALLING)
  updateBoulderFalling: (p) -> @updateRockFalling(p, Entity.BOULDERFALLING, Entity.BOULDER, Entity.DIAMOND)
  updateDiamondFalling: (p) -> @updateRockFalling(p, Entity.DIAMONDFALLING, Entity.DIAMOND, Entity.BOULDER)

  adjacent: (p, fn) ->
    dirs = [ DIR.UP, DIR.DOWN, DIR.LEFT, DIR.RIGHT ]

    rv = false
    for i in [0 .. dirs.length-1]
      if fn(p, dirs[i])
        rv = true
    rv

  updateFly: (p, dir, newdir, olddir, phases) ->
    self = this

    by_rockford = (p, d) -> self.isrockford(p, d)
    by_amoeba   = (p, d) -> self.isamoeba(p, d)

    if @adjacent(p, by_rockford) or @adjacent(p, by_amoeba)
      @explode(p)
      null
    else
      if @isempty(p, newdir)
        @move(p, newdir, phases[newdir])
      else if @isempty(p, dir)
        @move(p, dir, phases[dir])
      else
        @set(p, phases[olddir])
        
  updateFirefly: (p, dir)   -> @updateFly(p, dir, rotateLeft(dir), rotateRight(dir), Sequences.FIREFLIES)
  updateButterfly: (p, dir) -> @updateFly(p, dir, rotateRight(dir), rotateLeft(dir), Sequences.BUTTERFLIES)
  updateExplodeToSpace: (p, n) -> @set(p, Sequences.EXPLODETOSPACE[n+1])
  updateExplodeToDiamond: (p, n) -> @set(p, Sequences.EXPLODETODIAMOND[n+1])

  updateAmoeba: (p) ->
    if @amoeba.dead
      @set(p, @amoeba.dead)
    else
      self = this
      by_empty = (p, d) -> self.isempty(p, d)
      by_dirt  = (p, d) -> self.isdirt(p, d)
      @amoeba.size++
      if @adjacent(p, by_empty) or @adjacent(p, by_dirt)
        @amoeba.enclosed = false
      if @frame >= @birth
        grow = if @amoeba.slow
                 (randomInt(1, 128) < 4)
               else
                 (randomInt(1, 4) is 1)
        dir  = randomChoice([DIR.UP, DIR.DOWN, DIR.LEFT, DIR.RIGHT])
        if grow and (@isdirt(p, dir) or @isempty(p, dir))
          @set(p, Entity.AMOEBA, dir)

  explode: (p) ->
    explosion = if @isbutterfly(p) then Entity.EXPLODETODIAMOND0 else Entity.EXPLODETOSPACE0
    @set(p, explosion)
    for dir in [0 .. 7]
      if @isexplodable(p, dir)
        @set(p, explosion, dir)

  explode_dir: (p, dir) ->
    p2 = new Point(p.x, p.y, dir)
    @explode(p2)

  push: (p, dir) ->
    p2 = new Point(p.x, p.y, dir)
    if @isempty(p2, dir)
      if randomInt(1,8) is 1
        @move(p2, dir, Entity.BOULDER)
        if not @moving.grab
          @move(p, dir, Entity.ROCKFORD)

  domagic: (p, to) ->
    if @magic.time > 0
      @magic.active = true
      @clear(p)
      p2 = new Point(p.x, p.y + 2)
      if @isempty(p2)
        @set(p2, to)

  entityDispatch: (e, p, moving_dir) ->
    switch e
      when Entity.PREROCKFORD1 then @updatePreRockford(p, 1)
      when Entity.PREROCKFORD2 then @updatePreRockford(p, 2)
      when Entity.PREROCKFORD3 then @updatePreRockford(p, 3)
      when Entity.PREROCKFORD4 then @updatePreRockford(p, 4)
      when Entity.ROCKFORD then @updateRockford(p, moving_dir)
      when Entity.BOULDER then @updateBoulder(p)
      when Entity.BOULDERFALLING then @updateBoulderFalling(p)
      when Entity.DIAMOND then @updateDiamond(p)
      when Entity.DIAMONDFALLING then @updateDiamondFalling(p)
      when Entity.FIREFLY1 then @updateFirefly(p, DIR.LEFT)
      when Entity.FIREFLY2 then @updateFirefly(p, DIR.UP)
      when Entity.FIREFLY3 then @updateFirefly(p, DIR.RIGHT)
      when Entity.FIREFLY4 then @updateFirefly(p, DIR.DOWN)
      when Entity.BUTTERFLY1 then @updateButterfly(p, DIR.LEFT)
      when Entity.BUTTERFLY2 then @updateButterfly(p, DIR.UP)
      when Entity.BUTTERFLY3 then @updateButterfly(p, DIR.RIGHT)
      when Entity.BUTTERFLY4 then @updateButterfly(p, DIR.DOWN)
      when Entity.EXPLODETOSPACE0 then @updateExplodeToSpace(p, 0)
      when Entity.EXPLODETOSPACE1 then @updateExplodeToSpace(p, 1)
      when Entity.EXPLODETOSPACE2 then @updateExplodeToSpace(p, 2)
      when Entity.EXPLODETOSPACE3 then @updateExplodeToSpace(p, 3)
      when Entity.EXPLODETOSPACE4 then @updateExplodeToSpace(p, 4)
      when Entity.EXPLODETODIAMOND0 then @updateExplodeToDiamond(p, 0)
      when Entity.EXPLODETODIAMOND1 then @updateExplodeToDiamond(p, 1)
      when Entity.EXPLODETODIAMOND2 then @updateExplodeToDiamond(p, 2)
      when Entity.EXPLODETODIAMOND3 then @updateExplodeToDiamond(p, 3)
      when Entity.EXPLODETODIAMOND4 then @updateExplodeToDiamond(p, 4)
      when Entity.AMOEBA then @updateAmoeba(p)
      when Entity.PREOUTBOX then @updatePreOutbox(p)


timestamp = () -> new Date().getTime()

KEY =
  ENTER: 13
  ESC: 27
  SPACE: 32
  PAGEUP: 33
  PAGEDOWN: 34
  LEFT: 37
  UP: 38
  RIGHT: 39
  DOWN: 40

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
render = new Render(game, moving) # the boulderdash game renderer
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


