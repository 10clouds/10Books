import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import $ from 'jquery'

export default class Modal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    children: PropTypes.node
  }

  componentDidMount() {
    $(this.modalEl).on('hide.bs.modal', this.props.onHide)
    document.querySelector('body').classList.add('scroll-disabled')
  }

  componentWillUnmount() {
    document.querySelector('body').classList.add('scroll-disabled')
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.show && !this.props.show) {
      $(this.modalEl).modal('show')
    } else if (!nextProps.show && this.props.show) {
      $(this.modalEl).modal('hide')
    }
  }

  render() {
    return (
      <div
        className="popup"
        tabIndex="-1"
        role="dialog"
        aria-hidden="true"
        ref={el => this.modalEl = el}
      >
        <div className="popup__window">
          <h1 className="popup__heading">Rate the book</h1>
          {this.props.children}
        </div>
      </div>
    )
  }
}
