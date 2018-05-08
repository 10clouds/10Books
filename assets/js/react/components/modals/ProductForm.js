import React, { PureComponent } from 'react'
import classnames from 'classnames'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import Modal from './Modal'
import Dropdown from 'react-dropdown'

const DROPDOWN_STATUS = [
  { value: 'IN_LIBRARY', label: 'In Library' },
  { value: 'REQUESTED', label: 'In Orders' },
  { value: 'ACCEPTED', label: 'Accepted' },
  { value: 'REJECTED', label: 'Rejected' },
  { value: 'ORDERED', label: 'Ordered' },
  { value: 'LOST', label: 'Lost' },
  { value: 'DELETED', label: 'Deleted' },
]

class ProductForm extends PureComponent {
  static propTypes = {
    onSubmit: PropTypes.func.isRequired,
    onHide: PropTypes.func.isRequired,
    submitLabel: PropTypes.string.isRequired,
    forAdmin: PropTypes.bool.isRequired,
    categories: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.number.isRequired,
        name: PropTypes.string.isRequired
      })
    ).isRequired,
    product: PropTypes.object,
    show: PropTypes.bool
  }

  static defaultProps = {
    forAdmin: false
  }

  constructor(props) {
    super(props)
    this.state = {
      fields: this.getProductFields(props.product),
      errors: {}
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.product !== this.props.product) {
      this.setState({
        fields: this.getProductFields(nextProps.product)
      })
    }
  }

  getProductFields(product = {}) {
    return {
      title: product.title || '',
      author: product.author || '',
      url: product.url || '',
      status: product.status || '',
      category_id: product.category_id || null
    }
  }

  setErrors(errors) {
    const newErrors = {}

    errors.forEach(error => {
      const fieldName = error.source.pointer.replace('/data/attributes/', '')
      newErrors[fieldName] = error.detail
    })

    this.setState({ errors: newErrors })
  }

  handleInputChange = e => {
    this.handleFieldChange(e.target.name, e.target.value)
  }

  handleFieldChange = (name, value) => {
    this.setState(prevState => ({
      fields: { ...prevState.fields, [name]: value },
      errors: { ...prevState.errors, [name]: null }
    }))
  }

  renderFormGroup(props = { type: 'text' }) {
    const { label, name, inputComponent, ...inputProps } = props

    return (
      <div className="form__group">
        <label className="form__label">
          { label }
        </label>
        { inputComponent ? inputComponent : (
          <input
            className={classnames('form__input', {
              'is-invalid': this.state.errors[name]
            })}
            {...inputProps}
            name={name}
            onChange={this.handleInputChange}
            value={this.state.fields[name]}
          />
        ) }
        <span className="form__bar"/>
        { this.state.errors[name] && (
          <div className="invalid-feedback">
            { this.state.errors[name] }
          </div>
        ) }
      </div>
    )
  }

  render() {
    const { onSubmit, ...modalProps } = this.props

    const dropdownCategories = this.props.categories.map(option => (
      {
        value: option.id,
        label: option.name
      }
    ))

    return (
      <Modal popupModifier="form" {...modalProps}>
        <form
          className="form form--popup"
          onSubmit={e => {
            e.preventDefault()
            onSubmit(this.state.fields)
              .then(this.props.onHide)
              .catch(data => {
                this.setErrors(data.errors)
              })
          }}
        >
          { this.renderFormGroup({
            label: 'Title',
            placeholder: 'Title',
            name: 'title'
          }) }
          { this.renderFormGroup({
            label: 'Author',
            placeholder: 'Author',
            name: 'author'
          }) }
          { this.renderFormGroup({
            label: 'Url',
            placeholder: 'Url',
            name: 'url',
            type: 'url'
          }) }

          { this.props.forAdmin && this.renderFormGroup({
            label: 'Status',
            name: 'status',
            inputComponent: (
              <Dropdown
                options={DROPDOWN_STATUS}
                className={classnames('form__select', {
                  'is-invalid': this.state.errors['status']
                })}
                onChange={selectedOption => {
                  this.handleFieldChange('status', selectedOption.value)
                  this.setState({ selectedStatus: selectedOption })
                }}
                value={this.state.selectedStatus}
                placeholder="Select an option"/>
            )
          }) }

          { this.renderFormGroup({
            label: 'Category',
            name: 'category_id',
            inputComponent: (
              <Dropdown
                options={dropdownCategories}
                className={classnames('form__select', {
                  'is-invalid': this.state.errors['category_id']
                })}
                menuClassName='form__select-menu--short'
                onChange={selectedOption => {
                  this.handleFieldChange('category_id',
                    parseInt(selectedOption.value, 10) || null
                  )
                  this.setState({ selectedCategory: selectedOption })
                }}
                value={this.state.selectedCategory}
                placeholder="Select an option"
              />
            )
          }) }

          <button className="button button--dark button--narrow form__button"
                  type="submit">{ this.props.submitLabel }</button>
        </form>
      </Modal>
    )
  }
}

const mapStateToProps = state => ({
  values: state.categories.all
})

export default connect(mapStateToProps)(ProductForm)
