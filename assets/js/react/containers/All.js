import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import socket from 'socket';
import { joinChannel as joinCategoriesChannel } from '../store/actions/categories';
import { joinChannel as joinProductsChannel } from '../store/actions/products';
import * as allActions from '../store/actions/products/all';
import SearchContainer from './common/SearchContainer';
import ProductsTableContainer from './common/ProductsTableContainer';
import ProductModal from '../components/ProductModal';
import StatusSelect from '../components/StatusSelect';

const MODAL_PRODUCT_NEW = 'true'

class All extends PureComponent {
  constructor(props) {
    super(props);
    socket.connect();
    props.joinCategoriesChannel();
    props.joinProductsChannel('all');
  }

  state = {
    modalProduct: false
  }

  productTableColumns = [
    {
      title: 'Status',
      thProps: {
        className: 'text-center'
      },
      tdProps: {
        className: 'text-center'
      },
      render: (product, props) => (
        <div className="nowrap">
          <button
            onClick={() => this.handleEdit(product)}
            className="btn btn-secondary"
          >
            <i className="fa fa-pencil" />
          </button>
          {' '}
          <StatusSelect
            value={product.status}
            onChange={val => (
              props.onChange(product.id, { status: val })
            )}
          />
        </div>
      )
    }
  ]

  handleEdit = product => {
    this.setState({ modalProduct: product })
  }

  render() {
    return (
      <div>
        <SearchContainer />

        <button
          onClick={() => (
            this.setState({
              modalProduct: MODAL_PRODUCT_NEW
            })
          )}
        >
          Add {JSON.stringify(this.state.modalProduct)}
        </button>

        <ProductModal
          forAdmin
          submitLabel={
            this.state.modalProduct === MODAL_PRODUCT_NEW ? 'Add' : 'Update'
          }
          product={
            this.state.modalProduct &&
            this.state.modalProduct.id
              ? this.state.modalProduct
              : undefined
          }
          onSubmit={attrs => {
            return this.state.modalProduct === MODAL_PRODUCT_NEW
              ? this.props.allActions.create(attrs)
              : this.props.allActions.update(this.state.modalProduct.id, attrs)
          }}
          show={this.state.modalProduct !== false}
          onHide={() => {
            this.setState({ modalProduct: false })
          }}
        />

        <ProductsTableContainer appendColumns={this.productTableColumns} />
      </div>
    )
  }
}

const mapDispatchToProps = dispatch => {
  return {
    ...bindActionCreators({ joinProductsChannel, joinCategoriesChannel }, dispatch),
    allActions: bindActionCreators(allActions, dispatch)
  }
}

export default connect(null, mapDispatchToProps)(All)
