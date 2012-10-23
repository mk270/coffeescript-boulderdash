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

Object::extend = (source) ->
  for property of source
    if source.hasOwnProperty(property)
      this[property] = source[property]
  this

array_of_tuples = (l) ->
  tmp = []
  for i in l
    [k, v] = i
    tmp[k] = v
  tmp
    
BD.extend(
  Dom:
    get: (id) -> if (id instanceof HTMLElement)
                   id
                 else 
                   document.getElementById(id)
    set: (id, html) -> BD.Dom.get(id).innerHTML = html
    disable: (id, enabled) -> BD.Dom.get(id).className = if enabled then "disabled" else ""
  Entity:
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
  DIR:
    UP: 0
    UPRIGHT: 1
    RIGHT: 2
    DOWNRIGHT: 3
    DOWN: 4
    DOWNLEFT: 5
    LEFT: 6
    UPLEFT: 7
  DIRX: [     0,          1,        1,            1,       0,          -1,      -1,        -1 ],
  DIRY: [    -1,         -1,        0,            1,       1,           1,       0,        -1 ],
  rotateLeft: (dir) -> (dir-2) + (if dir < 2 then 8 else 0)
  rotateRight: (dir) -> (dir+2) - (if dir > 5 then 8 else 0)
  horizontal: (dir) -> (dir is BD.DIR.LEFT) or (dir is BD.DIR.RIGHT)
  vertical: (dir) -> (dir is BD.DIR.UP) or (dir is BD.DIR.DOWN)
  Point: (x, y, dir) ->
    @x = x + (BD.DIRX[dir] || 0)
    @y = y + (BD.DIRY[dir] || 0)
  isFirefly: (o) -> (BD.Entity.FIREFLY1.code <= o.code) and (o.code <= BD.Entity.FIREFLY4.code)
  isButterfly: (o) -> (BD.Entity.BUTTERFLY1.code <= o.code) and (o.code <= BD.Entity.BUTTERFLY4.code)
)

for key of BD.Entity
    BD.Entity[key].name = key
    BD.Entity[BD.Entity[key].code] = BD.Entity[key]

BD.extend(
  Sequences:
    FIREFLIES: array_of_tuples( [
      [BD.DIR.LEFT,  BD.Entity.FIREFLY1],
      [BD.DIR.UP,    BD.Entity.FIREFLY2],
      [BD.DIR.RIGHT, BD.Entity.FIREFLY3],
      [BD.DIR.DOWN,  BD.Entity.FIREFLY4]
    ] )
    BUTTERFLIES: array_of_tuples( [
      [BD.DIR.LEFT,  BD.Entity.BUTTERFLY1],
      [BD.DIR.UP,    BD.Entity.BUTTERFLY2],
      [BD.DIR.RIGHT, BD.Entity.BUTTERFLY3],
      [BD.DIR.DOWN,  BD.Entity.BUTTERFLY4]
    ] )
    PREROCKFORDS: [ BD.Entity.PREROCKFORD1, BD.Entity.PREROCKFORD2, BD.Entity.PREROCKFORD3, BD.Entity.PREROCKFORD, BD.Entity.ROCKFORD ]
    EXPLODETOSPACE: [ BD.Entity.EXPLODETOSPACE0, BD.Entity.EXPLODETOSPACE1, BD.Entity.EXPLODETOSPACE2, BD.Entity.EXPLODETOSPACE3, BD.Entity.EXPLODETOSPACE4, BD.Entity.SPACE ]
    EXPLODETODIAMOND: [ BD.Entity.EXPLODETODIAMOND0, BD.Entity.EXPLODETODIAMOND1, BD.Entity.EXPLODETODIAMOND2, BD.Entity.EXPLODETODIAMOND3, BD.Entity.EXPLODETODIAMOND4, BD.Entity.DIAMOND ]
)


BD.Render = (game, moving) ->
  @game = game;
  @moving = moving;
  game.subscribe('level', @onChangeLevel,   this)
  game.subscribe('score', @invalidateScore, this)
  game.subscribe('timer', @invalidateScore, this)
  game.subscribe('flash', @invalidateCave,  this)
  game.subscribe('cell',  @invalidateCell,  this)
  null

BD.Render.prototype =
  reset: (sprites) ->
    @canvas = BD.Dom.get('canvas')
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
    BD.Dom.disable('prev', info.index is 0)
    BD.Dom.disable('next', info.index is CAVES.length - 1)

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
    if @invalid.cave or cell.invalid or (sprite.f > 1) or (object is BD.Entity.ROCKFORD)
      if object is BD.Entity.ROCKFORD
        @rockford(cell)
      else 
        if (object is BD.Entity.SPACE) and (@game.flash > @game.frame)
          sprite = BD.Entity.SPACE.flash
        else if object is BD.Entity.MAGICWALL and not @game.magic.active
          sprite = BD.Entity.BRICKWALL.sprite
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
    if @moving.dir is BD.DIR.LEFT or BD.vertical(@moving.dir) and @moving.lastXDir is BD.DIR.LEFT
      @sprite(BD.Entity.ROCKFORD.left, cell)
    else if @moving.dir is BD.DIR.RIGHT or BD.vertical(@moving.dir) and @moving.lastXDir is BD.DIR.RIGHT
      @sprite(BD.Entity.ROCKFORD.right, cell)
    else if @game.idle.blink and not @game.idle.tap
      @sprite(BD.Entity.ROCKFORD.blink, cell)
    else if not @game.idle.blink and @game.idle.tap
      @sprite(BD.Entity.ROCKFORD.tap, cell)
    else if @game.idle.blink and @game.idle.tap
      @sprite(BD.Entity.ROCKFORD.blinktap, cell)
    else
      @sprite(BD.Entity.ROCKFORD.sprite, cell)

  description: (msg) -> BD.Dom.set('description', msg)

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

BD.Game = (moving, options) ->
  @options = options or {}
  @storage = window.localStorage or {}
  @score   = 0
  @moving  = moving
  null

BD.Game.prototype.extend(
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
          p: new BD.Point(x,y)
          frame: 0
          object: BD.Entity[@cave.map[x][y]]
    @publish('level', @cave)

  prev: () -> if (@index > 0)
                @reset(@index-1)
  next: () -> if (@index < CAVES.length-1)
                @reset(@index+1)

  get: (p,dir) -> @cells[p.x + (BD.DIRX[dir] or 0)][p.y + (BD.DIRY[dir] or 0)].object
    
  set: (p,o,dir) ->
    cell = @cells[p.x + (BD.DIRX[dir] or 0)][p.y + (BD.DIRY[dir] or 0)]
    cell.object = o
    cell.frame = @frame
    @publish('cell', cell)
    
  clear: (p,dir) -> @set(p,BD.Entity.SPACE,dir)
  move: (p,dir,o) -> @clear(p); @set(p,o,dir)

  isempty:      (p,dir) -> @get(p,dir) is BD.Entity.SPACE    
  isdirt:       (p,dir) -> @get(p,dir) is BD.Entity.DIRT     
  isboulder:    (p,dir) -> @get(p,dir) is BD.Entity.BOULDER  
  isrockford:   (p,dir) -> @get(p,dir) is BD.Entity.ROCKFORD 
  isdiamond:    (p,dir) -> @get(p,dir) is BD.Entity.DIAMOND  
  isamoeba:     (p,dir) -> @get(p,dir) is BD.Entity.AMOEBA   
  ismagic:      (p,dir) -> @get(p,dir) is BD.Entity.MAGICWALL
  isoutbox:     (p,dir) -> @get(p,dir) is BD.Entity.OUTBOX   

  isfirefly:    (p,dir) -> BD.isFirefly(@get(p,dir))
  isbutterfly:  (p,dir) -> BD.isButterfly(@get(p,dir))
  isexplodable: (p,dir) -> @get(p,dir).explodable
  isvulnerable: (p,dir) -> @get(p,dir).vulnerable
  isrounded:    (p,dir) -> @get(p,dir).rounded

  isfallingdiamond: (p,dir) -> @get(p,dir) is BD.Entity.DIAMONDFALLING
  isfallingboulder: (p,dir) -> @get(p,dir) is BD.Entity.BOULDERFALLING

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
        @amoeba.dead = BD.Entity.DIAMOND
      else if @amoeba.size > @amoeba.max
        @amoeba.dead = BD.Entity.BOULDER
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
      @set(p, BD.Sequences.PREROCKFORDS[n+1])

  updatePreOutbox: (p) ->
    if @diamonds.collected >= @diamonds.needed
        @set(p, BD.Entity.OUTBOX)

  doGrab: (p, dir) ->
    if @isdirt(p, dir)
      @clear(p, dir)
    else if @isdiamond(p, dir) or @isfallingdiamond(p, dir)
      @clear(p, dir)
      @collectDiamond()
    else if BD.horizontal(dir) and @isboulder(p, dir) 
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
      @move(p, dir, BD.Entity.ROCKFORD)
    else if @isdiamond(p, dir) 
      @move(p, dir, BD.Entity.ROCKFORD)
      @collectDiamond()
    else if BD.horizontal(dir) and @isboulder(p, dir) 
      @push(p, dir)
    else if @isoutbox(p, dir) 
      @move(p, dir, BD.Entity.ROCKFORD)
      @winLevel()

  updateRock: (p, rock) ->
    if @isempty(p, BD.DIR.DOWN)
      @set(p, rock)
    else if @isrounded(p, BD.DIR.DOWN) and @isempty(p, BD.DIR.LEFT) and @isempty(p, BD.DIR.DOWNLEFT)
      @move(p, BD.DIR.LEFT, rock)
    else if @isrounded(p, BD.DIR.DOWN) and @isempty(p, BD.DIR.RIGHT) and @isempty(p, BD.DIR.DOWNRIGHT)
      @move(p, BD.DIR.RIGHT, rock)

  updateRockFalling: (p, rock, rockAtRest, convertedRock) ->
    if @isempty(p, BD.DIR.DOWN)
      @move(p, BD.DIR.DOWN, rock)
    else if @isvulnerable(p, BD.DIR.DOWN)
      @explode_dir(p, BD.DIR.DOWN)
    else if @ismagic(p, BD.DIR.DOWN)
      @domagic(p, convertedRock)
    else if @isrounded(p, BD.DIR.DOWN) and @isempty(p, BD.DIR.LEFT) and @isempty(p, BD.DIR.DOWNLEFT)
      @move(p, BD.DIR.LEFT, rock)
    else if @isrounded(p, BD.DIR.DOWN) and @isempty(p, BD.DIR.RIGHT) and @isempty(p, BD.DIR.DOWNRIGHT)
      @move(p, BD.DIR.RIGHT, rock)
    else
      @set(p, rockAtRest)

  updateBoulder: (p) -> @updateRock(p, BD.Entity.BOULDERFALLING)
  updateDiamond: (p) -> @updateRock(p, BD.Entity.DIAMONDFALLING)
  updateBoulderFalling: (p) -> @updateRockFalling(p, BD.Entity.BOULDERFALLING, BD.Entity.BOULDER, BD.Entity.DIAMOND)
  updateDiamondFalling: (p) -> @updateRockFalling(p, BD.Entity.DIAMONDFALLING, BD.Entity.DIAMOND, BD.Entity.BOULDER)

  adjacent: (p, fn) ->
    dirs = [ BD.DIR.UP, BD.DIR.DOWN, BD.DIR.LEFT, BD.DIR.RIGHT ]

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
        
  updateFirefly: (p, dir)   -> @updateFly(p, dir, BD.rotateLeft(dir), BD.rotateRight(dir), BD.Sequences.FIREFLIES)
  updateButterfly: (p, dir) -> @updateFly(p, dir, BD.rotateRight(dir), BD.rotateLeft(dir), BD.Sequences.BUTTERFLIES)
  updateExplodeToSpace: (p, n) -> @set(p, BD.Sequences.EXPLODETOSPACE[n+1])
  updateExplodeToDiamond: (p, n) -> @set(p, BD.Sequences.EXPLODETODIAMOND[n+1])

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
        dir  = randomChoice([BD.DIR.UP, BD.DIR.DOWN, BD.DIR.LEFT, BD.DIR.RIGHT])
        if grow and (@isdirt(p, dir) or @isempty(p, dir))
          @set(p, BD.Entity.AMOEBA, dir)

  explode: (p) ->
    explosion = if @isbutterfly(p) then BD.Entity.EXPLODETODIAMOND0 else BD.Entity.EXPLODETOSPACE0
    @set(p, explosion)
    for dir in [0 .. 7]
      if @isexplodable(p, dir)
        @set(p, explosion, dir)

  explode_dir: (p, dir) ->
    p2 = new BD.Point(p.x, p.y, dir)
    @explode(p2)

  push: (p, dir) ->
    p2 = new BD.Point(p.x, p.y, dir)
    if @isempty(p2, dir)
      if randomInt(1,8) is 1
        @move(p2, dir, BD.Entity.BOULDER)
        if not @moving.grab
          @move(p, dir, BD.Entity.ROCKFORD)

  domagic: (p, to) ->
    if @magic.time > 0
      @magic.active = true
      @clear(p)
      p2 = new BD.Point(p.x, p.y + 2)
      if @isempty(p2)
        @set(p2, to)

  entityDispatch: (e, p, moving_dir) ->
    switch e
      when BD.Entity.PREROCKFORD1 then @updatePreRockford(p, 1)
      when BD.Entity.PREROCKFORD2 then @updatePreRockford(p, 2)
      when BD.Entity.PREROCKFORD3 then @updatePreRockford(p, 3)
      when BD.Entity.PREROCKFORD4 then @updatePreRockford(p, 4)
      when BD.Entity.ROCKFORD then @updateRockford(p, moving_dir)
      when BD.Entity.BOULDER then @updateBoulder(p)
      when BD.Entity.BOULDERFALLING then @updateBoulderFalling(p)
      when BD.Entity.DIAMOND then @updateDiamond(p)
      when BD.Entity.DIAMONDFALLING then @updateDiamondFalling(p)
      when BD.Entity.FIREFLY1 then @updateFirefly(p, BD.DIR.LEFT)
      when BD.Entity.FIREFLY2 then @updateFirefly(p, BD.DIR.UP)
      when BD.Entity.FIREFLY3 then @updateFirefly(p, BD.DIR.RIGHT)
      when BD.Entity.FIREFLY4 then @updateFirefly(p, BD.DIR.DOWN)
      when BD.Entity.BUTTERFLY1 then @updateButterfly(p, BD.DIR.LEFT)
      when BD.Entity.BUTTERFLY2 then @updateButterfly(p, BD.DIR.UP)
      when BD.Entity.BUTTERFLY3 then @updateButterfly(p, BD.DIR.RIGHT)
      when BD.Entity.BUTTERFLY4 then @updateButterfly(p, BD.DIR.DOWN)
      when BD.Entity.EXPLODETOSPACE0 then @updateExplodeToSpace(p, 0)
      when BD.Entity.EXPLODETOSPACE1 then @updateExplodeToSpace(p, 1)
      when BD.Entity.EXPLODETOSPACE2 then @updateExplodeToSpace(p, 2)
      when BD.Entity.EXPLODETOSPACE3 then @updateExplodeToSpace(p, 3)
      when BD.Entity.EXPLODETOSPACE4 then @updateExplodeToSpace(p, 4)
      when BD.Entity.EXPLODETODIAMOND0 then @updateExplodeToDiamond(p, 0)
      when BD.Entity.EXPLODETODIAMOND1 then @updateExplodeToDiamond(p, 1)
      when BD.Entity.EXPLODETODIAMOND2 then @updateExplodeToDiamond(p, 2)
      when BD.Entity.EXPLODETODIAMOND3 then @updateExplodeToDiamond(p, 3)
      when BD.Entity.EXPLODETODIAMOND4 then @updateExplodeToDiamond(p, 4)
      when BD.Entity.AMOEBA then @updateAmoeba(p)
      when BD.Entity.PREOUTBOX then @updatePreOutbox(p)

)