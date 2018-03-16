import React, { Component } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import debounce from 'lodash.debounce'
import * as searchActions from '../../store/actions/search'
import Search from '../../components/Search'

class SearchContainer extends Component {
  handleSearchUpdate = debounce((e) => {
    this.props.updateQuery(e.target.value)
  }, 50)

  render() {
    return (
      <Search
        onChange={(e) => {
          e.persist()
          this.handleSearchUpdate(e)
        }}
        value={this.props.queryString}
      />
    )
  }
}

const mapStateToProps = state => state.search
const mapDispatchToProps = (dispatch) => bindActionCreators(searchActions, dispatch)

export default connect(mapStateToProps, mapDispatchToProps)(SearchContainer)
