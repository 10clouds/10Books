import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'

const SCROLL_DISABLED_CLASS = 'scroll-disabled'

export default class Modal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    children: PropTypes.node,
    popupModifier: PropTypes.string
  }

  componentDidMount() {
    this.modalEl.addEventListener('hide.bs.modal', this.props.onHide)
    document.body.classList.add(SCROLL_DISABLED_CLASS)
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
      <div
        className="popup"
        tabIndex="-1"
        role="dialog"
        aria-hidden="true"
        ref={ el => this.modalEl = el }
        onClick={ this.handleClosePopup }
      >
        <div className={`popup__window ${this.props.popupModifier ? `popup__window--${this.props.popupModifier}` : ''}`}>
          { this.props.children }
        </div>
      </div>
    )
  }
}
