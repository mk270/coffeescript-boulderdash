
BD.Render = function(game, moving) {
  this.game = game;
  this.moving = moving;
    game.subscribe('level', this.onChangeLevel,   this);
    game.subscribe('score', this.invalidateScore, this);
    game.subscribe('timer', this.invalidateScore, this);
    game.subscribe('flash', this.invalidateCave,  this);
    game.subscribe('cell',  this.invalidateCell,  this);
};

BD.Render.prototype = {

    reset: function(sprites) {
      this.canvas     = BD.Dom.get('canvas');
      this.ctx        = this.canvas.getContext('2d');
      this.sprites    = sprites;
      this.fps        = 30;
      this.step       = 1/this.fps;
      this.frame      = 0;
      this.ctxSprites = document.createElement('canvas').getContext('2d');
      this.ctxSprites.canvas.width  = this.sprites.width;
      this.ctxSprites.canvas.height = this.sprites.height;
      this.ctxSprites.drawImage(this.sprites, 0, 0, this.sprites.width, this.sprites.height, 0, 0, this.sprites.width, this.sprites.height);
      this.resize();
    },

    onChangeLevel: function(info) {
      this.description(info.description);
      this.colors(info.color1, info.color2);
      this.invalidateCave();
      this.invalidateScore();
      BD.Dom.disable('prev', info.index === 0);
      BD.Dom.disable('next', info.index === CAVES.length-1);
    },

    invalid: { score: true, cave:  true },
    invalidateScore: function()     { this.invalid.score = true;  },
    invalidateCave:  function()     { this.invalid.cave  = true;  },
    invalidateCell:  function(cell) { cell.invalid       = true;  },
    validateScore:   function()     { this.invalid.score = false; },
    validateCave:    function()     { this.invalid.cave  = false; },
    validateCell:    function(cell) { cell.invalid       = false; },

    update: function() {
      this.frame++;
      this.score();
      this.game.eachCell(this.cell, this);
      this.validateCave();
    },

    score: function() {
      if (this.invalid.score) {
        this.ctx.fillStyle='black';
        this.ctx.fillRect(0, 0, this.canvas.width, this.dy);
        this.number(3, this.game.diamonds.needed, 2, true);
        this.letter(  5, '$');
        this.number(6,  this.game.diamonds.collected >= this.game.diamonds.needed ? this.game.diamonds.extra : this.game.diamonds.value, 2);
        this.number(12, this.game.diamonds.collected, 2, true);
        this.number(25, this.game.timer, 3);
        this.number(31, this.game.score, 6);
        this.validateScore();
      }
    },

    number: function(x, n, width, yellow) {
      var i, word = ("000000" + n.toString()).slice(-(width||2));
      for(i = 0 ; i < word.length ; ++i)
        this.letter(x+i, word[i], yellow);
    },

    letter: function(x, c, yellow) {
      this.ctx.drawImage(this.ctxSprites.canvas, (yellow ? 9 : 8) * 32, (c.charCodeAt(0)-32) * 16, 32, 16, (x*this.dx), 0, this.dx, this.dy-4); // auto scaling here from 32/32 to dx/dy can be slow... we should optimize and precatch rendered sprites at exact cell size (dx,dy)
    },

    cell: function(cell) {
      var object = cell.object,
          sprite = object.sprite;
      if (this.invalid.cave || cell.invalid || (sprite.f > 1) || (object === BD.Entity.ROCKFORD)) {
        if (object === BD.Entity.ROCKFORD)
          return this.rockford(cell);
        else if ((object === BD.Entity.SPACE) && (this.game.flash > this.game.frame))
          sprite = BD.Entity.SPACE.flash;
        else if ((object === BD.Entity.MAGICWALL) && !this.game.magic.active)
          sprite = BD.Entity.BRICKWALL.sprite;
        this.sprite(sprite, cell);
        this.validateCell(cell);
      }
    },

    sprite: function(sprite, cell) {
      var f = sprite.f ? (Math.floor((sprite.fps/this.fps) * this.frame) % sprite.f) : 0;
      this.ctx.drawImage(this.ctxSprites.canvas, (sprite.x + f) * 32, sprite.y * 32, 32, 32, cell.p.x * this.dx, (1+cell.p.y) * this.dy, this.dx, this.dy); // auto scaling here from 32/32 to dx/dy can be slow... we should optimize and precatch rendered sprites at exact cell size (dx,dy)
    },

    rockford: function(cell) {
      if ((this.moving.dir == BD.DIR.LEFT) || (BD.vertical(this.moving.dir) && (this.moving.lastXDir == BD.DIR.LEFT)))
        this.sprite(BD.Entity.ROCKFORD.left, cell);
      else if ((this.moving.dir == BD.DIR.RIGHT) || (BD.vertical(this.moving.dir) && (this.moving.lastXDir == BD.DIR.RIGHT)))
        this.sprite(BD.Entity.ROCKFORD.right, cell);
      else if (this.game.idle.blink && !this.game.idle.tap)
        this.sprite(BD.Entity.ROCKFORD.blink, cell);
      else if (!this.game.idle.blink && this.game.idle.tap)
        this.sprite(BD.Entity.ROCKFORD.tap, cell);
      else if (this.game.idle.blink && this.game.idle.tap)
        this.sprite(BD.Entity.ROCKFORD.blinktap, cell);
      else
        this.sprite(BD.Entity.ROCKFORD.sprite, cell);
    },

    description: function(msg) {
      BD.Dom.set('description', msg);
    },

    colors: function(color1, color2) {
      this.ctxSprites.drawImage(this.sprites, 0, 0, this.sprites.width, this.sprites.height, 0, 0, this.sprites.width, this.sprites.height);
      var pixels = this.ctxSprites.getImageData(0, 0, this.sprites.width, this.sprites.height);
      var x, y, n, r, g, b, a;
      for(y = 0 ; y < this.sprites.height ; ++y) {
        for(x = 0 ; x < this.sprites.width ; ++x) {
          n = (y*this.sprites.width*4) + (x*4);
          color = (pixels.data[n + 0] << 16) + 
                  (pixels.data[n + 1] << 8) +
                  (pixels.data[n + 2] << 0);
          if (color == 0x3F3F3F) { // mostly the metalic wall
            pixels.data[n + 0] = (color2 >> 16) & 0xFF;
            pixels.data[n + 1] = (color2 >> 8)  & 0xFF;
            pixels.data[n + 2] = (color2 >> 0)  & 0xFF;
          }
          else if (color == 0xA52A00) { // mostly the dirt
            pixels.data[n + 0] = (color1 >> 16) & 0xFF;
            pixels.data[n + 1] = (color1 >> 8)  & 0xFF;
            pixels.data[n + 2] = (color1 >> 0)  & 0xFF;
          }
        }
      }
      this.ctxSprites.putImageData(pixels, 0, 0);
    },

    resize: function() {
      var visibleArea = { w: 40, h: 23 };            // 40x22 + 1 row for score at top - TODO: scrollable area
      this.canvas.width  = this.canvas.clientWidth;  // set canvas logical size equal to its physical size
      this.canvas.height = this.canvas.clientHeight; // (ditto)
      this.dx = this.canvas.width  / visibleArea.w;  // calculate pixel size of a single game cell
      this.dy = this.canvas.height / visibleArea.h;  // (ditto)
      this.invalidateScore();
      this.invalidateCave();
    }

};
