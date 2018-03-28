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
import debounce from 'lodash.debounce'

class Library extends PureComponent {
  constructor(props) {
    super(props)
    socket.connect()
    props.joinCategoriesChannel()
    props.joinProductsChannel('library')
  }

  state = {
    rateProductWithId: null,
    windowWidth: null,
  }

  appendColumns = [
    {
      title: 'Ratings',
      thProps: {
        className: 'table__heading'
      },
      // tdProps: {
      //   className: 'table__data'
      // },
      render: product => (
        // <div>{JSON.stringify(product.ratings)}</div>
        <div>4.5</div>
      )
    },
    {
      title: 'Status',
      thProps: {
        className: 'table__heading'
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

  componentDidMount() {
    this.setState({ windowWidth: window.innerWidth })
    window.addEventListener('resize', this.handleWindowResize)
  }

  openRateProduct = productId => {
    this.setState({ rateProductWithId: productId })
  }

  hideRateProduct = () => {
    this.setState({ rateProductWithId: null })
  }

  handleWindowResize = debounce(() => {
    //TODO: set as breakpoints
    this.setState({ windowWidth: window.innerWidth })
  }, 400 )

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

        <ProductsTableContainer appendColumns={this.appendColumns} windowWidth={ this.state.windowWidth } currentUser={ this.props.currentUser } />
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
