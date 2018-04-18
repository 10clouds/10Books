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
      title: 'Rating',
      thProps: {
        className: 'table__heading table__heading-rating'
      },
      render: product => (
        <div>
          { product.ratings.length > 0 ?
              (product.ratings.reduce((total, rating) => {
                return total + rating.value
            }, 0) / product.ratings.length).toFixed(1)
            : '0.0'
          }
        </div>
      )
    },
    {
      title: 'Status',
      thProps: {
        className: 'table__heading table__heading-status'
      },
      tdProps: {
        className: 'table__data table__data-status'
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
        <div className="search-container">
          <SearchContainer categories={ this.props.categories } />
        </div>

        <RateProductModal
          show={this.state.rateProductWithId !== null}
          onHide={this.hideRateProduct}
          onSubmit={value => {
            this.props.libraryActions.rateProduct(this.state.rateProductWithId, value)
            this.hideRateProduct()
          }}
        />

        <ProductsTableContainer appendColumns={this.appendColumns} currentUser={ this.props.currentUser } />
      </div>
    )
  }
}

const mapStateToProps = state => ({
  categories: state.categories.all,
  currentUser: state.user
})

const mapDispatchToProps = dispatch => {
  return {
    ...bindActionCreators({ joinProductsChannel, joinCategoriesChannel }, dispatch),
    libraryActions: bindActionCreators(libraryActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Library)
