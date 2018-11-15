var express = require('express');

var app = express();

app.get('/', function (req, res) {
    console.log('主页get请求');
    res.send('hello get');
});

app.post('/', function (req, res) {
    console.log('post请求');
    res.send('hello post');
});

app.get('/del', function (req, res) {
    console.log('/del_user 响应 DELETE 请求');
    res.send('delete');
});

app.get('/list', function (req, res) {
    console.log('list get请求');
    res.send('list');
});

app.get('/ab*cd', function (req, res) {
    console.log('abcd get')
    res.send('正则匹配');
});


var server = app.listen(8081, function () {
    var host = server.address().address;
    var port = server.address().port;

    console.log('地址为 http://%s:%s', host, port)

})