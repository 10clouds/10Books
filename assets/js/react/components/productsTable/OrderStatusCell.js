import React, { PureComponent, Fragment } from 'react'
import PropTypes from 'prop-types'
import StatusSelect, { STATUSES_LIST } from '../../components/StatusSelect'

export default class OrderStatusCell extends PureComponent {
  static propTypes = {
    currUser: PropTypes.shape({
      id: PropTypes.number.isRequired,
      is_admin: PropTypes.bool.isRequired
    }).isRequired,
    product: PropTypes.shape({
      status: PropTypes.string.isRequired,
      requested_by: PropTypes.shape({
        id: PropTypes.number.isRequired
      }).isRequired
    }),
    onEdit: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired
  }

  render() {
    const {
      product,
      currUser,
      onEdit,
      onChange
    } = this.props

    return currUser.is_admin ? (
      <StatusSelect
        value={product.status}
        onChange={val => onChange(product.id, { status: val })}
      />
    ) : (
      product.status === 'REQUESTED' &&
      product.requested_by.id === currUser.id ? (
        <Fragment>
          <button
            className="btn btn-primary"
            onClick={() => onEdit(product.id)}
          >
            <i className="fa fa-pencil" />
          </button>
          <button
            className="btn btn-danger"
            onClick={() => onChange(product.id, { status: 'DELETED' })}
          >
            <i className="fa fa-trash-o" />
          </button>
        </Fragment>
      ) : (
        <div>
          {product.status === 'REQUESTED' ?
            '-' :
            STATUSES_LIST[product.status]}
        </div>
      )
    )
  }
}
