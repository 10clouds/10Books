import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import ProductStatus from './ProductStatus'

export default class ProductOrderStatus extends PureComponent {
  static propTypes = {
    currUser: PropTypes.shape({
      id: PropTypes.number.isRequired,
      is_admin: PropTypes.bool.isRequired
    }).isRequired,
    product: PropTypes.shape({
      id: PropTypes.number.isRequired,
      status: PropTypes.string.isRequired,
      requested_by: PropTypes.shape({
        id: PropTypes.number.isRequired
      }).isRequired
    }),
    onEdit: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired
  }

  handleStatusChange = status => {
    this.props.onChange(this.props.product.id, { status })
  }

  render() {
    const {
      product,
      currUser,
      onEdit,
    } = this.props

    const canDoOwnerAction = product.status === 'REQUESTED'
      && currUser.id == product.requested_by.id

    return (
      <ProductStatus
        status={product.status}
        canChangeStatus={currUser.is_admin}
        onStatusChange={this.handleStatusChange}
        canEdit={currUser.is_admin || canDoOwnerAction}
        onEdit={onEdit}
        canDelete={currUser.is_admin || canDoOwnerAction}
      />
    )
  }
}
