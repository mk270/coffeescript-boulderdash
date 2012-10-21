array_of_tuples = (l) ->
  tmp = []
  for i in l
    [k, v] = i
    tmp[k] = v
  tmp
 
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