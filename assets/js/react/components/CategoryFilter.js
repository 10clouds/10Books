import React from 'react'
import PropTypes from 'prop-types'
import Dropdown from 'react-dropdown'

const CategoryFilter = props => {
  const dropdownCategories = props.categories.map(option => (
    {
      value: option.id,
      label: option.name
    }
  ));

  return (
    <Dropdown
      className="search-form__dropdown"
      options={ dropdownCategories }
      onChange={ selectedOption => props.onChange(selectedOption) }
      value={ props.value }
      placeholder="Category"/>
  )
}

CategoryFilter.propTypes = {
  onChange: PropTypes.func,
  categories: PropTypes.array.isRequired,
  value: PropTypes.string
}

export default CategoryFilter
