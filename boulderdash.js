  function timestamp()            { return new Date().getTime();                             };
  function random(min, max)       { return (min + (Math.random() * (max - min)));            };
  function randomInt(min, max)    { return Math.floor(random(min,max));                      };
  function randomChoice(choices)  { return choices[Math.round(random(0, choices.length-1))]; };

  if (!window.requestAnimationFrame) { // http://paulirish.com/2011/requestanimationframe-for-smart-animating/
    window.requestAnimationFrame = window.webkitRequestAnimationFrame || 
                                   window.mozRequestAnimationFrame    || 
                                   window.oRequestAnimationFrame      || 
                                   window.msRequestAnimationFrame     || 
                                   function(callback, element) {
                                     window.setTimeout(callback, 1000 / 60);
                                   }
  }

Object.prototype.extend = function(source) {
    for (var property in source) {
        if (source.hasOwnProperty(property)) {
            this[property] = source[property];
        }
    }
    return this;
};

// key, dom, dir, object, point, game, render, loop

BD = {};
BD.extend({
  KEY: { ENTER: 13, ESC: 27, SPACE: 32, PAGEUP: 33, PAGEDOWN: 34, LEFT: 37, UP: 38, RIGHT: 39, DOWN: 40 },
  Dom: {
	get:     function(id)       { return (id instanceof HTMLElement) ? id : document.getElementById(id); },
	set:     function(id, html) { BD.Dom.get(id).innerHTML = html; },
	disable: function(id, on)   { BD.Dom.get(id).className = on ? "disabled" : "" }
  },
  Entity: {
    SPACE:             { code: 0x00, rounded: false, explodable: false, consumable: true,  sprite: { x: 0, y: 6                 }, flash: { x: 4, y: 0 } },
    DIRT:              { code: 0x01, rounded: false, explodable: false, consumable: true,  sprite: { x: 1, y: 7                 } },
    BRICKWALL:         { code: 0x02, rounded: true,  explodable: false, consumable: true,  sprite: { x: 3, y: 6                 } },
    MAGICWALL:         { code: 0x03, rounded: false, explodable: false, consumable: true,  sprite: { x: 4, y: 6,  f: 4, fps: 20 } },
    PREOUTBOX:         { code: 0x04, rounded: false, explodable: false, consumable: false, sprite: { x: 1, y: 6                 } },
    OUTBOX:            { code: 0x05, rounded: false, explodable: false, consumable: false, sprite: { x: 1, y: 6,  f: 2, fps: 4  } },
    STEELWALL:         { code: 0x07, rounded: false, explodable: false, consumable: false, sprite: { x: 1, y: 6                 } },
    FIREFLY1:          { code: 0x08, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 9,  f: 8, fps: 20 } },
    FIREFLY2:          { code: 0x09, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 9,  f: 8, fps: 20 } },
    FIREFLY3:          { code: 0x0A, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 9,  f: 8, fps: 20 } },
    FIREFLY4:          { code: 0x0B, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 9,  f: 8, fps: 20 } },
    BOULDER:           { code: 0x10, rounded: true,  explodable: false, consumable: true,  sprite: { x: 0, y: 7                 } },
    BOULDERFALLING:    { code: 0x12, rounded: false, explodable: false, consumable: true,  sprite: { x: 0, y: 7                 } },
    DIAMOND:           { code: 0x14, rounded: true,  explodable: false, consumable: true,  sprite: { x: 0, y: 10, f: 8, fps: 20 } },
    DIAMONDFALLING:    { code: 0x16, rounded: false, explodable: false, consumable: true,  sprite: { x: 0, y: 10, f: 8, fps: 20 } },
    EXPLODETOSPACE0:   { code: 0x1B, rounded: false, explodable: false, consumable: false, sprite: { x: 3, y: 7                 } },
    EXPLODETOSPACE1:   { code: 0x1C, rounded: false, explodable: false, consumable: false, sprite: { x: 4, y: 7                 } },
    EXPLODETOSPACE2:   { code: 0x1D, rounded: false, explodable: false, consumable: false, sprite: { x: 5, y: 7                 } },
    EXPLODETOSPACE3:   { code: 0x1E, rounded: false, explodable: false, consumable: false, sprite: { x: 4, y: 7                 } },
    EXPLODETOSPACE4:   { code: 0x1F, rounded: false, explodable: false, consumable: false, sprite: { x: 3, y: 7                 } },
    EXPLODETODIAMOND0: { code: 0x20, rounded: false, explodable: false, consumable: false, sprite: { x: 3, y: 7                 } },
    EXPLODETODIAMOND1: { code: 0x21, rounded: false, explodable: false, consumable: false, sprite: { x: 4, y: 7                 } },
    EXPLODETODIAMOND2: { code: 0x22, rounded: false, explodable: false, consumable: false, sprite: { x: 5, y: 7                 } },
    EXPLODETODIAMOND3: { code: 0x23, rounded: false, explodable: false, consumable: false, sprite: { x: 4, y: 7                 } },
    EXPLODETODIAMOND4: { code: 0x24, rounded: false, explodable: false, consumable: false, sprite: { x: 3, y: 7                 } },
    PREROCKFORD1:      { code: 0x25, rounded: false, explodable: false, consumable: false, sprite: { x: 1, y: 6,  f: 2, fps: 4  } },
    PREROCKFORD2:      { code: 0x26, rounded: false, explodable: false, consumable: false, sprite: { x: 1, y: 0                 } },
    PREROCKFORD3:      { code: 0x27, rounded: false, explodable: false, consumable: false, sprite: { x: 2, y: 0                 } },
    PREROCKFORD4:      { code: 0x28, rounded: false, explodable: false, consumable: false, sprite: { x: 3, y: 0                 } },
    BUTTERFLY1:        { code: 0x30, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 11, f: 8, fps: 20 } },
    BUTTERFLY2:        { code: 0x31, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 11, f: 8, fps: 20 } },
    BUTTERFLY3:        { code: 0x32, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 11, f: 8, fps: 20 } },
    BUTTERFLY4:        { code: 0x33, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 11, f: 8, fps: 20 } },
    ROCKFORD:          { code: 0x38, rounded: false, explodable: true,  consumable: true,  sprite: { x: 0, y: 0                 },   // standing still
                                                                                             left: { x: 0, y: 4,  f: 8, fps: 20 },   // running left
                                                                                            right: { x: 0, y: 5,  f: 8, fps: 20 },   // running right
                                                                                            blink: { x: 0, y: 1,  f: 8, fps: 20 },   // blinking
                                                                                              tap: { x: 0, y: 2,  f: 8, fps: 20 },   // foot tapping
                                                                                         blinktap: { x: 0, y: 3,  f: 8, fps: 20 } }, // foot tapping and blinking
    AMOEBA:            { code: 0x3A, rounded: false, explodable: false, consumable: true,  sprite: { x: 0, y: 8,  f: 8, fps: 20 } }
  },
  DIR: { UP: 0, UPRIGHT: 1, RIGHT: 2, DOWNRIGHT: 3, DOWN: 4, DOWNLEFT: 5, LEFT: 6, UPLEFT: 7 },
  DIRX: [     0,          1,        1,            1,       0,          -1,      -1,        -1 ],
  DIRY: [    -1,         -1,        0,            1,       1,           1,       0,        -1 ],
  rotateLeft: function(dir)  { return (dir-2) + (dir < 2 ? 8 : 0); },
  rotateRight: function(dir) { return (dir+2) - (dir > 5 ? 8 : 0); },
  horizontal: function(dir)  { return (dir === BD.DIR.LEFT) || (dir === BD.DIR.RIGHT); },
  vertical: function(dir)    { return (dir === BD.DIR.UP)   || (dir === BD.DIR.DOWN);  },
  Point: function(x, y, dir) {
    this.x = x + (BD.DIRX[dir] || 0);
    this.y = y + (BD.DIRY[dir] || 0);
  },
  isFirefly: function(o)   { return (BD.Entity.FIREFLY1.code     <= o.code) && (o.code <= BD.Entity.FIREFLY4.code);   },
  isButterfly: function(o) { return (BD.Entity.BUTTERFLY1.code   <= o.code) && (o.code <= BD.Entity.BUTTERFLY4.code); }

});


  var FIREFLIES = [];
  FIREFLIES[BD.DIR.LEFT]  = BD.Entity.FIREFLY1;
  FIREFLIES[BD.DIR.UP]    = BD.Entity.FIREFLY2;
  FIREFLIES[BD.DIR.RIGHT] = BD.Entity.FIREFLY3;
  FIREFLIES[BD.DIR.DOWN]  = BD.Entity.FIREFLY4;

  var BUTTERFLIES = [];
  BUTTERFLIES[BD.DIR.LEFT]  = BD.Entity.BUTTERFLY1;
  BUTTERFLIES[BD.DIR.UP]    = BD.Entity.BUTTERFLY2;
  BUTTERFLIES[BD.DIR.RIGHT] = BD.Entity.BUTTERFLY3;
  BUTTERFLIES[BD.DIR.DOWN]  = BD.Entity.BUTTERFLY4;

  var PREROCKFORDS = [
    BD.Entity.PREROCKFORD1,
    BD.Entity.PREROCKFORD2,
    BD.Entity.PREROCKFORD3,
    BD.Entity.PREROCKFORD4,
    BD.Entity.ROCKFORD
  ];

  var EXPLODETOSPACE = [
    BD.Entity.EXPLODETOSPACE0,
    BD.Entity.EXPLODETOSPACE1,
    BD.Entity.EXPLODETOSPACE2,
    BD.Entity.EXPLODETOSPACE3,
    BD.Entity.EXPLODETOSPACE4,
    BD.Entity.SPACE
  ];

  var EXPLODETODIAMOND = [
    BD.Entity.EXPLODETODIAMOND0,
    BD.Entity.EXPLODETODIAMOND1,
    BD.Entity.EXPLODETODIAMOND2,
    BD.Entity.EXPLODETODIAMOND3,
    BD.Entity.EXPLODETODIAMOND4,
    BD.Entity.DIAMOND
  ];




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

BD.Game = function(moving, options) {
    this.options = options || {};
    this.storage = window.localStorage || {};
    this.score   = 0;
  this.moving = moving;
};

BD.Game.prototype = {

    reset: function(n) {
      n = Math.min(CAVES.length-1, Math.max(0, (typeof n === 'number' ? n : this.storage.level || 0)));
      this.index    = this.storage.level = n;        // cave index
      this.cave     = CAVES[this.index];             // cave definition
      this.width    = this.cave.width;               // cave cell width
      this.height   = this.cave.height;              // cave cell height
      this.cells    = [];                            // will be built up into 2 dimensional array below
      this.frame    = 0;                             // game frame counter starts at zero
      this.fps      = 10;                            // how many game frames per second
      this.step     = 1/this.fps;                    // how long is each game frame (in seconds)
      this.birth    = 2*this.fps;                    // in which frame is rockford born ?
      this.timer    = this.cave.caveTime;            // seconds allowed to complete this cave 
      this.idle     = { blink: false, tap: false };  // is rockford showing any idle animation ?
      this.flash    = false;                         // trigger white flash when rockford has collected enought diamonds
      this.won      = false;                         // set to true when rockford enters the outbox
      this.diamonds = {
        collected: 0,
        needed: this.cave.diamondsNeeded,
        value:  this.cave.initialDiamondValue,
        extra:  this.cave.extraDiamondValue
      };
      this.amoeba = {
        max: this.cave.amoebaMaxSize,
        slow: this.cave.amoebaSlowGrowthTime/this.step
      };
      this.magic = {
        active: false,
        time: this.cave.magicWallMillingTime/this.step
      };
      var x, y, o, pt;
      for(y = 0 ; y < this.height ; ++y) {
        for(x = 0 ; x < this.width ; ++x) {
          this.cells[x]    = this.cells[x] || [];
          this.cells[x][y] = { p: new BD.Point(x,y), 
							   frame: 0, 
							   object: BD.Entity[this.cave.map[x][y]] };
        }
      }
      this.publish('level', this.cave);
    },

    prev: function() { if (this.index > 0)              this.reset(this.index-1); },
    next: function() { if (this.index < CAVES.length-1) this.reset(this.index+1); },

    get:          function(p,dir)   {     return this.cells[p.x + (BD.DIRX[dir] || 0)][p.y + (BD.DIRY[dir] || 0)].object; },
    set:          function(p,o,dir) { var cell = this.cells[p.x + (BD.DIRX[dir] || 0)][p.y + (BD.DIRY[dir] || 0)]; cell.object = o; cell.frame = this.frame; this.publish('cell', cell) },
    clear:        function(p,dir)   { this.set(p,BD.Entity.SPACE,dir); },
    move:         function(p,dir,o) { this.clear(p); this.set(p,o,dir); },
    isempty:      function(p,dir)   { var o = this.get(p,dir); return BD.Entity.SPACE     === o; },
    isdirt:       function(p,dir)   { var o = this.get(p,dir); return BD.Entity.DIRT      === o; },
    isboulder:    function(p,dir)   { var o = this.get(p,dir); return BD.Entity.BOULDER   === o; },
    isrockford:   function(p,dir)   { var o = this.get(p,dir); return BD.Entity.ROCKFORD  === o; },
    isdiamond:    function(p,dir)   { var o = this.get(p,dir); return BD.Entity.DIAMOND   === o; },
    isamoeba:     function(p,dir)   { var o = this.get(p,dir); return BD.Entity.AMOEBA    === o; },
    ismagic:      function(p,dir)   { var o = this.get(p,dir); return BD.Entity.MAGICWALL === o; },
    isoutbox:     function(p,dir)   { var o = this.get(p,dir); return BD.Entity.OUTBOX    === o; },
    isfirefly:    function(p,dir)   { var o = this.get(p,dir); return BD.isFirefly(o);           },
    isbutterfly:  function(p,dir)   { var o = this.get(p,dir); return BD.isButterfly(o);         },
    isexplodable: function(p,dir)   { var o = this.get(p,dir); return o.explodable;           },
    isconsumable: function(p,dir)   { var o = this.get(p,dir); return o.consumable;           },
    isrounded:    function(p,dir)   { var o = this.get(p,dir); return o.rounded;              },

    isfallingdiamond: function(p,dir) { var o = this.get(p,dir); return BD.Entity.DIAMONDFALLING === o; },
    isfallingboulder: function(p,dir) { var o = this.get(p,dir); return BD.Entity.BOULDERFALLING === o; },

    eachCell: function(fn, thisArg) {
      for(var y = 0 ; y < this.height ; y++) {
        for(var x = 0 ; x < this.width ; x++) {
          fn.call(thisArg || this, this.cells[x][y]);
        }
      }
    },

    update: function() {
      this.beginFrame();
      this.eachCell(function(cell) {
        if (cell.frame < this.frame) {
          switch(cell.object) {
            case BD.Entity.PREROCKFORD1:      this.updatePreRockford(cell.p, 1);       break;
            case BD.Entity.PREROCKFORD2:      this.updatePreRockford(cell.p, 2);       break;
            case BD.Entity.PREROCKFORD3:      this.updatePreRockford(cell.p, 3);       break;
            case BD.Entity.PREROCKFORD4:      this.updatePreRockford(cell.p, 4);       break;
            case BD.Entity.ROCKFORD:          this.updateRockford(cell.p, this.moving.dir); break;
            case BD.Entity.BOULDER:           this.updateBoulder(cell.p);              break;
            case BD.Entity.BOULDERFALLING:    this.updateBoulderFalling(cell.p);       break;
            case BD.Entity.DIAMOND:           this.updateDiamond(cell.p);              break;
            case BD.Entity.DIAMONDFALLING:    this.updateDiamondFalling(cell.p);       break;
            case BD.Entity.FIREFLY1:          this.updateFirefly(cell.p, BD.DIR.LEFT);    break;
            case BD.Entity.FIREFLY2:          this.updateFirefly(cell.p, BD.DIR.UP);      break;
            case BD.Entity.FIREFLY3:          this.updateFirefly(cell.p, BD.DIR.RIGHT);   break;
            case BD.Entity.FIREFLY4:          this.updateFirefly(cell.p, BD.DIR.DOWN);    break;
            case BD.Entity.BUTTERFLY1:        this.updateButterfly(cell.p, BD.DIR.LEFT);  break;
            case BD.Entity.BUTTERFLY2:        this.updateButterfly(cell.p, BD.DIR.UP);    break;
            case BD.Entity.BUTTERFLY3:        this.updateButterfly(cell.p, BD.DIR.RIGHT); break;
            case BD.Entity.BUTTERFLY4:        this.updateButterfly(cell.p, BD.DIR.DOWN);  break;
            case BD.Entity.EXPLODETOSPACE0:   this.updateExplodeToSpace(cell.p, 0);    break;
            case BD.Entity.EXPLODETOSPACE1:   this.updateExplodeToSpace(cell.p, 1);    break;
            case BD.Entity.EXPLODETOSPACE2:   this.updateExplodeToSpace(cell.p, 2);    break;
            case BD.Entity.EXPLODETOSPACE3:   this.updateExplodeToSpace(cell.p, 3);    break;
            case BD.Entity.EXPLODETOSPACE4:   this.updateExplodeToSpace(cell.p, 4);    break;
            case BD.Entity.EXPLODETODIAMOND0: this.updateExplodeToDiamond(cell.p, 0);  break;
            case BD.Entity.EXPLODETODIAMOND1: this.updateExplodeToDiamond(cell.p, 1);  break;
            case BD.Entity.EXPLODETODIAMOND2: this.updateExplodeToDiamond(cell.p, 2);  break;
            case BD.Entity.EXPLODETODIAMOND3: this.updateExplodeToDiamond(cell.p, 3);  break;
            case BD.Entity.EXPLODETODIAMOND4: this.updateExplodeToDiamond(cell.p, 4);  break;
            case BD.Entity.AMOEBA:            this.updateAmoeba(cell.p);               break;
            case BD.Entity.PREOUTBOX:         this.updatePreOutbox(cell.p);            break;
          }
        }
      });
      this.endFrame();
    },

    decreaseTimer: function(n) {
      this.timer = Math.max(0, this.timer - (n || 1));
      this.publish('timer', this.timer);
      return (this.timer === 0);
    },

    autoDecreaseTimer: function() {
      if ((this.frame > this.birth) && ((this.frame % this.fps) == 0))
        this.decreaseTimer(1);
    },

    runOutTimer: function() {
      var amount = Math.min(3, this.timer);
      this.increaseScore(amount);
      if (this.decreaseTimer(amount))
        this.next();
    },

    collectDiamond: function() {
      this.diamonds.collected++;
      this.increaseScore(this.diamonds.collected > this.diamonds.needed ? this.diamonds.extra : this.diamonds.value);
      this.publish('diamond', this.diamonds);
    },

    increaseScore: function(n) {
      this.score += n;
      this.publish('score', this.score);
    },

    flashWhenEnoughDiamondsCollected: function() {
      if (!this.flash && (this.diamonds.collected >= this.diamonds.needed))
        this.flash = this.frame + Math.round(this.fps/5); // flash for 1/5th of a second 
      if (this.frame <= this.flash)
        this.publish('flash');
    },

    loseLevel: function() {
      this.reset();
    },

    winLevel: function() {
      this.won = true;
    },

    beginFrame: function() {
      this.frame++;
      this.amoeba.size     = 0;
      this.amoeba.enclosed = true;
      this.idle = this.moving.dir ? {} : {
        blink: (randomInt(1,4)==1)  ? !this.idle.blink : this.idle.blink,
        tap:   (randomInt(1,16)==1) ? !this.idle.tap   : this.idle.tap
      }
    },

    endFrame: function() {
      if (!this.amoeba.dead) {
        if (this.amoeba.enclosed)
          this.amoeba.dead = BD.Entity.DIAMOND;
        else if (this.amoeba.size > this.amoeba.max)
          this.amoeba.dead = BD.Entity.BOULDER;
        else if (this.amoeba.slow > 0)
          this.amoeba.slow--;
      }
      this.magic.active = this.magic.active && (--this.magic.time > 0);
      this.flashWhenEnoughDiamondsCollected();
      if (this.won)
        this.runOutTimer();
      else if (this.frame - this.foundRockford > (4 * this.fps))
        this.loseLevel();
      else
        this.autoDecreaseTimer();
    },

    updatePreRockford: function(p, n) {
      if (this.frame >= this.birth)
        this.set(p, PREROCKFORDS[n+1]);
    },

    updatePreOutbox: function(p) {
      if (this.diamonds.collected >= this.diamonds.needed)
        this.set(p, BD.Entity.OUTBOX);
    },

    updateRockford: function(p, dir) {
      this.foundRockford = this.frame;
      if (this.won) {
        // do nothing -  dont let rockford move if he already found the outbox
      }
      else if (this.timer === 0) {
        this.explode(p);
      }
      else if (this.moving.grab) {
        if (this.isdirt(p, dir)) {
          this.clear(p, dir);
        }
        else if (this.isdiamond(p,dir) || this.isfallingdiamond(p, dir)) {
          this.clear(p, dir);
          this.collectDiamond();
        }
        else if (BD.horizontal(dir) && this.isboulder(p, dir)) {
          this.push(p, dir);
        }
      }
      else if (this.isempty(p, dir) || this.isdirt(p, dir)) {
        this.move(p, dir, BD.Entity.ROCKFORD);
      }
      else if (this.isdiamond(p, dir)) {
        this.move(p, dir, BD.Entity.ROCKFORD);
        this.collectDiamond();
      }
      else if (BD.horizontal(dir) && this.isboulder(p, dir)) {
        this.push(p, dir);
      }
      else if (this.isoutbox(p, dir)) {
        this.move(p, dir, BD.Entity.ROCKFORD);
        this.winLevel();
      }
    },

    updateBoulder: function(p) {
      if (this.isempty(p, BD.DIR.DOWN))
        this.set(p, BD.Entity.BOULDERFALLING);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.LEFT) && this.isempty(p, BD.DIR.DOWNLEFT))
        this.move(p, BD.DIR.LEFT, BD.Entity.BOULDERFALLING);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.RIGHT) && this.isempty(p, BD.DIR.DOWNRIGHT))
        this.move(p, BD.DIR.RIGHT, BD.Entity.BOULDERFALLING);
    },

    updateBoulderFalling: function(p) {
      if (this.isempty(p, BD.DIR.DOWN))
        this.move(p, BD.DIR.DOWN, BD.Entity.BOULDERFALLING);
      else if (this.isexplodable(p, BD.DIR.DOWN))
        this.explode(p, BD.DIR.DOWN);
      else if (this.ismagic(p, BD.DIR.DOWN))
        this.domagic(p, BD.Entity.DIAMOND);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.LEFT) && this.isempty(p, BD.DIR.DOWNLEFT))
        this.move(p, BD.DIR.LEFT, BD.Entity.BOULDERFALLING);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.RIGHT) && this.isempty(p, BD.DIR.DOWNRIGHT))
        this.move(p, BD.DIR.RIGHT, BD.Entity.BOULDERFALLING);
      else
        this.set(p, BD.Entity.BOULDER);
    },

    updateDiamond: function(p) {
      if (this.isempty(p, BD.DIR.DOWN))
        this.set(p, BD.Entity.DIAMONDFALLING);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.LEFT) && this.isempty(p, BD.DIR.DOWNLEFT))
        this.move(p, BD.DIR.LEFT, BD.Entity.DIAMONDFALLING);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.RIGHT) && this.isempty(p, BD.DIR.DOWNRIGHT))
        this.move(p, BD.DIR.RIGHT, BD.Entity.DIAMONDFALLING);
    },

    updateDiamondFalling: function(p) {
      if (this.isempty(p, BD.DIR.DOWN))
        this.move(p, BD.DIR.DOWN, BD.Entity.DIAMONDFALLING);
      else if (this.isexplodable(p, BD.DIR.DOWN))
        this.explode(p, BD.DIR.DOWN);
      else if (this.ismagic(p, BD.DIR.DOWN))
        this.domagic(p, BD.Entity.BOULDER);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.LEFT) && this.isempty(p, BD.DIR.DOWNLEFT))
        this.move(p, BD.DIR.LEFT, BD.Entity.DIAMONDFALLING);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.RIGHT) && this.isempty(p, BD.DIR.DOWNRIGHT))
        this.move(p, BD.DIR.RIGHT, BD.Entity.DIAMONDFALLING);
      else
        this.set(p, BD.Entity.DIAMOND);
    },

    updateFirefly: function(p, dir) {
      var newdir = BD.rotateLeft(dir);
      if (this.isrockford(p, BD.DIR.UP) || this.isrockford(p, BD.DIR.DOWN) || this.isrockford(p, BD.DIR.LEFT) || this.isrockford(p, BD.DIR.RIGHT))
        this.explode(p);
      else if (this.isamoeba(p, BD.DIR.UP) || this.isamoeba(p, BD.DIR.DOWN) || this.isamoeba(p, BD.DIR.LEFT) || this.isamoeba(p, BD.DIR.RIGHT))
        this.explode(p);
      else if (this.isempty(p, newdir))
        this.move(p, newdir, FIREFLIES[newdir]);
      else if (this.isempty(p, dir))
        this.move(p, dir, FIREFLIES[dir]);
      else
        this.set(p, FIREFLIES[BD.rotateRight(dir)]);
    },

    updateButterfly: function(p, dir) {
      var newdir = BD.rotateRight(dir);
      if (this.isrockford(p, BD.DIR.UP) || this.isrockford(p, BD.DIR.DOWN) || this.isrockford(p, BD.DIR.LEFT) || this.isrockford(p, BD.DIR.RIGHT))
        this.explode(p);
      else if (this.isamoeba(p, BD.DIR.UP) || this.isamoeba(p, BD.DIR.DOWN) || this.isamoeba(p, BD.DIR.LEFT) || this.isamoeba(p, BD.DIR.RIGHT))
        this.explode(p);
      else if (this.isempty(p, newdir))
        this.move(p, newdir, BUTTERFLIES[newdir]);
      else if (this.isempty(p, dir))
        this.move(p, dir, BUTTERFLIES[dir]);
      else
        this.set(p, BUTTERFLIES[BD.rotateLeft(dir)]);
    },

    updateExplodeToSpace: function(p, n) {
      this.set(p, EXPLODETOSPACE[n+1]);
    },

    updateExplodeToDiamond: function(p, n) {
      this.set(p, EXPLODETODIAMOND[n+1]);
    },

    updateAmoeba: function(p) {
      if (this.amoeba.dead) {
        this.set(p, this.amoeba.dead);
      }
      else {
        this.amoeba.size++;
        if (this.isempty(p, BD.DIR.UP) || this.isempty(p, BD.DIR.DOWN) || this.isempty(p, BD.DIR.RIGHT) || this.isempty(p, BD.DIR.LEFT) ||
            this.isdirt(p,  BD.DIR.UP) || this.isdirt(p,  BD.DIR.DOWN) || this.isdirt(p,  BD.DIR.RIGHT) || this.isdirt(p,  BD.DIR.LEFT)) {
          this.amoeba.enclosed = false;
        }
        if (this.frame >= this.birth) {
          var grow = this.amoeba.slow ? (randomInt(1, 128) < 4) : (randomInt(1, 4) == 1);
          var dir  = randomChoice([BD.DIR.UP, BD.DIR.DOWN, BD.DIR.LEFT, BD.DIR.RIGHT]);
          if (grow && (this.isdirt(p, dir) || this.isempty(p, dir)))
            this.set(p, BD.Entity.AMOEBA, dir);
        }
      }
    },

    explode: function(p, dir) {
      var p2        = new BD.Point(p.x, p.y, dir);
      var explosion = (this.isbutterfly(p2) ? BD.Entity.EXPLODETODIAMOND0 : BD.Entity.EXPLODETOSPACE0);
      this.set(p2, explosion);
      for(dir = 0 ; dir < 8 ; ++dir) { // for each of the 8 directions
        if (this.isexplodable(p2, dir))
          this.explode(p2, dir);
        else if (this.isconsumable(p2, dir))
          this.set(p2, explosion, dir);
      }
    },

    push: function(p, dir) {
      p2 = new BD.Point(p.x, p.y, dir);
      if (this.isempty(p2, dir)) {
        if (randomInt(1,8) == 1) {
          this.move(p2, dir, BD.Entity.BOULDER);
          if (!this.moving.grab)
            this.move(p, dir, BD.Entity.ROCKFORD);
        }
      }
    },

    domagic: function(p, to) {
      if (this.magic.time > 0) {
        this.magic.active = true;
        this.clear(p);
        var p2 = new BD.Point(p.x, p.y + 2);
        if (this.isempty(p2))
          this.set(p2, to);
      }
    },

    subscribe: function(event, callback, target) {
      this.subscribers = this.subscribers || {};
      this.subscribers[event] = this.subscribers[event] || [];
      this.subscribers[event].push({ callback: callback, target: target });
    },

    publish: function(event) {
      if (this.subscribers && this.subscribers[event]) {
        var subs = this.subscribers[event];
        var args = [].slice.call(arguments, 1);
        var n, sub;
        for(n = 0 ; n < subs.length ; ++n) {
          sub = subs[n];
          sub.callback.apply(sub.target, args);
        }
      }
    }

};



Boulderdash = function() {

  //=========================================================================
  // GENERAL purpose constants and helper methods
  //=========================================================================

  var KEY = BD.KEY;

  var Dom = BD.Dom;

  var DIR  = BD.DIR;
  var DIRX = BD.DIRX;
  var DIRY = BD.DIRY;

  function rotateLeft(dir)  { return (dir-2) + (dir < 2 ? 8 : 0); };
  function rotateRight(dir) { return (dir+2) - (dir > 5 ? 8 : 0); };
  function horizontal(dir)  { return (dir === DIR.LEFT) || (dir === DIR.RIGHT); };
  function vertical(dir)    { return (dir === DIR.UP)   || (dir === DIR.DOWN);  };

  //-------------------------------------------------------------------------

  var Entity = BD.Entity;
 
  for(var key in Entity) {
    Entity[key].name = key;                 // give it a human friendly name
    Entity[Entity[key].code] = Entity[key]; // and allow lookup by code
  }

  function isFirefly(o)   { return (Entity.FIREFLY1.code     <= o.code) && (o.code <= Entity.FIREFLY4.code);   }
  function isButterfly(o) { return (Entity.BUTTERFLY1.code   <= o.code) && (o.code <= Entity.BUTTERFLY4.code); }

  //----------------------------------------------------------------------------

  //=========================================================================
  // GAME LOGIC
  //=========================================================================

  var Game = BD.Game;

  var moving = {
    dir:      DIR.NONE,
    lastXDir: DIR.NONE,
    up: false, down: false, left: false, right: false, grab: false,
    startUp:    function() { this.up    = true; this.dir = DIR.UP;   },
    startDown:  function() { this.down  = true; this.dir = DIR.DOWN; },
    startLeft:  function() { this.left  = true; this.dir = DIR.LEFT;  this.lastXDir = DIR.LEFT;  },
    startRight: function() { this.right = true; this.dir = DIR.RIGHT; this.lastXDir = DIR.RIGHT; },
    startGrab:  function() { this.grab  = true; },
    stopUp:     function() { this.up    = false; this.dir = (this.dir == DIR.UP)    ? this.where() : this.dir; },
    stopDown:   function() { this.down  = false; this.dir = (this.dir == DIR.DOWN)  ? this.where() : this.dir; },
    stopLeft:   function() { this.left  = false; this.dir = (this.dir == DIR.LEFT)  ? this.where() : this.dir; },
    stopRight:  function() { this.right = false, this.dir = (this.dir == DIR.RIGHT) ? this.where() : this.dir; },
    stopGrab:   function() { this.grab  = false; },
    where: function() {
      if (this.up)
        return DIR.UP;
      else if (this.down)
        return DIR.DOWN;
      else if (this.left)
        return DIR.LEFT;
      else if (this.right)
        return DIR.RIGHT;
    }
  }

  //=========================================================================
  // GAME LOOP
  //=========================================================================

  var game   = new Game(moving),       // the boulderdash game logic (rendering independent)
      render = new BD.Render(game, moving), // the boulderdash game renderer
      stats  = new Stats();      // the FPS counter widget

  //-------------------------------------------------------------------------

  function run() {

    var now, last = timestamp(), dt = 0, gdt = 0, rdt = 0;
    function frame() {
      now = timestamp();
      dt  = Math.min(1, (now - last) / 1000); // using requestAnimationFrame have to be able to handle large delta's caused when it 'hibernates' in a background or non-visible tab
      gdt = gdt + dt;
      while (gdt > game.step) {
        gdt = gdt - game.step;
        game.update();
      }
      rdt = rdt + dt;
      if (rdt > render.step) {
        rdt = rdt - render.step;
        render.update();
      }
      stats.update();
      last = now;
      requestAnimationFrame(frame, render.canvas);
    }

    load(function(sprites) {
      render.reset(sprites); // reset the canvas renderer with the loaded sprites <IMG>
      game.reset();          // reset the game
      addEvents();           // attach keydown and resize event handlers
      showStats();           // initialize FPS counter
      frame();               //  ... and start the first frame !
    });

  };

  function load(cb) {
    var sprites = document.createElement('img');
    sprites.addEventListener('load', function() { cb(sprites); } , false);
    sprites.src = 'images/sprites.png';
  };

  function showStats() {
    stats.domElement.id = 'stats';
    Dom.get('boulderdash').appendChild(stats.domElement);
  };

  function addEvents() {
    document.addEventListener('keydown', keydown, false);
    document.addEventListener('keyup',   keyup,   false);
    window.addEventListener('resize', function() { render.resize() }, false);
    Dom.get('prev').addEventListener('click', function() { game.prev(); }, false);
    Dom.get('next').addEventListener('click', function() { game.next(); }, false);
  };

  function keydown(ev) {
    var handled = false;
    switch(ev.keyCode) {
      case KEY.UP:         moving.startUp();    handled = true; break;
      case KEY.DOWN:       moving.startDown();  handled = true; break;
      case KEY.LEFT:       moving.startLeft();  handled = true; break;
      case KEY.RIGHT:      moving.startRight(); handled = true; break;
      case KEY.ESC:        game.reset();        handled = true; break;
      case KEY.PAGEUP:     game.prev();         handled = true; break;
      case KEY.PAGEDOWN:   game.next();         handled = true; break;
      case KEY.SPACE:      moving.startGrab();  handled = true; break;
    }
    if (handled)
      ev.preventDefault(); // prevent arrow keys from scrolling the page (supported in IE9+ and all other browsers)
  }

  function keyup(ev) {
    switch(ev.keyCode) {
      case KEY.UP:    moving.stopUp();    handled = true; break;
      case KEY.DOWN:  moving.stopDown();  handled = true; break;
      case KEY.LEFT:  moving.stopLeft();  handled = true; break;
      case KEY.RIGHT: moving.stopRight(); handled = true; break;
      case KEY.SPACE: moving.stopGrab(); handled = true; break;
    }
  }

  //---------------------------------------------------------------------------

  run.game   = game;   // debug access using Boulderdash.game
  run.render = render; // debug access using Boulderdash.render

  return run;

}();

