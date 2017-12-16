import React, { Component } from 'react';
import classnames from 'classnames';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import debounce from 'lodash.debounce';
import { connect, Provider } from 'react-redux';
import moment from 'moment';
import * as searchActions from '../store/actions/search';
import * as productsActions from '../store/actions/products';
import AddProductModal from '../components/AddProductModal';
import RateProductModal from '../components/RateProductModal';
import Search from '../components/Search';
import CategoriesSelect from '../components/CategoriesSelect';

// TODO: Split into Smart/Dumb components
class ProductsTable extends Component {
  static propTypes = {
    currentUserId: PropTypes.number.isRequired
  }

  state = {
    addProductModalOpened: false,
    rateProductModalProductId: false
  }

  handleSearchUpdate = debounce((e) => {
    this.props.searchActions.updateQuery(e.target.value)
  }, 50)

  toggleAddProductModal = (isOpened) => {
    this.setState({ addProductModalOpened: isOpened });
  }

  toggleRateProductModal = (productIdOrFalse) => {
    this.setState({ rateProductModalProductId: productIdOrFalse });
  }

  renderProductRow = (product) => {
    let currentUserVote = 0;
    const upvotes = [];
    const downvotes = [];

    product.votes.forEach(vote => {
      if (vote.user.id == this.props.currentUserId) {
        currentUserVote = vote.is_upvote ? 1 : -1;
      }
      if (vote.is_upvote) {
        upvotes.push(vote);
      } else {
        downvotes.push(vote);
      }
    });

    let currentUserRating = null;
    const averageRating = product.ratings.reduce((acc, rating) => {
      if (rating.user.id === this.props.currentUserId) {
        currentUserRating = rating;
      }
      return acc + rating.value;
    }, 0) / product.ratings.length;

    return (
      <tr key={product.id}>
        <td>
          <a href={product.url} target="_blank">{product.title}</a>
        </td>
        <td>{product.author}</td>
        <td>
          <CategoriesSelect
            value={product.category_id}
            onChange={(val) => {
              this.props.productsActions.update(product.id, {
                category_id: val
              });
            }}
          />
        </td>
        <td>{product.status}</td>
        <td>
          {upvotes.length} / {downvotes.length}
          <button
            className={classnames('btn btn-sm', {
              'btn-default': [0, -1].includes(currentUserVote),
              'btn-success active': currentUserVote === 1
            })}
            disabled={currentUserVote === 1}
            onClick={() => this.props.productsActions.upvote(product.id)}
          >
            upvote
          </button>
          <button
            className={classnames('btn btn-sm', {
              'btn-default': [0, 1].includes(currentUserVote),
              'btn-success active': currentUserVote === -1
            })}
            disabled={currentUserVote === -1}
            onClick={() => this.props.productsActions.downvote(product.id)}
          >
            downvote
          </button>
        </td>
        <td>
          {product.in_use ? (
            <div>
              Take by <b>{product.in_use.user_name}</b> <br />
              { moment(product.in_use.started_at).fromNow() }
              <br />
              <button
                className="btn btn-warning"
                onClick={() => {
                  this.props.productsActions.returnProduct(product.id)
                }}
              >
                Return book
              </button>
            </div>
          ) : (
            <button
              className="btn btn-default"
              onClick={() => {
                this.props.productsActions.take(product.id)
              }}
            >
              Take book
            </button>
          )}
        </td>
        <td>
          <button
            onClick={() => {
              if (confirm('Are you sure?')) {
                this.props.productsActions.remove(product.id)
              }
            }}
          >
            Delete
          </button>
          {currentUserRating ? (
            averageRating
          ) : (
            <button
              onClick={() => this.toggleRateProductModal(product.id)}
            >
              Rate
            </button>
          )}
        </td>
      </tr>
    );
  }

  render() {
    const searchString = this.props.search.queryString.toLowerCase();

    const filteredProducts = this.props.products.all
      .filter(product => (
        product.title.toLowerCase().includes(searchString) ||
        (product.author && product.author.toLowerCase().includes(searchString)) ||
        (product.category_id && this.props.categories.byId[product.category_id].name.toLowerCase().includes(searchString))
      ));

    return (
      <Provider store={this.props.store}>
        <div>
          <Search
            onChange={(e) => {
              e.persist();
              this.handleSearchUpdate(e);
            }}
            value={this.props.search.queryString}
          />

          <br />
          <br />
          <br />

          <button onClick={() => this.toggleAddProductModal(true)}>
            Add Product {this.state.addProductModalOpened ? 'true' : 'false'}
          </button>

          <AddProductModal
            show={this.state.addProductModalOpened}
            onHide={() => this.toggleAddProductModal(false)}
            onSubmit={(data) => {
              this.props.productsActions.create(data)
              this.toggleAddProductModal(false)
            }}
          />
          <RateProductModal
            show={this.state.rateProductModalProductId !== false}
            onHide={() => this.toggleRateProductModal(false)}
            onSubmit={(rating) => {
              this.props.productsActions.rate(
                this.state.rateProductModalProductId,
                rating
              );
              this.toggleRateProductModal(false)
            }}
          />

          <br />
          <br />
          <br />

          {filteredProducts.length !== 0 && (
            <table className="products-table table table-striped">
              <thead>
                <tr>
                  <th>Title</th>
                  <th>Author</th>
                  <th>Category</th>
                  <th></th>
                  <th>Status</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {filteredProducts.map(this.renderProductRow)}
              </tbody>
            </table>
          )}
        </div>
      </Provider>
    );
  }
}

const mapStateToProps = state => state;

const mapDispatchToProps = (dispatch) => ({
  searchActions: bindActionCreators(searchActions, dispatch),
  productsActions: bindActionCreators(productsActions, dispatch)
});

export default connect(mapStateToProps, mapDispatchToProps)(ProductsTable);
