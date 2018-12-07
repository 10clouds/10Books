import React from 'react'
import PropTypes from 'prop-types'

const AlertOverlay = ({ children }) => (
  <div className="alert-overlay">{children}</div>
)

AlertOverlay.propTypes = {
  children: PropTypes.node.isRequired
}

export default AlertOverlay
