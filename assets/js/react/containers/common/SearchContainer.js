import React, { Component } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import debounce from 'lodash.debounce'
import * as searchActions from '~/store/actions/search'
import Search from '~/components/Search'
import CategoryFilter from '~/components/CategoryFilter'
import classnames from 'classnames'

class SearchContainer extends Component {

  state = {
    dropdownCategoryPlaceholder: ''
  }

  handleSearchUpdate = debounce(e => {
    this.props.updateQuery(e.target.value)
  }, 50)

  handleDropdownChange = debounce(selectedOption => {
    if (selectedOption.value === 'all') {
      this.props.updateQuery('')
    } else {
      this.props.updateQuery(selectedOption.label)
    }
  }, 50)

  render() {
    return (
      <div className="search-form">
        <Search
          onChange={ e => {
            e.persist()
            this.handleSearchUpdate(e)
          } }
          value={ this.props.queryString }
        />
        <CategoryFilter
          classNames={classnames( 'search-form__dropdown', {
            'search-form__dropdown--selected': this.state.dropdownCategoryPlaceholder
          })}
          onChange={ selectedOption => {
            this.handleDropdownChange(selectedOption)
            this.setState({ dropdownCategoryPlaceholder: selectedOption.label })
          } }
          value={ this.state.dropdownCategoryPlaceholder }
          categories={ this.props.categories }
        />
      </div>
    )
  }
}

const mapStateToProps = state => state.search
const mapDispatchToProps = dispatch => bindActionCreators(searchActions, dispatch)

export default connect(mapStateToProps, mapDispatchToProps)(SearchContainer)
