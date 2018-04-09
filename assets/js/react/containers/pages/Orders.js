import React, { Fragment, PureComponent } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import socket from 'socket'
import { joinChannel as joinCategoriesChannel } from '~/store/actions/categories'
import * as productActions from '~/store/actions/products'
import * as orderActions from '~/store/actions/products/orders'
import { ProductFormModal } from '~/components/modals'
import { VotesCell, OrderStatusCell } from '~/components/productsTable'
import SearchContainer from '../common/SearchContainer'
import ProductsTableContainer from '../common/ProductsTableContainer'

const MODAL_PRODUCT_NEW = 'true'

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
      thProps: {
        className: 'text-center text-nowrap'
      },
      tdProps: {
        className: 'text-center'
      },
      render: product => product.requested_by.name
    },
    {
      title: 'Votes',
      thProps: {
        className: 'text-center'
      },
      tdProps: {
        className: 'text-center'
      },
      render: product => (
        <VotesCell
          { ...this.props.orderActions }
          product={ product }
          currUser={ this.props.user }
        />
      )
    },
    {
      title: 'Status',
      thProps: {
        className: 'text-center'
      },
      tdProps: {
        className: 'text-center text-nowrap'
      },
      render: product => (
        <OrderStatusCell
          product={ product }
          currUser={ this.props.user }
          onEdit={ () => this.handleEdit(product) }
          onChange={ this.props.productActions.update }
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

  render() {
    return (
      <Fragment>
        <div className="search-container">
          <SearchContainer/>

          <button
            className="button button--dark button--narrow"
            onClick={ this.handleAdd }
          >
            <span>+</span> Order book
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
          categories={ this.props.categories }
          onSubmit={ this.handleSubmit }
          show={ this.state.modalProduct !== false }
          onHide={ this.handleHide }
        />

        <ProductsTableContainer appendColumns={ this.appendColumns }/>
      </Fragment>
    )
  }
}

const mapStateToProps = state => ({
  user: state.user,
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
