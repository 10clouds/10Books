import React, { PureComponent, Fragment } from 'react'
import PropTypes from 'prop-types'
import moment from 'moment'

export default class UsageCell extends PureComponent {
  static propTypes = {
    currentUser: PropTypes.shape({
      id: PropTypes.number.isRequired
    }),
    product: PropTypes.shape({
      id: PropTypes.number.isRequired,
      used_by: PropTypes.shape({
        started_at: PropTypes.string.isRequired,
        user: PropTypes.shape({
          id: PropTypes.number.isRequired,
          name: PropTypes.string.isRequired
        })
      })
    }),
    takeProduct: PropTypes.func.isRequired,
    openRateProduct: PropTypes.func.isRequired,
    returnProduct: PropTypes.func.isRequired,
    subscribeToReturnNotification: PropTypes.func.isRequired,
    unsubscribeFromReturnNotification: PropTypes.func.isRequired
  }

  renderUsedBy() {
    const { product, currentUser } = this.props

    return product.used_by.user.id !== currentUser.id && (
      <Fragment>
        Taken by <b>{product.used_by.user.name}</b> <br />
        {product.used_by.user.avatar_url}
        <br />
        { moment(product.used_by.started_at).fromNow() }
        <br />
      </Fragment>
    )
  }

  renderUsedByActions() {
    const {
      product,
      currentUser,
      openRateProduct,
      returnProduct,
      subscribeToReturnNotification,
      unsubscribeFromReturnNotification
    } = this.props

    return product.used_by.user.id === currentUser.id ? (
      <button
        className="btn btn-warning"
        onClick={() => {
          const isUserRated = product.ratings
            .find(item => item.user.id === currentUser.id)

          if (!isUserRated) openRateProduct(product.id)
          returnProduct(product.id)
        }}
      >
        Return book
      </button>
    ) : (
      product.used_by.return_subscribers.includes(currentUser.id) ? (
        <button
          type="button"
          className="btn btn-danger"
          onClick={() => unsubscribeFromReturnNotification(product.id)}
        >
          Cancel Notification
        </button>
      ) : (
        <button
          type="button"
          className="btn btn-info"
          onClick={() => subscribeToReturnNotification(product.id)}
        >
          Notify when returned
        </button>
      )
    )
  }

  render() {
    const {
      product,
      takeProduct
    } = this.props

    return product.used_by ? (
      <Fragment>
        {this.renderUsedBy()}
        {this.renderUsedByActions()}
      </Fragment>
    ) : (
      <button
        className="btn btn-primary"
        onClick={() => takeProduct(product.id)}
      >
        Take book
      </button>
    )
  }
}
