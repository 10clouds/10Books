import React from 'react'
import PropTypes from 'prop-types'

const Search = props => (
  <div className="search-form">
    <input
      className="search-form__input"
      type="text"
      placeholder="Type name, author or category"
      onChange={props.onChange}
      defaultValue={props.value}
    />
    <i className="fa fa-search search-form__loupe" aria-hidden="true" />
  </div>
)

Search.propTypes = {
  onChange: PropTypes.func.isRequired,
  value: PropTypes.string
}

export default Search
