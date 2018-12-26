import React from 'react'
import PropTypes from 'prop-types'

const AlertOverlay = ({ children, onCancel }) => (
  <div className="message-overlay">
    <div className="container">
      <div className="message-overlay__content">
        {onCancel && (
          <button onClick={onCancel} className="message-overlay__cancel" />
        )}
        {children}
      </div>
    </div>
  </div>
)

AlertOverlay.propTypes = {
  children: PropTypes.node.isRequired,
  onCancel: PropTypes.func
}

export default AlertOverlay
