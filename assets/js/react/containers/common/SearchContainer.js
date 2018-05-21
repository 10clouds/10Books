import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import debounce from 'lodash.debounce'
import * as searchActions from '~/store/actions/search'
import Search from '~/components/Search'
import CategoryFilter from '~/components/CategoryFilter'

class SearchContainer extends Component {
  static propTypes = {
    actions: PropTypes.node
  }

  handleSearchUpdate = debounce(e => {
    this.props.updateQuery('queryString', e.target.value)
  }, 50)

  handleDropdownChange = selectedOption => {
    this.props.updateQuery('filterByCategoryId', selectedOption.value)
  }

  render() {
    return (
      <div className="search-form">
        <Search
          onChange={e => {
            e.persist()
            this.handleSearchUpdate(e)
          }}
          value={this.props.queryString}
        />
        <CategoryFilter
          onChange={this.handleDropdownChange}
          value={this.props.filterByCategoryId}
          categories={this.props.categories}
        />
        {this.props.actions}
      </div>
    )
  }
}

const mapStateToProps = state => state.search
const mapDispatchToProps = dispatch => bindActionCreators(searchActions, dispatch)

export default connect(mapStateToProps, mapDispatchToProps)(SearchContainer)
