var fs = require("fs");
//同步
var data = fs.readFileSync('input.txt');
console.log(data.toString());
console.log('end');
console.log( __filename );