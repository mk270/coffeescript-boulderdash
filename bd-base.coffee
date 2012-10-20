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

