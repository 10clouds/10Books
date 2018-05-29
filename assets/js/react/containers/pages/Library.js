import React, { PureComponent, Fragment } from 'react'
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
      elProps: {
        modifiers: ['rating']
      },
      render: product => {
        const rating = product.ratings.length > 0
          ? (product.ratings.reduce((total, rating) => {
              return total + rating.value
            }, 0) / parseFloat(product.ratings.length).toFixed(1)).toString()
          : null

        return rating ? (
          <div className="product-rating">
            <span className="product-rating__value">{rating}</span>
            <span className="product-rating__label">/5</span>
          </div>
        ) : '-'
      }
    },
    {
      title: 'Status',
      elProps: {
        modifiers: ['used-by']
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

  getTableRowProps = product => ({
    isHighlighted: product.used_by
      && product.used_by.user.id === this.props.currentUser.id
  })

  openRateProduct = product => {
    this.setState({ rateProductWithId: product.id })
  }

  hideRateProduct = () => {
    this.setState({ rateProductWithId: null })
  }

  render() {
    return (
      <Fragment>
        <SearchContainer categories={this.props.categories} />

        <RateProductModal
          show={this.state.rateProductWithId !== null}
          onHide={this.hideRateProduct}
          onSubmit={value => {
            this.props.libraryActions.rateProduct(this.state.rateProductWithId, value)
            this.hideRateProduct()
          }}
        />

        <ProductsTableContainer
          modifier="library"
          appendColumns={this.appendColumns}
          getRowProps={this.getTableRowProps}
        />
      </Fragment>
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
