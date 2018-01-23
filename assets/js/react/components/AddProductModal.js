import React, { PureComponent } from 'react';
import classnames from 'classnames';
import PropTypes from 'prop-types';
import Modal from './Modal';
import CategoriesSelect from './CategoriesSelect';

export default class AddProductModal extends PureComponent {
  static propTypes = {
    onSubmit: PropTypes.func.isRequired
  };

  defaultFields = {
    title: '',
    author: '',
    url: '',
    category_id: null
  };

  state = {
    fields: this.defaultFields,
    errors: {}
  };

  componentWillReceiveProps(nextProps) {
    if (nextProps.show && nextProps.show !== this.props.show) {
      this.setState({
        fields: this.defaultFields
      });
    }
  }

  setErrors(errors) {
    const newErrors = {};

    errors.forEach(error => {
      const fieldName = error.source.pointer.replace('/data/attributes/', '');
      newErrors[fieldName] = error.detail;
    });

    this.setState({ errors: newErrors });
  }

  handleInputChange = (e) => {
    this.handleFieldChange(e.target.name, e.target.value);
  }

  handleFieldChange = (name, value) => {
    this.setState(prevState => ({
      fields: {...prevState.fields, [name]: value}
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
    const { onSubmit, ...modalProps } = this.props;

    return (
      <Modal {...modalProps}>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            onSubmit(this.state.fields)
              .then(() => {
                this.props.onHide();
              })
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
          <button type="submit">Add</button>
        </form>
      </Modal>
    );
  }
}
