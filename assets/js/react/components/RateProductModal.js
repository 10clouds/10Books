import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import Modal from './Modal';

export default class RateProductModal extends PureComponent {
  static propTypes = {
    onSubmit: PropTypes.func.isRequired
  }

  state = {
    rating: null
  }

  handleRatingChange = (e) => {
    this.setState({ rating: parseInt(e.target.value, 10) });
  }

  render() {
    const { onSubmit, ...modalProps } = this.props;

    return (
      <Modal {...modalProps}>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            onSubmit(this.state.rating);
            this.setState({ rating: null });
          }}
        >
          <input
            type="radio"
            name="rating"
            value="1"
            checked={this.state.rating === 1}
            onChange={this.handleRatingChange}
          />
          1
          <br />

          <input
            type="radio"
            name="rating"
            value="2"
            checked={this.state.rating === 2}
            onChange={this.handleRatingChange}
          />
          2
          <br />

          <input
            type="radio"
            name="rating"
            value="3"
            checked={this.state.rating === 3}
            onChange={this.handleRatingChange}
          />
          3
          <br />

          <input
            type="radio"
            name="rating"
            value="4"
            checked={this.state.rating === 4}
            onChange={this.handleRatingChange}
          />
          4
          <br />

          <input
            type="radio"
            name="rating"
            value="5"
            checked={this.state.rating === 5}
            onChange={this.handleRatingChange}
          />
          5

          <br />
          <br />

          <button type="submit">Submit</button>
        </form>
      </Modal>
    )
  }
}
