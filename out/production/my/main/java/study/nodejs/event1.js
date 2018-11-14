var EventEmitter = require('events').EventEmitter;

var event = new EventEmitter();
event.on('some_event', function () {
    console.log('事件触发');
});

setTimeout(function () {
    event.emit('some_event');
}, 5000);