import React, { PureComponent } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import socket from 'socket'
import { joinChannel as joinCategoriesChannel } from '~/store/actions/categories'
import * as productActions from '~/store/actions/products'
import { ProductFormModal } from '~/components/modals'
import SearchContainer from '../common/SearchContainer'
import ProductsTableContainer from '../common/ProductsTableContainer'

const MODAL_PRODUCT_NEW = 'true'

class All extends PureComponent {
  constructor(props) {
    super(props)
    socket.connect()
    props.joinCategoriesChannel()
    props.productActions.joinChannel('all')
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
        className: 'text-center nowrap-col'
      },
      render: product => (
        <button
          onClick={() => this.handleEdit(product)}
          className="btn btn-secondary"
        >
          <i className="fa fa-pencil" />
        </button>
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
          onSubmit={attrs => (
            this.state.modalProduct === MODAL_PRODUCT_NEW
              ? this.props.productActions.create(attrs)
              : this.props.productActions.update(this.state.modalProduct.id, attrs)
          )}
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
    ...bindActionCreators({ joinCategoriesChannel }, dispatch),
    productActions: bindActionCreators(productActions, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(All)
