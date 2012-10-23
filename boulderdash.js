

Boulderdash = function() {


  timestamp = function() {
    return new Date().getTime();
  };

  //=========================================================================
  // GENERAL purpose constants and helper methods
  //=========================================================================

  var KEY = { ENTER: 13, ESC: 27, SPACE: 32, PAGEUP: 33, PAGEDOWN: 34, LEFT: 37, UP: 38, RIGHT: 39, DOWN: 40 };

  var Dom = BD.Dom;

  var DIR  = BD.DIR;

  //-------------------------------------------------------------------------

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

