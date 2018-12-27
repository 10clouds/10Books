import React, { Component } from 'react'
import config from 'config'
import cacheStorage from 'lib/cacheStorage'
import MessageOverlay from '../components/MessageOverlay'

const CANCELED_TODAY_STORAGE_KEY = 'live-demo-message:canceled-today'
const ONE_DAY = 1000 * 60 * 60 * 24

export default class LiveDemoMessage extends Component {
  state = {
    isVisible: !cacheStorage.getItem(CANCELED_TODAY_STORAGE_KEY)
  }

  handleCancel = () => {
    cacheStorage.setItem(CANCELED_TODAY_STORAGE_KEY, true, ONE_DAY)
    this.setState({ isVisible: false })
  }

  render() {
    return this.state.isVisible ? (
      <MessageOverlay onCancel={this.handleCancel}>
        <h2>
          Welcome to{' '}
          <a href={config.get('repo.url')} target="_blank">
            10Books
          </a>{' '}
          live demo!
        </h2>
        All data is refreshed every hour
      </MessageOverlay>
    ) : (
      false
    )
  }
}
