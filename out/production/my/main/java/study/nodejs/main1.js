var fs = require("fs");
//异步
fs.readFile('input.txt', function (err, data) {
    if(err)
        return console.error(err);
    console.log(data.toString());
} );

console.log("end");
