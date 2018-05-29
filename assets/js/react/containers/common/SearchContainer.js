import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import debounce from 'lodash.debounce'
import cn from 'classnames'
import * as searchActions from '~/store/actions/search'
import CategorySelect from '~/components/CategorySelect'

class SearchContainer extends Component {
  static propTypes = {
    action: PropTypes.shape({
      onClick: PropTypes.func.isRequired,
      children: PropTypes.object.isRequired
    })
  }

  handleSearchUpdate = debounce(e => {
    this.props.updateQuery('queryString', e.target.value)
  }, 50)

  handleDropdownChange = selectedOption => {
    this.props.updateQuery('filterByCategoryId', selectedOption.value)
  }

  renderActionBtn(actionProps) {
    const {children, className, ...otherProps} = actionProps

    return (
      <button
        {...otherProps}
        className={cn(
          'search__action-btn',
          'button button--dark button--narrow',
          className
        )}
      >
        <div className="search__action-btn-inner" children={children} />
      </button>
    )
  }

  render() {
    return (
      <div className="search">
        <input
          className="search__field search__field--query"
          type="text"
          placeholder="Type book name or author"
          onChange={e => {
            e.persist()
            this.handleSearchUpdate(e)
          }}
          defaultValue={this.props.queryString}
        />
        <CategorySelect
          className="search__field search__field--category"
          onChange={this.handleDropdownChange}
          value={this.props.filterByCategoryId}
          categories={this.props.categories}
        />
        {this.props.action && this.renderActionBtn(this.props.action)}
      </div>
    )
  }
}

const mapStateToProps = state => state.search
const mapDispatchToProps = dispatch => bindActionCreators(searchActions, dispatch)

export default connect(mapStateToProps, mapDispatchToProps)(SearchContainer)
