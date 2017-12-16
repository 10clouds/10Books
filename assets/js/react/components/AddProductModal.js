import React, { Component } from 'react';
import PropTypes from 'prop-types';
import $ from 'jquery';
import CategoriesSelect from './CategoriesSelect';

export default class AddProductModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    onSubmit: PropTypes.func.isRequired
  };

  state = {
    title: null,
    author: null,
    url: null,
    category_id: null
  }

  componentDidMount() {
    $(this.modalEl).on('hide.bs.modal', this.props.onHide);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.show && !this.props.show) {
      $(this.modalEl).modal('show');
    } else if (!nextProps.show && this.props.show) {
      $(this.modalEl).modal('hide');
    }
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
    return (
      <div
        className="modal fade"
        tabIndex="-1"
        role="dialog"
        aria-hidden="true"
        ref={el => this.modalEl = el}
      >
        <div className="modal-dialog modal-lg">
          <div className="modal-content">

            <form
              onSubmit={(e) => {
                e.preventDefault();
                this.props.onSubmit(this.state);
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

          </div>
        </div>
      </div>
    );
  }
}
