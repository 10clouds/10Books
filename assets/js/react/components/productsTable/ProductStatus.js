import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import Select from '~/components/Select'
import { READABLE_PRODUCT_STATUS } from '~/constants'

const selectStatuses = Object
  .keys(READABLE_PRODUCT_STATUS)
  .filter(key => key !== 'DELETED')
  .map(key => ({
    value: key, label: READABLE_PRODUCT_STATUS[key]
  }))

const ACTION_EDIT = 'ACTION_EDIT'
const ACTION_DELETE = 'ACTION_DELETE'

export default class ProductActions extends PureComponent {
  static propTypes = {
    status: PropTypes.string.isRequired,
    canChangeStatus: PropTypes.bool,
    onStatusChange: PropTypes.func,
    canEdit: PropTypes.bool,
    onEdit: PropTypes.func,
    canDelete: PropTypes.bool
  }

  state = {
    isActive: false
  }

  setActive = () => {
    this.setState({ isActive: true })
  }

  setInactive = () => {
    this.setState({ isActive: false })
  }

  handleChange = option => {
    const {
      onStatusChange,
      onEdit
    } = this.props

    if (option.divider) {
      return
    } else if (option.value === ACTION_EDIT) {
      if (onEdit) onEdit()
    } else if (option.value === ACTION_DELETE) {
      if (onStatusChange && confirm('Are you sure?')) onStatusChange('DELETED')
    } else {
      if (onStatusChange) onStatusChange(option.value)
    }
  }

  getBtnColor = () => {
    switch (this.props.status) {
      case 'DELETED':
        return 'red'
      case 'ORDERED':
        return 'green'
      default:
        return 'bright'
    }
  }

  renderValue = () => {
    const color = this.getBtnColor()

    return (
      <div
        className={cn('product-status__label table-action-btn button', {
         [`button--${color}`]: true,
         [`button--${color}-active`]: this.state.isActive,
       })}
      >
        {READABLE_PRODUCT_STATUS[this.props.status]}
      </div>
    )
  }

  renderOption = option => {
    return option.divider
      ? <div className="product-status__option-divider" />
      : option.label
  }

  render() {
    const {
      canChangeStatus,
      canEdit,
      canDelete,
      status
    } = this.props
    const isDisabled = !canChangeStatus && !canEdit && !canDelete
    const btnColor = this.getBtnColor()

    let options = []
    if (canChangeStatus) options = options.concat(selectStatuses)
    if (canChangeStatus && (canEdit || canDelete)) options.push({ divider: true })
    if (canEdit) options.push({ value: 'ACTION_EDIT', label: 'Edit' })
    if (canDelete) options.push({ value: 'ACTION_DELETE', label: 'Delete' })

    return (
      <Select
        className={cn('product-status', {
          [`product-status--${btnColor}`]: true
        })}
        value={status}
        disabled={isDisabled}
        onChange={this.handleChange}
        optionRenderer={this.renderOption}
        options={options}
        placeholder={this.renderValue()}
        valueRenderer={this.renderValue}
        onOpen={this.setActive}
        onClose={this.setInactive}
      />
    )
  }
}
