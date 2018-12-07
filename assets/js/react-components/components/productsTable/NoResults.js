import React from 'react'

const NoResults = () => (
  <div className="no-results">
    <h1 className="no-results__heading">No matching results</h1>
    <p className="no-results__text">
      Check if you typed correctly or go to{' '}
      <a href="/" className="no-results__link">
        home page
      </a>
    </p>
  </div>
)

export default NoResults
