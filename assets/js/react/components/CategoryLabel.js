import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'

export default class CategoryLabel extends PureComponent {
  static propTypes = {
    category: PropTypes.shape({
      name: PropTypes.string.isRequired,
      color: PropTypes.shape({
        text: PropTypes.string.isRequired,
        background: PropTypes.string.isRequired
      }).isRequired
    }).isRequired
  }

  render() {
    const { category } = this.props

    return (
      <div className="category-label">
        <div
          className="category-label__icon"
          style={{
            color: category.color.text,
            background: category.color.background
          }}
        >
          {category.name.charAt(0)}
        </div>
        <div className="category-label__text">
          {category.name}
        </div>
      </div>
    )
  }
}
