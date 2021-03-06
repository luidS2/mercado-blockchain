import React, { Component } from 'react';

class Main extends Component {

  render() {
    return (
      <div id="content">
        <h1>Adicionar Produto</h1>
        <form onSubmit={(event) => {
          event.preventDefault()
          const name = this.productName.value
          const price = window.web3.utils.toWei(this.productPrice.value.toString(), 'Ether')
          this.props.createProduct(name, price)
        }}>
          <div className="form-group mr-sm-2">
            <input
              id="productName"
              type="text"
              ref={(input) => { this.productName = input }}
              className="form-control"
              placeholder="Nome do produto"
              required />
          </div>
          <div className="form-group mr-sm-2">
            <input
              id="productPrice"
              type="text"
              ref={(input) => { this.productPrice = input }}
              className="form-control"
              placeholder="Preço do produto (em Ether)"
              required />
          </div>
          <button type="submit" className="btn btn-primary">Adicionar produto</button>
        </form>
        <p>&nbsp;</p>
        <h2>Comprar produto</h2>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              {/* <th scope="col">Indisp. Venda</th>               */}
              <th scope="col">Nome</th>
              <th scope="col">Preço</th>
              <th scope="col">Proprietário</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody id="productList">
            {this.props.products.map((product, key) => {
              return (
                <tr key={key}>                   
                  <th scope="row">{product.id.toString()}</th>   
                  <td>
                      {product.name}
                  </td>                 
                  <td>{window.web3.utils.fromWei(product.price.toString(), "ether")} Eth</td>
                  <td>{product.owner}</td>
                  <td>
                    {!product.purchased
                      ? <button
                        name={product.id}
                        value={product.price}
                        onClick={(event) => {
                          this.props.purchaseProduct(event.target.name, event.target.value)
                        }}
                        >
                          Comprar
                        </button>
                      : null
                    }                 
                  </td>                 
                </tr>
              )
            })}
          </tbody>
        </table>
        <h2>Meus Produtos</h2>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">Bloquear Venda</th>              
              <th scope="col">Nome</th>
              <th scope="col">Preço</th>
              <th scope="col">Proprietário</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody id="productList">
            {this.props.productsMine.map((product, key) => {
              return (
                <tr key={key}>                   
                  <th scope="row">{product.id.toString()}</th>                  
                  <td><input type="checkbox" checked={product.purchased} name={product.id}                   
                  onChange={(event) => {                    
                    this.props.forSale(event.target.name, event.target.checked)                    
                  }}
                  /></td>
                  <td>
                      {product.name}
                  </td>
                  <td>
                    <input id="productPriceChange" type="text"                        
                        defaultValue = {window.web3.utils.fromWei(product.price.toString(), "ether")} Eth                        
                        name = {key}
                        onChange={(event) => {                                             
                          this.props.onChangePrice(event.target.name, 
                            window.web3.utils.toWei(event.target.value.toString(), 'Ether'))
                        }}
                        className="form-control" placeholder="Preço do produto (em Ether)" 
                        />
                  </td>
                  <td>{product.owner}</td>                 
                  <td>
                    <button                                                
                    value={product.price}
                    onClick={(event) => {                          
                      this.props.changeProduct(product.id, product.name, product.price)
                    }}
                    >
                      Alterar
                    </button>                    
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>                
        <p><a href="https://rinkeby.etherscan.io/tx/0xc9544b919425be860d8b735c93c9a3c06d7a5ec35579a341f908918d76470a94" target="_blank">Informação do contrato</a></p>
      </div>      
    );
  }
}

export default Main;
