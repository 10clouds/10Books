import React, { PureComponent } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import socket from 'socket'
import { joinChannel as joinCategoriesChannel } from '~/store/actions/categories'
import { joinChannel as joinProductsChannel } from '~/store/actions/products'
import * as allActions from '~/store/actions/products/all'
import { ProductFormModal } from '~/components/modals'
import SearchContainer from '../common/SearchContainer'
import ProductsTableContainer from '../common/ProductsTableContainer'

const MODAL_PRODUCT_NEW = 'true'

class All extends PureComponent {
  constructor(props) {
    super(props)
    socket.connect()
    props.joinCategoriesChannel()
    props.joinProductsChannel('all')
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
      render: product => product.status
    },
    {
      title: 'Status',
      thProps: {
        className: 'text-center'
      },
      tdProps: {
        className: 'text-center'
      },
      render: product => (
        <div className="nowrap">
          <button
            onClick={() => this.handleEdit(product)}
            className="btn btn-secondary"
          >
            <i className="fa fa-pencil" />
          </button>
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

        <ProductFormModal
          forAdmin
          categories={this.props.categories}
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

const mapStateToProps = state => ({
  categories: state.categories.all
})

const mapDispatchToProps = dispatch => {
  return {
    ...bindActionCreators({ joinProductsChannel, joinCategoriesChannel }, dispatch),
    allActions: bindActionCreators(allActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(All)
