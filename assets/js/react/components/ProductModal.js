import React, { PureComponent } from 'react';
import classnames from 'classnames';
import PropTypes from 'prop-types';
import Modal from './Modal';
import CategoriesSelect from './CategoriesSelect';

export default class ProductModal extends PureComponent {
  static propTypes = {
    onSubmit: PropTypes.func.isRequired,
    submitLabel: PropTypes.string.isRequired,
    forAdmin: PropTypes.bool.isRequired,
    product: PropTypes.object
  };

  static defaultProps = {
    forAdmin: false
  }

  constructor(props) {
    super(props);
    this.state = {
      fields: this.getProductFields(props.product),
      errors: {}
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.product !== this.props.product) {
      this.setState({
        fields: this.getProductFields(nextProps.product)
      });
    }
  }

  getProductFields(product = {}) {
    return {
      title: product.title || '',
      author: product.author || '',
      url: product.url || '',
      status: product.status || '',
      category_id: product.category_id || null
    };
  }

  setErrors(errors) {
    const newErrors = {};

    errors.forEach(error => {
      const fieldName = error.source.pointer.replace('/data/attributes/', '');
      newErrors[fieldName] = error.detail;
    });

    this.setState({ errors: newErrors });
  }

  handleInputChange = e => {
    this.handleFieldChange(e.target.name, e.target.value);
  }

  handleFieldChange = (name, value) => {
    this.setState(prevState => ({
      fields: {...prevState.fields, [name]: value},
      errors: {...prevState.errors, [name]: null}
    }));
  }

  renderFormGroup(props = {type: 'text'}) {
    const { label, name, inputComponent, ...inputProps } = props;

    return (
      <div className="form-group">
        <label className="form-control-label">
          {label}
        </label>
        {inputComponent ? inputComponent : (
          <input
            className={classnames('form-control', {
              'is-invalid': this.state.errors[name]
            })}
            {...inputProps}
            name={name}
            onChange={this.handleInputChange}
            value={this.state.fields[name]}
          />
        )}
        {this.state.errors[name] && (
          <div className="invalid-feedback">
            {this.state.errors[name]}
          </div>
        )}
      </div>
    );
  }

  render() {
    const { onSubmit, attrs, ...modalProps } = this.props;

    return (
      <Modal {...modalProps}>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            onSubmit(this.state.fields)
              .then(this.props.onHide)
              .catch(data => {
                this.setErrors(data.errors);
              });
          }}
        >
          {this.renderFormGroup({
            label: 'Title',
            placeholder: 'Title',
            name: 'title'
          })}
          {this.renderFormGroup({
            label: 'Author',
            placeholder: 'Author',
            name: 'author'
          })}
          {this.renderFormGroup({
            label: 'Url',
            placeholder: 'Url',
            name: 'url',
            type: 'url'
          })}

          {this.props.forAdmin && this.renderFormGroup({
            label: 'Status',
            name: 'status',
            inputComponent: (
              <select
                name="status"
                className={classnames('form-control', {
                  'is-invalid': this.state.errors['status']
                })}
                onChange={this.handleInputChange}
                value={this.state.fields.status}
              >
                <option value="">-- select --</option>
                <option value="IN_LIBRARY">In Library</option>
                <option value="REQUESTED">In Orders</option>
                <option value="ACCEPTED">Accepted</option>
                <option value="REJECTED">Rejected</option>
                <option value="ORDERED">Ordered</option>
                <option value="LOST">Lost</option>
                <option value="DELETED">Deleted</option>
              </select>
            )
          })}

          {this.renderFormGroup({
            label: 'Category',
            name: 'category_id',
            inputComponent: (
              <CategoriesSelect
                className={classnames('form-control', {
                  'is-invalid': this.state.errors['category_id']
                })}
                onChange={val => this.handleFieldChange('category_id', val)}
                value={this.state.fields.category_id}
              />
            )
          })}

          <br />
          <br />
          <button type="submit">{this.props.submitLabel}</button>
        </form>
      </Modal>
    );
  }
}
