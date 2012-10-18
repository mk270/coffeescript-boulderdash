
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