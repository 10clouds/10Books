import React, { PureComponent } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import socket from 'socket'
import { joinChannel as joinCategoriesChannel } from '~/store/actions/categories'
import { joinChannel as joinProductsChannel } from '~/store/actions/products'
import * as libraryActions from '~/store/actions/products/library'
import { RateProductModal } from '~/components/modals'
import { UsageCell } from '~/components/productsTable'
import SearchContainer from '../common/SearchContainer'
import ProductsTableContainer from '../common/ProductsTableContainer'

class Library extends PureComponent {
  constructor(props) {
    super(props)
    socket.connect()
    props.joinCategoriesChannel()
    props.joinProductsChannel('library')
  }

  state = {
    rateProductWithId: null
  }

  appendColumns = [
    {
      title: 'Ratings',
      render: product => (
        <div>{JSON.stringify(product.ratings)}</div>
      )
    },
    {
      title: 'Status',
      thProps: {
        className: 'text-center',
        colSpan: 2
      },
      tdProps: {
        className: 'text-center text-nowrap'
      },
      render: product => (
        <UsageCell
          {...this.props.libraryActions}
          product={product}
          currentUser={this.props.currentUser}
          openRateProduct={this.openRateProduct}
        />
      )
    }
  ]

  openRateProduct = productId => {
    this.setState({ rateProductWithId: productId })
  }

  hideRateProduct = () => {
    this.setState({ rateProductWithId: null })
  }

  render() {
    return (
      <div>
        <SearchContainer />

        <RateProductModal
          show={this.state.rateProductWithId !== null}
          onHide={this.hideRateProduct}
          onSubmit={value => {
            this.props.libraryActions.rateProduct(this.state.rateProductWithId, value)
            this.hideRateProduct()
          }}
        />

        <ProductsTableContainer appendColumns={this.appendColumns} />
      </div>
    )
  }
}

const mapStateToProps = state => ({
  currentUser: state.user
})

const mapDispatchToProps = dispatch => {
  return {
    ...bindActionCreators({ joinProductsChannel, joinCategoriesChannel }, dispatch),
    libraryActions: bindActionCreators(libraryActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Library)
