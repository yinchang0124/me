var express = require('express');
var app = express();

app.use(express.static('images'));
app.get('/', function (req, res) {
    res.send('hello');
});

var server = app.listen(8081, function () {
    var host = server.address().address;
    var port = server.address().port;

    console.log('地址 http://%s:%s', host, port);
})