import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import Select from '~/components/Select'
import CategoryLabel from '~/components/CategoryLabel'

export default class CategorySelect extends PureComponent {
  static propTypes = {
    categories: PropTypes.array.isRequired,
    onChange: PropTypes.func.isRequired,
    value: PropTypes.number,
    className: PropTypes.string
  }

  renderOption = option => {
    const colorProps = option.value
      ? this.props.categories.find(c => c.id === option.value)
      : null

    return (
      <CategoryLabel
        name={option.label}
        {...colorProps}
      />
    )
  }

  render() {
    const options = [
      {
        value: null,
        label: 'All Categories',
      },
      ...this.props.categories.map(option => ({
        value: option.id,
        label: option.name
      }))
    ]

    return (
      <Select
        className={this.props.className}
        value={this.props.value}
        onChange={this.props.onChange}
        options={options}
        optionRenderer={this.renderOption}
        placeholder={this.renderOption(options[0])}
        valueRenderer={this.renderOption}
      />
    )
  }
}
