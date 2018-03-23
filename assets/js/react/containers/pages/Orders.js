import React, { Fragment, PureComponent } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import socket from 'socket'
import { joinChannel as joinCategoriesChannel } from '~/store/actions/categories'
import { joinChannel as joinProductsChannel } from '~/store/actions/products'
import { ProductFormModal } from '~/components/modals'
import { VotesCell, OrderStatusCell } from '~/components/productsTable'
import * as orderActions from '~/store/actions/products/orders'
import SearchContainer from '../common/SearchContainer'
import ProductsTableContainer from '../common/ProductsTableContainer'

class Orders extends PureComponent {
  constructor(props) {
    super(props)
    socket.connect()
    props.joinCategoriesChannel()
    props.joinProductsChannel('orders')
  }

  state = {
    isAddModalVisible: false
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
          {...this.props.orderActions}
          product={product}
          currUser={this.props.user}
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
          product={product}
          currUser={this.props.user}
          onEdit={productId => console.log('onEdit', productId)}
          onChange={(productId, attrs) => console.log('onChange', productId, attrs)}
        />
      )
    }
  ]

  render() {
    return (
      <Fragment>
        <SearchContainer />

        <button
          onClick={() => this.setState({ isAddModalVisible: true })}
        >
          Add
        </button>

        <ProductFormModal
          submitLabel="Add"
          categories={this.props.categories}
          onSubmit={this.props.orderActions.create}
          show={this.state.isAddModalVisible}
          onHide={() => this.setState({ isAddModalVisible: false })}
        />

        <ProductsTableContainer appendColumns={this.appendColumns} />
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
    ...bindActionCreators({ joinProductsChannel, joinCategoriesChannel }, dispatch),
    orderActions: bindActionCreators(orderActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Orders)
