import React, { PureComponent, Fragment } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import socket from 'socket'
import { joinChannel as joinCategoriesChannel } from '~/store/actions/categories'
import * as productActions from '~/store/actions/products'
import { ProductFormModal } from '~/components/modals'
import SearchContainer from '~/containers/common/SearchContainer'
import ProductsTableContainer from '~/containers/common/ProductsTableContainer'
import { ProductRequestedBy, ProductStatus } from '~/components/productsTable'

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
      title: 'Requested by',
      elProps: {
        modifiers: ['requested-by'],
      },
      render: product => (
        <ProductRequestedBy name={product.requested_by ? product.requested_by.name : ''} />
      )
    },
    {
      title: 'Status',
      elProps: {
        modifiers: ['status']
      },
      render: product => (
        <ProductStatus
          status={product.status}
          canChangeStatus
          canEdit
          canDelete
          onStatusChange={status => {
            this.props.productActions.update(product.id, { status })
          }}
          onEdit={() => this.handleEdit(product)}
        />
      )
    }
  ]

  handleEdit = product => {
    this.setState({ modalProduct: product })
  }

  render() {
    return (
      <div>
        <SearchContainer
          categories={this.props.categories}
          action={{
            onClick: () => {
              this.setState({
                modalProduct: MODAL_PRODUCT_NEW
              })
            },
            children: (
              <Fragment>
                <img src="/images/icon-plus-white.svg" />
                Add
              </Fragment>
            )
          }}
        />

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

        <ProductsTableContainer
          appendColumns={this.productTableColumns}
        />
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
