import React, { Component } from 'react';
import classnames from 'classnames';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import debounce from 'lodash.debounce';
import { connect } from 'react-redux';
import moment from 'moment';
import * as searchActions from '../store/actions/search';
import * as productsActions from '../store/actions/products';
import Search from '../components/Search';
import CategoriesSelect from '../components/CategoriesSelect';

// TODO: Split into Smart/Dumb components
class ProductsTable extends Component {
  static propTypes = {
    currentUserId: PropTypes.number.isRequired
  }

  handleSearchUpdate = debounce((e) => {
    this.props.searchActions.updateQuery(e.target.value)
  }, 50)

  renderProductRow = (product) => {
    let currentUserHasUpvote = null;
    const upvotes = [];
    const downvotes = [];

    product.votes.forEach(vote => {
      if (vote.user.id == this.props.currentUserId) {
        currentUserHasUpvote = vote.is_upvote;
      }
      if (vote.is_upvote) {
        upvotes.push(vote);
      } else {
        downvotes.push(vote);
      }
    });

    return (
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
        <td>
          {upvotes.length} / {downvotes.length}
          <button
            className={classnames('btn btn-sm', {
              'btn-default': !currentUserHasUpvote,
              'btn-success active': currentUserHasUpvote
            })}
            disabled={currentUserHasUpvote}
            onClick={() => this.props.productsActions.upvote(product.id)}
          >
            upvote
          </button>
          <button
            className={classnames('btn btn-sm', {
              'btn-default': currentUserHasUpvote || currentUserHasUpvote === null,
              'btn-success active': currentUserHasUpvote === false
            })}
            disabled={currentUserHasUpvote === false}
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
                <th></th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {filteredProducts.map(this.renderProductRow)}
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
