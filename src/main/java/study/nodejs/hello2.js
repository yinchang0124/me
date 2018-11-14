function hhh() {
    var name;
    this.setName = function(tName)
    {
        name = tName;
    };

    this.sayHello = function()
    {
        console.log('hi' + ',' + name);
    };
};

module.exports = hhh;