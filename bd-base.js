
BD = {};

BD.extend({
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

for(var key in BD.Entity) {
    BD.Entity[key].name = key;                 // give it a human friendly name
    BD.Entity[BD.Entity[key].code] = BD.Entity[key]; // and allow lookup by code
};

FIREFLIES = [];
FIREFLIES[BD.DIR.LEFT]  = BD.Entity.FIREFLY1;
FIREFLIES[BD.DIR.UP]    = BD.Entity.FIREFLY2;
FIREFLIES[BD.DIR.RIGHT] = BD.Entity.FIREFLY3;
FIREFLIES[BD.DIR.DOWN]  = BD.Entity.FIREFLY4;

BUTTERFLIES = [];
BUTTERFLIES[BD.DIR.LEFT]  = BD.Entity.BUTTERFLY1;
BUTTERFLIES[BD.DIR.UP]    = BD.Entity.BUTTERFLY2;
BUTTERFLIES[BD.DIR.RIGHT] = BD.Entity.BUTTERFLY3;
BUTTERFLIES[BD.DIR.DOWN]  = BD.Entity.BUTTERFLY4;

PREROCKFORDS = [
  BD.Entity.PREROCKFORD1,
  BD.Entity.PREROCKFORD2,
  BD.Entity.PREROCKFORD3,
  BD.Entity.PREROCKFORD4,
  BD.Entity.ROCKFORD
];

EXPLODETOSPACE = [
  BD.Entity.EXPLODETOSPACE0,
  BD.Entity.EXPLODETOSPACE1,
  BD.Entity.EXPLODETOSPACE2,
  BD.Entity.EXPLODETOSPACE3,
  BD.Entity.EXPLODETOSPACE4,
  BD.Entity.SPACE
];

EXPLODETODIAMOND = [
  BD.Entity.EXPLODETODIAMOND0,
  BD.Entity.EXPLODETODIAMOND1,
  BD.Entity.EXPLODETODIAMOND2,
  BD.Entity.EXPLODETODIAMOND3,
  BD.Entity.EXPLODETODIAMOND4,
  BD.Entity.DIAMOND
];
