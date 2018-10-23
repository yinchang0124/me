var vm =new Vue({
    el : '#main',
    data: {
        status: false,
        msg: "",
        result: {}
    }
})


$("#btnS").click(function(){
    var searchId =  $("#searchId").val();
    $.getJSON("http://localhost:8080/searchid?id="+searchId, function (result, status) {
        vm.status = result.status;
        vm.msg = result.msg;
        vm.result = result.data;
    })
});