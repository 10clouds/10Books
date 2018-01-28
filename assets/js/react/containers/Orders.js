import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import classnames from 'classnames';
import socket from 'socket';
import { joinChannel as joinCategoriesChannel } from '../store/actions/categories';
import { joinChannel as joinProductsChannel } from '../store/actions/products';
import * as orderActions from '../store/actions/products/orders';
import SearchContainer from './common/SearchContainer';
import ProductsTableContainer from './common/ProductsTableContainer';
import AddProductModal from '../components/AddProductModal';
import StatusSelect, { STATUSES_LIST } from '../components/StatusSelect';

class OrdersProductTable extends PureComponent {
  render() {
    return (
      <ProductsTableContainer
        renderNoResults={() => (
          <div className="text-center">
            No orders yet :( <b>Be the first one!</b>
            </div>
        )}
        appendColumns={[
          {
            title: "Requested by",
            thProps: {
              className: 'text-center text-nowrap'
            },
            tdProps: {
              className: 'text-center'
            },
            render: (product) => (
              <div>
                {product.requested_by.name}
              </div>
            )
          },
          {
            title: "Votes",
            thProps: {
              className: 'text-center'
            },
            tdProps: {
              className: 'text-center'
            },
            render: (product) => {
              let upvotesCount = 0;
              let downvotesCount = 0;
              let userIsUpvote = null;

              product.votes.forEach(vote => {
                if (vote.user.id === this.props.user.id) {
                  userIsUpvote = vote.is_upvote;
                }

                if (vote.is_upvote) {
                  upvotesCount++;
                } else {
                  downvotesCount++;
                }
              });

              return (
                <div>
                  <div className="votes-counter">
                    <span className="text-success">{upvotesCount}</span>
                    /
                    <span className="text-danger">{downvotesCount}</span>
                  </div>
                  {product.requested_by.id !== this.props.user.id && (
                    <div className="btn-group">
                      <span
                        disabled={userIsUpvote === true}
                        className={classnames('btn btm-sm', {
                          'btn-secondary': [null, false].includes(userIsUpvote),
                          'btn-success active': userIsUpvote === true
                        })}
                        onClick={() => this.props.orderActions.upvote(product.id)}
                      >
                        <i className="fa fa-thumbs-up" />
                      </span>
                      <span
                        disabled={userIsUpvote === false}
                        className={classnames('btn btm-sm', {
                          'btn-secondary': [null, true].includes(userIsUpvote),
                          'btn-success active': userIsUpvote === false
                        })}
                        onClick={() => this.props.orderActions.downvote(product.id)}
                      >
                        <i className="fa fa-thumbs-down" />
                      </span>
                    </div>
                  )}
                </div>
              );
            }
          },
          {
            title: "Status",
            thProps: {
              className: 'text-center'
            },
            tdProps: {
              className: 'text-center text-nowrap'
            },
            render: (product, rowProps) => (
              this.props.user.is_admin ? (
                <StatusSelect
                  value={product.status}
                  onChange={val => (
                    rowProps.onChange(product.id, { status: val })
                  )}
                />
              ) : (
                product.status === 'REQUESTED' &&
                product.requested_by.id === this.props.user.id ? (
                  <button
                    className="btn btn-danger"
                    onClick={() => {
                      rowProps.onChange(product.id, { status: "DELETED" })
                    }}
                  >
                    <i className="fa fa-trash-o" />
                  </button>
                ) : (
                  <div>
                    {product.status === 'REQUESTED' ?
                      '-' :
                      STATUSES_LIST[product.status]}
                  </div>
                )
              )
            )
          }
        ]}
      />
    );
  }
};

OrdersProductTable.propTypes = {
  orderActions: PropTypes.object.isRequired,
  user: PropTypes.object.isRequired
};

class Orders extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      isAddModalVisible: false
    };
    socket.connect();
    props.joinCategoriesChannel();
    props.joinProductsChannel('orders');
  }

  render() {
    return (
      <div>
        <SearchContainer />

        <button
          onClick={() => this.setState({ isAddModalVisible: true })}
        >
          Add
        </button>

        <AddProductModal
          onSubmit={this.props.orderActions.create}
          show={this.state.isAddModalVisible}
          onHide={() => this.setState({ isAddModalVisible: false })}
        />

        <OrdersProductTable {...this.props} />
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.user
});

const mapDispatchToProps = dispatch => {
  return {
    ...bindActionCreators({ joinProductsChannel, joinCategoriesChannel }, dispatch),
    orderActions: bindActionCreators(orderActions, dispatch)
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(Orders);
