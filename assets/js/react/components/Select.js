import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import ReactSelect, { defaultMenuRenderer, Option } from 'react-select'
import cn from 'classnames'

const valuePropType = PropTypes.oneOfType([
  PropTypes.string,
  PropTypes.number
])

class OptionComponent extends PureComponent {
  render() {
    return this.props.option.label
      ? <Option {...this.props} />
      : this.props.children
  }
}

export default class Select extends PureComponent {
  static propTypes = {
    value: valuePropType,
    onChange: PropTypes.func.isRequired,
    options: PropTypes.arrayOf(
      PropTypes.shape({
        value: valuePropType,
        label: PropTypes.string
      }).isRequired
    ).isRequired,
    renderOptions: PropTypes.func
  }

  renderMenu = options => (
    defaultMenuRenderer({
      ...options,
      optionComponent: OptionComponent
    })
  )

  renderOption = (option) => {
    const { optionRenderer } = this.props
    const value = optionRenderer ? optionRenderer(option) : option.label

    return option.label
      ? <div className="select__option" children={value} />
      : value
  }

  render() {
    const {
      value,
      onChange,
      options,
      className,
      ...reactSelectProps
    } = this.props

    return (
      <ReactSelect
        {...reactSelectProps}
        menuRenderer={this.renderMenu}
        optionRenderer={this.renderOption}
        className={cn('select', className)}
        clearable={false}
        searchable={false}
        value={value}
        onChange={onChange}
        options={options}
      />
    )
  }
}
