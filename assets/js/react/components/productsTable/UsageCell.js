import React, { PureComponent, Fragment } from 'react'
import PropTypes from 'prop-types'
import moment from 'moment'
import TooltipButton from './Tooltip-button'
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
    unsubscribeFromReturnNotification: PropTypes.func.isRequired,
  }

  renderUsedBy() {
    const { product, currentUser } = this.props

    return product.used_by.user.id !== currentUser.id && (
      <div className="table__data table__data-user">
        <img src={ product.used_by.user.avatar_url } className="user-avatar"/>
        <p>
          <span className="table__data table__data-status-date">
            Taken { moment(product.used_by.started_at).fromNow() }
          </span>
          <br/>
          { product.used_by.user.name }
        </p>
      </div>
    )
  }

  renderUsedByActions() {
    const {
      product,
      currentUser,
      openRateProduct,
      returnProduct,
      subscribeToReturnNotification,
      unsubscribeFromReturnNotification,
    } = this.props

    return product.used_by.user.id === currentUser.id ? (
      <button
        className="button button--dark button--small"
        onClick={ () => {
          const isUserRated = product.ratings
            .find(item => item.user.id === currentUser.id)

          if (!isUserRated) openRateProduct(product.id)
          returnProduct(product.id)
        } }
      >
        Return book
      </button>
    ) : (
      product.used_by.return_subscribers.includes(currentUser.id) ? (
        <TooltipButton
          onClick={ () => {
            unsubscribeFromReturnNotification(product.id)
          } }
          className="table__bell-button"
          tooltipText="Cancel notification"
        >
          <img src="images/bell.svg" className="table__bell-icon"/>
        </TooltipButton>
      ) : (
        <TooltipButton
          onClick={ () => {
            subscribeToReturnNotification(product.id)
          } }
          className="table__bell-button"
          tooltipText="Notify when returned"
        >
          <img src="images/bell--inactive.svg" className="table__bell-icon"/>
        </TooltipButton>
      )
    )
  }

  render() {
    const {
      product,
      takeProduct,
    } = this.props

    return product.used_by ? (
      <Fragment>
        { this.renderUsedBy() }
        { this.renderUsedByActions() }
      </Fragment>
    ) : (
      <button
        className="button button--bright button--small"
        onClick={ () => takeProduct(product.id) }
      >
        Take book
      </button>
    )
  }
}
