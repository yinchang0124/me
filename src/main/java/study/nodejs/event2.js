var events = require('events');

var emitter = new events.EventEmitter();
emitter.on('someEvent', function (a, b) {
    console.log('listener1', a, b);
});


emitter.on('someEvent', function (c,d) {
    console.log('listener2', c,d);
});

emitter.emit('someEvent', '1111', '2111');