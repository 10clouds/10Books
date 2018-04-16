import React from 'react'
import PropTypes from 'prop-types'
import Dropdown from 'react-dropdown'

const CategoryFilter = props => {
  const categories = props.categories.map(option => (
    {
      value: option.id,
      label: option.name
    }
  ));

  const dropdownCategories = [{
    value: 'all',
    label: 'All categories',
  }, ...categories]

  return (
    <Dropdown
      className={ props.classNames }
      options={ dropdownCategories }
      onChange={ selectedOption => props.onChange(selectedOption) }
      value={ props.value }
      placeholder="Category"/>
  )
}

CategoryFilter.propTypes = {
  onChange: PropTypes.func,
  categories: PropTypes.array.isRequired,
  value: PropTypes.string,
  classNames: PropTypes.string
}

export default CategoryFilter
