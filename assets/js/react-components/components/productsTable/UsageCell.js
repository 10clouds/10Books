import React, { PureComponent, Fragment } from 'react'
import PropTypes from 'prop-types'
import distanceInWordsToNow from 'date-fns/distance_in_words_to_now'
import cn from 'classnames'

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

  handleReturnProduct = () => {
    const { product, returnProduct, openRateProduct, currentUser } = this.props

    const oneDay = 1000 * 60 * 60 * 24
    const takenAt = new Date(product.used_by.started_at)
    const canRateAfter = new Date(takenAt.getTime() + oneDay)

    const isUserRated = product.ratings.find(
      item => item.user.id === currentUser.id
    )

    if (!isUserRated && new Date() > canRateAfter) openRateProduct(product)
    returnProduct(product.id)
  }

  renderUsedBy() {
    const {
      product,
      currentUser,
      subscribeToReturnNotification,
      unsubscribeFromReturnNotification
    } = this.props

    const isSubscribed = product.used_by.return_subscribers.includes(
      currentUser.id
    )

    const takenStr = distanceInWordsToNow(product.used_by.started_at, {
      addSuffix: 'ago'
    })

    return (
      product.used_by.user.id !== currentUser.id && (
        <div className="used-by">
          <img
            src={product.used_by.user.avatar_url}
            className="used-by__user-avatar"
          />
          <div className="used-by__info">
            Taken {takenStr} <br />
            by <b className="used-by__user-name">{product.used_by.user.name}</b>
          </div>
          <div className="used-by__notification-container">
            <button
              className={cn('notification-btn', {
                'notification-btn--active': isSubscribed
              })}
              onClick={() => {
                isSubscribed
                  ? unsubscribeFromReturnNotification(product.id)
                  : subscribeToReturnNotification(product.id)
              }}
            >
              <div className="notification-btn__label">
                {isSubscribed ? 'Cancel notification' : 'Notify when returned'}
              </div>
            </button>
          </div>
        </div>
      )
    )
  }

  render() {
    const { product, currentUser, takeProduct } = this.props

    return product.used_by ? (
      <Fragment>
        {this.renderUsedBy()}
        {product.used_by.user.id === currentUser.id && (
          <button
            className="table-action-btn button button--block button--dark"
            onClick={this.handleReturnProduct}
          >
            Return book
          </button>
        )}
      </Fragment>
    ) : (
      <button
        className="table-action-btn button button--block button--bright"
        onClick={() => takeProduct(product.id)}
      >
        Take book
      </button>
    )
  }
}
