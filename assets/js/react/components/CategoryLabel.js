import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'

export default class CategoryLabel extends PureComponent {
  static propTypes = {
    category: PropTypes.shape({
      name: PropTypes.string.isRequired,
      text_color: PropTypes.string.isRequired,
      background_color: PropTypes.string.isRequired
    }).isRequired
  }

  render() {
    const { category } = this.props

    return (
      <div className="category-label">
        <div
          className="category-label__icon"
          style={{
            color: category.text_color,
            background: category.background_color
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
