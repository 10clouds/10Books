import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'

export default class Raw extends PureComponent {
  static propTypes = {
    content: PropTypes.node.isRequired
  }

  render() {
    const { content, ...otherProps } = this.props

    return (
      <span {...otherProps} dangerouslySetInnerHTML={{ __html: content }} />
    )
  }
}
