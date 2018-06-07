import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import { Modal as ReactOverlaysModal } from 'react-overlays'
import Transition, { ENTERED, ENTERING } from 'react-transition-group/Transition'

const TRANSITION_TIME = 300 // NOTE: Must be in sync with CSS

function ModalTransition({ children, ...props }) {
  return (
    <Transition
      {...props}
      timeout={TRANSITION_TIME}
    >
      {(status, innerProps) => React.cloneElement(children, {
        ...innerProps,
        className: classnames(children.props.className, {
          'modal--visible': [ENTERING, ENTERED].includes(status)
        })
      })}
    </Transition>
  )
}

export default class Modal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    children: PropTypes.node,
    popupModifier: PropTypes.string
  }

  handleEnter() {
    document
      .getElementById('js-page-header')
      .setAttribute('style', document.body.getAttribute('style'))
  }

  handleExited() {
    document
      .getElementById('js-page-header')
      .setAttribute('style', null)
  }

  handleClosePopup = e => {
    if (e.target === this.modalEl) {
      this.props.onHide()
    }
  }

  render() {
    return (
      <ReactOverlaysModal
        transition={ModalTransition}
        backdrop={false}
        containerClassName="with-visible-popup"
        onBackdropClick={this.props.onHide}
        show={this.props.show}
        onHide={this.props.onHide}
        onEnter={this.handleEnter}
        onExited={this.handleExited}
      >
        <div
          className="modal"
          ref={el => this.modalEl = el}
          onClick={this.handleClosePopup}
        >
          <div
            className={classnames('modal__content', {
              [`modal__content--${this.props.popupModifier}`]: this.props.popupModifier
            })}
          >
            <button
              className="modal__close"
              onClick={this.props.onHide}
            >
              Close
            </button>
            {this.props.children}
          </div>
        </div>
      </ReactOverlaysModal>
    )
  }
}
