import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import Modal from './Modal';
import CategoriesSelect from './CategoriesSelect';

export default class AddProductModal extends PureComponent {
  static propTypes = {
    onSubmit: PropTypes.func.isRequired
  };

  state = {
    title: null,
    author: null,
    url: null,
    category_id: null
  }

  handleInputChange = (e) => {
    this.handleFieldChange(e.target.name, e.target.value);
  }

  handleFieldChange = (name, value) => {
    this.setState({
      [name]: value
    });
  }

  render() {
    const { onSubmit, ...modalProps } = this.props;

    return (
      <Modal {...modalProps}>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            onSubmit(this.state);
          }}
        >
          <input
            type="text"
            name="title"
            placeholder="Title"
            required
            onChange={this.handleInputChange}
          />
          <br />
          <br />
          <input
            type="text"
            name="author"
            placeholder="Author"
            required
            onChange={this.handleInputChange}
          />
          <br />
          <br />
          <input
            type="url"
            name="url"
            placeholder="url"
            required
            onChange={this.handleInputChange}
          />
          <br />
          <br />
          <CategoriesSelect
            onChange={(val) => this.handleFieldChange('category_id', val)}
            value={this.state.category_id}
          />
          <br />
          <br />
          <button type="submit">Add</button>
        </form>
      </Modal>
    );
  }
}
