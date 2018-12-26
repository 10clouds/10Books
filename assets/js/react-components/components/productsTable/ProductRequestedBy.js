import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'

export default class ProductRequestedBy extends PureComponent {
  static propTypes = {
    name: PropTypes.string.isRequired
  }

  render() {
    return (
      <div className="product-requested-by">
        <span className="product-requested-by__label">Requested by</span>{' '}
        <span className="product-requested-by__value">{this.props.name}</span>
      </div>
    )
  }
}
