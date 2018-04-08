import React, { PureComponent } from 'react'
import classnames from 'classnames'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import Modal from './Modal'

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
            className={ classnames('form__input', {
              'is-invalid': this.state.errors[name]
            }) }
            { ...inputProps }
            name={ name }
            onChange={ this.handleInputChange }
            value={ this.state.fields[name] }
          />
        ) }
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

    return (
      this.props.show ? (
        <Modal popupModifier="form" { ...modalProps }>
          <form
            className="form form--popup"
            onSubmit={ e => {
              e.preventDefault()
              onSubmit(this.state.fields)
                .then(this.props.onHide)
                .catch(data => {
                  this.setErrors(data.errors)
                })
            } }
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
                <select
                  name="status"
                  className={ classnames('form__select', {
                    'is-invalid': this.state.errors['status']
                  }) }
                  onChange={ this.handleInputChange }
                  value={ this.state.fields.status }
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
            }) }

            { this.renderFormGroup({
              label: 'Category',
              name: 'category_id',
              inputComponent: (
                <select
                  className={ classnames('form-control', {
                    'is-invalid': this.state.errors['category_id']
                  }) }
                  value={ this.state.fields.category_id || '' }
                  onChange={ e => {
                    this.handleFieldChange('category_id',
                      parseInt(e.target.value, 10) || null
                    )
                  } }
                >
                  <option value="">--select category--</option>
                  { this.props.categories.map(option => (
                    <option
                      key={ option.id }
                      value={ option.id }
                    >
                      { option.name }
                    </option>
                  )) }
                </select>
              )
            }) }
            <button className="button button--dark button--narrow form__button" type="submit">{ this.props.submitLabel }</button>
          </form>
        </Modal>
      ) : null
    )
  }
}

const mapStateToProps = state => ({
  values: state.categories.all
})

export default connect(mapStateToProps)(ProductForm)
