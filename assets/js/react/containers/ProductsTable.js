import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import debounce from 'lodash.debounce';
import { connect } from 'react-redux';
import * as searchActions from '../store/actions/search';
import * as productsActions from '../store/actions/products';
import Search from '../components/Search';
import CategoriesSelect from '../components/CategoriesSelect';

class ProductsTable extends Component {
  handleSearchUpdate = debounce((e) => {
    this.props.searchActions.updateQuery(e.target.value)
  }, 50)

  render() {
    const searchString = this.props.search.queryString.toLowerCase();

    const filteredProducts = this.props.products.all
      .filter(product => (
        product.title.toLowerCase().includes(searchString) ||
        (product.author && product.author.toLowerCase().includes(searchString)) ||
        (product.category_id && this.props.categories.byId[product.category_id].name.toLowerCase().includes(searchString))
      ));

    return (
      <div>
        <Search
          onChange={(e) => {
            e.persist();
            this.handleSearchUpdate(e);
          }}
          value={this.props.search.queryString}
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
                  <td>
                    <CategoriesSelect
                      values={Object.values(this.props.categories.byId)}
                      value={product.category_id}
                      onChange={(val) => {
                        this.props.productsActions.update(product.id, {
                          category_id: val
                        });
                      }}
                    />
                  </td>
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

const mapStateToProps = state => state;

const mapDispatchToProps = (dispatch) => ({
  searchActions: bindActionCreators(searchActions, dispatch),
  productsActions: bindActionCreators(productsActions, dispatch)
});

export default connect(mapStateToProps, mapDispatchToProps)(ProductsTable);
