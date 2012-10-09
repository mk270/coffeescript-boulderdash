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
