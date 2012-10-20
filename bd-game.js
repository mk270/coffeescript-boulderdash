
// known physics bugs:
//  rocks are too eager to explode flies, partic in the "just started to fall" state and rolloffs
//  you can touch flies - the check for explode is in the wrong place / depends on fly movement
//  boulders on enchanted walls seem to be jammed in falling state


random = function(min, max) {
    return min + (Math.random() * (max - min));
  };

randomInt = function(min, max) {
    return Math.floor(random(min, max));
  };

randomChoice = function(choices) {
    return choices[Math.round(random(0, choices.length - 1))];
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
    isvulnerable: function(p,dir)   { var o = this.get(p,dir); return o.vulnerable;           },
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
        this.set(p, BD.Sequences.PREROCKFORDS[n+1]);
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

    updateRock: function(p, rock) {
	  if (this.isempty(p, BD.DIR.DOWN))
        this.set(p, rock);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.LEFT) && this.isempty(p, BD.DIR.DOWNLEFT))
        this.move(p, BD.DIR.LEFT, rock);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.RIGHT) && this.isempty(p, BD.DIR.DOWNRIGHT))
        this.move(p, BD.DIR.RIGHT, rock);
	},

    updateRockFalling: function(p, rock, rockAtRest, convertedRock) {
      if (this.isempty(p, BD.DIR.DOWN))
        this.move(p, BD.DIR.DOWN, rock);
      else if (this.isvulnerable(p, BD.DIR.DOWN))
        this.explode_dir(p, BD.DIR.DOWN);
      else if (this.ismagic(p, BD.DIR.DOWN))
        this.domagic(p, convertedRock);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.LEFT) && this.isempty(p, BD.DIR.DOWNLEFT))
        this.move(p, BD.DIR.LEFT, rock);
      else if (this.isrounded(p, BD.DIR.DOWN) && this.isempty(p, BD.DIR.RIGHT) && this.isempty(p, BD.DIR.DOWNRIGHT))
        this.move(p, BD.DIR.RIGHT, rock);
      else
        this.set(p, rockAtRest);
    },

    updateBoulder: function(p) {
	  return this.updateRock(p, BD.Entity.BOULDERFALLING);
    },

    updateDiamond: function(p) {
	  return this.updateRock(p, BD.Entity.DIAMONDFALLING);
    },

    updateBoulderFalling: function(p) {
	  return this.updateRockFalling(p, BD.Entity.BOULDERFALLING, BD.Entity.BOULDER, BD.Entity.DIAMOND);
    },

    updateDiamondFalling: function(p) {
	  return this.updateRockFalling(p, BD.Entity.DIAMONDFALLING, BD.Entity.DIAMOND, BD.Entity.BOULDER);
    },

    adjacent: function(p, fn) {
	  var dirs = [ BD.DIR.UP, BD.DIR.DOWN, BD.DIR.LEFT, BD.DIR.RIGHT ];

	  for(var i = 0; i < dirs.length; i++) {
		if(fn(p, dirs[i]))
		  return true;
	  }
	  return false;
	},

    updateFly: function(p, dir, newdir, olddir, phases) {
	  var self = this;

	  var by_rockford = function(p, d) { return self.isrockford(p, d); };
	  var by_amoeba   = function(p, d) { return self.isamoeba(p, d); };

	  if(this.adjacent(p, by_rockford) || this.adjacent(p, by_amoeba)) {
		this.explode(p);
		return;
	  }

	  if (this.isempty(p, newdir))
        this.move(p, newdir, phases[newdir]);
      else if (this.isempty(p, dir))
        this.move(p, dir, phases[dir]);
      else
        this.set(p, phases[olddir]);
	},

    updateFirefly: function(p, dir) {
      var newdir = BD.rotateLeft(dir);
	  var olddir = BD.rotateRight(dir);
	  var phases = BD.Sequences.FIREFLIES;
	  this.updateFly(p, dir, newdir, olddir, phases);
    },

    updateButterfly: function(p, dir) {
      var newdir = BD.rotateRight(dir);
	  var olddir = BD.rotateLeft(dir);
	  var phases = BD.Sequences.BUTTERFLIES;
	  this.updateFly(p, dir, newdir, olddir, phases);
    },

    updateExplodeToSpace: function(p, n) {
      this.set(p, BD.Sequences.EXPLODETOSPACE[n+1]);
    },

    updateExplodeToDiamond: function(p, n) {
      this.set(p, BD.Sequences.EXPLODETODIAMOND[n+1]);
    },

    updateAmoeba: function(p) {
      if (this.amoeba.dead) {
        this.set(p, this.amoeba.dead);
      }
      else {
		var self = this;
		var by_empty = function(p, d) { return self.isempty(p, d); };
		var by_dirt  = function(p, d) { return self.isdirt(p, d); };
        this.amoeba.size++;
        if (this.adjacent(p, by_empty) || this.adjacent(p, by_dirt)) {
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

    explode: function(p) {
      var explosion = (this.isbutterfly(p) ? BD.Entity.EXPLODETODIAMOND0 : BD.Entity.EXPLODETOSPACE0);
      this.set(p, explosion);
      for(dir = 0 ; dir < 8 ; ++dir) { // for each of the 8 directions
        if (this.isexplodable(p, dir))
          this.set(p, explosion, dir);
      }
    },

    explode_dir: function(p, dir) {
	  var p2 = new BD.Point(p.x, p.y, dir);
	  this.explode(p2);
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
