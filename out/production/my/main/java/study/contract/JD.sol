pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;


contract Merchant_status{
    function M_listen() public;
    function M_Wait_Ack() public;
    function M_Wait_Ec() public;
    function M_Ack_Con() public;
    function M_Suc() public;
    function M_Busy() public;
    function M_Abort() public;

    function C_init() public;
    function C_Resp_Wait() public;
    function C_Goods_Wait() public;
    function C_Receipt_Wait () public;
    function C_Suc() public;
    function C_Abort() public;

    function setState(State state) public;
}

contract State{

}

contract E_Shopping {

    enum Customer_status{C_init, C_Resp_Wait, C_Goods_Wait, C_Receipt_Wait, C_Suc, C_Abort}
    enum Merchant_status{M_listen, M_Wait_Ack, M_Wait_Ec, M_Ack_Con, M_Suc, M_Busy, M_Abort }

    event ShoppingRequest(address indexed from, uint256 commodityId, address indexed to);
    event CanShopping(address indexed from, uint totalprice, address indexed to);
    event QuitShopping(address indexed from, address indexed to);
    event SureShopping(address indexed from, address indexed to);
    event Transfer (address indexed from,address indexed to, uint256 value);
    event Transport(address indexed from,address indexed to);
    event Reception(address indexed from,address indexed to);
    event SendList(address indexed from,address indexed to);
    event GetList(address indexed from,address indexed to, bool get);

    address public merchantAddress;
    address public customerAddress;
    address public contractAddress;

    uint public contract_account;
    uint public customer_account;
    uint public merchant_account;
    uint public per_price;
    uint public totalprice;

    Merchant_status public merchant_status;
    Customer_status public customer_status;


    // modifier onlyMerchant{
    //     require(msg.sender == merchantAddress);
    //     _;
    // }



    constructor(address _merchantAddress, address _customerAddress, address _contractAddress,
        uint _cAccount, uint _mAccount, uint _contractAccount, uint _perprice){
        merchantAddress = _merchantAddress;
        customerAddress = _customerAddress;
        contractAddress = _contractAddress;
        customer_account = _cAccount;
        merchant_account = _mAccount;
        contract_account = _contractAccount;
        per_price = _perprice;
    }

    struct Commodity{
        uint256 commodityId;
        //uint256 amount;
    }

    function newProduct(uint256 commodityID) returns(bool,string){
        Commodity commodity = commodityMap[commodityID];
        if(commodity.commodityId != 0x0) {
            return (false,"The commodityID already exist!");
        }
        commodity.commodityId = commodityID;
        return (true,"Success,produce a new product");

    }


    //mapping (address => Customer) public customerMap;
    mapping (uint256 => Commodity) public commodityMap;
    mapping (address =>uint) private balanceOf;



    function shopping_Request(uint256 _commodityId)
    public
    returns (bool,address, uint256, Merchant_status, Customer_status){

        customer_status = Customer_status.C_init;
        merchant_status  = Merchant_status.M_listen;

        require(customerAddress != address(0));
        require(merchantAddress != address(0));

        Commodity storage commodity = commodityMap[_commodityId];
        require(commodity.commodityId != 0);

        emit ShoppingRequest(customerAddress, _commodityId, merchantAddress);
        return(true, customerAddress, _commodityId, merchant_status, customer_status);
    }


    function can_Shopping(uint256 _commodityId)public
    returns (uint, Merchant_status, Customer_status)
    {

        require(merchant_status == Merchant_status.M_listen);
        require(customer_status == Customer_status.C_init);
        require(customerAddress != address(0));
        require(merchantAddress != address(0));


        Commodity commodity = commodityMap[_commodityId];
        require(commodity.commodityId != 0);

        emit CanShopping(merchantAddress,totalprice, customerAddress);

        customer_status = Customer_status.C_Resp_Wait;
        //merchant_status  = Merchant_status.M_listen;
        return(totalprice, merchant_status, customer_status);

    }

    function sure_Shopping(uint256 _commodityId, uint _amount) public
    returns (bool, Merchant_status, Customer_status, address){

        require(merchant_status == Merchant_status.M_listen);
        require(customer_status == Customer_status.C_Resp_Wait);

        require(merchantAddress != address(0));
        require(customerAddress != address(0));

        Commodity commodity = commodityMap[_commodityId];
        require(commodity.commodityId != 0);

        totalprice = _amount * per_price;

        emit SureShopping(customerAddress, merchantAddress);

        customer_status = Customer_status.C_Goods_Wait;
        merchant_status  = Merchant_status.M_Wait_Ack;

        return (true, merchant_status, customer_status, customerAddress);

    }

    function quit_Shopping(uint256 _commodityId)public
    returns (bool, Merchant_status, Customer_status, address){

        require(merchant_status == Merchant_status.M_listen);
        require(customer_status == Customer_status.C_Resp_Wait);

        require(merchantAddress != address(0));
        require(customerAddress != address(0));

        Commodity commodity = commodityMap[_commodityId];
        require(commodity.commodityId != 0);

        emit QuitShopping(customerAddress, merchantAddress);

        customer_status = Customer_status.C_Resp_Wait;
        merchant_status  = Merchant_status.M_Wait_Ack;

        return (false, merchant_status, customer_status, customerAddress);

    }

    function transfer(uint256 _commodityId) public
    returns(bool, uint, Merchant_status, Customer_status){

        require(merchant_status == Merchant_status.M_Wait_Ack);
        require(customer_status == Customer_status.C_Goods_Wait);

        require(contractAddress != address(0));//防止转账给0x0地址
        require(contractAddress != address(this));
        //require(contractAddress == contractAddress);
        Commodity commodity = commodityMap[_commodityId];
        require(commodity.commodityId != 0);

        // customer_account = balanceOf[customerAddress];
        //contract_account = balanceOf[contractAddress];

        require(customer_account >= totalprice);//检查发送者账户中余额是否充足
        require(contract_account + totalprice >= contract_account);//检查是否溢出

        customer_account -= totalprice;//从发送者账户减去发送金额
        contract_account += totalprice;//在接受者账户中加上发送额

        emit Transfer(customerAddress, contractAddress, totalprice);//提示发送操作已发生

        //customer_status = Customer_status.C_Resp_Wait;
        merchant_status  = Merchant_status.M_Wait_Ec;
        return(true, totalprice, merchant_status, customer_status);
    }

    function reception(uint256 _commodityId)
    returns (bool, Merchant_status, Customer_status){

        require(merchant_status == Merchant_status.M_Wait_Ec);
        require(customer_status == Customer_status.C_Goods_Wait);

        require(merchantAddress != address(0));
        require(customerAddress != address(0));

        Commodity storage commodity = commodityMap[_commodityId];
        require(commodity.commodityId != 0);

        emit Reception(customerAddress, merchantAddress);

        customer_status = Customer_status.C_Receipt_Wait;
        //merchant_status  = Merchant_status.M_Wait_Ec;
        return (true, merchant_status, customer_status);

    }


    function sendList(uint256 _commodityId)
    returns (bool, Merchant_status _mstatus, Customer_status _cstatus){
        require(merchant_status == Merchant_status.M_Wait_Ec);
        require(customer_status == Customer_status.C_Receipt_Wait);

        require(merchantAddress != address(0));
        require(customerAddress != address(0));

        Commodity storage commodity = commodityMap[_commodityId];
        require(commodity.commodityId != 0);

        emit SendList(merchantAddress, customerAddress);

        //customer_status = Customer_status.C_Receipt_Wait;
        merchant_status  = Merchant_status.M_Ack_Con;

        return (true, merchant_status, customer_status);
    }


    function getList(uint256 _commodityId)
    returns (bool, Merchant_status, Customer_status){
        require(merchant_status == Merchant_status.M_Ack_Con);
        require(customer_status == Customer_status.C_Receipt_Wait);

        require( merchantAddress != address(0));
        require(customerAddress != address(0));

        emit GetList(merchantAddress, customerAddress, true);

        customer_status = Customer_status.C_Suc;
        //merchant_status  = Merchant_status.M_Suc;
        return (true, merchant_status, customer_status);
    }

    function withdrawBalance()
    returns (bool, uint, address,Merchant_status, Customer_status){

        require(merchant_status == Merchant_status.M_Ack_Con);
        require(customer_status == Customer_status.C_Suc);
        require(contractAddress != address(0));
        require(merchantAddress != address(0));

        require(merchantAddress != address(this));
        contract_account -= totalprice;//从发送者账户减去发送金额
        merchant_account += totalprice;
        emit Transfer(contractAddress, merchantAddress, totalprice);

        merchant_status  = Merchant_status.M_Suc;
        return(true, merchant_account, address(this),merchant_status, customer_status);
    }




}