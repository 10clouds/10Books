import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import Select from '~/components/Select'
import CategoryLabel from '~/components/CategoryLabel'

export default class CategoryFilter extends PureComponent {
  static propTypes = {
    categories: PropTypes.array.isRequired,
    onChange: PropTypes.func.isRequired,
    value: PropTypes.number
  }

  renderOption = option => {
    const { text_color, background_color } = option.value
      ? this.props.categories.find(c => c.id === option.value)
      : { text_color: "#fff", background_color: "#000" } // TODO

    return (
      <CategoryLabel
        name={option.label}
        text_color={text_color}
        background_color={background_color}
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
