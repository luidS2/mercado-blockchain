pragma solidity ^0.5.0;

contract Marketplace {
  string public name;
  uint public productCount=0;
  mapping(uint => Product) public products;
  address payable ownerContract;
  
struct Product {
  uint id;
  string name;
  uint price;
  address payable owner;
  bool purchased;
  bool sale;
}

event ProductCreated (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool purchased,
  bool sale
);

event ProductPurchased (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool purchased,
  bool sale
);

event ProductChanged (
  uint id,                                                         
  string name,                                                     
  uint price,                                                      
  address payable owner,                                           
  bool purchased,                                                  
  bool sale 
);

event ProductForSale (  
  uint id,              
  string name,          
  uint price,           
  address payable owner,
  bool purchased,       
  bool sale             
);

  constructor(address payable _ownerContract) public {
    name = "Dapp University Marketplace";
    ownerContract = _ownerContract;
  }

  function createProduct(string memory _name, uint _price) public {
    //Require a name
    require(bytes(_name).length > 0, "Enter a valid name");
    //Requiere a valid price
    require(_price > 0, "Enter a valid price");
    //Increment product count
    productCount++;
    //Create the product
    products[productCount] = Product(productCount, _name, _price, msg.sender, false, true);
    //Trigger an event
    emit ProductCreated(productCount, _name, _price, msg.sender, false, true);
  }

  function purchaseProduct(uint _id) public payable {
    //Fetch the product and make a copy of it
    Product memory _product = products[_id];
    //Fetch the owner
    address payable _seller = _product.owner;
    //Make sure the product has valid id
    require(_product.id > 0 && _product.id <= productCount, "Enter valid id");
    //Require that there is enough Ether in the transaction
    require(msg.value >= _product.price,"Transfer the correct amount");
    //Require that the product has not been purchased already
    require(!_product.purchased, "Product has been purchased");
    //Require that the buyer is not the seller
    require(msg.sender != _seller, "Buyer cannot be seller");    
    //Transfer ownership to the buyer
    _product.owner = msg.sender;
    //Mark as purchased
    _product.purchased = true;
    //Update the product
    products[_id] = _product;
    //Pay the seller by sending them Ether
    address(_seller).transfer(msg.value * 95/100);
    //Pay 5% for owner 
    address(ownerContract).transfer(msg.value * 5/100);
    //Trigger an event
    emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true, _product.sale);
  }

 function changeProduct(uint _id, string memory _name, uint _price) public {
   //Fetch the product and make a copy of it                                              
   Product memory _product = products[_id];  
   //Make sure the product has valid id                                                   
   require(_product.id > 0 && _product.id <= productCount, "Enter valid id");
   //Require owner product
   require(msg.sender == _product.owner, "Is not owner the product ");  
   //Require a name                                                                       
   require(bytes(_name).length > 0, "Enter a valid name");                                
   //Requiere a valid price                                                               
   require(_price > 0, "Enter a valid price");          
   //Change the product
   products[_id] = Product(_id, _name, _price, _product.owner, _product.purchased, _product.sale);
   //Trigger an event                                                                     
   emit ProductChanged(_id, _name, _price, _product.owner, _product.purchased, _product.sale);             
 }    

 function forSale(uint _id, bool _sale) public {
   //Fetch the product and make a copy of it                                                            
   Product memory _product = products[_id];                                                             
   //Make sure the product has valid id                                                                 
   require(_product.id > 0 && _product.id <= productCount, "Enter valid id"); 
   //Require owner product                                                                              
   require(msg.sender == _product.owner, "Is not owner the product ");   
   //Change the product                                                                                 
   products[_id] = Product(_id, _product.name, _product.price, _product.owner, _sale, _sale);      
   //Trigger an event                                                                       
   emit ProductForSale(_id, _product.name, _product.price, _product.owner, _sale, _sale);             
 }
}