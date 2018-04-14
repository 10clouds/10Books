import React from 'react'
import PropTypes from 'prop-types'

const Search = props => {
  return (
    <div className="search-form__wrapper-input">
      <input
        className="search-form__input"
        type="text"
        placeholder="Type name, author or category"
        onChange={ props.onChange }
        defaultValue={ props.value }
      />
      <img src="images/search.svg" alt="Search icon" className="search-form__loupe"/>
    </div>
  )
}

Search.propTypes = {
  onChange: PropTypes.func.isRequired,
  value: PropTypes.string
}

export default Search
