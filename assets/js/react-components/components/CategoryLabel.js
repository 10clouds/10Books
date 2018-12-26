import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'

export default class CategoryLabel extends PureComponent {
  static propTypes = {
    name: PropTypes.string.isRequired,
    text_color: PropTypes.string,
    background_color: PropTypes.string
  }

  render() {
    return (
      <div className="category-label">
        <div
          className="category-label__icon"
          style={{
            color: this.props.text_color,
            background: this.props.background_color
          }}
        >
          {this.props.name.charAt(0)}
        </div>
        <div className="category-label__text">{this.props.name}</div>
      </div>
    )
  }
}
