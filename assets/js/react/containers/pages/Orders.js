import React, { Fragment, PureComponent } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import socket from 'socket'
import { joinChannel as joinCategoriesChannel } from '~/store/actions/categories'
import * as productActions from '~/store/actions/products'
import * as orderActions from '~/store/actions/products/orders'
import { ProductFormModal } from '~/components/modals'
import {
  ProductVotes,
  ProductStatus,
  ProductRequestedBy
} from '~/components/productsTable'
import SearchContainer from '../common/SearchContainer'
import ProductsTableContainer from '../common/ProductsTableContainer'

const MODAL_PRODUCT_NEW = 'new-product'

class Orders extends PureComponent {
  constructor(props) {
    super(props)
    socket.connect()
    props.joinCategoriesChannel()
    props.productActions.joinChannel('orders')
  }

  state = {
    modalProduct: false
  }

  appendColumns = [
    {
      title: 'Requested by',
      elProps: {
        modifiers: ['requested-by'],
      },
      render: product => (
        <ProductRequestedBy name={product.requested_by.name} />
      )
    },
    {
      title: 'Votes',
      elProps: {
        modifiers: ['votes']
      },
      render: product => (
        <ProductVotes
          {...this.props.orderActions}
          product={product}
          currUser={this.props.currentUser}
        />
      )
    },
    {
      title: 'Status',
      elProps: {
        modifiers: ['status']
      },
      render: product => (
        <ProductStatus
          product={product}
          currUser={this.props.currentUser}
          onEdit={() => this.handleEdit(product)}
          onChange={this.props.productActions.update}
        />
      )
    }
  ]

  handleAdd = () => {
    this.setState({
      modalProduct: MODAL_PRODUCT_NEW
    })
  }

  handleEdit = product => {
    this.setState({ modalProduct: product })
  }

  handleSubmit = attrs => {
    return this.state.modalProduct === MODAL_PRODUCT_NEW
      ? this.props.productActions.create(attrs)
      : this.props.productActions.update(this.state.modalProduct.id, attrs)
  }

  handleHide = () => {
    this.setState({ modalProduct: false })
  }

  getTableRowProps = product => ({
    isHighlighted: product.requested_by.id === this.props.currentUser.id
  })

  render() {
    return (
      <Fragment>
        <div className="search-container">
          <SearchContainer categories={this.props.categories} />

          <button
            className="button button--dark button--narrow"
            onClick={this.handleAdd}
          >
            <span>+</span> Suggest book
          </button>
        </div>

        <ProductFormModal
          submitLabel={
            this.state.modalProduct === MODAL_PRODUCT_NEW ? 'Add' : 'Update'
          }
          product={
            this.state.modalProduct &&
            this.state.modalProduct.id
              ? this.state.modalProduct
              : undefined
          }
          categories={this.props.categories}
          onSubmit={this.handleSubmit}
          show={this.state.modalProduct !== false}
          onHide={this.handleHide}
        />

        <ProductsTableContainer
          appendColumns={this.appendColumns}
          getRowProps={this.getTableRowProps}
        />
      </Fragment>
    )
  }
}

const mapStateToProps = state => ({
  currentUser: state.user,
  categories: state.categories.all
})

const mapDispatchToProps = dispatch => {
  return {
    ...bindActionCreators({ joinCategoriesChannel }, dispatch),
    productActions: bindActionCreators(productActions, dispatch),
    orderActions: bindActionCreators(orderActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Orders)
