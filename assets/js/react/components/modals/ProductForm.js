import React, { Fragment, PureComponent } from 'react'
import classnames from 'classnames'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import Modal from './Modal'
import { READABLE_PRODUCT_STATUS } from '~/constants'

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
      category_id: product.category_id || ''
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
    const { label, name, options, ...inputProps } = props
    const fieldProps = {
      className: classnames('form__input', {
        'form__input--invalid': this.state.errors[name]
      }),
      name,
      onChange: this.handleInputChange,
      value: this.state.fields[name],
      ...inputProps
    }

    return (
      <div className="form__group">
        <label className="form__label">
          { label }
        </label>
        {options ? (
          <div className="form__select-container">
            <select
              {...fieldProps}
              className={classnames(fieldProps.className, {
                'form__input--empty': !fieldProps.value
              })}
            >
              <option>{inputProps.placeholder}</option>
              {options.map(o => (
                <option key={o.value} value={o.value} children={o.text} />
              ))}
            </select>
            <span className="form__bar"/>
          </div>
        ) : (
          <Fragment>
            <input {...fieldProps} />
            <span className="form__bar"/>
          </Fragment>
        )}

        {this.state.errors[name] && (
          <div className="invalid-feedback">
            { this.state.errors[name] }
          </div>
        )}
      </div>
    )
  }

  render() {
    const { onSubmit, ...modalProps } = this.props

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
            placeholder: 'Select status',
            name: 'status',
            options: Object.keys(READABLE_PRODUCT_STATUS).map(key => ({
              value: key,
              text: READABLE_PRODUCT_STATUS[key]
            }))
          })}

          {this.renderFormGroup({
            label: 'Category',
            placeholder: 'Select category',
            name: 'category_id',
            options: this.props.categories.map(option => ({
              value: option.id,
              text: option.name
            }))
          })}
          <div className="form__buttons-wrapper">
            <button
              className="button button--dark form__button"
              type="submit"
            >
              { this.props.submitLabel }
            </button>
          </div>
        </form>
      </Modal>
    )
  }
}

const mapStateToProps = state => ({
  values: state.categories.all
})

export default connect(mapStateToProps)(ProductForm)
