import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import Search from '../components/Search';
import * as productActions from '../store/actions/products';

class ProductsTable extends Component {
  render() {
    const searchString = this.props.searchString.toLowerCase();
    const filteredProducts = this.props.all.filter(product => (
      product.title.includes(searchString) ||
      product.author.includes(searchString)
    ));

    return (
      <div>
        <Search
          onChange={(e) => this.props.updateSearchString(e.target.value)}
          value={this.props.searchString}
        />

        {filteredProducts.length !== 0 && (
          <table className="products-table table table-striped">
            <thead>
              <tr>
                <th>Title</th>
                <th>Author</th>
                <th>Category</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {filteredProducts.map(product => (
                <tr key={product.id}>
                  <td>
                    <a href={product.url} target="_blank">{product.title}</a>
                  </td>
                  <td>{product.author}</td>
                  <td></td>
                  <td>{product.status}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    );
  }
}

const mapStateToProps = (state) => (state.products);

const mapDispatchToProps = (dispatch) => (
  bindActionCreators(productActions, dispatch)
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductsTable);
