import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import Modal from './Modal'
import cn from 'classnames'

export default class RateProductModal extends PureComponent {
  static propTypes = {
    onSubmit: PropTypes.func.isRequired,
    onHide: PropTypes.func.isRequired
  }

  state = {
    rating: null
  }

  handleRatingChange = e => {
    this.setState({
      rating: parseInt(e.target.value, 10)
    })
  }

  handleRejectRating = () => {
    this.setState({ rating: null })
    this.props.onHide()
  }

  render() {
    const { onSubmit, ...modalProps } = this.props
    const radioInputs = Array.from({ length: 5 }, (element, index) => index + 1)
    const isSubmitDisabled = this.state.rating === null

    return (
      <Modal {...modalProps}>
        <form
          className="rate-product-modal"
          onSubmit={e => {
            e.preventDefault()
            onSubmit(this.state.rating)
            this.setState({ rating: null })
          }}
        >
          <h2 className="rate-product-modal__header">Rate the book</h2>

          <div className="rate-product-modal__radios-wrapper">
            {
              radioInputs.map(element => (
                <div
                  className="rate-product-modal__radio-option"
                  key={`radio${element}`}
                >
                  <label className="rate-product-modal__radio-label" htmlFor={`opt${element}`}>
                    { element }
                  </label>
                  <input
                    className="rate-product-modal__radio-input"
                    id={`opt${element}`}
                    type="radio"
                    name="rating"
                    value={element}
                    checked={this.state.rating === element}
                    onChange={this.handleRatingChange}
                  />
                  <div className="rate-product-modal__radiobutton"></div>
                </div>
              ))
            }
          </div>
          <div className="modal-form__footer">
            <button
              type="submit"
              className={cn('button', {
                'button--dark': !isSubmitDisabled,
                'button--light-gray': isSubmitDisabled
              })}
              disabled={isSubmitDisabled}
            >
              Save
            </button>
          </div>
        </form>
      </Modal>
    )
  }
}
