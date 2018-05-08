import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import { Transition } from 'react-transition-group'

const SCROLL_DISABLED_CLASS = 'scroll-disabled'

export default class Modal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    children: PropTypes.node,
    popupModifier: PropTypes.string
  }

  componentWillReceiveProps(newProps) {
    if (newProps.show) {
      document.body.classList.add(SCROLL_DISABLED_CLASS)
    } else {
      document.body.classList.remove(SCROLL_DISABLED_CLASS)
    }
  }

  componentWillUnmount() {
    document.body.classList.remove(SCROLL_DISABLED_CLASS)
  }

  handleClosePopup = e => {
    if (e.target === this.modalEl) {
      document.body.classList.remove(SCROLL_DISABLED_CLASS)
      this.props.onHide()
    }
  }

  render() {
    return (
      <Transition in={this.props.show} timeout={500} unmountOnExit>
        { state => {
          return <div
            className={classnames('popup', {
              [`popup--${state}`]: state,
            })}
            tabIndex="-1"
            role="dialog"
            aria-hidden="true"
            ref={el => this.modalEl = el}
            onClick={this.handleClosePopup}
          >
            <div
              className={classnames('popup__window', {
                [`popup__window--${this.props.popupModifier}`]: this.props.popupModifier
              })}>
              { this.props.children }
            </div>
          </div>
        }
        }
      </Transition>
    )
  }
}
